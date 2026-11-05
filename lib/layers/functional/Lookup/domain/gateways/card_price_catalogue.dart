import 'package:akashic/layers/functional/Collection/domain/entities/deck_card.dart';

abstract interface class CardPriceCatalogue {
  String get key;
  Future<CardPrice?> priceOf(String externalCardId);
}

abstract interface class BatchCardPriceCatalogue implements CardPriceCatalogue {
  Future<Map<String, CardPrice>> pricesOf(List<String> externalCardIds);
}
