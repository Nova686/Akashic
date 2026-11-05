import 'package:akashic/layers/functional/Activity/domain/entities/activity_event.dart';
import 'package:akashic/layers/functional/Activity/domain/gateways/activity_log.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/collection_item.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/item_copy.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/item_photo.dart';
import 'package:akashic/layers/functional/Collection/domain/gateways/collection_gateway.dart';
import 'package:akashic/layers/functional/Collection/domain/use_cases/resolve_display_title.dart';
import 'package:akashic/layers/functional/Settings/domain/entities/preferred_languages.dart';
import 'package:equatable/equatable.dart';

enum MergeSide { first, second }

enum MergeField { identity, cover, purchase, rating, progress }

class MergePlan extends Equatable {
  const MergePlan({this.choices = const {}, this.joinsPhotos = true});

  final Map<MergeField, MergeSide> choices;
  final bool joinsPhotos;

  MergeSide sideOf(MergeField field) => choices[field] ?? MergeSide.first;

  MergePlan choose(MergeField field, MergeSide side) => MergePlan(choices: {...choices, field: side}, joinsPhotos: joinsPhotos);

  MergePlan withPhotos(bool joins) => MergePlan(choices: choices, joinsPhotos: joins);

  @override
  List<Object?> get props => [choices, joinsPhotos];
}

CollectionItem mergedItem(CollectionItem first, CollectionItem second, MergePlan plan) {
  CollectionItem pick(MergeField field) => plan.sideOf(field) == MergeSide.first ? first : second;
  final identity = pick(MergeField.identity);
  final cover = pick(MergeField.cover);
  return CollectionItem(
    id: first.id,
    categoryId: first.categoryId,
    seriesId: identity.seriesId ?? first.seriesId,
    volumeNumber: identity.volumeNumber,
    titles: identity.titles,
    creator: identity.creator,
    year: identity.year,
    publisher: identity.publisher,
    imagePath: cover.imagePath ?? (identical(cover, first) ? second.imagePath : first.imagePath),
    spineColorValue: cover.spineColorValue,
    rating: pick(MergeField.rating).rating,
    groupKey: first.groupKey ?? second.groupKey,
    sourceKey: identity.sourceKey ?? first.sourceKey ?? second.sourceKey,
    externalWorkId: identity.externalWorkId ?? first.externalWorkId ?? second.externalWorkId,
    cardKind: first.cardKind ?? second.cardKind,
    progress: pick(MergeField.progress).progress,
    addedAt: first.addedAt,
    marketValue: first.marketValue ?? second.marketValue,
  );
}

class MergeItems {
  MergeItems(this._collection, {this._activityLog, DateTime Function()? now}) : _now = now ?? DateTime.now;

  final CollectionGateway _collection;
  final ActivityLog? _activityLog;
  final DateTime Function() _now;

  Future<void> call(CollectionItem first, CollectionItem second, MergePlan plan) async {
    final result = mergedItem(first, second, plan);
    await _collection.saveItem(result);
    await _collection.saveProgress(result.id, result.progress);
    if (result.marketValue != first.marketValue) {
      await _collection.saveMarketValue(result.id, result.marketValue);
    }
    final firstCopies = await _collection.watchCopies(first.id).first;
    final secondCopies = await _collection.watchCopies(second.id).first;
    if (plan.sideOf(MergeField.purchase) == MergeSide.second && secondCopies.isNotEmpty) {
      for (final copy in firstCopies) {
        await _collection.deleteCopy(copy.id);
      }
      final kept = secondCopies.first;
      await _collection.saveCopy(ItemCopy(
        id: kept.id,
        itemId: first.id,
        edition: kept.edition,
        pricePaidCents: kept.pricePaidCents,
        location: kept.location,
        conditions: kept.conditions,
        barcode: kept.barcode,
        externalEditionId: kept.externalEditionId,
        loanedTo: kept.loanedTo,
        loanedSince: kept.loanedSince,
        isOpened: kept.isOpened,
        purchasedOn: kept.purchasedOn,
        purchaseChannel: kept.purchaseChannel,
      ));
    }
    if (plan.joinsPhotos) {
      final existing = await _collection.watchPhotos(first.id).first;
      for (final (index, photo) in (await _collection.watchPhotos(second.id).first).indexed) {
        await _collection.savePhoto(ItemPhoto(id: photo.id, itemId: first.id, path: photo.path, position: existing.length + index));
      }
    }
    await _collection.deleteItem(second.id);
    await _activityLog?.record(ActivityEvent(kind: ActivityKind.merged, title: resolveDisplayTitle(result.titles, PreferredLanguages.defaults) ?? '', at: _now(), itemId: first.id, categoryId: first.categoryId));
  }
}
