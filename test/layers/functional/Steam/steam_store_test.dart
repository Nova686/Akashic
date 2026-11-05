import 'dart:io';

import 'package:akashic/layers/functional/Catalog/domain/entities/category_type.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/collection_item.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/localized_titles.dart';
import 'package:akashic/layers/functional/Steam/data/sources/steam_store_client.dart';
import 'package:akashic/layers/functional/Steam/domain/entities/steam_store_page.dart';
import 'package:akashic/layers/functional/Steam/domain/gateways/steam_store_api.dart';
import 'package:akashic/layers/functional/Steam/domain/use_cases/load_steam_store_sheet.dart';
import 'package:akashic/layers/functional/Steam/presentation/widgets/steam_store_tab.dart';
import 'package:akashic/layers/technical/Localization/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:akashic/layers/functional/Lookup/domain/entities/source_unavailable.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:intl/date_symbol_data_local.dart';

import '../Collection/collection_harness.dart';

http.Response fixture(String name) => http.Response.bytes(File('test/fixtures/$name').readAsBytesSync(), 200, headers: {'content-type': 'application/json; charset=utf-8'});

class CountingStore extends FixedStore {
  int pageCalls = 0;
  int dlcCalls = 0;
  bool isDown = false;

  @override
  Future<SteamStorePage?> storePage(String appId) async {
    pageCalls++;
    if (isDown) {
      throw const SourceUnavailable('steam-store');
    }
    return super.storePage(appId);
  }

  @override
  Future<SteamDlc?> dlc(String appId) async {
    dlcCalls++;
    return super.dlc(appId);
  }
}

class FixedStore implements SteamStoreApi {
  @override
  Future<SteamStorePage?> storePage(String appId) async => const SteamStorePage(appId: '1145360', name: 'Hades', dlcIds: ['1206340', '1206341'], shortDescription: 'Défiez le dieu des morts.');

  @override
  Future<List<SteamNews>> news(String appId) async => [SteamNews(title: 'Patch 1.38', url: 'https://store.steampowered.com/news/1', publishedAt: DateTime.utc(2026, 10, 20))];

  @override
  Future<SteamDlc?> dlc(String appId) async => SteamDlc(appId: appId, name: appId == '1206340' ? 'Bande originale' : 'Artbook', price: const SteamPrice(initialCents: 999, finalCents: 999, discountPercent: 0, currency: 'EUR'));
}

