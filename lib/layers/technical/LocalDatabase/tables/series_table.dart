import 'package:akashic/layers/technical/LocalDatabase/tables/categories_table.dart';
import 'package:drift/drift.dart';

@DataClassName('SeriesRow')
class SeriesTable extends Table {
  @override
  String get tableName => 'series';

  TextColumn get id => text()();
  TextColumn get categoryId => text().references(Categories, #id)();
  TextColumn get originalLanguage => text().nullable()();
  TextColumn get creator => text().nullable()();
  IntColumn get publishedVolumes => integer().nullable()();
  TextColumn get sourceKey => text().nullable()();
  TextColumn get externalWorkId => text().nullable()();
  TextColumn get status => text().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}
