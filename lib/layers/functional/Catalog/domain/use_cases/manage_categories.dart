import 'package:akashic/layers/functional/Collection/domain/use_cases/delete_unshared_images.dart';
import 'package:akashic/layers/functional/Catalog/domain/entities/category.dart';
import 'package:akashic/layers/functional/Catalog/domain/entities/category_type.dart';
import 'package:uuid/uuid.dart';
import 'package:akashic/layers/functional/Catalog/domain/gateways/category_gateway.dart';
import 'package:akashic/layers/functional/Collection/domain/gateways/collection_gateway.dart';
import 'package:equatable/equatable.dart';

class CategoryContents extends Equatable {
  const CategoryContents({required this.itemCount, required this.seriesCount, required this.subcategoryCount});

  final int itemCount;
  final int seriesCount;
  final int subcategoryCount;

  bool get isEmpty => itemCount == 0 && seriesCount == 0 && subcategoryCount == 0;

  @override
  List<Object?> get props => [itemCount, seriesCount, subcategoryCount];
}

class ManageCategories {
  const ManageCategories(this._categories, this._collection, {this._deleteImage});

  final CategoryGateway _categories;
  final CollectionGateway _collection;
  final Future<void> Function(String path)? _deleteImage;

  Future<void> rename(Category category, {required String name, required int colorValue}) => update(category, name: name, colorValue: colorValue);

  Future<void> update(Category category, {required String name, required int colorValue, CategoryType? type, List<String>? conditionParts}) {
    return _categories.save(Category(
      id: category.id,
      parentId: category.parentId,
      name: name.trim().isEmpty ? category.name : name.trim(),
      colorValue: colorValue,
      type: type ?? category.type,
      conditionParts: conditionParts ?? category.conditionParts,
      position: category.position,
    ));
  }

  Future<List<Category>> subcategoriesOf(Category category) => _childrenOf(category.id);

  Future<void> addSubcategory(Category parent, String name) async {
    if (name.trim().isEmpty || parent.isSubcategory) {
      return;
    }
    await _categories.save(Category(
      id: const Uuid().v4(),
      parentId: parent.id,
      name: name.trim(),
      colorValue: parent.colorValue,
      type: parent.type,
      conditionParts: parent.conditionParts,
      position: await _categories.countChildrenOf(parent.id),
    ));
  }

  Future<List<Category>> siblingsOf(Category category) async {
    final tree = await _categories.watchTree().first;
    if (category.parentId == null) {
      return [for (final node in tree) node.category];
    }
    return tree.where((node) => node.category.id == category.parentId).firstOrNull?.children ?? const [];
  }

  Future<List<Category>> _childrenOf(String categoryId) async =>
      (await _categories.watchTree().first).where((node) => node.category.id == categoryId).firstOrNull?.children ?? const [];

  Future<void> reorder(List<Category> ordered) async {
    for (final (position, category) in ordered.indexed) {
      if (category.position != position) {
        await _categories.save(Category(
          id: category.id,
          parentId: category.parentId,
          name: category.name,
          colorValue: category.colorValue,
          type: category.type,
          conditionParts: category.conditionParts,
          position: position,
        ));
      }
    }
  }

  Future<CategoryContents> contentsOf(Category category) async => CategoryContents(
        itemCount: (await _collection.watchItemsInCategoryTree(category.id).first).length,
        seriesCount: (await _collection.watchSeriesInCategoryTree(category.id).first).length,
        subcategoryCount: await _categories.countChildrenOf(category.id),
      );

  Future<void> delete(Category category) async {
    final deleteImage = _deleteImage;
    final paths = <String>[];
    for (final item in await _collection.watchItemsInCategoryTree(category.id).first) {
      final photos = await _collection.watchPhotos(item.id).first;
      await _collection.deleteItem(item.id);
      paths.addAll([?item.imagePath, for (final photo in photos) photo.path]);
    }
    if (deleteImage != null) {
      await deleteUnsharedImages(_collection, deleteImage, paths);
    }
    for (final series in await _collection.watchSeriesInCategoryTree(category.id).first) {
      await _collection.deleteSeries(series.id);
    }
    for (final child in await _childrenOf(category.id)) {
      await _categories.delete(child.id);
    }
    await _categories.delete(category.id);
  }
}
