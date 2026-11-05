import 'package:akashic/layers/functional/Lookup/domain/entities/card_game.dart';
import 'package:akashic/layers/functional/Lookup/domain/entities/sealed_product.dart';

abstract interface class SealedProductCatalogue {
  bool covers(CardGame game);
  Future<List<SealedProduct>> productsOf(CardGame game);
}
