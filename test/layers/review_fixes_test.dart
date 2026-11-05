import 'package:akashic/layers/functional/Catalog/domain/entities/category.dart';
import 'package:akashic/layers/functional/Catalog/domain/entities/category_type.dart';
import 'package:akashic/layers/functional/Catalog/domain/use_cases/create_category.dart';
import 'package:akashic/layers/functional/Catalog/presentation/cubit/category_editor_cubit.dart';
import 'package:akashic/layers/functional/Catalog/presentation/cubit/category_editor_state.dart';
import 'package:akashic/layers/functional/Check/domain/entities/check_verdict.dart';
import 'package:akashic/layers/functional/Check/domain/use_cases/add_from_match.dart';
import 'package:akashic/layers/functional/Check/domain/use_cases/check_ownership.dart';
import 'package:akashic/layers/functional/Check/domain/use_cases/suggest_category.dart';
import 'package:akashic/layers/functional/Check/presentation/cubit/chain_scan_cubit.dart';
import 'package:akashic/layers/functional/Check/presentation/cubit/chain_scan_state.dart';
import 'package:akashic/layers/functional/Check/presentation/views/chain_scan_view.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/collection_item.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/localized_titles.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/owned_work.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/shelf_group.dart';
import 'package:akashic/layers/functional/Collection/presentation/widgets/cover_shelf.dart';
import 'package:akashic/layers/functional/Settings/domain/entities/preferred_languages.dart';
import 'package:akashic/layers/functional/Wishes/data/gateways/drift_wish_gateway.dart';
import 'package:akashic/layers/functional/Wishes/domain/entities/wish.dart';
import 'package:akashic/layers/functional/Wishes/domain/use_cases/remove_fulfilled_wishes.dart';
import 'package:akashic/layers/functional/Wishes/domain/use_cases/watch_fulfilled_wishes.dart';
import 'package:akashic/layers/technical/Localization/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'functional/Collection/collection_harness.dart';

class MockCheckOwnership extends Mock implements CheckOwnership {}

class MockAddFromMatch extends Mock implements AddFromMatch {}

class MockSuggestCategory extends Mock implements SuggestCategory {}

class FlakyRemoval extends RemoveFulfilledWishes {
  FlakyRemoval(super.wishes, this.fulfilled);

  final Wish fulfilled;
  int calls = 0;

  @override
  Future<List<Wish>> call(List<OwnedWork> ownedWorks) async {
    calls++;
    if (calls == 1) {
      throw Exception('database busy');
    }
    return [fulfilled];
  }
}

class FailingSubcategories extends CreateCategory {
  FailingSubcategories(super.gateway);

  @override
  Future<Category> call({required String name, required int colorValue, required CategoryType type, String? parentId, List<String>? conditionParts}) {
    if (parentId != null) {
      throw Exception('disk full');
    }
    return super.call(name: name, colorValue: colorValue, type: type, conditionParts: conditionParts);
  }
}

Widget localized(Widget child) => MaterialApp(
      locale: const Locale('fr'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(body: child),
    );

void main() {
  test('one failed check does not stop fulfilled wishes from being noticed', () async {
    final harness = CollectionHarness();
    final wishes = DriftWishGateway(harness.database);
    final mangas = await harness.mangas();
    final wish = Wish(id: 'w1', draft: const WishDraft(categoryType: CategoryType.manga, title: 'Frieren', origin: WishOrigin.manual), createdAt: DateTime(2026, 11, 4));
    await wishes.save(wish);
    final removal = FlakyRemoval(wishes, wish);
    final noticed = <List<Wish>>[];
    final subscription = WatchFulfilledWishes(harness.collection, wishes, removal)().listen(noticed.add);
    await pumpEventQueue();
    await harness.collection.saveItem(CollectionItem(id: 'f1', categoryId: mangas.id, titles: const LocalizedTitles(byLanguage: {'fr': 'Frieren'})));
    await pumpEventQueue(times: 50);
    expect(removal.calls, greaterThanOrEqualTo(2));
    expect(noticed, [
      [wish],
    ]);
    await subscription.cancel();
    await harness.database.close();
  });

  test('an unexpected error on one scan does not block the next ones', () async {
    registerFallbackValue(const CollectionItem(id: 'x', categoryId: 'x', titles: LocalizedTitles(byLanguage: {})));
    final checkOwnership = MockCheckOwnership();
    when(() => checkOwnership.barcode('0000000000001')).thenThrow(StateError('broken row'));
    when(() => checkOwnership.barcode('0000000000002')).thenAnswer((_) async => const NotOwned(null, '0000000000002'));
    final cubit = ChainScanCubit(checkOwnership, MockAddFromMatch(), MockSuggestCategory())
      ..scan('0000000000001')
      ..scan('0000000000002');
    await cubit.whenIdle();
    expect(cubit.state.entries.map((entry) => entry.status), [ChainEntryStatus.unreadable, ChainEntryStatus.notFound]);
    await cubit.close();
  });

  test('a category whose subcategories cannot be created is rolled back', () async {
    final harness = CollectionHarness();
    final editor = CategoryEditorCubit(FailingSubcategories(harness.categories), localizePart: (kind) => kind.name, deleteCategory: harness.categories.delete)
      ..setName('Vinyles')
      ..addSubcategory('Jazz');
    await editor.submit();
    expect(editor.state.status, CategoryEditorStatus.failed);
    expect(await harness.categories.watchTree().first, isEmpty);
    await editor.close();
    await harness.database.close();
  });

  test('only entries that just settled are announced', () {
    const resolving = ChainEntry(id: 'a', label: 'A', status: ChainEntryStatus.resolving);
    const other = ChainEntry(id: 'b', label: 'B', status: ChainEntryStatus.found);
    final before = const ChainScanState(entries: [resolving, other]);
    final after = ChainScanState(entries: [resolving.copyWith(status: ChainEntryStatus.alreadyOwned), other]);
    expect(settledEntriesBetween(before, after).map((entry) => entry.id), ['a']);
    expect(settledEntriesBetween(after, after), isEmpty);
  });

  testWidgets('a cover on a shelf can be opened and selected with TalkBack', (tester) async {
    final semantics = tester.ensureSemantics();
    final opened = <String>[];
    final selected = <String>[];
    await tester.pumpWidget(localized(SingleChildScrollView(
      child: CoverShelf(
        groups: [
          ShelfGroup(id: 'g', label: 'Jazz', isSeries: false, ownedCount: 1, entries: [ShelfItem(const CollectionItem(id: 'kob', categoryId: 'v', titles: LocalizedTitles(byLanguage: {'en': 'Kind of Blue'})))]),
        ],
        preferredLanguages: PreferredLanguages.defaults,
        categoryColorValue: 0xFF7FA8FF,
        collapsedSeriesIds: const {},
        onOpenItem: (item) => opened.add(item.id),
        onToggleSeries: (_) {},
        onLongPressItem: (item) => selected.add(item.id),
      ),
    )));
    final cover = find.bySemanticsLabel('Kind of Blue');
    expect(tester.getSemantics(cover), matchesSemantics(label: 'Kind of Blue', isButton: true, hasSelectedState: true, hasTapAction: true, customActions: const [CustomSemanticsAction(label: 'Sélectionner')]));
    tester.semantics.tap(find.semantics.byLabel('Kind of Blue'));
    expect(opened, ['kob']);
    semantics.dispose();
  });
}
