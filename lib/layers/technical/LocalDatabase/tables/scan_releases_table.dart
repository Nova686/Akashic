import 'package:akashic/layers/technical/LocalDatabase/tables/series_table.dart';
import 'package:drift/drift.dart';

@DataClassName('ScanReleaseRow')
class ScanReleases extends Table {
  TextColumn get seriesId => text().references(SeriesTable, #id, onDelete: KeyAction.cascade)();
  RealColumn get chapter => real()();
  TextColumn get teamName => text()();
  DateTimeColumn get releasedOn => dateTime().nullable()();
  BoolColumn get notified => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {seriesId, chapter, teamName};
}
