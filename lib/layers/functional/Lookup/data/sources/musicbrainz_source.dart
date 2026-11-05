import 'package:akashic/layers/functional/Catalog/domain/entities/category_type.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/localized_titles.dart';
import 'package:akashic/layers/functional/Lookup/data/sources/json_fields.dart';
import 'package:akashic/layers/functional/Lookup/data/sources/language_codes.dart';
import 'package:akashic/layers/functional/Lookup/data/sources/source_http.dart';
import 'package:akashic/layers/functional/Lookup/domain/entities/source_match.dart';
import 'package:akashic/layers/functional/Lookup/domain/gateways/catalog_source.dart';
import 'package:http/http.dart' as http;

class MusicBrainzSource implements CatalogSource {
  MusicBrainzSource(this._client);

  static const String sourceKey = 'musicbrainz';
  static const int _maximumResults = 15;

  final http.Client _client;

  @override
  String get key => sourceKey;

  @override
  Set<CategoryType> get types => const {CategoryType.music};

  @override
  bool get isConfigured => true;

  @override
  bool get supportsBarcode => true;

  Future<List<SourceMatch>> _releases(String luceneQuery) async {
    final json = mapOf(await sourceGetJson(
      _client,
      Uri.https('musicbrainz.org', '/ws/2/release/', {'query': luceneQuery, 'fmt': 'json', 'limit': '$_maximumResults'}),
      sourceKey: key,
    ));
    final seenWorks = <String>{};
    return [
      for (final release in listOf(json['releases']).map(mapOf))
        if (_matchOf(release) case final match? when seenWorks.add(match.externalWorkId)) match,
    ];
  }

  SourceMatch? _matchOf(Map<String, Object?> release) {
    final releaseId = textOf(release['id']);
    final title = textOf(release['title']);
    if (releaseId == null || title == null) {
      return null;
    }
    final groupId = textOf(mapOf(release['release-group'])['id']);
    final creator = [
      for (final credit in listOf(release['artist-credit']).map(mapOf)) '${textOf(credit['name']) ?? ''}${credit['joinphrase'] is String ? credit['joinphrase'] : ''}',
    ].join().trim();
    return SourceMatch(
      sourceKey: key,
      externalWorkId: groupId ?? releaseId,
      externalEditionId: releaseId,
      titles: LocalizedTitles(byLanguage: {twoLetterLanguage(textOf(mapOf(release['text-representation'])['language'])): title}),
      creator: creator.isEmpty ? null : creator,
      year: yearOf(release['date']),
      publisher: textOf(mapOf(mapOf(listOf(release['label-info']).firstOrNull)['label'])['name']),
      barcode: textOf(release['barcode']),
      format: textOf(mapOf(listOf(release['media']).firstOrNull)['format']),
      imageUrl: groupId == null ? 'https://coverartarchive.org/release/$releaseId/front-500' : 'https://coverartarchive.org/release-group/$groupId/front-500',
      suggestedType: CategoryType.music,
    );
  }

  @override
  Future<List<SourceMatch>> search(String query) {
    final escaped = query.trim().replaceAll(RegExp(r'([+\-&|!(){}\[\]^"~*?:\\/])'), r'\$1');
    return _releases(escaped);
  }

  @override
  Future<List<SourceMatch>> lookupBarcode(String barcode) => _releases('barcode:$barcode');
}
