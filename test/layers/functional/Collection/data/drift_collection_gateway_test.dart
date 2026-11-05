import 'package:akashic/layers/functional/Catalog/domain/entities/category_type.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/collection_item.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/item_condition.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/item_copy.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/card_kind.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/localized_titles.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/series.dart';
import 'package:flutter_test/flutter_test.dart';

import '../collection_harness.dart';

void main() {
  late CollectionHarness harness;

  setUp(() => harness = CollectionHarness());
  tearDown(() => harness.database.close());

  test('watchItemsInCategoryTree includes subcategory items', () async {
    final vinyls = await harness.vinyls();
    final jazz = await harness.createCategory(name: 'Jazz', colorValue: 0, type: CategoryType.music, parentId: vinyls.id);
    await harness.collection.saveItem(CollectionItem(
      id: 'kind-of-blue',
      categoryId: jazz.id,
      titles: const LocalizedTitles(byLanguage: {'en': 'Kind of Blue'}, originalLanguage: 'en'),
      creator: 'Miles Davis',
    ));
    final items = await harness.collection.watchItemsInCategoryTree(vinyls.id).first;
    expect(items.single.titles.byLanguage, {'en': 'Kind of Blue'});
    expect(items.single.creator, 'Miles Davis');
  });

  test('a copy keeps its conditions per part', () async {
    final vinyls = await harness.vinyls();
    await harness.collection.saveItem(CollectionItem(id: 'kob', categoryId: vinyls.id, titles: const LocalizedTitles(byLanguage: {'en': 'Kind of Blue'})));
    await harness.collection.saveCopy(const ItemCopy(
      id: 'copy',
      itemId: 'kob',
      edition: 'Réédition 2015, 180 g',
      pricePaidCents: 2800,
      location: 'Bac 2, salon',
      conditions: {'Disque': ItemCondition.veryGood, 'Pochette': ItemCondition.good},
    ));
    final copies = await harness.collection.watchCopies('kob').first;
    expect(copies.single.conditions, {'Disque': ItemCondition.veryGood, 'Pochette': ItemCondition.good});
    expect(copies.single.pricePaidCents, 2800);
  });

  test('copies are found by barcode', () async {
    final vinyls = await harness.vinyls();
    await harness.collection.saveItem(CollectionItem(id: 'kob', categoryId: vinyls.id, titles: const LocalizedTitles(byLanguage: {'en': 'Kind of Blue'})));
    await harness.collection.saveCopy(const ItemCopy(id: 'copy', itemId: 'kob', barcode: '4547366033267', externalEditionId: 'release-1'));
    final found = await harness.collection.findCopiesByBarcode('4547366033267');
    expect(found.single.$1.id, 'kob');
    expect(found.single.$2.externalEditionId, 'release-1');
    expect(await harness.collection.findCopiesByBarcode('0000000000000'), isEmpty);
  });

  test('items are found by source work id', () async {
    final vinyls = await harness.vinyls();
    await harness.collection.saveItem(CollectionItem(
      id: 'kob',
      categoryId: vinyls.id,
      titles: const LocalizedTitles(byLanguage: {'en': 'Kind of Blue'}),
      sourceKey: 'musicbrainz',
      externalWorkId: '8e8a594f-2175-38c7-a871-abb68ec363e7',
    ));
    expect((await harness.collection.findByExternalWork('musicbrainz', '8e8a594f-2175-38c7-a871-abb68ec363e7'))?.id, 'kob');
    expect(await harness.collection.findByExternalWork('discogs', '8e8a594f-2175-38c7-a871-abb68ec363e7'), isNull);
  });

  test('series keep their source ids and status and items keep their card kind', () async {
    final mangas = await harness.mangas();
    await harness.collection.saveSeries(Series(
      id: 'frieren',
      categoryId: mangas.id,
      titles: const LocalizedTitles(byLanguage: {'fr': 'Frieren'}),
      publishedVolumes: 13,
      sourceKey: 'anilist',
      externalWorkId: '118586',
      status: 'RELEASING',
    ));
    final series = (await harness.collection.watchSeriesInCategoryTree(mangas.id).first).single;
    expect(series.externalWorkId, '118586');
    expect(series.status, 'RELEASING');
    await harness.collection.saveItem(CollectionItem(id: 'deck', categoryId: mangas.id, titles: const LocalizedTitles(byLanguage: {'en': 'Deck'}), cardKind: CardKind.deck));
    expect((await harness.collection.watchItem('deck').first)!.cardKind, CardKind.deck);
  });
}
