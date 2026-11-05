import 'package:akashic/layers/functional/Catalog/data/gateways/drift_category_gateway.dart';
import 'package:akashic/layers/functional/Catalog/domain/entities/category.dart';
import 'package:akashic/layers/functional/Catalog/domain/entities/category_type.dart';
import 'package:akashic/layers/functional/Catalog/domain/use_cases/create_category.dart';
import 'package:akashic/layers/functional/Collection/data/gateways/drift_collection_gateway.dart';
import 'package:akashic/layers/functional/Settings/data/gateways/drift_settings_gateway.dart';
import 'package:akashic/layers/technical/LocalDatabase/akashic_database.dart';

class CollectionHarness {
  CollectionHarness() : database = AkashicDatabase.forTesting() {
    categories = DriftCategoryGateway(database);
    collection = DriftCollectionGateway(database);
    settings = DriftSettingsGateway(database);
    createCategory = CreateCategory(categories, newId: () => 'category-${_categorySequence++}');
  }

  final AkashicDatabase database;
  late final DriftCategoryGateway categories;
  late final DriftCollectionGateway collection;
  late final DriftSettingsGateway settings;
  late final CreateCategory createCategory;
  int _categorySequence = 0;
  int _idSequence = 0;

  String newId() => 'id-${_idSequence++}';

  Future<Category> mangas() => createCategory(name: 'Mangas', colorValue: 0xFFFF7A8A, type: CategoryType.manga, conditionParts: const ['Objet']);

  Future<Category> vinyls() => createCategory(name: 'Vinyles', colorValue: 0xFF7FA8FF, type: CategoryType.music, conditionParts: const ['Disque', 'Pochette']);
}
