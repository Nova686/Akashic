import 'package:akashic/layers/technical/Theme/akashic_empty_state.dart';
import 'package:akashic/layers/functional/Scans/domain/entities/chapter_number.dart';
import 'package:akashic/layers/functional/Scans/domain/entities/scan_progress.dart';
import 'package:akashic/layers/functional/Scans/presentation/cubit/scan_follow_cubit.dart';
import 'package:akashic/layers/functional/Scans/presentation/cubit/scan_follow_state.dart';
import 'package:akashic/layers/technical/Localization/app_localizations.dart';
import 'package:akashic/layers/technical/Theme/akashic_colors.dart';
import 'package:akashic/layers/technical/Theme/akashic_typography.dart';
import 'package:akashic/layers/technical/Theme/safe_scroll_padding.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

class ScanFollowPanel extends StatelessWidget {
  const ScanFollowPanel({super.key});

  static const int visibleChapterCount = 60;

  Future<void> _confirmUnfollow(BuildContext context) async {
    final l10n = AppLocalizations.of(context);
    final scanCubit = context.read<ScanFollowCubit>();
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        content: Text(l10n.stopFollowingQuestion),
        actions: [
          TextButton(onPressed: () => Navigator.of(dialogContext).pop(false), child: Text(l10n.cancel)),
          FilledButton(onPressed: () => Navigator.of(dialogContext).pop(true), child: Text(l10n.stopFollowingInScans)),
        ],
      ),
    );
    if (confirmed ?? false) {
      await scanCubit.unfollow();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final scanCubit = context.read<ScanFollowCubit>();
    return BlocConsumer<ScanFollowCubit, ScanFollowState>(
      listenWhen: (previous, current) => current.notice != ScanFollowNotice.none,
      listener: (context, state) {
        final message = switch (state.notice) {
          ScanFollowNotice.refreshFailed => l10n.releasesCheckFailed,
          ScanFollowNotice.notificationsRefused => l10n.notificationsRefused,
          ScanFollowNotice.nothingFound => l10n.noReleaseSeriesFound,
          ScanFollowNotice.none => null,
        };
        if (message != null) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
        }
      },
      builder: (context, state) {
        if (state.isLoading) {
          return const Center(child: LabelledSpinner());
        }
        final progress = state.progress;
        if (progress == null) {
          return ListView(
            padding: safeListPadding(context, top: 24),
            children: [
              Text(l10n.notFollowedInScans, textAlign: TextAlign.center, style: AkashicTypography.body().copyWith(color: AkashicColors.textSoft)),
              const SizedBox(height: 16),
              FilledButton(onPressed: scanCubit.follow, child: Text(l10n.followInScans)),
            ],
          );
        }
        return ListView(
          padding: safeListPadding(context, top: 16),
          children: [
            _ReadingSummary(progress: progress),
            const SizedBox(height: 14),
            _ReadUpToField(onSubmit: scanCubit.markReadUpTo),
            const SizedBox(height: 14),
            _ChapterGrid(progress: progress, showsAll: state.showsAllChapters, onToggle: scanCubit.toggleChapter, onShowAll: scanCubit.showAllChapters),
            const SizedBox(height: 18),
            _SiteField(siteUrl: progress.follow.siteUrl, onSubmit: scanCubit.setSite),
            const SizedBox(height: 12),
            _CommittingField(value: progress.follow.teamName, label: l10n.translationTeam, onCommit: scanCubit.setTeam),
            const SizedBox(height: 18),
            _ReleaseLink(state: state),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(l10n.chapterAlerts),
              value: progress.follow.alertsEnabled,
              onChanged: progress.follow.isLinked ? scanCubit.setAlerts : null,
            ),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(l10n.onlyMyTeam),
              value: progress.follow.onlyFollowedTeam,
              onChanged: progress.follow.teamName == null ? null : scanCubit.setOnlyFollowedTeam,
            ),
            const SizedBox(height: 8),
            TextButton(onPressed: () => _confirmUnfollow(context), child: Text(l10n.stopFollowingInScans, style: TextStyle(color: AkashicColors.textSoft))),
          ],
        );
      },
    );
  }
}

