import 'dart:convert';

import 'package:akashic/layers/functional/Catalog/domain/entities/category_type.dart';
import 'package:akashic/layers/functional/Collection/data/gateways/drift_deck_gateway.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/card_kind.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/collection_item.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/deck_card.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/localized_titles.dart';
import 'package:akashic/layers/functional/Collection/domain/use_cases/manage_deck.dart';
import 'package:akashic/layers/functional/Collection/presentation/cubit/deck_editor_cubit.dart';
import 'package:akashic/layers/functional/Lookup/data/sources/archidekt_deck_source.dart';
import 'package:akashic/layers/functional/Lookup/domain/entities/imported_deck_list.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

import '../collection_harness.dart';

Map<String, Object?> archidektCard(String name, {required String uid, int quantity = 1, List<String> categories = const [], List<String> superTypes = const [], List<String> types = const ['Creature'], List<String> subTypes = const [], List<String> colorIdentity = const [], num cmc = 1}) => {
      'quantity': quantity,
      'categories': categories,
      'card': {
        'uid': uid,
        'edition': {'editionname': 'Commander Legends'},
        'oracleCard': {'name': name, 'superTypes': superTypes, 'types': types, 'subTypes': subTypes, 'colorIdentity': colorIdentity, 'cmc': cmc},
      },
    };

ArchidektDeckSource archidekt() => ArchidektDeckSource(MockClient((request) async {
      if (request.url.path != '/api/decks/1234/') {
        return http.Response('', 404);
      }
      return http.Response.bytes(
        utf8.encode(jsonEncode({
          'name': 'Thelon Saprolings',
          'categories': [
            {'name': 'Commander', 'includedInDeck': true},
            {'name': 'Ramp', 'includedInDeck': true},
            {'name': 'Maybeboard', 'includedInDeck': false},
          ],
          'cards': [
            archidektCard('Thelon of Havenwood', uid: 'c673b7b0-c1e7-4bcd-8fe0-66d83f22ecb9', categories: ['Commander'], superTypes: ['Legendary'], subTypes: ['Elf', 'Druid'], colorIdentity: ['Black', 'Green'], cmc: 2),
            archidektCard('Forest', uid: 'aaaa0000-0000-0000-0000-000000000000', quantity: 30, superTypes: ['Basic'], types: ['Land'], subTypes: ['Forest'], colorIdentity: ['Green'], cmc: 0),
            archidektCard('Cultivate', uid: 'bbbb0000-0000-0000-0000-000000000000', categories: ['Ramp'], types: ['Sorcery'], colorIdentity: ['Green'], cmc: 3),
            archidektCard('Doubling Season', uid: 'cccc0000-0000-0000-0000-000000000000', categories: ['Maybeboard'], types: ['Enchantment'], colorIdentity: ['Green'], cmc: 5),
          ],
        })),
        200,
      );
    }));

void main() {
  test('an archidekt link gives the deck cards with their commander, scryfall ids and traits, maybeboard aside', () async {
    final source = archidekt();
    expect(source.recognizes('https://archidekt.com/decks/1234/thelon_saprolings'), isTrue);
    expect(source.recognizes('1234'), isTrue);
    expect(source.recognizes('https://moxfield.com/decks/abc'), isFalse);
    final deck = await source.deckAt('https://archidekt.com/decks/1234/thelon_saprolings');
    expect(deck.name, 'Thelon Saprolings');
    expect(deck.cards.map((entry) => (entry.card.name, entry.quantity, entry.isCommander)), [('Thelon of Havenwood', 1, true), ('Forest', 30, false), ('Cultivate', 1, false)]);
    expect(deck.cards.first.traits, const CardTraits(typeLine: 'Legendary Creature — Elf Druid', colorIdentity: 'BG', manaValue: 2));
    expect(deck.cards.first.card.imageUrl, 'https://cards.scryfall.io/normal/front/c/6/c673b7b0-c1e7-4bcd-8fe0-66d83f22ecb9.jpg');
    expect(deck.cards.first.card.sourceKey, 'scryfall');
    expect(source.deckAt('https://archidekt.com/decks/999/'), throwsA(isA<DeckListNotFound>()));
  });

  test('importing an archidekt deck fills the deck with its commander and card types ready for analysis', () async {
    final harness = CollectionHarness();
    final cards = await harness.createCategory(name: 'Magic', colorValue: 0, type: CategoryType.cards, conditionParts: const ['Carte']);
    await harness.collection.saveItem(CollectionItem(id: 'deck', categoryId: cards.id, titles: const LocalizedTitles(byLanguage: {'fr': 'Deck'}), cardKind: CardKind.deck));
    final gateway = DriftDeckGateway(harness.database);
    final cubit = DeckEditorCubit(itemId: 'deck', manageDeck: ManageDeck(gateway), cardSearches: const [], deckListSources: [archidekt()]);
    expect(cubit.state.canImportDeckList, isTrue);
    expect(await cubit.importDeckList('https://archidekt.com/decks/1234/'), ('Thelon Saprolings', 32));
    final saved = await gateway.watchCards('deck').first;
    expect([for (final card in saved) if (card.isCommander) (card.name, card.commanderRole)], [('Thelon of Havenwood', CommanderRole.primary)]);
    expect(saved.firstWhere((card) => card.name == 'Cultivate').traits?.typeLine, 'Sorcery');
    expect(() => cubit.importDeckList('https://example.com/not-a-deck'), throwsA(isA<DeckListNotFound>()));
    await cubit.close();
    await harness.database.close();
  });
}
