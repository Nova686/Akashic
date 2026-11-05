import 'package:akashic/layers/functional/Catalog/domain/entities/category_type.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/localized_titles.dart';
import 'package:akashic/layers/functional/Lookup/data/sources/json_fields.dart';
import 'package:akashic/layers/functional/Lookup/domain/entities/source_match.dart';
import 'package:akashic/layers/functional/Lookup/domain/gateways/catalog_source.dart';
import 'package:akashic/layers/functional/Lookup/data/sources/source_http.dart';
import 'package:http/http.dart' as http;

class TmdbSource implements CatalogSource {
  TmdbSource(this._client, {required this._apiKey});

  static const String sourceKey = 'tmdb';

  final http.Client _client;
  final String _apiKey;

  @override
  String get key => sourceKey;

  @override
  Set<CategoryType> get types => const {CategoryType.films};

  @override
  bool get isConfigured => _apiKey.isNotEmpty;

  @override
  bool get supportsBarcode => false;

  @override
  Future<List<SourceMatch>> search(String query) async {
    if (!isConfigured) {
      return const [];
    }
    final uri = Uri.https('api.themoviedb.org', '/3/search/movie', {'query': query, 'api_key': _apiKey, 'language': 'fr-FR'});
    final json = mapOf(await sourceGetJson(_client, uri, sourceKey: key));
    return [
      for (final movie in listOf(json['results']).map(mapOf))
        if (textOf(movie['title']) != null && movie['id'] != null)
          SourceMatch(
            sourceKey: key,
            externalWorkId: '${movie['id']}',
            titles: LocalizedTitles(
              byLanguage: {
                'fr': textOf(movie['title'])!,
                ?textOf(movie['original_language']): textOf(movie['original_title']) ?? textOf(movie['title'])!,
              },
              originalLanguage: textOf(movie['original_language']),
            ),
            year: yearOf(movie['release_date']),
            imageUrl: textOf(movie['poster_path']) == null ? null : 'https://image.tmdb.org/t/p/w342${movie['poster_path']}',
            suggestedType: CategoryType.films,
          ),
    ];
  }

  @override
  Future<List<SourceMatch>> lookupBarcode(String barcode) async => const [];
}
