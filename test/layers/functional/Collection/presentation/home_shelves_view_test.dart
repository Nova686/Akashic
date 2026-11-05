import 'package:akashic/layers/functional/Catalog/domain/entities/category.dart';
import 'package:akashic/layers/functional/Catalog/domain/entities/category_type.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/collection_item.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/localized_titles.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/shelf_group.dart';
import 'package:akashic/layers/functional/Collection/presentation/cubit/home_shelves_cubit.dart';
import 'package:akashic/layers/functional/Collection/presentation/cubit/home_shelves_state.dart';
import 'package:akashic/layers/functional/Collection/presentation/views/home_shelves_view.dart';
import 'package:akashic/layers/functional/Collection/presentation/widgets/empty_shelf_line.dart';
import 'package:akashic/layers/functional/Collection/presentation/widgets/item_spine.dart';
import 'package:akashic/layers/functional/Collection/presentation/widgets/shelf_divider_view.dart';
import 'package:akashic/layers/functional/Collection/presentation/widgets/shelf_gap_view.dart';
import 'package:akashic/layers/functional/Collection/presentation/widgets/shelf_row.dart';
import 'package:akashic/layers/functional/Collection/presentation/widgets/shelf_plank.dart';
import 'package:akashic/layers/technical/Localization/app_localizations.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockHomeShelvesCubit extends MockCubit<HomeShelvesState> implements HomeShelvesCubit {}

const vinyls = Category(id: 'vinyls', name: 'Vinyles', colorValue: 0xFF7FA8FF, type: CategoryType.music, conditionParts: ['Disque'], position: 0);

void main() {
  testWidgets('touching anywhere on a category shelf opens the category, never an item', (tester) async {
    final cubit = MockHomeShelvesCubit();
    when(() => cubit.state).thenReturn(const HomeShelvesState(
      isLoading: false,
      shelves: [
        HomeShelf(
          node: CategoryNode(category: vinyls, children: [], itemCount: 1),
          groups: [
            ShelfGroup(
              id: 'kob',
              label: '',
              isSeries: false,
              ownedCount: 1,
              entries: [ShelfItem(CollectionItem(id: 'kob', categoryId: 'vinyls', titles: LocalizedTitles(byLanguage: {'en': 'Kind of Blue'})))],
            ),
          ],
        ),
      ],
    ));
    final openedCategories = <String>[];
    final openedItems = <String>[];
    await tester.pumpWidget(MaterialApp(
      locale: const Locale('fr'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: BlocProvider<HomeShelvesCubit>.value(
        value: cubit,
        child: HomeShelvesView(
          onOpenCategory: openedCategories.add,
          onCreateCategory: () {},
          onOpenSettings: () {},
          onOpenItem: (item) => openedItems.add(item.id),
        ),
      ),
    ));
    await tester.tap(find.byType(ItemSpine));
    await tester.tap(find.byType(ShelfPlank), warnIfMissed: false);
    await tester.tap(find.text('Vinyles'));
    expect(openedCategories, ['vinyls', 'vinyls', 'vinyls']);
    expect(openedItems, isEmpty);
  });

  testWidgets('an empty category takes a single line on its plank instead of a whole empty shelf', (tester) async {
    final cubit = MockHomeShelvesCubit();
    when(() => cubit.state).thenReturn(const HomeShelvesState(
      isLoading: false,
      shelves: [HomeShelf(node: CategoryNode(category: vinyls, children: [], itemCount: 0), groups: [])],
    ));
    await tester.pumpWidget(MaterialApp(
      locale: const Locale('fr'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: BlocProvider<HomeShelvesCubit>.value(
        value: cubit,
        child: HomeShelvesView(onOpenCategory: (_) {}, onCreateCategory: () {}, onOpenSettings: () {}, onOpenItem: (_) {}),
      ),
    ));
    expect(find.byType(ShelfRow), findsNothing);
    expect(tester.getSize(find.byType(EmptyShelfLine)).height, lessThan(60));
  });

  testWidgets('on the collection page groups are parted by small blank dividers, never by labelled ones', (tester) async {
    CollectionItem record(String id, String title) => CollectionItem(id: id, categoryId: 'vinyls', titles: LocalizedTitles(byLanguage: {'en': title}));
    final cubit = MockHomeShelvesCubit();
    when(() => cubit.state).thenReturn(HomeShelvesState(
      isLoading: false,
      shelves: [
        HomeShelf(
          node: const CategoryNode(category: vinyls, children: [], itemCount: 3),
          groups: [
            ShelfGroup(id: 'group:dgd', label: 'Dance Gavin Dance', isSeries: false, ownedCount: 2, entries: [
              const ShelfDivider(label: 'Dance Gavin Dance', groupId: 'group:dgd'),
              ShelfItem(record('afterburner', 'Afterburner')),
              ShelfItem(record('jackpot', 'Jackpot Juicer')),
            ]),
            ShelfGroup(id: 'group:nirvana', label: 'Nirvana', isSeries: false, ownedCount: 1, entries: [
              const ShelfDivider(label: 'Nirvana', groupId: 'group:nirvana'),
              ShelfItem(record('nevermind', 'Nevermind')),
            ]),
          ],
        ),
      ],
    ));
    await tester.pumpWidget(MaterialApp(
      locale: const Locale('fr'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: BlocProvider<HomeShelvesCubit>.value(
        value: cubit,
        child: HomeShelvesView(onOpenCategory: (_) {}, onCreateCategory: () {}, onOpenSettings: () {}, onOpenItem: (_) {}),
      ),
    ));
    expect(find.byType(ShelfDividerView), findsNothing);
    expect(find.byType(ShelfGapView), findsOneWidget);
    expect(find.text('DANCE GAVIN DANCE'), findsNothing);
    expect(find.byType(ItemSpine), findsNWidgets(3));
  });
}
