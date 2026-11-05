import 'package:akashic/layers/functional/Catalog/domain/entities/category_type.dart';
import 'package:akashic/layers/functional/Catalog/presentation/widgets/category_type_labels.dart';
import 'package:akashic/layers/technical/Localization/app_localizations.dart';
import 'package:akashic/layers/technical/Theme/akashic_colors.dart';
import 'package:akashic/layers/technical/Theme/akashic_typography.dart';
import 'package:flutter/material.dart';

class CategoryTypeTile extends StatelessWidget {
  const CategoryTypeTile({required this.type, required this.isSelected, required this.onTap, super.key});

  final CategoryType type;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Semantics(
      button: true,
      selected: isSelected,
      child: Material(
        color: isSelected ? AkashicColors.lavender.withValues(alpha: 0.16) : AkashicColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: isSelected ? AkashicColors.lavender : AkashicColors.line, width: isSelected ? 2 : 1),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(type.icon, size: 30, color: isSelected ? AkashicColors.lavender : AkashicColors.textSoft),
                const SizedBox(height: 8),
                Text(
                  type.label(l10n),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AkashicTypography.body(size: 13, weight: isSelected ? FontWeight.w800 : FontWeight.w600).copyWith(color: isSelected ? AkashicColors.text : AkashicColors.textSoft),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CategoryPreviewCard extends StatelessWidget {
  const CategoryPreviewCard({required this.name, required this.colorValue, required this.type, this.details = const [], super.key});

  final String name;
  final int colorValue;
  final CategoryType type;
  final List<String> details;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final color = Color(colorValue);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [color.withValues(alpha: 0.35), AkashicColors.surface]),
        border: Border.all(color: color.withValues(alpha: 0.6)),
      ),
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(color: color.withValues(alpha: 0.25), borderRadius: BorderRadius.circular(14)),
            child: Icon(type.icon, color: color, size: 28),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name.trim().isEmpty ? l10n.categoryPreviewEmpty : name.trim(), maxLines: 1, overflow: TextOverflow.ellipsis, style: AkashicTypography.displayTitle(size: 20)),
                Text(
                  [type.label(l10n), if (details.isNotEmpty) details.join(', ')].join(' · '),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AkashicTypography.body(size: 12).copyWith(color: AkashicColors.textSoft),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
