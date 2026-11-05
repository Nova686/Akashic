import 'package:akashic/layers/functional/Releases/domain/entities/calendar_sync.dart';
import 'package:akashic/layers/functional/Releases/domain/entities/upcoming_release.dart';
import 'package:akashic/layers/functional/Releases/presentation/cubit/calendar_sync_cubit.dart';
import 'package:akashic/layers/technical/Localization/app_localizations.dart';
import 'package:akashic/layers/technical/Theme/akashic_colors.dart';
import 'package:akashic/layers/technical/Theme/akashic_typography.dart';
import 'package:akashic/layers/technical/Theme/safe_scroll_padding.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

String releaseKindLabel(ReleaseKind kind, AppLocalizations l10n) => switch (kind) {
      ReleaseKind.nextVolume => l10n.calendarKindVolumes,
      ReleaseKind.album => l10n.calendarKindAlbums,
      ReleaseKind.cardSet => l10n.calendarKindCardSets,
    };

IconData releaseKindIcon(ReleaseKind kind) => switch (kind) {
      ReleaseKind.nextVolume => Icons.menu_book_outlined,
      ReleaseKind.album => Icons.album_outlined,
      ReleaseKind.cardSet => Icons.style_outlined,
    };

CalendarEventDraft describeReleaseEvent(UpcomingRelease release, AppLocalizations l10n, {required bool remindsTheEveBefore}) => CalendarEventDraft(
      title: l10n.calendarEventTitle(release.title),
      day: release.releaseDate,
      description: [
        release.subject,
        if (release.isEstimated) l10n.calendarEventEstimated,
        l10n.calendarEventFooter,
      ].join('\n'),
      remindsTheEveBefore: remindsTheEveBefore,
    );

class CalendarSyncView extends StatefulWidget {
  const CalendarSyncView({super.key});

  @override
  State<CalendarSyncView> createState() => _CalendarSyncViewState();
}

