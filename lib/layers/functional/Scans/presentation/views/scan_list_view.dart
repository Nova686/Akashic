import 'package:akashic/layers/technical/Theme/safe_bottom_sheet.dart';
import 'package:akashic/layers/functional/Scans/domain/entities/chapter_number.dart';
import 'package:akashic/layers/functional/Scans/presentation/cubit/scan_list_cubit.dart';
import 'package:akashic/layers/technical/Localization/app_localizations.dart';
import 'package:akashic/layers/technical/Theme/akashic_empty_state.dart';
import 'package:akashic/layers/technical/Theme/akashic_colors.dart';
import 'package:akashic/layers/technical/Theme/akashic_typography.dart';
import 'package:akashic/layers/technical/Theme/safe_scroll_padding.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ScanListView extends StatelessWidget {
  const ScanListView({required this.onOpenSeries, super.key});

  final ValueChanged<String> onOpenSeries;

  Future<void> _chooseSeriesToFollow(BuildContext context) async {
    final scanListCubit = context.read<ScanListCubit>();
    final chosenSeriesId = await showSafeBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      builder: (sheetContext) => BlocProvider.value(value: scanListCubit, child: const _FollowSeriesSheet()),
    );
    if (chosenSeriesId != null) {
      onOpenSeries(chosenSeriesId);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return BlocBuilder<ScanListCubit, ScanListState>(
      builder: (context, state) {
        if (state.isLoading) {
          return const AkashicLoader();
        }
        return ListView(
          padding: safeListPadding(context, bottom: 96),
          children: [
            if (state.entries.isEmpty)
              AkashicEmptyState(message: l10n.noScanFollows),
            for (final entry in state.entries)
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(entry.title, maxLines: 1, overflow: TextOverflow.ellipsis, style: AkashicTypography.body(size: 15, weight: FontWeight.w700)),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      switch (entry.progress.lastRead) {
                        final lastRead? => l10n.lastReadChapterShort(formatChapter(lastRead)),
                        null => l10n.nothingReadYet,
                      },
                      style: AkashicTypography.body(size: 12).copyWith(color: AkashicColors.textSoft),
                    ),
                    if (entry.progress.follow.teamName case final team?)
                      Text(team, style: AkashicTypography.body(size: 12).copyWith(color: AkashicColors.textFaint)),
                  ],
                ),
                trailing: entry.progress.newChapters.isEmpty
                    ? null
                    : Text(
                        l10n.newChaptersCount(entry.progress.newChapters.length),
                        style: AkashicTypography.body(size: 12, weight: FontWeight.w700).copyWith(color: AkashicColors.teal),
                      ),
                onTap: () => onOpenSeries(entry.series.id),
              ),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: () => _chooseSeriesToFollow(context),
              icon: const Icon(Icons.add),
              label: Text(l10n.followSeriesInScans),
            ),
          ],
        );
      },
    );
  }
}

class _FollowSeriesSheet extends StatefulWidget {
  const _FollowSeriesSheet();

  @override
  State<_FollowSeriesSheet> createState() => _FollowSeriesSheetState();
}

class _FollowSeriesSheetState extends State<_FollowSeriesSheet> {
  final TextEditingController _titleController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  Future<void> _close(Future<String?> following) async {
    final navigator = Navigator.of(context);
    final seriesId = await following;
    if (seriesId != null) {
      navigator.pop(seriesId);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final scanListCubit = context.read<ScanListCubit>();
    final unfollowed = context.select((ScanListCubit cubit) => cubit.state.unfollowedSeries);
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: ListView(
        shrinkWrap: true,
        padding: safeListPadding(context, top: 18),
        children: [
          Text(l10n.followSeriesInScans, style: AkashicTypography.displayTitle(size: 24)),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _titleController,
                  decoration: InputDecoration(labelText: l10n.newSeriesTitle),
                  onSubmitted: (title) => _close(scanListCubit.createAndFollow(title)),
                ),
              ),
              const SizedBox(width: 8),
              FilledButton(onPressed: () => _close(scanListCubit.createAndFollow(_titleController.text)), child: Text(l10n.createAndFollow)),
            ],
          ),
          const SizedBox(height: 8),
          for (final (series, title) in unfollowed)
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.collections_bookmark_outlined, color: AkashicColors.lavender),
              title: Text(title, maxLines: 1, overflow: TextOverflow.ellipsis),
              onTap: () => _close(scanListCubit.follow(series.id)),
            ),
        ],
      ),
    );
  }
}
