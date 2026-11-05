import 'package:akashic/layers/functional/Activity/data/gateways/drift_activity_log.dart';
import 'package:akashic/layers/functional/Activity/domain/entities/activity_event.dart';
import 'package:akashic/layers/functional/Activity/domain/use_cases/build_journal.dart';
import 'package:akashic/layers/functional/Activity/presentation/views/journal_view.dart';
import 'package:akashic/layers/functional/Catalog/domain/entities/category.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/collection_item.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/item_copy.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/item_progress.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/localized_titles.dart';
import 'package:akashic/layers/functional/Collection/domain/use_cases/arrange_shelf.dart';
import 'package:akashic/layers/functional/Loans/data/gateways/drift_loan_gateway.dart';
import 'package:akashic/layers/functional/Loans/domain/use_cases/lending.dart';
import 'package:akashic/layers/functional/Organisation/data/gateways/drift_organisation_gateways.dart';
import 'package:akashic/layers/functional/Organisation/data/gateways/shelf_filter_codec.dart';
import 'package:akashic/layers/functional/Organisation/domain/entities/smart_shelf.dart';
import 'package:akashic/layers/functional/Organisation/domain/entities/storage_place.dart';
import 'package:akashic/layers/functional/Organisation/presentation/cubit/smart_shelves_cubit.dart';
import 'package:akashic/layers/functional/Organisation/presentation/cubit/storage_plan_cubit.dart';
import 'package:akashic/layers/functional/Organisation/presentation/widgets/item_tags_editor.dart';
import 'package:akashic/layers/functional/Stats/data/gateways/drift_value_history_store.dart';
import 'package:akashic/layers/functional/Trades/data/gateways/drift_trade_gateway.dart';
import 'package:akashic/layers/technical/Localization/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../Collection/collection_harness.dart';

