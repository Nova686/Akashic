import 'package:akashic/layers/technical/LocalDatabase/tables/series_table.dart';
import 'package:drift/drift.dart';

@DataClassName('SeriesTitleRow')
class SeriesTitles extends Table {
  TextColumn get seriesId => text().references(SeriesTable, #id, onDelete: KeyAction.cascade)();
  TextColumn get languageCode => text()();
  TextColumn get title => text()();

  @override
  Set<Column> get primaryKey => {seriesId, languageCode};
}
