import 'package:akashic/layers/functional/Catalog/domain/entities/category.dart';
import 'package:akashic/layers/functional/Catalog/domain/gateways/category_gateway.dart';
import 'package:akashic/layers/functional/Catalog/domain/use_cases/root_categories.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/collection_item.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/item_copy.dart';
import 'package:akashic/layers/functional/Collection/domain/gateways/collection_gateway.dart';
import 'package:equatable/equatable.dart';

class InventoryLine extends Equatable {
  const InventoryLine({required this.item, required this.category, this.copy});

  final CollectionItem item;
  final Category category;
  final ItemCopy? copy;

  int? get paidCents => copy?.pricePaidCents;

  int? get estimatedCents => item.marketValue?.currency == 'EUR' ? item.marketValue!.cents : paidCents;

  String? get location => copy?.location?.trim().isEmpty ?? true ? null : copy!.location!.trim();

  @override
  List<Object?> get props => [item.id, category.id, copy];
}

class InventoryCategory extends Equatable {
  const InventoryCategory({required this.category, required this.lines});

  final Category category;
  final List<InventoryLine> lines;

  int get estimatedCents => lines.fold(0, (total, line) => total + (line.estimatedCents ?? 0));

  @override
  List<Object?> get props => [category, lines];
}

class LoadInsuranceInventory {
  LoadInsuranceInventory(this._collection, this._categories);

  final CollectionGateway _collection;
  final CategoryGateway _categories;

  Future<List<InventoryCategory>> call() async {
    final tree = await _categories.watchTree().first;
    final roots = rootCategoryById(tree);
    final copies = await _collection.firstCopiesByItem();
    final byCategory = <String, List<InventoryLine>>{};
    for (final item in await _collection.allItems()) {
      final root = roots[item.categoryId];
      if (root == null) {
        continue;
      }
      byCategory.putIfAbsent(root.id, () => []).add(InventoryLine(item: item, category: root, copy: copies[item.id]));
    }
    return [
      for (final node in tree)
        if (byCategory[node.category.id] case final lines? when lines.isNotEmpty) InventoryCategory(category: node.category, lines: lines),
    ];
  }
}
