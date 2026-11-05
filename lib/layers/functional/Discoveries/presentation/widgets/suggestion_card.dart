import 'package:akashic/layers/functional/Discoveries/domain/entities/suggestion.dart';
import 'package:akashic/layers/technical/Localization/app_localizations.dart';
import 'package:akashic/layers/technical/Theme/akashic_colors.dart';
import 'package:akashic/layers/technical/Theme/akashic_typography.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class SuggestionCard extends StatelessWidget {
  const SuggestionCard({required this.suggestion, required this.isWished, required this.onWish, required this.onDismiss, this.onOpen, super.key});

  static const double width = 132;

  final Suggestion suggestion;
  final bool isWished;
  final VoidCallback onWish;
  final VoidCallback onDismiss;
  final VoidCallback? onOpen;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return SizedBox(
      width: width,
      child: InkWell(
        onTap: onOpen,
        borderRadius: BorderRadius.circular(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: SizedBox(
                  width: width,
                  child: suggestion.imageUrl == null
                      ? const ColoredBox(
                          color: AkashicColors.surface,
                          child: Icon(Icons.auto_awesome_outlined, color: AkashicColors.lavender),
                        )
                      : CachedNetworkImage(imageUrl: 
                          suggestion.imageUrl!,
                          fit: BoxFit.cover,
                          memCacheWidth: 400,
                          errorWidget: (context, url, error) => const ColoredBox(color: AkashicColors.surface),
                        ),
                ),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              suggestion.title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: AkashicTypography.body(size: 13, weight: FontWeight.w700),
            ),
            if (suggestion.creator != null)
              Text(
                suggestion.creator!,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AkashicTypography.body(size: 11).copyWith(color: AkashicColors.textSoft),
              ),
            const SizedBox(height: 4),
            Row(
              children: [
                Expanded(
                  child: isWished
                      ? Text(
                          l10n.wished,
                          style: AkashicTypography.body(size: 12, weight: FontWeight.w700).copyWith(color: AkashicColors.lavender),
                        )
                      : InkWell(
                          onTap: onWish,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: Text(
                              l10n.addWishShort,
                              style: AkashicTypography.body(size: 12, weight: FontWeight.w700).copyWith(color: AkashicColors.teal),
                            ),
                          ),
                        ),
                ),
                IconButton(
                  tooltip: l10n.notForMe,
                  icon: Icon(Icons.close, size: 18, color: AkashicColors.textSoft),
                  onPressed: onDismiss,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
