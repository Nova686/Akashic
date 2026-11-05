import 'package:akashic/layers/functional/Releases/domain/entities/calendar_sync.dart';
import 'package:akashic/layers/functional/Releases/domain/entities/upcoming_release.dart';
import 'package:akashic/layers/functional/Releases/domain/gateways/calendar_writer.dart';
import 'package:akashic/layers/functional/Releases/domain/gateways/release_store.dart';

typedef DescribeReleaseEvent = CalendarEventDraft Function(UpcomingRelease release, {required bool remindsTheEveBefore});

class SyncReleaseCalendar {
  SyncReleaseCalendar(this._releases, this._store, this._writer, this._describer, {DateTime Function()? now}) : _now = now ?? DateTime.now;

  final ReleaseStore _releases;
  final CalendarSyncStore _store;
  final CalendarWriter _writer;
  final Future<DescribeReleaseEvent> Function() _describer;
  final DateTime Function() _now;

  Future<List<UpcomingRelease>> wanted(CalendarSyncSettings settings) async {
    final today = _now();
    final outlook = await _releases.cachedOutlook();
    return [
      for (final release in outlook?.releases ?? const <UpcomingRelease>[])
        if (settings.sends(release) && release.datePrecision == ReleaseDatePrecision.day && !release.releaseDate.isBefore(DateTime(today.year, today.month, today.day))) release,
    ]..sort((first, second) => first.releaseDate.compareTo(second.releaseDate));
  }

  Future<int> call() async {
    final settings = await _store.watchSettings().first;
    final sent = await _store.sentEvents();
    final calendarId = settings.calendarId;
    if (!settings.isEnabled || calendarId == null) {
      if (sent.isNotEmpty) {
        for (final eventId in sent.values) {
          await _removeQuietly(eventId);
        }
        await _store.saveSentEvents(const {});
      }
      return 0;
    }
    final releases = await wanted(settings);
    final describe = await _describer();
    final kept = <String, String>{};
    for (final release in releases) {
      final key = releaseEventKey(release);
      final draft = describe(release, remindsTheEveBefore: settings.remindsTheEveBefore);
      kept[key] = await _writer.upsert(calendarId, sent[key], draft);
    }
    for (final MapEntry(key: key, value: eventId) in sent.entries) {
      if (!kept.containsKey(key)) {
        await _removeQuietly(eventId);
      }
    }
    await _store.saveSentEvents(kept);
    return kept.length;
  }

  Future<void> _removeQuietly(String eventId) async {
    try {
      await _writer.remove(eventId);
    } on Exception {
      return;
    }
  }
}