class _ReadingSummary extends StatelessWidget {
  const _ReadingSummary({required this.progress});

  final ScanProgress progress;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final lastRead = progress.lastRead;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: AkashicColors.surface, borderRadius: BorderRadius.circular(18)),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(l10n.lastChapterRead, style: AkashicTypography.body(size: 13).copyWith(color: AkashicColors.textSoft)),
                Text(lastRead == null ? '—' : formatChapter(lastRead), style: AkashicTypography.numeral(size: 34).copyWith(color: AkashicColors.lavender)),
              ],
            ),
          ),
          Flexible(
            child: Text(
              l10n.newChaptersCount(progress.newChapters.length),
              textAlign: TextAlign.end,
              style: AkashicTypography.body(size: 14, weight: FontWeight.w700).copyWith(color: AkashicColors.teal),
            ),
          ),
        ],
      ),
    );
  }
}

class _ReadUpToField extends StatefulWidget {
  const _ReadUpToField({required this.onSubmit});

  final Future<void> Function(String text) onSubmit;

  @override
  State<_ReadUpToField> createState() => _ReadUpToFieldState();
}

class _ReadUpToFieldState extends State<_ReadUpToField> {
  final TextEditingController _chapterController = TextEditingController();

  @override
  void dispose() {
    _chapterController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    await widget.onSubmit(_chapterController.text);
    _chapterController.clear();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _chapterController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            style: AkashicTypography.numeral(size: 16),
            decoration: InputDecoration(labelText: l10n.readUpToChapter),
            onSubmitted: (_) => _submit(),
          ),
        ),
        const SizedBox(width: 10),
        FilledButton(onPressed: _submit, child: Text(l10n.markRead)),
      ],
    );
  }
}

class _ChapterGrid extends StatelessWidget {
  const _ChapterGrid({required this.progress, required this.showsAll, required this.onToggle, required this.onShowAll});

  final ScanProgress progress;
  final bool showsAll;
  final ValueChanged<double> onToggle;
  final VoidCallback onShowAll;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final known = <double>{
      ...progress.readChapters,
      for (final release in progress.releases) release.chapter,
      for (var whole = 1; whole <= (progress.lastRead ?? 0); whole++) whole.toDouble(),
    }.toList()
      ..sort();
    if (known.isEmpty) {
      return const SizedBox.shrink();
    }
    final hidden = showsAll ? 0 : (known.length - ScanFollowPanel.visibleChapterCount).clamp(0, known.length);
    final read = progress.readChapters.toSet();
    final unread = progress.newChapters.toSet();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(l10n.chaptersRead, style: AkashicTypography.body(size: 15, weight: FontWeight.w800)),
        const SizedBox(height: 8),
        Wrap(
          spacing: 6,
          runSpacing: 6,
          children: [
            for (final chapter in known.skip(hidden))
              FilterChip(
                label: Text(formatChapter(chapter), style: AkashicTypography.numeral(size: 12)),
                selected: read.contains(chapter),
                side: unread.contains(chapter) ? const BorderSide(color: AkashicColors.teal) : null,
                showCheckmark: false,
                onSelected: (_) => onToggle(chapter),
              ),
          ],
        ),
        if (hidden > 0) TextButton(onPressed: onShowAll, child: Text(l10n.showAllChapters)),
      ],
    );
  }
}

class _SiteField extends StatelessWidget {
  const _SiteField({required this.siteUrl, required this.onSubmit});

