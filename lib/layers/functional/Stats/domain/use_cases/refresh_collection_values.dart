import 'package:akashic/layers/functional/Catalog/domain/entities/category_type.dart';
import 'package:akashic/layers/functional/Catalog/domain/gateways/category_gateway.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/card_kind.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/collection_item.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/market_value.dart';
import 'package:akashic/layers/functional/Collection/domain/gateways/collection_gateway.dart';
import 'package:akashic/layers/functional/Collection/domain/use_cases/update_card_prices.dart';
import 'package:akashic/layers/functional/Lookup/domain/entities/source_unavailable.dart';
import 'package:akashic/layers/functional/Lookup/domain/gateways/record_market.dart';
import 'package:akashic/layers/functional/Stats/domain/entities/collection_value.dart';

class RefreshCollectionValues {
  RefreshCollectionValues(this._collection, this._categories, this._records, this._updateCardPrices, {DateTime Function()? now}) : _now = now ?? DateTime.now;

  static const Duration freshValue = Duration(hours: 24);
  static const int valuesPerSave = 20;

  static const String recordSourceKey = 'discogs';

  final CollectionGateway _collection;
  final CategoryGateway _categories;
  final RecordMarket _records;
  final UpdateCardPrices _updateCardPrices;
  final DateTime Function() _now;

  Future<ValueRefresh> call({void Function(int done, int total)? onProgress}) async {
    final typeOf = {
      for (final node in await _categories.watchTree().first) ...{node.category.id: node.category.type, for (final child in node.children) child.id: child.type},
    };
    final items = await _collection.allItems();
    final records = [
      for (final item in items)
        if (typeOf[item.categoryId] == CategoryType.music && item.sourceKey == recordSourceKey) item,
    ];
    final decks = [
      for (final item in items)
        if (item.cardKind == CardKind.deck) item,
    ];
    final total = records.length + decks.length;
    var done = 0;
    var recordsValued = 0;
    var decksPriced = 0;
    final now = _now();
    final pendingValues = <String, MarketValue?>{};
    Future<void> savePendingValues() async {
      await _collection.saveMarketValues({...pendingValues});
      pendingValues.clear();
    }

    try {
      for (final record in records) {
        if (record.marketValue case final value? when now.difference(value.valuedAt) < freshValue) {
          recordsValued++;
        } else if (await _releaseIdOf(record) case final releaseId?) {
          pendingValues[record.id] = await _records.lowestPriceOf(releaseId);
          recordsValued++;
          if (pendingValues.length >= valuesPerSave) {
            await savePendingValues();
          }
        }
        onProgress?.call(++done, total);
      }
      await savePendingValues();
      for (final deck in decks) {
        final pricing = await _updateCardPrices(deck.id);
        if (pricing.failure case final failure? when failure.isRateLimited) {
          throw failure;
        }
        if (pricing.priced > 0) {
          decksPriced++;
        }
        onProgress?.call(++done, total);
      }
    } on SourceUnavailable {
      await savePendingValues();
      return ValueRefresh(recordsValued: recordsValued, decksPriced: decksPriced, isComplete: false);
    }
    return ValueRefresh(recordsValued: recordsValued, decksPriced: decksPriced, isComplete: true);
  }

  Future<String?> _releaseIdOf(CollectionItem record) async {
    for (final copy in await _collection.watchCopies(record.id).first) {
      if (copy.externalEditionId case final editionId? when RegExp(r'^\d+$').hasMatch(editionId)) {
        return editionId;
      }
    }
    final workId = record.externalWorkId ?? '';
    if (workId.startsWith('release:')) {
      return workId.substring('release:'.length);
    }
    if (workId.startsWith('master:')) {
      return _records.mainReleaseOf(workId.substring('master:'.length));
    }
    return null;
  }
}
