import 'package:drift/drift.dart';

@DataClassName('DismissedSuggestionRow')
class DismissedSuggestions extends Table {
  TextColumn get sourceKey => text()();
  TextColumn get externalWorkId => text()();

  @override
  Set<Column> get primaryKey => {sourceKey, externalWorkId};
}
