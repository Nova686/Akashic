import 'package:akashic/layers/functional/Collection/domain/entities/market_value.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/collection_item.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/item_progress.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/item_copy.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/item_photo.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/owned_work.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/series.dart';

abstract interface class CollectionGateway {
  Future<void> saveItem(CollectionItem item);
  Future<void> saveSeries(Series series);
  Future<void> saveCopy(ItemCopy copy);
  Future<void> deleteCopy(String copyId);
  Future<void> deleteItem(String itemId);
  Future<void> saveProgress(String itemId, ItemProgress? progress);
  Stream<List<ItemPhoto>> watchPhotos(String itemId);
  Future<void> savePhoto(ItemPhoto photo);
  Future<void> deletePhoto(String photoId);
  Future<void> deleteSeries(String seriesId);
  Future<void> setGroupKey(String itemId, String? groupKey);
  Future<void> saveMarketValue(String itemId, MarketValue? value);
  Future<void> saveMarketValues(Map<String, MarketValue?> valuesByItem);
  Future<Map<String, Set<int>>> ownedVolumesBySeries();
  Future<void> saveCover(String itemId, {required String imagePath, int? spineColorValue});
  Future<void> moveItem(String itemId, {required String categoryId, required bool leavesSeries});
  Future<void> moveSeries(String seriesId, {required String categoryId});
  Stream<List<CollectionItem>> watchItemsInCategoryTree(String categoryId);
  Stream<List<Series>> watchSeriesInCategoryTree(String categoryId);
  Stream<List<Series>> watchAllSeries();
  Stream<CollectionItem?> watchItem(String itemId);
  Stream<List<ItemCopy>> watchCopies(String itemId);
  Future<List<CollectionItem>> allItems();
  Future<Map<String, ItemCopy>> firstCopiesByItem();
  Future<void> savePreorder(String itemId, Preorder? preorder);
  Future<Set<int>> volumeNumbersOf(String seriesId);
  Stream<List<OwnedWork>> watchOwnedWorks();
  Future<CollectionItem?> findByExternalWork(String sourceKey, String externalWorkId);
  Future<List<(CollectionItem, ItemCopy)>> findCopiesByBarcode(String normalizedBarcode);
}
