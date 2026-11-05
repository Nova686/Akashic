import 'package:akashic/layers/functional/Budget/data/gateways/drift_budget_store.dart';
import 'package:akashic/layers/functional/Budget/domain/entities/budget.dart';
import 'package:akashic/layers/functional/Budget/domain/gateways/budget_store.dart';
import 'package:akashic/layers/functional/Budget/domain/use_cases/budget_use_cases.dart';
import 'package:akashic/layers/functional/Budget/presentation/widgets/budget_gauge.dart';
import 'package:akashic/layers/functional/Catalog/domain/entities/category_type.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/collection_item.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/item_copy.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/localized_titles.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/market_value.dart';
import 'package:akashic/layers/functional/Inventory/domain/use_cases/insurance_inventory.dart';
import 'package:akashic/layers/functional/Wishes/domain/entities/wish.dart';
import 'package:akashic/layers/functional/Wishes/presentation/cubit/wishes_state.dart';
import 'package:akashic/layers/functional/Wishes/presentation/views/wishlist_share_view.dart';
import 'package:akashic/layers/technical/Documents/pdf_table_document.dart';
import 'package:akashic/layers/technical/Localization/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

import '../Collection/collection_harness.dart';

class RecordedBudgetAlerts implements BudgetAlerts {
  final List<int> remaining = [];

  @override
  Future<void> nearCeiling(int remainingCents, int ceilingCents) async => remaining.add(remainingCents);
}

Widget localized(Widget child) => MaterialApp(
      locale: const Locale('fr'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(body: child),
    );

Wish wish(String id, String title, WishPriority priority) => Wish(id: id, draft: WishDraft(categoryType: CategoryType.manga, title: title, origin: WishOrigin.manual), createdAt: DateTime(2026, 11), priority: priority);

void main() {
  late CollectionHarness harness;
  late DriftBudgetStore store;
  late String gamesId;
  late String mangasId;

  setUp(() async {
    harness = CollectionHarness();
    store = DriftBudgetStore(harness.database);
    mangasId = (await harness.mangas()).id;
    gamesId = (await harness.createCategory(name: 'Jeux', colorValue: 0, type: CategoryType.videoGames, conditionParts: const ['Jeu'])).id;
    final now = DateTime.now();
    await harness.collection.saveItem(CollectionItem(id: 'f14', categoryId: mangasId, titles: const LocalizedTitles(byLanguage: {'fr': 'Frieren 14'})));
    await harness.collection.saveCopy(ItemCopy(id: 'c1', itemId: 'f14', pricePaidCents: 720, purchasedOn: now, location: 'Salon › Bibliothèque'));
    await harness.collection.saveItem(CollectionItem(id: 'er', categoryId: gamesId, titles: const LocalizedTitles(byLanguage: {'fr': 'Elden Ring'}), sourceKey: 'steam', externalWorkId: '1'));
    await harness.collection.saveCopy(ItemCopy(id: 'c2', itemId: 'er', pricePaidCents: 3999, purchasedOn: now));
    await harness.collection.saveMarketValue('f14', MarketValue(cents: 900, currency: 'EUR', valuedAt: now));
  });
  tearDown(() => harness.database.close());

  test('the month budget counts priced purchases, Steam optional, and warns once a month', () async {
    final compute = ComputeBudget(harness.collection, store);
    await store.save(const BudgetSettings(ceilingCents: 5000, alertPercent: 80));
    final status = await compute();
    expect((status.spentCents, status.remainingCents, status.isPastAlert, status.isOver), (4719, 281, true, false));
    final withoutSteam = await compute(const BudgetSettings(ceilingCents: 5000, countsSteam: false));
    expect(withoutSteam.spentCents, 720);
    final alerts = RecordedBudgetAlerts();
    final check = CheckBudgetAlert(compute, store, alerts);
    expect(await check(), isTrue);
    expect(await check(), isFalse);
    expect(alerts.remaining, [281]);
  });

  test('the insurance inventory values items by their market value, else what was paid', () async {
    final inventory = await LoadInsuranceInventory(harness.collection, harness.categories)();
    final lines = {for (final category in inventory) for (final line in category.lines) line.item.id: line};
    expect((lines['f14']!.estimatedCents, lines['f14']!.location), (900, 'Salon › Bibliothèque'));
    expect(lines['er']!.estimatedCents, 3999);
  });

  test('the PDF builder writes a document', () async {
    TestWidgetsFlutterBinding.ensureInitialized();
    final regular = (await rootBundle.load('assets/fonts/Lato-Regular.ttf')).buffer.asUint8List();
    final bold = (await rootBundle.load('assets/fonts/Lato-Bold.ttf')).buffer.asUint8List();
    final bytes = await buildTablePdf(PdfTableDocument(
      title: 'Inventaire de collection',
      subtitle: 'Établi le 5 novembre',
      columns: const [PdfColumn('Objet', flex: 5), PdfColumn('Payé', flex: 2, alignsRight: true)],
      sections: const [PdfSection(heading: 'Salon › Bibliothèque', rows: [PdfRow(title: 'Frieren 14', subtitle: 'Mangas', cells: ['7,20 €'])], footer: ['Sous-total (1)', '7,20 €'])],
      regularFont: regular,
      boldFont: bold,
    ));
    expect(String.fromCharCodes(bytes.take(4)), '%PDF');
    expect(bytes, isA<Uint8List>());
  });

  test('wishes are listed by priority', () {
    final state = WishesState(wishes: [wish('a', 'Un jour', WishPriority.someday), wish('b', 'Indispensable', WishPriority.mustHave), wish('c', 'Envie', WishPriority.want)], isLoading: false);
    expect(state.visibleWishes.map((visible) => visible.id), ['b', 'c', 'a']);
  });

  testWidgets('the shared wishlist card groups wishes by priority', (tester) async {
    await tester.pumpWidget(localized(SingleChildScrollView(child: WishlistCard(wishes: [wish('b', 'Hades II', WishPriority.mustHave), wish('a', 'Wingspan', WishPriority.someday)]))));
    expect(find.text('INDISPENSABLE'), findsOneWidget);
    expect(find.text('UN JOUR'), findsOneWidget);
    expect(find.text('ENVIE'), findsNothing);
  });

  testWidgets('the scan line says what is left of the budget', (tester) async {
    final status = BudgetStatus(settings: const BudgetSettings(ceilingCents: 15000), expenses: [BudgetExpense(itemId: 'x', title: 'x', cents: 11800, at: DateTime(2026, 11, 4))], month: DateTime(2026, 11));
    await tester.pumpWidget(localized(BudgetScanLine(status: status)));
    expect(find.textContaining('reste 32,00'), findsOneWidget);
  });
}
