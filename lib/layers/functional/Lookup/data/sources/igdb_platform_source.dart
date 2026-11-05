import 'package:akashic/layers/functional/Catalog/domain/entities/category_type.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/localized_titles.dart';
import 'package:akashic/layers/functional/Lookup/data/sources/igdb_source.dart';
import 'package:akashic/layers/functional/Lookup/data/sources/json_fields.dart';
import 'package:akashic/layers/functional/Lookup/domain/entities/source_match.dart';
import 'package:akashic/layers/functional/Lookup/domain/gateways/catalog_source.dart';

class IgdbPlatformSource implements CatalogSource {
  IgdbPlatformSource(this._igdb);

  final IgdbSource _igdb;

  @override
  String get key => 'igdb-platforms';

  @override
  Set<CategoryType> get types => const {CategoryType.consoles};

  @override
  bool get isConfigured => _igdb.isConfigured;

  @override
  bool get supportsBarcode => false;

  @override
  Future<List<SourceMatch>> search(String query) async => [
        for (final platform in await _igdb.platforms(query)) ?_matchOf(platform),
      ];

  SourceMatch? _matchOf(Map<String, Object?> platform) {
    final platformId = platform['id'];
    final name = textOf(platform['name']);
    if (platformId is! int || name == null) {
      return null;
    }
    final versions = listOf(platform['versions']).map(mapOf).toList();
    final releaseSeconds = [
      for (final version in versions)
        for (final release in listOf(version['platform_version_release_dates']).map(mapOf))
          if (release['date'] case final int seconds) seconds,
    ]..sort();
    final manufacturer = [
      for (final version in versions)
        for (final company in listOf(version['companies']).map(mapOf))
          if (company['manufacturer'] == true) ?textOf(mapOf(company['company'])['name']),
    ].firstOrNull;
    final logoId = textOf(mapOf(platform['platform_logo'])['image_id']) ??
        [for (final version in versions) ?textOf(mapOf(version['platform_logo'])['image_id'])].firstOrNull;
    return SourceMatch(
      sourceKey: key,
      externalWorkId: '$platformId',
      titles: LocalizedTitles(byLanguage: {'en': name}),
      creator: manufacturer,
      year: releaseSeconds.isEmpty ? null : DateTime.fromMillisecondsSinceEpoch(releaseSeconds.first * 1000, isUtc: true).year,
      imageUrl: logoId == null ? null : 'https://images.igdb.com/igdb/image/upload/t_logo_med/$logoId.png',
      suggestedType: CategoryType.consoles,
    );
  }

  @override
  Future<List<SourceMatch>> lookupBarcode(String barcode) async => const [];
}
