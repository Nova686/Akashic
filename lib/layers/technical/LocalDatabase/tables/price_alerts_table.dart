import 'package:akashic/layers/technical/LocalDatabase/tables/items_table.dart';
import 'package:drift/drift.dart';

@DataClassName('PriceAlertRow')
class PriceAlerts extends Table {
  TextColumn get itemId => text().references(Items, #id, onDelete: KeyAction.cascade)();
  IntColumn get thresholdCents => integer()();
  BoolColumn get isAbove => boolean()();
  DateTimeColumn get notifiedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {itemId};
}
