import 'package:akashic/layers/technical/LocalDatabase/tables/items_table.dart';
import 'package:drift/drift.dart';

@DataClassName('SteamGameStatsRow')
class SteamGameStats extends Table {
  TextColumn get itemId => text().references(Items, #id, onDelete: KeyAction.cascade)();
  TextColumn get appId => text()();
  IntColumn get playtimeMinutes => integer().withDefault(const Constant(0))();
  IntColumn get recentMinutes => integer().withDefault(const Constant(0))();
  DateTimeColumn get lastPlayedAt => dateTime().nullable()();
  IntColumn get achievementsUnlocked => integer().nullable()();
  IntColumn get achievementsTotal => integer().nullable()();
  DateTimeColumn get achievementsCheckedAt => dateTime().nullable()();
  TextColumn get deckStatus => text().nullable()();
  DateTimeColumn get deckCheckedAt => dateTime().nullable()();
  TextColumn get autoProgressStatus => text().nullable()();
  IntColumn get priceCents => integer().nullable()();
  TextColumn get priceCurrency => text().nullable()();
  DateTimeColumn get pricedAt => dateTime().nullable()();
  DateTimeColumn get syncedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {itemId};
}
