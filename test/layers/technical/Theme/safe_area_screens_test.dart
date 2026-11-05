import 'package:akashic/layers/functional/Collection/presentation/widgets/learn_more_tab.dart';
import 'package:akashic/layers/functional/Catalog/domain/entities/category.dart';
import 'package:akashic/layers/functional/Catalog/domain/entities/category_type.dart';
import 'package:akashic/layers/functional/Catalog/presentation/cubit/category_editor_cubit.dart';
import 'package:akashic/layers/functional/Catalog/presentation/cubit/category_editor_state.dart';
import 'package:akashic/layers/functional/Catalog/presentation/views/category_editor_view.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/collection_item.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/item_copy.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/localized_titles.dart';
import 'package:akashic/layers/functional/Collection/presentation/cubit/category_shelves_cubit.dart';
import 'package:akashic/layers/functional/Collection/presentation/cubit/category_shelves_state.dart';
import 'package:akashic/layers/functional/Collection/presentation/cubit/item_detail_cubit.dart';
import 'package:akashic/layers/functional/Collection/presentation/cubit/item_detail_state.dart';
import 'package:akashic/layers/functional/Collection/presentation/cubit/item_editor_cubit.dart';
import 'package:akashic/layers/functional/Collection/presentation/cubit/item_editor_state.dart';
import 'package:akashic/layers/functional/Collection/presentation/views/category_shelves_view.dart';
import 'package:akashic/layers/functional/Collection/presentation/views/item_detail_view.dart';
import 'package:akashic/layers/functional/Collection/presentation/views/item_editor_view.dart';
import 'package:akashic/layers/functional/Settings/presentation/cubit/settings_cubit.dart';
import 'package:akashic/layers/functional/Settings/presentation/cubit/settings_state.dart';
import 'package:akashic/layers/functional/Settings/presentation/views/settings_view.dart';
import 'package:akashic/layers/technical/Localization/app_localizations.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockCategoryEditorCubit extends MockCubit<CategoryEditorState> implements CategoryEditorCubit {}

class MockCategoryShelvesCubit extends MockCubit<CategoryShelvesState> implements CategoryShelvesCubit {}

class MockItemDetailCubit extends MockCubit<ItemDetailState> implements ItemDetailCubit {}

class MockItemEditorCubit extends MockCubit<ItemEditorState> implements ItemEditorCubit {}

class MockSettingsCubit extends MockCubit<SettingsState> implements SettingsCubit {}

const gestureBar = 48.0;

const films = Category(id: 'films', name: 'Films', colorValue: 0xFFF2C46B, type: CategoryType.films, conditionParts: ['Objet'], position: 0);

Future<void> expectListClearsGestureBar(WidgetTester tester, Widget screen) async {
  await tester.pumpWidget(MaterialApp(
    locale: const Locale('fr'),
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    home: MediaQuery(
      data: const MediaQueryData(size: Size(400, 800), padding: EdgeInsets.only(top: 40, bottom: gestureBar), viewPadding: EdgeInsets.only(top: 40, bottom: gestureBar)),
      child: screen,
    ),
  ));
  final bottomPadding = find.byType(ListView).evaluate().isNotEmpty
      ? tester.widget<ListView>(find.byType(ListView).first).padding!.resolve(TextDirection.ltr).bottom
      : tester.widget<SliverPadding>(find.descendant(of: find.byType(CustomScrollView).first, matching: find.byType(SliverPadding)).last).padding.resolve(TextDirection.ltr).bottom;
  expect(bottomPadding, greaterThanOrEqualTo(gestureBar + 16), reason: '${screen.runtimeType} list ends under the gesture bar');
}

