import 'package:akashic/layers/functional/Collection/domain/entities/series.dart';
import 'package:akashic/layers/functional/Collection/domain/gateways/collection_gateway.dart';

class WatchCategorySeries {
  const WatchCategorySeries(this._collection);

  final CollectionGateway _collection;

  Stream<List<Series>> call(String categoryId) => _collection.watchSeriesInCategoryTree(categoryId);
}
