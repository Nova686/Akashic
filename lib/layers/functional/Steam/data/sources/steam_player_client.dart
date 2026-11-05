import 'dart:convert';
import 'dart:async';
import 'package:akashic/layers/functional/Lookup/data/sources/json_fields.dart';
import 'package:akashic/layers/functional/Lookup/data/sources/source_http.dart';
import 'package:akashic/layers/functional/Steam/domain/entities/steam_achievement.dart';
import 'package:akashic/layers/functional/Steam/domain/entities/steam_game_stats.dart';
import 'package:akashic/layers/functional/Steam/domain/gateways/steam_player_api.dart';
import 'package:akashic/layers/functional/Lookup/domain/entities/source_unavailable.dart';
import 'package:http/http.dart' as http;

class SteamPlayerClient implements SteamPlayerApi {
  SteamPlayerClient(this._apiClient, this._storeClient, {required this._apiKey});

  static const String sourceKey = 'steam';
  static const String storeSourceKey = 'steamstore';
  static const Map<int, SteamDeckStatus> _deckStatuses = {1: SteamDeckStatus.unsupported, 2: SteamDeckStatus.playable, 3: SteamDeckStatus.verified};

  final http.Client _apiClient;
  final http.Client _storeClient;
  final String _apiKey;

  @override
  bool get isConfigured => _apiKey.isNotEmpty;

  Future<Map<String, Object?>> _api(String path, Map<String, String> parameters) async =>
      mapOf(await sourceGetJson(_apiClient, Uri.https('api.steampowered.com', path, {'key': _apiKey, ...parameters}), sourceKey: sourceKey));

  @override
  Future<List<SteamWishlistItem>> wishlist(String steamId) async {
    final response = mapOf((await _api('/IWishlistService/GetWishlist/v1/', {'steamid': steamId}))['response']);
    return [
      for (final item in listOf(response['items']).map(mapOf))
        if (item['appid'] case final int appId)
          SteamWishlistItem(
            appId: '$appId',
            priority: item['priority'] is int ? item['priority']! as int : 0,
            addedAt: switch (item['date_added']) {
              final int seconds when seconds > 0 => DateTime.fromMillisecondsSinceEpoch(seconds * 1000, isUtc: true),
              _ => null,
            },
          ),
    ]..sort((first, second) => first.priority.compareTo(second.priority));
  }

  @override
  Future<List<SteamOwnedGame>> ownedGames(String steamId) async {
    final response = mapOf((await _api('/IPlayerService/GetOwnedGames/v1/', {'steamid': steamId, 'include_appinfo': 'true', 'include_played_free_games': 'true'}))['response']);
    if (!response.containsKey('games')) {
      throw const SteamProfilePrivate();
    }
    return [
      for (final game in listOf(response['games']).map(mapOf))
        if ((game['appid'], textOf(game['name'])) case (final int appId, final name?))
          SteamOwnedGame(
            appId: '$appId',
            name: name,
            playtimeMinutes: game['playtime_forever'] is int ? game['playtime_forever']! as int : 0,
            recentMinutes: game['playtime_2weeks'] is int ? game['playtime_2weeks']! as int : 0,
            lastPlayedAt: switch (game['rtime_last_played']) {
              final int seconds when seconds > 0 => DateTime.fromMillisecondsSinceEpoch(seconds * 1000, isUtc: true),
              _ => null,
            },
          ),
    ];
  }

  Future<Map<String, Object?>> _playerStats(String steamId, String appId) async {
    final uri = Uri.https('api.steampowered.com', '/ISteamUserStats/GetPlayerAchievements/v1/', {'key': _apiKey, 'steamid': steamId, 'appid': appId});
    final http.Response response;
    try {
      response = await _apiClient.get(uri).timeout(const Duration(seconds: 20));
    } on http.ClientException catch (failure) {
      throw SourceUnavailable(sourceKey, failure.message);
    } on TimeoutException {
      throw SourceUnavailable(sourceKey, 'timeout');
    }
    if (const {200, 400, 403}.contains(response.statusCode)) {
      try {
        return mapOf(mapOf(jsonDecode(utf8.decode(response.bodyBytes)))['playerstats']);
      } on FormatException {
        throw SourceUnavailable(sourceKey, 'HTTP ${response.statusCode}');
      }
    }
    throw SourceUnavailable(sourceKey, 'HTTP ${response.statusCode}', response.statusCode == 429);
  }

