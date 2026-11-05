import 'package:akashic/layers/technical/LocalDatabase/tables/categories_table.dart';
import 'package:akashic/layers/technical/LocalDatabase/tables/copies_table.dart';
import 'package:akashic/layers/technical/LocalDatabase/tables/copy_conditions_table.dart';
import 'package:akashic/layers/technical/LocalDatabase/tables/deck_cards_table.dart';
import 'package:akashic/layers/technical/LocalDatabase/tables/discovery_cache_table.dart';
import 'package:akashic/layers/technical/LocalDatabase/tables/dismissed_suggestions_table.dart';
import 'package:akashic/layers/technical/LocalDatabase/tables/item_details_table.dart';
import 'package:akashic/layers/technical/LocalDatabase/tables/item_titles_table.dart';
import 'package:akashic/layers/technical/LocalDatabase/tables/item_photos_table.dart';
import 'package:akashic/layers/technical/LocalDatabase/tables/items_table.dart';
import 'package:akashic/layers/technical/LocalDatabase/tables/preferences_table.dart';
import 'package:akashic/layers/technical/LocalDatabase/tables/read_chapters_table.dart';
import 'package:akashic/layers/technical/LocalDatabase/tables/sales_table.dart';
import 'package:akashic/layers/technical/LocalDatabase/tables/sealed_prices_table.dart';
import 'package:akashic/layers/technical/LocalDatabase/tables/price_alerts_table.dart';
import 'package:akashic/layers/technical/LocalDatabase/tables/steam_watches_table.dart';
import 'package:akashic/layers/technical/LocalDatabase/tables/activity_events_table.dart';
import 'package:akashic/layers/technical/LocalDatabase/tables/organisation_tables.dart';
import 'package:akashic/layers/technical/LocalDatabase/tables/scan_sessions_table.dart';
import 'package:akashic/layers/technical/LocalDatabase/tables/value_snapshots_table.dart';
import 'package:akashic/layers/technical/LocalDatabase/tables/scan_follows_table.dart';
import 'package:akashic/layers/technical/LocalDatabase/tables/scan_releases_table.dart';
import 'package:akashic/layers/technical/LocalDatabase/tables/series_table.dart';
import 'package:akashic/layers/technical/LocalDatabase/tables/series_titles_table.dart';
import 'package:akashic/layers/technical/LocalDatabase/tables/steam_game_stats_table.dart';
import 'package:akashic/layers/technical/LocalDatabase/tables/source_blocks_table.dart';
import 'package:akashic/layers/technical/LocalDatabase/tables/wishes_table.dart';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:drift_flutter/drift_flutter.dart';

export 'package:akashic/layers/technical/LocalDatabase/tables/categories_table.dart';
export 'package:akashic/layers/technical/LocalDatabase/tables/copies_table.dart';
export 'package:akashic/layers/technical/LocalDatabase/tables/copy_conditions_table.dart';
export 'package:akashic/layers/technical/LocalDatabase/tables/deck_cards_table.dart';
export 'package:akashic/layers/technical/LocalDatabase/tables/discovery_cache_table.dart';
export 'package:akashic/layers/technical/LocalDatabase/tables/dismissed_suggestions_table.dart';
export 'package:akashic/layers/technical/LocalDatabase/tables/item_details_table.dart';
export 'package:akashic/layers/technical/LocalDatabase/tables/item_titles_table.dart';
export 'package:akashic/layers/technical/LocalDatabase/tables/item_photos_table.dart';
export 'package:akashic/layers/technical/LocalDatabase/tables/items_table.dart';
export 'package:akashic/layers/technical/LocalDatabase/tables/preferences_table.dart';
export 'package:akashic/layers/technical/LocalDatabase/tables/read_chapters_table.dart';
export 'package:akashic/layers/technical/LocalDatabase/tables/scan_follows_table.dart';
export 'package:akashic/layers/technical/LocalDatabase/tables/scan_releases_table.dart';
export 'package:akashic/layers/technical/LocalDatabase/tables/series_table.dart';
export 'package:akashic/layers/technical/LocalDatabase/tables/series_titles_table.dart';
export 'package:akashic/layers/technical/LocalDatabase/tables/source_blocks_table.dart';
export 'package:akashic/layers/technical/LocalDatabase/tables/wishes_table.dart';

part 'akashic_database.g.dart';

@DriftDatabase(tables: [Categories, SeriesTable, SeriesTitles, Items, ItemTitles, Copies, CopyConditions, Preferences, DeckCards, ItemDetails, Wishes, DismissedSuggestions, DiscoveryCache, ScanFollows, ReadChapters, ScanReleases, SourceBlocks, ItemPhotos, SteamGameStats, Sales, SealedPrices, SteamWatches, SteamKnownDlcs, PriceAlerts, ValueSnapshots, ItemValueSnapshots, ScanSessions, ScanSessionEntries, ActivityEvents, Goals, ItemTags, SmartShelves, StoragePlaces])
class AkashicDatabase extends _$AkashicDatabase {
  AkashicDatabase(super.executor);

