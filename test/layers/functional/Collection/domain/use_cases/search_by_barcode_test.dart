import 'package:akashic/layers/functional/Collection/domain/entities/collection_item.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/item_copy.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/localized_titles.dart';
import 'package:akashic/layers/functional/Collection/domain/use_cases/search_collection.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../collection_harness.dart';

void main() {
  late CollectionHarness harness;
  late SearchCollection searchCollection;

  setUp(() async {
    harness = CollectionHarness();
    searchCollection = SearchCollection(harness.collection);
    final vinyls = await harness.vinyls();
    await harness.collection.saveItem(CollectionItem(id: 'kob', categoryId: vinyls.id, titles: const LocalizedTitles(byLanguage: {'en': 'Kind of Blue'})));
    await harness.collection.saveCopy(const ItemCopy(id: 'kob-1', itemId: 'kob', barcode: '0888751238211'));
    await harness.collection.saveCopy(const ItemCopy(id: 'kob-2', itemId: 'kob', barcode: '0888751238211'));
    await harness.collection.saveItem(CollectionItem(id: 'hobbit', categoryId: vinyls.id, titles: const LocalizedTitles(byLanguage: {'en': 'The Hobbit'})));
    await harness.collection.saveCopy(const ItemCopy(id: 'hobbit-1', itemId: 'hobbit', barcode: '9780547928227'));
  });
  tearDown(() => harness.database.close());

  test('a scanned barcode typed in the search finds its item once', () async {
    expect((await searchCollection('0888751238211')).map((item) => item.id), ['kob']);
  });

  test('a UPC-A, spaced or ISBN-10 form finds the stored barcode', () async {
    expect((await searchCollection('888751238211')).map((item) => item.id), ['kob']);
    expect((await searchCollection('978 0 547 92822 7')).map((item) => item.id), ['hobbit']);
    expect((await searchCollection('054792822X')).map((item) => item.id), ['hobbit']);
  });

  test('titles are still searched as before', () async {
    expect((await searchCollection('hobbit')).map((item) => item.id), ['hobbit']);
  });
}
