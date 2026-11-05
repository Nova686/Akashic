import 'package:akashic/layers/functional/Catalog/domain/entities/category_type.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/localized_titles.dart';
import 'package:akashic/layers/functional/Lookup/data/sources/json_fields.dart';
import 'package:akashic/layers/functional/Lookup/data/sources/source_http.dart';
import 'package:akashic/layers/functional/Lookup/domain/entities/source_match.dart';
import 'package:akashic/layers/functional/Lookup/domain/gateways/catalog_source.dart';
import 'package:http/http.dart' as http;

class RebrickableSource implements CatalogSource {
  RebrickableSource(this._client, {required this._apiKey});

  static const String sourceKey = 'rebrickable';

  final http.Client _client;
  final String _apiKey;
  final Map<int, String?> _themeNames = {};

  @override
  String get key => sourceKey;

  @override
  Set<CategoryType> get types => const {CategoryType.lego};

  @override
  bool get isConfigured => _apiKey.isNotEmpty;

  @override
  bool get supportsBarcode => false;

  Map<String, String> get _headers => {'Authorization': 'key $_apiKey', 'Accept': 'application/json'};

  Future<String?> _themeName(Object? themeId) async {
    if (themeId is! int) {
      return null;
    }
    if (_themeNames.containsKey(themeId)) {
      return _themeNames[themeId];
    }
    final theme = mapOf(await sourceGetJson(_client, Uri.https('rebrickable.com', '/api/v3/lego/themes/$themeId/'), sourceKey: key, headers: _headers));
    return _themeNames[themeId] = textOf(theme['name']);
  }

  @override
  Future<List<SourceMatch>> search(String query) async {
    final setNumber = RegExp(r'\b(\d{3,7})(-\d+)?\b').firstMatch(query);
    final json = mapOf(await sourceGetJson(
      _client,
      Uri.https('rebrickable.com', '/api/v3/lego/sets/', {'search': setNumber?.group(0) ?? query.trim(), 'page_size': '20'}),
      sourceKey: key,
      headers: _headers,
    ));
    final matches = <SourceMatch>[];
    for (final set in listOf(json['results']).map(mapOf)) {
      final setNumberFound = textOf(set['set_num']);
      final name = textOf(set['name']);
      if (setNumberFound == null || name == null) {
        continue;
      }
      final pieces = set['num_parts'];
      matches.add(SourceMatch(
        sourceKey: key,
        externalWorkId: setNumberFound,
        titles: LocalizedTitles(byLanguage: {'en': '$name (${setNumberFound.replaceFirst(RegExp(r'-1$'), '')})'}),
        creator: matches.length < 5 ? await _themeName(set['theme_id']) : null,
        year: yearOf(set['year']),
        format: pieces is int && pieces > 0 ? '$pieces pcs' : null,
        imageUrl: textOf(set['set_img_url']),
        suggestedType: CategoryType.lego,
      ));
    }
    return matches;
  }

  @override
  Future<List<SourceMatch>> lookupBarcode(String barcode) async => const [];
}
