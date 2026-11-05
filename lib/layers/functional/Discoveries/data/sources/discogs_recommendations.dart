import 'package:akashic/layers/functional/Catalog/domain/entities/category_type.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/owned_work.dart';
import 'package:akashic/layers/functional/Collection/domain/use_cases/search_text_normalizer.dart';
import 'package:akashic/layers/functional/Discoveries/domain/entities/suggestion.dart';
import 'package:akashic/layers/functional/Discoveries/domain/gateways/recommendation_source.dart';
import 'package:akashic/layers/functional/Lookup/data/sources/json_fields.dart';
import 'package:akashic/layers/functional/Lookup/data/sources/source_http.dart';
import 'package:http/http.dart' as http;

class DiscogsRecommendations implements RecommendationSource {
  DiscogsRecommendations(this._client, {required this._token});

  final http.Client _client;
  final String _token;

  @override
  String get key => 'discogs';

  @override
  bool get isConfigured => _token.isNotEmpty;

  @override
  int get maximumSeeds => 3;

  Map<String, String> get _headers => {'Authorization': 'Discogs token=$_token'};

  @override
  bool supports(OwnedWork work, CategoryType type) => type == CategoryType.music && (work.creator?.trim().isNotEmpty ?? false);

  @override
  String queryKeyFor(OwnedWork work) => normalizeForSearch(withoutDiscogsNumber(work.creator!));

  Future<Map<String, Object?>> _get(String path, [Map<String, String>? parameters]) async =>
      mapOf(await sourceGetJson(_client, Uri.https('api.discogs.com', path, parameters), sourceKey: key, headers: _headers));

  @override
  Future<List<Suggestion>> recommendationsFor(OwnedWork work, {required String languageCode}) async {
    final artist = withoutDiscogsNumber(work.creator!);
    final artistResults = await _search({'artist': artist, 'sort': 'have', 'sort_order': 'desc', 'per_page': '20'});
    final style = _mainStyleOf(artistResults);
    final byStyle = style == null ? const <Map<String, Object?>>[] : await _search({'style': style, 'sort': 'have', 'sort_order': 'desc', 'per_page': '25'});
    return [
      ...artistResults.map(_suggestionOf).nonNulls,
      ...byStyle.map(_suggestionOf).nonNulls.where((suggestion) => normalizeForSearch(suggestion.creator ?? '') != normalizeForSearch(artist)),
    ];
  }

  String? _mainStyleOf(List<Map<String, Object?>> results) {
    final counts = <String, int>{};
    for (final result in results) {
      for (final style in listOf(result['style']).map(textOf).nonNulls) {
        counts[style] = (counts[style] ?? 0) + 1;
      }
    }
    if (counts.isEmpty) {
      return null;
    }
    return counts.entries.reduce((best, entry) => entry.value > best.value ? entry : best).key;
  }

  Future<List<Map<String, Object?>>> _search(Map<String, String> parameters) async =>
      listOf((await _get('/database/search', {'type': 'master', ...parameters}))['results']).map(mapOf).toList();

  Suggestion? _suggestionOf(Map<String, Object?> result) {
    final id = result['id'];
    final fullTitle = textOf(result['title']);
    if (id is! int || fullTitle == null) {
      return null;
    }
    final separator = fullTitle.indexOf(' - ');
    final coverImage = httpsUrl(result['cover_image']);
    return Suggestion(
      sourceKey: key,
      externalWorkId: 'master:$id',
      title: separator > 0 ? fullTitle.substring(separator + 3).trim() : fullTitle,
      creator: separator > 0 ? withoutDiscogsNumber(fullTitle.substring(0, separator)) : null,
      imageUrl: coverImage != null && !coverImage.endsWith('spacer.gif') ? coverImage : null,
      year: yearOf(result['year']),
    );
  }
}

String withoutDiscogsNumber(String artist) => artist.replaceAll(RegExp(r'\s*\(\d+\)$'), '').trim();
