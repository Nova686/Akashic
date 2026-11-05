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

class RiftcodexSource implements CatalogSource, CardSearch {
  RiftcodexSource(this._client);

  static const String sourceKey = 'riftcodex';
  static const int _maximumCards = 30;

  final http.Client _client;
  Future<List<Map<String, Object?>>>? _sets;

  Future<List<Map<String, Object?>>> _allSets() => _sets ??= _loadSets().catchError((Object failure) {
        _sets = null;
        throw failure;
      });

  Future<List<Map<String, Object?>>> _loadSets() async => listOf(mapOf(await sourceGetJson(_client, _endpoint('/sets', {'size': '100'}), sourceKey: key))['items']).map(mapOf).toList();

  @override
  String get key => sourceKey;

  @override
  Set<CategoryType> get types => const {CategoryType.cards};

  @override
  bool get isConfigured => true;

  @override
  bool get supportsBarcode => false;

  Uri _endpoint(String path, Map<String, String> parameters) => Uri.https('api.riftcodex.com', path, parameters);

  Future<List<Map<String, Object?>>> allSets() => _allSets();

  @override
  Future<List<SourceMatch>> search(String query) async {
    final wanted = normalizeForSearch(query);
    final sets = [...await allSets()]..sort((first, second) => (textOf(second['published_on']) ?? '').compareTo(textOf(first['published_on']) ?? ''));
    return [
      for (final set in sets)
        if ((textOf(set['set_id']), textOf(set['name'])) case (final code?, final name?) when normalizeForSearch(name).contains(wanted) || normalizeForSearch(code) == wanted)
          SourceMatch(
            sourceKey: key,
            externalWorkId: code,
            titles: LocalizedTitles(byLanguage: {'en': name}),
            year: yearOf(set['published_on']),
            suggestedType: CategoryType.cards,
          ),
    ];
  }

  @override
  Future<List<SourceMatch>> lookupBarcode(String barcode) async => const [];

  @override
  Future<List<CardSearchResult>> searchCards(String query) async {
    final cards = listOf(mapOf(await sourceGetJson(_client, _endpoint('/cards/name', {'fuzzy': query.trim()}), sourceKey: key))['items']).map(mapOf);
    return [
      for (final card in cards)
        if ((textOf(card['riftbound_id']) ?? textOf(card['id']), textOf(card['name'])) case (final cardId?, final name?))
          CardSearchResult(
            name: name,
            externalCardId: cardId,
            setName: textOf(mapOf(card['set'])['label']),
            imageUrl: textOf(mapOf(card['media'])['image_url']),
            sourceKey: key,
          ),
    ].take(_maximumCards).toList();
  }
}
