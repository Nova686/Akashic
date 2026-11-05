import 'package:akashic/layers/functional/Catalog/domain/entities/category_type.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/localized_titles.dart';
import 'package:akashic/layers/functional/Lookup/data/sources/json_fields.dart';
import 'package:akashic/layers/functional/Lookup/data/sources/source_http.dart';
import 'package:akashic/layers/functional/Lookup/domain/entities/source_match.dart';
import 'package:akashic/layers/functional/Lookup/domain/gateways/catalog_source.dart';
import 'package:http/http.dart' as http;

class JikanSource implements CatalogSource {
  JikanSource(this._client);

  static const String sourceKey = 'jikan';
  static const Map<String, String> _statuses = {
    'Finished': 'FINISHED',
    'Publishing': 'RELEASING',
    'On Hiatus': 'HIATUS',
    'Discontinued': 'CANCELLED',
    'Not yet published': 'NOT_YET_RELEASED',
  };

  final http.Client _client;

  @override
  String get key => sourceKey;

  @override
  Set<CategoryType> get types => const {CategoryType.manga};

  @override
  bool get isConfigured => true;

  @override
  bool get supportsBarcode => false;

  String _authorName(Object? author) {
    final name = textOf(mapOf(author)['name']) ?? '';
    final parts = name.split(', ');
    return parts.length == 2 ? '${parts[1]} ${parts[0]}' : name;
  }

  @override
  Future<List<SourceMatch>> search(String query) async {
    final json = mapOf(await sourceGetJson(_client, Uri.https('api.jikan.moe', '/v4/manga', {'q': query.trim(), 'limit': '15'}), sourceKey: key));
    return [
      for (final manga in listOf(json['data']).map(mapOf))
        if ((manga['mal_id'], textOf(manga['title'])) case (final int malId, final romajiTitle?))
          SourceMatch(
            sourceKey: key,
            externalWorkId: '$malId',
            titles: LocalizedTitles(
              byLanguage: {
                'ja-Latn': romajiTitle,
                'en': ?textOf(manga['title_english']),
                'ja': ?textOf(manga['title_japanese']),
              },
              originalLanguage: 'ja',
            ),
            creator: switch ([for (final author in listOf(manga['authors'])) _authorName(author)].where((name) => name.isNotEmpty).toList()) {
              final authors when authors.isNotEmpty => authors.join(', '),
              _ => null,
            },
            year: yearOf(mapOf(manga['published'])['from']),
            imageUrl: textOf(mapOf(mapOf(manga['images'])['jpg'])['large_image_url']),
            volumeCount: manga['volumes'] is int ? manga['volumes'] as int : null,
            status: _statuses[textOf(manga['status'])],
            suggestedType: CategoryType.manga,
          ),
    ];
  }

  @override
  Future<List<SourceMatch>> lookupBarcode(String barcode) async => const [];
}
