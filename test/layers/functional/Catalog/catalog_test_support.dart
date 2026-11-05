import 'package:akashic/layers/functional/Catalog/data/gateways/drift_category_gateway.dart';
import 'package:akashic/layers/functional/Catalog/domain/use_cases/create_category.dart';
import 'package:akashic/layers/technical/LocalDatabase/akashic_database.dart';

class CatalogHarness {
  CatalogHarness() : database = AkashicDatabase.forTesting() {
    gateway = DriftCategoryGateway(database);
    var sequence = 0;
    createCategory = CreateCategory(gateway, newId: () => 'category-${sequence++}');
  }

  final AkashicDatabase database;
  late final DriftCategoryGateway gateway;
  late final CreateCategory createCategory;

  Future<void> addItemTo(String categoryId, String itemId) {
    return database.into(database.items).insert(ItemsCompanion.insert(id: itemId, categoryId: categoryId));
  }
}
