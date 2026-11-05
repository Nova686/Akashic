import 'package:akashic/layers/functional/Catalog/domain/entities/category.dart';
import 'package:akashic/layers/functional/Catalog/domain/entities/category_type.dart';
import 'package:akashic/layers/functional/Catalog/domain/use_cases/create_category.dart';
import 'package:akashic/layers/functional/Catalog/presentation/cubit/category_editor_cubit.dart';
import 'package:akashic/layers/functional/Catalog/presentation/cubit/category_editor_state.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockCreateCategory extends Mock implements CreateCategory {}

String partLabel(ConditionPartKind kind) => kind.name;

Category categoryNamed(String id, String name, {String? parentId}) => Category(
      id: id,
      parentId: parentId,
      name: name,
      colorValue: 0,
      type: CategoryType.cards,
      conditionParts: const ['item'],
      position: 0,
    );

void main() {
  late MockCreateCategory createCategory;

  setUpAll(() => registerFallbackValue(CategoryType.free));

  setUp(() {
    createCategory = MockCreateCategory();
    when(() => createCategory(
          name: any(named: 'name'),
          colorValue: any(named: 'colorValue'),
          type: any(named: 'type'),
          parentId: any(named: 'parentId'),
          conditionParts: any(named: 'conditionParts'),
        )).thenAnswer((invocation) async {
      final parentId = invocation.namedArguments[#parentId] as String?;
      final name = invocation.namedArguments[#name] as String;
      return categoryNamed(parentId == null ? 'parent' : 'child-$name', name, parentId: parentId);
    });
  });

  blocTest<CategoryEditorCubit, CategoryEditorState>(
    'selecting music resets parts to disc and sleeve',
    build: () => CategoryEditorCubit(createCategory, localizePart: partLabel),
    act: (cubit) {
      cubit.addConditionPart('Coin');
      cubit.selectType(CategoryType.music);
    },
    verify: (cubit) {
      expect(cubit.state.conditionParts, ['disc', 'sleeve']);
    },
  );

  blocTest<CategoryEditorCubit, CategoryEditorState>(
    'submit with empty name emits invalid',
    build: () => CategoryEditorCubit(createCategory, localizePart: partLabel),
    act: (cubit) async {
      cubit.setName('   ');
      await cubit.submit();
    },
    verify: (cubit) {
      expect(cubit.state.status, CategoryEditorStatus.invalid);
      verifyNever(() => createCategory(
            name: any(named: 'name'),
            colorValue: any(named: 'colorValue'),
            type: any(named: 'type'),
          ));
    },
  );

  blocTest<CategoryEditorCubit, CategoryEditorState>(
    'submit creates parent then each subcategory',
    build: () => CategoryEditorCubit(createCategory, localizePart: partLabel),
    act: (cubit) async {
      cubit.setName('TCG');
      cubit.selectType(CategoryType.cards);
      cubit.addSubcategory('Pokémon');
      cubit.addSubcategory('Magic');
      await cubit.submit();
    },
    verify: (cubit) {
      expect(cubit.state.status, CategoryEditorStatus.saved);
      verifyInOrder([
        () => createCategory(
              name: 'TCG',
              colorValue: any(named: 'colorValue'),
              type: CategoryType.cards,
              conditionParts: ['item'],
            ),
        () => createCategory(
              name: 'Pokémon',
              colorValue: any(named: 'colorValue'),
              type: CategoryType.cards,
              parentId: 'parent',
            ),
        () => createCategory(
              name: 'Magic',
              colorValue: any(named: 'colorValue'),
              type: CategoryType.cards,
              parentId: 'parent',
            ),
      ]);
    },
  );
}
