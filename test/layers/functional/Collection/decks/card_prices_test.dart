import 'package:akashic/layers/functional/Collection/data/gateways/drift_deck_gateway.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/card_kind.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/collection_item.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/deck_card.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/localized_titles.dart';
import 'package:akashic/layers/functional/Collection/domain/use_cases/update_card_prices.dart';
import 'package:akashic/layers/functional/Lookup/domain/entities/source_unavailable.dart';
import 'package:akashic/layers/functional/Lookup/domain/gateways/card_price_catalogue.dart';
import 'package:flutter_test/flutter_test.dart';

import '../collection_harness.dart';

class FixedPrices implements CardPriceCatalogue {
  FixedPrices(this.key, this.prices, {this.isDown = false});

  @override
  final String key;
  final Map<String, CardPrice> prices;
  final bool isDown;

  @override
  Future<CardPrice?> priceOf(String externalCardId) async {
    if (isDown) {
      throw SourceUnavailable(key, 'rate limited', true);
    }
    return prices[externalCardId];
  }
}

class BatchPrices implements BatchCardPriceCatalogue {
  BatchPrices(this.key, this.prices, {this.batchFails = false});

  @override
  final String key;
  final Map<String, CardPrice> prices;
  final bool batchFails;
  final List<List<String>> batches = [];
  final List<String> singles = [];

  @override
  Future<Map<String, CardPrice>> pricesOf(List<String> externalCardIds) async {
    batches.add(externalCardIds);
    if (batchFails) {
      throw SourceUnavailable(key, 'HTTP 400');
    }
    return {for (final id in externalCardIds) id: ?prices[id]};
  }

  @override
  Future<CardPrice?> priceOf(String externalCardId) async {
    singles.add(externalCardId);
    return prices[externalCardId];
  }
}

