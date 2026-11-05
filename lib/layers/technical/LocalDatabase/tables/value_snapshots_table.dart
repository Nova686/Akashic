import 'package:akashic/layers/technical/LocalDatabase/tables/items_table.dart';
import 'package:drift/drift.dart';

@DataClassName('ValueSnapshotRow')
class ValueSnapshots extends Table {
  TextColumn get month => text()();
  TextColumn get totals => text()();
  DateTimeColumn get takenAt => dateTime()();

  @override
  Set<Column> get primaryKey => {month};
}

@DataClassName('ItemValueSnapshotRow')
class ItemValueSnapshots extends Table {
  TextColumn get itemId => text().references(Items, #id, onDelete: KeyAction.cascade)();
  TextColumn get month => text()();
  IntColumn get cents => integer()();
  TextColumn get currency => text()();

  @override
  Set<Column> get primaryKey => {itemId, month};
}
