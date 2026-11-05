import 'package:akashic/layers/functional/Collection/domain/entities/item_copy.dart';
import 'package:akashic/layers/functional/Collection/domain/gateways/collection_gateway.dart';
import 'package:uuid/uuid.dart';

class AddCopy {
  AddCopy(this._collection, {String Function()? newId}) : _newId = newId ?? const Uuid().v4;

  final CollectionGateway _collection;
  final String Function() _newId;

  Future<ItemCopy> call(String itemId) async {
    final copy = ItemCopy(id: _newId(), itemId: itemId);
    await _collection.saveCopy(copy);
    return copy;
  }
}
