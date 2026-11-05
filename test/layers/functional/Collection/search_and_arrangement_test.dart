import 'package:akashic/layers/functional/Collection/domain/entities/collection_item.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/item_copy.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/localized_titles.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/shelf_group.dart';
import 'package:akashic/layers/functional/Collection/domain/use_cases/arrange_shelf.dart';
import 'package:akashic/layers/functional/Collection/domain/use_cases/search_collection.dart';
import 'package:akashic/layers/functional/Settings/domain/entities/preferred_languages.dart';
import 'package:akashic/layers/functional/Settings/domain/use_cases/manage_recent_searches.dart';
import 'package:flutter_test/flutter_test.dart';

import 'collection_harness.dart';

void main() {
  test('the collection search reads locations, editions and volumes, exact titles first', () async {
    final harness = CollectionHarness();
    addTearDown(harness.database.close);
    final mangas = await harness.mangas();
    Future<void> add(String id, String title, {int? volume, String? location, String? edition}) async {
      await harness.collection.saveItem(CollectionItem(id: id, categoryId: mangas.id, titles: LocalizedTitles(byLanguage: {'fr': title}), volumeNumber: volume));
      await harness.collection.saveCopy(ItemCopy(id: '$id-copy', itemId: id, location: location, edition: edition, barcode: '978234405141$id'.substring(0, 13)));
    }
    await add('1', 'One Piece Party', location: 'Tiroir bleu');
    await add('2', 'One Piece', volume: 104, edition: 'Collector');
    await add('3', 'Le monde de One Piece', location: 'Salon');
    final search = SearchCollection(harness.collection);
    expect((await search('one piece')).map((item) => item.id), ['2', '1', '3']);
    expect((await search('tiroir')).map((item) => item.id), ['1']);
    expect((await search('collector')).map((item) => item.id), ['2']);
    expect((await search('one piece 104')).map((item) => item.id), ['2']);
    expect(await search('   '), isEmpty);
  });

  test('recent searches keep the last four, newest first, without duplicates', () async {
    final harness = CollectionHarness();
    addTearDown(harness.database.close);
    final recent = ManageRecentSearches(harness.settings);
    for (final query in ['zelda', 'miles', 'Zelda', 'tiroir', 'frieren', 'dune']) {
      await recent.remember(query);
    }
    expect(await recent.watch().first, ['dune', 'frieren', 'tiroir', 'Zelda']);
    await recent.forget('tiroir');
    expect(await recent.watch().first, ['dune', 'frieren', 'Zelda']);
  });

  test('shelves sort by price paid or location and filter on sealing, loans and location', () {
    CollectionItem item(String id) => CollectionItem(id: id, categoryId: 'cards', titles: LocalizedTitles(byLanguage: {'fr': 'Produit $id'}));
    final groups = [ShelfGroup(id: 'all', label: '', entries: [for (final id in ['a', 'b', 'c']) ShelfItem(item(id))], isSeries: false, ownedCount: 3)];
    final copies = {
      'a': const ItemCopy(id: 'ca', itemId: 'a', pricePaidCents: 4500, location: 'Vitrine', isOpened: true),
      'b': const ItemCopy(id: 'cb', itemId: 'b', pricePaidCents: 15000, location: 'Placard', loanedTo: 'Camille'),
      'c': const ItemCopy(id: 'cc', itemId: 'c', pricePaidCents: 800),
    };
    List<String> idsOf(List<ShelfGroup> arranged) => [for (final group in arranged) for (final entry in group.entries) if (entry case ShelfItem(:final item)) item.id];
    List<ShelfGroup> arrange(ShelfSort sort, [ShelfFilter filter = const ShelfFilter()]) => arrangeShelf(groups, sort: sort, filter: filter, languages: PreferredLanguages.defaults, copies: copies);
    final byPrice = arrange(ShelfSort.pricePaid);
    expect(idsOf(byPrice), ['b', 'a', 'c']);
    expect(byPrice.map((group) => group.label), ['> 100 €', '30 – 100 €', '< 10 €']);
    expect(idsOf(arrange(ShelfSort.location)), ['b', 'a', 'c']);
    expect(idsOf(arrange(ShelfSort.title, const ShelfFilter(sealing: SealingFilter.sealed))), ['b', 'c']);
    expect(idsOf(arrange(ShelfSort.title, const ShelfFilter(sealing: SealingFilter.opened))), ['a']);
    expect(idsOf(arrange(ShelfSort.title, const ShelfFilter(onlyLent: true))), ['b']);
    expect(idsOf(arrange(ShelfSort.bySeries, const ShelfFilter(location: 'Vitrine'))), ['a']);
    expect(const ShelfFilter(onlyLent: true, location: 'Vitrine').activeCount, 2);
  });
}
