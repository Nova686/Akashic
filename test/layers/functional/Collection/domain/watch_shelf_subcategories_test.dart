import 'package:akashic/layers/functional/Catalog/domain/entities/category_type.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/collection_item.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/localized_titles.dart';
import 'package:akashic/layers/functional/Collection/domain/use_cases/watch_shelf.dart';
import 'package:flutter_test/flutter_test.dart';

import '../collection_harness.dart';
import 'collection_fixtures.dart';

void main() {
  test('a parent shelf lays its subcategories one after the other with a blank gap between them', () async {
    final harness = CollectionHarness();
    addTearDown(harness.database.close);
    final tcg = await harness.createCategory(name: 'TCG', colorValue: 0, type: CategoryType.cards, conditionParts: const ['Objet']);
    final pokemon = await harness.createCategory(name: 'Pokémon', colorValue: 0, type: CategoryType.cards, parentId: tcg.id, conditionParts: const ['Objet']);
    final lorcana = await harness.createCategory(name: 'Lorcana', colorValue: 0, type: CategoryType.cards, parentId: tcg.id, conditionParts: const ['Objet']);
    await harness.collection.saveItem(CollectionItem(id: 'lorcana-deck', categoryId: lorcana.id, titles: const LocalizedTitles(byLanguage: {'en': 'Amber Deck'})));
    await harness.collection.saveItem(CollectionItem(id: 'pikachu', categoryId: pokemon.id, titles: const LocalizedTitles(byLanguage: {'en': 'Pikachu Box'})));
    await harness.collection.saveItem(CollectionItem(id: 'charizard', categoryId: pokemon.id, titles: const LocalizedTitles(byLanguage: {'en': 'Charizard Box'})));
    final groups = await WatchShelf(harness.collection, harness.categories, harness.settings)(tcg.id).first;
    expect([for (final group in groups) ...group.entries.map(describe)], ['item:charizard', 'item:pikachu', 'gap', 'item:lorcana-deck']);
  });
}
