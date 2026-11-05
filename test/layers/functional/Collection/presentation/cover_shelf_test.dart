import 'package:akashic/layers/functional/Catalog/domain/entities/category.dart';
import 'package:akashic/layers/functional/Catalog/domain/entities/category_type.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/collection_item.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/localized_titles.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/shelf_group.dart';
import 'package:akashic/layers/functional/Collection/domain/use_cases/arrange_shelf.dart';
import 'package:akashic/layers/functional/Collection/presentation/cubit/category_shelves_cubit.dart';
import 'package:akashic/layers/functional/Collection/presentation/cubit/category_shelves_state.dart';
import 'package:akashic/layers/functional/Collection/presentation/views/category_shelves_view.dart';
import 'package:akashic/layers/functional/Collection/presentation/widgets/cover_shelf.dart';
import 'package:akashic/layers/functional/Collection/presentation/widgets/item_spine.dart';
import 'package:akashic/layers/functional/Collection/presentation/widgets/shelf_plank.dart';
import 'package:akashic/layers/technical/Localization/app_localizations.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockCategoryShelvesCubit extends MockCubit<CategoryShelvesState> implements CategoryShelvesCubit {}

const mangas = Category(id: 'mangas', name: 'Mangas', colorValue: 0xFFFF7A8A, type: CategoryType.manga, conditionParts: ['Objet'], position: 0);

CollectionItem volume(String seriesId, int number) =>
    CollectionItem(id: '$seriesId-$number', categoryId: 'mangas', seriesId: seriesId, volumeNumber: number, titles: LocalizedTitles(byLanguage: {'fr': seriesId == 'frieren' ? 'Frieren' : 'One Piece'}));

final frierenGroup = ShelfGroup(
  id: 'frieren',
  label: 'Frieren',
  isSeries: true,
  ownedCount: 2,
  entries: [
    const ShelfDivider(label: 'Frieren', groupId: 'frieren'),
    ShelfItem(volume('frieren', 1)),
    const ShelfMissingVolume(seriesId: 'frieren', volumeNumber: 2),
    ShelfItem(volume('frieren', 3)),
  ],
);

final onePieceGroup = ShelfGroup(
  id: 'one-piece',
  label: 'One Piece',
  isSeries: true,
  ownedCount: 1,
  entries: [
    const ShelfDivider(label: 'One Piece', groupId: 'one-piece'),
    ShelfItem(volume('one-piece', 1)),
    for (var number = 2; number <= 10; number++) ShelfMissingVolume(seriesId: 'one-piece', volumeNumber: number),
  ],
);

Future<MockCategoryShelvesCubit> pumpCategory(WidgetTester tester, {ShelfSort sort = ShelfSort.bySeries, Set<String> collapsed = const {}, void Function(CollectionItem item)? onOpenItem, void Function(String seriesId)? onOpenSeries}) async {
  tester.view.physicalSize = const Size(1080, 2400);
  tester.view.devicePixelRatio = 2.5;
  addTearDown(tester.view.reset);
  final cubit = MockCategoryShelvesCubit();
  when(() => cubit.state).thenReturn(CategoryShelvesState(
    category: mangas,
    shelves: [CategoryShelf(category: mangas, groups: [frierenGroup, onePieceGroup], itemCount: 3)],
    collapsedSeriesIds: collapsed,
    isLoading: false,
    sort: sort,
  ));
  when(() => cubit.toggleSeries(any())).thenAnswer((_) async {});
  await tester.pumpWidget(MaterialApp(
    locale: const Locale('fr'),
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    home: BlocProvider<CategoryShelvesCubit>.value(
      value: cubit,
      child: CategoryShelvesView(onAddItem: (_) {}, onOpenItem: onOpenItem ?? (_) {}, onOpenSeries: onOpenSeries),
    ),
  ));
  return cubit;
}

void main() {
  testWidgets('a category shows its items face out with large tap targets, never on the spine', (tester) async {
    CollectionItem? opened;
    await pumpCategory(tester, onOpenItem: (item) => opened = item);
    expect(find.byType(ItemSpine), findsNothing);
    expect(find.text('T. 2'), findsOneWidget);
    expect(find.text('9 manquants'), findsOneWidget);
    expect(find.text('3'), findsOneWidget);
    final tile = find.ancestor(of: find.text('3'), matching: find.byType(InkWell)).first;
    expect(tester.getSize(tile).width, CoverShelf.coverWidth);
    expect(tester.getSize(tile).height, greaterThan(100));
    await tester.tap(tile);
    expect(opened?.id, 'frieren-3');
  });

  testWidgets('the series header folds the series and its button opens the series page', (tester) async {
    String? openedSeries;
    final cubit = await pumpCategory(tester, collapsed: {'one-piece'}, onOpenSeries: (seriesId) => openedSeries = seriesId);
    expect(find.text('9 manquants'), findsNothing);
    await tester.tap(find.text('Frieren').first);
    verify(() => cubit.toggleSeries('frieren')).called(1);
    await tester.tap(find.byTooltip('Voir la série').first);
    expect(openedSeries, 'frieren');
  });

  testWidgets('each group is one shelf, and see all lays the whole group on shelves of several covers', (tester) async {
    CollectionItem? opened;
    await pumpCategory(tester, onOpenItem: (item) => opened = item);
    expect(find.byType(ShelfPlank), findsNWidgets(2));
    final cover = find.ancestor(of: find.text('3'), matching: find.byType(InkWell)).first;
    expect(tester.getRect(cover).bottom, closeTo(tester.getRect(find.byType(ShelfPlank).first).top, 1));
    await tester.tap(find.byTooltip('Voir tout').last);
    await tester.pumpAndSettle();
    expect(find.text('One Piece'), findsWidgets);
    final covers = find.descendant(of: find.byType(Scaffold).last, matching: find.byType(InkWell));
    expect(tester.getSize(covers.first).width, inInclusiveRange(CoverShelf.minimumCoverWidth, 110));
    expect(CoverShelf.columnsFor(360), 4);
    await tester.tap(find.descendant(of: find.byType(Scaffold).last, matching: find.text('1')).first);
    expect(opened?.id, 'one-piece-1');
  });

  testWidgets('a sort puts each value on its own shelf instead of one flat grid', (tester) async {
    await pumpCategory(tester, sort: ShelfSort.title);
    expect(find.text('F'), findsOneWidget);
    expect(find.text('O'), findsOneWidget);
    expect(find.byType(ShelfPlank), findsNWidgets(2));
    expect(find.byTooltip('Voir tout'), findsNWidgets(2));
  });

  testWidgets('a group header gives the title all the room and keeps the count and the arrow on the right', (tester) async {
    await pumpCategory(tester);
    final screenWidth = tester.view.physicalSize.width / tester.view.devicePixelRatio;
    final arrow = tester.getRect(find.byTooltip('Voir tout').first);
    final count = tester.getRect(find.text('2 objets').first);
    final title = tester.getRect(find.text('Frieren').first);
    expect(arrow.right, greaterThan(screenWidth - 40));
    expect(count.right, lessThanOrEqualTo(arrow.left));
    expect(count.left, greaterThan(screenWidth / 2));
    expect(title.left, lessThan(60));
  });
}
