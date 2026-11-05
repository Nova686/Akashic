import 'package:akashic/layers/functional/Catalog/domain/entities/category_type.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/localized_titles.dart';
import 'package:akashic/layers/functional/Lookup/data/sources/json_fields.dart';
import 'package:akashic/layers/functional/Lookup/data/sources/source_http.dart';
import 'package:akashic/layers/functional/Lookup/domain/entities/source_match.dart';
import 'package:akashic/layers/functional/Lookup/domain/gateways/catalog_source.dart';
import 'package:http/http.dart' as http;

class AmiiboSource implements CatalogSource {
  AmiiboSource(this._client);

  static const String sourceKey = 'amiiboapi';

  final http.Client _client;

  @override
  String get key => sourceKey;

  @override
  Set<CategoryType> get types => const {CategoryType.amiibo};

  @override
  bool get isConfigured => true;

  @override
  bool get supportsBarcode => false;

  @override
  Future<List<SourceMatch>> search(String query) async {
    final json = mapOf(await sourceGetJson(_client, Uri.https('www.amiiboapi.com', '/api/amiibo/', {'name': query.trim()}), sourceKey: key));
    return [
      for (final amiibo in listOf(json['amiibo']).map(mapOf))
        if ((textOf(amiibo['name']), '${textOf(amiibo['head']) ?? ''}${textOf(amiibo['tail']) ?? ''}') case (final name?, final identifier) when identifier.isNotEmpty)
          SourceMatch(
            sourceKey: key,
            externalWorkId: identifier,
            titles: LocalizedTitles(byLanguage: {'en': name}),
            creator: textOf(amiibo['amiiboSeries']),
            seriesTitle: textOf(amiibo['gameSeries']),
            year: yearOf(mapOf(amiibo['release'])['eu']) ?? yearOf(mapOf(amiibo['release'])['na']),
            imageUrl: textOf(amiibo['image']),
            suggestedType: CategoryType.amiibo,
          ),
    ];
  }

  @override
  Future<List<SourceMatch>> lookupBarcode(String barcode) async => const [];
}
