import 'package:akashic/layers/functional/Organisation/data/gateways/shelf_filter_codec.dart';
import 'package:akashic/layers/functional/Organisation/domain/entities/smart_shelf.dart';
import 'package:akashic/layers/functional/Organisation/domain/entities/storage_place.dart';
import 'package:akashic/layers/functional/Organisation/domain/gateways/organisation_gateways.dart';
import 'package:akashic/layers/technical/LocalDatabase/akashic_database.dart';
import 'package:drift/drift.dart';

class DriftTagGateway implements TagGateway {
  DriftTagGateway(this._database);

  final AkashicDatabase _database;

  @override
  Stream<Set<String>> watchTagsOf(String itemId) =>
      (_database.select(_database.itemTags)..where((table) => table.itemId.equals(itemId))).watch().map((rows) => {for (final row in rows) row.tag});

  @override
  Future<void> setTags(String itemId, Set<String> tags) => _database.transaction(() async {
        await (_database.delete(_database.itemTags)..where((table) => table.itemId.equals(itemId))).go();
        await _database.batch((batch) => batch.insertAll(_database.itemTags, [
              for (final tag in tags)
                if (tag.trim().isNotEmpty) ItemTagsCompanion.insert(itemId: itemId, tag: tag.trim()),
            ]));
      });

  @override
  Future<Map<String, Set<String>>> tagsByItem() async {
    final tags = <String, Set<String>>{};
    for (final row in await _database.select(_database.itemTags).get()) {
      tags.putIfAbsent(row.itemId, () => {}).add(row.tag);
    }
    return tags;
  }

  @override
  Stream<Map<String, int>> watchTagCounts() => _database.select(_database.itemTags).watch().map((rows) {
        final counts = <String, int>{};
        for (final row in rows) {
          counts[row.tag] = (counts[row.tag] ?? 0) + 1;
        }
        return counts;
      });
}

class DriftSmartShelfGateway implements SmartShelfGateway {
  DriftSmartShelfGateway(this._database);

  final AkashicDatabase _database;

  @override
  Stream<List<SmartShelf>> watchAll() => (_database.select(_database.smartShelves)..orderBy([(table) => OrderingTerm.asc(table.createdAt)])).watch().map((rows) => [
        for (final row in rows) SmartShelf(id: row.id, name: row.name, categoryId: row.categoryId, filter: decodeShelfFilter(row.filter)),
      ]);

  @override
  Future<void> save(SmartShelf shelf) => _database.into(_database.smartShelves).insertOnConflictUpdate(SmartShelvesCompanion.insert(
        id: shelf.id,
        name: shelf.name,
        categoryId: Value(shelf.categoryId),
        filter: encodeShelfFilter(shelf.filter),
        createdAt: DateTime.now(),
      ));

  @override
  Future<void> delete(String shelfId) => (_database.delete(_database.smartShelves)..where((table) => table.id.equals(shelfId))).go();
}

class DriftStoragePlanGateway implements StoragePlanGateway {
  DriftStoragePlanGateway(this._database);

  final AkashicDatabase _database;

  @override
  Stream<List<StoragePlace>> watchAll() => _database.select(_database.storagePlaces).watch().map((rows) => [
        for (final row in rows) StoragePlace(id: row.id, parentId: row.parentId, name: row.name, position: row.position),
      ]);

  @override
  Future<void> save(StoragePlace place) => _database.into(_database.storagePlaces).insertOnConflictUpdate(StoragePlacesCompanion.insert(
        id: place.id,
        parentId: Value(place.parentId),
        name: place.name,
        position: Value(place.position),
      ));

  @override
  Future<void> delete(List<String> placeIds) => (_database.delete(_database.storagePlaces)..where((table) => table.id.isIn(placeIds))).go();
}
