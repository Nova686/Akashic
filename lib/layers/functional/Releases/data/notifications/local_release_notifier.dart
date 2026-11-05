import 'package:akashic/layers/functional/Releases/domain/entities/upcoming_release.dart';
import 'package:akashic/layers/functional/Releases/domain/gateways/release_notifier.dart';
import 'package:akashic/layers/technical/Localization/app_localizations.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';

class LocalReleaseNotifier implements ReleaseNotifier {
  LocalReleaseNotifier(this._localizations, {FlutterLocalNotificationsPlugin? plugin}) : _plugin = plugin ?? FlutterLocalNotificationsPlugin();

  static const String _channelId = 'upcoming-releases';
  static const int detailedAnnouncements = 3;

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
  Future<void> announceWishedOut(List<UpcomingRelease> releases) async {
    await _initialize();
    final localizations = await _localizations();
    for (final release in releases) {
      await _plugin.show(
        id: '${release.key}|out'.codeUnits.fold(31, (hash, unit) => (hash * 31 + unit) & 0x7fffffff),
        title: localizations.wishedReleaseOutTitle(release.title),
        body: localizations.wishedReleaseOutBody(release.subject),
        notificationDetails: _details(localizations),
      );
    }
  }

  NotificationDetails _details(AppLocalizations localizations) => NotificationDetails(
        android: AndroidNotificationDetails(
          _channelId,
          localizations.releaseAlertsChannelName,
          channelDescription: localizations.releaseAlertsChannelDescription,
          importance: Importance.defaultImportance,
        ),
      );

  @override
  Future<void> announce(List<UpcomingRelease> releases) async {
    await _initialize();
    final localizations = await _localizations();
    final details = NotificationDetails(
      android: AndroidNotificationDetails(
        _channelId,
        localizations.releaseAlertsChannelName,
        channelDescription: localizations.releaseAlertsChannelDescription,
        importance: Importance.defaultImportance,
      ),
    );
    if (releases.length > detailedAnnouncements) {
      await _plugin.show(
        id: _channelId.hashCode & 0x7fffffff,
        title: localizations.releaseAlertSummaryTitle(releases.length),
        body: releases.map((release) => release.title).join(' · '),
        notificationDetails: details,
      );
      return;
    }
    for (final release in releases) {
      await _plugin.show(
        id: release.key.codeUnits.fold(31, (hash, unit) => (hash * 31 + unit) & 0x7fffffff),
        title: localizations.releaseAlertTitle(release.title),
        body: localizations.releaseAlertBody(release.subject, DateFormat.yMMMMd(localizations.localeName).format(release.releaseDate)),
        notificationDetails: details,
      );
    }
  }
}
