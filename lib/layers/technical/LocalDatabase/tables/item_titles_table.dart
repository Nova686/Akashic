import 'package:akashic/layers/technical/LocalDatabase/tables/items_table.dart';
import 'package:drift/drift.dart';

@DataClassName('ItemTitleRow')
class ItemTitles extends Table {
  TextColumn get itemId => text().references(Items, #id, onDelete: KeyAction.cascade)();
  TextColumn get languageCode => text()();
  TextColumn get title => text()();

  @override
  Set<Column> get primaryKey => {itemId, languageCode};
}
