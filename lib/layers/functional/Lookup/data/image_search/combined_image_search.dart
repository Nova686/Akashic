import 'package:akashic/layers/functional/Lookup/presentation/source_failure_toast.dart';
import 'package:akashic/layers/functional/Lookup/data/sources/json_fields.dart';
import 'package:akashic/layers/functional/Lookup/domain/entities/source_match.dart';
import 'package:akashic/layers/functional/Lookup/domain/gateways/image_search.dart';
import 'package:akashic/layers/functional/Lookup/data/sources/source_http.dart';
import 'package:akashic/layers/functional/Lookup/domain/entities/source_unavailable.dart';
import 'package:http/http.dart' as http;

class CombinedImageSearch implements ImageSearch {
  CombinedImageSearch(this._client);

  static const int maximumImages = 12;

  final http.Client _client;

  @override
  Future<List<String>> imagesFor(SourceMatch? match, String query) async {
    final images = <String>[?match?.imageUrl];
    try {
      images.addAll(await _commonsImages(query));
    } on SourceUnavailable catch (failure) {
      showSourceFailure(failure);
      return images.toSet().take(maximumImages).toList();
    }
    return images.toSet().take(maximumImages).toList();
  }

  Future<List<String>> _commonsImages(String query) async {
    if (query.trim().isEmpty) {
      return const [];
    }
    final uri = Uri.https('commons.wikimedia.org', '/w/api.php', {
      'action': 'query',
      'generator': 'search',
      'gsrsearch': query,
      'gsrnamespace': '6',
      'gsrlimit': '$maximumImages',
      'prop': 'imageinfo',
      'iiprop': 'url',
      'iiurlwidth': '600',
      'format': 'json',
    });
    final pages = mapOf(mapOf(mapOf(await sourceGetJson(_client, uri, sourceKey: 'commons'))['query'])['pages']).values.map(mapOf).toList()
      ..sort((first, second) => ((first['index'] as int?) ?? 0).compareTo((second['index'] as int?) ?? 0));
    return [
      for (final page in pages) ?textOf(mapOf(listOf(page['imageinfo']).firstOrNull)['thumburl']),
    ];
  }
}
