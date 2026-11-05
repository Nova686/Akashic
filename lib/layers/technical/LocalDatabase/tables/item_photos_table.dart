import 'package:akashic/layers/technical/LocalDatabase/tables/copies_table.dart';
import 'package:akashic/layers/technical/LocalDatabase/tables/items_table.dart';
import 'package:drift/drift.dart';

@DataClassName('ItemPhotoRow')
class ItemPhotos extends Table {
  TextColumn get id => text()();
  TextColumn get itemId => text().references(Items, #id, onDelete: KeyAction.cascade)();
  TextColumn get copyId => text().nullable().references(Copies, #id, onDelete: KeyAction.cascade)();
  TextColumn get path => text()();
  IntColumn get position => integer()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}
