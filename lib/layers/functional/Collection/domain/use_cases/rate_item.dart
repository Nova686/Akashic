import 'package:akashic/layers/functional/Collection/domain/entities/collection_item.dart';
import 'package:akashic/layers/functional/Collection/domain/gateways/collection_gateway.dart';

class RateItem {
  const RateItem(this._collection);

  final CollectionGateway _collection;

  Future<void> call(CollectionItem item, int? rating) {
    final boundedRating = rating?.clamp(0, 5);
    return _collection.saveItem(item.copyWith(rating: () => boundedRating));
  }
}
