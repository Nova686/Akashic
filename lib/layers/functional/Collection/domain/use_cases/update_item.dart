import 'package:akashic/layers/functional/Collection/domain/entities/collection_item.dart';
import 'package:akashic/layers/functional/Collection/domain/gateways/collection_gateway.dart';

class ItemNotFound implements Exception {
  const ItemNotFound(this.itemId);

  final String itemId;
}

class UpdateItem {
  const UpdateItem(this._collection);

  final CollectionGateway _collection;

  Future<void> call(CollectionItem item) async {
    if (await _collection.watchItem(item.id).first == null) {
      throw ItemNotFound(item.id);
    }
    await _collection.saveItem(item);
  }
}
