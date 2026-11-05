import 'package:akashic/layers/functional/Collection/domain/entities/collection_item.dart';
import 'package:akashic/layers/functional/Details/domain/entities/item_details.dart';
import 'package:akashic/layers/functional/Details/domain/gateways/details_source.dart';
import 'package:akashic/layers/functional/Lookup/data/sources/json_fields.dart';
import 'package:akashic/layers/functional/Lookup/data/sources/source_http.dart';
import 'package:http/http.dart' as http;

class DiscogsDetailsSource implements DetailsSource {
  DiscogsDetailsSource(this._client, {required this._token});

  static const String _label = 'Discogs';

  final http.Client _client;
  final String _token;

  Map<String, String> get _headers => {if (_token.isNotEmpty) 'Authorization': 'Discogs token=$_token'};

  @override
  bool supports(CollectionItem item) => item.sourceKey == 'discogs' && RegExp(r'^(master|release):\d+$').hasMatch(item.externalWorkId ?? '');

  Future<Map<String, Object?>> _get(String path) async => mapOf(await sourceGetJson(_client, Uri.https('api.discogs.com', path), sourceKey: 'discogs', headers: _headers));

  @override
  Future<List<DetailSection>> fetch(CollectionItem item, {required String languageCode, String? editionId}) async {
    final [kind, id] = item.externalWorkId!.split(':');
    final work = await _get(kind == 'master' ? '/masters/$id' : '/releases/$id');
    final chosenEdition = int.tryParse(editionId ?? '');
    final releaseId = chosenEdition ?? (kind == 'release' ? int.parse(id) : work['main_release'] as int?);
    final release = releaseId == null ? const <String, Object?>{} : (kind == 'release' && releaseId == int.parse(id) ? work : await _get('/releases/$releaseId'));
    final tracklist = chosenEdition != null && listOf(release['tracklist']).isNotEmpty ? release['tracklist'] : work['tracklist'];
    final label = mapOf(listOf(release['labels']).firstOrNull);
    final format = mapOf(listOf(release['formats']).firstOrNull);
    final labelText = [?textOf(label['name']), ?textOf(label['catno'])].join(' · ');
    final formatText = [?textOf(format['name']), ...listOf(format['descriptions']).map(textOf).nonNulls].join(', ');
    final notes = textOf(release['notes']);
    final pageUrl = textOf(release['uri']) ?? textOf(work['uri']);
    return [
      TrackListSection(
        sourceLabel: _label,
        tracks: _tracksOf(listOf(tracklist)),
      ),
      FactsSection(facts: [
        if (labelText.isNotEmpty) DetailFact(kind: FactKind.label, value: labelText),
        if (formatText.isNotEmpty) DetailFact(kind: FactKind.format, value: formatText),
      ], sourceLabel: _label),
      TextSection(kind: TextKind.summary, text: notes ?? '', sourceLabel: _label),
      TagSection(tags: [
        for (final tag in {...listOf(work['genres']).map(textOf).nonNulls, ...listOf(work['styles']).map(textOf).nonNulls}) tag,
      ]),
      LinkSection(links: [if (pageUrl != null) DetailLink(label: _label, url: pageUrl)]),
    ];
  }

  List<DetailTrack> _tracksOf(List<Object?> tracklist) {
    final tracks = <DetailTrack>[];
    for (final track in tracklist.map(mapOf)) {
      final type = textOf(track['type_']);
      if (type == 'index') {
        tracks.addAll(_tracksOf(listOf(track['sub_tracks'])));
      } else if (type != 'heading') {
        if (textOf(track['title']) case final title?) {
          tracks.add(DetailTrack(position: textOf(track['position']) ?? '', title: title, duration: textOf(track['duration'])));
        }
      }
    }
    return tracks;
  }
}
