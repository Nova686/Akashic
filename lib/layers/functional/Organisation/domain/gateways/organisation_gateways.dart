import 'package:akashic/layers/functional/Organisation/domain/entities/smart_shelf.dart';
import 'package:akashic/layers/functional/Organisation/domain/entities/storage_place.dart';

abstract interface class TagGateway {
  Stream<Set<String>> watchTagsOf(String itemId);
  Future<void> setTags(String itemId, Set<String> tags);
  Future<Map<String, Set<String>>> tagsByItem();
  Stream<Map<String, int>> watchTagCounts();
}

abstract interface class SmartShelfGateway {
  Stream<List<SmartShelf>> watchAll();
  Future<void> save(SmartShelf shelf);
  Future<void> delete(String shelfId);
}

abstract interface class StoragePlanGateway {
  Stream<List<StoragePlace>> watchAll();
  Future<void> save(StoragePlace place);
  Future<void> delete(List<String> placeIds);
}
