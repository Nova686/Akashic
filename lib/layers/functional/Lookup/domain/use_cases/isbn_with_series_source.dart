import 'package:akashic/layers/functional/Catalog/domain/entities/category_type.dart';
import 'package:akashic/layers/functional/Collection/domain/use_cases/search_text_normalizer.dart';
import 'package:akashic/layers/functional/Lookup/domain/entities/source_match.dart';
import 'package:akashic/layers/functional/Lookup/domain/entities/source_unavailable.dart';
import 'package:akashic/layers/functional/Lookup/domain/gateways/catalog_source.dart';

class IsbnWithSeriesSource implements CatalogSource {
  IsbnWithSeriesSource(this._isbnSource, this._seriesSource);

  final CatalogSource _isbnSource;
  final CatalogSource _seriesSource;

  @override
  String get key => _isbnSource.key;

  @override
  Set<CategoryType> get types => _isbnSource.types;

  @override
  bool get isConfigured => _isbnSource.isConfigured;

  @override
  bool get supportsBarcode => true;

  @override
  Future<List<SourceMatch>> search(String query) => _isbnSource.search(query);

  @override
  Future<List<SourceMatch>> lookupBarcode(String barcode) async {
    final matches = await _isbnSource.lookupBarcode(barcode);
    return [for (final match in matches) await _withSeries(match)];
  }

  Future<SourceMatch> _withSeries(SourceMatch volume) async {
    final seriesTitle = volume.seriesTitle;
    if (volume.suggestedType != _seriesSource.types.firstOrNull || seriesTitle == null || !_seriesSource.isConfigured) {
      return volume;
    }
    final List<SourceMatch> candidates;
    try {
      candidates = await _seriesSource.search(seriesTitle);
    } on SourceUnavailable {
      return volume;
    }
    final wanted = normalizeForSearch(seriesTitle);
    final series = candidates.where((candidate) => candidate.titles.byLanguage.values.any((title) => normalizeForSearch(title) == wanted)).firstOrNull ??
        candidates.firstOrNull;
    if (series == null) {
      return volume;
    }
    return SourceMatch(
      sourceKey: series.sourceKey,
      externalWorkId: series.externalWorkId,
      externalEditionId: volume.externalWorkId,
      titles: series.titles,
      creator: series.creator ?? volume.creator,
      year: volume.year,
      publisher: volume.publisher,
      barcode: volume.barcode,
      imageUrl: volume.imageUrl ?? series.imageUrl,
      seriesTitle: seriesTitle,
      volumeNumber: volume.volumeNumber,
      volumeCount: series.volumeCount,
      status: series.status,
      suggestedType: series.suggestedType,
    );
  }
}
