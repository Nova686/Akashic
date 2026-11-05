import 'package:akashic/layers/technical/Theme/akashic_colors.dart';
import 'package:akashic/layers/technical/Theme/akashic_typography.dart';
import 'package:flutter/material.dart';

class ShelfHeader extends StatelessWidget {
  const ShelfHeader({required this.name, required this.colorValue, required this.itemCount, this.highlight, this.onTap, super.key});

  final String name;
  final int colorValue;
  final int itemCount;
  final String? highlight;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 6),
        child: Row(
          children: [
            Container(
              width: 10,
              height: 10,
              margin: const EdgeInsets.only(right: 8),
              decoration: BoxDecoration(
                color: Color(colorValue),
                shape: BoxShape.circle,
                boxShadow: [BoxShadow(color: AkashicColors.text.withValues(alpha: 0.3), blurRadius: 10)],
              ),
            ),
            Expanded(
              child: Row(
                children: [
                  Flexible(child: Text(name, maxLines: 1, overflow: TextOverflow.ellipsis, style: AkashicTypography.body(size: 15, weight: FontWeight.w700))),
                  if (highlight != null)
                    Flexible(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8),
                        child: Text(highlight!, maxLines: 1, overflow: TextOverflow.ellipsis, style: AkashicTypography.body(size: 12).copyWith(color: AkashicColors.teal)),
                      ),
                    ),
                ],
              ),
            ),
            Text('$itemCount', style: AkashicTypography.numeral()),
            if (onTap != null) Icon(Icons.chevron_right, size: 18, color: AkashicColors.textFaint),
          ],
        ),
      ),
    );
  }
}
