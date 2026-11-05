import 'package:akashic/layers/functional/SealedPrices/domain/entities/price_alert.dart';
import 'package:akashic/layers/functional/SealedPrices/domain/gateways/price_alert_store.dart';
import 'package:akashic/layers/technical/LocalDatabase/akashic_database.dart';
import 'package:drift/drift.dart';

class DriftPriceAlertStore implements PriceAlertStore {
  DriftPriceAlertStore(this._database);

  final AkashicDatabase _database;

  PriceAlert _alertOf(PriceAlertRow row) => PriceAlert(itemId: row.itemId, thresholdCents: row.thresholdCents, isAbove: row.isAbove, notifiedAt: row.notifiedAt);

  @override
  Stream<PriceAlert?> watch(String itemId) =>
      (_database.select(_database.priceAlerts)..where((table) => table.itemId.equals(itemId))).watchSingleOrNull().map((row) => row == null ? null : _alertOf(row));

  @override
  Future<List<PriceAlert>> all() async => [for (final row in await _database.select(_database.priceAlerts).get()) _alertOf(row)];

  @override
  Future<void> save(PriceAlert alert) => _database.into(_database.priceAlerts).insertOnConflictUpdate(
        PriceAlertsCompanion.insert(itemId: alert.itemId, thresholdCents: alert.thresholdCents, isAbove: alert.isAbove, notifiedAt: Value(alert.notifiedAt)),
      );

  @override
  Future<void> remove(String itemId) => (_database.delete(_database.priceAlerts)..where((table) => table.itemId.equals(itemId))).go();
}
