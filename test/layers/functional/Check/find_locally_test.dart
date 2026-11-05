import 'package:akashic/layers/functional/Check/domain/entities/check_verdict.dart';
import 'package:akashic/layers/functional/Check/domain/use_cases/find_locally.dart';
import 'package:akashic/layers/functional/Check/domain/use_cases/normalize_barcode.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/collection_item.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/item_copy.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/localized_titles.dart';
import 'package:flutter_test/flutter_test.dart';

import '../Collection/collection_harness.dart';

void main() {
  test('upc and ean forms of the same disc normalize identically', () {
    expect(normalizeBarcode('074646093822'), '0074646093822');
    expect(normalizeBarcode('0074646093822'), '0074646093822');
    expect(normalizeBarcode(' 0 74646 09382 2 '), '0074646093822');
  });

  test('an isbn-10 becomes its isbn-13 and garbage is refused', () {
    expect(normalizeBarcode('0-306-40615-2'), '9780306406157');
    expect(normalizeBarcode('080442957X'), '9780804429573');
    expect(normalizeBarcode('12345'), isNull);
    expect(normalizeBarcode('abc'), isNull);
  });

  test('a copy barcode is found whatever its stored form', () async {
    final harness = CollectionHarness();
    final vinyls = await harness.vinyls();
    await harness.collection.saveItem(CollectionItem(id: 'kob', categoryId: vinyls.id, titles: const LocalizedTitles(byLanguage: {'en': 'Kind of Blue'})));
    await harness.collection.saveCopy(const ItemCopy(id: 'a', itemId: 'kob', barcode: '074646093822'));
    await harness.collection.saveCopy(const ItemCopy(id: 'b', itemId: 'kob', edition: 'Reissue'));
    final verdict = await FindLocally(harness.collection).byBarcode('0074646093822');
    expect(verdict, isA<Owned>());
    expect(verdict!.item.id, 'kob');
    expect(verdict.copies, hasLength(2));
    expect(await FindLocally(harness.collection).byBarcode('0000000000017'), isNull);
    await harness.database.close();
  });

  test('exact title matches come first', () async {
    final harness = CollectionHarness();
    final vinyls = await harness.vinyls();
    await harness.collection.saveItem(CollectionItem(id: 'live', categoryId: vinyls.id, titles: const LocalizedTitles(byLanguage: {'en': 'Kind of Blue Live'})));
    await harness.collection.saveItem(CollectionItem(id: 'studio', categoryId: vinyls.id, titles: const LocalizedTitles(byLanguage: {'en': 'Kind of Blue'})));
    final results = await FindLocally(harness.collection).byText('kind of blue');
    expect(results.map((item) => item.id), ['studio', 'live']);
    await harness.database.close();
  });
}
