import 'package:akashic/layers/functional/Catalog/domain/entities/category_type.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/localized_titles.dart';
import 'package:akashic/layers/functional/Lookup/data/sources/json_fields.dart';
import 'package:akashic/layers/functional/Lookup/domain/entities/source_match.dart';
import 'package:akashic/layers/functional/Lookup/domain/entities/series_info.dart';
import 'package:akashic/layers/functional/Lookup/domain/gateways/catalog_source.dart';
import 'package:akashic/layers/functional/Lookup/domain/gateways/series_info_source.dart';
import 'package:akashic/layers/functional/Lookup/data/sources/source_http.dart';
import 'package:http/http.dart' as http;

class AniListSource implements CatalogSource, SeriesInfoSource {
  AniListSource(this._client);

  static const String sourceKey = 'anilist';
  static const String _query = r'''
query ($search: String) {
  Page(perPage: 10) {
    media(search: $search, type: MANGA) {
      id
      title { romaji english native }
      staff(perPage: 3) { nodes { name { full } } }
      volumes
      status
      coverImage { large color }
      startDate { year }
    }
  }
}''';

  final http.Client _client;

  @override
  String get key => sourceKey;

  @override
  Set<CategoryType> get types => const {CategoryType.manga};

  @override
  bool get isConfigured => true;

  @override
  bool get supportsBarcode => false;

  @override
  Future<List<SourceMatch>> search(String query) async {
    final json = mapOf(await sourcePostJson(_client, Uri.https('graphql.anilist.co', '/'), sourceKey: key, body: {
      'query': _query,
      'variables': {'search': query},
    }));
    final media = listOf(mapOf(mapOf(json['data'])['Page'])['media']).map(mapOf);
    return [
      for (final entry in media)
        if (anilistTitlesOf(entry).byLanguage.isNotEmpty)
          SourceMatch(
            sourceKey: key,
            externalWorkId: '${entry['id']}',
            titles: anilistTitlesOf(entry),
            creator: anilistStaffOf(entry),
            year: yearOf(mapOf(entry['startDate'])['year']),
            imageUrl: httpsUrl(mapOf(entry['coverImage'])['large']),
            volumeCount: entry['volumes'] is int ? entry['volumes']! as int : null,
            status: textOf(entry['status']),
            suggestedType: CategoryType.manga,
          ),
    ];
  }

  @override
  Future<SeriesInfo?> seriesInfo(String externalWorkId) async {
    final id = int.tryParse(externalWorkId);
    if (id == null) {
      return null;
    }
    final json = mapOf(await sourcePostJson(_client, Uri.https('graphql.anilist.co', '/'), sourceKey: key, body: {
      'query': r'query ($id: Int) { Media(id: $id, type: MANGA) { id volumes status } }',
      'variables': {'id': id},
    }));
    final media = mapOf(mapOf(json['data'])['Media']);
    if (media.isEmpty) {
      return null;
    }
    return SeriesInfo(volumeCount: media['volumes'] is int ? media['volumes']! as int : null, status: textOf(media['status']));
  }

  @override
  Future<List<SourceMatch>> lookupBarcode(String barcode) async => const [];
}

LocalizedTitles anilistTitlesOf(Map<String, Object?> entry) {
  final title = mapOf(entry['title']);
  return LocalizedTitles(
    byLanguage: {
      'en': ?textOf(title['english']),
      'ja': ?textOf(title['native']),
      'ja-Latn': ?textOf(title['romaji']),
    },
    originalLanguage: 'ja',
  );
}

String? anilistStaffOf(Map<String, Object?> entry) {
  final names = [
    for (final node in listOf(mapOf(entry['staff'])['nodes']).map(mapOf))
      ?textOf(mapOf(node['name'])['full']),
  ];
  return names.isEmpty ? null : names.join(', ');
}
