import 'package:akashic/layers/functional/Collection/domain/entities/deck_card.dart';
import 'package:akashic/layers/functional/Collection/domain/gateways/deck_gateway.dart';
import 'package:akashic/layers/functional/Lookup/domain/entities/source_unavailable.dart';
import 'package:akashic/layers/functional/Lookup/domain/gateways/card_price_catalogue.dart';
import 'package:equatable/equatable.dart';

class CardPricing extends Equatable {
  const CardPricing({required this.priced, required this.unpriced, this.failure});

  final int priced;
  final int unpriced;
  final SourceUnavailable? failure;

  @override
  List<Object?> get props => [priced, unpriced, failure];
}

final RegExp _scryfallId = RegExp(r'^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$');

String? cardSourceOf(DeckCard card) {
  if (card.sourceKey case final sourceKey?) {
    return sourceKey;
  }
  final externalCardId = card.externalCardId;
  if (externalCardId == null) {
    return null;
  }
  if (_scryfallId.hasMatch(externalCardId)) {
    return 'scryfall';
  }
  if (RegExp(r'^\d+$').hasMatch(externalCardId)) {
    return 'ygoprodeck';
  }
  if (externalCardId.startsWith('crd_')) {
    return 'lorcast';
  }
  return externalCardId.contains('-') ? 'tcgdex' : null;
}

Map<String, int> deckValueByCurrency(List<DeckCard> cards) {
  final totals = <String, int>{};
  for (final card in cards) {
    if (card.price case final price?) {
      totals.update(price.currency, (total) => total + price.cents * card.quantity, ifAbsent: () => price.cents * card.quantity);
    }
  }
  return totals;
}

class UpdateCardPrices {
  UpdateCardPrices(this._deck, List<CardPriceCatalogue> catalogues, {DateTime Function()? now})
      : _catalogues = {for (final catalogue in catalogues) catalogue.key: catalogue},
        _now = now ?? DateTime.now;

  static const Duration freshPrice = Duration(hours: 24);

  final DeckGateway _deck;
  final Map<String, CardPriceCatalogue> _catalogues;
  final DateTime Function() _now;

  Future<CardPricing> call(String itemId) async {
    final cards = await _deck.watchCards(itemId).first;
    final now = _now();
    final pending = <String, Set<String>>{};
    var priced = 0;
    var unpriced = 0;
    for (final card in cards) {
      final source = cardSourceOf(card);
      final externalCardId = card.externalCardId;
      if (card.price case final price? when now.difference(price.pricedAt) < freshPrice) {
        priced++;
      } else if (_catalogues.containsKey(source) && externalCardId != null) {
        pending.putIfAbsent(source!, () => {}).add(externalCardId);
      } else {
        unpriced++;
      }
    }
    final pricesBySource = <String, Map<String, CardPrice>>{};
    SourceUnavailable? failure;
    for (final MapEntry(key: source, value: cardIds) in pending.entries) {
      final (prices, sourceFailure) = await _pricesOf(_catalogues[source]!, cardIds.toList());
      pricesBySource[source] = prices;
      failure ??= sourceFailure;
    }
    final updated = <DeckCard>[];
    for (final card in cards) {
      final source = cardSourceOf(card);
      final cardIds = pending[source];
      if (cardIds == null || !cardIds.contains(card.externalCardId)) {
        continue;
      }
      if (pricesBySource[source]?[card.externalCardId] case final price?) {
        updated.add(card.copyWith(price: price));
        priced++;
      } else {
        unpriced++;
      }
    }
    await _deck.saveCards(updated);
    return CardPricing(priced: priced, unpriced: unpriced, failure: failure);
  }

  Future<(Map<String, CardPrice>, SourceUnavailable?)> _pricesOf(CardPriceCatalogue catalogue, List<String> cardIds) async {
    if (catalogue is BatchCardPriceCatalogue) {
      try {
        return (await catalogue.pricesOf(cardIds), null);
      } on SourceUnavailable catch (unavailable) {
        if (unavailable.isRateLimited) {
          return (const <String, CardPrice>{}, unavailable);
        }
      }
    }
    final prices = <String, CardPrice>{};
    SourceUnavailable? failure;
    for (final cardId in cardIds) {
      try {
        if (await catalogue.priceOf(cardId) case final price?) {
          prices[cardId] = price;
        }
      } on SourceUnavailable catch (unavailable) {
        failure ??= unavailable;
        if (unavailable.isRateLimited) {
          break;
        }
      }
    }
    return (prices, failure);
  }
}