class _CalendarSyncViewState extends State<CalendarSyncView> {
  @override
  void initState() {
    super.initState();
    context.read<CalendarSyncCubit>().loadCalendars();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final cubit = context.read<CalendarSyncCubit>();
    return BlocConsumer<CalendarSyncCubit, CalendarSyncState>(
      listenWhen: (previous, current) => current.notice != null && previous.notice != current.notice,
      listener: (context, state) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(state.notice == CalendarSyncNotice.accessDenied ? l10n.calendarAccessDenied : l10n.calendarSyncFailed),
      )),
      builder: (context, state) {
        final settings = state.settings;
        final isEnabled = settings.isEnabled;
        final next = state.upcoming.firstOrNull;
        return Scaffold(
          appBar: AppBar(title: Text(l10n.calendarSync, style: AkashicTypography.displayTitle(size: 24))),
          body: ListView(
            padding: safeListPadding(context),
            children: [
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                value: isEnabled,
                onChanged: state.isWorking ? null : cubit.setEnabled,
                title: Text(l10n.calendarSyncSwitch, style: AkashicTypography.body(size: 15, weight: FontWeight.w800)),
                subtitle: Text(l10n.calendarSyncSwitchHelp),
              ),
              if (state.isWorking) const LinearProgressIndicator(),
              AnimatedOpacity(
                opacity: isEnabled ? 1 : 0.45,
                duration: MediaQuery.disableAnimationsOf(context) ? Duration.zero : const Duration(milliseconds: 180),
                child: IgnorePointer(
                  ignoring: !isEnabled,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 10),
                      _Heading(l10n.calendarTarget),
                      DropdownButtonFormField<String>(
                        initialValue: state.calendars.any((calendar) => calendar.id == settings.calendarId) ? settings.calendarId : null,
                        hint: Text(l10n.calendarDefaultName),
                        items: [for (final calendar in state.calendars) DropdownMenuItem(value: calendar.id, child: Text(calendar.name))],
                        onChanged: (calendarId) => calendarId == null ? null : cubit.chooseCalendar(calendarId),
                      ),
                      const SizedBox(height: 14),
                      _Heading(l10n.calendarKinds),
                      for (final kind in ReleaseKind.values)
                        SwitchListTile(
                          contentPadding: EdgeInsets.zero,
                          secondary: Icon(releaseKindIcon(kind), color: AkashicColors.lavender),
                          value: settings.kinds.contains(kind),
                          onChanged: (_) => cubit.toggleKind(kind),
                          title: Text(releaseKindLabel(kind, l10n), style: AkashicTypography.body(weight: FontWeight.w700)),
                        ),
                      if (state.subjects.isNotEmpty) ...[
                        const SizedBox(height: 14),
                        _Heading(l10n.calendarSubjects),
                        for (final (subject, kind) in state.subjects)
                          SwitchListTile(
                            contentPadding: EdgeInsets.zero,
                            value: !settings.mutedSubjects.contains(subject) && settings.kinds.contains(kind),
                            onChanged: settings.kinds.contains(kind) ? (_) => cubit.toggleSubject(subject) : null,
                            title: Text(subject, maxLines: 1, overflow: TextOverflow.ellipsis, style: AkashicTypography.body(weight: FontWeight.w700)),
                            subtitle: Text(releaseKindLabel(kind, l10n)),
                          ),
                      ],
                      const SizedBox(height: 14),
                      _Heading(l10n.calendarEventSettings),
                      SwitchListTile(
                        contentPadding: EdgeInsets.zero,
                        value: settings.remindsTheEveBefore,
                        onChanged: cubit.setReminder,
                        title: Text(l10n.calendarReminder, style: AkashicTypography.body(weight: FontWeight.w700)),
                      ),
                      Text(l10n.calendarRemovedWhenAdded, style: AkashicTypography.body(size: 12).copyWith(color: AkashicColors.textSoft)),
                      if (next != null) ...[
                        const SizedBox(height: 16),
                        _Heading(l10n.calendarPreview),
                        _EventPreview(release: next, draft: describeReleaseEvent(next, l10n, remindsTheEveBefore: settings.remindsTheEveBefore)),
                        const SizedBox(height: 14),
                        _Heading(l10n.calendarNextSent),
                        for (final release in state.upcoming.take(5))
                          ListTile(
                            contentPadding: EdgeInsets.zero,
                            leading: const Icon(Icons.event_outlined, color: AkashicColors.teal),
                            title: Text(release.title, maxLines: 2, overflow: TextOverflow.ellipsis, style: AkashicTypography.body(size: 14, weight: FontWeight.w700)),
                            subtitle: Text(DateFormat.yMMMd(l10n.localeName).format(release.releaseDate)),
                          ),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _Heading extends StatelessWidget {
  const _Heading(this.text);

  final String text;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 4),
        child: Text(text.toUpperCase(), style: AkashicTypography.body(size: 11, weight: FontWeight.w800).copyWith(color: AkashicColors.textSoft, letterSpacing: 1.1)),
      );
}

class _EventPreview extends StatelessWidget {
  const _EventPreview({required this.release, required this.draft});

  final UpcomingRelease release;
  final CalendarEventDraft draft;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AkashicColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border(left: const BorderSide(color: AkashicColors.lavender, width: 5), top: BorderSide(color: AkashicColors.line), right: BorderSide(color: AkashicColors.line), bottom: BorderSide(color: AkashicColors.line)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(draft.title, style: AkashicTypography.displayTitle(size: 20)),
          const SizedBox(height: 6),
          Row(children: [const Icon(Icons.calendar_today, size: 16), const SizedBox(width: 8), Expanded(child: Text(l10n.calendarAllDay(toBeginningOfSentenceCase(DateFormat.yMMMMEEEEd(l10n.localeName).format(draft.day)))))]),
          if (draft.remindsTheEveBefore) Row(children: [const Icon(Icons.notifications_none, size: 16), const SizedBox(width: 8), Text(l10n.calendarReminder)]),
          const SizedBox(height: 4),
          Text(draft.description, style: AkashicTypography.body(size: 12).copyWith(color: AkashicColors.textSoft)),
        ],
      ),
    );
  }
}
