import 'package:akashic/layers/functional/SealedPrices/domain/entities/sealed_price.dart';
import 'package:akashic/layers/functional/SealedPrices/domain/gateways/sealed_price_store.dart';
import 'package:akashic/layers/technical/LocalDatabase/akashic_database.dart';
import 'package:drift/drift.dart';

class DriftSealedPriceStore implements SealedPriceStore {
  DriftSealedPriceStore(this._database);

  final AkashicDatabase _database;

  @override
  Future<void> savePrices(List<SealedPrice> prices) => _database.batch((batch) => batch.insertAllOnConflictUpdate(_database.sealedPrices, [
        for (final price in prices)
          SealedPricesCompanion.insert(
            productId: price.productId,
            lowCents: Value(price.lowCents),
            averageCents: Value(price.averageCents),
            trendCents: Value(price.trendCents),
            average1Cents: Value(price.average1Cents),
            average7Cents: Value(price.average7Cents),
            average30Cents: Value(price.average30Cents),
            pricedAt: price.pricedAt,
          ),
      ]));

  @override
  Stream<SealedPrice?> watchPrice(String productId) => (_database.select(_database.sealedPrices)..where((table) => table.productId.equals(productId))).watchSingleOrNull().map((row) => row == null
      ? null
      : SealedPrice(
          productId: row.productId,
          pricedAt: row.pricedAt,
          lowCents: row.lowCents,
          averageCents: row.averageCents,
          trendCents: row.trendCents,
          average1Cents: row.average1Cents,
          average7Cents: row.average7Cents,
          average30Cents: row.average30Cents,
        ));

  @override
  Future<DateTime?> lastPricedAt() {
    final latest = _database.sealedPrices.pricedAt.max();
    return (_database.selectOnly(_database.sealedPrices)..addColumns([latest])).map((row) => row.read(latest)).getSingle();
  }
}
