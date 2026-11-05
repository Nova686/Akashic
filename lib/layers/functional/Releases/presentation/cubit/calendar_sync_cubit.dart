import 'dart:async';

import 'package:akashic/layers/functional/Releases/domain/entities/calendar_sync.dart';
import 'package:akashic/layers/functional/Releases/domain/entities/upcoming_release.dart';
import 'package:akashic/layers/functional/Releases/domain/gateways/calendar_writer.dart';
import 'package:akashic/layers/functional/Releases/domain/gateways/release_store.dart';
import 'package:akashic/layers/functional/Releases/domain/use_cases/sync_release_calendar.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

enum CalendarSyncNotice { accessDenied, failed }

class CalendarSyncState extends Equatable {
  const CalendarSyncState({this.settings = const CalendarSyncSettings(), this.calendars = const [], this.subjects = const [], this.upcoming = const [], this.isWorking = false, this.notice});

  final CalendarSyncSettings settings;
  final List<DeviceCalendarChoice> calendars;
  final List<(String, ReleaseKind)> subjects;
  final List<UpcomingRelease> upcoming;
  final bool isWorking;
  final CalendarSyncNotice? notice;

  CalendarSyncState copyWith({CalendarSyncSettings? settings, List<DeviceCalendarChoice>? calendars, List<(String, ReleaseKind)>? subjects, List<UpcomingRelease>? upcoming, bool? isWorking, CalendarSyncNotice? notice}) =>
      CalendarSyncState(
        settings: settings ?? this.settings,
        calendars: calendars ?? this.calendars,
        subjects: subjects ?? this.subjects,
        upcoming: upcoming ?? this.upcoming,
        isWorking: isWorking ?? this.isWorking,
        notice: notice,
      );

  @override
  List<Object?> get props => [settings, calendars, subjects, upcoming, isWorking, notice];
}

class CalendarSyncCubit extends Cubit<CalendarSyncState> {
  CalendarSyncCubit(this._store, this._writer, this._releases, this._sync, {required this.newCalendarName}) : super(const CalendarSyncState());

  final CalendarSyncStore _store;
  final CalendarWriter _writer;
  final ReleaseStore _releases;
  final SyncReleaseCalendar _sync;
  final String newCalendarName;
  StreamSubscription<CalendarSyncSettings>? _subscription;

  Future<void> start() async {
    final outlook = await _releases.cachedOutlook();
    final subjects = <String, ReleaseKind>{for (final release in outlook?.releases ?? const <UpcomingRelease>[]) release.subject: release.kind};
    _subscription = _store.watchSettings().listen((settings) async {
      final upcoming = await _sync.wanted(settings.copyWith(isEnabled: true));
      if (!isClosed) {
        emit(state.copyWith(settings: settings, subjects: [for (final entry in subjects.entries) (entry.key, entry.value)], upcoming: upcoming));
      }
    });
  }

  Future<void> _apply(CalendarSyncSettings settings) async {
    emit(state.copyWith(isWorking: true));
    try {
      await _store.saveSettings(settings);
      await _sync();
      emit(state.copyWith(settings: settings, isWorking: false));
    } on Exception {
      emit(state.copyWith(isWorking: false, notice: CalendarSyncNotice.failed));
    }
  }

  Future<void> setEnabled(bool isEnabled) async {
    if (!isEnabled) {
      return _apply(state.settings.copyWith(isEnabled: false));
    }
    emit(state.copyWith(isWorking: true));
    try {
      if (!await _writer.requestAccess()) {
        emit(state.copyWith(isWorking: false, notice: CalendarSyncNotice.accessDenied));
        return;
      }
      final calendars = await _writer.writableCalendars();
      var calendarId = state.settings.calendarId;
      if (calendarId == null || !calendars.any((calendar) => calendar.id == calendarId)) {
        calendarId = calendars.where((calendar) => calendar.name == newCalendarName).firstOrNull?.id ?? await _writer.createCalendar(newCalendarName);
      }
      emit(state.copyWith(calendars: await _writer.writableCalendars()));
      await _apply(state.settings.copyWith(isEnabled: true, calendarId: calendarId));
    } on Exception {
      emit(state.copyWith(isWorking: false, notice: CalendarSyncNotice.failed));
    }
  }

  Future<void> chooseCalendar(String calendarId) => _apply(state.settings.copyWith(calendarId: calendarId));

  Future<void> toggleKind(ReleaseKind kind) => _apply(state.settings.copyWith(kinds: state.settings.kinds.contains(kind) ? ({...state.settings.kinds}..remove(kind)) : {...state.settings.kinds, kind}));

  Future<void> toggleSubject(String subject) =>
      _apply(state.settings.copyWith(mutedSubjects: state.settings.mutedSubjects.contains(subject) ? ({...state.settings.mutedSubjects}..remove(subject)) : {...state.settings.mutedSubjects, subject}));

  Future<void> setReminder(bool remindsTheEveBefore) => _apply(state.settings.copyWith(remindsTheEveBefore: remindsTheEveBefore));

  Future<void> loadCalendars() async {
    if (state.settings.isEnabled) {
      try {
        emit(state.copyWith(calendars: await _writer.writableCalendars()));
      } on Exception {
        return;
      }
    }
  }

  @override
  Future<void> close() async {
    await _subscription?.cancel();
    return super.close();
  }
}
