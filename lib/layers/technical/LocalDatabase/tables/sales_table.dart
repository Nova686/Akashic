import 'package:drift/drift.dart';

@DataClassName('SaleRow')
class Sales extends Table {
  TextColumn get id => text()();
  TextColumn get itemId => text()();
  TextColumn get categoryId => text().nullable()();
  TextColumn get titles => text()();
  TextColumn get originalLanguage => text().nullable()();
  TextColumn get edition => text().nullable()();
  BoolColumn get wasOpened => boolean().withDefault(const Constant(false))();
  IntColumn get purchasePriceCents => integer().nullable()();
  DateTimeColumn get purchasedOn => dateTime().nullable()();
  TextColumn get purchaseChannel => text().nullable()();
  IntColumn get salePriceCents => integer()();
  DateTimeColumn get soldOn => dateTime()();
  TextColumn get saleChannel => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}
