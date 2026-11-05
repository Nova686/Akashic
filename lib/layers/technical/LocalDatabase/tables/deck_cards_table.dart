import 'package:akashic/layers/technical/LocalDatabase/tables/items_table.dart';
import 'package:drift/drift.dart';

@DataClassName('DeckCardRow')
class DeckCards extends Table {
  TextColumn get id => text()();
  TextColumn get itemId => text().references(Items, #id, onDelete: KeyAction.cascade)();
  TextColumn get name => text()();
  TextColumn get externalCardId => text().nullable()();
  IntColumn get quantity => integer()();
  TextColumn get imageUrl => text().nullable()();
  TextColumn get sourceKey => text().nullable()();
  IntColumn get priceCents => integer().nullable()();
  TextColumn get priceCurrency => text().nullable()();
  DateTimeColumn get pricedAt => dateTime().nullable()();
  TextColumn get typeLine => text().nullable()();
  TextColumn get colorIdentity => text().nullable()();
  RealColumn get manaValue => real().nullable()();
  BoolColumn get isCommander => boolean().withDefault(const Constant(false))();
  BoolColumn get isSecondaryCommander => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}
