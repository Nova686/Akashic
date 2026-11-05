import 'package:akashic/layers/functional/Collection/domain/entities/collection_item.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/item_copy.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/localized_titles.dart';
import 'package:akashic/layers/functional/Collection/domain/use_cases/delete_copy.dart';
import 'package:flutter_test/flutter_test.dart';

import 'collection_harness.dart';

void main() {
  late CollectionHarness harness;
  late List<String> deletedImages;
  late DeleteCopy deleteCopy;

  setUp(() async {
    harness = CollectionHarness();
    deletedImages = [];
    deleteCopy = DeleteCopy(harness.collection, deleteImage: (path) async => deletedImages.add(path));
    final vinyls = await harness.vinyls();
    await harness.collection.saveItem(CollectionItem(id: 'kob', categoryId: vinyls.id, titles: const LocalizedTitles(byLanguage: {'en': 'Kind of Blue'}), imagePath: '/covers/kob.jpg'));
  });
  tearDown(() => harness.database.close());

  test('deleting one of several copies keeps the item and its other copies', () async {
    const first = ItemCopy(id: 'first', itemId: 'kob', edition: '1959');
    const second = ItemCopy(id: 'second', itemId: 'kob', edition: '2015', loanedTo: 'Camille');
    await harness.collection.saveCopy(first);
    await harness.collection.saveCopy(second);
    expect(await deleteCopy.isLastCopy(second), isFalse);
    expect(await deleteCopy(second), CopyDeletion.copyOnly);
    expect((await harness.collection.watchCopies('kob').first).map((copy) => copy.id), ['first']);
    expect(await harness.collection.watchItem('kob').first, isNotNull);
    expect(deletedImages, isEmpty);
  });

  test('deleting the last copy removes the whole item and its cover', () async {
    const only = ItemCopy(id: 'only', itemId: 'kob');
    await harness.collection.saveCopy(only);
    expect(await deleteCopy.isLastCopy(only), isTrue);
    expect(await deleteCopy(only), CopyDeletion.wholeItem);
    expect(await harness.collection.watchItem('kob').first, isNull);
    expect(await harness.collection.watchCopies('kob').first, isEmpty);
    expect(await harness.collection.allItems(), isEmpty);
    expect(deletedImages, ['/covers/kob.jpg']);
  });
}
