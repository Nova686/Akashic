import 'dart:async';

import 'package:akashic/layers/functional/Catalog/domain/entities/category_type.dart';
import 'package:akashic/layers/functional/Catalog/domain/use_cases/watch_category_tree.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/collection_item.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/localized_titles.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/series.dart';
import 'package:akashic/layers/functional/Collection/domain/use_cases/add_series_volumes.dart';
import 'package:akashic/layers/functional/Collection/domain/use_cases/search_collection.dart';
import 'package:akashic/layers/functional/Collection/domain/use_cases/watch_shelf.dart';
import 'package:akashic/layers/functional/Collection/presentation/cubit/category_shelves_cubit.dart';
import 'package:akashic/layers/functional/Collection/presentation/cubit/category_shelves_state.dart';
import 'package:akashic/layers/functional/Collection/presentation/cubit/home_shelves_cubit.dart';
import 'package:akashic/layers/functional/Collection/presentation/cubit/home_shelves_state.dart';
import 'package:akashic/layers/functional/Settings/domain/use_cases/manage_collapsed_series.dart';
import 'package:akashic/layers/functional/Settings/domain/use_cases/manage_preferred_languages.dart';
import 'package:flutter_test/flutter_test.dart';

import '../collection_harness.dart';

void main() {
  late CollectionHarness harness;

  setUp(() => harness = CollectionHarness());
  tearDown(() => harness.database.close());

  Future<Series> seedFrieren(String categoryId, List<int> volumes) async {
    final series = Series(id: 'frieren', categoryId: categoryId, titles: const LocalizedTitles(byLanguage: {'fr': 'Frieren'}));
    await harness.collection.saveSeries(series);
    final template = CollectionItem(id: 'template', categoryId: categoryId, titles: series.titles, seriesId: series.id);
    final addVolumes = AddSeriesVolumes(harness.collection, newId: harness.newId);
    for (final volume in volumes) {
      await addVolumes(series: series, from: volume, to: volume, template: template);
    }
    return series;
  }

  CategoryShelvesCubit categoryShelves(String categoryId) => CategoryShelvesCubit(
        categoryId: categoryId,
        watchCategoryTree: WatchCategoryTree(harness.categories),
        watchShelf: WatchShelf(harness.collection, harness.categories, harness.settings),
        collapsedSeries: ManageCollapsedSeries(harness.settings),
      );

  test('home counts incomplete series per category', () async {
    final mangas = await harness.mangas();
    await seedFrieren(mangas.id, [1, 2, 3, 5]);
    final home = HomeShelvesCubit(
      watchCategoryTree: WatchCategoryTree(harness.categories),
      watchShelf: WatchShelf(harness.collection, harness.categories, harness.settings),
      searchCollection: SearchCollection(harness.collection),
      preferredLanguages: ManagePreferredLanguages(harness.settings),
      collapsedSeries: ManageCollapsedSeries(harness.settings),
    )..start();
    await expectLater(home.stream, emitsThrough(predicate<HomeShelvesState>((state) => state.shelves.isNotEmpty && state.shelves.single.groups.isNotEmpty)));
    expect(home.state.shelves.single.incompleteSeriesCount, 1);
    expect(home.state.totalItems, 4);
    await home.close();
  });

  test('typing quickly in the home search reads the collection once, for the last text', () async {
    final mangas = await harness.mangas();
    await seedFrieren(mangas.id, [1]);
    final searchCollection = CountingSearchCollection(SearchCollection(harness.collection));
    final home = HomeShelvesCubit(
      watchCategoryTree: WatchCategoryTree(harness.categories),
      watchShelf: WatchShelf(harness.collection, harness.categories, harness.settings),
      searchCollection: searchCollection,
      preferredLanguages: ManagePreferredLanguages(harness.settings),
      collapsedSeries: ManageCollapsedSeries(harness.settings),
      searchDelay: const Duration(milliseconds: 30),
    );
    unawaited(home.search('f'));
    unawaited(home.search('fr'));
    await home.search('fri');
    expect(searchCollection.queries, ['fri']);
    expect(home.state.searchResults, isNotEmpty);
    await home.close();
  });

  test('toggling a series persists the collapsed set', () async {
    final mangas = await harness.mangas();
    await seedFrieren(mangas.id, [1, 2]);
    final shelves = categoryShelves(mangas.id)..start();
    await expectLater(shelves.stream, emitsThrough(predicate<CategoryShelvesState>((state) => state.shelves.isNotEmpty && state.shelves.first.groups.isNotEmpty)));
    await shelves.toggleSeries('frieren');
    expect(await harness.settings.watchCollapsedSeries().first, {'frieren'});
    await shelves.toggleSeries('frieren');
    expect(await harness.settings.watchCollapsedSeries().first, isEmpty);
    await shelves.close();
  });

  test('fold all collapses every series of the screen and unfold all clears them', () async {
    final mangas = await harness.mangas();
    await seedFrieren(mangas.id, [1]);
    await harness.settings.saveCollapsedSeries({'elsewhere'});
    final shelves = categoryShelves(mangas.id)..start();
    await expectLater(shelves.stream, emitsThrough(predicate<CategoryShelvesState>((state) => state.shelves.isNotEmpty && state.shelves.first.groups.isNotEmpty)));
    await shelves.setAllSeriesCollapsed(true);
    expect(await harness.settings.watchCollapsedSeries().first, {'elsewhere', 'frieren'});
    await shelves.setAllSeriesCollapsed(false);
    expect(await harness.settings.watchCollapsedSeries().first, {'elsewhere'});
    await shelves.close();
  });

  test('a category with subcategories gets one shelf per subcategory', () async {
    final vinyls = await harness.vinyls();
    await harness.createCategory(name: 'Jazz', colorValue: 0, type: CategoryType.music, parentId: vinyls.id);
    await harness.createCategory(name: 'Rock', colorValue: 0, type: CategoryType.music, parentId: vinyls.id);
    final shelves = categoryShelves(vinyls.id)..start();
    await expectLater(shelves.stream, emitsThrough(predicate<CategoryShelvesState>((state) => state.shelves.length == 2)));
    expect(shelves.state.shelves.map((shelf) => shelf.category.name), ['Jazz', 'Rock']);
    await shelves.close();
  });
}

class CountingSearchCollection implements SearchCollection {
  CountingSearchCollection(this._inner);

  final SearchCollection _inner;
  final List<String> queries = [];

  @override
  Future<List<CollectionItem>> call(String query) {
    queries.add(query);
    return _inner(query);
  }
}
