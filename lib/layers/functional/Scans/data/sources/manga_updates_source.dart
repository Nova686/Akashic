import 'package:akashic/layers/functional/Lookup/data/sources/json_fields.dart';
import 'package:akashic/layers/functional/Lookup/data/sources/source_http.dart';
import 'package:akashic/layers/functional/Scans/domain/entities/chapter_number.dart';
import 'package:akashic/layers/functional/Scans/domain/gateways/chapter_release_source.dart';
import 'package:http/http.dart' as http;

class MangaUpdatesSource implements ChapterReleaseSource {
  MangaUpdatesSource(this._client);

  static const String sourceKey = 'mangaupdates';
  static const Set<String> _excludedKinds = {'doujinshi'};
  static const Set<String> _excludedGenres = {'adult', 'hentai'};
  static const Map<String, String> _namedEntities = {'lt': '<', 'gt': '>', 'quot': '"', 'apos': "'"};

  final http.Client _client;

  @override
  Future<List<ReleaseSeriesCandidate>> searchSeries(String query) async {
    final json = mapOf(await sourcePostJson(_client, Uri.https('api.mangaupdates.com', '/v1/series/search'), sourceKey: sourceKey, body: {'search': query, 'perpage': 25}));
    return [
      for (final result in listOf(json['results']).map(mapOf))
        if (mapOf(result['record']) case final record when _isProposable(record))
          if ((record['series_id'], textOf(record['title'])) case (final int id, final title?))
            ReleaseSeriesCandidate(
              id: '$id',
              title: title,
              year: textOf(record['year']),
              imageUrl: httpsUrl(mapOf(mapOf(record['image'])['url'])['thumb']),
              kind: textOf(record['type']),
            ),
    ];
  }

  bool _isProposable(Map<String, Object?> record) {
    final kind = textOf(record['type'])?.toLowerCase();
    if (kind != null && _excludedKinds.contains(kind)) {
      return false;
    }
    return !listOf(record['genres']).map((genre) => textOf(mapOf(genre)['genre'])?.toLowerCase()).any(_excludedGenres.contains);
  }

  @override
  Future<List<PublishedChapters>> releasesOf(String releaseSeriesId) async {
    final feed = await sourceGetText(_client, Uri.https('api.mangaupdates.com', '/v1/series/$releaseSeriesId/rss'), sourceKey: sourceKey) ?? '';
    return [
      for (final item in RegExp(r'<item>(.*?)</item>', dotAll: true).allMatches(feed))
        if (_tagContent(item.group(1)!, 'title') case final title?)
          if (RegExp(r'\bc\.\s*([\d.]+(?:\s*-\s*[\d.]+)?)').firstMatch(title) case final chapterMatch?)
            PublishedChapters(chapters: chaptersIn(chapterMatch.group(1)!), teamName: _tagContent(item.group(1)!, 'description') ?? ''),
    ];
  }

  String? _tagContent(String item, String tag) {
    final raw = RegExp('<$tag>(.*?)</$tag>', dotAll: true).firstMatch(item)?.group(1);
    if (raw == null) {
      return null;
    }
    final text = raw.replaceAll(RegExp(r'^<!\[CDATA\[|\]\]>$'), '').replaceAllMapped(RegExp(r'&(#x[0-9a-fA-F]+|#\d+|lt|gt|quot|apos);'), (entity) {
      final name = entity.group(1)!;
      if (name.startsWith('#x')) {
        return String.fromCharCode(int.parse(name.substring(2), radix: 16));
      }
      if (name.startsWith('#')) {
        return String.fromCharCode(int.parse(name.substring(1)));
      }
      return _namedEntities[name]!;
    });
    return textOf(text.replaceAll('&amp;', '&'));
  }
}
