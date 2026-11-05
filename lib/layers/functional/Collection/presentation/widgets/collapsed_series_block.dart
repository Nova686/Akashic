import 'package:akashic/layers/functional/Collection/presentation/widgets/item_spine.dart';
import 'package:akashic/layers/functional/Collection/presentation/widgets/spine_text_color.dart';
import 'package:akashic/layers/functional/Collection/presentation/widgets/vertical_spine_label.dart';
import 'package:akashic/layers/technical/Theme/akashic_colors.dart';
import 'package:akashic/layers/technical/Theme/akashic_typography.dart';
import 'package:flutter/material.dart';

class CollapsedSeriesBlock extends StatelessWidget {
  const CollapsedSeriesBlock({
    required this.label,
    required this.ownedCount,
    required this.isIncomplete,
    required this.colorValue,
    required this.size,
    required this.onTap,
    this.onLongPress,
    super.key,
  });

  final String label;
  final int ownedCount;
  final bool isIncomplete;
  final int colorValue;
  final SpineSize size;
  final VoidCallback onTap;
  final VoidCallback? onLongPress;

  @override
  Widget build(BuildContext context) {
    final color = Color(colorValue);
    final textColor = textColorOnSpine(color);
    return Semantics(
      button: true,
      label: '$label, $ownedCount',
      child: GestureDetector(
        onTap: onTap,
        onLongPress: onLongPress,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              width: 40,
              height: size.shelfHeight - 4,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(2)),
                gradient: LinearGradient(
                  colors: [color, color, Colors.black38, color, color, Colors.black38, color, color, Colors.black38, color],
                  stops: const [0, 0.12, 0.13, 0.14, 0.3, 0.31, 0.32, 0.5, 0.51, 0.52],
                  tileMode: TileMode.repeated,
                ),
              ),
              child: Column(
                children: [
                  const SizedBox(height: 4),
                  Text('$ownedCount', style: AkashicTypography.numeral(size: 10).copyWith(color: textColor)),
                  Expanded(child: VerticalSpineLabel(text: label.toUpperCase(), style: AkashicTypography.body(size: 7.5, weight: FontWeight.w800).copyWith(color: textColor))),
                ],
              ),
            ),
            if (isIncomplete)
              const Positioned(
                top: -3,
                right: -3,
                child: DecoratedBox(
                  decoration: BoxDecoration(color: AkashicColors.teal, shape: BoxShape.circle, boxShadow: [BoxShadow(color: AkashicColors.teal, blurRadius: 8)]),
                  child: SizedBox(width: 8, height: 8),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
