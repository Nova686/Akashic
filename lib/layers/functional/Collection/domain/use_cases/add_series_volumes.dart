import 'package:akashic/layers/functional/Collection/domain/entities/collection_item.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/item_copy.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/series.dart';
import 'package:akashic/layers/functional/Collection/domain/gateways/collection_gateway.dart';
import 'package:uuid/uuid.dart';

class InvalidVolumeRange implements Exception {
  const InvalidVolumeRange(this.from, this.to);

  final int from;
  final int to;
}

class AddSeriesVolumes {
  AddSeriesVolumes(this._collection, {String Function()? newId}) : _newId = newId ?? const Uuid().v4;

  static const int maximumVolumesPerBatch = 500;

  final CollectionGateway _collection;
  final String Function() _newId;

  Future<List<int>> call({
    required Series series,
    required int from,
    required int to,
    required CollectionItem template,
    ItemCopy? copyTemplate,
    bool addsOwnedVolumesAgain = false,
  }) async {
    if (from < 1 || from > to || to - from + 1 > maximumVolumesPerBatch) {
      throw InvalidVolumeRange(from, to);
    }
    final existing = await _collection.volumeNumbersOf(series.id);
    final created = <int>[];
    for (var number = from; number <= to; number++) {
      if (existing.contains(number) && !addsOwnedVolumesAgain) {
        continue;
      }
      final itemId = _newId();
      await _collection.saveItem(CollectionItem(
        id: itemId,
        categoryId: series.categoryId,
        seriesId: series.id,
        volumeNumber: number,
        titles: template.titles,
        creator: template.creator ?? series.creator,
        year: template.year,
        publisher: template.publisher,
        imagePath: template.imagePath,
        spineColorValue: template.spineColorValue,
        rating: template.rating,
        groupKey: template.groupKey,
        sourceKey: template.sourceKey ?? series.sourceKey,
        externalWorkId: template.externalWorkId ?? series.externalWorkId,
        cardKind: template.cardKind,
      ));
      await _collection.saveCopy(ItemCopy(
        id: _newId(),
        itemId: itemId,
        edition: copyTemplate?.edition,
        pricePaidCents: copyTemplate?.pricePaidCents,
        location: copyTemplate?.location,
        conditions: copyTemplate?.conditions ?? const {},
        barcode: copyTemplate?.barcode,
        externalEditionId: copyTemplate?.externalEditionId,
      ));
      created.add(number);
    }
    return created;
  }
}
