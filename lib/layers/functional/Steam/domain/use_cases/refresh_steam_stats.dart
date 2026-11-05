import 'package:akashic/layers/functional/Collection/domain/entities/collection_item.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/item_progress.dart';
import 'package:akashic/layers/functional/Collection/domain/gateways/collection_gateway.dart';
import 'package:akashic/layers/functional/Lookup/domain/entities/source_unavailable.dart';
import 'package:akashic/layers/functional/Steam/domain/entities/steam_game_stats.dart';
import 'package:akashic/layers/functional/Steam/domain/gateways/steam_player_api.dart';
import 'package:akashic/layers/functional/Steam/domain/gateways/steam_stats_gateway.dart';

ProgressStatus? automaticStatusOf({required int recentMinutes, AchievementProgress? achievements}) {
  if (achievements?.isComplete ?? false) {
    return ProgressStatus.finished;
  }
  return recentMinutes > 0 ? ProgressStatus.inProgress : null;
}

class RefreshSteamStats {
  RefreshSteamStats(this._api, this._stats, this._collection, {DateTime Function()? now}) : _now = now ?? DateTime.now;

  static const String steamSourceKey = 'steam';
  static const int achievementChecksPerRun = 40;
  static const int deckChecksPerRun = 40;
  static const Duration deckStatusLifetime = Duration(days: 30);
  static const Duration priceLifetime = Duration(days: 1);
  static const int pricesPerRun = 200;

  final SteamPlayerApi _api;
  final SteamStatsGateway _stats;
  final CollectionGateway _collection;
  final DateTime Function() _now;

  Future<int> call(String steamId) async {
    if (!_api.isConfigured) {
      return 0;
    }
    final owned = await _api.ownedGames(steamId);
    final itemsByApp = {
      for (final item in await _collection.allItems())
        if (item.sourceKey == steamSourceKey && item.externalWorkId != null) item.externalWorkId!: item,
    };
    final previousByItem = {for (final stats in await _stats.watchAll().first) stats.itemId: stats};
    final now = _now();
    var achievementChecks = achievementChecksPerRun;
    var deckChecks = deckChecksPerRun;
    final refreshed = <SteamGameStats>[];
    for (final game in owned) {
      final item = itemsByApp[game.appId];
      if (item == null) {
        continue;
      }
      final previous = previousByItem[item.id];
      var achievements = previous?.achievements;
      var achievementsCheckedAt = previous?.achievementsCheckedAt;
      final playedSinceCheck = achievementsCheckedAt == null || (game.lastPlayedAt?.isAfter(achievementsCheckedAt) ?? false);
      if (achievementChecks > 0 && game.playtimeMinutes > 0 && playedSinceCheck) {
        achievementChecks--;
        try {
          achievements = await _api.achievementProgress(steamId, game.appId) ?? achievements;
          achievementsCheckedAt = now;
        } on SteamProfilePrivate {
          achievementChecks = 0;
        } on SourceUnavailable catch (failure) {
          if (failure.isRateLimited) {
            achievementChecks = 0;
          }
        }
      }
      var deckStatus = previous?.deckStatus;
      var deckCheckedAt = previous?.deckCheckedAt;
      if (deckChecks > 0 && (deckCheckedAt == null || now.difference(deckCheckedAt) > deckStatusLifetime)) {
        deckChecks--;
        try {
          deckStatus = await _api.deckStatus(game.appId);
          deckCheckedAt = now;
        } on SourceUnavailable catch (failure) {
          if (failure.isRateLimited) {
            deckChecks = 0;
          }
        }
      }
      refreshed.add(SteamGameStats(
        itemId: item.id,
        appId: game.appId,
        playtimeMinutes: game.playtimeMinutes,
        recentMinutes: game.recentMinutes,
        lastPlayedAt: game.lastPlayedAt,
        achievements: achievements,
        achievementsCheckedAt: achievementsCheckedAt,
        deckStatus: deckStatus,
        deckCheckedAt: deckCheckedAt,
        autoProgressStatus: await _applyAutomaticStatus(item, previous?.autoProgressStatus, automaticStatusOf(recentMinutes: game.recentMinutes, achievements: achievements)),
        storePrice: previous?.storePrice,
        pricedAt: previous?.pricedAt,
        syncedAt: now,
      ));
    }
    await _stats.saveAll(await _withFreshPrices(refreshed, now));
    return refreshed.length;
  }

  Future<List<SteamGameStats>> _withFreshPrices(List<SteamGameStats> games, DateTime now) async {
    final due = [
      for (final game in games)
        if (game.pricedAt == null || now.difference(game.pricedAt!) > priceLifetime) game.appId,
    ].take(pricesPerRun).toList();
    if (due.isEmpty) {
      return games;
    }
    final Map<String, StorePrice?> prices;
    try {
      prices = await _api.storePrices(due);
    } on SourceUnavailable {
      return games;
    }
    return [
      for (final game in games)
        if (prices.containsKey(game.appId))
          SteamGameStats(
            itemId: game.itemId,
            appId: game.appId,
            playtimeMinutes: game.playtimeMinutes,
            recentMinutes: game.recentMinutes,
            lastPlayedAt: game.lastPlayedAt,
            achievements: game.achievements,
            achievementsCheckedAt: game.achievementsCheckedAt,
            deckStatus: game.deckStatus,
            deckCheckedAt: game.deckCheckedAt,
            autoProgressStatus: game.autoProgressStatus,
            storePrice: prices[game.appId],
            pricedAt: now,
            syncedAt: game.syncedAt,
          )
        else
          game,
    ];
  }

  Future<String?> _applyAutomaticStatus(CollectionItem item, String? previousAutomatic, ProgressStatus? wanted) async {
    final current = item.progress?.status;
    final setByHand = current != null && current.name != previousAutomatic;
    if (setByHand) {
      return null;
    }
    if (wanted == null) {
      return previousAutomatic;
    }
    if (current != wanted) {
      await _collection.saveProgress(item.id, ItemProgress(status: wanted));
    }
    return wanted.name;
  }
}
