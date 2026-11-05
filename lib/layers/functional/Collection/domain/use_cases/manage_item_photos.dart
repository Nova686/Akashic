import 'dart:typed_data';

import 'package:akashic/layers/functional/Collection/domain/entities/item_photo.dart';
import 'package:akashic/layers/functional/Collection/domain/gateways/collection_gateway.dart';
import 'package:uuid/uuid.dart';

class ManageItemPhotos {
  ManageItemPhotos(this._collection, {required this._storeImage, required this._deleteImage, String Function()? newId}) : _newId = newId ?? const Uuid().v4;

  final CollectionGateway _collection;
  final Future<String> Function(Uint8List bytes) _storeImage;
  final Future<void> Function(String path) _deleteImage;
  final String Function() _newId;

  Stream<List<ItemPhoto>> watch(String itemId) => _collection.watchPhotos(itemId);

  Future<void> add(String itemId, Uint8List bytes, {String? copyId}) async {
    final existing = await _collection.watchPhotos(itemId).first;
    final path = await _storeImage(bytes);
    final nextPosition = existing.fold(-1, (highest, photo) => photo.position > highest ? photo.position : highest) + 1;
    await _collection.savePhoto(ItemPhoto(id: _newId(), itemId: itemId, copyId: copyId, path: path, position: nextPosition));
  }

  Future<void> delete(ItemPhoto photo) async {
    await _collection.deletePhoto(photo.id);
    await _deleteImage(photo.path);
  }
}
