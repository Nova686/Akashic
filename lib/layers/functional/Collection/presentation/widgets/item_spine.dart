import 'package:akashic/layers/functional/Collection/domain/entities/collection_item.dart';
import 'package:akashic/layers/functional/Collection/presentation/widgets/deck_box.dart';
import 'package:akashic/layers/functional/Collection/presentation/widgets/spine_text_color.dart';
import 'package:akashic/layers/functional/Collection/presentation/widgets/vertical_spine_label.dart';
import 'package:akashic/layers/technical/Theme/akashic_typography.dart';
import 'package:flutter/material.dart';

enum SpineSize {
  compact(shelfHeight: 60),
  large(shelfHeight: 84);

  const SpineSize({required this.shelfHeight});

  final double shelfHeight;
}

enum SpineShape { flat, deckBox }

enum SpineThickness {
  record(compactWidth: 8, largeWidth: 16),
  volume(compactWidth: 13, largeWidth: 15);

  const SpineThickness({required this.compactWidth, required this.largeWidth});

  final double compactWidth;
  final double largeWidth;

  double widthFor(SpineSize size) => size == SpineSize.compact ? compactWidth : largeWidth;
}

class ItemSpine extends StatelessWidget {
  const ItemSpine({
    required this.item,
    required this.label,
    required this.shape,
    required this.size,
    required this.fallbackColorValue,
    this.thickness = SpineThickness.record,
    this.labelIsNumber = false,
    this.onTap,
    this.semanticsLabel,
    super.key,
  });

  final CollectionItem item;
  final String? label;
  final SpineShape shape;
  final SpineSize size;
  final int fallbackColorValue;
  final SpineThickness thickness;
  final bool labelIsNumber;
  final VoidCallback? onTap;
  final String? semanticsLabel;

  @override
  Widget build(BuildContext context) {
    final color = Color(item.spineColorValue ?? fallbackColorValue);
    if (shape == SpineShape.deckBox) {
      return Semantics(
        label: semanticsLabel,
        button: onTap != null,
        onTap: onTap,
        excludeSemantics: semanticsLabel != null,
        child: GestureDetector(
          onTap: onTap,
          child: DeckBox(color: color, size: size),
        ),
      );
    }
    final textColor = textColorOnSpine(color);
    final height = size.shelfHeight - (thickness == SpineThickness.volume ? 8 : 2);
    final text = label;
    return Semantics(
      label: semanticsLabel,
      button: onTap != null,
      onTap: onTap,
      excludeSemantics: semanticsLabel != null,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: thickness.widthFor(size),
          height: height,
          decoration: BoxDecoration(
            color: color,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(2)),
            boxShadow: const [BoxShadow(color: Color(0x59000000), offset: Offset(-1.5, 0), blurStyle: BlurStyle.inner)],
          ),
          child: text == null
              ? null
              : labelIsNumber
              ? Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
                    text,
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.clip,
                    style: AkashicTypography.numeral(size: size == SpineSize.compact ? 7 : 8).copyWith(color: textColor),
                  ),
                )
              : VerticalSpineLabel(
                  text: text,
                  style: AkashicTypography.body(size: 8, weight: FontWeight.w700).copyWith(color: textColor),
                ),
        ),
      ),
    );
  }
}
