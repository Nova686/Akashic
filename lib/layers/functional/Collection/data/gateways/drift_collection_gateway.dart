import 'dart:async';

import 'package:akashic/layers/functional/Collection/domain/entities/market_value.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/card_kind.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/collection_item.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/item_photo.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/item_progress.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/item_condition.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/item_copy.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/localized_titles.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/trade_channel.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/owned_work.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/series.dart';
import 'package:akashic/layers/functional/Collection/domain/gateways/collection_gateway.dart';
import 'package:akashic/layers/technical/LocalDatabase/akashic_database.dart';
import 'package:drift/drift.dart';

class DriftCollectionGateway implements CollectionGateway {
  DriftCollectionGateway(this._database);

  final AkashicDatabase _database;

  Stream<T> _watchTables<T>(Set<ResultSetImplementation<dynamic, dynamic>> tables, Future<T> Function() load) {
    return _database.customSelect('SELECT 1', readsFrom: tables.cast()).watch().asyncMap((_) => load());
  }

  @override
  Future<void> saveItem(CollectionItem item) {
    return _database.transaction(() async {
      await _database.into(_database.items).insertOnConflictUpdate(ItemsCompanion.insert(
            id: item.id,
            categoryId: item.categoryId,
            seriesId: Value(item.seriesId),
            volumeNumber: Value(item.volumeNumber),
            originalLanguage: Value(item.titles.originalLanguage),
            creator: Value(item.creator),
            year: Value(item.year),
            publisher: Value(item.publisher),
            imagePath: Value(item.imagePath),
            spineColorValue: Value(item.spineColorValue),
            rating: Value(item.rating),
            groupKey: Value(item.groupKey),
            sourceKey: Value(item.sourceKey),
            externalWorkId: Value(item.externalWorkId),
            cardKind: Value(item.cardKind?.name),
          ));
      await (_database.delete(_database.itemTitles)..where((table) => table.itemId.equals(item.id))).go();
      for (final MapEntry(key: languageCode, value: title) in item.titles.byLanguage.entries) {
        if (title.trim().isEmpty) {
          continue;
        }
        await _database.into(_database.itemTitles).insert(ItemTitlesCompanion.insert(itemId: item.id, languageCode: languageCode, title: title.trim()));
      }
    });
  }

  @override
  Future<void> saveSeries(Series series) {
    return _database.transaction(() async {
      await _database.into(_database.seriesTable).insertOnConflictUpdate(SeriesTableCompanion.insert(
            id: series.id,
            categoryId: series.categoryId,
            originalLanguage: Value(series.titles.originalLanguage),
            creator: Value(series.creator),
            publishedVolumes: Value(series.publishedVolumes),
            sourceKey: Value(series.sourceKey),
            externalWorkId: Value(series.externalWorkId),
            status: Value(series.status),
          ));
      await (_database.delete(_database.seriesTitles)..where((table) => table.seriesId.equals(series.id))).go();
      for (final MapEntry(key: languageCode, value: title) in series.titles.byLanguage.entries) {
        if (title.trim().isEmpty) {
          continue;
        }
        await _database.into(_database.seriesTitles).insert(SeriesTitlesCompanion.insert(seriesId: series.id, languageCode: languageCode, title: title.trim()));
      }
    });
  }

  @override
  Future<void> saveCopy(ItemCopy copy) {
    return _database.transaction(() async {
      await _database.into(_database.copies).insertOnConflictUpdate(CopiesCompanion.insert(
            id: copy.id,
            itemId: copy.itemId,
            edition: Value(copy.edition),
            pricePaidCents: Value(copy.pricePaidCents),
            location: Value(copy.location),
            barcode: Value(copy.barcode),
            externalEditionId: Value(copy.externalEditionId),
            isOpened: Value(copy.isOpened),
            purchasedOn: Value(copy.purchasedOn),
            purchaseChannel: Value(copy.purchaseChannel?.name),
          ));
      await (_database.delete(_database.copyConditions)..where((table) => table.copyId.equals(copy.id))).go();
      for (final MapEntry(key: part, value: condition) in copy.conditions.entries) {
        await _database.into(_database.copyConditions).insert(CopyConditionsCompanion.insert(copyId: copy.id, part: part, condition: condition.name));
      }
    });
  }

  @override
  Future<void> deleteCopy(String copyId) {
    return (_database.delete(_database.copies)..where((table) => table.id.equals(copyId))).go();
  }

  @override
  Future<void> deleteItem(String itemId) {
    return (_database.delete(_database.items)..where((table) => table.id.equals(itemId))).go();
  }

