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

class TcgdexSource implements CatalogSource, CardSearch, CardPriceCatalogue {
  TcgdexSource(this._client, {this._language = 'fr'});

  static const String sourceKey = 'tcgdex';
  static const int _maximumResults = 20;

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

  Uri _endpoint(String path, [Map<String, String>? parameters]) => Uri.https('api.tcgdex.net', '/v2/$_language$path', parameters);

  Future<List<Map<String, Object?>>> _allSets() {
    return _sets ??= _loadSets().catchError((Object failure) {
      _sets = null;
      throw failure;
    });
  }

  Future<List<Map<String, Object?>>> _setsOrNone() async {
    try {
      return await _allSets();
    } on SourceUnavailable {
      return const [];
    }
  }

  Future<List<Map<String, Object?>>> _loadSets() async {
    final json = await sourceGetJson(_client, _endpoint('/sets'), sourceKey: key);
    if (json is! List || json.isEmpty) {
      throw const SourceUnavailable(sourceKey, 'no extensions');
    }
    return json.map(mapOf).toList();
  }

  String? _image(Object? base, String variant) => switch (textOf(base)) {
        final url? => '$url$variant',
        null => null,
      };

  @override
  Future<List<SourceMatch>> search(String query) async {
    final wanted = normalizeForSearch(query);
    final sets = await _allSets();
    return [
      for (final set in sets.reversed)
        if ((textOf(set['id']), textOf(set['name'])) case (final id?, final name?) when normalizeForSearch(name).contains(wanted))
          SourceMatch(
            sourceKey: key,
            externalWorkId: id,
            titles: LocalizedTitles(byLanguage: {_language: name}),
            imageUrl: _image(set['logo'], '.png'),
            suggestedType: CategoryType.cards,
          ),
    ].take(_maximumResults).toList();
  }

  @override
  Future<List<SourceMatch>> lookupBarcode(String barcode) async => const [];

  @override
  Future<List<CardSearchResult>> searchCards(String query) async {
    final cards = listOf(await sourceGetJson(_client, _endpoint('/cards', {'name': query.trim(), 'pagination:itemsPerPage': '30'}), sourceKey: key)).map(mapOf);
    final setNames = <String, String>{
      for (final set in await _setsOrNone())
        if ((textOf(set['id']), textOf(set['name'])) case (final id?, final name?)) id: name,
    };
    return [
      for (final card in cards)
        if ((textOf(card['id']), textOf(card['name'])) case (final id?, final name?))
          CardSearchResult(
            name: name,
            externalCardId: id,
            setName: id.contains('-') ? setNames[id.substring(0, id.lastIndexOf('-'))] : null,
            imageUrl: _image(card['image'], '/low.png'),
            sourceKey: key,
          ),
    ];
  }

  @override
  Future<CardPrice?> priceOf(String externalCardId) async {
    final cardmarket = mapOf(mapOf(mapOf(await sourceGetJson(_client, _endpoint('/cards/$externalCardId'), sourceKey: key))['pricing'])['cardmarket']);
    final cents = centsOf(cardmarket['trend']) ?? centsOf(cardmarket['avg']);
    return cents == null ? null : CardPrice(cents: cents, currency: textOf(cardmarket['unit']) ?? 'EUR', pricedAt: DateTime.now());
  }
}
