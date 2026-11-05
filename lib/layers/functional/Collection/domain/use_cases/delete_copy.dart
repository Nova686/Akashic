import 'package:akashic/layers/functional/Collection/domain/entities/item_copy.dart';
import 'package:akashic/layers/functional/Collection/domain/gateways/collection_gateway.dart';
import 'package:akashic/layers/functional/Collection/domain/use_cases/delete_unshared_images.dart';

enum CopyDeletion { copyOnly, wholeItem }

class DeleteCopy {
  const DeleteCopy(this._collection, {this._deleteImage});

  final CollectionGateway _collection;
  final Future<void> Function(String path)? _deleteImage;

  Future<bool> isLastCopy(ItemCopy copy) async => (await _collection.watchCopies(copy.itemId).first).length <= 1;

  Future<CopyDeletion> call(ItemCopy copy) async {
    if (!await isLastCopy(copy)) {
      final copyPhotos = [for (final photo in await _collection.watchPhotos(copy.itemId).first) if (photo.copyId == copy.id) photo];
      for (final photo in copyPhotos) {
        await _collection.deletePhoto(photo.id);
      }
      await _collection.deleteCopy(copy.id);
      final deleteImage = _deleteImage;
      if (deleteImage != null) {
        for (final photo in copyPhotos) {
          await deleteImage(photo.path);
        }
      }
      return CopyDeletion.copyOnly;
    }
    final item = await _collection.watchItem(copy.itemId).first;
    final photos = await _collection.watchPhotos(copy.itemId).first;
    await _collection.deleteItem(copy.itemId);
    final deleteImage = _deleteImage;
    if (deleteImage != null) {
      await deleteUnsharedImages(_collection, deleteImage, [?item?.imagePath, for (final photo in photos) photo.path]);
    }
    return CopyDeletion.wholeItem;
  }
}
