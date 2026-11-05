import 'package:akashic/layers/functional/Catalog/domain/entities/category.dart';

abstract interface class CategoryGateway {
  Future<void> save(Category category);
  Future<Category?> findById(String categoryId);
  Future<int> countChildrenOf(String? parentId);
  Future<int> countItemsIn(String categoryId);
  Future<int> countSeriesIn(String categoryId);
  Stream<List<CategoryNode>> watchTree();
  Future<void> delete(String categoryId);
}
