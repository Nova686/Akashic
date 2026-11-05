import 'package:akashic/layers/technical/LocalDatabase/tables/items_table.dart';
import 'package:drift/drift.dart';

@DataClassName('CopyRow')
class Copies extends Table {
  TextColumn get id => text()();
  TextColumn get itemId => text().references(Items, #id, onDelete: KeyAction.cascade)();
  TextColumn get edition => text().nullable()();
  IntColumn get pricePaidCents => integer().nullable()();
  TextColumn get location => text().nullable()();
  TextColumn get barcode => text().nullable()();
  TextColumn get externalEditionId => text().nullable()();
  TextColumn get loanedTo => text().nullable()();
  DateTimeColumn get loanedSince => dateTime().nullable()();
  DateTimeColumn get loanDueOn => dateTime().nullable()();
  BoolColumn get loanRemindsAtDue => boolean().withDefault(const Constant(true))();
  BoolColumn get loanFollowsUp => boolean().withDefault(const Constant(true))();
  BoolColumn get isOpened => boolean().withDefault(const Constant(false))();
  DateTimeColumn get purchasedOn => dateTime().nullable()();
  TextColumn get purchaseChannel => text().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}