  @override
  Stream<List<ItemPhoto>> watchPhotos(String itemId) {
    return (_database.select(_database.itemPhotos)
          ..where((table) => table.itemId.equals(itemId))
          ..orderBy([(table) => OrderingTerm.asc(table.position)]))
        .watch()
        .map((rows) => [for (final row in rows) ItemPhoto(id: row.id, itemId: row.itemId, copyId: row.copyId, path: row.path, position: row.position)]);
  }

  @override
  Future<void> savePhoto(ItemPhoto photo) {
    return _database.into(_database.itemPhotos).insertOnConflictUpdate(ItemPhotosCompanion.insert(id: photo.id, itemId: photo.itemId, copyId: Value(photo.copyId), path: photo.path, position: photo.position));
  }

  @override
  Future<void> deletePhoto(String photoId) {
    return (_database.delete(_database.itemPhotos)..where((table) => table.id.equals(photoId))).go();
  }

  @override
  Future<void> saveMarketValue(String itemId, MarketValue? value) => (_database.update(
    _database.items,
  )..where((table) => table.id.equals(itemId))).write(ItemsCompanion(marketValueCents: Value(value?.cents), marketValueCurrency: Value(value?.currency), marketValuedAt: Value(value?.valuedAt)));

  @override
  Future<void> saveMarketValues(Map<String, MarketValue?> valuesByItem) async {
    if (valuesByItem.isEmpty) {
      return;
    }
    await _database.batch((batch) {
      for (final MapEntry(key: itemId, value: value) in valuesByItem.entries) {
        batch.update(
          _database.items,
          ItemsCompanion(marketValueCents: Value(value?.cents), marketValueCurrency: Value(value?.currency), marketValuedAt: Value(value?.valuedAt)),
          where: (table) => table.id.equals(itemId),
        );
      }
    });
  }

  @override
  Future<void> saveCover(String itemId, {required String imagePath, int? spineColorValue}) =>
      (_database.update(_database.items)..where((table) => table.id.equals(itemId))).write(ItemsCompanion(imagePath: Value(imagePath), spineColorValue: Value(spineColorValue)));

  @override
  Future<void> setGroupKey(String itemId, String? groupKey) =>
      (_database.update(_database.items)..where((table) => table.id.equals(itemId))).write(ItemsCompanion(groupKey: Value(groupKey)));

  @override
  Future<void> saveProgress(String itemId, ItemProgress? progress) {
    return (_database.update(_database.items)..where((table) => table.id.equals(itemId))).write(ItemsCompanion(
          progressStatus: Value(progress?.status.name),
          progressChapter: Value(progress?.hasBookmark ?? false ? progress?.chapter : null),
          progressPage: Value(progress?.hasBookmark ?? false ? progress?.page : null),
        ));
  }

  @override
  Future<void> moveItem(String itemId, {required String categoryId, required bool leavesSeries}) {
    return (_database.update(_database.items)..where((table) => table.id.equals(itemId))).write(ItemsCompanion(
          categoryId: Value(categoryId),
          seriesId: leavesSeries ? const Value(null) : const Value.absent(),
          volumeNumber: leavesSeries ? const Value(null) : const Value.absent(),
        ));
  }

  @override
  Future<void> moveSeries(String seriesId, {required String categoryId}) {
    return _database.transaction(() async {
      await (_database.update(_database.seriesTable)..where((table) => table.id.equals(seriesId))).write(SeriesTableCompanion(categoryId: Value(categoryId)));
      await (_database.update(_database.items)..where((table) => table.seriesId.equals(seriesId))).write(ItemsCompanion(categoryId: Value(categoryId)));
    });
  }

  @override
  Future<void> deleteSeries(String seriesId) {
    return _database.transaction(() async {
      await (_database.update(_database.items)..where((table) => table.seriesId.equals(seriesId))).write(const ItemsCompanion(seriesId: Value(null)));
      await (_database.delete(_database.seriesTable)..where((table) => table.id.equals(seriesId))).go();
    });
  }

  Future<List<String>> _categoryTreeIds(String categoryId) async {
    final rows = await (_database.select(_database.categories)
          ..where((table) => table.id.equals(categoryId) | table.parentId.equals(categoryId)))
        .get();
    return rows.map((row) => row.id).toList();
  }

  @override
  Stream<List<CollectionItem>> watchItemsInCategoryTree(String categoryId) {
    return _watchTables({_database.items, _database.itemTitles, _database.categories}, () async {
      final categoryIds = await _categoryTreeIds(categoryId);
      final rows = await (_database.select(_database.items)..where((table) => table.categoryId.isIn(categoryIds))).get();
      return _toItems(rows);
    });
  }

  @override
  Stream<List<Series>> watchSeriesInCategoryTree(String categoryId) {
    return _watchTables({_database.seriesTable, _database.seriesTitles, _database.categories}, () async {
      final categoryIds = await _categoryTreeIds(categoryId);
      final rows = await (_database.select(_database.seriesTable)..where((table) => table.categoryId.isIn(categoryIds))).get();
      return _toSeries(rows);
    });
  }

