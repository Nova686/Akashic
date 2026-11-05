import 'package:akashic/layers/functional/Catalog/domain/entities/category_type.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/card_kind.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/collection_item.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/item_copy.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/localized_titles.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/trade_channel.dart';
import 'package:akashic/layers/functional/Collection/domain/use_cases/delete_copy.dart';
import 'package:akashic/layers/functional/Collection/domain/use_cases/update_copy.dart';
import 'package:akashic/layers/functional/Collection/presentation/cubit/copy_editor_cubit.dart';
import 'package:akashic/layers/functional/Trades/data/gateways/drift_trade_gateway.dart';
import 'package:akashic/layers/functional/Trades/domain/entities/trade_history.dart';
import 'package:akashic/layers/functional/Trades/domain/use_cases/sell_copy.dart';
import 'package:akashic/layers/functional/Collection/presentation/widgets/copy_card.dart';
import 'package:akashic/layers/functional/Trades/presentation/cubit/trade_history_cubit.dart';
import 'package:akashic/layers/functional/Trades/presentation/views/trade_history_view.dart';
import 'package:akashic/layers/technical/Localization/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

import '../Collection/collection_harness.dart';

void main() {
  Future<(CollectionHarness, DriftTradeGateway)> sealedShelf() async {
    final harness = CollectionHarness();
    addTearDown(harness.database.close);
    final pokemon = await harness.createCategory(name: 'Pokémon', colorValue: 0, type: CategoryType.cards, conditionParts: const ['Objet']);
    await harness.collection.saveItem(CollectionItem(id: 'etb', categoryId: pokemon.id, titles: const LocalizedTitles(byLanguage: {'en': 'Prismatic Evolutions ETB'}), cardKind: CardKind.sealed));
    await harness.collection.saveCopy(ItemCopy(id: 'etb-1', itemId: 'etb', pricePaidCents: 6000, purchasedOn: DateTime(2025, 1, 17), purchaseChannel: TradeChannel.store));
    await harness.collection.saveCopy(ItemCopy(id: 'etb-2', itemId: 'etb', pricePaidCents: 6500, purchasedOn: DateTime(2025, 2, 3), purchaseChannel: TradeChannel.online, isOpened: true));
    return (harness, DriftTradeGateway(harness.database));
  }

  test('a copy keeps its sealing state, purchase date and channel', () async {
    final (harness, _) = await sealedShelf();
    final copies = await harness.collection.watchCopies('etb').first;
    final opened = copies.singleWhere((copy) => copy.id == 'etb-2');
    expect((opened.isOpened, opened.purchasedOn, opened.purchaseChannel), (true, DateTime(2025, 2, 3), TradeChannel.online));
    expect(copies.singleWhere((copy) => copy.id == 'etb-1').isOpened, isFalse);
  });

  test('selling a copy removes it, keeps the item and records the sale with its purchase', () async {
    final (harness, trades) = await sealedShelf();
    final sell = SellCopy(harness.collection, trades, DeleteCopy(harness.collection), newId: () => 'sale-1');
    final copy = (await harness.collection.watchCopies('etb').first).singleWhere((copy) => copy.id == 'etb-1');
    final deletion = await sell(copy, salePriceCents: 11000, soldOn: DateTime(2025, 10, 1), channel: TradeChannel.online);
    expect(deletion, CopyDeletion.copyOnly);
    expect((await harness.collection.watchCopies('etb').first).map((copy) => copy.id), ['etb-2']);
    final history = await trades.watchHistory().first;
    final sale = history.sales.single;
    expect((sale.titles.byLanguage['en'], sale.purchasePriceCents, sale.purchasedOn, sale.purchaseChannel, sale.saleChannel, sale.wasOpened), ('Prismatic Evolutions ETB', 6000, DateTime(2025, 1, 17), TradeChannel.store, TradeChannel.online, false));
    expect(sale.marginCents, 5000);
    expect((history.spentCents, history.earnedCents, history.marginCents), (12500, 11000, 5000));
    expect(history.entries.map((entry) => (entry is SaleEntry, entry.happenedOn)), [(true, DateTime(2025, 10, 1)), (false, DateTime(2025, 2, 3)), (false, DateTime(2025, 1, 17))]);
  });

  test('selling the last copy removes the item but the sale stays in the history', () async {
    final (harness, trades) = await sealedShelf();
    final sell = SellCopy(harness.collection, trades, DeleteCopy(harness.collection));
    for (final copy in await harness.collection.watchCopies('etb').first) {
      await sell(copy, salePriceCents: 5000, soldOn: DateTime(2025, 10, 2));
    }
    expect(await harness.collection.watchItem('etb').first, isNull);
    final history = await trades.watchHistory().first;
    expect(history.purchases, isEmpty);
    expect(history.sales.map((sale) => sale.wasOpened).toSet(), {true, false});
    expect(history.marginCents, -2500);
  });

  test('the copy editor saves purchase details and sells with the price being edited', () async {
    final (harness, trades) = await sealedShelf();
    final copy = (await harness.collection.watchCopies('etb').first).singleWhere((copy) => copy.id == 'etb-1');
    final sell = SellCopy(harness.collection, trades, DeleteCopy(harness.collection));
    final editor = CopyEditorCubit(
      UpdateCopy(harness.collection),
      copy,
      parts: const ['Objet'],
      deleteCopy: DeleteCopy(harness.collection),
      sellCopy: (soldCopy, sale) => sell(soldCopy, salePriceCents: sale.priceCents, soldOn: sale.soldOn, channel: sale.channel),
      tracksSealing: true,
    );
    expect(editor.canSell, isTrue);
    editor
      ..setOpened(true)
      ..setPurchaseChannel(null)
      ..setPurchasedOn(DateTime(2024, 12, 24));
    await editor.save();
    final saved = (await harness.collection.watchCopies('etb').first).singleWhere((copy) => copy.id == 'etb-1');
    expect((saved.isOpened, saved.purchasedOn, saved.purchaseChannel, saved.pricePaidCents), (true, DateTime(2024, 12, 24), null, 6000));
    editor.setPriceText('55');
    await editor.sell((priceCents: 7000, soldOn: DateTime(2025, 3, 1), channel: TradeChannel.store));
    final sale = (await trades.watchHistory().first).sales.single;
    expect((sale.purchasePriceCents, sale.wasOpened, sale.salePriceCents), (5500, true, 7000));
    await editor.close();
  });

  Widget inApp(Widget child) => MaterialApp(
        locale: const Locale('fr'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: child,
      );

  testWidgets('the history shows totals, the sale with its margin and the purchases by month', (tester) async {
    final (harness, trades) = await tester.runAsync(sealedShelf) as (CollectionHarness, DriftTradeGateway);
    await tester.runAsync(() async {
      final copy = (await harness.collection.watchCopies('etb').first).singleWhere((copy) => copy.id == 'etb-1');
      await SellCopy(harness.collection, trades, DeleteCopy(harness.collection))(copy, salePriceCents: 11000, soldOn: DateTime(2025, 10, 1));
    });
    final cubit = TradeHistoryCubit(trades)..start();
    await tester.runAsync(() => cubit.stream.firstWhere((state) => !state.isLoading));
    await tester.pumpWidget(inApp(BlocProvider.value(value: cubit, child: TradeHistoryView(onOpenItem: (_) {}))));
    expect(find.text('Achats et ventes'), findsOneWidget);
    expect(find.textContaining('125,00'), findsOneWidget);
    expect(find.textContaining('+110,00'), findsOneWidget);
    expect(find.textContaining('+50,00'), findsNWidgets(2));
    expect(find.text('Octobre 2025'), findsOneWidget);
    expect(find.text('Janvier 2025'), findsOneWidget);
    await tester.pumpWidget(const SizedBox());
    await tester.runAsync(cubit.close);
  });

  testWidgets('a sealed product copy shows whether it is opened and where it was bought', (tester) async {
    await tester.pumpWidget(inApp(Scaffold(
      body: CopyCard(
        copy: ItemCopy(id: 'etb-2', itemId: 'etb', isOpened: true, purchasedOn: DateTime(2025, 2, 3), purchaseChannel: TradeChannel.online),
        onTap: () {},
        showsSealing: true,
      ),
    )));
    expect(find.text('Ouvert'), findsOneWidget);
    expect(find.text('Acheté le 3 févr. 2025 · En ligne'), findsOneWidget);
  });
}
