import 'package:akashic/layers/functional/Catalog/domain/entities/category_type.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/owned_work.dart';
import 'package:akashic/layers/functional/Discoveries/domain/entities/suggestion.dart';
import 'package:akashic/layers/functional/Discoveries/domain/gateways/recommendation_source.dart';
import 'package:akashic/layers/functional/Lookup/data/sources/json_fields.dart';
import 'package:akashic/layers/functional/Lookup/data/sources/source_http.dart';
import 'package:http/http.dart' as http;

class GoogleBooksRecommendations implements RecommendationSource {
  GoogleBooksRecommendations(this._client, {required this._apiKey});

  final http.Client _client;
  final String _apiKey;

  @override
  String get key => 'googlebooks';

  @override
  bool get isConfigured => _apiKey.isNotEmpty;

  @override
  int get maximumSeeds => 4;

  @override
  bool supports(OwnedWork work, CategoryType type) =>
      (type == CategoryType.books || type == CategoryType.comics) && work.sourceKey == key && (work.externalWorkId?.isNotEmpty ?? false);

  @override
  String queryKeyFor(OwnedWork work) => work.externalWorkId!;

  Future<Map<String, Object?>> _get(String path, Map<String, String> parameters) async =>
      mapOf(await sourceGetJson(_client, Uri.https('www.googleapis.com', path, {...parameters, 'key': _apiKey}), sourceKey: key));

  @override
  Future<List<Suggestion>> recommendationsFor(OwnedWork work, {required String languageCode}) async {
    final info = mapOf((await _get('/books/v1/volumes/${work.externalWorkId}', const {}))['volumeInfo']);
    final author = firstTextOf(info['authors']);
    final category = firstTextOf(info['categories'])?.split(' / ').first.trim();
    final byAuthor = author == null ? const <Suggestion>[] : await _search('inauthor:"${_unquoted(author)}"', languageCode);
    final byCategory = category == null ? const <Suggestion>[] : await _search('subject:"${_unquoted(category)}"', languageCode);
    return [...byAuthor, ...byCategory];
  }

  String _unquoted(String text) => text.replaceAll('"', ' ').trim();

  Future<List<Suggestion>> _search(String query, String languageCode) async {
    final json = await _get('/books/v1/volumes', {'q': query, 'langRestrict': languageCode, 'printType': 'books', 'orderBy': 'relevance', 'maxResults': '20'});
    return [
      for (final volume in listOf(json['items']).map(mapOf))
        if ((textOf(volume['id']), textOf(mapOf(volume['volumeInfo'])['title'])) case (final id?, final title?))
          Suggestion(
            sourceKey: key,
            externalWorkId: id,
            title: title,
            creator: firstTextOf(mapOf(volume['volumeInfo'])['authors']),
            imageUrl: httpsUrl(mapOf(mapOf(volume['volumeInfo'])['imageLinks'])['thumbnail']),
            year: yearOf(mapOf(volume['volumeInfo'])['publishedDate']),
          ),
    ];
  }
}
