import 'package:akashic/layers/functional/Catalog/domain/entities/category_type.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/owned_work.dart';
import 'package:akashic/layers/functional/Discoveries/domain/entities/suggestion.dart';
import 'package:akashic/layers/functional/Discoveries/domain/gateways/recommendation_source.dart';
import 'package:akashic/layers/functional/Lookup/data/sources/json_fields.dart';
import 'package:akashic/layers/functional/Lookup/data/sources/source_http.dart';
import 'package:http/http.dart' as http;

class AniListRecommendations implements RecommendationSource {
  AniListRecommendations(this._client);

  static const String _query =
      r'query ($id: Int) { Media(id: $id) { id recommendations(sort: RATING_DESC, perPage: 12) { nodes { mediaRecommendation { id type format title { romaji english native } coverImage { large } staff(perPage: 1) { nodes { name { full } } } } } } } }';

  final http.Client _client;

  @override
  String get key => 'anilist';

  @override
  bool get isConfigured => true;

  @override
  int get maximumSeeds => 8;

  @override
  bool supports(OwnedWork work, CategoryType type) => work.sourceKey == key && int.tryParse(work.externalWorkId ?? '') != null;

  @override
  String queryKeyFor(OwnedWork work) => work.externalWorkId!;

  @override
  Future<List<Suggestion>> recommendationsFor(OwnedWork work, {required String languageCode}) async {
    final json = mapOf(await sourcePostJson(_client, Uri.https('graphql.anilist.co', '/'), sourceKey: key, body: {
      'query': _query,
      'variables': {'id': int.parse(work.externalWorkId!)},
    }));
    final nodes = listOf(mapOf(mapOf(mapOf(json['data'])['Media'])['recommendations'])['nodes']);
    return [
      for (final node in nodes.map(mapOf))
        if (mapOf(node['mediaRecommendation']) case final media when media['id'] is int && media['type'] == 'MANGA')
          if (_titleOf(mapOf(media['title'])) case final title?)
            Suggestion(
              sourceKey: key,
              externalWorkId: '${media['id']}',
              title: title,
              creator: textOf(mapOf(mapOf(listOf(mapOf(media['staff'])['nodes']).firstOrNull)['name'])['full']),
              imageUrl: httpsUrl(mapOf(media['coverImage'])['large']),
            ),
    ];
  }

  String? _titleOf(Map<String, Object?> titles) => textOf(titles['english']) ?? textOf(titles['romaji']) ?? textOf(titles['native']);
}
