import 'package:akashic/layers/functional/Collection/domain/entities/collection_item.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/deck_card.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/item_copy.dart';
import 'package:akashic/layers/functional/Collection/domain/gateways/collection_gateway.dart';
import 'package:akashic/layers/functional/Collection/domain/gateways/deck_gateway.dart';
import 'package:uuid/uuid.dart';

class AddAnotherItem {
  AddAnotherItem(this._collection, {this._decks, String Function()? newId}) : _newId = newId ?? const Uuid().v4;

  final CollectionGateway _collection;
  final DeckGateway? _decks;
  final String Function() _newId;

  Future<String?> call(String itemId, {String? barcode}) async {
    final original = await _collection.watchItem(itemId).first;
    if (original == null) {
      return null;
    }
    final originalCopy = (await _collection.watchCopies(itemId).first).firstOrNull;
    final anotherId = _newId();
    await _collection.saveItem(CollectionItem(
      id: anotherId,
      categoryId: original.categoryId,
      titles: original.titles,
      seriesId: original.seriesId,
      volumeNumber: original.volumeNumber,
      creator: original.creator,
      year: original.year,
      publisher: original.publisher,
      imagePath: original.imagePath,
      spineColorValue: original.spineColorValue,
      groupKey: original.groupKey,
      sourceKey: original.sourceKey,
      externalWorkId: original.externalWorkId,
      cardKind: original.cardKind,
    ));
    final isSameEdition = barcode == null || barcode == originalCopy?.barcode;
    await _collection.saveCopy(ItemCopy(
      id: _newId(),
      itemId: anotherId,
      edition: isSameEdition ? originalCopy?.edition : null,
      externalEditionId: isSameEdition ? originalCopy?.externalEditionId : null,
      barcode: barcode ?? originalCopy?.barcode,
    ));
    if (_decks case final decks?) {
      await decks.saveCards([
        for (final card in await decks.watchCards(itemId).first)
          DeckCard(
            id: _newId(),
            itemId: anotherId,
            name: card.name,
            quantity: card.quantity,
            externalCardId: card.externalCardId,
            imageUrl: card.imageUrl,
            sourceKey: card.sourceKey,
            price: card.price,
            traits: card.traits,
            commanderRole: card.commanderRole,
          ),
      ]);
    }
    if (original.marketValue case final value?) {
      await _collection.saveMarketValue(anotherId, value);
    }
    return anotherId;
  }
}
