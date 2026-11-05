import 'package:akashic/layers/functional/Catalog/domain/entities/category_type.dart';
import 'package:akashic/layers/functional/Collection/data/gateways/drift_deck_gateway.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/card_kind.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/collection_item.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/deck_card.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/item_copy.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/localized_titles.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/market_value.dart';
import 'package:akashic/layers/functional/Collection/domain/use_cases/update_card_prices.dart';
import 'package:akashic/layers/functional/Lookup/domain/entities/source_unavailable.dart';
import 'package:akashic/layers/functional/Lookup/domain/gateways/record_market.dart';
import 'package:akashic/layers/functional/Settings/domain/entities/preferred_languages.dart';
import 'package:akashic/layers/functional/Stats/data/gateways/drift_stats_gateway.dart';
import 'package:akashic/layers/functional/Stats/domain/entities/collection_value.dart';
import 'package:akashic/layers/functional/Stats/domain/use_cases/compute_collection_value.dart';
import 'package:akashic/layers/functional/Stats/domain/use_cases/refresh_collection_values.dart';
import 'package:akashic/layers/functional/Stats/presentation/cubit/collection_value_cubit.dart';
import 'package:akashic/layers/functional/Stats/presentation/views/duplicates_view.dart';
import 'package:akashic/layers/technical/Localization/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

import '../Collection/collection_harness.dart';

class FakeRecordMarket implements RecordMarket {
  FakeRecordMarket({this.prices = const {}, this.mainReleases = const {}, this.rateLimitedFrom});

  final Map<String, int> prices;
  final Map<String, String> mainReleases;
  final int? rateLimitedFrom;
  final List<String> askedReleases = [];

  @override
  bool get isConfigured => true;

  @override
  Future<MarketValue?> lowestPriceOf(String releaseId) async {
    if (rateLimitedFrom case final limit? when askedReleases.length >= limit) {
      throw const SourceUnavailable('discogs', 'rate', true);
    }
    askedReleases.add(releaseId);
    return switch (prices[releaseId]) {
      final cents? => MarketValue(cents: cents, currency: 'EUR', valuedAt: DateTime(2026, 10, 29)),
      null => null,
    };
  }

  @override
  Future<String?> mainReleaseOf(String masterId) async => mainReleases[masterId];
}

