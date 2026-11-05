import 'package:drift/drift.dart';

@DataClassName('DiscoveryCacheRow')
class DiscoveryCache extends Table {
  TextColumn get id => text()();
  TextColumn get payload => text()();
  DateTimeColumn get fetchedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}
