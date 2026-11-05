import 'package:akashic/layers/functional/Catalog/domain/entities/category_type.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/deck_card.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/localized_titles.dart';
import 'package:akashic/layers/functional/Collection/domain/use_cases/search_text_normalizer.dart';
import 'package:akashic/layers/functional/Lookup/data/sources/json_fields.dart';
import 'package:akashic/layers/functional/Lookup/data/sources/source_http.dart';
import 'package:akashic/layers/functional/Lookup/domain/entities/card_search_result.dart';
import 'package:akashic/layers/functional/Lookup/domain/entities/source_match.dart';
import 'package:akashic/layers/functional/Lookup/domain/gateways/card_price_catalogue.dart';
import 'package:akashic/layers/functional/Lookup/domain/gateways/card_search.dart';
import 'package:akashic/layers/functional/Lookup/domain/gateways/catalog_source.dart';
import 'package:http/http.dart' as http;

class OptcgSource implements CatalogSource, CardSearch, CardPriceCatalogue {
  OptcgSource(this._client, {DateTime Function()? now}) : _now = now ?? DateTime.now;

  static const String sourceKey = 'optcg';
  static const int _maximumCards = 30;

  final http.Client _client;
  Future<List<Map<String, Object?>>>? _sets;

  Future<List<Map<String, Object?>>> _allSets() => _sets ??= _loadSets().catchError((Object failure) {
        _sets = null;
        throw failure;
      });

  Future<List<Map<String, Object?>>> _loadSets() async => listOf(await sourceGetJson(_client, _endpoint('allSets/'), sourceKey: key)).map(mapOf).toList();
  final DateTime Function() _now;

  @override
  String get key => sourceKey;

  @override
  Set<CategoryType> get types => const {CategoryType.cards};

  @override
  bool get isConfigured => true;

  @override
  bool get supportsBarcode => false;

  Uri _endpoint(String path, [Map<String, String>? parameters]) => Uri.https('optcgapi.com', '/api/$path', parameters);

  @override
  Future<List<SourceMatch>> search(String query) async {
    final wanted = normalizeForSearch(query);
    final sets = await _allSets();
    return [
      for (final set in sets)
        if ((textOf(set['set_id']), textOf(set['set_name'])) case (final code?, final name?) when normalizeForSearch(name).contains(wanted) || normalizeForSearch(code) == wanted)
          SourceMatch(sourceKey: key, externalWorkId: code, titles: LocalizedTitles(byLanguage: {'en': name}), suggestedType: CategoryType.cards),
    ];
  }

  @override
  Future<List<SourceMatch>> lookupBarcode(String barcode) async => const [];

  @override
  Future<List<CardSearchResult>> searchCards(String query) async {
    final cards = listOf(await sourceGetJson(_client, _endpoint('sets/filtered/', {'card_name': query.trim()}), sourceKey: key)).map(mapOf);
    return [
      for (final card in cards)
        if ((textOf(card['card_image_id']) ?? textOf(card['card_set_id']), textOf(card['card_name'])) case (final cardId?, final name?))
          CardSearchResult(name: name, externalCardId: cardId, setName: textOf(card['set_name']), imageUrl: httpsUrl(card['card_image']), sourceKey: key),
    ].take(_maximumCards).toList();
  }

  @override
  Future<CardPrice?> priceOf(String externalCardId) async {
    final printedId = externalCardId.split('_').first;
    final versions = listOf(await sourceGetJson(_client, _endpoint('sets/card/$printedId/'), sourceKey: key)).map(mapOf);
    final version = versions.where((card) => (textOf(card['card_image_id']) ?? textOf(card['card_set_id'])) == externalCardId).firstOrNull;
    final dollars = centsOf(version?['market_price']) ?? centsOf(version?['inventory_price']);
    return dollars == null ? null : CardPrice(cents: dollars, currency: 'USD', pricedAt: _now());
  }
}
