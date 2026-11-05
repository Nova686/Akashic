import 'dart:convert';

import 'package:akashic/layers/functional/Catalog/domain/entities/category_type.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/card_kind.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/collection_item.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/localized_titles.dart';
import 'package:akashic/layers/functional/Lookup/domain/entities/card_game.dart';
import 'package:akashic/layers/functional/Lookup/domain/entities/source_unavailable.dart';
import 'package:akashic/layers/functional/SealedPrices/data/gateways/drift_price_alert_store.dart';
import 'package:akashic/layers/functional/SealedPrices/data/gateways/drift_sealed_price_store.dart';
import 'package:akashic/layers/functional/SealedPrices/domain/entities/price_alert.dart';
import 'package:akashic/layers/functional/SealedPrices/domain/gateways/price_alert_store.dart';
import 'package:akashic/layers/functional/SealedPrices/data/sources/cardmarket_price_guide.dart';
import 'package:akashic/layers/functional/SealedPrices/domain/entities/sealed_price.dart';
import 'package:akashic/layers/functional/SealedPrices/domain/use_cases/refresh_sealed_prices.dart';
import 'package:akashic/layers/functional/SealedPrices/presentation/widgets/sealed_price_section.dart';
import 'package:akashic/layers/technical/Localization/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

import '../Collection/collection_harness.dart';

final List<int> pokemonGuide = utf8.encode(jsonEncode({
  'version': 1,
  'priceGuides': [
    {'idProduct': 103, 'idCategory': 3, 'avg': 210.5, 'low': 189.99, 'trend': 214.3, 'avg1': 0, 'avg7': 208.12, 'avg30': 205},
    {'idProduct': 999, 'idCategory': 3, 'avg': 10, 'low': 9, 'trend': 11},
  ],
}));

CardmarketPriceGuide fakeGuide({List<String>? requests, int status = 200}) => CardmarketPriceGuide(MockClient((request) async {
      requests?.add('${request.method} ${request.url.path}');
      if (request.url.path != '/productCatalog/priceGuide/price_guide_6.json') {
        return http.Response('', 404);
      }
      if (request.method == 'HEAD') {
        return http.Response('', 200, headers: {'content-length': '15755005'});
      }
      return status == 200 ? http.Response.bytes(pokemonGuide, 200) : http.Response('', status);
    }));

