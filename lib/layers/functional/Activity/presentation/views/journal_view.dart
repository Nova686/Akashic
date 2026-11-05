import 'package:akashic/layers/functional/Activity/domain/entities/activity_event.dart';
import 'package:akashic/layers/functional/Stats/presentation/views/stats_view.dart';
import 'package:akashic/layers/technical/Localization/app_localizations.dart';
import 'package:akashic/layers/technical/Theme/akashic_colors.dart';
import 'package:akashic/layers/technical/Theme/akashic_empty_state.dart';
import 'package:akashic/layers/technical/Theme/akashic_typography.dart';
import 'package:akashic/layers/technical/Theme/safe_scroll_padding.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

enum JournalFilter { all, added, sales, loans, valuations, finished }

bool journalAccepts(JournalFilter filter, ActivityKind kind) => switch (filter) {
      JournalFilter.all => true,
      JournalFilter.added => kind == ActivityKind.added || kind == ActivityKind.received,
      JournalFilter.sales => kind == ActivityKind.sold,
      JournalFilter.loans => kind == ActivityKind.lent || kind == ActivityKind.returned,
      JournalFilter.valuations => kind == ActivityKind.valueRose || kind == ActivityKind.valueFell,
      JournalFilter.finished => kind == ActivityKind.finished || kind == ActivityKind.started,
    };

(IconData, Color) journalLook(ActivityKind kind) => switch (kind) {
      ActivityKind.added || ActivityKind.received => (Icons.add, AkashicColors.teal),
      ActivityKind.started => (Icons.play_arrow, AkashicColors.teal),
      ActivityKind.finished => (Icons.flag, AkashicColors.teal),
      ActivityKind.sold => (Icons.sell_outlined, AkashicColors.gold),
      ActivityKind.lent => (Icons.north_east, AkashicColors.lavender),
      ActivityKind.returned => (Icons.south_west, AkashicColors.lavender),
      ActivityKind.valueRose => (Icons.trending_up, AkashicColors.gold),
      ActivityKind.valueFell => (Icons.trending_down, AkashicColors.coral),
      ActivityKind.merged => (Icons.merge, AkashicColors.lavender),
    };

class JournalView extends StatefulWidget {
  const JournalView({required this.loadJournal, required this.onOpenItem, super.key});

  final Future<List<ActivityEvent>> Function() loadJournal;
  final ValueChanged<String> onOpenItem;

  @override
  State<JournalView> createState() => _JournalViewState();
}

class _JournalViewState extends State<JournalView> {
  late final Future<List<ActivityEvent>> _journal = widget.loadJournal();
  JournalFilter _filter = JournalFilter.all;

  String _filterLabel(JournalFilter filter, AppLocalizations l10n) => switch (filter) {
        JournalFilter.all => l10n.filterAll,
        JournalFilter.added => l10n.journalAdded,
        JournalFilter.sales => l10n.journalSales,
        JournalFilter.loans => l10n.journalLoans,
        JournalFilter.valuations => l10n.journalValues,
        JournalFilter.finished => l10n.journalFinished,
      };

  String _dayLabel(DateTime day, AppLocalizations l10n) {
    final today = DateUtils.dateOnly(DateTime.now());
    final difference = today.difference(day).inDays;
    return switch (difference) {
      0 => l10n.today,
      1 => l10n.yesterday,
      _ => toBeginningOfSentenceCase(DateFormat.yMMMMEEEEd(l10n.localeName).format(day)),
    };
  }

  String _describe(ActivityEvent event, AppLocalizations l10n) => switch (event.kind) {
        ActivityKind.added => l10n.journalEntryAdded,
        ActivityKind.received => l10n.journalEntryReceived,
        ActivityKind.started => l10n.journalEntryStarted,
        ActivityKind.finished => l10n.journalEntryFinished,
        ActivityKind.sold => l10n.journalEntrySold(formatEuros(l10n, event.amountCents ?? 0)),
        ActivityKind.lent => l10n.journalEntryLent(event.detail ?? ''),
        ActivityKind.returned => l10n.journalEntryReturned(event.detail ?? ''),
        ActivityKind.valueRose => l10n.journalEntryValueRose(formatEuros(l10n, (event.amountCents ?? 0).abs())),
        ActivityKind.valueFell => l10n.journalEntryValueFell(formatEuros(l10n, (event.amountCents ?? 0).abs())),
        ActivityKind.merged => l10n.journalEntryMerged,
      };

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.journal, style: AkashicTypography.displayTitle(size: 26))),
      body: FutureBuilder<List<ActivityEvent>>(
        future: _journal,
        builder: (context, snapshot) {
          final events = snapshot.data;
          if (events == null) {
            return const AkashicLoader();
          }
          final shown = [for (final event in events) if (journalAccepts(_filter, event.kind)) event];
          final byDay = <DateTime, List<ActivityEvent>>{};
          for (final event in shown) {
            byDay.putIfAbsent(DateUtils.dateOnly(event.at), () => []).add(event);
          }
          return ListView(
            padding: safeListPadding(context),
            children: [
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    for (final filter in JournalFilter.values)
                      Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: ChoiceChip(label: Text(_filterLabel(filter, l10n)), selected: _filter == filter, onSelected: (_) => setState(() => _filter = filter)),
                      ),
                  ],
                ),
              ),
              if (shown.isEmpty) Padding(padding: const EdgeInsets.only(top: 40), child: AkashicEmptyState(message: l10n.journalEmpty)),
              for (final MapEntry(key: day, value: dayEvents) in byDay.entries) ...[
                Padding(
                  padding: const EdgeInsets.only(top: 18, bottom: 4),
                  child: Text(_dayLabel(day, l10n).toUpperCase(), style: AkashicTypography.body(size: 11, weight: FontWeight.w800).copyWith(color: AkashicColors.textSoft, letterSpacing: 1.1)),
                ),
                for (final event in dayEvents) _JournalRow(event: event, description: _describe(event, l10n), onTap: event.itemId == null ? null : () => widget.onOpenItem(event.itemId!)),
              ],
            ],
          );
        },
      ),
    );
  }
}

class _JournalRow extends StatelessWidget {
  const _JournalRow({required this.event, required this.description, this.onTap});

  final ActivityEvent event;
  final String description;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final (icon, color) = journalLook(event.kind);
    final time = DateFormat.Hm(AppLocalizations.of(context).localeName).format(event.at);
    final hasTime = event.at.hour != 0 || event.at.minute != 0;
    return ListTile(
      contentPadding: EdgeInsets.zero,
      onTap: onTap,
      leading: CircleAvatar(backgroundColor: color.withValues(alpha: 0.18), foregroundColor: color, child: Icon(icon, size: 20)),
      title: Text(event.title, maxLines: 2, overflow: TextOverflow.ellipsis, style: AkashicTypography.body(size: 14, weight: FontWeight.w700)),
      subtitle: Text(description, style: AkashicTypography.body(size: 12).copyWith(color: color == AkashicColors.coral ? AkashicColors.coral : AkashicColors.textSoft)),
      trailing: hasTime ? Text(time, style: AkashicTypography.body(size: 12).copyWith(color: AkashicColors.textSoft)) : null,
    );
  }
}