  @override
  Stream<List<Series>> watchAllSeries() {
    return _watchTables({_database.seriesTable, _database.seriesTitles}, () async {
      return _toSeries(await _database.select(_database.seriesTable).get());
    });
  }

  @override
  Stream<CollectionItem?> watchItem(String itemId) {
    return _watchTables({_database.items, _database.itemTitles}, () async {
      final rows = await (_database.select(_database.items)..where((table) => table.id.equals(itemId))).get();
      final items = await _toItems(rows);
      return items.isEmpty ? null : items.single;
    });
  }

  Future<List<ItemCopy>> _copiesFrom(List<CopyRow> rows) async {
    final conditionRows = await (_database.select(_database.copyConditions)..where((table) => table.copyId.isIn(rows.map((row) => row.id)))).get();
    final conditionsByCopy = <String, Map<String, ItemCondition>>{};
    for (final conditionRow in conditionRows) {
      conditionsByCopy.putIfAbsent(conditionRow.copyId, () => {})[conditionRow.part] = ItemCondition.values.byName(conditionRow.condition);
    }
    return [
      for (final row in rows)
        ItemCopy(
          id: row.id,
          itemId: row.itemId,
          edition: row.edition,
          pricePaidCents: row.pricePaidCents,
          location: row.location,
          barcode: row.barcode,
          externalEditionId: row.externalEditionId,
          loanedTo: row.loanedTo,
          loanedSince: row.loanedSince,
          isOpened: row.isOpened,
          purchasedOn: row.purchasedOn,
          purchaseChannel: TradeChannel.values.asNameMap()[row.purchaseChannel],
          conditions: conditionsByCopy[row.id] ?? const {},
        ),
    ];
  }

  @override
  Stream<List<ItemCopy>> watchCopies(String itemId) {
    return _watchTables({_database.copies, _database.copyConditions}, () async {
      final rows = await (_database.select(_database.copies)
            ..where((table) => table.itemId.equals(itemId))
            ..orderBy([(table) => OrderingTerm.asc(table.createdAt)]))
          .get();
      return _copiesFrom(rows);
    });
  }

  @override
  Future<CollectionItem?> findByExternalWork(String sourceKey, String externalWorkId) async {
    final rows = await (_database.select(_database.items)
          ..where((table) => table.sourceKey.equals(sourceKey) & table.externalWorkId.equals(externalWorkId))
          ..limit(1))
        .get();
    final items = await _toItems(rows);
    return items.firstOrNull;
  }

  @override
  Future<List<(CollectionItem, ItemCopy)>> findCopiesByBarcode(String normalizedBarcode) async {
    final copyRows = await (_database.select(_database.copies)..where((table) => table.barcode.equals(normalizedBarcode))).get();
    final itemIds = {for (final copyRow in copyRows) copyRow.itemId};
    final itemsById = {for (final item in await _toItems(await (_database.select(_database.items)..where((table) => table.id.isIn(itemIds))).get())) item.id: item};
    final result = <(CollectionItem, ItemCopy)>[];
    for (final copy in await _copiesFrom(copyRows)) {
      if (itemsById[copy.itemId] case final item?) {
        result.add((item, copy));
      }
    }
    return result;
  }

  @override
  Future<List<CollectionItem>> allItems() async => _toItems(await _database.select(_database.items).get());

  @override
  Future<Map<String, ItemCopy>> firstCopiesByItem() async {
    final copies = <String, ItemCopy>{};
    for (final row in await (_database.select(_database.copies)..orderBy([(table) => OrderingTerm.asc(table.createdAt), (table) => OrderingTerm.asc(table.id)])).get()) {
      copies.putIfAbsent(
        row.itemId,
        () => ItemCopy(id: row.id, itemId: row.itemId, edition: row.edition, pricePaidCents: row.pricePaidCents, location: row.location, barcode: row.barcode, isOpened: row.isOpened, loanedTo: row.loanedTo, purchasedOn: row.purchasedOn),
      );
    }
    return copies;
  }

  @override
  Future<Map<String, Set<int>>> ownedVolumesBySeries() async {
    final rows = await (_database.selectOnly(_database.items)
          ..addColumns([_database.items.seriesId, _database.items.volumeNumber])
          ..where(_database.items.seriesId.isNotNull() & _database.items.volumeNumber.isNotNull()))
        .get();
    final volumesBySeries = <String, Set<int>>{};
    for (final row in rows) {
      volumesBySeries.putIfAbsent(row.read(_database.items.seriesId)!, () => {}).add(row.read(_database.items.volumeNumber)!);
    }
    return volumesBySeries;
  }

