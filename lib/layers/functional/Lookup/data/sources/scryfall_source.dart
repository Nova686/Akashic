import 'package:akashic/layers/functional/Collection/domain/entities/deck_card.dart';
import 'package:akashic/layers/functional/Lookup/domain/gateways/card_price_catalogue.dart';
import 'package:akashic/layers/functional/Lookup/domain/gateways/card_traits_catalogue.dart';
import 'package:akashic/layers/functional/Catalog/domain/entities/category_type.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/localized_titles.dart';
import 'package:akashic/layers/functional/Lookup/data/sources/json_fields.dart';
import 'package:akashic/layers/functional/Lookup/domain/entities/card_search_result.dart';
import 'package:akashic/layers/functional/Lookup/domain/entities/source_match.dart';
import 'package:akashic/layers/functional/Lookup/domain/gateways/card_search.dart';
import 'package:akashic/layers/functional/Lookup/domain/gateways/catalog_source.dart';
import 'package:akashic/layers/functional/Lookup/data/sources/source_http.dart';
import 'package:http/http.dart' as http;

class ScryfallSource implements CatalogSource, CardSearch, BatchCardPriceCatalogue, CardTraitsCatalogue {
  ScryfallSource(this._client);

  static const String sourceKey = 'scryfall';
  static const int collectionBatchSize = 75;

  final http.Client _client;

  @override
  String get key => sourceKey;

  @override
  Set<CategoryType> get types => const {CategoryType.cards};

  @override
  bool get isConfigured => true;

  @override
  bool get supportsBarcode => false;

  @override
  Future<List<SourceMatch>> search(String query) async {
    final json = mapOf(await sourceGetJson(_client, Uri.https('api.scryfall.com', '/cards/search', {'q': query}), sourceKey: key));
    return [
      for (final card in listOf(json['data']).map(mapOf))
        if (textOf(card['name']) != null && textOf(card['id']) != null)
          SourceMatch(
            sourceKey: key,
            externalWorkId: textOf(card['oracle_id']) ?? textOf(card['id'])!,
            externalEditionId: textOf(card['id']),
            titles: LocalizedTitles(byLanguage: {textOf(card['lang']) ?? 'en': textOf(card['name'])!}),
            year: yearOf(card['released_at']),
            publisher: textOf(card['set_name']),
            imageUrl: textOf(mapOf(card['image_uris'])['normal']),
            suggestedType: CategoryType.cards,
          ),
    ];
  }

  @override
  Future<List<SourceMatch>> lookupBarcode(String barcode) async => const [];

  @override
  Future<List<CardSearchResult>> searchCards(String query) async {
    final json = mapOf(await sourceGetJson(_client, Uri.https('api.scryfall.com', '/cards/search', {'q': query}), sourceKey: key));
    return [
      for (final card in listOf(json['data']).map(mapOf))
        if (textOf(card['name']) case final name?)
          CardSearchResult(name: name, externalCardId: textOf(card['id']), setName: textOf(card['set_name']), imageUrl: textOf(mapOf(card['image_uris'])['normal']), sourceKey: key),
    ];
  }

  @override
  Future<CardPrice?> priceOf(String externalCardId) async =>
      _priceFrom(mapOf(mapOf(await sourceGetJson(_client, Uri.https('api.scryfall.com', '/cards/$externalCardId'), sourceKey: key))['prices']));

  CardPrice? _priceFrom(Map<String, Object?> prices) {
    final euros = centsOf(prices['eur']) ?? centsOf(prices['eur_foil']);
    if (euros != null) {
      return CardPrice(cents: euros, currency: 'EUR', pricedAt: DateTime.now());
    }
    final dollars = centsOf(prices['usd']) ?? centsOf(prices['usd_foil']);
    return dollars == null ? null : CardPrice(cents: dollars, currency: 'USD', pricedAt: DateTime.now());
  }

  Future<List<Map<String, Object?>>> _collectionOf(List<String> externalCardIds) async {
    final cards = <Map<String, Object?>>[];
    for (var start = 0; start < externalCardIds.length; start += collectionBatchSize) {
      final batch = externalCardIds.sublist(start, (start + collectionBatchSize).clamp(0, externalCardIds.length));
      final json = mapOf(await sourcePostJson(
        _client,
        Uri.https('api.scryfall.com', '/cards/collection'),
        sourceKey: key,
        body: {
          'identifiers': [for (final id in batch) {'id': id}],
        },
      ));
      cards.addAll(listOf(json['data']).map(mapOf));
    }
    return cards;
  }

  @override
  Future<Map<String, CardPrice>> pricesOf(List<String> externalCardIds) async => {
        for (final card in await _collectionOf(externalCardIds))
          if ((textOf(card['id']), _priceFrom(mapOf(card['prices']))) case (final id?, final price?)) id: price,
      };

  @override
  Future<Map<String, CardTraits>> traitsOf(List<String> externalCardIds) async {
    final traits = <String, CardTraits>{};
    for (final card in await _collectionOf(externalCardIds)) {
      final id = textOf(card['id']);
      final typeLine = textOf(card['type_line']) ?? textOf(mapOf(listOf(card['card_faces']).firstOrNull)['type_line']);
      if (id == null || typeLine == null) {
        continue;
      }
      traits[id] = CardTraits(
        typeLine: typeLine,
        colorIdentity: [for (final color in listOf(card['color_identity'])) ?textOf(color)].join(),
        manaValue: (card['cmc'] as num?)?.toDouble(),
      );
    }
    return traits;
  }
}
