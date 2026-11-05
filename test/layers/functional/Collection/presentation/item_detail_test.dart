import 'package:akashic/layers/functional/Catalog/domain/entities/category.dart';
import 'package:akashic/layers/functional/Catalog/domain/entities/category_type.dart';
import 'package:akashic/layers/functional/Catalog/domain/use_cases/watch_category_tree.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/collection_item.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/item_condition.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/item_copy.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/localized_titles.dart';
import 'package:akashic/layers/functional/Collection/domain/use_cases/add_copy.dart';
import 'package:akashic/layers/functional/Collection/domain/use_cases/rate_item.dart';
import 'package:akashic/layers/functional/Collection/domain/use_cases/watch_item_detail.dart';
import 'package:akashic/layers/functional/Collection/presentation/cubit/item_detail_cubit.dart';
import 'package:akashic/layers/functional/Collection/presentation/cubit/item_detail_state.dart';
import 'package:akashic/layers/functional/Collection/presentation/views/item_detail_view.dart';
import 'package:akashic/layers/functional/Settings/domain/entities/preferred_languages.dart';
import 'package:akashic/layers/functional/Settings/domain/use_cases/manage_preferred_languages.dart';
import 'package:akashic/layers/technical/Localization/app_localizations.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../collection_harness.dart';

class MockItemDetailCubit extends MockCubit<ItemDetailState> implements ItemDetailCubit {}

const hobbit = CollectionItem(
  id: 'hobbit',
  categoryId: 'books',
  titles: LocalizedTitles(byLanguage: {'en': 'The Hobbit', 'fr': 'Le Hobbit'}, originalLanguage: 'en'),
  creator: 'J. R. R. Tolkien',
);

const books = Category(id: 'books', name: 'Livres', colorValue: 0xFF6FD6B0, type: CategoryType.books, conditionParts: ['Objet'], position: 0);

Widget hostDetail(ItemDetailCubit cubit) => MaterialApp(
      locale: const Locale('en'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: BlocProvider<ItemDetailCubit>.value(value: cubit, child: ItemDetailView(onEditCopy: (copy, parts) {})),
    );

void main() {
  testWidgets('title variants follow preferred language order then original', (tester) async {
    final cubit = MockItemDetailCubit();
    when(() => cubit.canManagePhotos).thenReturn(false);
    when(() => cubit.state).thenReturn(const ItemDetailState(
      item: hobbit,
      category: books,
      copies: [ItemCopy(id: 'copy', itemId: 'hobbit')],
      preferredLanguages: PreferredLanguages(['fr', 'en']),
      isLoading: false,
    ));
    await tester.pumpWidget(hostDetail(cubit));
    final frTop = tester.getTopLeft(find.text('Le Hobbit').last).dy;
    final enTop = tester.getTopLeft(find.text('The Hobbit')).dy;
    expect(frTop, lessThan(enTop));
    expect(find.text('FR'), findsOneWidget);
  });

  testWidgets('the item shows one purchase block, never a list of copies', (tester) async {
    final cubit = MockItemDetailCubit();
    when(() => cubit.canManagePhotos).thenReturn(false);
    when(() => cubit.state).thenReturn(const ItemDetailState(
      item: hobbit,
      category: books,
      copies: [
        ItemCopy(id: 'a', itemId: 'hobbit', edition: 'Poche', pricePaidCents: 850, conditions: {'Objet': ItemCondition.good}),
        ItemCopy(id: 'b', itemId: 'hobbit', edition: 'Collector'),
      ],
      preferredLanguages: PreferredLanguages(['fr', 'en']),
      isLoading: false,
    ));
    await tester.pumpWidget(hostDetail(cubit));
    expect(find.text('Purchase, condition and storage'), findsOneWidget);
    expect(find.text('€8.50'), findsOneWidget);
    expect(find.text('Collector'), findsNothing);
    expect(find.text('Add a copy'), findsNothing);
  });

  test('rating a star saves the rating', () async {
    final harness = CollectionHarness();
    final bookCategory = await harness.createCategory(name: 'Livres', colorValue: 0, type: CategoryType.books, conditionParts: const ['Objet']);
    await harness.collection.saveItem(CollectionItem(id: 'hobbit', categoryId: bookCategory.id, titles: hobbit.titles));
    final cubit = ItemDetailCubit(
      itemId: 'hobbit',
      watchItemDetail: WatchItemDetail(harness.collection),
      watchCategoryTree: WatchCategoryTree(harness.categories),
      preferredLanguages: ManagePreferredLanguages(harness.settings),
      rateItem: RateItem(harness.collection),
      addCopy: AddCopy(harness.collection),
    )..start();
    await expectLater(cubit.stream, emitsThrough(predicate<ItemDetailState>((state) => state.item != null)));
    await cubit.rate(4);
    expect((await harness.collection.watchItem('hobbit').first)?.rating, 4);
    await cubit.close();
    await harness.database.close();
  });
}
