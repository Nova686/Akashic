import 'package:akashic/layers/technical/LocalDatabase/tables/categories_table.dart';
import 'package:akashic/layers/technical/LocalDatabase/tables/series_table.dart';
import 'package:drift/drift.dart';

@DataClassName('ItemRow')
class Items extends Table {
  TextColumn get id => text()();
  TextColumn get categoryId => text().references(Categories, #id)();
  TextColumn get seriesId => text().nullable().references(SeriesTable, #id)();
  IntColumn get volumeNumber => integer().nullable()();
  TextColumn get originalLanguage => text().nullable()();
  TextColumn get creator => text().nullable()();
  IntColumn get year => integer().nullable()();
  TextColumn get publisher => text().nullable()();
  TextColumn get imagePath => text().nullable()();
  IntColumn get spineColorValue => integer().nullable()();
  IntColumn get rating => integer().nullable()();
  TextColumn get groupKey => text().nullable()();
  TextColumn get sourceKey => text().nullable()();
  TextColumn get externalWorkId => text().nullable()();
  TextColumn get cardKind => text().nullable()();
  TextColumn get progressStatus => text().nullable()();
  TextColumn get progressChapter => text().nullable()();
  IntColumn get progressPage => integer().nullable()();
  IntColumn get marketValueCents => integer().nullable()();
  TextColumn get marketValueCurrency => text().nullable()();
  DateTimeColumn get marketValuedAt => dateTime().nullable()();
  DateTimeColumn get preorderDueOn => dateTime().nullable()();
  IntColumn get preorderDepositCents => integer().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}
