import 'package:akashic/layers/functional/Catalog/domain/entities/category_type.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/localized_titles.dart';
import 'package:akashic/layers/functional/Lookup/data/sources/json_fields.dart';
import 'package:akashic/layers/functional/Lookup/data/sources/source_http.dart';
import 'package:akashic/layers/functional/Lookup/domain/entities/source_match.dart';
import 'package:akashic/layers/functional/Lookup/domain/gateways/catalog_source.dart';
import 'package:http/http.dart' as http;

class MangaDexSource implements CatalogSource {
  MangaDexSource(this._client);

  static const String sourceKey = 'mangadex';
  static const Set<String> keptLanguages = {'fr', 'en', 'ja', 'ja-Latn'};

  final http.Client _client;

  @override
  String get key => sourceKey;

  @override
  Set<CategoryType> get types => const {CategoryType.manga};

  @override
  bool get isConfigured => true;

  @override
  bool get supportsBarcode => false;

  @override
  Future<List<SourceMatch>> search(String query) async {
    final json = mapOf(await sourceGetJson(
      _client,
      Uri.parse('https://api.mangadex.org/manga').replace(queryParameters: {
        'title': query.trim(),
        'limit': '15',
        'includes[]': ['author', 'cover_art'],
      }),
      sourceKey: key,
    ));
    return [
      for (final manga in listOf(json['data']).map(mapOf)) ?_matchOf(manga),
    ];
  }

  SourceMatch? _matchOf(Map<String, Object?> manga) {
    final mangaId = textOf(manga['id']);
    final attributes = mapOf(manga['attributes']);
    final titles = <String, String>{};
    for (final localized in [mapOf(attributes['title']), ...listOf(attributes['altTitles']).map(mapOf)]) {
      for (final MapEntry(key: code, value: title) in localized.entries) {
        final language = code == 'ja-ro' ? 'ja-Latn' : code;
        if (keptLanguages.contains(language) && textOf(title) != null) {
          titles.putIfAbsent(language, () => textOf(title)!);
        }
      }
    }
    if (mangaId == null || titles.isEmpty) {
      return null;
    }
    final relationships = listOf(manga['relationships']).map(mapOf).toList();
    final authors = [
      for (final relation in relationships)
        if (relation['type'] == 'author') ?textOf(mapOf(relation['attributes'])['name']),
    ];
    final coverFile = [
      for (final relation in relationships)
        if (relation['type'] == 'cover_art') ?textOf(mapOf(relation['attributes'])['fileName']),
    ].firstOrNull;
    return SourceMatch(
      sourceKey: key,
      externalWorkId: mangaId,
      titles: LocalizedTitles(byLanguage: titles),
      creator: authors.isEmpty ? null : authors.join(', '),
      year: yearOf(attributes['year']),
      imageUrl: coverFile == null ? null : 'https://uploads.mangadex.org/covers/$mangaId/$coverFile.512.jpg',
      volumeCount: int.tryParse(textOf(attributes['lastVolume']) ?? ''),
      status: textOf(attributes['status'])?.toUpperCase(),
      suggestedType: CategoryType.manga,
    );
  }

  @override
  Future<List<SourceMatch>> lookupBarcode(String barcode) async => const [];
}
