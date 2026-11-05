import 'package:akashic/layers/functional/Wishes/domain/use_cases/describe_wish.dart';
import 'package:akashic/layers/functional/Wishes/presentation/views/wish_detail_view.dart';
import 'package:akashic/layers/functional/Catalog/presentation/widgets/category_type_labels.dart';
import 'package:akashic/layers/functional/Wishes/domain/entities/wish.dart';
import 'package:akashic/layers/functional/Wishes/presentation/cubit/wishes_cubit.dart';
import 'package:akashic/layers/functional/Wishes/presentation/cubit/wishes_state.dart';
import 'package:akashic/layers/functional/Wishes/presentation/widgets/wish_labels.dart';
import 'package:akashic/layers/technical/Localization/app_localizations.dart';
import 'package:akashic/layers/technical/Theme/akashic_empty_state.dart';
import 'package:akashic/layers/technical/Theme/akashic_colors.dart';
import 'package:akashic/layers/technical/Theme/akashic_typography.dart';
import 'package:akashic/layers/technical/Theme/safe_scroll_padding.dart';
import 'package:akashic/layers/functional/Steam/domain/entities/steam_wish_watch.dart';
import 'package:akashic/layers/functional/Wishes/presentation/views/wishlist_share_view.dart';
import 'package:akashic/layers/functional/Wishes/presentation/widgets/wish_priority_labels.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class WishesView extends StatelessWidget {
  const WishesView({this.describeWish, this.steamWatches, super.key});

  final DescribeWish? describeWish;
  final Stream<Map<String, SteamWishWatch>>? steamWatches;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final wishesCubit = context.read<WishesCubit>();
    return StreamBuilder<Map<String, SteamWishWatch>>(
      stream: steamWatches,
      builder: (context, watchesSnapshot) => BlocBuilder<WishesCubit, WishesState>(
      builder: (context, state) {
        final watches = watchesSnapshot.data ?? const <String, SteamWishWatch>{};
        return Scaffold(
          appBar: AppBar(
            title: Text(l10n.navWishes, style: AkashicTypography.displayTitle(size: 28)),
            actions: [
              if (state.wishes.isNotEmpty)
                IconButton(
                  tooltip: l10n.shareWishlist,
                  icon: const Icon(Icons.share_outlined),
                  onPressed: () => Navigator.of(context, rootNavigator: true).push(MaterialPageRoute<void>(builder: (_) => WishlistShareView(wishes: state.visibleWishes))),
                ),
            ],
          ),
          body: state.isLoading
              ? const AkashicLoader()
              : state.wishes.isEmpty
                  ? Center(child: AkashicEmptyState(message: l10n.wishesEmpty))
                  : ListView(
                      padding: safeListPadding(context),
                      children: [
                        if (state.availableTypes.length > 1)
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: [
                                _TypeChip(label: l10n.allTypes, isSelected: state.typeFilter == null, onSelected: () => wishesCubit.filterBy(null)),
                                for (final type in state.availableTypes)
                                  _TypeChip(label: type.label(l10n), isSelected: state.typeFilter == type, onSelected: () => wishesCubit.filterBy(type)),
                              ],
                            ),
                          ),
                        for (final (index, wish) in state.visibleWishes.indexed) ...[
                          if (index == 0 || state.visibleWishes[index - 1].priority != wish.priority)
                            Padding(
                              padding: const EdgeInsets.only(top: 14, bottom: 4),
                              child: Row(
                                children: [
                                  Icon(wishPriorityIcon(wish.priority), size: 16, color: wishPriorityColor(wish.priority)),
                                  const SizedBox(width: 6),
                                  Text(wishPriorityLabel(wish.priority, l10n).toUpperCase(), style: AkashicTypography.body(size: 11, weight: FontWeight.w800).copyWith(color: AkashicColors.textSoft, letterSpacing: 1.1)),
                                ],
                              ),
                            ),
                          Dismissible(
                            key: ValueKey(wish.id),
                            direction: DismissDirection.endToStart,
                            background: Container(
                              alignment: Alignment.centerRight,
                              padding: const EdgeInsets.only(right: 18),
                              color: AkashicColors.surface,
                              child: Icon(Icons.delete_outline, color: AkashicColors.textSoft),
                            ),
                            onDismissed: (_) {
                              wishesCubit.remove(wish.id);
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.wishRemoved)));
                            },
                            child: _WishTile(
                              wish: wish,
                              steamWatch: wish.key.sourceKey == 'steam' ? watches[wish.key.externalWorkId] : null,
                              onRemove: () => wishesCubit.remove(wish.id),
                              onOpen: () => Navigator.of(context, rootNavigator: true).push(MaterialPageRoute<void>(
                                builder: (_) => WishDetailView(
                                  wish: wish,
                                  describeWish: describeWish,
                                  onRemove: () => wishesCubit.remove(wish.id),
                                  onSavePlan: (priority, maxPriceCents) => wishesCubit.savePlan(wish.id, priority: priority, maxPriceCents: maxPriceCents),
                                ),
                              )),
                            ),
                          ),
                        ],
                      ],
                    ),
        );
      },
      ),
    );
  }
}

