import 'package:akashic/layers/functional/Catalog/domain/entities/category_type.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/localized_titles.dart';
import 'package:akashic/layers/functional/Lookup/data/sources/json_fields.dart';
import 'package:akashic/layers/functional/Lookup/data/sources/language_codes.dart';
import 'package:akashic/layers/functional/Lookup/data/sources/source_http.dart';
import 'package:akashic/layers/functional/Lookup/domain/entities/source_match.dart';
import 'package:akashic/layers/functional/Lookup/domain/gateways/catalog_source.dart';
import 'package:http/http.dart' as http;

class OpenLibrarySource implements CatalogSource {
  OpenLibrarySource(this._client);

  static const String sourceKey = 'openlibrary';
  static const String _fields = 'key,title,author_name,first_publish_year,cover_i,publisher,language,isbn';

  final http.Client _client;

  @override
  String get key => sourceKey;

  @override
  Set<CategoryType> get types => const {CategoryType.books, CategoryType.comics};

  @override
  bool get isConfigured => true;

  @override
  bool get supportsBarcode => true;

  Future<List<SourceMatch>> _search(Map<String, String> parameters, {String? scannedIsbn}) async {
    final json = mapOf(await sourceGetJson(_client, Uri.https('openlibrary.org', '/search.json', {...parameters, 'fields': _fields}), sourceKey: key));
    return [
      for (final work in listOf(json['docs']).map(mapOf))
        if ((textOf(work['key']), textOf(work['title'])) case (final workKey?, final title?))
          SourceMatch(
            sourceKey: key,
            externalWorkId: workKey.replaceFirst('/works/', ''),
            titles: LocalizedTitles(byLanguage: {twoLetterLanguage(textOf(listOf(work['language']).firstOrNull)): title}),
            creator: switch (listOf(work['author_name']).whereType<String>().toList()) {
              final authors when authors.isNotEmpty => authors.join(', '),
              _ => null,
            },
            year: yearOf(work['first_publish_year']),
            publisher: textOf(listOf(work['publisher']).firstOrNull),
            barcode: scannedIsbn,
            imageUrl: switch (work['cover_i']) {
              final int coverId => 'https://covers.openlibrary.org/b/id/$coverId-L.jpg',
              _ => null,
            },
            suggestedType: CategoryType.books,
          ),
    ];
  }

  @override
  Future<List<SourceMatch>> search(String query) => _search({'q': query.trim(), 'limit': '20'});

  @override
  Future<List<SourceMatch>> lookupBarcode(String barcode) => _search({'isbn': barcode, 'limit': '1'}, scannedIsbn: barcode);
}
