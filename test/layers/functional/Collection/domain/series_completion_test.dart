import 'package:akashic/layers/functional/Catalog/domain/entities/category_type.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/localized_titles.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/series.dart';
import 'package:akashic/layers/functional/Collection/domain/use_cases/group_items_on_shelf.dart';
import 'package:akashic/layers/functional/Collection/domain/use_cases/series_completion.dart';
import 'package:akashic/layers/functional/Collection/domain/use_cases/update_series_from_source.dart';
import 'package:akashic/layers/functional/Lookup/data/sources/anilist_source.dart';
import 'package:akashic/layers/functional/Settings/domain/entities/preferred_languages.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../Lookup/data/fixture_client.dart';
import '../collection_harness.dart';
import 'collection_fixtures.dart';

Series seriesWith({int? published, String? status}) => Series(
      id: 'frieren',
      categoryId: 'mangas',
      titles: const LocalizedTitles(byLanguage: {'fr': 'Frieren'}),
      publishedVolumes: published,
      status: status,
      sourceKey: 'anilist',
      externalWorkId: '118586',
    );

void main() {
  test('a releasing series with unknown volume count uses the highest owned volume and shows the next one as unreleased', () {
    final completion = computeSeriesCompletion(seriesWith(status: 'RELEASING'), {1, 2, 5});
    expect(completion.published, 5);
    expect(completion.missing, [3, 4]);
    expect(completion.nextUnreleased, 6);
    expect(completion.isComplete, isFalse);
  });

  test('a finished series with 13 volumes lists all missing ones', () {
    final completion = computeSeriesCompletion(seriesWith(published: 13, status: 'FINISHED'), {1, 2, 3, 5, 6, 8, 9, 10, 11, 12, 13});
    expect(completion.missing, [4, 7]);
    expect(completion.nextUnreleased, isNull);
    expect(computeSeriesCompletion(seriesWith(published: 2, status: 'FINISHED'), {1, 2}).isComplete, isTrue);
  });

  test('shelf holes extend to the published count', () {
    final groups = groupItemsOnShelf([vol(1), vol(2)], [seriesWith(published: 4)], CategoryType.manga, PreferredLanguages.defaults);
    expect(groups.single.entries.map(describe).skip(1), ['item:1', 'item:2', 'missing:3', 'missing:4']);
  });

  test('updating from anilist sets status but never lowers the count under the highest owned volume', () async {
    final harness = CollectionHarness();
    final mangas = await harness.mangas();
    final series = Series(id: 'frieren', categoryId: mangas.id, titles: const LocalizedTitles(byLanguage: {'fr': 'Frieren'}), sourceKey: 'anilist', externalWorkId: '118586', publishedVolumes: 14);
    await harness.collection.saveSeries(series);
    final source = AniListSource(clientReturning('{"data":{"Media":{"id":118586,"volumes":null,"status":"RELEASING"}}}'));
    final updated = await UpdateSeriesFromSource(harness.collection, source)(series, ownedVolumes: {1, 14});
    expect(updated.status, 'RELEASING');
    expect(updated.publishedVolumes, 14);
    final finished = AniListSource(clientReturning('{"data":{"Media":{"id":118586,"volumes":13,"status":"FINISHED"}}}'));
    expect((await UpdateSeriesFromSource(harness.collection, finished)(series, ownedVolumes: {1, 14})).publishedVolumes, 14);
    expect((await UpdateSeriesFromSource(harness.collection, finished)(series, ownedVolumes: {1, 2})).publishedVolumes, 13);
    await harness.database.close();
  });
}
