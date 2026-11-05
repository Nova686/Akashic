import 'dart:async';

import 'package:akashic/layers/functional/Collection/domain/entities/collection_item.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/series.dart';
import 'package:akashic/layers/functional/Collection/domain/gateways/collection_gateway.dart';

class WatchSeriesVolumes {
  const WatchSeriesVolumes(this._collection);

  final CollectionGateway _collection;

  Stream<Series?> series(String seriesId) => _collection.watchAllSeries().map((all) => all.where((series) => series.id == seriesId).firstOrNull);

  Stream<List<CollectionItem>> volumes(Series series) => _collection
      .watchItemsInCategoryTree(series.categoryId)
      .map((items) => items.where((item) => item.seriesId == series.id).toList()..sort((first, second) => (first.volumeNumber ?? 0).compareTo(second.volumeNumber ?? 0)));
}

class SetPublishedVolumes {
  const SetPublishedVolumes(this._collection);

  final CollectionGateway _collection;

  Future<Series> call(Series series, int? publishedVolumes) async {
    final updated = series.copyWith(publishedVolumes: () => publishedVolumes == null || publishedVolumes < 1 ? null : publishedVolumes);
    await _collection.saveSeries(updated);
    return updated;
  }
}
