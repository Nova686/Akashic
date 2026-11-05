import 'package:drift/drift.dart';

@DataClassName('SteamWatchRow')
class SteamWatches extends Table {
  TextColumn get appId => text()();
  IntColumn get priceCents => integer().nullable()();
  IntColumn get initialPriceCents => integer().nullable()();
  IntColumn get discountPercent => integer().withDefault(const Constant(0))();
  TextColumn get priceCurrency => text().nullable()();
  BoolColumn get isComingSoon => boolean().withDefault(const Constant(false))();
  DateTimeColumn get checkedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {appId};
}

@DataClassName('SteamKnownDlcsRow')
class SteamKnownDlcs extends Table {
  TextColumn get appId => text()();
  TextColumn get dlcIds => text()();
  DateTimeColumn get checkedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {appId};
}
