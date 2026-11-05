import 'package:akashic/layers/functional/Steam/domain/entities/steam_game_stats.dart';
import 'package:akashic/layers/functional/Steam/domain/entities/steam_wish_watch.dart';
import 'package:akashic/layers/functional/Steam/domain/gateways/steam_watch_store.dart';
import 'package:akashic/layers/technical/LocalDatabase/akashic_database.dart';
import 'package:drift/drift.dart';

class DriftSteamWatchStore implements SteamWatchStore {
  DriftSteamWatchStore(this._database);

  final AkashicDatabase _database;

  SteamWishWatch _watchOf(SteamWatchRow row) => SteamWishWatch(
        appId: row.appId,
        price: switch ((row.priceCents, row.priceCurrency)) {
          (final cents?, final currency?) => StorePrice(cents: cents, currency: currency, initialCents: row.initialPriceCents, discountPercent: row.discountPercent),
          _ => null,
        },
        isComingSoon: row.isComingSoon,
        checkedAt: row.checkedAt,
      );

  @override
  Future<Map<String, SteamWishWatch>> wishWatches() async => {for (final row in await _database.select(_database.steamWatches).get()) row.appId: _watchOf(row)};

  @override
  Stream<Map<String, SteamWishWatch>> watchWishWatches() =>
      _database.select(_database.steamWatches).watch().map((rows) => {for (final row in rows) row.appId: _watchOf(row)});

  @override
  Future<void> saveWishWatches(Iterable<SteamWishWatch> watches) => _database.batch((batch) => batch.insertAllOnConflictUpdate(_database.steamWatches, [
        for (final watch in watches)
          SteamWatchesCompanion.insert(
            appId: watch.appId,
            priceCents: Value(watch.price?.cents),
            initialPriceCents: Value(watch.price?.initialCents),
            discountPercent: Value(watch.price?.discountPercent ?? 0),
            priceCurrency: Value(watch.price?.currency),
            isComingSoon: Value(watch.isComingSoon),
            checkedAt: watch.checkedAt,
          ),
      ]));

  @override
  Future<KnownSteamDlcs?> knownDlcsOf(String appId) async {
    final row = await (_database.select(_database.steamKnownDlcs)..where((table) => table.appId.equals(appId))).getSingleOrNull();
    return row == null ? null : KnownSteamDlcs(appId: row.appId, dlcIds: row.dlcIds.split(',').where((dlcId) => dlcId.isNotEmpty).toSet(), checkedAt: row.checkedAt);
  }

  @override
  Future<void> saveKnownDlcs(KnownSteamDlcs known) => _database.into(_database.steamKnownDlcs).insertOnConflictUpdate(
        SteamKnownDlcsCompanion.insert(appId: known.appId, dlcIds: (known.dlcIds.toList()..sort()).join(','), checkedAt: known.checkedAt),
      );
}
