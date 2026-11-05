import 'package:akashic/layers/functional/Collection/presentation/widgets/item_spine.dart';
import 'package:akashic/layers/technical/Theme/akashic_colors.dart';
import 'package:flutter/material.dart';

class ShelfGapView extends StatelessWidget {
  const ShelfGapView({required this.size, super.key});

  final SpineSize size;

  @override
  Widget build(BuildContext context) {
    return ExcludeSemantics(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 3),
        child: Container(
          width: 6,
          height: size.shelfHeight * 0.55,
          decoration: BoxDecoration(
            color: AkashicColors.lavender.withValues(alpha: 0.2),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(3)),
            border: Border.all(color: AkashicColors.lavender.withValues(alpha: 0.55)),
          ),
        ),
      ),
    );
  }
}
