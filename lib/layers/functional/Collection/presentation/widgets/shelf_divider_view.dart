import 'package:akashic/layers/functional/Collection/presentation/widgets/item_spine.dart';
import 'package:akashic/layers/functional/Collection/presentation/widgets/vertical_spine_label.dart';
import 'package:akashic/layers/technical/Theme/akashic_colors.dart';
import 'package:akashic/layers/technical/Theme/akashic_typography.dart';
import 'package:flutter/material.dart';

class ShelfDividerView extends StatelessWidget {
  const ShelfDividerView({required this.label, required this.size, this.onTap, this.onLongPress, super.key});

  final String label;
  final SpineSize size;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: onTap != null,
      label: label,
      child: GestureDetector(
        onTap: onTap,
        onLongPress: onLongPress,
        child: Container(
          width: size == SpineSize.compact ? 15 : 18,
          height: size.shelfHeight,
          decoration: BoxDecoration(
            color: AkashicColors.lavender.withValues(alpha: 0.2),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(3)),
            border: Border.all(color: AkashicColors.lavender.withValues(alpha: 0.55)),
          ),
          child: VerticalSpineLabel(
            text: label.toUpperCase(),
            style: AkashicTypography.body(size: size == SpineSize.compact ? 7.5 : 8.5, weight: FontWeight.w800).copyWith(color: AkashicColors.lavender, letterSpacing: 0.4),
          ),
        ),
      ),
    );
  }
}
