import 'package:akashic/layers/functional/Catalog/domain/gateways/category_gateway.dart';
import 'package:akashic/layers/functional/Check/domain/entities/check_verdict.dart';
import 'package:akashic/layers/functional/Check/domain/entities/check_query_kind.dart';
import 'package:akashic/layers/functional/Check/domain/use_cases/add_from_match.dart';
import 'package:akashic/layers/functional/Check/domain/use_cases/check_ownership.dart';
import 'package:akashic/layers/functional/Check/domain/use_cases/normalize_barcode.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/collection_item.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/item_copy.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/localized_titles.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/series.dart';
import 'package:akashic/layers/functional/Collection/domain/gateways/collection_gateway.dart';
import 'package:akashic/layers/functional/Collection/domain/use_cases/add_item.dart';
import 'package:akashic/layers/functional/Collection/domain/use_cases/create_series.dart';
import 'package:akashic/layers/functional/Collection/domain/use_cases/search_text_normalizer.dart';
import 'package:akashic/layers/functional/Import/domain/entities/import_table.dart';
import 'package:akashic/layers/functional/Lookup/domain/entities/source_match.dart';
import 'package:uuid/uuid.dart';

class ResolveImportLine {
  ResolveImportLine(this._checkOwnership);

  final CheckOwnership _checkOwnership;

  Future<CheckVerdict> call(ImportLine line) async {
    final barcode = line.barcode == null ? null : normalizeBarcode(line.barcode!);
    if (barcode != null) {
      final byBarcode = await _checkOwnership.evaluate(CheckQueryKind.barcode, barcode);
      if (byBarcode is! NotOwned || byBarcode.match != null || line.searchText.isEmpty) {
        return byBarcode;
      }
    }
    return _checkOwnership.evaluate(CheckQueryKind.text, line.searchText);
  }
}

class ImportRows {
  ImportRows(this._addFromMatch, this._addItem, this._collection, this._categories, this._createSeries, {String Function()? newId})
      : _newId = newId ?? const Uuid().v4;

  final AddFromMatch _addFromMatch;
  final AddItem _addItem;
  final CollectionGateway _collection;
  final CategoryGateway _categories;
  final CreateSeries _createSeries;
  final String Function() _newId;

  Future<CollectionItem> call(ImportLine line, {required String categoryId, required String languageCode, SourceMatch? match}) async {
    final conditionParts = (await _categories.findById(categoryId))?.conditionParts ?? const <String>[];
    final barcode = line.barcode == null ? null : normalizeBarcode(line.barcode!) ?? line.barcode;
    final copyTemplate = ItemCopy(
      id: _newId(),
      itemId: '',
      edition: line.edition,
      pricePaidCents: line.priceCents,
      location: line.location,
      conditions: {
        if (line.condition case final condition?)
          for (final part in conditionParts) part: condition,
      },
    );
    final series = line.seriesTitle == null ? null : await _seriesNamed(line.seriesTitle!, categoryId, languageCode);
    if (match != null) {
      final added = await _addFromMatch(match, categoryId: categoryId, barcode: barcode, copyTemplate: copyTemplate);
      if (series == null || added.seriesId != null) {
        return added;
      }
      final placed = CollectionItem(
        id: added.id,
        categoryId: added.categoryId,
        titles: added.titles,
        creator: added.creator,
        year: added.year,
        publisher: added.publisher,
        imagePath: added.imagePath,
        spineColorValue: added.spineColorValue,
        groupKey: added.groupKey,
        sourceKey: added.sourceKey,
        externalWorkId: added.externalWorkId,
        cardKind: added.cardKind,
        rating: added.rating,
        seriesId: series.id,
        volumeNumber: line.volumeNumber ?? added.volumeNumber,
      );
      await _collection.saveItem(placed);
      return placed;
    }
    final itemId = _newId();
    return _addItem(
      CollectionItem(
        id: itemId,
        categoryId: categoryId,
        titles: LocalizedTitles(byLanguage: {languageCode: line.title ?? line.barcode ?? ''}),
        creator: line.creator,
        year: line.year,
        seriesId: series?.id,
        volumeNumber: series == null ? null : line.volumeNumber,
      ),
      firstCopy: ItemCopy(
        id: copyTemplate.id,
        itemId: itemId,
        edition: copyTemplate.edition,
        pricePaidCents: copyTemplate.pricePaidCents,
        location: copyTemplate.location,
        conditions: copyTemplate.conditions,
        barcode: barcode,
      ),
    );
  }

  Future<Series> _seriesNamed(String title, String categoryId, String languageCode) async {
    final wanted = normalizeForSearch(title);
    for (final series in await _collection.watchSeriesInCategoryTree(categoryId).first) {
      if (series.titles.byLanguage.values.any((candidate) => normalizeForSearch(candidate) == wanted)) {
        return series;
      }
    }
    return _createSeries(categoryId: categoryId, titles: LocalizedTitles(byLanguage: {languageCode: title.trim()}));
  }
}
