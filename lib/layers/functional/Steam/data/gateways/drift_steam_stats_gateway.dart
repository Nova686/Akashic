import 'package:akashic/layers/functional/Steam/domain/entities/steam_game_stats.dart';
import 'package:akashic/layers/functional/Steam/domain/gateways/steam_stats_gateway.dart';
import 'package:akashic/layers/technical/LocalDatabase/akashic_database.dart';
import 'package:drift/drift.dart';

class DriftSteamStatsGateway implements SteamStatsGateway {
  DriftSteamStatsGateway(this._database);

  final AkashicDatabase _database;

  @override
  Stream<SteamGameStats?> watch(String itemId) =>
      (_database.select(_database.steamGameStats)..where((table) => table.itemId.equals(itemId))).watchSingleOrNull().map((row) => row == null ? null : _toStats(row));

  @override
  Stream<List<SteamGameStats>> watchAll() => _database.select(_database.steamGameStats).watch().map((rows) => [for (final row in rows) _toStats(row)]);

  @override
  Future<void> saveAll(List<SteamGameStats> stats) async {
    if (stats.isEmpty) {
      return;
    }
    await _database.batch((batch) => batch.insertAllOnConflictUpdate(_database.steamGameStats, [
          for (final game in stats)
            SteamGameStatsCompanion.insert(
              itemId: game.itemId,
              appId: game.appId,
              playtimeMinutes: Value(game.playtimeMinutes),
              recentMinutes: Value(game.recentMinutes),
              lastPlayedAt: Value(game.lastPlayedAt),
              achievementsUnlocked: Value(game.achievements?.unlocked),
              achievementsTotal: Value(game.achievements?.total),
              achievementsCheckedAt: Value(game.achievementsCheckedAt),
              deckStatus: Value(game.deckStatus?.name),
              deckCheckedAt: Value(game.deckCheckedAt),
              autoProgressStatus: Value(game.autoProgressStatus),
              priceCents: Value(game.storePrice?.cents),
              priceCurrency: Value(game.storePrice?.currency),
              pricedAt: Value(game.pricedAt),
              syncedAt: game.syncedAt,
            ),
        ]));
  }

  SteamGameStats _toStats(SteamGameStatsRow row) => SteamGameStats(
        itemId: row.itemId,
        appId: row.appId,
        playtimeMinutes: row.playtimeMinutes,
        recentMinutes: row.recentMinutes,
        lastPlayedAt: row.lastPlayedAt,
        achievements: switch ((row.achievementsUnlocked, row.achievementsTotal)) {
          (final unlocked?, final total?) => AchievementProgress(unlocked: unlocked, total: total),
          _ => null,
        },
        achievementsCheckedAt: row.achievementsCheckedAt,
        deckStatus: SteamDeckStatus.values.asNameMap()[row.deckStatus],
        deckCheckedAt: row.deckCheckedAt,
        autoProgressStatus: row.autoProgressStatus,
        storePrice: switch ((row.priceCents, row.priceCurrency)) {
          (final cents?, final currency?) => StorePrice(cents: cents, currency: currency),
          _ => null,
        },
        pricedAt: row.pricedAt,
        syncedAt: row.syncedAt,
      );
}
