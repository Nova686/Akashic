import 'package:drift/drift.dart';

@DataClassName('SealedPriceRow')
class SealedPrices extends Table {
  TextColumn get productId => text()();
  IntColumn get lowCents => integer().nullable()();
  IntColumn get averageCents => integer().nullable()();
  IntColumn get trendCents => integer().nullable()();
  IntColumn get average1Cents => integer().nullable()();
  IntColumn get average7Cents => integer().nullable()();
  IntColumn get average30Cents => integer().nullable()();
  DateTimeColumn get pricedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {productId};
}