void main() {
  testWidgets('screens keep their content above the gesture bar', (tester) async {
    final categoryEditor = MockCategoryEditorCubit();
    when(() => categoryEditor.state).thenReturn(CategoryEditorState.initial());
    await expectListClearsGestureBar(tester, BlocProvider<CategoryEditorCubit>.value(value: categoryEditor, child: const CategoryEditorView()));

    final shelves = MockCategoryShelvesCubit();
    when(() => shelves.state).thenReturn(const CategoryShelvesState(category: films, shelves: [CategoryShelf(category: films, groups: [], itemCount: 0)], collapsedSeriesIds: {}, isLoading: false));
    await expectListClearsGestureBar(tester, BlocProvider<CategoryShelvesCubit>.value(value: shelves, child: CategoryShelvesView(onAddItem: (_) {}, onOpenItem: (_) {})));

    final detail = MockItemDetailCubit();

    when(() => detail.canManagePhotos).thenReturn(false);
    when(() => detail.state).thenReturn(const ItemDetailState(
      item: CollectionItem(id: 'matrix', categoryId: 'films', titles: LocalizedTitles(byLanguage: {'fr': 'Matrix'})),
      category: films,
      isLoading: false,
    ));
    await expectListClearsGestureBar(tester, BlocProvider<ItemDetailCubit>.value(value: detail, child: ItemDetailView(onEditCopy: (copy, parts) {})));

    final editor = MockItemEditorCubit();
    when(() => editor.state).thenReturn(const ItemEditorState(categoryId: 'films', titleLanguages: ['fr', 'en']));
    await expectListClearsGestureBar(tester, BlocProvider<ItemEditorCubit>.value(value: editor, child: const ItemEditorView(categoryName: 'Films')));

    final settings = MockSettingsCubit();
    when(() => settings.state).thenReturn(const SettingsState.initial());
    await expectListClearsGestureBar(tester, BlocProvider<SettingsCubit>.value(value: settings, child: const SettingsView()));
  });

  testWidgets('a record page scrolls as one, its last copy ending above the gesture bar', (tester) async {
    tester.view.physicalSize = const Size(1600, 1800);
    tester.view.devicePixelRatio = 2;
    tester.view.padding = const FakeViewPadding(top: 80, bottom: gestureBar * 2);
    tester.view.viewPadding = const FakeViewPadding(top: 80, bottom: gestureBar * 2);
    addTearDown(tester.view.reset);
    const vinyls = Category(id: 'vinyls', name: 'Vinyles', colorValue: 0xFF7FA8FF, type: CategoryType.music, conditionParts: ['Disque'], position: 0);
    final detail = MockItemDetailCubit();
    when(() => detail.canManagePhotos).thenReturn(false);
    when(() => detail.state).thenReturn(ItemDetailState(
      item: const CollectionItem(id: 'kob', categoryId: 'vinyls', titles: LocalizedTitles(byLanguage: {'en': 'Kind of Blue'})),
      category: vinyls,
      copies: [for (var number = 1; number <= 8; number++) ItemCopy(id: 'copy-$number', itemId: 'kob', edition: 'Pressage $number')],
      isLoading: false,
    ));
    await tester.pumpWidget(MaterialApp(
      locale: const Locale('fr'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: BlocProvider<ItemDetailCubit>.value(value: detail, child: ItemDetailView(onEditCopy: (copy, parts) {})),
    ));
    expect(find.byType(Scrollable), findsOneWidget);
    await tester.scrollUntilVisible(find.text('Pressage 1'), 300, scrollable: find.byType(Scrollable));
    await tester.drag(find.byType(Scrollable), const Offset(0, -2000));
    await tester.pumpAndSettle();
    final screenHeight = tester.view.physicalSize.height / tester.view.devicePixelRatio;
    final lastCopy = find.ancestor(of: find.text('Pressage 1'), matching: find.byType(Material)).first;
    expect(tester.getRect(lastCopy).bottom, lessThanOrEqualTo(screenHeight - gestureBar));
  });

  testWidgets('a details list on its own page ends above the gesture bar', (tester) async {
    await tester.pumpWidget(MaterialApp(
      locale: const Locale('fr'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: MediaQuery(
        data: const MediaQueryData(size: Size(400, 800), padding: EdgeInsets.only(top: 40, bottom: gestureBar), viewPadding: EdgeInsets.only(top: 40, bottom: gestureBar)),
        child: Scaffold(body: LearnMoreTab(details: null, isFetching: false, canFetch: true, onRefresh: () {})),
      ),
    ));
    final list = tester.widget<ListView>(find.byType(ListView));
    expect(list.padding!.resolve(TextDirection.ltr).bottom, greaterThanOrEqualTo(gestureBar + 16));
  });
}
