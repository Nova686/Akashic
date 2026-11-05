import 'package:akashic/layers/functional/Catalog/domain/entities/category_type.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/localized_titles.dart';
import 'package:akashic/layers/functional/Lookup/data/sources/json_fields.dart';
import 'package:akashic/layers/functional/Lookup/data/sources/source_http.dart';
import 'package:akashic/layers/functional/Lookup/domain/entities/source_match.dart';
import 'package:akashic/layers/functional/Lookup/domain/gateways/catalog_source.dart';
import 'package:http/http.dart' as http;

class DeezerSource implements CatalogSource {
  DeezerSource(this._client);

  static const String sourceKey = 'deezer';

  final http.Client _client;

  @override
  String get key => sourceKey;

  @override
  Set<CategoryType> get types => const {CategoryType.music};

  @override
  bool get isConfigured => true;

  @override
  bool get supportsBarcode => true;

  @override
  Future<List<SourceMatch>> search(String query) async {
    final json = mapOf(await sourceGetJson(_client, Uri.https('api.deezer.com', '/search/album', {'q': query.trim(), 'limit': '20'}), sourceKey: key));
    return [
      for (final album in listOf(json['data']).map(mapOf)) ?_matchOf(album),
    ];
  }

  @override
  Future<List<SourceMatch>> lookupBarcode(String barcode) async {
    for (final upc in {barcode, if (barcode.length == 13 && barcode.startsWith('0')) barcode.substring(1)}) {
      final album = mapOf(await sourceGetJson(_client, Uri.https('api.deezer.com', '/album/upc:$upc'), sourceKey: key));
      if (album['error'] == null) {
        if (_matchOf(album, barcode: barcode) case final match?) {
          return [match];
        }
      }
    }
    return const [];
  }

  SourceMatch? _matchOf(Map<String, Object?> album, {String? barcode}) {
    final albumId = album['id'];
    final title = textOf(album['title']);
    if (albumId is! int || title == null) {
      return null;
    }
    return SourceMatch(
      sourceKey: key,
      externalWorkId: '$albumId',
      titles: LocalizedTitles(byLanguage: {'en': title}),
      creator: textOf(mapOf(album['artist'])['name']),
      year: yearOf(album['release_date']),
      publisher: textOf(album['label']),
      barcode: barcode,
      imageUrl: textOf(album['cover_xl']) ?? textOf(album['cover_big']),
      suggestedType: CategoryType.music,
    );
  }
}
