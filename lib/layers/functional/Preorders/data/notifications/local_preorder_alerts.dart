import 'package:akashic/layers/functional/Preorders/domain/gateways/preorder_alerts.dart';
import 'package:akashic/layers/technical/Localization/app_localizations.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LocalPreorderAlerts implements PreorderAlerts {
  LocalPreorderAlerts(this._localizations, {FlutterLocalNotificationsPlugin? plugin}) : _plugin = plugin ?? FlutterLocalNotificationsPlugin();

  static const String _channelId = 'preorder-arrivals';

  final Future<AppLocalizations> Function() _localizations;
  final FlutterLocalNotificationsPlugin _plugin;

  @override
  Future<void> arrivesToday(List<String> titles) async {
    await _plugin.initialize(settings: const InitializationSettings(android: AndroidInitializationSettings('@drawable/ic_stat_akashic')));
    final l10n = await _localizations();
    await _plugin.show(
      id: titles.join('|').codeUnits.fold(41, (hash, unit) => (hash * 31 + unit) & 0x7fffffff),
      title: titles.length == 1 ? l10n.preorderArrivesTodayTitle(titles.single) : l10n.preordersArriveTodayTitle(titles.length),
      body: l10n.preorderArrivesTodayBody,
      notificationDetails: NotificationDetails(android: AndroidNotificationDetails(_channelId, l10n.preorderChannelName, channelDescription: l10n.preorderChannelDescription)),
    );
  }
}