  AkashicDatabase.open() : super(driftDatabase(name: 'akashic'));

  AkashicDatabase.forTesting() : super(DatabaseConnection(NativeDatabase.memory(), closeStreamsSynchronously: true));

  static const int currentSchemaVersion = 28;

  static const Map<String, String> lookupIndexes = {
    'items_by_category': 'items (category_id)',
    'items_by_series': 'items (series_id)',
    'items_by_external_work': 'items (source_key, external_work_id)',
    'copies_by_item': 'copies (item_id)',
    'copies_by_barcode': 'copies (barcode)',
    'series_by_category': 'series (category_id)',
    'categories_by_parent': 'categories (parent_id)',
    'deck_cards_by_item': 'deck_cards (item_id)',
    'item_photos_by_item': 'item_photos (item_id)',
    'item_photos_by_copy': 'item_photos (copy_id)',
    'wishes_by_category': 'wishes (category_id)',
    'wishes_by_series': 'wishes (series_id)',
    'steam_game_stats_by_app': 'steam_game_stats (app_id)',
  };
  static const String fileName = 'akashic.sqlite';

  @override
  int get schemaVersion => currentSchemaVersion;

  Future<void> _createActivityIndex() => customStatement('CREATE INDEX IF NOT EXISTS activity_events_by_time ON activity_events (at)');

  Future<void> _createLookupIndexes() async {
    for (final MapEntry(key: name, value: target) in lookupIndexes.entries) {
      await customStatement('CREATE INDEX IF NOT EXISTS $name ON $target');
    }
  }

  Future<void> splitCopiesIntoItems() async {
    final extraCopies = await customSelect(
      'SELECT copy.id AS copy_id, copy.item_id AS item_id FROM copies copy '
      'WHERE EXISTS (SELECT 1 FROM copies earlier WHERE earlier.item_id = copy.item_id '
      'AND (earlier.created_at < copy.created_at OR (earlier.created_at = copy.created_at AND earlier.id < copy.id)))',
      readsFrom: {copies},
    ).get();
    for (final row in extraCopies) {
      final copyId = row.read<String>('copy_id');
      final itemId = row.read<String>('item_id');
      final newItemId = 'split-$copyId';
      await _cloneRows(items, keyColumn: 'id', from: itemId, to: newItemId);
      await _cloneRows(itemTitles, keyColumn: 'item_id', from: itemId, to: newItemId);
      await _cloneRows(itemDetails, keyColumn: 'item_id', from: itemId, to: newItemId);
      await _cloneRows(deckCards, keyColumn: 'item_id', from: itemId, to: newItemId, renamedIdColumn: 'id');
      await customStatement('UPDATE copies SET item_id = ? WHERE id = ?', [newItemId, copyId]);
      await customStatement('UPDATE item_photos SET item_id = ? WHERE copy_id = ?', [newItemId, copyId]);
    }
  }

