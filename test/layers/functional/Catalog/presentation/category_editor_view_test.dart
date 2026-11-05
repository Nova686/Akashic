import 'package:akashic/layers/functional/Catalog/domain/entities/category_type.dart';
import 'package:akashic/layers/functional/Catalog/presentation/cubit/category_editor_cubit.dart';
import 'package:akashic/layers/functional/Catalog/presentation/cubit/category_editor_state.dart';
import 'package:akashic/layers/functional/Catalog/presentation/views/category_editor_view.dart';
import 'package:akashic/layers/functional/Catalog/presentation/widgets/category_type_labels.dart';
import 'package:akashic/layers/technical/Localization/app_localizations.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockCategoryEditorCubit extends MockCubit<CategoryEditorState> implements CategoryEditorCubit {}

void main() {
  setUpAll(() => registerFallbackValue(CategoryType.free));

  testWidgets('the create button submits the category', (tester) async {
    final cubit = MockCategoryEditorCubit();
    when(() => cubit.state).thenReturn(CategoryEditorState.initial());
    when(() => cubit.submit()).thenAnswer((_) async {});

    await tester.pumpWidget(MaterialApp(
      locale: const Locale('en'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: BlocProvider<CategoryEditorCubit>.value(value: cubit, child: const CategoryEditorView()),
    ));

    expect(find.text('Create category'), findsNothing);
    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Create category'));
    verify(() => cubit.submit()).called(1);
  });

  testWidgets('each colour swatch is a named, selectable target of at least 48 dp', (tester) async {
    final semantics = tester.ensureSemantics();
    final cubit = MockCategoryEditorCubit();
    when(() => cubit.state).thenReturn(CategoryEditorState.initial().copyWith(colorValue: CategoryEditorState.categoryPalette[1]));
    when(() => cubit.setColor(any())).thenReturn(null);
    await tester.pumpWidget(MaterialApp(
      locale: const Locale('fr'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: BlocProvider<CategoryEditorCubit>.value(value: cubit, child: const CategoryEditorView()),
    ));
    await tester.tap(find.text('Continuer'));
    await tester.pumpAndSettle();
    final pink = find.bySemanticsLabel('Rose');
    expect(tester.getSemantics(pink), matchesSemantics(label: 'Rose', isButton: true, hasSelectedState: true, isSelected: true, hasTapAction: true));
    expect(tester.getSize(pink).shortestSide, greaterThanOrEqualTo(48));
    await tester.tap(find.bySemanticsLabel('Vert'));
    verify(() => cubit.setColor(CategoryEditorState.categoryPalette[2])).called(1);
    await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
    semantics.dispose();
  });

  testWidgets('choosing a type never asks which API to use', (tester) async {
    final cubit = MockCategoryEditorCubit();
    when(() => cubit.state).thenReturn(CategoryEditorState.initial().copyWith(type: CategoryType.cards, subcategories: const [SubcategoryDraft(name: 'Pokémon')]));
    await tester.pumpWidget(MaterialApp(
      locale: const Locale('fr'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: BlocProvider<CategoryEditorCubit>.value(value: cubit, child: const CategoryEditorView()),
    ));
    await tester.tap(find.text('Continuer'));
    await tester.pumpAndSettle();
    expect(find.text('Pokémon'), findsWidgets);
    for (final apiName in sourceDisplayNames.values) {
      expect(find.text(apiName), findsNothing);
    }
  });

  testWidgets('a trading card category suggests the games it does not have yet, board games are a type', (tester) async {
    final cubit = MockCategoryEditorCubit();
    when(() => cubit.state).thenReturn(CategoryEditorState.initial().copyWith(type: CategoryType.cards, subcategories: const [SubcategoryDraft(name: 'Pokémon')]));
    await tester.pumpWidget(MaterialApp(
      locale: const Locale('fr'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: BlocProvider<CategoryEditorCubit>.value(value: cubit, child: const CategoryEditorView()),
    ));
    expect(find.text('Jeux de société'), findsOneWidget);
    await tester.tap(find.text('Continuer'));
    await tester.pumpAndSettle();
    expect(find.widgetWithText(ActionChip, 'Pokémon'), findsNothing);
    await tester.scrollUntilVisible(find.widgetWithText(ActionChip, 'Yu-Gi-Oh!'), 200, scrollable: find.byType(Scrollable).first);
    await tester.ensureVisible(find.widgetWithText(ActionChip, 'Yu-Gi-Oh!'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(ActionChip, 'Yu-Gi-Oh!'));
    verify(() => cubit.addSubcategory('Yu-Gi-Oh!')).called(1);
  });

  testWidgets('a custom category says it has no online catalogue', (tester) async {
    final cubit = MockCategoryEditorCubit();
    when(() => cubit.state).thenReturn(CategoryEditorState.initial().copyWith(type: CategoryType.free));
    await tester.pumpWidget(MaterialApp(
      locale: const Locale('fr'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: BlocProvider<CategoryEditorCubit>.value(value: cubit, child: const CategoryEditorView()),
    ));
    expect(find.text('Personnalisée'), findsOneWidget);
    await tester.scrollUntilVisible(find.textContaining('sans catalogue en ligne'), 200, scrollable: find.byType(Scrollable).first);
    expect(find.textContaining('sans catalogue en ligne'), findsOneWidget);
  });

  testWidgets('a new category starts with its type, then shows a preview named after it', (tester) async {
    final cubit = MockCategoryEditorCubit();
    when(() => cubit.state).thenReturn(CategoryEditorState.initial().copyWith(type: CategoryType.manga, name: 'Mangas'));
    when(() => cubit.selectType(any())).thenReturn(null);
    when(() => cubit.setName(any())).thenReturn(null);
    await tester.pumpWidget(MaterialApp(
      locale: const Locale('fr'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: BlocProvider<CategoryEditorCubit>.value(value: cubit, child: const CategoryEditorView()),
    ));
    expect(find.text('Que veux-tu ranger ?'), findsOneWidget);
    await tester.ensureVisible(find.text('Jeux vidéo'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Jeux vidéo'));
    verify(() => cubit.selectType(CategoryType.videoGames)).called(1);
    await tester.tap(find.text('Continuer'));
    await tester.pumpAndSettle();
    expect(find.text('Détails de la catégorie'), findsNothing);
    expect(find.text('Mangas'), findsWidgets);
    expect(find.text('Changer'), findsOneWidget);
    await tester.tap(find.text('Changer'));
    await tester.pumpAndSettle();
    expect(find.text('Que veux-tu ranger ?'), findsOneWidget);
  });
}
