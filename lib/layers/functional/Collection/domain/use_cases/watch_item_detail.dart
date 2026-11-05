import 'package:akashic/layers/functional/Collection/domain/entities/collection_item.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/item_copy.dart';
import 'package:akashic/layers/functional/Collection/domain/gateways/collection_gateway.dart';

class WatchItemDetail {
  const WatchItemDetail(this._collection);

  final CollectionGateway _collection;

  Stream<CollectionItem?> item(String itemId) => _collection.watchItem(itemId);

  Stream<List<ItemCopy>> copies(String itemId) => _collection.watchCopies(itemId);
}
