import 'dart:convert';
import 'dart:io';

import 'package:akashic/layers/functional/Catalog/domain/entities/category_type.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/collection_item.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/item_progress.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/localized_titles.dart';
import 'package:akashic/layers/functional/Steam/data/gateways/drift_steam_stats_gateway.dart';
import 'package:akashic/layers/functional/Steam/data/sources/steam_player_client.dart';
import 'package:akashic/layers/functional/Steam/domain/entities/steam_achievement.dart';
import 'package:akashic/layers/functional/Steam/domain/entities/steam_game_stats.dart';
import 'package:akashic/layers/functional/Steam/domain/gateways/steam_player_api.dart';
import 'package:akashic/layers/functional/Steam/domain/use_cases/compute_steam_collection_stats.dart';
import 'package:akashic/layers/functional/Steam/domain/use_cases/refresh_steam_stats.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

import '../Collection/collection_harness.dart';

http.Response jsonResponse(Object body) => http.Response.bytes(utf8.encode(jsonEncode(body)), 200, headers: {'content-type': 'application/json; charset=utf-8'});

class ScriptedSteam implements SteamPlayerApi {
  ScriptedSteam(this.games, {this.progressByApp = const {}, this.isPrivate = false, this.wishlistItems = const []});

  final List<SteamWishlistItem> wishlistItems;

  List<SteamOwnedGame> games;
  final Map<String, AchievementProgress> progressByApp;
  final bool isPrivate;
  final List<String> achievementCalls = [];
  final List<String> deckCalls = [];

  @override
  bool get isConfigured => true;

  @override
  Future<List<SteamOwnedGame>> ownedGames(String steamId) async => games;

  @override
  Future<AchievementProgress?> achievementProgress(String steamId, String appId) async {
    achievementCalls.add(appId);
    if (isPrivate) {
      throw const SteamProfilePrivate();
    }
    return progressByApp[appId];
  }

  @override
  Future<SteamDeckStatus> deckStatus(String appId) async {
    deckCalls.add(appId);
    return SteamDeckStatus.verified;
  }

  @override
  Future<List<SteamAchievement>> achievements(String steamId, String appId) async => const [];

  final List<List<String>> priceCalls = [];

  @override
  Future<List<SteamWishlistItem>> wishlist(String steamId) async => wishlistItems;

  @override
  Future<Map<String, StorePrice?>> storePrices(List<String> appIds) async {
    priceCalls.add(appIds);
    return {for (final appId in appIds) appId: appId == '70' ? null : const StorePrice(cents: 2450, currency: 'EUR')};
  }
}

