import 'package:akashic/layers/technical/LocalDatabase/tables/copies_table.dart';
import 'package:drift/drift.dart';

@DataClassName('CopyConditionRow')
class CopyConditions extends Table {
  TextColumn get copyId => text().references(Copies, #id, onDelete: KeyAction.cascade)();
  TextColumn get part => text()();
  TextColumn get condition => text()();

  @override
  Set<Column> get primaryKey => {copyId, part};
}
