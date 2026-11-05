import 'dart:convert';

import 'package:akashic/layers/functional/Catalog/domain/entities/category_type.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/collection_item.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/localized_titles.dart';
import 'package:akashic/layers/functional/Steam/data/gateways/drift_steam_wishlist_memory.dart';
import 'package:akashic/layers/functional/Steam/data/sources/steam_player_client.dart';
import 'package:akashic/layers/functional/Lookup/domain/entities/source_unavailable.dart';
import 'package:akashic/layers/functional/Steam/domain/entities/steam_game_stats.dart';
import 'package:akashic/layers/functional/Steam/domain/entities/steam_store_page.dart';
import 'package:akashic/layers/functional/Steam/domain/gateways/steam_player_api.dart';
import 'package:akashic/layers/functional/Steam/domain/use_cases/sync_steam_wishlist.dart';
import 'package:akashic/layers/functional/Wishes/data/gateways/drift_wish_gateway.dart';
import 'package:akashic/layers/functional/Wishes/domain/entities/wish.dart';
import 'package:akashic/layers/functional/Wishes/domain/use_cases/add_wish.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

import '../Collection/collection_harness.dart';
import 'steam_stats_test.dart';
import 'steam_store_test.dart';

class NamedStore extends FixedStore {
  final List<String> lookups = [];

  @override
  Future<SteamDlc?> dlc(String appId) async {
    lookups.add(appId);
    return SteamDlc(appId: appId, name: 'Game $appId', imageUrl: 'https://cdn.steam/$appId.jpg');
  }
}

void main() {
  test('the Steam wishlist is read in priority order', () async {
    final client = SteamPlayerClient(
      MockClient((request) async {
        expect(request.url.path, '/IWishlistService/GetWishlist/v1/');
        expect(request.url.queryParameters['steamid'], '765');
        return jsonResponse({
          'response': {
            'items': [
              {'appid': 1145360, 'priority': 2, 'date_added': 1700000000},
              {'appid': 413150, 'priority': 1, 'date_added': 1690000000},
            ],
          },
        });
      }),
      MockClient((request) async => http.Response('', 404)),
      apiKey: 'key',
    );
    final items = await client.wishlist('765');
    expect(items.map((item) => (item.appId, item.priority)), [('413150', 1), ('1145360', 2)]);
    expect(items.first.addedAt, DateTime.fromMillisecondsSinceEpoch(1690000000 * 1000, isUtc: true));
  });

  test('wished Steam games land in the wishes once, owned ones are skipped and removed ones stay removed', () async {
    final harness = CollectionHarness();
    addTearDown(harness.database.close);
    final games = await harness.createCategory(name: 'Jeux', colorValue: 0, type: CategoryType.videoGames, conditionParts: const ['Jeu']);
    await harness.collection.saveItem(CollectionItem(id: 'hades', categoryId: games.id, titles: const LocalizedTitles(byLanguage: {'en': 'Hades'}), sourceKey: 'steam', externalWorkId: '1145360'));
    final wishes = DriftWishGateway(harness.database);
    final store = NamedStore();
    final steam = ScriptedSteam(const [], wishlistItems: const [SteamWishlistItem(appId: '413150', priority: 1), SteamWishlistItem(appId: '1145360', priority: 2), SteamWishlistItem(appId: '367520', priority: 3)]);
    final sync = SyncSteamWishlist(steam, store, harness.collection, AddWish(wishes), DriftSteamWishlistMemory(harness.database));
    expect(await sync('765', categoryId: games.id), 2);
    final saved = await wishes.all();
    expect(saved.map((wish) => wish.draft.title).toSet(), {'Game 413150', 'Game 367520'});
    final stardew = saved.firstWhere((wish) => wish.draft.title == 'Game 413150');
    expect((stardew.draft.origin, stardew.draft.key.sourceKey, stardew.draft.key.externalWorkId, stardew.draft.categoryId, stardew.draft.imageUrl), (WishOrigin.steamWishlist, 'steam', '413150', games.id, 'https://cdn.steam/413150.jpg'));
    expect(store.lookups, ['413150', '367520']);
    await wishes.remove(stardew.id);
    expect(await sync('765'), 0);
    expect((await wishes.all()).map((wish) => wish.draft.title), ['Game 367520']);
  });

  test('a private profile and a game without achievements are told apart from an outage', () async {
    SteamPlayerClient clientAnswering(int status, Map<String, Object?> body) => SteamPlayerClient(
          MockClient((request) async => http.Response(jsonEncode(body), status, headers: {'content-type': 'application/json'})),
          MockClient((request) async => http.Response('', 404)),
          apiKey: 'key',
        );
    final noStats = clientAnswering(400, {'playerstats': {'error': 'Requested app has no stats', 'success': false}});
    expect(await noStats.achievementProgress('765', '1145360'), const AchievementProgress(unlocked: 0, total: 0));
    final private = clientAnswering(403, {'playerstats': {'error': 'Profile is not public', 'success': false}});
    await expectLater(private.achievementProgress('765', '1145360'), throwsA(isA<SteamProfilePrivate>()));
    await expectLater(private.achievements('765', '1145360'), throwsA(isA<SteamProfilePrivate>()));
    final down = clientAnswering(503, const {});
    await expectLater(down.achievementProgress('765', '1145360'), throwsA(isA<SourceUnavailable>()));
  });

  test('a wished game missing from the store is remembered, so it never blocks the others', () async {
    final harness = CollectionHarness();
    addTearDown(harness.database.close);
    final store = DelistedStore();
    final steam = ScriptedSteam(const [], wishlistItems: const [SteamWishlistItem(appId: 'gone', priority: 1), SteamWishlistItem(appId: '413150', priority: 2)]);
    final sync = SyncSteamWishlist(steam, store, harness.collection, AddWish(DriftWishGateway(harness.database)), DriftSteamWishlistMemory(harness.database));
    expect(await sync('765'), 1);
    store.lookups.clear();
    expect(await sync('765'), 0);
    expect(store.lookups, isEmpty);
  });
}

class DelistedStore extends NamedStore {
  @override
  Future<SteamDlc?> dlc(String appId) async {
    if (appId != 'gone') {
      return super.dlc(appId);
    }
    lookups.add(appId);
    return null;
  }
}
