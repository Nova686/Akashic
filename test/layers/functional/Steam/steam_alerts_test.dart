import 'package:akashic/layers/functional/Catalog/domain/entities/category_type.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/collection_item.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/localized_titles.dart';
import 'package:akashic/layers/functional/Steam/data/gateways/drift_steam_stats_gateway.dart';
import 'package:akashic/layers/functional/Steam/data/gateways/drift_steam_watch_store.dart';
import 'package:akashic/layers/functional/Steam/domain/entities/steam_game_stats.dart';
import 'package:akashic/layers/functional/Steam/domain/entities/steam_store_page.dart';
import 'package:akashic/layers/functional/Steam/domain/gateways/steam_alerts.dart';
import 'package:akashic/layers/functional/Steam/domain/use_cases/check_new_steam_dlcs.dart';
import 'package:akashic/layers/functional/Steam/domain/use_cases/watch_steam_wishes.dart';
import 'package:akashic/layers/functional/Wishes/data/gateways/drift_wish_gateway.dart';
import 'package:akashic/layers/functional/Wishes/domain/entities/wish.dart';
import 'package:akashic/layers/functional/Wishes/domain/entities/wish_key.dart';
import 'package:akashic/layers/functional/Wishes/domain/use_cases/add_wish.dart';
import 'package:flutter_test/flutter_test.dart';

import '../Collection/collection_harness.dart';
import 'steam_stats_test.dart';
import 'steam_store_test.dart';

class RecordedAlerts implements SteamAlerts {
  final List<String> said = [];

  @override
  Future<void> wishOnSale(String title, StorePrice price) async => said.add('sale $title -${price.discountPercent}');

  @override
  Future<void> wishReleased(String title) async => said.add('released $title');

  @override
  Future<void> newDlcs(String gameTitle, List<String> dlcNames) async => said.add('dlc $gameTitle ${dlcNames.join(', ')}');

  @override
  Future<void> wishUnderMaximum(String title, StorePrice price, int maxPriceCents) async => said.add('maximum $title ${price.cents}');
}

class DiscountingSteam extends ScriptedSteam {
  DiscountingSteam() : super(const []);

  int discount = 0;

  @override
  Future<Map<String, StorePrice?>> storePrices(List<String> appIds) async => {
        for (final appId in appIds) appId: StorePrice(cents: 2000 * (100 - discount) ~/ 100, currency: 'EUR', initialCents: 2000, discountPercent: discount),
      };
}

class UpcomingStore extends FixedStore {
  bool isComingSoon = true;
  List<String> dlcIds = const ['1206340'];

  @override
  Future<SteamDlc?> dlc(String appId) async => SteamDlc(appId: appId, name: appId == '1206341' ? 'Artbook' : 'Game $appId', isComingSoon: appId == '413150' && isComingSoon);

  @override
  Future<SteamStorePage?> storePage(String appId) async => SteamStorePage(appId: appId, name: 'Hades', dlcIds: dlcIds, shortDescription: '');
}

void main() {
  test('a Steam wish warns when it goes on sale or deeper on sale, and when it comes out', () async {
    final harness = CollectionHarness();
    addTearDown(harness.database.close);
    final wishes = DriftWishGateway(harness.database);
    await AddWish(wishes)(const WishDraft(categoryType: CategoryType.videoGames, title: 'Stardew Valley', origin: WishOrigin.steamWishlist, key: WishKey(sourceKey: 'steam', externalWorkId: '413150')));
    final steam = DiscountingSteam()..discount = 25;
    final store = UpcomingStore();
    final alerts = RecordedAlerts();
    final watchStore = DriftSteamWatchStore(harness.database);
    final watch = WatchSteamWishes(steam, store, wishes, watchStore, alerts);
    await watch();
    expect(alerts.said, isEmpty);
    final first = (await watchStore.wishWatches())['413150']!;
    expect((first.price?.cents, first.price?.discountPercent, first.isComingSoon), (1500, 25, true));
    await watch();
    expect(alerts.said, isEmpty);
    steam.discount = 50;
    store.isComingSoon = false;
    await watch();
    expect(alerts.said, ['released Stardew Valley', 'sale Stardew Valley -50']);
    steam.discount = 0;
    await watch();
    expect(alerts.said, hasLength(2));
  });

  test('a Steam wish warns once when its price falls under the chosen maximum', () async {
    final harness = CollectionHarness();
    addTearDown(harness.database.close);
    final wishes = DriftWishGateway(harness.database);
    final wish = await AddWish(wishes)(const WishDraft(categoryType: CategoryType.videoGames, title: 'Hades II', origin: WishOrigin.steamWishlist, key: WishKey(sourceKey: 'steam', externalWorkId: '1145350')));
    await wishes.savePlan(wish.id, priority: WishPriority.mustHave, maxPriceCents: 1200);
    expect((await wishes.all()).single.priority, WishPriority.mustHave);
    final steam = DiscountingSteam();
    final alerts = RecordedAlerts();
    final watch = WatchSteamWishes(steam, UpcomingStore(), wishes, DriftSteamWatchStore(harness.database), alerts);
    await watch();
    steam.discount = 50;
    await watch();
    await watch();
    expect(alerts.said.where((said) => said.startsWith('maximum')), ['maximum Hades II 1000']);
  });

  test('new DLC of a recently played game is announced once its first list is known', () async {
    final harness = CollectionHarness();
    addTearDown(harness.database.close);
    final games = await harness.createCategory(name: 'Jeux', colorValue: 0, type: CategoryType.videoGames, conditionParts: const ['Jeu']);
    await harness.collection.saveItem(CollectionItem(id: 'hades', categoryId: games.id, titles: const LocalizedTitles(byLanguage: {'en': 'Hades'}), sourceKey: 'steam', externalWorkId: '1145360'));
    final stats = DriftSteamStatsGateway(harness.database);
    await stats.saveAll([SteamGameStats(itemId: 'hades', appId: '1145360', playtimeMinutes: 600, recentMinutes: 60, lastPlayedAt: DateTime(2026, 11, 1), syncedAt: DateTime(2026, 11, 1))]);
    final store = UpcomingStore();
    final alerts = RecordedAlerts();
    var now = DateTime(2026, 11, 2);
    final check = CheckNewSteamDlcs(stats, store, harness.collection, DriftSteamWatchStore(harness.database), alerts, now: () => now);
    await check();
    expect(alerts.said, isEmpty);
    store.dlcIds = const ['1206340', '1206341'];
    now = DateTime(2026, 11, 4);
    await check();
    expect(alerts.said, isEmpty);
    now = DateTime(2026, 11, 10);
    await check();
    expect(alerts.said, ['dlc Hades Artbook']);
  });
}