void main() {
  late CollectionHarness harness;
  late DriftDeckGateway decks;
  late ComputeCollectionValue computeValue;
  late String vinylsId;
  late String cardsId;
  late String mangasId;

  RefreshCollectionValues refreshWith(RecordMarket market) => RefreshCollectionValues(harness.collection, harness.categories, market, UpdateCardPrices(decks, const []));

  CollectionItem item(String id, String categoryId, String title, {String? sourceKey, String? externalWorkId, CardKind? cardKind, String? creator, int? volumeNumber}) => CollectionItem(
    id: id,
    categoryId: categoryId,
    titles: LocalizedTitles(byLanguage: {'fr': title}),
    sourceKey: sourceKey,
    externalWorkId: externalWorkId,
    cardKind: cardKind,
    creator: creator,
    volumeNumber: volumeNumber,
  );

  setUp(() async {
    harness = CollectionHarness();
    decks = DriftDeckGateway(harness.database);
    computeValue = ComputeCollectionValue(harness.collection, decks, DriftStatsGateway(harness.database), harness.categories);
    final vinyls = await harness.vinyls();
    vinylsId = (await harness.createCategory(name: 'Jazz', colorValue: 0xFF7FA8FF, type: CategoryType.music, conditionParts: const ['Disque'], parentId: vinyls.id)).id;
    cardsId = (await harness.createCategory(name: 'TCG', colorValue: 0xFF5ED1C3, type: CategoryType.cards, conditionParts: const ['Carte'])).id;
    mangasId = (await harness.mangas()).id;
  });

  tearDown(() => harness.database.close());

  test('a refresh prices records from their copy edition, release or master and stops when rate limited', () async {
    await harness.collection.saveItem(item('kob', vinylsId, 'Kind of Blue', sourceKey: 'discogs', externalWorkId: 'master:5'));
    await harness.collection.saveCopy(const ItemCopy(id: 'kob-1', itemId: 'kob', externalEditionId: '111'));
    await harness.collection.saveItem(item('blue', vinylsId, 'Blue Train', sourceKey: 'discogs', externalWorkId: 'release:222'));
    await harness.collection.saveItem(item('moanin', vinylsId, 'Moanin', sourceKey: 'discogs', externalWorkId: 'master:9'));
    await harness.collection.saveItem(item('frieren', mangasId, 'Frieren', sourceKey: 'discogs', externalWorkId: 'release:1'));
    final market = FakeRecordMarket(prices: const {'111': 1500, '222': 900, '333': 700}, mainReleases: const {'9': '333'});
    final refresh = await refreshWith(market)();
    expect(refresh, const ValueRefresh(recordsValued: 3, decksPriced: 0, isComplete: true));
    expect(market.askedReleases, unorderedEquals(['111', '222', '333']));
    expect((await harness.collection.watchItem('kob').first)!.marketValue?.cents, 1500);
    final again = FakeRecordMarket(prices: const {'111': 1600});
    await RefreshCollectionValues(harness.collection, harness.categories, again, UpdateCardPrices(decks, const []), now: () => DateTime(2026, 10, 29, 12))();
    expect(again.askedReleases, isEmpty);
    expect((await harness.collection.watchItem('kob').first)!.marketValue?.cents, 1500);
    await harness.collection.saveMarketValues({'kob': null, 'blue': null, 'moanin': null});
    final limited = await refreshWith(FakeRecordMarket(prices: const {'111': 1500}, rateLimitedFrom: 1))();
    expect(limited.isComplete, isFalse);
    expect(limited.recordsValued, 1);
  });

  test('the value uses market prices per copy, deck card prices, then the price paid, by top-level category', () async {
    await harness.collection.saveItem(item('kob', vinylsId, 'Kind of Blue'));
    await harness.collection.saveCopy(const ItemCopy(id: 'kob-1', itemId: 'kob', pricePaidCents: 5000));
    await harness.collection.saveCopy(const ItemCopy(id: 'kob-2', itemId: 'kob'));
    await harness.collection.saveMarketValue('kob', MarketValue(cents: 1200, currency: 'EUR', valuedAt: DateTime(2026, 10, 20)));
    await harness.collection.saveItem(item('deck', cardsId, 'Deck', cardKind: CardKind.deck));
    await harness.collection.saveCopy(const ItemCopy(id: 'deck-1', itemId: 'deck', pricePaidCents: 4000));
    await decks.saveCard(
      DeckCard(
        id: 'sol',
        itemId: 'deck',
        name: 'Sol Ring',
        quantity: 2,
        price: CardPrice(cents: 150, currency: 'USD', pricedAt: DateTime(2026, 10, 1)),
      ),
    );
    await harness.collection.saveItem(item('frieren', mangasId, 'Frieren'));
    await harness.collection.saveCopy(const ItemCopy(id: 'frieren-1', itemId: 'frieren', pricePaidCents: 690));
    await harness.collection.saveItem(item('unknown', mangasId, 'Inconnu'));
    final value = await computeValue();
    expect(value.totalByCurrency, {'EUR': 2400 + 690, 'USD': 300});
    expect(
      {for (final category in value.categories) category.category.name: category.byCurrency},
      {
        'Vinyles': {'EUR': 2400},
        'TCG': {'USD': 300},
        'Mangas': {'EUR': 690},
      },
    );
    expect((value.marketValuedItems, value.purchaseValuedItems, value.unvaluedItems), (2, 1, 1));
    expect(value.lastValuedAt, DateTime(2026, 10, 20));
  });

  test('duplicates list works added twice, volumes apart', () async {
    await harness.collection.saveItem(item('kob', vinylsId, 'Kind of Blue', creator: 'Miles Davis'));
    await harness.collection.saveCopy(const ItemCopy(id: 'kob-1', itemId: 'kob'));
    await harness.collection.saveCopy(const ItemCopy(id: 'kob-2', itemId: 'kob'));
    await harness.collection.saveItem(item('kob-again', vinylsId, 'kind of blue', creator: 'Miles Davis'));
    await harness.collection.saveItem(item('f1', mangasId, 'Frieren', volumeNumber: 1));
    await harness.collection.saveItem(item('f2', mangasId, 'Frieren', volumeNumber: 2));
    final duplicates = await computeValue.duplicates(titleOf: (found) => found.titles.byLanguage['fr'] ?? '');
    expect(duplicates.sameWork.map((group) => group.map((found) => found.id).toSet()), [
      {'kob', 'kob-again'},
    ]);
  });

  testWidgets('the duplicates page lists works added twice and opens an item', (tester) async {
    late final CollectionValueCubit cubit;
    final opened = <String>[];
    await tester.runAsync(() async {
      await harness.collection.saveItem(item('kob', vinylsId, 'Kind of Blue'));
      await harness.collection.saveCopy(const ItemCopy(id: 'kob-1', itemId: 'kob'));
      await harness.collection.saveCopy(const ItemCopy(id: 'kob-2', itemId: 'kob'));
      await harness.collection.saveItem(item('kob-again', vinylsId, 'Kind of Blue'));
      cubit = CollectionValueCubit(computeValue, refreshWith(FakeRecordMarket()), preferredLanguages: () async => PreferredLanguages.defaults);
      await cubit.start();
    });
    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('fr'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: BlocProvider.value(
          value: cubit,
          child: DuplicatesView(onOpenItem: opened.add),
        ),
      ),
    );
    expect(find.text('Plusieurs exemplaires'), findsNothing);
    expect(find.text('Même œuvre ajoutée plusieurs fois'), findsOneWidget);
    await tester.tap(find.text('Kind of Blue').first);
    expect(opened, hasLength(1));
    await tester.runAsync(cubit.close);
  });
}
