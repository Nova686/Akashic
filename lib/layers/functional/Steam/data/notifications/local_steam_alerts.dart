import 'package:akashic/layers/functional/Steam/domain/entities/steam_game_stats.dart';
import 'package:akashic/layers/functional/Steam/domain/gateways/steam_alerts.dart';
import 'package:akashic/layers/technical/Localization/app_localizations.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';

class LocalSteamAlerts implements SteamAlerts {
  LocalSteamAlerts(this._localizations, {FlutterLocalNotificationsPlugin? plugin}) : _plugin = plugin ?? FlutterLocalNotificationsPlugin();

  static const String _channelId = 'steam-alerts';

  final Future<AppLocalizations> Function() _localizations;
  final FlutterLocalNotificationsPlugin _plugin;
  bool _isInitialized = false;

  Future<void> _show(String key, String Function(AppLocalizations l10n) title, String Function(AppLocalizations l10n) body) async {
    if (!_isInitialized) {
      await _plugin.initialize(settings: const InitializationSettings(android: AndroidInitializationSettings('@drawable/ic_stat_akashic')));
      _isInitialized = true;
    }
    final l10n = await _localizations();
    await _plugin.show(
      id: key.codeUnits.fold(17, (hash, unit) => (hash * 31 + unit) & 0x7fffffff),
      title: title(l10n),
      body: body(l10n),
      notificationDetails: NotificationDetails(
        android: AndroidNotificationDetails(_channelId, l10n.steamAlertsChannelName, channelDescription: l10n.steamAlertsChannelDescription),
      ),
    );
  }

  @override
  Future<void> wishOnSale(String title, StorePrice price) => _show(
        'sale|$title|${price.discountPercent}',
        (l10n) => l10n.steamWishOnSaleTitle(title),
        (l10n) => l10n.steamWishOnSaleBody(price.discountPercent, NumberFormat.simpleCurrency(locale: l10n.localeName, name: price.currency).format(price.cents / 100)),
      );

  @override
  Future<void> wishUnderMaximum(String title, StorePrice price, int maxPriceCents) => _show(
        'maximum|$title|${price.cents}',
        (l10n) => l10n.wishUnderMaximumTitle(title),
        (l10n) {
          final money = NumberFormat.simpleCurrency(locale: l10n.localeName, name: price.currency);
          return l10n.wishUnderMaximumBody(money.format(price.cents / 100), money.format(maxPriceCents / 100));
        },
      );

  @override
  Future<void> wishReleased(String title) => _show('released|$title', (l10n) => l10n.steamWishReleasedTitle(title), (l10n) => l10n.steamWishReleasedBody);

  @override
  Future<void> newDlcs(String gameTitle, List<String> dlcNames) => _show(
        'dlc|$gameTitle|${dlcNames.join('|')}',
        (l10n) => l10n.steamNewDlcTitle(gameTitle),
        (l10n) => dlcNames.isEmpty ? l10n.steamNewDlcBodyUnnamed : dlcNames.join(' · '),
      );
}
