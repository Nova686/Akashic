import 'dart:convert';
import 'dart:isolate';

import 'package:akashic/layers/functional/Lookup/data/sources/cardmarket_catalogue.dart';
import 'package:akashic/layers/functional/Lookup/domain/entities/card_game.dart';
import 'package:akashic/layers/functional/Lookup/domain/entities/source_unavailable.dart';
import 'package:akashic/layers/functional/SealedPrices/domain/entities/sealed_price.dart';
import 'package:akashic/layers/functional/SealedPrices/domain/gateways/price_guide.dart';
import 'package:http/http.dart' as http;

int? _centsOf(Object? euros) => euros is num && euros > 0 ? (euros * 100).round() : null;

List<SealedPrice> pricesInGuide(List<int> body, Set<String> productIds, DateTime pricedAt) {
  final json = jsonDecode(utf8.decode(body));
  final guides = json is Map && json['priceGuides'] is List ? json['priceGuides'] as List : const [];
  return [
    for (final guide in guides)
      if (guide is Map && productIds.contains('${guide['idProduct']}'))
        SealedPrice(
          productId: '${guide['idProduct']}',
          pricedAt: pricedAt,
          lowCents: _centsOf(guide['low']),
          averageCents: _centsOf(guide['avg']),
          trendCents: _centsOf(guide['trend']),
          average1Cents: _centsOf(guide['avg1']),
          average7Cents: _centsOf(guide['avg7']),
          average30Cents: _centsOf(guide['avg30']),
        ),
  ];
}

class CardmarketPriceGuide implements PriceGuide {
  CardmarketPriceGuide(this._client);

  final http.Client _client;

  Uri _guideOf(int gameId) => Uri.https('downloads.s3.cardmarket.com', '/productCatalog/priceGuide/price_guide_$gameId.json');

  @override
  bool covers(CardGame game) => cardmarketGameIds.containsKey(game);

  @override
  Future<int?> downloadSizeOf(CardGame game) async {
    final gameId = cardmarketGameIds[game];
    if (gameId == null) {
      return null;
    }
    try {
      final response = await _client.head(_guideOf(gameId));
      return response.statusCode == 200 ? int.tryParse(response.headers['content-length'] ?? '') : null;
    } on http.ClientException {
      return null;
    }
  }

  @override
  Future<List<SealedPrice>> pricesOf(CardGame game, Set<String> productIds, {required DateTime pricedAt}) async {
    final gameId = cardmarketGameIds[game];
    if (gameId == null || productIds.isEmpty) {
      return const [];
    }
    final http.Response response;
    try {
      response = await _client.get(_guideOf(gameId));
    } on http.ClientException catch (failure) {
      throw SourceUnavailable(CardmarketCatalogue.sourceKey, failure.message);
    }
    if (response.statusCode != 200) {
      throw SourceUnavailable(CardmarketCatalogue.sourceKey, 'HTTP ${response.statusCode}', response.statusCode == 429);
    }
    final body = response.bodyBytes;
    return Isolate.run(() => pricesInGuide(body, productIds, pricedAt));
  }
}
