import 'package:akashic/layers/functional/Releases/domain/entities/calendar_sync.dart';

abstract interface class CalendarWriter {
  Future<bool> requestAccess();
  Future<List<DeviceCalendarChoice>> writableCalendars();
  Future<String> createCalendar(String name);
  Future<String> upsert(String calendarId, String? eventId, CalendarEventDraft draft);
  Future<void> remove(String eventId);
}

abstract interface class CalendarSyncStore {
  Stream<CalendarSyncSettings> watchSettings();
  Future<void> saveSettings(CalendarSyncSettings settings);
  Future<Map<String, String>> sentEvents();
  Future<void> saveSentEvents(Map<String, String> eventIdsByKey);
}