void main() {
  setUpAll(() => initializeDateFormatting('fr'));

  test('steam html becomes readable lines', () {
    expect(plainTextOf('<strong>Minimale :</strong><br><ul><li><strong>Processeur :</strong> Dual Core&nbsp;2.4 GHz<br></li></ul>'), 'Minimale :\nProcesseur : Dual Core 2.4 GHz');
    expect(plainTextOf('   '), isNull);
  });

  test('the store page reads price, media, requirements and dlc from the real hades answer, the news from the news api', () async {
    final client = SteamStoreClient(
      MockClient((request) async {
        expect(request.url.queryParameters, {'appids': '1145360', 'cc': 'fr', 'l': 'french'});
        return fixture('steam_appdetails_hades.json');
      }),
      MockClient((request) async {
        expect(request.url.path, '/ISteamNews/GetNewsForApp/v2/');
        return fixture('steam_news_hades.json');
      }),
    );
    final page = (await client.storePage('1145360'))!;
    expect(page.name, 'Hades');
    expect(page.price, const SteamPrice(initialCents: 2450, finalCents: 1470, discountPercent: 40, currency: 'EUR'));
    expect(page.price!.isDiscounted, isTrue);
    expect(page.genres, contains('RPG'));
    expect(page.features, contains('Solo'));
    expect(page.developers, isNotEmpty);
    expect(page.screenshots, hasLength(2));
    expect(page.trailerThumbnailUrl, startsWith('https://'));
    expect(page.minimumRequirements, contains('Processeur'));
    expect(page.languages, contains('Français'));
    expect(page.dlcIds, ['1206340']);
    final news = await client.news('1145360');
    expect(news, isNotEmpty);
    expect(news.first.url, startsWith('https://'));
  });

  test('a dlc already in the collection is marked as such', () async {
    final harness = CollectionHarness();
    addTearDown(harness.database.close);
    final games = await harness.createCategory(name: 'Jeux', colorValue: 0, type: CategoryType.videoGames, conditionParts: const ['Jeu']);
    await harness.collection.saveItem(CollectionItem(id: 'ost', categoryId: games.id, titles: const LocalizedTitles(byLanguage: {'en': 'Hades OST'}), sourceKey: 'steam', externalWorkId: '1206340'));
    final loader = LoadSteamStoreSheet(FixedStore(), harness.collection);
    final sheet = await loader('1145360');
    expect(sheet.dlcs, isEmpty);
    expect(sheet.news.single.title, 'Patch 1.38');
    final dlcs = await loader.dlcsOf('1145360');
    expect(dlcs.map((dlc) => (dlc.name, dlc.isInCollection)), [('Bande originale', true), ('Artbook', false)]);
  });

  test('the store sheet is fetched once and kept, so a prefetch makes the tab instant', () async {
    final harness = CollectionHarness();
    addTearDown(harness.database.close);
    final store = CountingStore();
    final loader = LoadSteamStoreSheet(store, harness.collection)..prefetch('1145360');
    await loader.dlcsOf('1145360');
    await loader('1145360');
    await loader.dlcsOf('1145360');
    expect((store.pageCalls, store.dlcCalls), (1, 2));
  });

  test('a failed store sheet is not kept, so a retry asks again', () async {
    final harness = CollectionHarness();
    addTearDown(harness.database.close);
    final store = CountingStore()..isDown = true;
    final loader = LoadSteamStoreSheet(store, harness.collection);
    await expectLater(loader('1145360'), throwsA(isA<SourceUnavailable>()));
    store.isDown = false;
    expect((await loader('1145360')).page.name, 'Hades');
    expect(store.pageCalls, 2);
  });

  testWidgets('the store tab shows the price first, then the news, then the dlc, then the rest', (tester) async {
    await tester.binding.setSurfaceSize(const Size(500, 2400));
    final wished = <String>[];
    await tester.pumpWidget(MaterialApp(
      locale: const Locale('fr'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(
        body: SingleChildScrollView(
          child: SteamStoreTab(
            load: () async => SteamStoreSheet(
              page: const SteamStorePage(appId: '1145360', name: 'Hades', shortDescription: 'Défiez le dieu des morts.', price: SteamPrice(initialCents: 2450, finalCents: 1470, discountPercent: 40, currency: 'EUR')),
              news: [SteamNews(title: 'Patch 1.38', url: 'https://store.steampowered.com/news/1', publishedAt: DateTime.utc(2026, 10, 20))],
              dlcs: const [SteamDlc(appId: '1', name: 'Bande originale', isInCollection: true), SteamDlc(appId: '2', name: 'Artbook')],
            ),
            onWishDlc: (dlc) async => wished.add(dlc.name),
          ),
        ),
      ),
    ));
    await tester.pumpAndSettle();
    double top(String text) => tester.getTopLeft(find.text(text)).dy;
    expect(find.text('−40 %'), findsOneWidget);
    expect(top('Prix du jour sur Steam'), lessThan(top('Actualités')));
    expect(top('Actualités'), lessThan(top('Contenus additionnels')));
    expect(top('Contenus additionnels'), lessThan(top('À propos')));
    expect(find.text('Dans ta collection'), findsOneWidget);
    await tester.tap(find.text('Envie'));
    await tester.pumpAndSettle();
    expect(wished, ['Artbook']);
    await tester.binding.setSurfaceSize(null);
  });
}
