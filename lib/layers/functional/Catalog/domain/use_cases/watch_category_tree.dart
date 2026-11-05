import 'package:akashic/layers/functional/Catalog/domain/entities/category.dart';
import 'package:akashic/layers/functional/Catalog/domain/gateways/category_gateway.dart';

class WatchCategoryTree {
  const WatchCategoryTree(this._gateway);

  final CategoryGateway _gateway;

  Stream<List<CategoryNode>> call() => _gateway.watchTree();
}
