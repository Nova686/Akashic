import 'package:akashic/layers/functional/Friends/domain/use_cases/compare_collections.dart';
import 'package:akashic/layers/technical/Localization/app_localizations.dart';
import 'package:akashic/layers/technical/Theme/akashic_colors.dart';
import 'package:akashic/layers/technical/Theme/akashic_empty_state.dart';
import 'package:akashic/layers/technical/Theme/akashic_typography.dart';
import 'package:akashic/layers/technical/Theme/safe_scroll_padding.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

enum CompareTab { inCommon, onlyFriend, onlyMine }

class CompareView extends StatefulWidget {
  const CompareView({required this.pickAndCompare, super.key});

  final Future<CollectionComparison?> Function() pickAndCompare;

  @override
  State<CompareView> createState() => _CompareViewState();
}

class _CompareViewState extends State<CompareView> {
  CollectionComparison? _comparison;
  CompareTab _tab = CompareTab.onlyFriend;
  bool _isLoading = false;
  bool _wasUnreadable = false;

  Future<void> _pick() async {
    setState(() {
      _isLoading = true;
      _wasUnreadable = false;
    });
    try {
      final comparison = await widget.pickAndCompare();
      if (mounted) {
        setState(() => _comparison = comparison ?? _comparison);
      }
    } on Exception {
      if (mounted) {
        setState(() => _wasUnreadable = true);
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  String _reasonLabel(ExchangeReason reason, AppLocalizations l10n) => switch (reason) {
        ExchangeReason.fillsMissingVolume => l10n.compareFillsMissing,
        ExchangeReason.wished => l10n.compareInWishes,
      };

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final comparison = _comparison;
    final works = switch ((comparison, _tab)) {
      (null, _) => const <ComparedWork>[],
      (final found?, CompareTab.inCommon) => found.inCommon,
      (final found?, CompareTab.onlyFriend) => found.onlyFriend,
      (final found?, CompareTab.onlyMine) => found.onlyMine,
    };
    return Scaffold(
      appBar: AppBar(title: Text(l10n.compareTitle, style: AkashicTypography.displayTitle(size: 24))),
      body: ListView(
        padding: safeListPadding(context),
        children: [
          Text(l10n.compareIntro, style: AkashicTypography.body(size: 13).copyWith(color: AkashicColors.textSoft)),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(14), border: Border.all(color: AkashicColors.teal, width: 1.5)),
            child: Row(
              children: [
                const Icon(Icons.lock_outline, color: AkashicColors.teal),
                const SizedBox(width: 10),
                Expanded(child: Text(l10n.compareNothingSent, style: AkashicTypography.body(size: 13, weight: FontWeight.w600))),
              ],
            ),
          ),
          const SizedBox(height: 12),
          OutlinedButton.icon(onPressed: _isLoading ? null : _pick, icon: const Icon(Icons.upload_file), label: Text(comparison == null ? l10n.compareChooseFile : l10n.compareOtherFile)),
          if (_isLoading) const Padding(padding: EdgeInsets.only(top: 12), child: LinearProgressIndicator()),
          if (_wasUnreadable) Padding(padding: const EdgeInsets.only(top: 8), child: Text(l10n.compareUnreadable, style: AkashicTypography.body(size: 13).copyWith(color: AkashicColors.coral))),
          if (comparison != null) ...[
            const SizedBox(height: 16),
            Text(l10n.compareCounts(comparison.myCount, comparison.friendCount), style: AkashicTypography.body(size: 13).copyWith(color: AkashicColors.textSoft)),
            const SizedBox(height: 8),
            SegmentedButton<CompareTab>(
              showSelectedIcon: false,
              segments: [
                ButtonSegment(value: CompareTab.inCommon, label: Text(l10n.compareInCommon(comparison.inCommon.length))),
                ButtonSegment(value: CompareTab.onlyFriend, label: Text(l10n.compareOnlyFriend(comparison.onlyFriend.length))),
                ButtonSegment(value: CompareTab.onlyMine, label: Text(l10n.compareOnlyMine(comparison.onlyMine.length))),
              ],
              selected: {_tab},
              onSelectionChanged: (selection) => setState(() => _tab = selection.single),
            ),
            if (_tab == CompareTab.onlyFriend && comparison.exchangeIdeas.isNotEmpty) ...[
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(child: Text(l10n.compareExchangeIdeas(comparison.exchangeIdeas.length), style: AkashicTypography.body(size: 14, weight: FontWeight.w800).copyWith(color: AkashicColors.teal))),
                  TextButton.icon(
                    onPressed: () async {
                      final messenger = ScaffoldMessenger.of(context);
                      await Clipboard.setData(ClipboardData(text: [for (final work in comparison.exchangeIdeas) '• ${work.label}'].join('\n')));
                      messenger.showSnackBar(SnackBar(content: Text(l10n.compareCopied)));
                    },
                    icon: const Icon(Icons.copy, size: 18),
                    label: Text(l10n.compareCopyList),
                  ),
                ],
              ),
            ],
            if (works.isEmpty) Padding(padding: const EdgeInsets.only(top: 30), child: AkashicEmptyState(message: l10n.compareNothingHere)),
            for (final work in works)
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(work.label, maxLines: 2, overflow: TextOverflow.ellipsis, style: AkashicTypography.body(size: 14, weight: FontWeight.w700)),
                subtitle: work.creator == null ? null : Text(work.creator!, style: AkashicTypography.body(size: 12).copyWith(color: AkashicColors.textSoft)),
                trailing: switch (work.reason) {
                  final reason? when _tab == CompareTab.onlyFriend => Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(999), border: Border.all(color: AkashicColors.teal)),
                      child: Text(_reasonLabel(reason, l10n), style: AkashicTypography.body(size: 11, weight: FontWeight.w800).copyWith(color: AkashicColors.teal)),
                    ),
                  _ => null,
                },
              ),
          ],
        ],
      ),
    );
  }
}
