import 'package:akashic/layers/functional/Catalog/domain/entities/category_type.dart';
import 'package:akashic/layers/functional/Collection/domain/gateways/collection_gateway.dart';
import 'package:akashic/layers/functional/Lookup/domain/entities/source_unavailable.dart';
import 'package:akashic/layers/functional/Steam/domain/gateways/steam_player_api.dart';
import 'package:akashic/layers/functional/Steam/domain/gateways/steam_store_api.dart';
import 'package:akashic/layers/functional/Steam/domain/gateways/steam_wishlist_memory.dart';
import 'package:akashic/layers/functional/Wishes/domain/entities/wish.dart';
import 'package:akashic/layers/functional/Wishes/domain/entities/wish_key.dart';
import 'package:akashic/layers/functional/Wishes/domain/use_cases/add_wish.dart';

class SyncSteamWishlist {
  SyncSteamWishlist(this._player, this._store, this._collection, this._addWish, this._memory);

  static const String steamSourceKey = 'steam';
  static const int storeLookupsPerRun = 40;

  final SteamPlayerApi _player;
  final SteamStoreApi _store;
  final CollectionGateway _collection;
  final AddWish _addWish;
  final SteamWishlistMemory _memory;

  Future<int> call(String steamId, {String? categoryId}) async {
    final imported = await _memory.importedAppIds();
    final pending = [for (final item in await _player.wishlist(steamId)) if (!imported.contains(item.appId)) item];
    final handled = <String>{};
    var added = 0;
    try {
      for (final item in pending.take(storeLookupsPerRun)) {
        if (await _collection.findByExternalWork(steamSourceKey, item.appId) != null) {
          handled.add(item.appId);
          continue;
        }
        final game = await _store.dlc(item.appId);
        if (game == null) {
          handled.add(item.appId);
          continue;
        }
        await _addWish(WishDraft(
          categoryType: CategoryType.videoGames,
          categoryId: categoryId,
          title: game.name,
          origin: WishOrigin.steamWishlist,
          key: WishKey(sourceKey: steamSourceKey, externalWorkId: item.appId),
          imageUrl: game.imageUrl,
        ));
        handled.add(item.appId);
        added++;
      }
    } on SourceUnavailable {
      if (handled.isEmpty) {
        rethrow;
      }
    } finally {
      if (handled.isNotEmpty) {
        await _memory.rememberImported({...imported, ...handled});
      }
    }
    return added;
  }
}
