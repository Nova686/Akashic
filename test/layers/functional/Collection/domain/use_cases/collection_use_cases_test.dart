import 'package:akashic/layers/functional/Catalog/domain/entities/category_type.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/collection_item.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/localized_titles.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/series.dart';
import 'package:akashic/layers/functional/Collection/domain/use_cases/add_item.dart';
import 'package:akashic/layers/functional/Collection/domain/use_cases/add_series_volumes.dart';
import 'package:akashic/layers/functional/Collection/domain/use_cases/search_collection.dart';
import 'package:akashic/layers/functional/Collection/domain/use_cases/watch_shelf.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../collection_harness.dart';

void main() {
  late CollectionHarness harness;
  late AddItem addItem;
  late AddSeriesVolumes addSeriesVolumes;

  setUp(() {
    harness = CollectionHarness();
    addItem = AddItem(harness.collection, harness.categories, newId: harness.newId);
    addSeriesVolumes = AddSeriesVolumes(harness.collection, newId: harness.newId);
  });
  tearDown(() => harness.database.close());

  Series frierenIn(String categoryId) => Series(
        id: 'frieren',
        categoryId: categoryId,
        titles: const LocalizedTitles(byLanguage: {'fr': 'Frieren'}, originalLanguage: 'ja'),
      );

  test('add item creates a first empty copy', () async {
    final vinyls = await harness.vinyls();
    await addItem(CollectionItem(id: 'kob', categoryId: vinyls.id, titles: const LocalizedTitles(byLanguage: {'en': 'Kind of Blue'})));
    final copies = await harness.collection.watchCopies('kob').first;
    expect(copies, hasLength(1));
    expect(copies.single.edition, isNull);
  });

  test('add item refuses a category that has subcategories', () async {
    final vinyls = await harness.vinyls();
    await harness.createCategory(name: 'Jazz', colorValue: 0, type: CategoryType.music, parentId: vinyls.id);
    expect(
      () => addItem(CollectionItem(id: 'kob', categoryId: vinyls.id, titles: const LocalizedTitles(byLanguage: {'en': 'Kind of Blue'}))),
      throwsA(isA<ItemNeedsLeafCategory>()),
    );
  });

  test('adding volumes 1 to 9 when 3 and 5 exist creates only the 7 missing ones', () async {
    final mangas = await harness.mangas();
    final series = frierenIn(mangas.id);
    await harness.collection.saveSeries(series);
    final template = CollectionItem(id: 'template', categoryId: mangas.id, titles: series.titles, seriesId: series.id, creator: 'Kanehito Yamada');
    await addSeriesVolumes(series: series, from: 3, to: 3, template: template);
    await addSeriesVolumes(series: series, from: 5, to: 5, template: template);

    final created = await addSeriesVolumes(series: series, from: 1, to: 9, template: template);

    expect(created, [1, 2, 4, 6, 7, 8, 9]);
    expect(await harness.collection.volumeNumbersOf(series.id), {1, 2, 3, 4, 5, 6, 7, 8, 9});
    final items = await harness.collection.allItems();
    expect(items.every((item) => item.creator == 'Kanehito Yamada'), isTrue);
  });

  test('a reversed or zero volume range is refused', () async {
    final mangas = await harness.mangas();
    final series = frierenIn(mangas.id);
    final template = CollectionItem(id: 'template', categoryId: mangas.id, titles: series.titles, seriesId: series.id);
    expect(() => addSeriesVolumes(series: series, from: 5, to: 2, template: template), throwsA(isA<InvalidVolumeRange>()));
    expect(() => addSeriesVolumes(series: series, from: 0, to: 2, template: template), throwsA(isA<InvalidVolumeRange>()));
  });

  test('search finds an item by its english title when preferred languages are fr then en', () async {
    final vinyls = await harness.vinyls();
    await addItem(CollectionItem(id: 'hobbit', categoryId: vinyls.id, titles: const LocalizedTitles(byLanguage: {'fr': 'Le Hobbit', 'en': 'The Hobbit'})));
    final results = await SearchCollection(harness.collection)('the hobbit');
    expect(results.map((item) => item.id), ['hobbit']);
  });

  test('watch shelf groups the items of a category with the stored preferred languages', () async {
    final mangas = await harness.mangas();
    final series = frierenIn(mangas.id);
    await harness.collection.saveSeries(series);
    final template = CollectionItem(id: 'template', categoryId: mangas.id, titles: series.titles, seriesId: series.id);
    await addSeriesVolumes(series: series, from: 1, to: 2, template: template);
    final groups = await WatchShelf(harness.collection, harness.categories, harness.settings)(mangas.id).first;
    expect(groups.single.label, 'Frieren');
    expect(groups.single.ownedCount, 2);
  });
}
