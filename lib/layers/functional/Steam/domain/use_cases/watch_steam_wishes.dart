import 'package:akashic/layers/functional/Lookup/domain/entities/source_unavailable.dart';
import 'package:akashic/layers/functional/Steam/domain/entities/steam_wish_watch.dart';
import 'package:akashic/layers/functional/Steam/domain/gateways/steam_alerts.dart';
import 'package:akashic/layers/functional/Steam/domain/gateways/steam_player_api.dart';
import 'package:akashic/layers/functional/Steam/domain/gateways/steam_store_api.dart';
import 'package:akashic/layers/functional/Steam/domain/gateways/steam_watch_store.dart';
import 'package:akashic/layers/functional/Wishes/domain/gateways/wish_gateway.dart';

class WatchSteamWishes {
  WatchSteamWishes(this._player, this._store, this._wishes, this._watches, this._alerts, {DateTime Function()? now}) : _now = now ?? DateTime.now;

  static const String steamSourceKey = 'steam';
  static const int pricesPerRun = 200;
  static const int releaseChecksPerRun = 10;

  final SteamPlayerApi _player;
  final SteamStoreApi _store;
  final WishGateway _wishes;
  final SteamWatchStore _watches;
  final SteamAlerts _alerts;
  final DateTime Function() _now;

  Future<void> call() async {
    final wishes = [
      for (final wish in await _wishes.all())
        if (wish.key.sourceKey == steamSourceKey && wish.key.externalWorkId != null) wish,
    ].take(pricesPerRun).toList();
    if (wishes.isEmpty || !_player.isConfigured) {
      return;
    }
    final previous = await _watches.wishWatches();
    final prices = await _player.storePrices([for (final wish in wishes) wish.key.externalWorkId!]);
    final now = _now();
    var releaseChecks = releaseChecksPerRun;
    final updated = <SteamWishWatch>[];
    for (final wish in wishes) {
      final appId = wish.key.externalWorkId!;
      final before = previous[appId];
      final price = prices.containsKey(appId) ? prices[appId] : before?.price;
      var isComingSoon = before?.isComingSoon ?? false;
      if ((before == null || before.isComingSoon) && releaseChecks > 0) {
        releaseChecks--;
        try {
          if (await _store.dlc(appId) case final game?) {
            if (before != null && before.isComingSoon && !game.isComingSoon) {
              await _alerts.wishReleased(wish.title);
            }
            isComingSoon = game.isComingSoon;
          }
        } on SourceUnavailable {
          releaseChecks = 0;
        }
      }
      if (before != null && price != null && price.isDiscounted && price.discountPercent > (before.price?.discountPercent ?? 0)) {
        await _alerts.wishOnSale(wish.title, price);
      }
      if ((wish.maxPriceCents, price) case (final maximum?, final current?) when current.cents <= maximum && (before?.price == null || before!.price!.cents > maximum)) {
        await _alerts.wishUnderMaximum(wish.title, current, maximum);
      }
      updated.add(SteamWishWatch(appId: appId, price: price, isComingSoon: isComingSoon, checkedAt: now));
    }
    await _watches.saveWishWatches(updated);
  }
}
