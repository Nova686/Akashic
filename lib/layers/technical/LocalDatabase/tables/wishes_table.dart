import 'package:akashic/layers/technical/LocalDatabase/tables/categories_table.dart';
import 'package:akashic/layers/technical/LocalDatabase/tables/series_table.dart';
import 'package:drift/drift.dart';

@DataClassName('WishRow')
class Wishes extends Table {
  TextColumn get id => text()();
  TextColumn get categoryType => text()();
  TextColumn get categoryId => text().nullable().references(Categories, #id, onDelete: KeyAction.setNull)();
  TextColumn get title => text()();
  TextColumn get creator => text().nullable()();
  TextColumn get imageUrl => text().nullable()();
  TextColumn get sourceKey => text().nullable()();
  TextColumn get externalWorkId => text().nullable()();
  TextColumn get barcode => text().nullable()();
  TextColumn get seriesId => text().nullable().references(SeriesTable, #id, onDelete: KeyAction.cascade)();
  IntColumn get volumeNumber => integer().nullable()();
  TextColumn get origin => text()();
  TextColumn get priority => text().nullable()();
  IntColumn get maxPriceCents => integer().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}
