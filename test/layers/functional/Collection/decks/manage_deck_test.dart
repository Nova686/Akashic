import 'package:akashic/layers/functional/Catalog/domain/entities/category_type.dart';
import 'package:akashic/layers/functional/Collection/data/gateways/drift_deck_gateway.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/card_kind.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/collection_item.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/localized_titles.dart';
import 'package:akashic/layers/functional/Collection/domain/use_cases/manage_deck.dart';
import 'package:akashic/layers/functional/Lookup/data/sources/tcgdex_source.dart';
import 'package:akashic/layers/functional/Lookup/data/sources/scryfall_source.dart';
import 'package:akashic/layers/functional/Lookup/domain/entities/card_search_result.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../Lookup/data/fixture_client.dart';
import '../../Lookup/data/keyless_sources_test.dart' show tcgdexClient;
import '../collection_harness.dart';

const pikachu = CardSearchResult(name: 'Pikachu', externalCardId: 'sv03.5-025', setName: '151', imageUrl: 'https://assets.tcgdex.net/fr/sv/sv03.5/025/low.png');

void main() {
  late CollectionHarness harness;
  late ManageDeck manageDeck;

  setUp(() async {
    harness = CollectionHarness();
    manageDeck = ManageDeck(DriftDeckGateway(harness.database), newId: harness.newId);
    final tcg = await harness.createCategory(name: 'TCG', colorValue: 0, type: CategoryType.cards, conditionParts: const ['Objet']);
    await harness.collection.saveItem(CollectionItem(id: 'deck', categoryId: tcg.id, titles: const LocalizedTitles(byLanguage: {'fr': 'Deck électrique'}), cardKind: CardKind.deck));
  });
  tearDown(() => harness.database.close());

  test('adding the same card twice gives quantity 2', () async {
    await manageDeck.add('deck', pikachu);
    await manageDeck.add('deck', pikachu);
    final cards = await manageDeck.watch('deck').first;
    expect(cards.single.quantity, 2);
    expect(await manageDeck.totalCards('deck'), 2);
  });

  test('quantity never goes under 1 and removing deletes the line', () async {
    await manageDeck.add('deck', pikachu);
    final card = (await manageDeck.watch('deck').first).single;
    await manageDeck.setQuantity(card.id, 4);
    expect((await manageDeck.watch('deck').first).single.quantity, 4);
    await manageDeck.setQuantity(card.id, 0);
    expect((await manageDeck.watch('deck').first).single.quantity, 1);
    await manageDeck.remove(card.id);
    expect(await manageDeck.watch('deck').first, isEmpty);
  });

  test('card searches give names, extensions and images', () async {
    final results = await TcgdexSource(tcgdexClient()).searchCards('pikachu');
    expect(results.first.name, 'Pikachu');
    expect(results, hasLength(6));
    final magic = await ScryfallSource(clientReturning(fixture('scryfall_search.json'))).searchCards('lightning');
    expect(magic.single.name, 'Lightning Bolt');
    expect(magic.single.setName, 'Magic 2011');
  });
}
