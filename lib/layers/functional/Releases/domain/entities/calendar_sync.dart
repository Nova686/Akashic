import 'package:akashic/layers/functional/Releases/domain/entities/upcoming_release.dart';
import 'package:equatable/equatable.dart';

class CalendarSyncSettings extends Equatable {
  const CalendarSyncSettings({this.isEnabled = false, this.calendarId, this.kinds = const {ReleaseKind.nextVolume, ReleaseKind.album, ReleaseKind.cardSet}, this.mutedSubjects = const {}, this.remindsTheEveBefore = true});

  final bool isEnabled;
  final String? calendarId;
  final Set<ReleaseKind> kinds;
  final Set<String> mutedSubjects;
  final bool remindsTheEveBefore;

  bool sends(UpcomingRelease release) => isEnabled && kinds.contains(release.kind) && !mutedSubjects.contains(release.subject);

  CalendarSyncSettings copyWith({bool? isEnabled, String? calendarId, Set<ReleaseKind>? kinds, Set<String>? mutedSubjects, bool? remindsTheEveBefore}) => CalendarSyncSettings(
        isEnabled: isEnabled ?? this.isEnabled,
        calendarId: calendarId ?? this.calendarId,
        kinds: kinds ?? this.kinds,
        mutedSubjects: mutedSubjects ?? this.mutedSubjects,
        remindsTheEveBefore: remindsTheEveBefore ?? this.remindsTheEveBefore,
      );

  @override
  List<Object?> get props => [isEnabled, calendarId, kinds, mutedSubjects, remindsTheEveBefore];
}

class CalendarEventDraft extends Equatable {
  const CalendarEventDraft({required this.title, required this.day, required this.description, this.remindsTheEveBefore = true});

  final String title;
  final DateTime day;
  final String description;
  final bool remindsTheEveBefore;

  @override
  List<Object?> get props => [title, day, description, remindsTheEveBefore];
}

class DeviceCalendarChoice extends Equatable {
  const DeviceCalendarChoice({required this.id, required this.name});

  final String id;
  final String name;

  @override
  List<Object?> get props => [id, name];
}

String releaseEventKey(UpcomingRelease release) => '${release.sourceKey}|${release.externalId}';
