import 'package:drift/drift.dart';

@DataClassName('ActivityEventRow')
class ActivityEvents extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get kind => text()();
  TextColumn get itemId => text().nullable()();
  TextColumn get categoryId => text().nullable()();
  TextColumn get title => text()();
  IntColumn get amountCents => integer().nullable()();
  TextColumn get currency => text().nullable()();
  TextColumn get detail => text().nullable()();
  DateTimeColumn get at => dateTime()();
}

@DataClassName('GoalRow')
class Goals extends Table {
  TextColumn get id => text()();
  IntColumn get year => integer()();
  TextColumn get measure => text()();
  TextColumn get categoryId => text().nullable()();
  IntColumn get target => integer()();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}
