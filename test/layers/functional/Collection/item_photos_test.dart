import 'dart:typed_data';

import 'package:akashic/layers/functional/Collection/domain/entities/collection_item.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/item_copy.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/localized_titles.dart';
import 'package:akashic/layers/functional/Collection/domain/use_cases/delete_copy.dart';
import 'package:akashic/layers/functional/Collection/domain/use_cases/manage_item_photos.dart';
import 'package:flutter_test/flutter_test.dart';

import 'collection_harness.dart';

void main() {
  late CollectionHarness harness;
  late List<String> storedPaths;
  late List<String> deletedPaths;
  late ManageItemPhotos managePhotos;

  setUp(() async {
    harness = CollectionHarness();
    storedPaths = [];
    deletedPaths = [];
    var photoNumber = 0;
    managePhotos = ManageItemPhotos(
      harness.collection,
      storeImage: (bytes) async {
        final path = '/images/photo-${photoNumber++}.jpg';
        storedPaths.add(path);
        return path;
      },
      deleteImage: (path) async => deletedPaths.add(path),
      newId: harness.newId,
    );
    final vinyls = await harness.vinyls();
    await harness.collection.saveItem(CollectionItem(id: 'kob', categoryId: vinyls.id, titles: const LocalizedTitles(byLanguage: {'en': 'Kind of Blue'}), imagePath: '/images/cover.jpg'));
    await harness.collection.saveCopy(const ItemCopy(id: 'kob-1', itemId: 'kob'));
  });
  tearDown(() => harness.database.close());

  test('photos are added in order and deleting one removes its file', () async {
    await managePhotos.add('kob', Uint8List(1));
    await managePhotos.add('kob', Uint8List(1));
    final photos = await managePhotos.watch('kob').first;
    expect(photos.map((photo) => photo.path), ['/images/photo-0.jpg', '/images/photo-1.jpg']);
    expect(photos.map((photo) => photo.position), [0, 1]);
    await managePhotos.delete(photos.first);
    expect((await managePhotos.watch('kob').first).map((photo) => photo.path), ['/images/photo-1.jpg']);
    expect(deletedPaths, ['/images/photo-0.jpg']);
  });

  test('removing the item with its last copy also removes its photo files', () async {
    await managePhotos.add('kob', Uint8List(1));
    final removedImages = <String>[];
    await DeleteCopy(harness.collection, deleteImage: (path) async => removedImages.add(path))(const ItemCopy(id: 'kob-1', itemId: 'kob'));
    expect(removedImages, ['/images/cover.jpg', '/images/photo-0.jpg']);
    expect(await managePhotos.watch('kob').first, isEmpty);
  });

  test('a photo belongs to its copy, and removing that copy removes only its photos', () async {
    await harness.collection.saveCopy(const ItemCopy(id: 'kob-2', itemId: 'kob'));
    await managePhotos.add('kob', Uint8List(1), copyId: 'kob-1');
    await managePhotos.add('kob', Uint8List(1), copyId: 'kob-2');
    expect((await managePhotos.watch('kob').first).map((photo) => photo.copyId), ['kob-1', 'kob-2']);
    final removedImages = <String>[];
    expect(await DeleteCopy(harness.collection, deleteImage: (path) async => removedImages.add(path))(const ItemCopy(id: 'kob-2', itemId: 'kob')), CopyDeletion.copyOnly);
    expect(removedImages, ['/images/photo-1.jpg']);
    expect((await managePhotos.watch('kob').first).map((photo) => photo.copyId), ['kob-1']);
  });
}
