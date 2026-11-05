import 'package:akashic/layers/functional/Collection/domain/entities/collection_item.dart';
import 'package:akashic/layers/functional/Collection/presentation/widgets/console_case_style.dart';
import 'package:akashic/layers/functional/Collection/presentation/widgets/item_spine.dart';
import 'package:akashic/layers/functional/Collection/presentation/widgets/spine_text_color.dart';
import 'package:akashic/layers/functional/Collection/presentation/widgets/vertical_spine_label.dart';
import 'package:akashic/layers/technical/Theme/akashic_typography.dart';
import 'package:flutter/material.dart';

class ConsoleCaseSpine extends StatelessWidget {
  const ConsoleCaseSpine({required this.item, required this.label, required this.size, this.onTap, this.semanticsLabel, super.key});

  final CollectionItem item;
  final String? label;
  final SpineSize size;
  final VoidCallback? onTap;
  final String? semanticsLabel;

  @override
  Widget build(BuildContext context) {
    final style = consoleCaseStyleFor(item.groupKey);
    final scale = size == SpineSize.compact ? 0.72 : 1.0;
    final text = label;
    final showsLabel = size == SpineSize.large && text != null && !style.isCartridge && style.width >= 10;
    return Semantics(
      label: semanticsLabel,
      button: onTap != null,
      onTap: onTap,
      excludeSemantics: semanticsLabel != null,
      child: GestureDetector(
        onTap: onTap,
        child: SizedBox(
          width: style.width,
          height: style.height * scale,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: style.body,
              borderRadius: BorderRadius.vertical(top: Radius.circular(style.isCartridge ? 3 : 2), bottom: Radius.circular(style.isCartridge ? 6 : 0)),
              border: Border.all(color: const Color(0x38FFFFFF)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (style.band case final band?) Container(height: style.bandHeight * scale, color: band),
                if (style.isCartridge) Container(margin: const EdgeInsets.fromLTRB(4, 4, 4, 0), height: 10 * scale, color: const Color(0xFFC9C9D1)),
                if (showsLabel)
                  Expanded(
                    child: VerticalSpineLabel(
                      text: text,
                      style: AkashicTypography.body(size: 7.5, weight: FontWeight.w700).copyWith(color: textColorOnSpine(style.body)),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
