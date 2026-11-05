import 'package:akashic/layers/functional/Collection/domain/entities/series.dart';
import 'package:akashic/layers/functional/Collection/domain/gateways/collection_gateway.dart';
import 'package:akashic/layers/functional/Lookup/domain/gateways/series_info_source.dart';

class UpdateSeriesFromSource {
  const UpdateSeriesFromSource(this._collection, this._source);

  final CollectionGateway _collection;
  final SeriesInfoSource _source;

  Future<Series> call(Series series, {required Set<int> ownedVolumes}) async {
    final externalWorkId = series.externalWorkId;
    if (externalWorkId == null || series.sourceKey != _source.key) {
      return series;
    }
    final info = await _source.seriesInfo(externalWorkId);
    if (info == null) {
      return series;
    }
    final highestOwned = ownedVolumes.isEmpty ? 0 : ownedVolumes.reduce((first, second) => first > second ? first : second);
    final known = info.volumeCount ?? series.publishedVolumes;
    final published = known == null ? null : (known > highestOwned ? known : highestOwned);
    final updated = series.copyWith(publishedVolumes: () => published, status: () => info.status ?? series.status);
    await _collection.saveSeries(updated);
    return updated;
  }
}
