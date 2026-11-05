import 'package:akashic/layers/functional/SealedPrices/domain/entities/price_alert.dart';
import 'package:akashic/layers/functional/SealedPrices/domain/gateways/price_alert_store.dart';
import 'package:akashic/layers/technical/Localization/app_localizations.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';

class LocalPriceAlertNotifier implements PriceAlertNotifier {
  LocalPriceAlertNotifier(this._localizations, {FlutterLocalNotificationsPlugin? plugin}) : _plugin = plugin ?? FlutterLocalNotificationsPlugin();

  static const String _channelId = 'price-alerts';

  final Future<AppLocalizations> Function() _localizations;
  final FlutterLocalNotificationsPlugin _plugin;
  bool _isInitialized = false;

  @override
  Future<void> crossed(String title, int cents, PriceAlert alert) async {
    if (!_isInitialized) {
      await _plugin.initialize(settings: const InitializationSettings(android: AndroidInitializationSettings('@drawable/ic_stat_akashic')));
      _isInitialized = true;
    }
    final l10n = await _localizations();
    final euros = NumberFormat.currency(locale: l10n.localeName, symbol: '€');
    await _plugin.show(
      id: 'price|${alert.itemId}'.codeUnits.fold(23, (hash, unit) => (hash * 31 + unit) & 0x7fffffff),
      title: alert.isAbove ? l10n.priceAlertAboveTitle(title) : l10n.priceAlertBelowTitle(title),
      body: l10n.priceAlertBody(euros.format(cents / 100), euros.format(alert.thresholdCents / 100)),
      notificationDetails: NotificationDetails(android: AndroidNotificationDetails(_channelId, l10n.priceAlertsChannelName, channelDescription: l10n.priceAlertsChannelDescription)),
    );
  }
}