class _TypeChip extends StatelessWidget {
  const _TypeChip({required this.label, required this.isSelected, required this.onSelected});

  final String label;
  final bool isSelected;
  final VoidCallback onSelected;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8, bottom: 8),
      child: ChoiceChip(label: Text(label), selected: isSelected, onSelected: (_) => onSelected()),
    );
  }
}

class _WishTile extends StatelessWidget {
  const _WishTile({required this.wish, required this.onRemove, required this.onOpen, this.steamWatch});

  final Wish wish;
  final SteamWishWatch? steamWatch;
  final VoidCallback onRemove;
  final VoidCallback onOpen;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final addedOn = DateFormat.yMMMd(l10n.localeName).format(wish.createdAt);
    return ListTile(
      contentPadding: EdgeInsets.zero,
      onTap: onOpen,
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(6),
        child: SizedBox(
          width: 48,
          height: 48,
          child: wish.imageUrl == null
              ? const ColoredBox(color: AkashicColors.surface, child: Icon(Icons.favorite_border, color: AkashicColors.lavender))
              : CachedNetworkImage(imageUrl: wish.imageUrl!, fit: BoxFit.cover, memCacheWidth: 200, errorWidget: (context, url, error) => const ColoredBox(color: AkashicColors.surface)),
        ),
      ),
      title: Text(wish.displayTitle(l10n), maxLines: 2, overflow: TextOverflow.ellipsis, style: AkashicTypography.body(size: 15, weight: FontWeight.w700)),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (wish.creator != null) Text(wish.creator!, style: AkashicTypography.body(size: 12).copyWith(color: AkashicColors.textSoft)),
          Text(l10n.wishOriginOn(wish.origin.label(l10n), addedOn), style: AkashicTypography.body(size: 12).copyWith(color: AkashicColors.textSoft)),
          if (steamWatch case final watch?) _SteamWishPrice(watch: watch, maxPriceCents: wish.maxPriceCents),
          if ((wish.maxPriceCents, steamWatch) case (final maximum?, null)) Text(l10n.wishMaximumPrice(NumberFormat.simpleCurrency(locale: l10n.localeName, name: 'EUR').format(maximum / 100)), style: AkashicTypography.body(size: 12).copyWith(color: AkashicColors.textSoft)),
        ],
      ),
      isThreeLine: wish.creator != null || steamWatch != null || wish.maxPriceCents != null,
      trailing: IconButton(tooltip: l10n.removeWish, icon: const Icon(Icons.close), onPressed: onRemove),
    );
  }
}

class _SteamWishPrice extends StatelessWidget {
  const _SteamWishPrice({required this.watch, this.maxPriceCents});

  final SteamWishWatch watch;
  final int? maxPriceCents;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final price = watch.price;
    if (watch.isComingSoon) {
      return Text(l10n.steamWishComingSoon, style: AkashicTypography.body(size: 12, weight: FontWeight.w700).copyWith(color: AkashicColors.lavender));
    }
    if (price == null) {
      return const SizedBox.shrink();
    }
    final format = NumberFormat.simpleCurrency(locale: l10n.localeName, name: price.currency);
    return Padding(
      padding: const EdgeInsets.only(top: 2),
      child: Wrap(
        spacing: 6,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          Text(format.format(price.cents / 100), style: AkashicTypography.numeral(size: 13).copyWith(color: price.isDiscounted ? AkashicColors.gold : AkashicColors.text)),
          if (price.isDiscounted) ...[
            if (price.initialCents case final initial?)
              Text(format.format(initial / 100), style: AkashicTypography.body(size: 11).copyWith(color: AkashicColors.textFaint, decoration: TextDecoration.lineThrough)),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
              decoration: BoxDecoration(color: AkashicColors.gold.withValues(alpha: 0.18), borderRadius: BorderRadius.circular(6)),
              child: Text('-${price.discountPercent} %', style: AkashicTypography.body(size: 11, weight: FontWeight.w800).copyWith(color: AkashicColors.gold)),
            ),
          ],
          if (DateTime.now().difference(watch.checkedAt).inHours >= 24)
            Text(l10n.priceOn(DateFormat.MMMd(l10n.localeName).format(watch.checkedAt)), style: AkashicTypography.body(size: 11).copyWith(color: AkashicColors.textSoft)),
          if (maxPriceCents case final maximum?)
            Text(
              price.cents <= maximum ? l10n.wishUnderYourMaximum(format.format(maximum / 100)) : l10n.wishMaximumPrice(format.format(maximum / 100)),
              style: AkashicTypography.body(size: 11, weight: FontWeight.w700).copyWith(color: price.cents <= maximum ? AkashicColors.teal : AkashicColors.textSoft),
            ),
        ],
      ),
    );
  }
}