  final String? siteUrl;
  final ValueChanged<String> onSubmit;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final site = Uri.tryParse(siteUrl ?? '');
    final canOpen = site != null && site.hasScheme && (site.scheme == 'https' || site.scheme == 'http');
    return Row(
      children: [
        Expanded(child: _CommittingField(value: siteUrl, label: l10n.readingSite, keyboardType: TextInputType.url, onCommit: onSubmit)),
        IconButton(
          tooltip: l10n.openReadingSite,
          icon: const Icon(Icons.open_in_new, color: AkashicColors.teal),
          onPressed: canOpen ? () => launchUrl(site, mode: LaunchMode.externalApplication) : null,
        ),
      ],
    );
  }
}

class _ReleaseLink extends StatelessWidget {
  const _ReleaseLink({required this.state});

  final ScanFollowState state;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final scanCubit = context.read<ScanFollowCubit>();
    final follow = state.progress!.follow;
    if (follow.isLinked) {
      return Row(
        children: [
          const Icon(Icons.link, size: 18, color: AkashicColors.teal),
          const SizedBox(width: 6),
          Expanded(child: Text(l10n.linkedToMangaUpdates, style: AkashicTypography.body(size: 13, weight: FontWeight.w600))),
          IconButton(
            tooltip: l10n.checkReleases,
            onPressed: state.isRefreshing ? null : scanCubit.refresh,
            icon: state.isRefreshing ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2)) : const Icon(Icons.refresh, color: AkashicColors.teal),
          ),
          TextButton(onPressed: scanCubit.unlink, child: Text(l10n.unlinkMangaUpdates)),
        ],
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          textInputAction: TextInputAction.search,
          decoration: InputDecoration(
            labelText: l10n.searchMangaUpdates,
            prefixIcon: const Icon(Icons.search),
            suffixIcon: state.isSearching ? const Padding(padding: EdgeInsets.all(12), child: SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2))) : null,
          ),
          onSubmitted: scanCubit.searchReleaseSeries,
        ),
        for (final candidate in state.candidates)
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: candidate.imageUrl == null
                ? null
                : ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: Image.network(candidate.imageUrl!, width: 36, height: 50, fit: BoxFit.cover, cacheWidth: 120, errorBuilder: (context, error, stack) => const SizedBox(width: 36, height: 50)),
                  ),
            title: Text(candidate.title, maxLines: 2, overflow: TextOverflow.ellipsis),
            subtitle: Text([?candidate.kind, ?candidate.year].join(' · ')),
            onTap: () => scanCubit.link(candidate),
          ),
        Padding(
          padding: const EdgeInsets.only(top: 6),
          child: Text(l10n.manualTrackingHint, style: AkashicTypography.body(size: 12).copyWith(color: AkashicColors.textFaint)),
        ),
      ],
    );
  }
}

class _CommittingField extends StatefulWidget {
  const _CommittingField({required this.value, required this.label, required this.onCommit, this.keyboardType});

  final String? value;
  final String label;
  final ValueChanged<String> onCommit;
  final TextInputType? keyboardType;

  @override
  State<_CommittingField> createState() => _CommittingFieldState();
}

class _CommittingFieldState extends State<_CommittingField> {
  late final TextEditingController _textController = TextEditingController(text: widget.value ?? '');
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_commitOnBlur);
  }

  @override
  void didUpdateWidget(_CommittingField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!_focusNode.hasFocus && widget.value != oldWidget.value) {
      _textController.text = widget.value ?? '';
    }
  }

  void _commitOnBlur() {
    if (!_focusNode.hasFocus) {
      _commit();
    }
  }

  void _commit() {
    if (_textController.text.trim() != (widget.value ?? '')) {
      widget.onCommit(_textController.text);
    }
  }

  @override
  void dispose() {
    _commit();
    _focusNode
      ..removeListener(_commitOnBlur)
      ..dispose();
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _textController,
      focusNode: _focusNode,
      keyboardType: widget.keyboardType,
      decoration: InputDecoration(labelText: widget.label),
      onSubmitted: (_) => _focusNode.unfocus(),
      onTapOutside: (_) => _focusNode.unfocus(),
    );
  }
}
