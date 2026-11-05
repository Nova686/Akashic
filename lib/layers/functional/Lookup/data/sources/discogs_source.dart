import 'package:akashic/layers/functional/Catalog/domain/entities/category_type.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/localized_titles.dart';
import 'package:akashic/layers/functional/Lookup/data/sources/json_fields.dart';
import 'package:akashic/layers/functional/Lookup/domain/entities/source_match.dart';
import 'package:akashic/layers/functional/Lookup/domain/gateways/catalog_source.dart';
import 'package:akashic/layers/functional/Lookup/data/sources/source_http.dart';
import 'package:http/http.dart' as http;

class DiscogsSource implements CatalogSource {
  DiscogsSource(this._client, {required this._token});

  static const String sourceKey = 'discogs';

  final http.Client _client;
  final String _token;

  @override
  String get key => sourceKey;

  @override
  Set<CategoryType> get types => const {CategoryType.music};

  @override
  bool get isConfigured => _token.isNotEmpty;

  @override
  bool get supportsBarcode => true;

  Future<List<SourceMatch>> _query(Map<String, String> parameters) async {
    if (!isConfigured) {
      return const [];
    }
    final uri = Uri.https('api.discogs.com', '/database/search', {'type': 'release', 'per_page': '10', ...parameters});
    final json = mapOf(await sourceGetJson(_client, uri, sourceKey: key, headers: {'Authorization': 'Discogs token=$_token'}));
    return [
      for (final result in listOf(json['results']).map(mapOf))
        if (textOf(result['title']) != null && result['id'] != null) _toMatch(result),
    ];
  }

  SourceMatch _toMatch(Map<String, Object?> result) {
    final fullTitle = textOf(result['title'])!;
    final separator = fullTitle.indexOf(' - ');
    final artist = separator > 0 ? fullTitle.substring(0, separator).trim() : null;
    final title = separator > 0 ? fullTitle.substring(separator + 3).trim() : fullTitle;
    final masterId = result['master_id'];
    return SourceMatch(
      sourceKey: key,
      externalWorkId: masterId is int && masterId > 0 ? 'master:$masterId' : 'release:${result['id']}',
      externalEditionId: '${result['id']}',
      titles: LocalizedTitles(byLanguage: {'en': title}),
      creator: artist,
      year: yearOf(result['year']),
      publisher: firstTextOf(result['label']),
      barcode: firstTextOf(result['barcode']),
      format: firstTextOf(result['format']),
      imageUrl: textOf(result['cover_image']),
      suggestedType: CategoryType.music,
    );
  }

  @override
  Future<List<SourceMatch>> search(String query) => _query({'q': query});

  @override
  Future<List<SourceMatch>> lookupBarcode(String barcode) => _query({'barcode': barcode});
}
