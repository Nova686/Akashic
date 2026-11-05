import 'package:akashic/layers/functional/Catalog/domain/entities/category.dart';
import 'package:akashic/layers/functional/Catalog/domain/entities/category_type.dart';
import 'package:akashic/layers/functional/Catalog/domain/gateways/category_gateway.dart';
import 'package:akashic/layers/functional/Collection/domain/gateways/collection_gateway.dart';
import 'package:akashic/layers/functional/Collection/domain/use_cases/search_text_normalizer.dart';
import 'package:akashic/layers/functional/Lookup/domain/entities/source_match.dart';

class SuggestCategory {
  const SuggestCategory(this._categories, {this._collection});

  final CategoryGateway _categories;
  final CollectionGateway? _collection;

  Future<Category?> forMatch(SourceMatch match) async {
    final leaves = await _leavesOf(match.suggestedType);
    if (leaves.length <= 1) {
      return leaves.firstOrNull;
    }
    final leafById = {for (final leaf in leaves) leaf.id: leaf};
    final collection = _collection;
    final seriesHome = collection == null ? null : await _homeOfOwnedSeries(collection, match, leafById);
    if (seriesHome != null) {
      return seriesHome;
    }
    final namedHome = _leafNamedIn(match, leaves);
    if (namedHome != null) {
      return namedHome;
    }
    final creatorHome = collection == null ? null : await _homeOfCreator(collection, match, leafById);
    return creatorHome ?? await _fullest(leaves);
  }

  Future<List<Category>> _leavesOf(CategoryType type) async => [
        for (final node in await _categories.watchTree().first)
          if (node.category.type == type) ...(node.children.isEmpty ? [node.category] : node.children),
      ];

  Future<Category?> _homeOfOwnedSeries(CollectionGateway collection, SourceMatch match, Map<String, Category> leafById) async {
    final seriesTitles = {
      if (match.seriesTitle case final seriesTitle?) normalizeForSearch(seriesTitle),
      if (match.volumeNumber != null) ...match.titles.byLanguage.values.map(normalizeForSearch),
    };
    for (final series in await collection.watchAllSeries().first) {
      final home = leafById[series.categoryId];
      if (home == null) {
        continue;
      }
      final isSameWork = series.sourceKey == match.sourceKey && series.externalWorkId == match.externalWorkId;
      if (isSameWork || series.titles.byLanguage.values.map(normalizeForSearch).any(seriesTitles.contains)) {
        return home;
      }
    }
    return null;
  }

  Category? _leafNamedIn(SourceMatch match, List<Category> leaves) {
    final describedAs = [match.platform, match.publisher, match.seriesTitle, match.format, ...match.titles.byLanguage.values]
        .nonNulls
        .map((text) => ' ${normalizeForSearch(text)} ')
        .toList();
    for (final leaf in leaves) {
      final name = normalizeForSearch(leaf.name);
      if (name.isNotEmpty && describedAs.any((text) => text.contains(' $name '))) {
        return leaf;
      }
    }
    return null;
  }

  Future<Category?> _homeOfCreator(CollectionGateway collection, SourceMatch match, Map<String, Category> leafById) async {
    final creator = match.creator;
    if (creator == null || creator.trim().isEmpty) {
      return null;
    }
    final wantedCreator = normalizeForSearch(creator);
    final countByLeaf = <String, int>{};
    for (final item in await collection.allItems()) {
      final itemCreator = item.creator;
      if (leafById.containsKey(item.categoryId) && itemCreator != null && normalizeForSearch(itemCreator) == wantedCreator) {
        countByLeaf.update(item.categoryId, (count) => count + 1, ifAbsent: () => 1);
      }
    }
    final favourite = countByLeaf.entries.fold<MapEntry<String, int>?>(null, (best, entry) => best == null || entry.value > best.value ? entry : best);
    return favourite == null ? null : leafById[favourite.key];
  }

  Future<Category> _fullest(List<Category> leaves) async {
    var fullest = leaves.first;
    var fullestCount = await _categories.countItemsIn(fullest.id);
    for (final leaf in leaves.skip(1)) {
      final count = await _categories.countItemsIn(leaf.id);
      if (count > fullestCount) {
        fullest = leaf;
        fullestCount = count;
      }
    }
    return fullest;
  }
}
