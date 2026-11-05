import 'package:akashic/layers/functional/Collection/domain/entities/item_copy.dart';
import 'package:akashic/layers/functional/Collection/domain/gateways/collection_gateway.dart';

class UpdateCopy {
  const UpdateCopy(this._collection);

  final CollectionGateway _collection;

  Future<void> call(ItemCopy copy) => _collection.saveCopy(copy);
}
