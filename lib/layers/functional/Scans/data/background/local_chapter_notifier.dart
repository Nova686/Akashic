import 'package:akashic/layers/functional/Scans/domain/entities/chapter_number.dart';
import 'package:akashic/layers/functional/Scans/domain/gateways/chapter_alerts.dart';
import 'package:akashic/layers/technical/Localization/app_localizations.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

int notificationIdFor(String seriesId) => seriesId.codeUnits.fold(17, (hash, unit) => (hash * 31 + unit) & 0x7fffffff);

class LocalChapterNotifier implements ChapterNotifier {
  LocalChapterNotifier(this._localizations, {FlutterLocalNotificationsPlugin? plugin}) : _plugin = plugin ?? FlutterLocalNotificationsPlugin();


  static const String _channelId = 'scan-chapters';

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
  Future<void> announce(List<ChapterNotice> notices) async {
    await _initialize();
    final localizations = await _localizations();
    final details = NotificationDetails(
      android: AndroidNotificationDetails(
        _channelId,
        localizations.scanAlertsChannelName,
        channelDescription: localizations.scanAlertsChannelDescription,
        importance: Importance.defaultImportance,
      ),
    );
    for (final notice in notices) {
      await _plugin.show(
        id: notificationIdFor(notice.seriesId),
        title: localizations.newChapterNotificationTitle(notice.seriesTitle.isEmpty ? localizations.untitled : notice.seriesTitle),
        body: localizations.newChaptersNotificationBody(notice.chapters.length, notice.chapters.map(formatChapter).join(', ')),
        notificationDetails: details,
        payload: notice.seriesId,
      );
    }
  }
}
