import 'package:akashic/layers/functional/Catalog/domain/entities/category.dart';
import 'package:akashic/layers/functional/Catalog/domain/gateways/category_gateway.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/card_kind.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/collection_item.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/deck_card.dart';
import 'package:akashic/layers/functional/Collection/domain/gateways/collection_gateway.dart';
import 'package:akashic/layers/functional/Collection/domain/gateways/deck_gateway.dart';
import 'package:akashic/layers/functional/Collection/domain/use_cases/update_card_prices.dart';
import 'package:akashic/layers/functional/Collection/domain/use_cases/work_identity.dart';
import 'package:akashic/layers/functional/Stats/domain/entities/collection_stats.dart';
import 'package:akashic/layers/functional/Stats/domain/entities/collection_value.dart';
import 'package:akashic/layers/functional/Stats/domain/gateways/stats_gateway.dart';

class ComputeCollectionValue {
  ComputeCollectionValue(this._collection, this._decks, this._stats, this._categories);

  static const String purchaseCurrency = 'EUR';

  final CollectionGateway _collection;
  final DeckGateway _decks;
  final StatsGateway _stats;
  final CategoryGateway _categories;

  Future<(List<CollectionItem>, List<CopyFact>)> _snapshot() async => (await _collection.allItems(), (await _stats.watchFacts().first).$1);

  Future<CollectionValue> call() async => _valueOf(await _snapshot());

  Future<Duplicates> duplicates({required String Function(CollectionItem item) titleOf}) async => _duplicatesOf(await _snapshot(), titleOf);

  Future<(CollectionValue, Duplicates)> valueAndDuplicates({required String Function(CollectionItem item) titleOf}) async {
    final snapshot = await _snapshot();
    return (await _valueOf(snapshot), _duplicatesOf(snapshot, titleOf));
  }

  Future<CollectionValue> _valueOf((List<CollectionItem>, List<CopyFact>) snapshot) async {
    final (items, copies) = snapshot;
    final tree = await _categories.watchTree().first;
    final topLevelOf = <String, Category>{
      for (final node in tree) ...{node.category.id: node.category, for (final child in node.children) child.id: node.category},
    };
    final copiesByItem = <String, List<CopyFact>>{};
    for (final copy in copies) {
      copiesByItem.putIfAbsent(copy.itemId, () => []).add(copy);
    }
    final cardsByDeck = <String, List<DeckCard>>{};
    for (final card in await _decks.watchAllCards().first) {
      cardsByDeck.putIfAbsent(card.itemId, () => []).add(card);
    }
    final total = <String, int>{};
    final byCategory = <String, Map<String, int>>{};
    var marketValued = 0;
    var purchaseValued = 0;
    var unvalued = 0;
    DateTime? lastValuedAt;
    void add(String categoryId, String currency, int cents) {
      total[currency] = (total[currency] ?? 0) + cents;
      final topLevel = topLevelOf[categoryId]?.id ?? categoryId;
      final values = byCategory.putIfAbsent(topLevel, () => {});
      values[currency] = (values[currency] ?? 0) + cents;
    }

    for (final item in items) {
      final itemCopies = copiesByItem[item.id] ?? const <CopyFact>[];
      final deckValue = item.cardKind == CardKind.deck ? deckValueByCurrency(cardsByDeck[item.id] ?? const []) : const <String, int>{};
      if (deckValue.isNotEmpty) {
        deckValue.forEach((currency, cents) => add(item.categoryId, currency, cents));
        marketValued++;
        continue;
      }
      if (item.marketValue case final value?) {
        add(item.categoryId, value.currency, value.cents * (itemCopies.isEmpty ? 1 : itemCopies.length));
        marketValued++;
        if (lastValuedAt == null || value.valuedAt.isAfter(lastValuedAt)) {
          lastValuedAt = value.valuedAt;
        }
        continue;
      }
      final paid = itemCopies.fold(0, (sum, copy) => sum + (copy.pricePaidCents ?? 0));
      if (paid > 0) {
        add(item.categoryId, purchaseCurrency, paid);
        purchaseValued++;
      } else {
        unvalued++;
      }
    }
    return CollectionValue(
      totalByCurrency: total,
      categories: [for (final node in tree) CategoryValue(category: node.category, byCurrency: byCategory[node.category.id] ?? const {})],
      marketValuedItems: marketValued,
      purchaseValuedItems: purchaseValued,
      unvaluedItems: unvalued,
      lastValuedAt: lastValuedAt,
    );
  }

  Duplicates _duplicatesOf((List<CollectionItem>, List<CopyFact>) snapshot, String Function(CollectionItem item) titleOf) {
    final (items, _) = snapshot;
    final byWork = <String, List<CollectionItem>>{};
    for (final item in items) {
      final key = item.sourceKey != null && item.externalWorkId != null && item.volumeNumber == null
          ? '${item.sourceKey}|${item.externalWorkId}'
          : '${workIdentityOf(titleOf(item), item.creator)}|${item.volumeNumber ?? ''}|${item.cardKind?.name ?? ''}';
      byWork.putIfAbsent(key, () => []).add(item);
    }
    return Duplicates(
      sameWork: [
        for (final group in byWork.values)
          if (group.length > 1) group,
      ],
    );
  }
}
