import 'package:akashic/layers/functional/Catalog/domain/entities/category_type.dart';
import 'package:akashic/layers/functional/Check/domain/gateways/cover_image_gateway.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/collection_item.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/item_copy.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/localized_titles.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/series.dart';
import 'package:akashic/layers/functional/Collection/domain/gateways/collection_gateway.dart';
import 'package:akashic/layers/functional/Collection/domain/use_cases/add_item.dart';
import 'package:akashic/layers/functional/Collection/domain/use_cases/search_text_normalizer.dart';
import 'package:akashic/layers/functional/Lookup/domain/entities/source_match.dart';
import 'package:akashic/layers/functional/Lookup/domain/use_cases/volume_title.dart';
import 'package:uuid/uuid.dart';

String? editionLabelOf(SourceMatch match) {
  final parts = [?match.format, ?match.year?.toString()];
  return parts.isEmpty ? null : parts.join(', ');
}

String? groupKeyOf(SourceMatch match) => switch (match.suggestedType) {
      CategoryType.music => match.creator,
      CategoryType.videoGames => match.platform,
      _ => null,
    };

class AddFromMatch {
  AddFromMatch(
    this._addItem,
    this._collection,
    this._covers, {
    String Function()? newId,
  }) : _newId = newId ?? const Uuid().v4;

  final AddItem _addItem;
  final CollectionGateway _collection;
  final CoverImageGateway _covers;
  final String Function() _newId;

  Future<CollectionItem> call(SourceMatch match, {required String categoryId, String? barcode, ItemCopy? copyTemplate}) async {
    final (imagePath, spineColor) = await _storeCover(match.imageUrl);
    final series = match.volumeNumber == null ? null : await _seriesFor(match, categoryId);
    final item = CollectionItem(
      id: _newId(),
      categoryId: categoryId,
      seriesId: series?.id,
      volumeNumber: series == null ? null : match.volumeNumber,
      titles: match.titles,
      creator: match.creator,
      year: match.year,
      publisher: match.publisher,
      imagePath: imagePath,
      spineColorValue: spineColor,
      groupKey: groupKeyOf(match),
      sourceKey: match.sourceKey,
      externalWorkId: match.externalWorkId,
    );
    return _addItem(
      item,
      firstCopy: ItemCopy(
        id: _newId(),
        itemId: item.id,
        edition: copyTemplate?.edition ?? editionLabelOf(match),
        pricePaidCents: copyTemplate?.pricePaidCents,
        location: copyTemplate?.location,
        conditions: copyTemplate?.conditions ?? const {},
        barcode: barcode ?? match.barcode,
        externalEditionId: match.externalEditionId,
      ),
    );
  }

  Future<Series> _seriesFor(SourceMatch match, String categoryId) async {
    final titles = {
      ...match.titles.byLanguage.values.map(normalizeForSearch),
      if (match.seriesTitle case final seriesTitle?) normalizeForSearch(seriesTitle),
    };
    for (final series in await _collection.watchSeriesInCategoryTree(categoryId).first) {
      final sameWork = series.sourceKey == match.sourceKey && series.externalWorkId == match.externalWorkId;
      if (sameWork || series.titles.byLanguage.values.map(normalizeForSearch).any(titles.contains)) {
        return series;
      }
    }
    final titlesNameTheSeries = match.titles.byLanguage.isNotEmpty && match.titles.byLanguage.values.every((title) => parseVolumeTitle(title) == null);
    final created = Series(
      id: _newId(),
      categoryId: categoryId,
      titles: titlesNameTheSeries
          ? match.titles
          : LocalizedTitles(byLanguage: {match.titles.byLanguage.keys.firstOrNull ?? 'fr': match.seriesTitle ?? match.titles.byLanguage.values.firstOrNull ?? ''}),
      creator: match.creator,
      sourceKey: titlesNameTheSeries ? match.sourceKey : null,
      externalWorkId: titlesNameTheSeries ? match.externalWorkId : null,
      publishedVolumes: match.volumeCount,
      status: match.status,
    );
    await _collection.saveSeries(created);
    return created;
  }

  Future<ItemCopy> addCopyFromMatch(CollectionItem owned, SourceMatch match, {String? barcode}) async {
    final copy = ItemCopy(
      id: _newId(),
      itemId: owned.id,
      edition: editionLabelOf(match),
      barcode: barcode ?? match.barcode,
      externalEditionId: match.externalEditionId,
    );
    await _collection.saveCopy(copy);
    return copy;
  }

  Future<CollectionItem?> completeProvisional(String itemId, SourceMatch match) async {
    final provisional = await _collection.watchItem(itemId).first;
    if (provisional == null) {
      return null;
    }
    final (imagePath, spineColor) = await _storeCover(match.imageUrl);
    final completed = CollectionItem(
      id: provisional.id,
      categoryId: provisional.categoryId,
      titles: match.titles,
      creator: match.creator,
      year: match.year,
      publisher: match.publisher,
      imagePath: imagePath ?? provisional.imagePath,
      spineColorValue: spineColor ?? provisional.spineColorValue,
      rating: provisional.rating,
      groupKey: groupKeyOf(match),
      sourceKey: match.sourceKey,
      externalWorkId: match.externalWorkId,
    );
    await _collection.saveItem(completed);
    return completed;
  }

  Future<(String?, int?)> _storeCover(String? imageUrl) async {
    if (imageUrl == null) {
      return (null, null);
    }
    final cover = await _covers.storeCover(imageUrl);
    return (cover?.path, cover?.spineColorValue);
  }
}
