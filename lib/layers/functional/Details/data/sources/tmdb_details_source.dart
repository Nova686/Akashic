import 'package:akashic/layers/functional/Collection/domain/entities/collection_item.dart';
import 'package:akashic/layers/functional/Details/domain/entities/item_details.dart';
import 'package:akashic/layers/functional/Details/domain/gateways/details_source.dart';
import 'package:akashic/layers/functional/Lookup/data/sources/json_fields.dart';
import 'package:akashic/layers/functional/Lookup/data/sources/source_http.dart';
import 'package:http/http.dart' as http;

class TmdbDetailsSource implements DetailsSource {
  TmdbDetailsSource(this._client, {required this._apiKey});

  final http.Client _client;
  final String _apiKey;

  @override
  bool supports(CollectionItem item) => _apiKey.isNotEmpty && item.sourceKey == 'tmdb' && item.externalWorkId != null;

  @override
  Future<List<DetailSection>> fetch(CollectionItem item, {required String languageCode, String? editionId}) async {
    final uri = Uri.https('api.themoviedb.org', '/3/movie/${item.externalWorkId}', {'api_key': _apiKey, 'language': languageCode, 'append_to_response': 'credits'});
    final movie = mapOf(await sourceGetJson(_client, uri, sourceKey: 'tmdb'));
    final directors = [
      for (final member in listOf(mapOf(movie['credits'])['crew']).map(mapOf))
        if (member['job'] == 'Director') ?textOf(member['name']),
    ];
    final runtime = movie['runtime'];
    return [
      TextSection(kind: TextKind.summary, text: textOf(movie['overview']) ?? '', sourceLabel: 'TMDB'),
      FactsSection(facts: [
        if (directors.isNotEmpty) DetailFact(kind: FactKind.director, value: directors.join(', ')),
        if (runtime is int && runtime > 0) DetailFact(kind: FactKind.runtime, value: '${runtime ~/ 60} h ${(runtime % 60).toString().padLeft(2, '0')}'),
      ], sourceLabel: 'TMDB'),
      LinkSection(links: [DetailLink(label: 'TMDB', url: 'https://www.themoviedb.org/movie/${item.externalWorkId}')]),
    ];
  }
}
