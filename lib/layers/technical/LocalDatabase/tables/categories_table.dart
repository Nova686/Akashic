import 'package:drift/drift.dart';

@DataClassName('CategoryRow')
class Categories extends Table {
  TextColumn get id => text()();
  TextColumn get parentId => text().nullable().references(Categories, #id)();
  TextColumn get name => text()();
  IntColumn get colorValue => integer()();
  TextColumn get type => text()();
  TextColumn get sourceKey => text().nullable()();
  TextColumn get conditionParts => text()();
  IntColumn get position => integer()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}
