import 'package:akashic/layers/functional/Catalog/domain/entities/category_type.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/localized_titles.dart';
import 'package:akashic/layers/functional/Lookup/data/sources/json_fields.dart';
import 'package:akashic/layers/functional/Lookup/domain/entities/source_match.dart';
import 'package:akashic/layers/functional/Lookup/domain/gateways/catalog_source.dart';
import 'package:akashic/layers/functional/Lookup/domain/use_cases/volume_title.dart';
import 'package:akashic/layers/functional/Lookup/data/sources/source_http.dart';
import 'package:http/http.dart' as http;

class GoogleBooksSource implements CatalogSource {
  GoogleBooksSource(this._client, {this._apiKey = ''});

  static const String sourceKey = 'googlebooks';
  static const Set<String> mangaPublishers = {
    'kana', 'pika', 'pika édition', 'glénat', 'glénat manga', 'ki-oon', 'kurokawa', 'kazé', 'kaze', 'tonkam', 'delcourt tonkam', 'akata', 'doki-doki',
    'soleil manga', 'panini manga', 'noeve', 'noeve grafx', 'mangetsu', 'vega', 'vega-dupuis', 'crunchyroll', 'ototo', 'meian', 'nobi nobi', 'kotoba',
    'black box', 'casterman sakka', 'shueisha', 'kodansha', 'shogakukan', 'square enix', 'viz media', 'yen press', 'seven seas',
  };

  final http.Client _client;
  final String _apiKey;

  @override
  String get key => sourceKey;

  @override
  Set<CategoryType> get types => const {CategoryType.books, CategoryType.comics};

  @override
  bool get isConfigured => _apiKey.isNotEmpty;

  @override
  bool get supportsBarcode => true;

  Future<List<SourceMatch>> _query(String query, {String? barcode}) async {
    final uri = Uri.https('www.googleapis.com', '/books/v1/volumes', {'q': query, 'maxResults': '10', if (_apiKey.isNotEmpty) 'key': _apiKey});
    final json = mapOf(await sourceGetJson(_client, uri, sourceKey: key));
    return [
      for (final volume in listOf(json['items']).map(mapOf))
        if (textOf(mapOf(volume['volumeInfo'])['title']) != null && textOf(volume['id']) != null)
          _toMatch(volume, barcode),
    ];
  }

  SourceMatch _toMatch(Map<String, Object?> volume, String? barcode) {
    final info = mapOf(volume['volumeInfo']);
    final language = textOf(info['language']) ?? 'en';
    final isbn13 = listOf(info['industryIdentifiers']).map(mapOf).where((identifier) => identifier['type'] == 'ISBN_13').map((identifier) => textOf(identifier['identifier'])).firstOrNull;
    final title = textOf(info['title'])!;
    final fullTitle = [title, ?textOf(info['subtitle'])].join(' - ');
    final numbered = parseVolumeTitle(fullTitle) ?? parseVolumeTitle(title);
    final type = _typeOf(info);
    return SourceMatch(
      sourceKey: key,
      externalWorkId: textOf(volume['id'])!,
      titles: LocalizedTitles(byLanguage: {language: textOf(info['title'])!}, originalLanguage: null),
      creator: firstTextOf(info['authors']),
      year: yearOf(info['publishedDate']),
      publisher: textOf(info['publisher']),
      barcode: barcode ?? isbn13,
      imageUrl: httpsUrl(mapOf(info['imageLinks'])['thumbnail']),
      seriesTitle: type == CategoryType.books ? null : numbered?.seriesTitle,
      volumeNumber: type == CategoryType.books ? null : numbered?.volumeNumber,
      suggestedType: type,
    );
  }

  static String normalizedPublisher(String publisher) =>
      ' ${publisher.toLowerCase()} '.replaceAll(RegExp(r'(?<=\s)(?:éditions|édition|editions|edition|éd\.)(?=\s)'), ' ').replaceAll(RegExp(r'\s+'), ' ').trim();

  static bool isMangaPublisher(String publisher) {
    final normalized = normalizedPublisher(publisher);
    return normalized.split(' ').contains('manga') || mangaPublishers.contains(normalized);
  }

  CategoryType _typeOf(Map<String, Object?> info) {
    final categories = listOf(info['categories']).map(textOf).nonNulls.map((category) => category.toLowerCase()).toList();
    final publisher = textOf(info['publisher'])?.toLowerCase();
    if (categories.any((category) => category.contains('manga')) || (publisher != null && isMangaPublisher(publisher))) {
      return CategoryType.manga;
    }
    if (categories.any((category) => category.contains('comics') || category.contains('bandes dessinées') || category.contains('graphic novels'))) {
      return CategoryType.comics;
    }
    return CategoryType.books;
  }

  @override
  Future<List<SourceMatch>> search(String query) => _query(query);

  @override
  Future<List<SourceMatch>> lookupBarcode(String barcode) => _query('isbn:$barcode', barcode: barcode);
}
