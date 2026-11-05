import 'package:akashic/layers/functional/Check/domain/entities/check_verdict.dart';
import 'package:akashic/layers/functional/Check/domain/use_cases/normalize_barcode.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/collection_item.dart';
import 'package:akashic/layers/functional/Collection/domain/gateways/collection_gateway.dart';
import 'package:akashic/layers/functional/Collection/domain/use_cases/collection_search_matcher.dart';
import 'package:akashic/layers/functional/Collection/domain/use_cases/search_text_normalizer.dart';

class FindLocally {
  const FindLocally(this._collection);

  static const CollectionSearchMatcher _matcher = CollectionSearchMatcher();

  final CollectionGateway _collection;

  Future<Owned?> byBarcode(String normalizedBarcode) async {
    for (final form in barcodeStorageForms(normalizedBarcode)) {
      final found = await _collection.findCopiesByBarcode(form);
      if (found.isNotEmpty) {
        final item = found.first.$1;
        return Owned(item, await _collection.watchCopies(item.id).first);
      }
    }
    return null;
  }

  Future<List<CollectionItem>> byText(String text, {List<CollectionItem>? among}) async {
    final query = normalizeForSearch(text);
    final matches = (among ?? await _collection.allItems()).where((item) => _matcher.matches(item, text)).toList();
    bool isExact(CollectionItem item) => item.titles.byLanguage.values.any((title) => normalizeForSearch(title) == query);
    matches.sort((first, second) => (isExact(first) ? 0 : 1).compareTo(isExact(second) ? 0 : 1));
    return matches;
  }

  Future<Owned?> bestTextMatch(String text, {List<CollectionItem>? among}) async {
    final query = normalizeForSearch(text);
    if (query.isEmpty) {
      return null;
    }
    for (final item in await byText(text, among: among)) {
      if (item.titles.byLanguage.values.any((title) => normalizeForSearch(title) == query)) {
        return Owned(item, await _collection.watchCopies(item.id).first);
      }
    }
    return null;
  }
}