void main() {
  test('the price guide keeps the owned products only, in cents, without empty prices', () {
    final prices = pricesInGuide(pokemonGuide, {'103'}, DateTime(2026, 10, 30));
    expect(prices, [
      SealedPrice(productId: '103', pricedAt: DateTime(2026, 10, 30), lowCents: 18999, averageCents: 21050, trendCents: 21430, average7Cents: 20812, average30Cents: 20500),
    ]);
    expect(prices.single.referenceCents, 21430);
  });

  test('the Cardmarket guide gives its download size and reports an unreachable file', () async {
    expect(await fakeGuide().downloadSizeOf(CardGame.pokemon), 15755005);
    expect(await fakeGuide().downloadSizeOf(CardGame.magic), isNull);
    expect(fakeGuide(status: 503).pricesOf(CardGame.pokemon, {'103'}, pricedAt: DateTime(2026)), throwsA(isA<SourceUnavailable>()));
  });

  Future<(CollectionHarness, DriftSealedPriceStore)> sealedCollection() async {
    final harness = CollectionHarness();
    addTearDown(harness.database.close);
    final pokemon = await harness.createCategory(name: 'Pokémon', colorValue: 0, type: CategoryType.cards, conditionParts: const ['Objet']);
    final books = await harness.createCategory(name: 'Livres', colorValue: 0, type: CategoryType.books, conditionParts: const ['Objet']);
    await harness.collection.saveItem(CollectionItem(
      id: 'display',
      categoryId: pokemon.id,
      titles: const LocalizedTitles(byLanguage: {'en': 'Evolving Skies Booster Box'}),
      cardKind: CardKind.sealed,
      sourceKey: 'cardmarket',
      externalWorkId: '103',
    ));
    await harness.collection.saveItem(CollectionItem(id: 'novel', categoryId: books.id, titles: const LocalizedTitles(byLanguage: {'fr': 'Roman'}), sourceKey: 'cardmarket', externalWorkId: '999'));
    return (harness, DriftSealedPriceStore(harness.database));
  }

  test('refreshing stores the prices of owned sealed products and values the items at the trend', () async {
    final (harness, store) = await sealedCollection();
    final requests = <String>[];
    final refresh = RefreshSealedPrices(harness.collection, harness.categories, fakeGuide(requests: requests), store, now: () => DateTime(2026, 10, 30, 8));
    expect(await refresh.downloadSize(), 15755005);
    expect(await refresh(), 1);
    final price = await store.watchPrice('103').first;
    expect((price?.trendCents, price?.average30Cents), (21430, 20500));
    expect(await store.watchPrice('999').first, isNull);
    final display = await harness.collection.watchItem('display').first;
    expect((display?.marketValue?.cents, display?.marketValue?.currency), (21430, 'EUR'));
    expect((await harness.collection.watchItem('novel').first)?.marketValue, isNull);
    expect(requests.where((request) => request.startsWith('GET')), hasLength(1));
  });

  test('the automatic refresh skips prices downloaded less than a day ago', () async {
    final (harness, store) = await sealedCollection();
    final requests = <String>[];
    var now = DateTime(2026, 10, 30, 8);
    final refresh = RefreshSealedPrices(harness.collection, harness.categories, fakeGuide(requests: requests), store, now: () => now);
    expect(await refresh.refreshIfStale(), 1);
    now = DateTime(2026, 10, 30, 20);
    expect(await refresh.refreshIfStale(), 0);
    now = DateTime(2026, 10, 31, 9);
    expect(await refresh.refreshIfStale(), 1);
    expect(requests, hasLength(2));
  });

  test('a price alert warns once when the trend crosses its threshold, and again only after going back', () async {
    final (harness, store) = await sealedCollection();
    final alerts = DriftPriceAlertStore(harness.database);
    final crossings = <(String, int)>[];
    await alerts.save(const PriceAlert(itemId: 'display', thresholdCents: 20000, isAbove: true));
    var now = DateTime(2026, 10, 30, 8);
    final refresh = RefreshSealedPrices(harness.collection, harness.categories, fakeGuide(), store, alerts: alerts, alertNotifier: RecordedCrossings(crossings), now: () => now);
    await refresh();
    expect(crossings, [('Evolving Skies Booster Box', 21430)]);
    now = DateTime(2026, 10, 31, 8);
    await refresh();
    expect(crossings, hasLength(1));
    await alerts.save(const PriceAlert(itemId: 'display', thresholdCents: 25000, isAbove: true));
    await refresh();
    expect((await alerts.all()).single.notifiedAt, isNull);
    expect(crossings, hasLength(1));
  });

  testWidgets('the price block shows the trend, the details and warns about opened copies', (tester) async {
    var refreshed = 0;
    await tester.pumpWidget(MaterialApp(
      locale: const Locale('fr'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(
        body: SingleChildScrollView(
          child: SealedPriceSection(
            watchPrice: () => Stream.value(SealedPrice(productId: '103', pricedAt: DateTime(2026, 10, 30, 8), lowCents: 18999, trendCents: 21430, average30Cents: 20500)),
            onRefresh: () async => refreshed++,
            hasOpenedCopy: true,
          ),
        ),
      ),
    ));
    await tester.pump();
    expect(find.text('Tendance'), findsOneWidget);
    expect(find.textContaining('214,30'), findsOneWidget);
    expect(find.text('Moyenne 30 jours'), findsOneWidget);
    expect(find.textContaining('ne cote que le scellé'), findsOneWidget);
    await tester.tap(find.text('Mettre à jour les prix'));
    await tester.pump();
    expect(refreshed, 1);
  });
}

class RecordedCrossings implements PriceAlertNotifier {
  RecordedCrossings(this.crossings);

  final List<(String, int)> crossings;

  @override
  Future<void> crossed(String title, int cents, PriceAlert alert) async => crossings.add((title, cents));
}