Widget localized(Widget child) => MaterialApp(
      locale: const Locale('fr'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(body: child),
    );

void main() {
  late CollectionHarness harness;
  late DriftTagGateway tags;
  late Category mangas;

  CollectionItem item(String id, String title) => CollectionItem(id: id, categoryId: mangas.id, titles: LocalizedTitles(byLanguage: {'fr': title}));

  setUp(() async {
    harness = CollectionHarness();
    tags = DriftTagGateway(harness.database);
    mangas = await harness.mangas();
  });
  tearDown(() => harness.database.close());

  test('a saved filter keeps every criterion, the tag included', () {
    const filter = ShelfFilter(progressStatus: ProgressStatus.finished, minimumRating: 4, sealing: SealingFilter.sealed, onlyLent: true, location: 'Salon', tag: 'dédicacé');
    expect(decodeShelfFilter(encodeShelfFilter(filter)), filter);
    expect(decodeShelfFilter(encodeShelfFilter(const ShelfFilter())), const ShelfFilter());
  });

  test('a smart shelf fills itself with the tagged items of its category', () async {
    await harness.collection.saveItem(item('b1', 'Blacksad'));
    await harness.collection.saveItem(item('f1', 'Frieren'));
    await tags.setTags('b1', {'dédicacé', 'à revendre'});
    await tags.setTags('f1', {'cadeau'});
    expect((await tags.tagsByItem())['b1'], {'dédicacé', 'à revendre'});
    final shelves = DriftSmartShelfGateway(harness.database);
    await shelves.save(SmartShelf(id: 's', name: 'Dédicacés', categoryId: mangas.id, filter: const ShelfFilter(tag: 'dédicacé')));
    final cubit = SmartShelvesCubit(shelves, harness.collection, harness.categories, tags)..start();
    final filled = await cubit.stream.firstWhere((state) => state.isNotEmpty);
    expect(filled.single.items.map((shelfItem) => shelfItem.id), ['b1']);
    await cubit.close();
  });

  test('the storage plan builds paths and finds where an item lives', () async {
    final places = DriftStoragePlanGateway(harness.database);
    final ids = ['salon', 'biblio', 'etagere'];
    final cubit = StoragePlanCubit(places, harness.collection, newId: () => ids.removeAt(0));
    await harness.collection.saveItem(item('b1', 'Blacksad'));
    await harness.collection.saveItem(item('f1', 'Frieren'));
    await harness.collection.saveCopy(const ItemCopy(id: 'c1', itemId: 'b1', location: 'Salon › Bibliothèque › Étagère 3'));
    await harness.collection.saveCopy(const ItemCopy(id: 'c2', itemId: 'f1'));
    await DriftLoanGateway(harness.database).lend('c2', borrower: 'Tom', since: DateTime(2026, 11));
    await cubit.start();
    await cubit.addPlace('Salon');
    await cubit.stream.firstWhere((state) => state.places.length == 1);
    await cubit.addPlace('Bibliothèque', parentId: 'salon');
    await cubit.stream.firstWhere((state) => state.places.length == 2);
    await cubit.addPlace('Étagère 3', parentId: 'biblio');
    final state = await cubit.stream.firstWhere((state) => state.places.length == 3);
    expect(state.plan.pathOf('etagere'), 'Salon › Bibliothèque › Étagère 3');
    expect(state.countUnder('Salon'), 1);
    expect(isStoredUnder('Salon › Bibliothèque', 'Salon'), isTrue);
    expect(isStoredUnder('Salonnière', 'Salon'), isFalse);
    cubit.search('blacksad');
    expect(cubit.state.answers.single.location, 'Salon › Bibliothèque › Étagère 3');
    cubit.search('frieren');
    expect(cubit.state.answers.single.borrower, 'Tom');
    await cubit.remove(state.places.firstWhere((place) => place.id == 'salon'));
    expect(await places.watchAll().first, isEmpty);
    await cubit.close();
  });

  test('the journal gathers additions, loans and returns, newest first', () async {
    final log = DriftActivityLog(harness.database);
    await harness.collection.saveItem(item('b1', 'Blacksad'));
    await harness.collection.saveCopy(const ItemCopy(id: 'c1', itemId: 'b1'));
    final loans = DriftLoanGateway(harness.database);
    var clock = DateTime.now().add(const Duration(minutes: 1));
    await LendCopy(loans, activityLog: log, now: () => clock)('c1', 'Tom');
    clock = clock.add(const Duration(minutes: 5));
    await ReturnCopy(loans, activityLog: log, now: () => clock)('c1');
    final journal = await BuildJournal(harness.collection, log, DriftTradeGateway(harness.database), DriftValueHistoryStore(harness.database))();
    expect(journal.map((event) => (event.kind, event.title, event.detail)), [
      (ActivityKind.returned, 'Blacksad', 'Tom'),
      (ActivityKind.lent, 'Blacksad', 'Tom'),
      (ActivityKind.added, 'Blacksad', null),
    ]);
  });

  testWidgets('the journal filters by kind', (tester) async {
    final now = DateTime.now();
    await tester.pumpWidget(localized(JournalView(
      loadJournal: () async => [
        ActivityEvent(kind: ActivityKind.sold, title: 'Wingspan', at: now, amountCents: 3500),
        ActivityEvent(kind: ActivityKind.added, title: 'Frieren', at: now),
      ],
      onOpenItem: (_) {},
    )));
    await tester.pumpAndSettle();
    expect(find.text('AUJOURD\'HUI'), findsOneWidget);
    expect(find.text('Wingspan'), findsOneWidget);
    await tester.tap(find.text('Ventes'));
    await tester.pumpAndSettle();
    expect(find.text('Frieren'), findsNothing);
    expect(find.textContaining('Vendu'), findsOneWidget);
  });

  testWidgets('a suggested tag lands on the item in one tap', (tester) async {
    await tester.runAsync(() => harness.collection.saveItem(item('b1', 'Blacksad')));
    await tester.pumpWidget(localized(SingleChildScrollView(child: ItemTagsEditor(itemId: 'b1', tags: tags))));
    await tester.runAsync(() => Future<void>.delayed(const Duration(milliseconds: 50)));
    await tester.pump();
    await tester.tap(find.text('dédicacé'));
    await tester.runAsync(() => Future<void>.delayed(const Duration(milliseconds: 50)));
    await tester.pump();
    expect(await tester.runAsync(() => tags.watchTagsOf('b1').first), {'dédicacé'});
    expect(find.byTooltip('Retirer l\'étiquette dédicacé'), findsOneWidget);
  });
}
