import 'package:drift/drift.dart';

@DataClassName('ScanSessionRow')
class ScanSessions extends Table {
  TextColumn get id => text()();
  DateTimeColumn get startedAt => dateTime()();
  TextColumn get mode => text()();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('ScanSessionEntryRow')
class ScanSessionEntries extends Table {
  TextColumn get sessionId => text().references(ScanSessions, #id, onDelete: KeyAction.cascade)();
  IntColumn get position => integer()();
  TextColumn get title => text()();
  TextColumn get outcome => text()();
  TextColumn get source => text()();
  TextColumn get itemId => text().nullable()();

  @override
  Set<Column> get primaryKey => {sessionId, position};
}
