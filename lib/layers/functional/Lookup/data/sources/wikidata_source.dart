import 'package:akashic/layers/functional/Catalog/domain/entities/category_type.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/localized_titles.dart';
import 'package:akashic/layers/functional/Lookup/data/sources/json_fields.dart';
import 'package:akashic/layers/functional/Lookup/data/sources/source_http.dart';
import 'package:akashic/layers/functional/Lookup/domain/entities/source_match.dart';
import 'package:akashic/layers/functional/Lookup/domain/gateways/catalog_source.dart';
import 'package:http/http.dart' as http;

class WikidataSource implements CatalogSource {
  WikidataSource(this._client, {required this.type, required this._descriptionWords});

  static const String sourceKey = 'wikidata';

  static const Map<CategoryType, List<String>> descriptionWordsByType = {
    CategoryType.films: ['film', 'série télévisée', 'television series', 'téléfilm', "film d'animation"],
    CategoryType.videoGames: ['jeu vidéo', 'video game'],
    CategoryType.boardGames: ['jeu de société', 'board game', 'jeu de plateau', 'tabletop game'],
  };

  final http.Client _client;
  final CategoryType type;
  final List<String> _descriptionWords;

  WikidataSource.forType(http.Client client, CategoryType type) : this(client, type: type, descriptionWords: descriptionWordsByType[type] ?? const []);

  @override
  String get key => '$sourceKey-${type.name}';

  @override
  Set<CategoryType> get types => {type};

  @override
  bool get isConfigured => _descriptionWords.isNotEmpty;

  @override
  bool get supportsBarcode => false;

  @override
  Future<List<SourceMatch>> search(String query) async {
    final json = mapOf(await sourceGetJson(
      _client,
      Uri.https('www.wikidata.org', '/w/api.php', {
        'action': 'wbsearchentities',
        'search': query.trim(),
        'language': 'fr',
        'uselang': 'fr',
        'type': 'item',
        'limit': '20',
        'format': 'json',
      }),
      sourceKey: key,
    ));
    return [
      for (final entity in listOf(json['search']).map(mapOf))
        if ((textOf(entity['id']), textOf(entity['label']), textOf(entity['description'])?.toLowerCase()) case (final entityId?, final label?, final description?)
            when _descriptionWords.any(description.contains))
          SourceMatch(
            sourceKey: sourceKey,
            externalWorkId: entityId,
            titles: LocalizedTitles(byLanguage: {'fr': label}),
            year: yearOf(RegExp(r'\b(1[89]\d\d|20\d\d)\b').firstMatch(description)?.group(0)),
            suggestedType: type,
          ),
    ];
  }

  @override
  Future<List<SourceMatch>> lookupBarcode(String barcode) async => const [];
}
