import 'package:akashic/layers/functional/Check/domain/entities/scan_session.dart';
import 'package:akashic/layers/functional/Check/presentation/widgets/scan_entry_cover.dart';
import 'package:akashic/layers/technical/Localization/app_localizations.dart';
import 'package:akashic/layers/technical/Theme/akashic_colors.dart';
import 'package:akashic/layers/technical/Theme/akashic_empty_state.dart';
import 'package:akashic/layers/technical/Theme/akashic_typography.dart';
import 'package:akashic/layers/technical/Theme/safe_scroll_padding.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

IconData scanSourceIcon(ScanSource source) => switch (source) {
      ScanSource.barcode => Icons.qr_code_scanner,
      ScanSource.cover => Icons.photo_camera_outlined,
      ScanSource.shelf => Icons.shelves,
    };

Color scanOutcomeColor(ScanOutcome outcome) => switch (outcome) {
      ScanOutcome.added => AkashicColors.teal,
      ScanOutcome.owned => AkashicColors.lavender,
      ScanOutcome.missed => AkashicColors.gold,
    };

String scanSessionCounts(ScanSession session, AppLocalizations l10n) => [
      if (session.countOf(ScanOutcome.added) case final added when added > 0) l10n.scanAddedCount(added),
      if (session.countOf(ScanOutcome.owned) case final owned when owned > 0) l10n.chainOwnedCount(owned),
      if (session.countOf(ScanOutcome.missed) case final missed when missed > 0) l10n.chainMissingCount(missed),
    ].join(' · ');

String scanSessionMoment(DateTime startedAt, AppLocalizations l10n) =>
    '${toBeginningOfSentenceCase(DateFormat.MMMMEEEEd(l10n.localeName).format(startedAt))} · ${DateFormat.Hm(l10n.localeName).format(startedAt)}';

class ScanHistoryView extends StatelessWidget {
  const ScanHistoryView({required this.sessions, required this.onOpenSession, super.key});

  final Stream<List<ScanSession>> sessions;
  final ValueChanged<String> onOpenSession;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.scanHistory, style: AkashicTypography.displayTitle(size: 26))),
      body: StreamBuilder<List<ScanSession>>(
        stream: sessions,
        builder: (context, snapshot) {
          final loaded = snapshot.data;
          if (loaded == null) {
            return const AkashicLoader();
          }
          if (loaded.isEmpty) {
            return Center(child: AkashicEmptyState(message: l10n.noScanSessions));
          }
          final byMonth = <DateTime, List<ScanSession>>{};
          for (final session in loaded) {
            byMonth.putIfAbsent(DateTime(session.startedAt.year, session.startedAt.month), () => []).add(session);
          }
          return ListView(
            padding: safeListPadding(context),
            children: [
              for (final MapEntry(key: month, value: monthSessions) in byMonth.entries) ...[
                Padding(
                  padding: const EdgeInsets.only(top: 14, bottom: 6),
                  child: Text(
                    DateFormat.yMMMM(l10n.localeName).format(month).toUpperCase(),
                    style: AkashicTypography.body(size: 11, weight: FontWeight.w800).copyWith(color: AkashicColors.textSoft, letterSpacing: 1.1),
                  ),
                ),
                for (final session in monthSessions) _SessionRow(session: session, onTap: () => onOpenSession(session.id)),
              ],
            ],
          );
        },
      ),
    );
  }
}

class _SessionRow extends StatelessWidget {
  const _SessionRow({required this.session, required this.onTap});

  final ScanSession session;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        onTap: onTap,
        leading: CircleAvatar(
          backgroundColor: AkashicColors.lavender.withValues(alpha: 0.18),
          foregroundColor: AkashicColors.lavender,
          child: Icon(scanSourceIcon(session.mode), semanticLabel: _sourceLabel(session.mode, l10n)),
        ),
        title: Text(scanSessionMoment(session.startedAt, l10n), style: AkashicTypography.body(size: 14, weight: FontWeight.w700)),
        subtitle: Text(scanSessionCounts(session, l10n), style: AkashicTypography.body(size: 12).copyWith(color: AkashicColors.textSoft)),
        trailing: const Icon(Icons.chevron_right),
      ),
    );
  }
}

String _sourceLabel(ScanSource source, AppLocalizations l10n) => switch (source) {
      ScanSource.barcode => l10n.chainSourceBarcode,
      ScanSource.cover => l10n.chainSourceCover,
      ScanSource.shelf => l10n.chainSourceShelf,
    };

class ScanSessionView extends StatelessWidget {
  const ScanSessionView({required this.session, required this.onOpenItem, super.key});

  final Stream<ScanSession?> session;
  final ValueChanged<String> onOpenItem;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return StreamBuilder<ScanSession?>(
      stream: session,
      builder: (context, snapshot) {
        final loaded = snapshot.data;
        return Scaffold(
          appBar: AppBar(title: Text(loaded == null ? l10n.scanHistory : scanSessionMoment(loaded.startedAt, l10n), style: AkashicTypography.displayTitle(size: 22))),
          body: switch ((snapshot.connectionState, loaded)) {
            (ConnectionState.waiting, null) => const AkashicLoader(),
            (_, null) => Center(child: AkashicEmptyState(message: l10n.noScanSessions)),
            (_, final found?) => ListView(
                padding: safeListPadding(context),
                children: [
                  Text(scanSessionCounts(found, l10n), style: AkashicTypography.body(size: 13).copyWith(color: AkashicColors.textSoft)),
                  for (final (outcome, label) in [
                    (ScanOutcome.added, l10n.scanGroupAdded),
                    (ScanOutcome.owned, l10n.scanGroupOwned),
                    (ScanOutcome.missed, l10n.scanGroupMissed),
                  ])
                    if (found.entriesWith(outcome) case final members when members.isNotEmpty) ...[
                      Padding(
                        padding: const EdgeInsets.only(top: 18, bottom: 6),
                        child: Text('${label.toUpperCase()} · ${members.length}', style: AkashicTypography.body(size: 11, weight: FontWeight.w800).copyWith(color: AkashicColors.textSoft, letterSpacing: 1.1)),
                      ),
                      for (final entry in members) _SessionEntryRow(entry: entry, onOpenItem: onOpenItem),
                    ],
                ],
              ),
          },
        );
      },
    );
  }
}

class _SessionEntryRow extends StatelessWidget {
  const _SessionEntryRow({required this.entry, required this.onOpenItem});

  final ScanSessionEntry entry;
  final ValueChanged<String> onOpenItem;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final color = scanOutcomeColor(entry.outcome);
    final itemId = entry.itemId;
    return ListTile(
      contentPadding: EdgeInsets.zero,
      onTap: itemId == null ? null : () => onOpenItem(itemId),
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(6),
        child: Container(
          width: 36,
          height: 50,
          alignment: Alignment.center,
          decoration: BoxDecoration(gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [color.withValues(alpha: 0.55), AkashicColors.line])),
          child: Text(entry.outcome == ScanOutcome.missed ? '?' : initialsOf(entry.title), style: AkashicTypography.numeral(size: 13).copyWith(color: AkashicColors.text)),
        ),
      ),
      title: Text(entry.title, maxLines: 2, overflow: TextOverflow.ellipsis, style: AkashicTypography.body(size: 14, weight: FontWeight.w700)),
      subtitle: Text(_sourceLabel(entry.source, l10n), style: AkashicTypography.body(size: 12).copyWith(color: AkashicColors.textSoft)),
      trailing: itemId == null ? null : Icon(Icons.chevron_right, semanticLabel: l10n.seeItem),
    );
  }
}
