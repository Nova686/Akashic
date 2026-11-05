import 'package:drift/drift.dart';

@DataClassName('SourceBlockRow')
class SourceBlocks extends Table {
  TextColumn get apiFamily => text()();
  DateTimeColumn get blockedAt => dateTime()();
  DateTimeColumn get retryAt => dateTime()();

  @override
  Set<Column> get primaryKey => {apiFamily};
}
