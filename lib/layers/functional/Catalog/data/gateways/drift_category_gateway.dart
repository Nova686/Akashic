import 'dart:convert';

import 'package:akashic/layers/functional/Catalog/domain/entities/category.dart';
import 'package:akashic/layers/functional/Catalog/domain/entities/category_type.dart';
import 'package:akashic/layers/functional/Catalog/domain/gateways/category_gateway.dart';
import 'package:akashic/layers/technical/LocalDatabase/akashic_database.dart';
import 'package:drift/drift.dart';

class DriftCategoryGateway implements CategoryGateway {
  DriftCategoryGateway(this._database);

  final AkashicDatabase _database;

  @override
  Future<void> save(Category category) {
    return _database.into(_database.categories).insertOnConflictUpdate(CategoriesCompanion.insert(
          id: category.id,
          parentId: Value(category.parentId),
          name: category.name,
          colorValue: category.colorValue,
          type: category.type.name,
          conditionParts: jsonEncode(category.conditionParts),
          position: category.position,
        ));
  }

  @override
  Future<Category?> findById(String categoryId) async {
    final row = await (_database.select(_database.categories)..where((table) => table.id.equals(categoryId))).getSingleOrNull();
    return row == null ? null : _toCategory(row);
  }

  @override
  Future<int> countChildrenOf(String? parentId) async {
    final count = _database.categories.id.count();
    final query = _database.selectOnly(_database.categories)
      ..addColumns([count])
      ..where(parentId == null ? _database.categories.parentId.isNull() : _database.categories.parentId.equals(parentId));
    return (await query.getSingle()).read(count) ?? 0;
  }

  @override
  Future<int> countItemsIn(String categoryId) async {
    final count = _database.items.id.count();
    final query = _database.selectOnly(_database.items)
      ..addColumns([count])
      ..where(_database.items.categoryId.equals(categoryId));
    return (await query.getSingle()).read(count) ?? 0;
  }

  @override
  Future<int> countSeriesIn(String categoryId) async {
    final count = _database.seriesTable.id.count();
    final query = _database.selectOnly(_database.seriesTable)
      ..addColumns([count])
      ..where(_database.seriesTable.categoryId.equals(categoryId));
    return (await query.getSingle()).read(count) ?? 0;
  }

  @override
  Stream<List<CategoryNode>> watchTree() {
    final itemCounts = _database.customSelect(
      'SELECT category_id, COUNT(*) AS item_count FROM items GROUP BY category_id',
      readsFrom: {_database.items, _database.categories},
    );
    return itemCounts.watch().asyncMap((countRows) async {
      final countByCategory = {for (final row in countRows) row.read<String>('category_id'): row.read<int>('item_count')};
      final rows = await (_database.select(_database.categories)..orderBy([(table) => OrderingTerm.asc(table.position)])).get();
      final categories = rows.map(_toCategory).toList();
      return [
        for (final parent in categories.where((category) => !category.isSubcategory))
          _buildNode(parent, categories, countByCategory),
      ];
    });
  }

  CategoryNode _buildNode(Category parent, List<Category> categories, Map<String, int> countByCategory) {
    final children = categories.where((category) => category.parentId == parent.id).toList();
    final itemCount = (countByCategory[parent.id] ?? 0) +
        children.fold<int>(0, (total, child) => total + (countByCategory[child.id] ?? 0));
    return CategoryNode(category: parent, children: children, itemCount: itemCount);
  }

  @override
  Future<void> delete(String categoryId) {
    return (_database.delete(_database.categories)..where((table) => table.id.equals(categoryId))).go();
  }

  Category _toCategory(CategoryRow row) => Category(
        id: row.id,
        parentId: row.parentId,
        name: row.name,
        colorValue: row.colorValue,
        type: CategoryType.values.byName(row.type),
        conditionParts: List<String>.from(jsonDecode(row.conditionParts) as List),
        position: row.position,
      );
}