  @override
  Future<Set<int>> volumeNumbersOf(String seriesId) async {
    final rows = await (_database.select(_database.items)..where((table) => table.seriesId.equals(seriesId) & table.volumeNumber.isNotNull())).get();
    return rows.map((row) => row.volumeNumber!).toSet();
  }

  @override
  Stream<List<OwnedWork>> watchOwnedWorks() {
    return _watchTables({_database.items, _database.itemTitles, _database.copies}, () async {
      final itemRows = await _database.select(_database.items).get();
      final items = await _toItems(itemRows);
      final addedAtByItem = {for (final row in itemRows) row.id: row.createdAt};
      final barcodesByItem = <String, Set<String>>{};
      for (final copyRow in await (_database.select(_database.copies)..where((table) => table.barcode.isNotNull())).get()) {
        barcodesByItem.putIfAbsent(copyRow.itemId, () => {}).add(copyRow.barcode!);
      }
      return [
        for (final item in items)
          OwnedWork(
            itemId: item.id,
            categoryId: item.categoryId,
            titles: item.titles,
            creator: item.creator,
            sourceKey: item.sourceKey,
            externalWorkId: item.externalWorkId,
            seriesId: item.seriesId,
            volumeNumber: item.volumeNumber,
            barcodes: barcodesByItem[item.id] ?? const {},
            rating: item.rating,
            addedAt: addedAtByItem[item.id],
          ),
      ];
    });
  }

  static const int _titlesQueryLimit = 200;

  Future<List<CollectionItem>> _toItems(List<ItemRow> rows) async {
    final itemIds = {for (final row in rows) row.id};
    final titleRows = rows.length > _titlesQueryLimit
        ? [for (final titleRow in await _database.select(_database.itemTitles).get()) if (itemIds.contains(titleRow.itemId)) titleRow]
        : await (_database.select(_database.itemTitles)..where((table) => table.itemId.isIn(itemIds))).get();
    final titlesByItem = <String, Map<String, String>>{};
    for (final titleRow in titleRows) {
      titlesByItem.putIfAbsent(titleRow.itemId, () => {})[titleRow.languageCode] = titleRow.title;
    }
    return [
      for (final row in rows)
        CollectionItem(
          id: row.id,
          categoryId: row.categoryId,
          seriesId: row.seriesId,
          volumeNumber: row.volumeNumber,
          titles: LocalizedTitles(
            byLanguage: titlesByItem[row.id] ?? const {},
            originalLanguage: row.originalLanguage,
          ),
          creator: row.creator,
          year: row.year,
          publisher: row.publisher,
          imagePath: row.imagePath,
          spineColorValue: row.spineColorValue,
          rating: row.rating,
          groupKey: row.groupKey,
          sourceKey: row.sourceKey,
          externalWorkId: row.externalWorkId,
          cardKind: row.cardKind == null ? null : CardKind.values.byName(row.cardKind!),
          progress: switch (row.progressStatus) {
            final status? => ItemProgress(status: ProgressStatus.values.byName(status), chapter: row.progressChapter, page: row.progressPage),
            null => null,
          },
          addedAt: row.createdAt,
          marketValue: switch ((row.marketValueCents, row.marketValueCurrency, row.marketValuedAt)) {
            (final cents?, final currency?, final valuedAt?) => MarketValue(cents: cents, currency: currency, valuedAt: valuedAt),
            _ => null,
          },
          preorder: switch (row.preorderDueOn) {
            final dueOn? => Preorder(dueOn: dueOn, depositCents: row.preorderDepositCents),
            null => null,
          },
        ),
    ];
  }

  @override
  Future<void> savePreorder(String itemId, Preorder? preorder) => (_database.update(_database.items)..where((table) => table.id.equals(itemId)))
      .write(ItemsCompanion(preorderDueOn: Value(preorder?.dueOn), preorderDepositCents: Value(preorder?.depositCents)));

  Future<List<Series>> _toSeries(List<SeriesRow> rows) async {
    final titleRows = await (_database.select(_database.seriesTitles)..where((table) => table.seriesId.isIn(rows.map((row) => row.id)))).get();
    final titlesBySeries = <String, Map<String, String>>{};
    for (final titleRow in titleRows) {
      titlesBySeries.putIfAbsent(titleRow.seriesId, () => {})[titleRow.languageCode] = titleRow.title;
    }
    return [
      for (final row in rows)
        Series(
          id: row.id,
          categoryId: row.categoryId,
          titles: LocalizedTitles(
            byLanguage: titlesBySeries[row.id] ?? const {},
            originalLanguage: row.originalLanguage,
          ),
          creator: row.creator,
          publishedVolumes: row.publishedVolumes,
          sourceKey: row.sourceKey,
          externalWorkId: row.externalWorkId,
          status: row.status,
        ),
    ];
  }
}
