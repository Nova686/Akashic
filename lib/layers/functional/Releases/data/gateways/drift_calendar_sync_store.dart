import 'dart:convert';

import 'package:akashic/layers/functional/Releases/domain/entities/calendar_sync.dart';
import 'package:akashic/layers/functional/Releases/domain/entities/upcoming_release.dart';
import 'package:akashic/layers/functional/Releases/domain/gateways/calendar_writer.dart';
import 'package:akashic/layers/technical/LocalDatabase/akashic_database.dart';

class DriftCalendarSyncStore implements CalendarSyncStore {
  DriftCalendarSyncStore(this._database);

  static const String _settingsKey = 'calendarSyncSettings';
  static const String _eventsKey = 'calendarSyncEvents';

  final AkashicDatabase _database;

  Stream<String?> _watch(String key) => (_database.select(_database.preferences)..where((table) => table.key.equals(key))).watchSingleOrNull().map((row) => row?.value);

  Future<void> _write(String key, String value) => _database.into(_database.preferences).insertOnConflictUpdate(PreferencesCompanion.insert(key: key, value: value));

  @override
  Stream<CalendarSyncSettings> watchSettings() => _watch(_settingsKey).map((value) {
        if (value == null) {
          return const CalendarSyncSettings();
        }
        final fields = jsonDecode(value) as Map<String, Object?>;
        return CalendarSyncSettings(
          isEnabled: fields['isEnabled'] == true,
          calendarId: fields['calendarId'] as String?,
          kinds: {for (final name in (fields['kinds'] as List? ?? const [])) ?ReleaseKind.values.asNameMap()[name]},
          mutedSubjects: {for (final subject in (fields['mutedSubjects'] as List? ?? const [])) subject as String},
          remindsTheEveBefore: fields['remindsTheEveBefore'] != false,
        );
      });

  @override
  Future<void> saveSettings(CalendarSyncSettings settings) => _write(
        _settingsKey,
        jsonEncode({
          'isEnabled': settings.isEnabled,
          'calendarId': settings.calendarId,
          'kinds': [for (final kind in settings.kinds) kind.name],
          'mutedSubjects': settings.mutedSubjects.toList(),
          'remindsTheEveBefore': settings.remindsTheEveBefore,
        }),
      );

  @override
  Future<Map<String, String>> sentEvents() async {
    final value = await _watch(_eventsKey).first;
    return value == null ? {} : Map<String, String>.from(jsonDecode(value) as Map);
  }

  @override
  Future<void> saveSentEvents(Map<String, String> eventIdsByKey) => _write(_eventsKey, jsonEncode(eventIdsByKey));
}
