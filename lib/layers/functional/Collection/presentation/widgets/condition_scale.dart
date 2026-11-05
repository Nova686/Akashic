import 'package:akashic/layers/functional/Collection/domain/entities/item_condition.dart';
import 'package:akashic/layers/functional/Collection/presentation/widgets/condition_labels.dart';
import 'package:akashic/layers/technical/Localization/app_localizations.dart';
import 'package:akashic/layers/technical/Theme/akashic_colors.dart';
import 'package:akashic/layers/technical/Theme/akashic_typography.dart';
import 'package:flutter/material.dart';

class ConditionScale extends StatelessWidget {
  const ConditionScale({required this.part, required this.selected, required this.onChanged, super.key});

  final String part;
  final ItemCondition? selected;
  final ValueChanged<ItemCondition?> onChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(child: Text(part, style: AkashicTypography.body(size: 13, weight: FontWeight.w700))),
            if (selected != null) Text(selected!.label(l10n), style: AkashicTypography.body(size: 13).copyWith(color: AkashicColors.textSoft)),
          ],
        ),
        const SizedBox(height: 6),
        Row(
          children: [
            for (final condition in ItemCondition.values)
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 2),
                  child: _ConditionChip(
                    label: condition.label(l10n),
                    isSelected: condition == selected,
                    isMissing: condition == ItemCondition.missing,
                    onTap: () => onChanged(condition == selected ? null : condition),
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }
}

class _ConditionChip extends StatelessWidget {
  const _ConditionChip({required this.label, required this.isSelected, required this.isMissing, required this.onTap});

  final String label;
  final bool isSelected;
  final bool isMissing;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final background = isSelected ? (isMissing ? AkashicColors.missing : AkashicColors.lavender) : (isMissing ? Colors.transparent : AkashicColors.surface);
    return Semantics(
      button: true,
      selected: isSelected,
      label: label,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(7),
        child: SizedBox(
          height: 48,
          child: Center(
            child: Container(
              height: 32,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: background,
                borderRadius: BorderRadius.circular(7),
                border: isMissing && !isSelected ? Border.all(color: AkashicColors.line) : null,
              ),
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AkashicTypography.body(size: 10, weight: FontWeight.w600).copyWith(color: isSelected ? AkashicColors.night : AkashicColors.textSoft),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
