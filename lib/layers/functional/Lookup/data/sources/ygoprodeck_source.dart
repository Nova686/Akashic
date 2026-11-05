import 'package:akashic/layers/functional/Collection/domain/entities/deck_card.dart';
import 'package:akashic/layers/functional/Lookup/domain/gateways/card_price_catalogue.dart';
import 'package:akashic/layers/functional/Catalog/domain/entities/category_type.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/localized_titles.dart';
import 'package:akashic/layers/functional/Collection/domain/use_cases/search_text_normalizer.dart';
import 'package:akashic/layers/functional/Lookup/data/sources/json_fields.dart';
import 'package:akashic/layers/functional/Lookup/data/sources/source_http.dart';
import 'package:akashic/layers/functional/Lookup/domain/entities/card_search_result.dart';
import 'package:akashic/layers/functional/Lookup/domain/entities/source_match.dart';
import 'package:akashic/layers/functional/Lookup/domain/entities/source_unavailable.dart';
import 'package:akashic/layers/functional/Lookup/domain/gateways/card_search.dart';
import 'package:akashic/layers/functional/Lookup/domain/gateways/catalog_source.dart';
import 'package:http/http.dart' as http;

class YgoprodeckSource implements CatalogSource, CardSearch, BatchCardPriceCatalogue {
  YgoprodeckSource(this._client, {this._language = 'fr'});

  static const String sourceKey = 'ygoprodeck';
  static const int _maximumResults = 20;
  static const int _maximumCards = 30;

  final http.Client _client;
  final String _language;
  Future<List<Map<String, Object?>>>? _sets;

  @override
  String get key => sourceKey;

  @override
  Set<CategoryType> get types => const {CategoryType.cards};

  @override
  bool get isConfigured => true;

  @override
  bool get supportsBarcode => false;

  Uri _endpoint(String path, [Map<String, String>? parameters]) => Uri.https('db.ygoprodeck.com', '/api/v7/$path', parameters);

  Future<List<Map<String, Object?>>> _allSets() {
    return _sets ??= _loadSets().catchError((Object failure) {
      _sets = null;
      throw failure;
    });
  }

  Future<List<Map<String, Object?>>> _loadSets() async {
    final json = await sourceGetJson(_client, _endpoint('cardsets.php'), sourceKey: key);
    if (json is! List || json.isEmpty) {
      throw const SourceUnavailable(sourceKey, 'no sets');
    }
    return json.map(mapOf).toList();
  }

  @override
  Future<List<SourceMatch>> search(String query) async {
    final wanted = normalizeForSearch(query);
    final sets = [...await _allSets()]..sort((first, second) => (textOf(second['tcg_date']) ?? '').compareTo(textOf(first['tcg_date']) ?? ''));
    return [
      for (final set in sets)
        if ((textOf(set['set_code']), textOf(set['set_name'])) case (final code?, final name?)
            when normalizeForSearch(name).contains(wanted) || normalizeForSearch(code) == wanted)
          SourceMatch(
            sourceKey: key,
            externalWorkId: code,
            titles: LocalizedTitles(byLanguage: {'en': name}),
            year: yearOf(set['tcg_date']),
            imageUrl: textOf(set['set_image']),
            suggestedType: CategoryType.cards,
          ),
    ].take(_maximumResults).toList();
  }

  @override
  Future<List<SourceMatch>> lookupBarcode(String barcode) async => const [];

  @override
  Future<List<CardSearchResult>> searchCards(String query) async {
    final trimmed = query.trim();
    final answers = await Future.wait([
      _cardsNamed(trimmed, language: _language),
      if (_language != 'en') _cardsNamed(trimmed),
    ]);
    final seenIds = <String>{};
    return [
      for (final card in answers.expand((cards) => cards))
        if ((_idOf(card['id']), textOf(card['name'])) case (final id?, final name?) when seenIds.add(id))
          CardSearchResult(
            name: name,
            externalCardId: id,
            setName: textOf(mapOf(listOf(card['card_sets']).firstOrNull)['set_name']),
            imageUrl: textOf(mapOf(listOf(card['card_images']).firstOrNull)['image_url_small']),
            sourceKey: key,
          ),
    ].take(_maximumCards).toList();
  }

  String? _idOf(Object? value) => value is int ? '$value' : textOf(value);

  Future<List<Map<String, Object?>>> _cardsNamed(String name, {String? language}) async {
    final parameters = {'fname': name, 'num': '$_maximumCards', 'offset': '0', 'language': ?language};
    try {
      return listOf(mapOf(await sourceGetJson(_client, _endpoint('cardinfo.php', parameters), sourceKey: key))['data']).map(mapOf).toList();
    } on SourceUnavailable catch (failure) {
      if (failure.reason == 'HTTP 400') {
        return const [];
      }
      rethrow;
    }
  }

  static const int priceBatchSize = 50;

  @override
  Future<CardPrice?> priceOf(String externalCardId) async =>
      _priceFrom(mapOf(listOf(mapOf(await sourceGetJson(_client, _endpoint('cardinfo.php', {'id': externalCardId}), sourceKey: key))['data']).firstOrNull));

  CardPrice? _priceFrom(Map<String, Object?> card) {
    final prices = mapOf(listOf(card['card_prices']).firstOrNull);
    final euros = centsOf(prices['cardmarket_price']);
    if (euros != null) {
      return CardPrice(cents: euros, currency: 'EUR', pricedAt: DateTime.now());
    }
    final dollars = centsOf(prices['tcgplayer_price']);
    return dollars == null ? null : CardPrice(cents: dollars, currency: 'USD', pricedAt: DateTime.now());
  }

  @override
  Future<Map<String, CardPrice>> pricesOf(List<String> externalCardIds) async {
    final prices = <String, CardPrice>{};
    for (var start = 0; start < externalCardIds.length; start += priceBatchSize) {
      final batch = externalCardIds.sublist(start, (start + priceBatchSize).clamp(0, externalCardIds.length));
      final json = mapOf(await sourceGetJson(_client, _endpoint('cardinfo.php', {'id': batch.join(',')}), sourceKey: key));
      for (final card in listOf(json['data']).map(mapOf)) {
        if ((card['id'], _priceFrom(card)) case (final int id, final price?)) {
          prices['$id'] = price;
        }
      }
    }
    return prices;
  }
}
