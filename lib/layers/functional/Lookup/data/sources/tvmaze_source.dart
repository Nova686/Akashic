import 'package:akashic/layers/functional/Catalog/domain/entities/category_type.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/localized_titles.dart';
import 'package:akashic/layers/functional/Lookup/data/sources/json_fields.dart';
import 'package:akashic/layers/functional/Lookup/data/sources/source_http.dart';
import 'package:akashic/layers/functional/Lookup/domain/entities/source_match.dart';
import 'package:akashic/layers/functional/Lookup/domain/gateways/catalog_source.dart';
import 'package:http/http.dart' as http;

class TvmazeSource implements CatalogSource {
  TvmazeSource(this._client);

  static const String sourceKey = 'tvmaze';

  final http.Client _client;

  @override
  String get key => sourceKey;

  @override
  Set<CategoryType> get types => const {CategoryType.films};

  @override
  bool get isConfigured => true;

  @override
  bool get supportsBarcode => false;

  @override
  Future<List<SourceMatch>> search(String query) async {
    final results = listOf(await sourceGetJson(_client, Uri.https('api.tvmaze.com', '/search/shows', {'q': query.trim()}), sourceKey: key));
    return [
      for (final show in results.map((result) => mapOf(mapOf(result)['show'])))
        if ((show['id'], textOf(show['name'])) case (final int showId, final name?))
          SourceMatch(
            sourceKey: key,
            externalWorkId: '$showId',
            titles: LocalizedTitles(byLanguage: {'en': name}),
            year: yearOf(show['premiered']),
            publisher: textOf(mapOf(show['network'])['name']) ?? textOf(mapOf(show['webChannel'])['name']),
            imageUrl: textOf(mapOf(show['image'])['original'])?.replaceFirst('http://', 'https://'),
            format: 'TV',
            suggestedType: CategoryType.films,
          ),
    ];
  }

  @override
  Future<List<SourceMatch>> lookupBarcode(String barcode) async => const [];
}
