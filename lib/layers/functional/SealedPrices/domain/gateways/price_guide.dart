import 'package:akashic/layers/functional/Lookup/domain/entities/card_game.dart';
import 'package:akashic/layers/functional/SealedPrices/domain/entities/sealed_price.dart';

abstract interface class PriceGuide {
  bool covers(CardGame game);
  Future<int?> downloadSizeOf(CardGame game);
  Future<List<SealedPrice>> pricesOf(CardGame game, Set<String> productIds, {required DateTime pricedAt});
}
