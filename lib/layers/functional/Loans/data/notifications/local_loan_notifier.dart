import 'package:akashic/layers/functional/Collection/domain/use_cases/resolve_display_title.dart';
import 'package:akashic/layers/functional/Loans/domain/entities/loan.dart';
import 'package:akashic/layers/functional/Loans/domain/use_cases/remind_overdue_loans.dart';
import 'package:akashic/layers/functional/Settings/domain/entities/preferred_languages.dart';
import 'package:akashic/layers/technical/Localization/app_localizations.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LocalLoanNotifier implements LoanNotifier {
  LocalLoanNotifier(this._localizations, {FlutterLocalNotificationsPlugin? plugin}) : _plugin = plugin ?? FlutterLocalNotificationsPlugin();

  static const String _channelId = 'loan-reminders';

  final Future<AppLocalizations> Function() _localizations;
  final FlutterLocalNotificationsPlugin _plugin;
  bool _isInitialized = false;

  Future<void> _initialize() async {
    if (_isInitialized) {
      return;
    }
    await _plugin.initialize(settings: const InitializationSettings(android: AndroidInitializationSettings('@drawable/ic_stat_akashic')));
    _isInitialized = true;
  }

  @override
  Future<bool> requestPermission() async {
    await _initialize();
    final android = _plugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
    return await android?.requestNotificationsPermission() ?? true;
  }

  @override
  Future<void> remind(List<Loan> overdueLoans) async {
    await _initialize();
    final localizations = await _localizations();
    final details = NotificationDetails(
      android: AndroidNotificationDetails(
        _channelId,
        localizations.loanRemindersChannelName,
        channelDescription: localizations.loanRemindersChannelDescription,
        importance: Importance.defaultImportance,
      ),
    );
    for (final loan in overdueLoans) {
      final title = resolveDisplayTitle(loan.itemTitles, PreferredLanguages.defaults) ?? localizations.untitled;
      await _plugin.show(
        id: loanKeyOf(loan).codeUnits.fold(29, (hash, unit) => (hash * 31 + unit) & 0x7fffffff),
        title: localizations.loanReminderTitle(title),
        body: localizations.loanReminderBody(loan.borrower, DateTime.now().difference(loan.since).inDays),
        notificationDetails: details,
        payload: loan.itemId,
      );
    }
  }
}
