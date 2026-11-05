import 'package:akashic/layers/functional/Collection/domain/entities/collection_item.dart';
import 'package:akashic/layers/functional/Details/data/sources/duration_format.dart';
import 'package:akashic/layers/functional/Details/domain/entities/item_details.dart';
import 'package:akashic/layers/functional/Details/domain/gateways/details_source.dart';
import 'package:akashic/layers/functional/Lookup/data/sources/json_fields.dart';
import 'package:akashic/layers/functional/Lookup/data/sources/source_http.dart';
import 'package:http/http.dart' as http;

class AniListDetailsSource implements DetailsSource {
  AniListDetailsSource(this._client);

  final http.Client _client;

  @override
  bool supports(CollectionItem item) => item.sourceKey == 'anilist' && int.tryParse(item.externalWorkId ?? '') != null;

  @override
  Future<List<DetailSection>> fetch(CollectionItem item, {required String languageCode, String? editionId}) async {
    final json = mapOf(await sourcePostJson(_client, Uri.https('graphql.anilist.co', '/'), sourceKey: 'anilist', body: {
      'query': r'query ($id: Int) { Media(id: $id, type: MANGA) { id description(asHtml: false) status volumes chapters genres siteUrl } }',
      'variables': {'id': int.parse(item.externalWorkId!)},
    }));
    final media = mapOf(mapOf(json['data'])['Media']);
    final description = textOf(media['description']);
    final siteUrl = textOf(media['siteUrl']);
    return [
      TextSection(kind: TextKind.summary, text: description == null ? '' : stripHtml(description), sourceLabel: 'AniList'),
      FactsSection(facts: [
        if (textOf(media['status']) case final status?) DetailFact(kind: FactKind.status, value: status),
        if (media['volumes'] is int) DetailFact(kind: FactKind.volumes, value: '${media['volumes']}'),
        if (media['chapters'] is int) DetailFact(kind: FactKind.chapters, value: '${media['chapters']}'),
      ], sourceLabel: 'AniList'),
      TagSection(tags: [for (final genre in listOf(media['genres'])) ?textOf(genre)]),
      LinkSection(links: [if (siteUrl != null) DetailLink(label: 'AniList', url: siteUrl)]),
    ];
  }
}
