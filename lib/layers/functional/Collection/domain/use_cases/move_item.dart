import 'package:akashic/layers/functional/Collection/domain/entities/collection_item.dart';
import 'package:akashic/layers/functional/Collection/domain/gateways/collection_gateway.dart';

enum SeriesMove { wholeSeries, thisItemOnly }

class MoveItem {
  const MoveItem(this._collection);

  final CollectionGateway _collection;

  Future<void> call(CollectionItem item, {required String targetCategoryId, SeriesMove seriesMove = SeriesMove.thisItemOnly}) async {
    final seriesId = item.seriesId;
    if (seriesId != null && seriesMove == SeriesMove.wholeSeries) {
      await _collection.moveSeries(seriesId, categoryId: targetCategoryId);
      return;
    }
    if (item.categoryId == targetCategoryId) {
      return;
    }
    await _collection.moveItem(item.id, categoryId: targetCategoryId, leavesSeries: seriesId != null);
  }
}
