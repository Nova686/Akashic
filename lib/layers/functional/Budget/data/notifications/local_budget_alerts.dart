import 'package:akashic/layers/functional/Budget/domain/gateways/budget_store.dart';
import 'package:akashic/layers/technical/Localization/app_localizations.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';

class LocalBudgetAlerts implements BudgetAlerts {
  LocalBudgetAlerts(this._localizations, {FlutterLocalNotificationsPlugin? plugin}) : _plugin = plugin ?? FlutterLocalNotificationsPlugin();

  static const String _channelId = 'budget-alerts';
  static const int _notificationId = 4271;

  final Future<AppLocalizations> Function() _localizations;
  final FlutterLocalNotificationsPlugin _plugin;

  @override
  Future<void> nearCeiling(int remainingCents, int ceilingCents) async {
    await _plugin.initialize(settings: const InitializationSettings(android: AndroidInitializationSettings('@drawable/ic_stat_akashic')));
    final l10n = await _localizations();
    final money = NumberFormat.simpleCurrency(locale: l10n.localeName, name: 'EUR');
    await _plugin.show(
      id: _notificationId,
      title: l10n.budgetAlertTitle,
      body: remainingCents > 0 ? l10n.budgetAlertBody(money.format(remainingCents / 100), money.format(ceilingCents / 100)) : l10n.budgetOverBody(money.format(ceilingCents / 100)),
      notificationDetails: NotificationDetails(android: AndroidNotificationDetails(_channelId, l10n.budgetChannelName, channelDescription: l10n.budgetChannelDescription)),
    );
  }
}
