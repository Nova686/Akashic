import 'package:akashic/layers/functional/Collection/domain/entities/collection_item.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/item_copy.dart';
import 'package:akashic/layers/functional/Collection/domain/use_cases/delete_unshared_images.dart';
import 'package:akashic/layers/functional/Collection/domain/gateways/collection_gateway.dart';
import 'package:akashic/layers/functional/Collection/domain/use_cases/move_item.dart';

class BulkItemActions {
  const BulkItemActions(this._collection, {this._deleteImage});

  final CollectionGateway _collection;
  final Future<void> Function(String path)? _deleteImage;

  Future<void> move(List<CollectionItem> items, {required String targetCategoryId, required SeriesMove seriesMove}) async {
    final moveItem = MoveItem(_collection);
    final movedSeries = <String>{};
    for (final item in items) {
      final seriesId = item.seriesId;
      if (seriesMove == SeriesMove.wholeSeries && seriesId != null && !movedSeries.add(seriesId)) {
        continue;
      }
      await moveItem(item, targetCategoryId: targetCategoryId, seriesMove: seriesMove);
    }
  }

  Future<void> storeAt(List<CollectionItem> items, String location) async {
    final trimmed = location.trim();
    for (final item in items) {
      for (final copy in await _collection.watchCopies(item.id).first) {
        await _collection.saveCopy(ItemCopy(
          id: copy.id,
          itemId: copy.itemId,
          edition: copy.edition,
          pricePaidCents: copy.pricePaidCents,
          location: trimmed.isEmpty ? null : trimmed,
          conditions: copy.conditions,
          barcode: copy.barcode,
          externalEditionId: copy.externalEditionId,
          loanedTo: copy.loanedTo,
          loanedSince: copy.loanedSince,
          isOpened: copy.isOpened,
          purchasedOn: copy.purchasedOn,
          purchaseChannel: copy.purchaseChannel,
        ));
      }
    }
  }

  Future<void> delete(List<CollectionItem> items) async {
    final deleteImage = _deleteImage;
    final paths = <String>[];
    for (final item in items) {
      final photos = await _collection.watchPhotos(item.id).first;
      await _collection.deleteItem(item.id);
      paths.addAll([?item.imagePath, for (final photo in photos) photo.path]);
    }
    if (deleteImage != null) {
      await deleteUnsharedImages(_collection, deleteImage, paths);
    }
  }
}
