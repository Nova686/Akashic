import 'package:akashic/layers/functional/Collection/domain/entities/collection_item.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/localized_titles.dart';
import 'package:flutter_test/flutter_test.dart';

import 'collection_harness.dart';

void main() {
  test('a large collection loads every item with its titles, and the owned volumes per series', () async {
    final harness = CollectionHarness();
    addTearDown(harness.database.close);
    final mangas = await harness.mangas();
    for (var index = 0; index < 260; index++) {
      await harness.collection.saveItem(CollectionItem(id: 'item-$index', categoryId: mangas.id, titles: LocalizedTitles(byLanguage: {'fr': 'Titre $index', 'en': 'Title $index'})));
    }
    final items = await harness.collection.allItems();
    expect(items, hasLength(260));
    expect(items.firstWhere((item) => item.id == 'item-259').titles.byLanguage, {'fr': 'Titre 259', 'en': 'Title 259'});
    expect(await harness.collection.ownedVolumesBySeries(), isEmpty);
  });
}
