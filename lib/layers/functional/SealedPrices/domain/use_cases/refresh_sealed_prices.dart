import 'package:akashic/layers/functional/Catalog/domain/gateways/category_gateway.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/card_kind.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/market_value.dart';
import 'package:akashic/layers/functional/Collection/domain/gateways/collection_gateway.dart';
import 'package:akashic/layers/functional/Collection/domain/use_cases/sealed_product_library.dart';
import 'package:akashic/layers/functional/Lookup/domain/entities/card_game.dart';
import 'package:akashic/layers/functional/Collection/domain/use_cases/resolve_display_title.dart';
import 'package:akashic/layers/functional/SealedPrices/domain/gateways/price_alert_store.dart';
import 'package:akashic/layers/functional/SealedPrices/domain/gateways/price_guide.dart';
import 'package:akashic/layers/functional/Settings/domain/entities/preferred_languages.dart';
import 'package:akashic/layers/functional/SealedPrices/domain/gateways/sealed_price_store.dart';

class RefreshSealedPrices {
  RefreshSealedPrices(this._collection, this._categories, this._guide, this._store, {this._alerts, this._alertNotifier, DateTime Function()? now}) : _now = now ?? DateTime.now;

  static const Duration automaticInterval = Duration(hours: 20);

  final CollectionGateway _collection;
  final CategoryGateway _categories;
  final PriceGuide _guide;
  final SealedPriceStore _store;
  final PriceAlertStore? _alerts;
  final PriceAlertNotifier? _alertNotifier;
  final DateTime Function() _now;

  Future<Map<CardGame, Map<String, List<String>>>> _ownedProducts() async {
    final itemsByProductByGame = <CardGame, Map<String, List<String>>>{};
    final gameByCategory = <String, CardGame?>{};
    for (final item in await _collection.allItems()) {
      final productId = item.externalWorkId;
      if (item.cardKind != CardKind.sealed || item.sourceKey != sealedSourceKey || productId == null) {
        continue;
      }
      if (!gameByCategory.containsKey(item.categoryId)) {
        final category = await _categories.findById(item.categoryId);
        gameByCategory[item.categoryId] = category == null ? null : cardGameNamed(category.name);
      }
      final game = gameByCategory[item.categoryId];
      if (game == null || !_guide.covers(game)) {
        continue;
      }
      itemsByProductByGame.putIfAbsent(game, () => {}).putIfAbsent(productId, () => []).add(item.id);
    }
    return itemsByProductByGame;
  }

  Future<bool> hasSealedProducts() async => (await _ownedProducts()).isNotEmpty;

  Future<int> downloadSize() async {
    var total = 0;
    for (final game in (await _ownedProducts()).keys) {
      total += await _guide.downloadSizeOf(game) ?? 0;
    }
    return total;
  }

  Future<int> call() async {
    final pricedAt = _now();
    var priced = 0;
    for (final MapEntry(key: game, value: itemsByProduct) in (await _ownedProducts()).entries) {
      final prices = await _guide.pricesOf(game, itemsByProduct.keys.toSet(), pricedAt: pricedAt);
      await _store.savePrices(prices);
      await _collection.saveMarketValues({
        for (final price in prices)
          if (price.referenceCents case final cents?)
            for (final itemId in itemsByProduct[price.productId] ?? const <String>[]) itemId: MarketValue(cents: cents, currency: 'EUR', valuedAt: pricedAt),
      });
      priced += prices.length;
      await _checkAlerts({
        for (final price in prices)
          if (price.referenceCents case final cents?)
            for (final itemId in itemsByProduct[price.productId] ?? const <String>[]) itemId: cents,
      }, pricedAt);
    }
    return priced;
  }

  Future<void> _checkAlerts(Map<String, int> centsByItem, DateTime now) async {
    final alerts = _alerts;
    final notifier = _alertNotifier;
    if (alerts == null || notifier == null || centsByItem.isEmpty) {
      return;
    }
    for (final alert in await alerts.all()) {
      final cents = centsByItem[alert.itemId];
      if (cents == null) {
        continue;
      }
      if (alert.isCrossedBy(cents) && alert.notifiedAt == null) {
        final item = await _collection.watchItem(alert.itemId).first;
        await notifier.crossed(item == null ? '' : (resolveDisplayTitle(item.titles, PreferredLanguages.defaults) ?? ''), cents, alert);
        await alerts.save(alert.notified(now));
      } else if (!alert.isCrossedBy(cents) && alert.notifiedAt != null) {
        await alerts.save(alert.notified(null));
      }
    }
  }

  Future<int> refreshIfStale() async {
    final lastPricedAt = await _store.lastPricedAt();
    if (lastPricedAt != null && _now().difference(lastPricedAt) < automaticInterval) {
      return 0;
    }
    return call();
  }
}
