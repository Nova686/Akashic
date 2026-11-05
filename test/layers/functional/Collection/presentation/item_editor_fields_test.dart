import 'package:akashic/layers/functional/Catalog/domain/entities/category_type.dart';
import 'package:akashic/layers/functional/Collection/presentation/cubit/item_editor_cubit.dart';
import 'package:akashic/layers/functional/Collection/presentation/cubit/item_editor_state.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/localized_titles.dart';
import 'package:akashic/layers/functional/Collection/presentation/views/item_editor_view.dart';
import 'package:akashic/layers/functional/Lookup/domain/entities/source_match.dart';
import 'package:akashic/layers/technical/Localization/app_localizations.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockItemEditorCubit extends MockCubit<ItemEditorState> implements ItemEditorCubit {}

Future<void> pumpEditor(WidgetTester tester, CategoryType type) async {
  final cubit = MockItemEditorCubit();
  when(() => cubit.state).thenReturn(ItemEditorState(categoryId: 'category', categoryType: type, titleLanguages: const ['fr', 'en']));
  await tester.pumpWidget(MaterialApp(
    locale: const Locale('fr'),
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    home: BlocProvider<ItemEditorCubit>.value(value: cubit, child: const ItemEditorView(categoryName: 'Test')),
  ));
}

void main() {
  testWidgets('a vinyl editor shows no series section and labels the creator as artist', (tester) async {
    await pumpEditor(tester, CategoryType.music);
    await tester.scrollUntilVisible(find.text('Artiste'), 200, scrollable: find.byType(Scrollable).first);
    expect(find.text('Artiste'), findsOneWidget);
    expect(find.text('Label'), findsOneWidget);
    expect(find.text('Ajouter à Test'), findsOneWidget);
    expect(find.text('Fait partie d’une série'), findsNothing);
  });

  testWidgets('a manga editor shows the series section and an author', (tester) async {
    await pumpEditor(tester, CategoryType.manga);
    await tester.scrollUntilVisible(find.text('Auteur'), 200, scrollable: find.byType(Scrollable).first);
    expect(find.text('Auteur'), findsOneWidget);
    await tester.scrollUntilVisible(find.text('Fait partie d’une série'), 300, scrollable: find.byType(Scrollable).first);
    expect(find.text('Fait partie d’une série'), findsOneWidget);
  });

  testWidgets('a video game editor asks for the platform', (tester) async {
    await pumpEditor(tester, CategoryType.videoGames);
    await tester.scrollUntilVisible(find.text('Plateforme (console)'), 200, scrollable: find.byType(Scrollable).first);
    expect(find.text('Studio'), findsOneWidget);
    expect(find.text('Plateforme (console)'), findsOneWidget);
    expect(find.text('Éditeur'), findsNothing);
  });

  testWidgets('adding goes from search to check: a result or « Saisir à la main » leads to the fields, the arrow goes back', (tester) async {
    const frieren = SourceMatch(sourceKey: 'anilist', externalWorkId: '1', titles: LocalizedTitles(byLanguage: {'fr': 'Frieren'}), volumeNumber: 3, year: 2021, suggestedType: CategoryType.manga);
    registerFallbackValue(frieren);
    final cubit = MockItemEditorCubit();
    when(() => cubit.state).thenReturn(const ItemEditorState(categoryId: 'mangas', categoryType: CategoryType.manga, titleLanguages: ['fr'], canSearchOnline: true, searchResults: [frieren]));
    when(() => cubit.applyMatch(any())).thenAnswer((_) async {});
    await tester.pumpWidget(MaterialApp(
      locale: const Locale('fr'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: BlocProvider<ItemEditorCubit>.value(value: cubit, child: const ItemEditorView(categoryName: 'Mangas')),
    ));
    expect(find.text('Chercher'), findsOneWidget);
    expect(find.text('2021 · Tome 3'), findsOneWidget);
    expect(find.text('Ajouter à Mangas'), findsNothing);
    await tester.tap(find.text('Frieren'));
    await tester.pumpAndSettle();
    verify(() => cubit.applyMatch(frieren)).called(1);
    expect(find.text('Ajouter à Mangas'), findsOneWidget);
    await tester.tap(find.byTooltip('Chercher'));
    await tester.pumpAndSettle();
    expect(find.text('Saisir à la main'), findsOneWidget);
    await tester.tap(find.text('Saisir à la main'));
    await tester.pumpAndSettle();
    expect(find.text('Ajouter à Mangas'), findsOneWidget);
  });
}
