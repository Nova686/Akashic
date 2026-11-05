import 'package:akashic/layers/functional/Collection/presentation/cubit/missing_volumes_cubit.dart';
import 'package:akashic/layers/technical/Localization/app_localizations.dart';
import 'package:akashic/layers/technical/Theme/akashic_colors.dart';
import 'package:akashic/layers/technical/Theme/akashic_empty_state.dart';
import 'package:akashic/layers/technical/Theme/akashic_typography.dart';
import 'package:akashic/layers/technical/Theme/safe_scroll_padding.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

enum VolumeRunKind { owned, wished, missing }

typedef VolumeRun = ({VolumeRunKind kind, int from, int to});

List<VolumeRun> volumeRunsOf(SeriesGaps gaps) {
  final runs = <VolumeRun>[];
  final last = gaps.completion.published ?? (gaps.completion.owned.isEmpty ? 0 : gaps.completion.owned.last);
  final owned = gaps.completion.owned.toSet();
  for (var number = 1; number <= last; number++) {
    final kind = owned.contains(number)
        ? VolumeRunKind.owned
        : gaps.wishedVolumes.contains(number)
            ? VolumeRunKind.wished
            : VolumeRunKind.missing;
    if (runs.isNotEmpty && runs.last.kind == kind && runs.last.to == number - 1) {
      runs[runs.length - 1] = (kind: kind, from: runs.last.from, to: number);
    } else {
      runs.add((kind: kind, from: number, to: number));
    }
  }
  return runs;
}

class MissingVolumesView extends StatelessWidget {
  const MissingVolumesView({required this.onOpenSeries, super.key});

  final ValueChanged<String> onOpenSeries;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final cubit = context.read<MissingVolumesCubit>();
    return BlocBuilder<MissingVolumesCubit, MissingVolumesState>(
      builder: (context, state) => Scaffold(
        appBar: AppBar(title: Text(l10n.missingVolumesTitle, style: AkashicTypography.displayTitle(size: 26))),
        body: state.isLoading
            ? const AkashicLoader()
            : state.series.isEmpty
                ? Center(child: AkashicEmptyState(message: l10n.noMissingVolumes))
                : ListView(
                    padding: safeListPadding(context),
                    children: [
                      Text.rich(
                        TextSpan(children: [
                          TextSpan(text: '${l10n.youAreMissing} '),
                          TextSpan(text: '${state.missingCount}', style: AkashicTypography.numeral(size: 26).copyWith(color: AkashicColors.lavender)),
                          TextSpan(text: ' ${l10n.volumesInSeries(state.missingCount, state.series.length)}'),
                        ]),
                        style: AkashicTypography.body(size: 15),
                      ),
                      const SizedBox(height: 10),
                      if (state.unwishedCount > 0)
                        FilledButton.icon(
                          onPressed: () async {
                            final messenger = ScaffoldMessenger.of(context);
                            final added = await cubit.wishEverything();
                            messenger.showSnackBar(SnackBar(content: Text(l10n.missingVolumesWished(added))));
                          },
                          icon: const Icon(Icons.favorite_border),
                          label: Text(l10n.wishAllMissing(state.unwishedCount)),
                        ),
                      for (final gaps in state.series) _SeriesGapsCard(gaps: gaps, onOpen: () => onOpenSeries(gaps.series.id), onWish: (volumes) => cubit.wish(gaps, volumes)),
                    ],
                  ),
      ),
    );
  }
}

class _SeriesGapsCard extends StatelessWidget {
  const _SeriesGapsCard({required this.gaps, required this.onOpen, required this.onWish});

  final SeriesGaps gaps;
  final VoidCallback onOpen;
  final Future<int> Function(List<int> volumes) onWish;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Container(
      margin: const EdgeInsets.only(top: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: AkashicColors.surface, borderRadius: BorderRadius.circular(18)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          InkWell(
            onTap: onOpen,
            child: Row(
              children: [
                Expanded(child: Text(gaps.title, maxLines: 1, overflow: TextOverflow.ellipsis, style: AkashicTypography.body(size: 15, weight: FontWeight.w700))),
                Text('${gaps.completion.owned.length} / ${gaps.completion.published ?? '?'}', style: AkashicTypography.numeral(size: 14).copyWith(color: AkashicColors.textSoft)),
                Icon(Icons.chevron_right, color: AkashicColors.textSoft),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: [
              for (final run in volumeRunsOf(gaps))
                _RunChip(
                  run: run,
                  onTap: run.kind == VolumeRunKind.missing ? () => onWish([for (var number = run.from; number <= run.to; number++) number]) : null,
                  semanticLabel: switch ((run.kind, run.from == run.to)) {
                    (VolumeRunKind.owned, true) => l10n.ownedVolume(run.from),
                    (VolumeRunKind.wished, true) => l10n.wishedVolume(run.from),
                    (VolumeRunKind.missing, true) => l10n.missingVolume(run.from),
                    (VolumeRunKind.owned, false) => l10n.ownedVolumesRun(run.from, run.to),
                    (VolumeRunKind.wished, false) => l10n.wishedVolumesRun(run.from, run.to),
                    (VolumeRunKind.missing, false) => l10n.missingVolumesRun(run.from, run.to),
                  },
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _RunChip extends StatelessWidget {
  const _RunChip({required this.run, required this.semanticLabel, this.onTap});

  final VolumeRun run;
  final String semanticLabel;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final label = run.from == run.to ? '${run.from}' : '${run.from}–${run.to}';
    final (background, border, foreground) = switch (run.kind) {
      VolumeRunKind.owned => (AkashicColors.lavender, AkashicColors.lavender, AkashicColors.night),
      VolumeRunKind.wished => (Colors.transparent, AkashicColors.lavender, AkashicColors.lavender),
      VolumeRunKind.missing => (Colors.transparent, AkashicColors.textFaint, AkashicColors.textSoft),
    };
    return Semantics(
      button: onTap != null,
      label: semanticLabel,
      onTap: onTap,
      excludeSemantics: true,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          constraints: const BoxConstraints(minHeight: 48, minWidth: 48),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: background,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: border, width: run.kind == VolumeRunKind.missing ? 1 : 1.5, strokeAlign: BorderSide.strokeAlignInside),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (run.kind == VolumeRunKind.wished) ...[Icon(Icons.favorite, size: 13, color: foreground), const SizedBox(width: 4)],
              if (run.kind == VolumeRunKind.missing) ...[Icon(Icons.add, size: 13, color: foreground), const SizedBox(width: 2)],
              Text(label, style: AkashicTypography.numeral(size: 13).copyWith(color: foreground)),
            ],
          ),
        ),
      ),
    );
  }
}