void main() {
  test('the steam client reads playtime, achievements, private profiles and the steam deck report', () async {
    final client = SteamPlayerClient(
      MockClient((request) async {
        expect(request.url.queryParameters['key'], 'key');
        return switch (request.url.path) {
          '/IPlayerService/GetOwnedGames/v1/' => jsonResponse({
              'response': {
                'games': [
                  {'appid': 1145360, 'name': 'Hades', 'playtime_forever': 7620, 'playtime_2weeks': 95, 'rtime_last_played': 1761800000},
                  {'appid': 70, 'name': 'Half-Life', 'playtime_forever': 0, 'rtime_last_played': 0},
                ],
              },
            }),
          '/ISteamUserStats/GetPlayerAchievements/v1/' => jsonResponse(request.url.queryParameters['appid'] == '1145360'
              ? {
                  'playerstats': {
                    'success': true,
                    'achievements': [
                      {'apiname': 'A', 'achieved': 1, 'unlocktime': 1700000000},
                      {'apiname': 'B', 'achieved': 0, 'unlocktime': 0},
                      {'apiname': 'C', 'achieved': 1, 'unlocktime': 1700000100},
                    ],
                  },
                }
              : {
                  'playerstats': {'error': 'Requested app has no stats', 'success': false},
                }),
          _ => http.Response('', 404),
        };
      }),
      MockClient((request) async {
        expect(request.url.path, '/saleaction/ajaxgetdeckappcompatibilityreport');
        return http.Response.bytes(File('test/fixtures/steam_deck_report.json').readAsBytesSync(), 200, headers: {'content-type': 'application/json'});
      }),
      apiKey: 'key',
    );
    final games = await client.ownedGames('7656');
    expect(games.first, SteamOwnedGame(appId: '1145360', name: 'Hades', playtimeMinutes: 7620, recentMinutes: 95, lastPlayedAt: DateTime.fromMillisecondsSinceEpoch(1761800000000, isUtc: true)));
    expect(games.last.lastPlayedAt, isNull);
    expect(await client.achievementProgress('7656', '1145360'), const AchievementProgress(unlocked: 2, total: 3));
    expect(await client.achievementProgress('7656', '70'), const AchievementProgress(unlocked: 0, total: 0));
    expect(await client.deckStatus('1145360'), SteamDeckStatus.verified);
    final private = SteamPlayerClient(
      MockClient((request) async => jsonResponse({
            'playerstats': {'error': 'Profile is not public', 'success': false},
          })),
      MockClient((request) async => http.Response('', 404)),
      apiKey: 'key',
    );
    expect(private.achievementProgress('7656', '1145360'), throwsA(isA<SteamProfilePrivate>()));
  });

  group('refreshing steam stats', () {
    late CollectionHarness harness;
    late DriftSteamStatsGateway stats;
    late String gamesId;
    var clock = DateTime.utc(2026, 10, 30, 12);

    setUp(() async {
      harness = CollectionHarness();
      stats = DriftSteamStatsGateway(harness.database);
      clock = DateTime.utc(2026, 10, 30, 12);
      gamesId = (await harness.createCategory(name: 'Jeux', colorValue: 0, type: CategoryType.videoGames, conditionParts: const ['Jeu'])).id;
      for (final (id, appId) in [('hades', '1145360'), ('celeste', '504230'), ('halflife', '70')]) {
        await harness.collection.saveItem(CollectionItem(id: id, categoryId: gamesId, titles: LocalizedTitles(byLanguage: {'en': id}), sourceKey: 'steam', externalWorkId: appId));
      }
    });

    tearDown(() => harness.database.close());

    RefreshSteamStats refresh(ScriptedSteam steam) => RefreshSteamStats(steam, stats, harness.collection, now: () => clock);

    test('stats are stored per game, recent play marks it in progress and full achievements mark it finished', () async {
      final steam = ScriptedSteam([
        SteamOwnedGame(appId: '1145360', name: 'Hades', playtimeMinutes: 7620, recentMinutes: 95, lastPlayedAt: clock),
        SteamOwnedGame(appId: '504230', name: 'Celeste', playtimeMinutes: 600, recentMinutes: 0, lastPlayedAt: clock.subtract(const Duration(days: 300))),
        const SteamOwnedGame(appId: '70', name: 'Half-Life', playtimeMinutes: 0, recentMinutes: 0),
        const SteamOwnedGame(appId: '999', name: 'Not in collection', playtimeMinutes: 10, recentMinutes: 0),
      ], progressByApp: {'1145360': const AchievementProgress(unlocked: 34, total: 49), '504230': const AchievementProgress(unlocked: 31, total: 31)});
      expect(await refresh(steam)('7656'), 3);
      final byItem = {for (final game in await stats.watchAll().first) game.itemId: game};
      expect(byItem['hades']!.achievements, const AchievementProgress(unlocked: 34, total: 49));
      expect(byItem['hades']!.deckStatus, SteamDeckStatus.verified);
      expect(byItem['halflife']!.wasNeverPlayed, isTrue);
      expect(steam.achievementCalls, unorderedEquals(['1145360', '504230']));
      Future<ProgressStatus?> statusOf(String itemId) async => (await harness.collection.watchItem(itemId).first)?.progress?.status;
      expect(await statusOf('hades'), ProgressStatus.inProgress);
      expect(await statusOf('celeste'), ProgressStatus.finished);
      expect(await statusOf('halflife'), isNull);
    });

    test('a status set by hand is never overwritten, and unchanged games are not asked again', () async {
      await harness.collection.saveProgress('hades', const ItemProgress(status: ProgressStatus.abandoned));
      final steam = ScriptedSteam([SteamOwnedGame(appId: '1145360', name: 'Hades', playtimeMinutes: 7620, recentMinutes: 95, lastPlayedAt: clock)], progressByApp: {'1145360': const AchievementProgress(unlocked: 49, total: 49)});
      await refresh(steam)('7656');
      expect((await harness.collection.watchItem('hades').first)?.progress?.status, ProgressStatus.abandoned);
      clock = clock.add(const Duration(hours: 7));
      await refresh(steam)('7656');
      expect(steam.achievementCalls, ['1145360']);
      expect(steam.deckCalls, ['1145360']);
      steam.games = [SteamOwnedGame(appId: '1145360', name: 'Hades', playtimeMinutes: 7700, recentMinutes: 175, lastPlayedAt: clock)];
      clock = clock.add(const Duration(hours: 1));
      await refresh(steam)('7656');
      expect(steam.achievementCalls, ['1145360', '1145360']);
    });

    test('store prices are fetched in one batch and kept a day, then the collection stats add them up', () async {
      final steam = ScriptedSteam([
        SteamOwnedGame(appId: '1145360', name: 'Hades', playtimeMinutes: 7620, recentMinutes: 0, lastPlayedAt: clock),
        SteamOwnedGame(appId: '504230', name: 'Celeste', playtimeMinutes: 600, recentMinutes: 0, lastPlayedAt: clock),
        const SteamOwnedGame(appId: '70', name: 'Half-Life', playtimeMinutes: 0, recentMinutes: 0),
      ], progressByApp: {'1145360': const AchievementProgress(unlocked: 34, total: 49), '504230': const AchievementProgress(unlocked: 31, total: 31)});
      await refresh(steam)('7656');
      expect(steam.priceCalls, hasLength(1));
      expect(steam.priceCalls.single, unorderedEquals(['1145360', '504230', '70']));
      clock = clock.add(const Duration(hours: 7));
      await refresh(steam)('7656');
      expect(steam.priceCalls, hasLength(1));
      final collection = await ComputeSteamCollectionStats(stats, harness.collection)().first;
      expect(collection.gameCount, 3);
      expect(collection.totalMinutes, 8220);
      expect(collection.neverPlayed.map((item) => item.id), ['halflife']);
      expect(collection.topPlayed.map((game) => (game.item.id, game.minutes)), [('hades', 7620), ('celeste', 600)]);
      expect(collection.averageCompletion, closeTo((34 / 49 + 1) / 2, 0.0001));
      expect(collection.libraryValue, {'EUR': 4900});
    });

    test('a private profile stops asking for achievements but keeps the playtime', () async {
      final steam = ScriptedSteam([
        SteamOwnedGame(appId: '1145360', name: 'Hades', playtimeMinutes: 7620, recentMinutes: 0, lastPlayedAt: clock),
        SteamOwnedGame(appId: '504230', name: 'Celeste', playtimeMinutes: 600, recentMinutes: 0, lastPlayedAt: clock),
      ], isPrivate: true);
      await refresh(steam)('7656');
      expect(steam.achievementCalls, hasLength(1));
      expect((await stats.watch('hades').first)?.playtimeMinutes, 7620);
    });
  });
}
