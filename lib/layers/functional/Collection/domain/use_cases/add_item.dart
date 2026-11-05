import 'package:akashic/layers/functional/Catalog/domain/gateways/category_gateway.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/collection_item.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/item_copy.dart';
import 'package:akashic/layers/functional/Collection/domain/gateways/collection_gateway.dart';
import 'package:uuid/uuid.dart';

class ItemNeedsLeafCategory implements Exception {
  const ItemNeedsLeafCategory(this.categoryId);

  final String categoryId;
}

class AddItem {
  AddItem(this._collection, this._categories, {String Function()? newId}) : _newId = newId ?? const Uuid().v4;

  final CollectionGateway _collection;
  final CategoryGateway _categories;
  final String Function() _newId;

  Future<CollectionItem> call(CollectionItem item, {ItemCopy? firstCopy}) async {
    if (await _categories.countChildrenOf(item.categoryId) > 0) {
      throw ItemNeedsLeafCategory(item.categoryId);
    }
    await _collection.saveItem(item);
    await _collection.saveCopy(ItemCopy(
      id: firstCopy?.id ?? _newId(),
      itemId: item.id,
      edition: firstCopy?.edition,
      pricePaidCents: firstCopy?.pricePaidCents,
      location: firstCopy?.location,
      conditions: firstCopy?.conditions ?? const {},
      barcode: firstCopy?.barcode,
      externalEditionId: firstCopy?.externalEditionId,
    ));
    return item;
  }
}
