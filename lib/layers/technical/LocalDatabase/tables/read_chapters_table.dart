import 'package:akashic/layers/technical/LocalDatabase/tables/series_table.dart';
import 'package:drift/drift.dart';

@DataClassName('ReadChapterRow')
class ReadChapters extends Table {
  TextColumn get seriesId => text().references(SeriesTable, #id, onDelete: KeyAction.cascade)();
  RealColumn get chapter => real()();

  @override
  Set<Column> get primaryKey => {seriesId, chapter};
}
