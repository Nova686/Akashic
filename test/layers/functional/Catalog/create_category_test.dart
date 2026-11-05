import 'package:akashic/layers/functional/Catalog/domain/entities/category_type.dart';
import 'package:akashic/layers/functional/Catalog/domain/use_cases/create_category.dart';
import 'package:flutter_test/flutter_test.dart';

import 'catalog_test_support.dart';

void main() {
  late CatalogHarness harness;

  setUp(() => harness = CatalogHarness());
  tearDown(() => harness.database.close());

  test('subcategory inherits type and parts from parent', () async {
    final vinyls = await harness.createCategory(
      name: 'Vinyles',
      colorValue: 0xFF7FA8FF,
      type: CategoryType.music,
      conditionParts: const ['Disque', 'Pochette'],
    );
    final jazz = await harness.createCategory(name: 'Jazz', colorValue: 0xFF7FA8FF, type: CategoryType.free, parentId: vinyls.id);
    expect(jazz.type, CategoryType.music);
    expect(jazz.conditionParts, ['Disque', 'Pochette']);
  });

  test('creating a grandchild throws CategoryDepthExceeded', () async {
    final tcg = await harness.createCategory(name: 'TCG', colorValue: 0xFF5FD3E8, type: CategoryType.cards, conditionParts: const ['Objet']);
    final pokemon = await harness.createCategory(name: 'Pokémon', colorValue: 0xFF5FD3E8, type: CategoryType.cards, parentId: tcg.id);
    expect(
      () => harness.createCategory(name: 'Écarlate', colorValue: 0xFF5FD3E8, type: CategoryType.cards, parentId: pokemon.id),
      throwsA(isA<CategoryDepthExceeded>()),
    );
  });

  test('music categories default to disc and sleeve parts', () {
    expect(CategoryType.music.defaultConditionParts, [ConditionPartKind.disc, ConditionPartKind.sleeve]);
    expect(CategoryType.videoGames.defaultConditionParts, [ConditionPartKind.game, ConditionPartKind.box, ConditionPartKind.manual]);
    expect(CategoryType.manga.defaultConditionParts, [ConditionPartKind.item]);
  });
}