  @override
  Future<AchievementProgress?> achievementProgress(String steamId, String appId) async {
    final stats = await _playerStats(steamId, appId);
    if (stats['success'] != true) {
      if ((textOf(stats['error']) ?? '').toLowerCase().contains('not public')) {
        throw const SteamProfilePrivate();
      }
      return const AchievementProgress(unlocked: 0, total: 0);
    }
    final achievements = listOf(stats['achievements']).map(mapOf).toList();
    return AchievementProgress(unlocked: achievements.where((achievement) => achievement['achieved'] == 1).length, total: achievements.length);
  }

  @override
  Future<List<SteamAchievement>> achievements(String steamId, String appId) async {
    final playerStats = await _playerStats(steamId, appId);
    if (playerStats['success'] != true && (textOf(playerStats['error']) ?? '').toLowerCase().contains('not public')) {
      throw const SteamProfilePrivate();
    }
    final schema = await _api('/ISteamUserStats/GetSchemaForGame/v2/', {'appid': appId, 'l': 'french'});
    final global = await _api('/ISteamUserStats/GetGlobalAchievementPercentagesForApp/v0002/', {'gameid': appId});
    final unlockedAt = {
      for (final achieved in listOf(playerStats['achievements']).map(mapOf))
        if ((textOf(achieved['apiname']), achieved['achieved'], achieved['unlocktime']) case (final apiName?, 1, final int seconds))
          apiName: DateTime.fromMillisecondsSinceEpoch(seconds * 1000, isUtc: true),
    };
    final percentByName = {
      for (final entry in listOf(mapOf(global['achievementpercentages'])['achievements']).map(mapOf))
        ?textOf(entry['name']): ?double.tryParse('${entry['percent']}'),
    };
    return [
      for (final achievement in listOf(mapOf(mapOf(mapOf(schema['game'])['availableGameStats']))['achievements']).map(mapOf))
        if ((textOf(achievement['name']), textOf(achievement['displayName'])) case (final apiName?, final name?))
          SteamAchievement(
            apiName: apiName,
            name: name,
            description: textOf(achievement['description']),
            iconUrl: httpsUrl(achievement['icon']),
            lockedIconUrl: httpsUrl(achievement['icongray']),
            isHidden: achievement['hidden'] == 1,
            unlockedAt: unlockedAt[apiName],
            globalPercent: percentByName[apiName],
          ),
    ];
  }

  static const int pricesPerRequest = 50;

  @override
  Future<Map<String, StorePrice?>> storePrices(List<String> appIds) async {
    final prices = <String, StorePrice?>{};
    for (var start = 0; start < appIds.length; start += pricesPerRequest) {
      final batch = appIds.sublist(start, (start + pricesPerRequest).clamp(0, appIds.length));
      final json = mapOf(await sourceGetJson(_storeClient, Uri.https('store.steampowered.com', '/api/appdetails', {'appids': batch.join(','), 'cc': 'fr', 'filters': 'price_overview'}), sourceKey: storeSourceKey));
      for (final appId in batch) {
        final entry = mapOf(json[appId]);
        if (entry['success'] != true) {
          continue;
        }
        final price = mapOf(mapOf(entry['data'])['price_overview']);
        prices[appId] = switch ((price['final'], textOf(price['currency']))) {
          (final int cents, final currency?) => StorePrice(
              cents: cents,
              currency: currency,
              initialCents: price['initial'] is int ? price['initial']! as int : null,
              discountPercent: price['discount_percent'] is int ? price['discount_percent']! as int : 0,
            ),
          _ => null,
        };
      }
    }
    return prices;
  }

  @override
  Future<SteamDeckStatus> deckStatus(String appId) async {
    final report = mapOf(await sourceGetJson(_storeClient, Uri.https('store.steampowered.com', '/saleaction/ajaxgetdeckappcompatibilityreport', {'nAppID': appId}), sourceKey: storeSourceKey));
    return _deckStatuses[mapOf(report['results'])['resolved_category']] ?? SteamDeckStatus.unknown;
  }
}
