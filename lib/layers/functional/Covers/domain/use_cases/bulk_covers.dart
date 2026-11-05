import 'package:akashic/layers/functional/Catalog/domain/entities/category.dart';
import 'package:akashic/layers/functional/Catalog/domain/gateways/category_gateway.dart';
import 'package:akashic/layers/functional/Catalog/domain/use_cases/root_categories.dart';
import 'package:akashic/layers/functional/Check/domain/gateways/cover_image_gateway.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/collection_item.dart';
import 'package:akashic/layers/functional/Collection/domain/gateways/collection_gateway.dart';
import 'package:akashic/layers/functional/Collection/domain/use_cases/resolve_display_title.dart';
import 'package:akashic/layers/functional/Lookup/domain/gateways/image_search.dart';
import 'package:akashic/layers/functional/Settings/domain/entities/preferred_languages.dart';
import 'package:equatable/equatable.dart';

class CoverlessGroup extends Equatable {
  const CoverlessGroup({required this.category, required this.items});

  final Category category;
  final List<CollectionItem> items;

  @override
  List<Object?> get props => [category, items];
}

class FindCoverlessItems {
  FindCoverlessItems(this._collection, this._categories);

  final CollectionGateway _collection;
  final CategoryGateway _categories;

  Future<List<CoverlessGroup>> call() async {
    final tree = await _categories.watchTree().first;
    final roots = rootCategoryById(tree);
    final byRoot = <String, List<CollectionItem>>{};
    for (final item in await _collection.allItems()) {
      final root = roots[item.categoryId];
      if (item.imagePath == null && item.cardKind == null && root != null) {
        byRoot.putIfAbsent(root.id, () => []).add(item);
      }
    }
    return [
      for (final node in tree)
        if (byRoot[node.category.id] case final items? when items.isNotEmpty) CoverlessGroup(category: node.category, items: items),
    ];
  }
}

String coverQueryOf(CollectionItem item) {
  final title = resolveDisplayTitle(item.titles, PreferredLanguages.defaults) ?? '';
  return [title, if (item.volumeNumber case final volume?) '$volume', ?item.creator].join(' ').trim();
}

class ProposeCovers {
  ProposeCovers(this._search);

  final ImageSearch _search;

  Future<List<String>> call(CollectionItem item) async {
    final query = coverQueryOf(item);
    if (query.isEmpty) {
      return const [];
    }
    return _search.imagesFor(null, query);
  }
}

class AcceptCover {
  AcceptCover(this._covers, this._collection);

  final CoverImageGateway _covers;
  final CollectionGateway _collection;

  Future<bool> call(String itemId, String url) async {
    final stored = await _covers.storeCover(url);
    if (stored == null) {
      return false;
    }
    await _collection.saveCover(itemId, imagePath: stored.path, spineColorValue: stored.spineColorValue);
    return true;
  }
}
