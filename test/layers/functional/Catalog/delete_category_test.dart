import 'package:akashic/layers/functional/Catalog/domain/entities/category_type.dart';
import 'package:akashic/layers/functional/Catalog/domain/use_cases/delete_category.dart';
import 'package:flutter_test/flutter_test.dart';

import 'catalog_test_support.dart';

void main() {
  late CatalogHarness harness;
  late DeleteCategory deleteCategory;

  setUp(() {
    harness = CatalogHarness();
    deleteCategory = DeleteCategory(harness.gateway);
  });
  tearDown(() => harness.database.close());

  test('deleting a category with items throws CategoryNotEmpty', () async {
    final vinyls = await harness.createCategory(name: 'Vinyles', colorValue: 0xFF7FA8FF, type: CategoryType.music, conditionParts: const ['Disque']);
    await harness.addItemTo(vinyls.id, 'kind-of-blue');
    expect(() => deleteCategory(vinyls.id), throwsA(isA<CategoryNotEmpty>()));
  });

  test('deleting a category with subcategories throws CategoryNotEmpty', () async {
    final vinyls = await harness.createCategory(name: 'Vinyles', colorValue: 0xFF7FA8FF, type: CategoryType.music, conditionParts: const ['Disque']);
    await harness.createCategory(name: 'Jazz', colorValue: 0xFF7FA8FF, type: CategoryType.music, parentId: vinyls.id);
    expect(() => deleteCategory(vinyls.id), throwsA(isA<CategoryNotEmpty>()));
  });

  test('deleting an empty category removes it', () async {
    final films = await harness.createCategory(name: 'Films', colorValue: 0xFFF2C46B, type: CategoryType.films, conditionParts: const ['Objet']);
    await deleteCategory(films.id);
    expect(await harness.gateway.watchTree().first, isEmpty);
  });
}
