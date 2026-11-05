import 'dart:typed_data';

import 'package:akashic/layers/functional/Catalog/domain/entities/category_type.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/collection_item.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/item_copy.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/localized_titles.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/series.dart';
import 'package:akashic/layers/functional/Collection/domain/use_cases/bulk_item_actions.dart';
import 'package:akashic/layers/functional/Collection/domain/use_cases/manage_item_photos.dart';
import 'package:akashic/layers/functional/Collection/domain/use_cases/move_item.dart';
import 'package:akashic/layers/functional/Loans/data/gateways/drift_loan_gateway.dart';
import 'package:flutter_test/flutter_test.dart';

import 'collection_harness.dart';

void main() {
  late CollectionHarness harness;
  late List<String> deletedImages;
  late BulkItemActions bulkActions;
  late String shonenId;
  late String seinenId;

  setUp(() async {
    harness = CollectionHarness();
    deletedImages = [];
    bulkActions = BulkItemActions(harness.collection, deleteImage: (path) async => deletedImages.add(path));
    final mangas = await harness.mangas();
    shonenId = (await harness.createCategory(name: 'Shōnen', colorValue: 0, type: CategoryType.manga, parentId: mangas.id)).id;
    seinenId = (await harness.createCategory(name: 'Seinen', colorValue: 0, type: CategoryType.manga, parentId: mangas.id)).id;
    await harness.collection.saveSeries(Series(id: 'berserk', categoryId: shonenId, titles: const LocalizedTitles(byLanguage: {'fr': 'Berserk'})));
    for (final volume in [1, 2]) {
      await harness.collection.saveItem(CollectionItem(id: 'berserk-$volume', categoryId: shonenId, seriesId: 'berserk', volumeNumber: volume, titles: LocalizedTitles(byLanguage: {'fr': 'Berserk $volume'}), imagePath: '/images/berserk-$volume.jpg'));
      await harness.collection.saveCopy(ItemCopy(id: 'berserk-$volume-copy', itemId: 'berserk-$volume', barcode: '978000000000$volume'));
    }
  });
  tearDown(() => harness.database.close());

  Future<List<CollectionItem>> volumes() async => [for (final itemId in ['berserk-1', 'berserk-2']) (await harness.collection.watchItem(itemId).first)!];

  test('selected volumes move their series once', () async {
    await bulkActions.move(await volumes(), targetCategoryId: seinenId, seriesMove: SeriesMove.wholeSeries);
    expect((await volumes()).map((item) => item.categoryId), [seinenId, seinenId]);
    expect((await harness.collection.watchSeriesInCategoryTree(seinenId).first).single.id, 'berserk');
  });

  test('the storage location changes on every copy and keeps loans and barcodes', () async {
    await DriftLoanGateway(harness.database).lend('berserk-1-copy', borrower: 'Camille', since: DateTime(2026, 10, 1));
    await bulkActions.storeAt(await volumes(), '  Étagère du salon ');
    final firstCopy = (await harness.collection.watchCopies('berserk-1').first).single;
    expect(firstCopy.location, 'Étagère du salon');
    expect(firstCopy.loanedTo, 'Camille');
    expect(firstCopy.barcode, '9780000000001');
    expect((await harness.collection.watchCopies('berserk-2').first).single.location, 'Étagère du salon');
  });

  test('deleting the selection removes the items with their covers and photos', () async {
    final managePhotos = ManageItemPhotos(harness.collection, storeImage: (bytes) async => '/images/photo.jpg', deleteImage: (path) async {}, newId: harness.newId);
    await managePhotos.add('berserk-2', Uint8List(1));
    await bulkActions.delete(await volumes());
    expect(await harness.collection.allItems(), isEmpty);
    expect(deletedImages, ['/images/berserk-1.jpg', '/images/berserk-2.jpg', '/images/photo.jpg']);
  });
}
