import 'package:akashic/layers/functional/Catalog/domain/entities/category.dart';
import 'package:akashic/layers/functional/Catalog/domain/entities/category_type.dart';
import 'package:akashic/layers/functional/Collection/presentation/cubit/category_shelves_cubit.dart';
import 'package:akashic/layers/functional/Collection/presentation/cubit/category_shelves_state.dart';
import 'package:akashic/layers/functional/Collection/presentation/views/category_shelves_view.dart';
import 'package:akashic/layers/technical/Localization/app_localizations.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockCategoryShelvesCubit extends MockCubit<CategoryShelvesState> implements CategoryShelvesCubit {}

void main() {
  testWidgets('an empty category invites to add the first item', (tester) async {
    const films = Category(id: 'films', name: 'Films', colorValue: 0xFFF2C46B, type: CategoryType.films, conditionParts: ['Objet'], position: 0);
    final cubit = MockCategoryShelvesCubit();
    when(() => cubit.state).thenReturn(const CategoryShelvesState(
      category: films,
      shelves: [CategoryShelf(category: films, groups: [], itemCount: 0)],
      collapsedSeriesIds: {},
      isLoading: false,
    ));
    var addRequested = false;
    await tester.pumpWidget(MaterialApp(
      locale: const Locale('en'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: BlocProvider<CategoryShelvesCubit>.value(
        value: cubit,
        child: CategoryShelvesView(onAddItem: (_) => addRequested = true, onOpenItem: (_) {}),
      ),
    ));
    expect(find.text('Nothing on this shelf yet.'), findsOneWidget);
    await tester.tap(find.text('Add your first item'));
    expect(addRequested, isTrue);
  });

  testWidgets('a manga category switches between its physical shelves and its scans', (tester) async {
    const mangas = Category(id: 'mangas', name: 'Mangas', colorValue: 0xFFFF7A8A, type: CategoryType.manga, conditionParts: ['Objet'], position: 0);
    final cubit = MockCategoryShelvesCubit();
    when(() => cubit.state).thenReturn(const CategoryShelvesState(
      category: mangas,
      shelves: [CategoryShelf(category: mangas, groups: [], itemCount: 0)],
      collapsedSeriesIds: {},
      isLoading: false,
      showsScans: true,
    ));
    await tester.pumpWidget(MaterialApp(
      locale: const Locale('fr'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: BlocProvider<CategoryShelvesCubit>.value(
        value: cubit,
        child: CategoryShelvesView(onAddItem: (_) {}, onOpenItem: (_) {}, scansViewBuilder: (categoryId) => Text('scans of $categoryId')),
      ),
    ));
    expect(find.text('scans of mangas'), findsOneWidget);
    expect(find.byType(FloatingActionButton), findsNothing);
    await tester.tap(find.text('Physique'));
    verify(() => cubit.showScans(false)).called(1);
  });

  testWidgets('adding from a parent category on all subcategories asks which one, never picks the first', (tester) async {
    const tcg = Category(id: 'tcg', name: 'TCG', colorValue: 0, type: CategoryType.cards, conditionParts: ['Objet'], position: 0);
    const pokemon = Category(id: 'pokemon', parentId: 'tcg', name: 'Pokémon', colorValue: 0xFFF2C46B, type: CategoryType.cards, conditionParts: ['Objet'], position: 0);
    const lorcana = Category(id: 'lorcana', parentId: 'tcg', name: 'Lorcana', colorValue: 0xFF7FA8FF, type: CategoryType.cards, conditionParts: ['Objet'], position: 1);
    final cubit = MockCategoryShelvesCubit();
    when(() => cubit.state).thenReturn(const CategoryShelvesState(
      category: tcg,
      shelves: [CategoryShelf(category: pokemon, groups: [], itemCount: 0), CategoryShelf(category: lorcana, groups: [], itemCount: 0)],
      collapsedSeriesIds: {},
      isLoading: false,
    ));
    final added = <String>[];
    await tester.pumpWidget(MaterialApp(
      locale: const Locale('fr'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: BlocProvider<CategoryShelvesCubit>.value(value: cubit, child: CategoryShelvesView(onAddItem: added.add, onOpenItem: (_) {})),
    ));
    await tester.tap(find.byType(FloatingActionButton));
    await tester.pumpAndSettle();
    expect(find.text('Ajouter dans quelle sous-catégorie ?'), findsOneWidget);
    await tester.tap(find.widgetWithText(ListTile, 'Lorcana'));
    await tester.pumpAndSettle();
    expect(added, ['lorcana']);
  });
}
