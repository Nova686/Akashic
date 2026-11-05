import 'package:akashic/layers/functional/Collection/domain/use_cases/series_completion.dart';
import 'package:akashic/layers/technical/Localization/app_localizations.dart';
import 'package:akashic/layers/technical/Theme/akashic_colors.dart';
import 'package:akashic/layers/technical/Theme/akashic_typography.dart';
import 'package:flutter/material.dart';

enum VolumeCellState { owned, missing, unreleased }

class VolumeCell {
  const VolumeCell(this.number, this.state);

  final int number;
  final VolumeCellState state;
}

List<VolumeCell> volumeCellsOf(SeriesCompletion completion) {
  final owned = completion.owned.toSet();
  final last = [completion.published ?? 0, ...completion.owned].fold<int>(0, (highest, number) => number > highest ? number : highest);
  return [
    for (var number = 1; number <= last; number++) VolumeCell(number, owned.contains(number) ? VolumeCellState.owned : VolumeCellState.missing),
    if (completion.nextUnreleased case final next?) VolumeCell(next, VolumeCellState.unreleased),
  ];
}

class SeriesCompletionGrid extends StatelessWidget {
  SeriesCompletionGrid({required SeriesCompletion completion, super.key}) : cells = volumeCellsOf(completion);

  final List<VolumeCell> cells;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Wrap(
      spacing: 6,
      runSpacing: 6,
      children: [
        for (final cell in cells)
          Semantics(
            label: switch (cell.state) {
              VolumeCellState.owned => l10n.volumeOwnedLabel(cell.number),
              VolumeCellState.missing => l10n.volumeMissingLabel(cell.number),
              VolumeCellState.unreleased => l10n.volumeUnreleasedLabel(cell.number),
            },
            excludeSemantics: true,
            child: Container(
              width: 34,
              height: 50,
              alignment: cell.state == VolumeCellState.owned ? Alignment.bottomCenter : Alignment.center,
              padding: const EdgeInsets.only(bottom: 4),
              decoration: BoxDecoration(
                gradient: cell.state == VolumeCellState.owned ? const LinearGradient(colors: [Color(0xFFD9CFFF), AkashicColors.lavender], begin: Alignment.topLeft, end: Alignment.bottomRight) : null,
                color: cell.state == VolumeCellState.missing ? AkashicColors.missing.withValues(alpha: 0.14) : null,
                borderRadius: BorderRadius.circular(4),
                border: switch (cell.state) {
                  VolumeCellState.owned => null,
                  VolumeCellState.missing => Border.all(color: AkashicColors.missing, width: 1.5),
                  VolumeCellState.unreleased => Border.all(color: AkashicColors.textFaint),
                },
              ),
              child: Text(
                '${cell.number}',
                style: AkashicTypography.numeral(size: 11).copyWith(
                  color: switch (cell.state) {
                    VolumeCellState.owned => AkashicColors.night,
                    VolumeCellState.missing => AkashicColors.missing,
                    VolumeCellState.unreleased => AkashicColors.textFaint,
                  },
                ),
              ),
            ),
          ),
      ],
    );
  }
}
