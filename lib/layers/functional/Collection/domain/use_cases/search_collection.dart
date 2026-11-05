import 'package:akashic/layers/functional/Check/domain/use_cases/normalize_barcode.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/collection_item.dart';
import 'package:akashic/layers/functional/Collection/domain/gateways/collection_gateway.dart';
import 'package:akashic/layers/functional/Collection/domain/use_cases/collection_search_matcher.dart';
import 'package:akashic/layers/functional/Collection/domain/use_cases/search_text_normalizer.dart';

class SearchCollection {
  const SearchCollection(this._collection);

  final CollectionGateway _collection;
  static const CollectionSearchMatcher _matcher = CollectionSearchMatcher();
  static final RegExp _barcodeLike = RegExp(r'^[\d\s-]{8,}[\dXx]?$');

  Future<List<CollectionItem>> call(String query) async {
    final normalizedQuery = normalizeForSearch(query);
    final words = normalizedQuery.split(' ').where((word) => word.isNotEmpty).toList();
    if (words.isEmpty) {
      return const [];
    }
    final byBarcode = await _itemsWithBarcode(query);
    final copies = await _collection.firstCopiesByItem();
    final scored = <(int, String, CollectionItem)>[];
    for (final item in await _collection.allItems()) {
      final titles = [for (final title in item.titles.byLanguage.values) normalizeForSearch(title)];
      final copy = copies[item.id];
      final haystack = [
        ...titles,
        ?item.creator,
        ?item.publisher,
        ?item.groupKey,
        ?copy?.location,
        ?copy?.edition,
        ?copy?.barcode,
        if (item.volumeNumber case final volume?) '$volume',
      ].map(normalizeForSearch).join(' ');
      if (!words.every(haystack.contains) && !_matcher.matches(item, query)) {
        continue;
      }
      final relevance = titles.any((title) => title == normalizedQuery)
          ? 0
          : titles.any((title) => title.startsWith(normalizedQuery))
              ? 1
              : titles.any((title) => title.contains(normalizedQuery))
                  ? 2
                  : 3;
      scored.add((relevance, titles.firstOrNull ?? '', item));
    }
    scored.sort((first, second) => first.$1 != second.$1 ? first.$1.compareTo(second.$1) : first.$2.compareTo(second.$2));
    final seenIds = {for (final item in byBarcode) item.id};
    return [...byBarcode, for (final (_, _, item) in scored) if (seenIds.add(item.id)) item];
  }

  Future<List<CollectionItem>> _itemsWithBarcode(String query) async {
    final trimmed = query.trim();
    if (!_barcodeLike.hasMatch(trimmed)) {
      return const [];
    }
    final barcode = normalizeBarcode(trimmed);
    if (barcode == null) {
      return const [];
    }
    final seenIds = <String>{};
    return [
      for (final (item, _) in await _collection.findCopiesByBarcode(barcode))
        if (seenIds.add(item.id)) item,
    ];
  }
}
