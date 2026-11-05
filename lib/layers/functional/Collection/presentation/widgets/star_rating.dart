import 'package:akashic/layers/technical/Localization/app_localizations.dart';
import 'package:akashic/layers/technical/Theme/akashic_colors.dart';
import 'package:flutter/material.dart';

class StarRating extends StatelessWidget {
  const StarRating({required this.rating, required this.onChanged, this.size = 26, super.key});

  static const double touchSize = 48;

  final int? rating;
  final ValueChanged<int?> onChanged;
  final double size;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final current = rating ?? 0;
    return Semantics(
      slider: true,
      label: l10n.ratingLabel,
      value: rating == null ? l10n.notRated : l10n.ratingValue(current),
      increasedValue: l10n.ratingValue(current < 5 ? current + 1 : 5),
      decreasedValue: current > 1 ? l10n.ratingValue(current - 1) : l10n.notRated,
      onIncrease: current < 5 ? () => onChanged(current + 1) : null,
      onDecrease: current > 0 ? () => onChanged(current > 1 ? current - 1 : null) : null,
      child: ExcludeSemantics(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (var star = 1; star <= 5; star++)
              InkResponse(
                onTap: () => onChanged(star == rating ? null : star),
                radius: touchSize / 2,
                child: SizedBox(
                  width: touchSize,
                  height: touchSize,
                  child: Icon(
                    star <= current ? Icons.star_rounded : Icons.star_outline_rounded,
                    size: size,
                    color: star <= current ? AkashicColors.lavender : AkashicColors.textFaint,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
