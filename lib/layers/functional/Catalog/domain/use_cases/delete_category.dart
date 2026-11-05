import 'package:akashic/layers/functional/Catalog/domain/gateways/category_gateway.dart';

class CategoryNotEmpty implements Exception {
  const CategoryNotEmpty({required this.itemCount, required this.subcategoryCount, required this.seriesCount});

  final int itemCount;
  final int subcategoryCount;
  final int seriesCount;
}

class DeleteCategory {
  const DeleteCategory(this._gateway);

  final CategoryGateway _gateway;

  Future<void> call(String categoryId) async {
    final itemCount = await _gateway.countItemsIn(categoryId);
    final subcategoryCount = await _gateway.countChildrenOf(categoryId);
    final seriesCount = await _gateway.countSeriesIn(categoryId);
    if (itemCount > 0 || subcategoryCount > 0 || seriesCount > 0) {
      throw CategoryNotEmpty(itemCount: itemCount, subcategoryCount: subcategoryCount, seriesCount: seriesCount);
    }
    await _gateway.delete(categoryId);
  }
}
