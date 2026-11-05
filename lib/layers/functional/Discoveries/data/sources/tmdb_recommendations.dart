import 'package:akashic/layers/functional/Catalog/domain/entities/category_type.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/owned_work.dart';
import 'package:akashic/layers/functional/Discoveries/domain/entities/suggestion.dart';
import 'package:akashic/layers/functional/Discoveries/domain/gateways/recommendation_source.dart';
import 'package:akashic/layers/functional/Lookup/data/sources/json_fields.dart';
import 'package:akashic/layers/functional/Lookup/data/sources/source_http.dart';
import 'package:http/http.dart' as http;

class TmdbRecommendations implements RecommendationSource {
  TmdbRecommendations(this._client, {required this._apiKey});

  final http.Client _client;
  final String _apiKey;

  @override
  String get key => 'tmdb';

  @override
  bool get isConfigured => _apiKey.isNotEmpty;

  @override
  int get maximumSeeds => 8;

  @override
  bool supports(OwnedWork work, CategoryType type) => work.sourceKey == key && int.tryParse(work.externalWorkId ?? '') != null;

  @override
  String queryKeyFor(OwnedWork work) => work.externalWorkId!;

  @override
  Future<List<Suggestion>> recommendationsFor(OwnedWork work, {required String languageCode}) async {
    final uri = Uri.https('api.themoviedb.org', '/3/movie/${work.externalWorkId}/recommendations', {'api_key': _apiKey, 'language': languageCode});
    final json = mapOf(await sourceGetJson(_client, uri, sourceKey: key));
    return [
      for (final movie in listOf(json['results']).map(mapOf))
        if ((movie['id'], textOf(movie['title'])) case (final int id, final title?))
          Suggestion(
            sourceKey: key,
            externalWorkId: '$id',
            title: title,
            imageUrl: textOf(movie['poster_path']) == null ? null : 'https://image.tmdb.org/t/p/w342${movie['poster_path']}',
            year: yearOf(movie['release_date']),
          ),
    ];
  }
}
