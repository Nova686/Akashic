import 'package:akashic/layers/functional/Collection/domain/entities/deck_card.dart';
import 'package:akashic/layers/functional/Lookup/domain/gateways/card_price_catalogue.dart';
import 'package:akashic/layers/functional/Catalog/domain/entities/category_type.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/localized_titles.dart';
import 'package:akashic/layers/functional/Collection/domain/use_cases/search_text_normalizer.dart';
import 'package:akashic/layers/functional/Lookup/data/sources/json_fields.dart';
import 'package:akashic/layers/functional/Lookup/data/sources/source_http.dart';
import 'package:akashic/layers/functional/Lookup/domain/entities/card_search_result.dart';
import 'package:akashic/layers/functional/Lookup/domain/entities/source_match.dart';
import 'package:akashic/layers/functional/Lookup/domain/gateways/card_search.dart';
import 'package:akashic/layers/functional/Lookup/domain/gateways/catalog_source.dart';
import 'package:http/http.dart' as http;

class LorcastSource implements CatalogSource, CardSearch, CardPriceCatalogue {
  LorcastSource(this._client);

  static const String sourceKey = 'lorcast';
  static const int _maximumCards = 30;

  final http.Client _client;
  Future<List<Map<String, Object?>>>? _sets;

  Future<List<Map<String, Object?>>> _allSets() => _sets ??= _loadSets().catchError((Object failure) {
        _sets = null;
        throw failure;
      });

  Future<List<Map<String, Object?>>> _loadSets() async => listOf(mapOf(await sourceGetJson(_client, _endpoint('sets'), sourceKey: key))['results']).map(mapOf).toList();

  @override
  String get key => sourceKey;

  @override
  Set<CategoryType> get types => const {CategoryType.cards};

  @override
  bool get isConfigured => true;

  @override
  bool get supportsBarcode => false;

  Uri _endpoint(String path, [Map<String, String>? parameters]) => Uri.https('api.lorcast.com', '/v0/$path', parameters);

  @override
  Future<List<SourceMatch>> search(String query) async {
    final wanted = normalizeForSearch(query);
    final sets = (await _allSets()).reversed;
    return [
      for (final set in sets)
        if ((textOf(set['code']), textOf(set['name'])) case (final code?, final name?) when normalizeForSearch(name).contains(wanted) || normalizeForSearch(code) == wanted)
          SourceMatch(
            sourceKey: key,
            externalWorkId: code,
            titles: LocalizedTitles(byLanguage: {'en': name}),
            year: yearOf(set['released_at']),
            suggestedType: CategoryType.cards,
          ),
    ];
  }

  @override
  Future<List<SourceMatch>> lookupBarcode(String barcode) async => const [];

  @override
  Future<List<CardSearchResult>> searchCards(String query) async {
    final cards = listOf(mapOf(await sourceGetJson(_client, _endpoint('cards/search', {'q': query.trim()}), sourceKey: key))['results']).map(mapOf);
    return [
      for (final card in cards)
        if ((textOf(card['id']), textOf(card['name'])) case (final id?, final name?))
          CardSearchResult(
            name: switch (textOf(card['version'])) {
              final version? => '$name – $version',
              null => name,
            },
            externalCardId: id,
            setName: textOf(mapOf(card['set'])['name']),
            imageUrl: textOf(mapOf(mapOf(card['image_uris'])['digital'])['small']),
            sourceKey: key,
          ),
    ].take(_maximumCards).toList();
  }

  @override
  Future<CardPrice?> priceOf(String externalCardId) async {
    final prices = mapOf(mapOf(await sourceGetJson(_client, _endpoint('cards/$externalCardId'), sourceKey: key))['prices']);
    final dollars = centsOf(prices['usd']) ?? centsOf(prices['usd_foil']);
    return dollars == null ? null : CardPrice(cents: dollars, currency: 'USD', pricedAt: DateTime.now());
  }
}
