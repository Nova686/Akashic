import 'package:akashic/layers/technical/LocalDatabase/tables/items_table.dart';
import 'package:drift/drift.dart';

@DataClassName('ItemTagRow')
class ItemTags extends Table {
  TextColumn get itemId => text().references(Items, #id, onDelete: KeyAction.cascade)();
  TextColumn get tag => text()();

  @override
  Set<Column> get primaryKey => {itemId, tag};
}

@DataClassName('SmartShelfRow')
class SmartShelves extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get categoryId => text().nullable()();
  TextColumn get filter => text()();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('StoragePlaceRow')
class StoragePlaces extends Table {
  TextColumn get id => text()();
  TextColumn get parentId => text().nullable()();
  TextColumn get name => text()();
  IntColumn get position => integer().withDefault(const Constant(0))();

  @override
  Set<Column> get primaryKey => {id};
}
