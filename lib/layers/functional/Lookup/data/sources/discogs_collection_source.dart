import 'package:akashic/layers/functional/Catalog/domain/entities/category_type.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/localized_titles.dart';
import 'package:akashic/layers/functional/Import/domain/use_cases/import_discogs_collection.dart';
import 'package:akashic/layers/functional/Lookup/data/sources/json_fields.dart';
import 'package:akashic/layers/functional/Lookup/data/sources/source_http.dart';
import 'package:akashic/layers/functional/Lookup/domain/entities/source_match.dart';
import 'package:akashic/layers/functional/Lookup/domain/entities/source_unavailable.dart';
import 'package:http/http.dart' as http;

class DiscogsCollectionSource implements OwnedReleaseCatalogue {
  DiscogsCollectionSource(this._client, {required this._token});

  static const String _sourceKey = 'discogs';
  static const int _pageSize = 100;
  static final RegExp _artistDisambiguation = RegExp(r'\s*\(\d+\)$');

  final http.Client _client;
  final String _token;

  @override
  bool get isConfigured => _token.isNotEmpty;

  Map<String, String> get _headers => {'Authorization': 'Discogs token=$_token'};

  Future<Map<String, Object?>> _get(String path, [Map<String, String>? parameters]) async =>
      mapOf(await sourceGetJson(_client, Uri.https('api.discogs.com', path, parameters), sourceKey: _sourceKey, headers: _headers));

  @override
  Future<List<SourceMatch>> ownedReleases({void Function(int loaded, int total)? onProgress}) async {
    final username = textOf((await _get('/oauth/identity'))['username']);
    if (username == null) {
      throw const SourceUnavailable(_sourceKey, 'no identity for this token');
    }
    final matches = <SourceMatch>[];
    var page = 1;
    var pages = 1;
    do {
      final json = await _get('/users/${Uri.encodeComponent(username)}/collection/folders/0/releases', {'per_page': '$_pageSize', 'page': '$page', 'sort': 'added'});
      final pagination = mapOf(json['pagination']);
      pages = pagination['pages'] is int ? pagination['pages'] as int : 1;
      for (final release in listOf(json['releases']).map(mapOf)) {
        if (_matchOf(mapOf(release['basic_information'])) case final match?) {
          matches.add(match);
        }
      }
      onProgress?.call(matches.length, pagination['items'] is int ? pagination['items'] as int : matches.length);
      page++;
    } while (page <= pages);
    return matches;
  }

  SourceMatch? _matchOf(Map<String, Object?> release) {
    final releaseId = release['id'];
    final title = textOf(release['title']);
    if (releaseId is! int || title == null) {
      return null;
    }
    final masterId = release['master_id'];
    final artists = [
      for (final artist in listOf(release['artists']).map(mapOf))
        if (textOf(artist['name']) case final name?) name.replaceAll(_artistDisambiguation, ''),
    ];
    final format = mapOf(listOf(release['formats']).firstOrNull);
    final descriptions = listOf(format['descriptions']).whereType<String>().join(', ');
    final formatName = textOf(format['name']);
    final year = release['year'];
    return SourceMatch(
      sourceKey: _sourceKey,
      externalWorkId: masterId is int && masterId > 0 ? 'master:$masterId' : 'release:$releaseId',
      externalEditionId: '$releaseId',
      titles: LocalizedTitles(byLanguage: {'en': title}),
      creator: artists.isEmpty ? null : artists.join(', '),
      year: year is int && year > 0 ? year : null,
      publisher: textOf(mapOf(listOf(release['labels']).firstOrNull)['name']),
      format: [?formatName, if (descriptions.isNotEmpty) descriptions].join(', '),
      imageUrl: textOf(release['cover_image']),
      suggestedType: CategoryType.music,
    );
  }
}
