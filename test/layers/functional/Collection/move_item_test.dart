import 'package:akashic/layers/functional/Catalog/domain/entities/category_type.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/collection_item.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/localized_titles.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/series.dart';
import 'package:akashic/layers/functional/Collection/domain/use_cases/move_item.dart';
import 'package:flutter_test/flutter_test.dart';

import 'collection_harness.dart';

void main() {
  late CollectionHarness harness;
  late MoveItem moveItem;
  late String shonenId;
  late String seinenId;

  setUp(() async {
    harness = CollectionHarness();
    moveItem = MoveItem(harness.collection);
    final mangas = await harness.mangas();
    shonenId = (await harness.createCategory(name: 'Shōnen', colorValue: 0, type: CategoryType.manga, parentId: mangas.id)).id;
    seinenId = (await harness.createCategory(name: 'Seinen', colorValue: 0, type: CategoryType.manga, parentId: mangas.id)).id;
    await harness.collection.saveSeries(Series(id: 'berserk', categoryId: shonenId, titles: const LocalizedTitles(byLanguage: {'fr': 'Berserk'})));
    for (final volume in [1, 2]) {
      await harness.collection.saveItem(CollectionItem(id: 'berserk-$volume', categoryId: shonenId, seriesId: 'berserk', volumeNumber: volume, titles: LocalizedTitles(byLanguage: {'fr': 'Berserk $volume'})));
    }
    await harness.collection.saveItem(CollectionItem(id: 'artbook', categoryId: shonenId, titles: const LocalizedTitles(byLanguage: {'fr': 'Artbook'})));
  });
  tearDown(() => harness.database.close());

  Future<CollectionItem> itemOf(String itemId) async => (await harness.collection.watchItem(itemId).first)!;

  test('an item without series simply changes category', () async {
    await moveItem(await itemOf('artbook'), targetCategoryId: seinenId);
    expect((await itemOf('artbook')).categoryId, seinenId);
  });

  test('moving the whole series takes every volume and the series along', () async {
    await moveItem(await itemOf('berserk-1'), targetCategoryId: seinenId, seriesMove: SeriesMove.wholeSeries);
    expect((await itemOf('berserk-1')).categoryId, seinenId);
    expect((await itemOf('berserk-2')).categoryId, seinenId);
    expect((await harness.collection.watchSeriesInCategoryTree(seinenId).first).single.id, 'berserk');
  });

  test('moving one volume alone takes it out of its series', () async {
    await moveItem(await itemOf('berserk-2'), targetCategoryId: seinenId);
    final moved = await itemOf('berserk-2');
    expect(moved.categoryId, seinenId);
    expect(moved.seriesId, isNull);
    expect(moved.volumeNumber, isNull);
    expect((await itemOf('berserk-1')).seriesId, 'berserk');
  });
}