void main() {
  final pricedAt = DateTime(2026, 10, 28);

  group('batched pricing', () {
    late CollectionHarness harness;
    late DriftDeckGateway deck;
    const solRing = '00000000-0000-0000-0000-00000000000a';
    const arcaneSignet = '00000000-0000-0000-0000-00000000000b';
    const commandTower = '00000000-0000-0000-0000-00000000000c';

    setUp(() async {
      harness = CollectionHarness();
      final vinyls = await harness.vinyls();
      await harness.collection.saveItem(CollectionItem(id: 'deck', categoryId: vinyls.id, titles: const LocalizedTitles(byLanguage: {'fr': 'Deck'}), cardKind: CardKind.deck));
      deck = DriftDeckGateway(harness.database);
      await deck.saveCards([
        const DeckCard(id: 'a', itemId: 'deck', name: 'Sol Ring', quantity: 1, externalCardId: solRing),
        const DeckCard(id: 'a2', itemId: 'deck', name: 'Sol Ring', quantity: 1, externalCardId: solRing),
        const DeckCard(id: 'b', itemId: 'deck', name: 'Arcane Signet', quantity: 1, externalCardId: arcaneSignet),
        DeckCard(id: 'c', itemId: 'deck', name: 'Command Tower', quantity: 1, externalCardId: commandTower, price: CardPrice(cents: 10, currency: 'EUR', pricedAt: pricedAt.subtract(const Duration(hours: 2)))),
        const DeckCard(id: 'd', itemId: 'deck', name: 'Proxy', quantity: 1),
      ]);
    });

    tearDown(() => harness.database.close());

    test('a deck is priced in one batch per source, each card asked once, fresh prices kept', () async {
      final scryfall = BatchPrices('scryfall', {solRing: CardPrice(cents: 150, currency: 'EUR', pricedAt: pricedAt), arcaneSignet: CardPrice(cents: 90, currency: 'EUR', pricedAt: pricedAt)});
      final pricing = await UpdateCardPrices(deck, [scryfall], now: () => pricedAt)('deck');
      expect(scryfall.batches, hasLength(1));
      expect(scryfall.batches.single, unorderedEquals([solRing, arcaneSignet]));
      expect(scryfall.singles, isEmpty);
      expect(pricing, const CardPricing(priced: 4, unpriced: 1));
      final saved = {for (final card in await deck.watchCards('deck').first) card.id: card.price?.cents};
      expect(saved, {'a': 150, 'a2': 150, 'b': 90, 'c': 10, 'd': null});
    });

    test('a refused batch falls back to one call per card', () async {
      final scryfall = BatchPrices('scryfall', {solRing: CardPrice(cents: 150, currency: 'EUR', pricedAt: pricedAt)}, batchFails: true);
      final pricing = await UpdateCardPrices(deck, [scryfall], now: () => pricedAt)('deck');
      expect(scryfall.singles, unorderedEquals([solRing, arcaneSignet]));
      expect(pricing.priced, 3);
      expect(pricing.unpriced, 2);
    });
  });

  test('card sources are read from the card or guessed from older identifiers', () {
    DeckCard cardWith(String? externalCardId, {String? sourceKey}) => DeckCard(id: 'card', itemId: 'deck', name: 'card', quantity: 1, externalCardId: externalCardId, sourceKey: sourceKey);
    expect(cardSourceOf(cardWith('anything', sourceKey: 'riftcodex')), 'riftcodex');
    expect(cardSourceOf(cardWith('56719f6a-1a6c-4c0a-8d21-18f7d7350b68')), 'scryfall');
    expect(cardSourceOf(cardWith('46986414')), 'ygoprodeck');
    expect(cardSourceOf(cardWith('crd_a6f3c215973844fc')), 'lorcast');
    expect(cardSourceOf(cardWith('sv3pt5-25')), 'tcgdex');
    expect(cardSourceOf(cardWith(null)), isNull);
  });

  test('prices are stored per card and summed by currency with quantities', () async {
    final harness = CollectionHarness();
    final vinyls = await harness.vinyls();
    await harness.collection.saveItem(CollectionItem(id: 'deck', categoryId: vinyls.id, titles: const LocalizedTitles(byLanguage: {'fr': 'Deck'}), cardKind: CardKind.deck));
    final deck = DriftDeckGateway(harness.database);
    await deck.saveCard(const DeckCard(id: 'pikachu', itemId: 'deck', name: 'Pikachu', quantity: 3, externalCardId: 'sv3pt5-25', sourceKey: 'tcgdex'));
    await deck.saveCard(const DeckCard(id: 'elsa', itemId: 'deck', name: 'Elsa', quantity: 2, externalCardId: 'crd_1', sourceKey: 'lorcast'));
    await deck.saveCard(const DeckCard(id: 'typed', itemId: 'deck', name: 'Typed by hand', quantity: 1));
    final pricing = await UpdateCardPrices(deck, [
      FixedPrices('tcgdex', {'sv3pt5-25': CardPrice(cents: 150, currency: 'EUR', pricedAt: pricedAt)}),
      FixedPrices('lorcast', {'crd_1': CardPrice(cents: 99, currency: 'USD', pricedAt: pricedAt)}),
    ])('deck');
    expect(pricing, const CardPricing(priced: 2, unpriced: 1));
    expect(deckValueByCurrency(await deck.watchCards('deck').first), {'EUR': 450, 'USD': 198});
    await harness.database.close();
  });

  test('a catalogue over its quota leaves the card unpriced and reports the failure', () async {
    final harness = CollectionHarness();
    final vinyls = await harness.vinyls();
    await harness.collection.saveItem(CollectionItem(id: 'deck', categoryId: vinyls.id, titles: const LocalizedTitles(byLanguage: {'fr': 'Deck'})));
    final deck = DriftDeckGateway(harness.database);
    await deck.saveCard(const DeckCard(id: 'bolt', itemId: 'deck', name: 'Bolt', quantity: 1, externalCardId: 'bolt-id', sourceKey: 'scryfall'));
    final pricing = await UpdateCardPrices(deck, [FixedPrices('scryfall', const {}, isDown: true)])('deck');
    expect(pricing.unpriced, 1);
    expect(pricing.failure?.isRateLimited, isTrue);
    await harness.database.close();
  });
}