  Future<void> _cloneRows(TableInfo<Table, Object?> table, {required String keyColumn, required String from, required String to, String? renamedIdColumn}) async {
    final names = [for (final column in table.$columns) '"${column.name}"'];
    final selected = <String>[];
    final arguments = <Object>[];
    for (final name in names) {
      if (name == '"$keyColumn"') {
        selected.add('?');
        arguments.add(to);
      } else if (name == '"$renamedIdColumn"') {
        selected.add('? || $name');
        arguments.add('$to:');
      } else {
        selected.add(name);
      }
    }
    final tableName = table.actualTableName;
    await customStatement('INSERT INTO $tableName (${names.join(', ')}) SELECT ${selected.join(', ')} FROM $tableName WHERE $keyColumn = ?', [...arguments, from]);
  }

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (migrator) async {
          await migrator.createAll();
          await _createLookupIndexes();
          await _createActivityIndex();
        },
        onUpgrade: (migrator, from, to) async {
          if (from < 28) {
            final itemColumns = {for (final row in await customSelect('PRAGMA table_info(items)').get()) row.read<String>('name')};
            if (!itemColumns.contains('preorder_due_on')) {
              await migrator.addColumn(items, items.preorderDueOn);
            }
            if (!itemColumns.contains('preorder_deposit_cents')) {
              await migrator.addColumn(items, items.preorderDepositCents);
            }
          }
          if (from < 2) {
            await migrator.addColumn(items, items.sourceKey);
            await migrator.addColumn(items, items.externalWorkId);
            await migrator.addColumn(copies, copies.barcode);
            await migrator.addColumn(copies, copies.externalEditionId);
          }
          if (from < 4) {
            await migrator.addColumn(items, items.cardKind);
            await migrator.addColumn(seriesTable, seriesTable.sourceKey);
            await migrator.addColumn(seriesTable, seriesTable.externalWorkId);
            await migrator.addColumn(seriesTable, seriesTable.status);
            await migrator.createTable(deckCards);
            await migrator.createTable(itemDetails);
          }
          if (from < 5) {
            await migrator.createTable(wishes);
            await migrator.createTable(dismissedSuggestions);
            await migrator.createTable(discoveryCache);
          }
          if (from < 6) {
            await migrator.createTable(scanFollows);
            await migrator.createTable(readChapters);
            await migrator.createTable(scanReleases);
          }
          if (from < 7) {
            await migrator.addColumn(copies, copies.loanedTo);
            await migrator.addColumn(copies, copies.loanedSince);
          }
          if (from < 8) {
            await migrator.createTable(sourceBlocks);
          }
          if (from < 9) {
            await customStatement('DROP TABLE IF EXISTS pending_checks');
          }
          if (from < 10) {
            await migrator.addColumn(items, items.progressStatus);
            await migrator.addColumn(items, items.progressChapter);
            await migrator.addColumn(items, items.progressPage);
            await migrator.createTable(itemPhotos);
            if (from >= 4) {
              await migrator.addColumn(deckCards, deckCards.sourceKey);
              await migrator.addColumn(deckCards, deckCards.priceCents);
              await migrator.addColumn(deckCards, deckCards.priceCurrency);
              await migrator.addColumn(deckCards, deckCards.pricedAt);
            }
          }
          if (from < 14 && from >= 4) {
            await migrator.addColumn(deckCards, deckCards.typeLine);
            await migrator.addColumn(deckCards, deckCards.colorIdentity);
            await migrator.addColumn(deckCards, deckCards.manaValue);
            await migrator.addColumn(deckCards, deckCards.isCommander);
          }
          if (from < 19) {
            await migrator.createTable(sealedPrices);
          }
          if (from < 18) {
            await migrator.addColumn(copies, copies.isOpened);
            await migrator.addColumn(copies, copies.purchasedOn);
            await migrator.addColumn(copies, copies.purchaseChannel);
            await migrator.createTable(sales);
          }
          if (from < 17 && from >= 16) {
            await migrator.addColumn(steamGameStats, steamGameStats.priceCents);
            await migrator.addColumn(steamGameStats, steamGameStats.priceCurrency);
            await migrator.addColumn(steamGameStats, steamGameStats.pricedAt);
          }
          if (from < 16) {
            await migrator.createTable(steamGameStats);
            await customStatement('CREATE INDEX IF NOT EXISTS steam_game_stats_by_app ON ${lookupIndexes['steam_game_stats_by_app']}');
          }
          if (from < 15 && from >= 4) {
            await migrator.addColumn(deckCards, deckCards.isSecondaryCommander);
          }
          if (from < 13) {
            await migrator.addColumn(items, items.marketValueCents);
            await migrator.addColumn(items, items.marketValueCurrency);
            await migrator.addColumn(items, items.marketValuedAt);
          }
          if (from < 12) {
            if (from >= 10) {
              await migrator.addColumn(itemPhotos, itemPhotos.copyId);
              await customStatement(
                'UPDATE item_photos SET copy_id = (SELECT copies.id FROM copies WHERE copies.item_id = item_photos.item_id ORDER BY copies.created_at, copies.id LIMIT 1)',
              );
            }
            await _createLookupIndexes();
          }
          if (from < 20) {
            await splitCopiesIntoItems();
          }
          if (from < 21) {
            await migrator.createTable(steamWatches);
            await migrator.createTable(steamKnownDlcs);
            await migrator.createTable(priceAlerts);
          }
          if (from < 22) {
            await migrator.createTable(valueSnapshots);
            await migrator.createTable(itemValueSnapshots);
          }
          if (from < 23) {
            await migrator.createTable(scanSessions);
            await migrator.createTable(scanSessionEntries);
          }
          if (from < 24) {
            await migrator.createTable(activityEvents);
            await migrator.createTable(goals);
            await _createActivityIndex();
          }
          if (from < 25) {
            await migrator.createTable(itemTags);
            await migrator.createTable(smartShelves);
            await migrator.createTable(storagePlaces);
          }
          if (from < 26) {
            final wishColumns = {for (final row in await customSelect('PRAGMA table_info(wishes)').get()) row.read<String>('name')};
            if (!wishColumns.contains('priority')) {
              await migrator.addColumn(wishes, wishes.priority);
            }
            if (!wishColumns.contains('max_price_cents')) {
              await migrator.addColumn(wishes, wishes.maxPriceCents);
            }
          }
          if (from < 27) {
            final copyColumns = {for (final row in await customSelect('PRAGMA table_info(copies)').get()) row.read<String>('name')};
            if (!copyColumns.contains('loan_due_on')) {
              await migrator.addColumn(copies, copies.loanDueOn);
            }
            if (!copyColumns.contains('loan_reminds_at_due')) {
              await migrator.addColumn(copies, copies.loanRemindsAtDue);
            }
            if (!copyColumns.contains('loan_follows_up')) {
              await migrator.addColumn(copies, copies.loanFollowsUp);
            }
          }
        },
        beforeOpen: (details) async {
          await customStatement('PRAGMA foreign_keys = ON');
          await customStatement('PRAGMA busy_timeout = 5000');
          await customStatement('PRAGMA journal_mode = WAL');
        },
      );
}
