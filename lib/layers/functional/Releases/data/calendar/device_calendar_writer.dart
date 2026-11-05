import 'package:akashic/layers/functional/Releases/domain/entities/calendar_sync.dart';
import 'package:akashic/layers/functional/Releases/domain/gateways/calendar_writer.dart';
import 'package:device_calendar_plus/device_calendar_plus.dart';

class DeviceCalendarWriter implements CalendarWriter {
  DeviceCalendarWriter({DeviceCalendar? calendar}) : _calendar = calendar ?? DeviceCalendar.instance;

  static const Duration eveningBefore = Duration(hours: 6);
  static const String calendarColor = '#B7A6FF';

  final DeviceCalendar _calendar;

  @override
  Future<bool> requestAccess() async => await _calendar.requestPermissions() == CalendarPermissionStatus.granted;

  @override
  Future<List<DeviceCalendarChoice>> writableCalendars() async => [
        for (final calendar in await _calendar.listCalendars())
          if (!calendar.readOnly) DeviceCalendarChoice(id: calendar.id, name: calendar.name),
      ];

  @override
  Future<String> createCalendar(String name) => _calendar.createCalendar(name: name, colorHex: calendarColor);

  @override
  Future<String> upsert(String calendarId, String? eventId, CalendarEventDraft draft) async {
    final start = DateTime(draft.day.year, draft.day.month, draft.day.day);
    final end = start.add(const Duration(days: 1));
    final reminders = draft.remindsTheEveBefore ? const [eveningBefore] : const <Duration>[];
    if (eventId != null) {
      try {
        await _calendar.updateEvent(instanceId: eventId, title: draft.title, startDate: start, endDate: end, isAllDay: true, description: Patch.set(draft.description), reminders: Patch.set(reminders));
        return eventId;
      } on DeviceCalendarException catch (error) {
        if (error.errorCode != DeviceCalendarError.notFound) {
          rethrow;
        }
      }
    }
    return _calendar.createEvent(calendarId: calendarId, title: draft.title, startDate: start, endDate: end, isAllDay: true, description: draft.description, reminders: reminders);
  }

  @override
  Future<void> remove(String eventId) => _calendar.deleteEvent(instanceId: eventId);
}
