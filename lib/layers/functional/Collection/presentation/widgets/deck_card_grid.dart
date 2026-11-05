import 'package:akashic/layers/functional/Collection/domain/entities/deck_card.dart';
import 'package:akashic/layers/technical/Localization/app_localizations.dart';
import 'package:akashic/layers/technical/Theme/akashic_colors.dart';
import 'package:akashic/layers/technical/Theme/akashic_typography.dart';
import 'package:akashic/layers/technical/Theme/zoom_gallery.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class DeckCardGrid extends StatelessWidget {
  const DeckCardGrid({required this.cards, super.key});

  static const double cardAspectRatio = 63 / 88;

  final Stream<List<DeckCard>> cards;

  void _showCards(BuildContext context, List<DeckCard> deckCards, int index) {
    showZoomGallery(
      context,
      initialIndex: index,
      showsPosition: false,
      images: [
        for (final card in deckCards)
          ZoomGalleryImage(
            heroTag: heroTagOf(card),
            image: card.imageUrl == null ? null : NetworkImage(card.imageUrl!.replaceFirst('/normal/', '/large/')),
            placeholder: card.name,
            badge: card.quantity > 1 ? '×${card.quantity}' : null,
            aspectRatio: cardAspectRatio,
          ),
      ],
    );
  }

  static Object heroTagOf(DeckCard card) => 'deck-card-${card.id}';

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return StreamBuilder<List<DeckCard>>(
      stream: cards,
      builder: (context, snapshot) {
        final deckCards = snapshot.data ?? const <DeckCard>[];
        final total = deckCards.fold<int>(0, (sum, card) => sum + card.quantity);
        return SliverMainAxisGroup(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.only(top: 16, bottom: 8),
                child: Text(l10n.deckCardsCount(total), style: AkashicTypography.body(size: 15, weight: FontWeight.w800)),
              ),
            ),
            if (snapshot.hasData && deckCards.isEmpty)
              SliverToBoxAdapter(child: Text(l10n.deckHasNoCards, style: AkashicTypography.body(size: 13).copyWith(color: AkashicColors.textSoft)))
            else
              SliverGrid.builder(
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(maxCrossAxisExtent: 110, childAspectRatio: cardAspectRatio, mainAxisSpacing: 8, crossAxisSpacing: 8),
                itemCount: deckCards.length,
                itemBuilder: (context, index) => _CardTile(card: deckCards[index], onTap: () => _showCards(context, deckCards, index)),
              ),
          ],
        );
      },
    );
  }
}

class _CardTile extends StatelessWidget {
  const _CardTile({required this.card, required this.onTap});

  final DeckCard card;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final placeholder = ColoredBox(
      color: AkashicColors.surface,
      child: Padding(
        padding: const EdgeInsets.all(6),
        child: Center(child: Text(card.name, textAlign: TextAlign.center, maxLines: 5, overflow: TextOverflow.ellipsis, style: AkashicTypography.body(size: 11, weight: FontWeight.w600))),
      ),
    );
    return Semantics(
      button: true,
      label: '${card.quantity} × ${card.name}',
      onTap: onTap,
      excludeSemantics: true,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(6),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Hero(
              tag: DeckCardGrid.heroTagOf(card),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: card.imageUrl == null ? placeholder : CachedNetworkImage(imageUrl: card.imageUrl!, fit: BoxFit.cover, memCacheWidth: 300, errorWidget: (context, url, error) => placeholder),
              ),
            ),
            if (card.quantity > 1)
              Positioned(
                right: 4,
                bottom: 4,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                  decoration: BoxDecoration(color: AkashicColors.night.withValues(alpha: 0.85), borderRadius: BorderRadius.circular(10)),
                  child: Text('×${card.quantity}', style: AkashicTypography.numeral(size: 12).copyWith(color: AkashicColors.lavender)),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
