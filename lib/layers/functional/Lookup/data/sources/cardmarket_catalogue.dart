import 'package:akashic/layers/functional/Lookup/data/sources/json_fields.dart';
import 'package:akashic/layers/functional/Lookup/data/sources/source_http.dart';
import 'package:akashic/layers/functional/Lookup/domain/entities/card_game.dart';
import 'package:akashic/layers/functional/Lookup/domain/entities/sealed_product.dart';
import 'package:akashic/layers/functional/Lookup/domain/gateways/sealed_product_catalogue.dart';
import 'package:http/http.dart' as http;

const Map<CardGame, int> cardmarketGameIds = {
  CardGame.magic: 1,
  CardGame.yugioh: 3,
  CardGame.pokemon: 6,
  CardGame.onePiece: 18,
  CardGame.lorcana: 19,
  CardGame.riftbound: 22,
};

class CardmarketCatalogue implements SealedProductCatalogue {
  CardmarketCatalogue(this._client);

  static const String sourceKey = 'cardmarket';

  final http.Client _client;
  final Map<CardGame, Future<List<SealedProduct>>> _productsByGame = {};

  @override
  bool covers(CardGame game) => cardmarketGameIds.containsKey(game);

  @override
  Future<List<SealedProduct>> productsOf(CardGame game) => _productsByGame[game] ??= _load(game).catchError((Object failure) {
        _productsByGame.remove(game);
        throw failure;
      });

  Future<List<SealedProduct>> _load(CardGame game) async {
    final gameId = cardmarketGameIds[game];
    if (gameId == null) {
      return const [];
    }
    final json = mapOf(await sourceGetJson(_client, Uri.https('downloads.s3.cardmarket.com', '/productCatalog/productList/products_nonsingles_$gameId.json'), sourceKey: sourceKey));
    return [
      for (final product in listOf(json['products']).map(mapOf))
        if ((product['idProduct'], textOf(product['name']), textOf(product['categoryName'])) case (final int id, final name?, final categoryName?))
          SealedProduct(id: '$id', name: name, categoryName: categoryName, addedAt: DateTime.tryParse(textOf(product['dateAdded']) ?? '')),
    ];
  }
}
