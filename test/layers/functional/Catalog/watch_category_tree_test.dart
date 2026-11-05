import 'package:akashic/layers/functional/Catalog/domain/entities/category_type.dart';
import 'package:akashic/layers/functional/Catalog/domain/use_cases/watch_category_tree.dart';
import 'package:flutter_test/flutter_test.dart';

import 'catalog_test_support.dart';

void main() {
  late CatalogHarness harness;

  setUp(() => harness = CatalogHarness());
  tearDown(() => harness.database.close());

  test('watchTree returns parents ordered by position with their children and item counts', () async {
    final vinyls = await harness.createCategory(name: 'Vinyles', colorValue: 0xFF7FA8FF, type: CategoryType.music, conditionParts: const ['Disque']);
    final mangas = await harness.createCategory(name: 'Mangas', colorValue: 0xFFFF7A8A, type: CategoryType.manga, conditionParts: const ['Objet']);
    final jazz = await harness.createCategory(name: 'Jazz', colorValue: 0xFF7FA8FF, type: CategoryType.music, parentId: vinyls.id);
    await harness.addItemTo(jazz.id, 'kind-of-blue');
    await harness.addItemTo(jazz.id, 'blue-train');
    await harness.addItemTo(mangas.id, 'frieren-1');

    final tree = await WatchCategoryTree(harness.gateway)().first;

    expect(tree.map((node) => node.category.name), ['Vinyles', 'Mangas']);
    expect(tree.first.children.map((child) => child.name), ['Jazz']);
    expect(tree.first.itemCount, 2);
    expect(tree.last.itemCount, 1);
  });
}
