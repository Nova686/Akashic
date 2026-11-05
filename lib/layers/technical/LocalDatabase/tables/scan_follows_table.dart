import 'package:akashic/layers/technical/LocalDatabase/tables/series_table.dart';
import 'package:drift/drift.dart';

@DataClassName('ScanFollowRow')
class ScanFollows extends Table {
  TextColumn get seriesId => text().references(SeriesTable, #id, onDelete: KeyAction.cascade)();
  TextColumn get siteUrl => text().nullable()();
  TextColumn get teamName => text().nullable()();
  TextColumn get mangaUpdatesSeriesId => text().nullable()();
  BoolColumn get alertsEnabled => boolean().withDefault(const Constant(false))();
  BoolColumn get onlyFollowedTeam => boolean().withDefault(const Constant(false))();
  DateTimeColumn get lastCheckedAt => dateTime().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {seriesId};
}
