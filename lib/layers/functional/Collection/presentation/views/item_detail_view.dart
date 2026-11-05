import 'package:akashic/layers/technical/Theme/akashic_empty_state.dart';
import 'dart:io';

import 'package:akashic/layers/functional/Catalog/domain/entities/category_type.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/deck_card.dart';
import 'package:akashic/layers/functional/Collection/presentation/widgets/deck_card_grid.dart';
import 'package:akashic/layers/functional/Collection/presentation/widgets/deck_tabs.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/card_kind.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/item_copy.dart';
import 'package:akashic/layers/functional/Collection/domain/use_cases/resolve_display_title.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/collection_item.dart';
import 'package:akashic/layers/functional/Collection/presentation/cubit/item_detail_cubit.dart';
import 'package:akashic/layers/functional/Collection/presentation/cubit/item_detail_state.dart';
import 'package:akashic/layers/functional/Collection/presentation/widgets/copy_card.dart';
import 'package:akashic/layers/functional/Collection/presentation/widgets/learn_more_tab.dart';
import 'package:akashic/layers/functional/Collection/presentation/widgets/progress_section.dart';
import 'package:akashic/layers/functional/Collection/presentation/widgets/star_rating.dart';
import 'package:akashic/layers/technical/Localization/app_localizations.dart';
import 'package:akashic/layers/technical/Theme/akashic_colors.dart';
import 'package:akashic/layers/technical/Theme/akashic_typography.dart';
import 'package:akashic/layers/technical/Theme/safe_scroll_padding.dart';
import 'package:akashic/layers/functional/Steam/domain/entities/steam_achievement.dart';
import 'package:akashic/layers/functional/Steam/presentation/widgets/steam_achievements_tab.dart';
import 'package:akashic/layers/functional/Steam/domain/entities/steam_store_page.dart';
import 'package:akashic/layers/functional/Steam/presentation/widgets/steam_store_tab.dart';
import 'package:akashic/layers/functional/Steam/presentation/widgets/steam_dashboard.dart';
import 'package:akashic/layers/functional/Steam/domain/entities/steam_game_stats.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/item_progress.dart';
import 'package:akashic/layers/functional/Collection/domain/use_cases/sealed_product_library.dart';
import 'package:akashic/layers/functional/SealedPrices/domain/entities/price_alert.dart';
import 'package:akashic/layers/functional/SealedPrices/domain/entities/sealed_price.dart';
import 'package:akashic/layers/functional/SealedPrices/domain/gateways/price_alert_store.dart';
import 'package:akashic/layers/functional/SealedPrices/presentation/widgets/sealed_price_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

const String steamSourceKey = 'steam';

class ItemDetailView extends StatelessWidget {
  const ItemDetailView({required this.onEditCopy, this.onEditItem, this.onOpenSeries, this.onEditDeck, this.deckCardsOf, this.onFetchCardTraits, this.onSetCommander, this.onSwapCommanders, this.steamAchievementsOf, this.steamStoreSheetOf, this.steamStoreDlcsOf, this.prefetchSteamStore, this.onWishSteamDlc, this.steamStatsOf, this.sealedPriceOf, this.onRefreshSealedPrices, this.priceAlerts, this.onLendCopy, this.onReturnCopy, this.onMoveItem, this.onAddAnother, this.tagsEditorOf, this.preorderPanelOf, super.key});

  final void Function(ItemCopy copy, List<String> parts) onEditCopy;
  final ValueChanged<String>? onEditItem;
  final ValueChanged<String>? onOpenSeries;
  final ValueChanged<String>? onEditDeck;
  final Stream<List<DeckCard>> Function(String itemId)? deckCardsOf;
  final Future<int> Function(String itemId)? onFetchCardTraits;
  final Future<void> Function(String cardId, CommanderRole role)? onSetCommander;
  final Future<void> Function(String itemId)? onSwapCommanders;
  final Future<List<SteamAchievement>> Function(String appId)? steamAchievementsOf;
  final Future<SteamStoreSheet> Function(String appId)? steamStoreSheetOf;
  final Future<List<SteamDlc>> Function(String appId)? steamStoreDlcsOf;
  final ValueChanged<String>? prefetchSteamStore;
  final Future<void> Function(SteamDlc dlc)? onWishSteamDlc;
  final Stream<SteamGameStats?> Function(String itemId)? steamStatsOf;
  final Stream<SealedPrice?> Function(String productId)? sealedPriceOf;
  final ValueChanged<String>? onAddAnother;
  final Future<void> Function()? onRefreshSealedPrices;
  final PriceAlertStore? priceAlerts;
  final Widget Function(String itemId)? tagsEditorOf;
  final Widget Function(CollectionItem item)? preorderPanelOf;
  final ValueChanged<ItemCopy>? onLendCopy;
  final ValueChanged<ItemCopy>? onReturnCopy;
  final ValueChanged<CollectionItem>? onMoveItem;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final detail = context.read<ItemDetailCubit>();
    return BlocConsumer<ItemDetailCubit, ItemDetailState>(
      listenWhen: (previous, current) => current.detailsFailed,
      listener: (context, state) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.detailsUnavailable))),
      builder: (context, state) {
        final item = state.item;
        if (item == null) {
          return const Scaffold(body: Center(child: LabelledSpinner()));
        }
        final displayTitle = resolveDisplayTitle(item.titles, state.preferredLanguages) ?? l10n.untitled;
        final variants = orderedTitleVariants(item.titles, state.preferredLanguages);
        final path = [?state.parentCategory?.name, ?state.category?.name].join(' › ');
        final metadata = [?item.year?.toString(), ?item.publisher].join(' · ');
        final imagePath = item.imagePath;
        final isDeck = item.cardKind == CardKind.deck;
        final isCard = state.category?.type == CategoryType.cards;
        final listPadding = safeListPadding(context, bottom: 32);
        final myInfo = <Widget>[
          if (variants.length > 1) ...[
            const SizedBox(height: 14),
            Text(l10n.titleVariants, style: AkashicTypography.body(size: 15, weight: FontWeight.w800)),
            for (final MapEntry(key: language, value: variant) in variants)
              Padding(
                padding: const EdgeInsets.only(top: 6),
                child: Row(
                  children: [
                    SizedBox(
                      width: 34,
                      child: Text(
                        language.toUpperCase(),
                        style: AkashicTypography.body(size: 11, weight: FontWeight.w700).copyWith(color: AkashicColors.teal),
                      ),
                    ),
                    Expanded(child: Text(variant, style: AkashicTypography.body())),
                  ],
                ),
              ),
          ],
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Expanded(child: Text(l10n.myCopies, style: AkashicTypography.body(size: 15, weight: FontWeight.w800))),
              if (onAddAnother case final addAnother?)
                TextButton.icon(
                  onPressed: () => addAnother(item.id),
                  icon: const Icon(Icons.add, size: 16, color: AkashicColors.teal),
                  label: Text(
                    l10n.addAnotherItem,
                    style: AkashicTypography.body(size: 12, weight: FontWeight.w600).copyWith(color: AkashicColors.teal),
                  ),
                ),
            ],
          ),
          if (state.copies.isEmpty)
            Align(
              alignment: Alignment.centerLeft,
              child: TextButton.icon(
                onPressed: () async => onEditCopy(await detail.addCopy(), state.conditionParts),
                icon: const Icon(Icons.edit_note, color: AkashicColors.lavender),
                label: Text(l10n.fillObjectDetails, style: AkashicTypography.body(size: 13, weight: FontWeight.w600).copyWith(color: AkashicColors.lavender)),
              ),
            ),
          for (final copy in state.copies.take(1))
            CopyCard(
              copy: copy,
              showsSealing: state.item?.cardKind == CardKind.sealed,
              onTap: () => onEditCopy(copy, state.conditionParts),
              onLend: onLendCopy == null ? null : () => onLendCopy!(copy),
              onReturn: onReturnCopy == null ? null : () => onReturnCopy!(copy),
            ),
        ];
        final steamAppId = item.sourceKey == steamSourceKey ? item.externalWorkId : null;
        final achievementsOf = steamAppId == null ? null : steamAchievementsOf;
        final storeSheetOf = steamAppId == null ? null : steamStoreSheetOf;
        if (steamAppId != null) {
          prefetchSteamStore?.call(steamAppId);
        }
        return DefaultTabController(
          length: achievementsOf == null ? 2 : 3,
          child: Scaffold(
            appBar: AppBar(
              actions: [
                if (onMoveItem case final moveItem?) IconButton(tooltip: l10n.moveItem, icon: const Icon(Icons.drive_file_move_outline), onPressed: () => moveItem(item)),
                if (onEditItem != null) IconButton(tooltip: l10n.editAction, icon: const Icon(Icons.edit_outlined), onPressed: () => onEditItem!(item.id)),
              ],
            ),
            body: CustomScrollView(
              slivers: [
                SliverPadding(
                  padding: isDeck && deckCardsOf != null ? listPadding.copyWith(bottom: 0) : listPadding,
                  sliver: SliverList.list(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(6),
                            child: SizedBox(
                              width: isCard ? 100 : 120,
                              height: isCard ? 100 / DeckCardGrid.cardAspectRatio : 120,
                              child: switch (ColoredBox(color: Color(item.spineColorValue ?? state.category?.colorValue ?? AkashicColors.surface.toARGB32()))) {
                                final placeholder when imagePath == null => placeholder,
                                final placeholder => Image.file(File(imagePath), fit: BoxFit.cover, cacheWidth: 400, errorBuilder: (context, error, stack) => placeholder),
                              },
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (path.isNotEmpty) Text(path, style: AkashicTypography.body(size: 12).copyWith(color: AkashicColors.textSoft)),
                                Text.rich(
                                  TextSpan(
                                    text: displayTitle,
                                    style: AkashicTypography.displayTitle(size: 28),
                                    children: [
                                      if (item.volumeNumber != null) ...[
                                        const TextSpan(text: ' '),
                                        TextSpan(
                                          text: '${item.volumeNumber}',
                                          style: AkashicTypography.numeral(size: 22).copyWith(color: AkashicColors.text),
                                        ),
                                      ],
                                    ],
                                  ),
                                ),
                                if (item.creator != null) Text(item.creator!, style: AkashicTypography.body().copyWith(color: AkashicColors.textSoft)),
                                if (metadata.isNotEmpty) Text(metadata, style: AkashicTypography.body(size: 12).copyWith(color: AkashicColors.textSoft)),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      StarRating(rating: item.rating, onChanged: detail.rate),
                      if (preorderPanelOf case final preorderPanel?) preorderPanel(item),
                      if (tagsEditorOf case final tagsEditor?) tagsEditor(item.id),
                      const SizedBox(height: 12),
                      if (tracksProgress(state.category?.type) && (achievementsOf == null || steamStatsOf == null)) ProgressSection(progress: item.progress, categoryType: state.category?.type, onChanged: detail.setProgress),
                      if ((item.cardKind, item.sourceKey, item.externalWorkId, sealedPriceOf, onRefreshSealedPrices) case (CardKind.sealed, sealedSourceKey, final productId?, final priceOf?, final refresh?))
                        SealedPriceSection(
                          key: ValueKey(productId),
                          watchPrice: () => priceOf(productId),
                          onRefresh: refresh,
                          hasOpenedCopy: state.copies.any((copy) => copy.isOpened),
                          watchAlert: switch (priceAlerts) {
                            final alerts? => () => alerts.watch(item.id),
                            null => null,
                          },
                          onSaveAlert: switch (priceAlerts) {
                            final alerts? => (thresholdCents, isAbove) => alerts.save(PriceAlert(itemId: item.id, thresholdCents: thresholdCents, isAbove: isAbove)),
                            null => null,
                          },
                          onRemoveAlert: switch (priceAlerts) {
                            final alerts? => () => alerts.remove(item.id),
                            null => null,
                          },
                        ),
                      if (item.cardKind == CardKind.deck)
                        Wrap(
                          spacing: 4,
                          children: [
                            if (onEditDeck case final editDeck?)
                              TextButton.icon(
                                onPressed: () => editDeck(item.id),
                                icon: const Icon(Icons.style_outlined, color: AkashicColors.teal),
                                label: Text(
                                  l10n.editDeck,
                                  style: AkashicTypography.body(weight: FontWeight.w600).copyWith(color: AkashicColors.teal),
                                ),
                              ),
                          ],
                        ),
                      if (item.seriesId != null && onOpenSeries != null)
                        Align(
                          alignment: Alignment.centerLeft,
                          child: TextButton.icon(
                            onPressed: () => onOpenSeries!(item.seriesId!),
                            icon: const Icon(Icons.collections_bookmark_outlined, color: AkashicColors.teal),
                            label: Text(
                              l10n.seeSeries,
                              style: AkashicTypography.body(weight: FontWeight.w600).copyWith(color: AkashicColors.teal),
                            ),
                          ),
                        ),
                      if (isDeck) ...[
                        ...myInfo,
                      ] else ...[
                        TabBar(
                          labelPadding: const EdgeInsets.symmetric(horizontal: 8),
                          isScrollable: MediaQuery.textScalerOf(context).scale(14) > 18,
                          tabAlignment: MediaQuery.textScalerOf(context).scale(14) > 18 ? TabAlignment.start : null,
                          tabs: [
                            for (final label in [l10n.myInfo, if (achievementsOf != null) l10n.achievementsTab, l10n.learnMore]) Tab(child: Text(label, maxLines: 1)),
                          ],
                        ),
                        Builder(
                          builder: (tabContext) {
                            final tabs = DefaultTabController.of(tabContext);
                            return AnimatedBuilder(
                              animation: tabs,
                              builder: (context, _) => switch ((tabs.index, achievementsOf)) {
                                (0, final loadAchievements?) when steamStatsOf != null => Column(
                                    crossAxisAlignment: CrossAxisAlignment.stretch,
                                    children: [
                                      SteamDashboardSection(
                                        key: ValueKey('dashboard-${item.id}'),
                                        watchStats: () => steamStatsOf!(item.id),
                                        loadAchievements: () => loadAchievements(steamAppId!),
                                        status: item.progress?.status,
                                        onStatusChanged: (status) => detail.setProgress(ItemProgress(status: status)),
                                        onOpenAchievements: () => tabs.animateTo(1),
                                        copy: SteamCopySummary(platform: 'Steam · ${item.groupKey ?? 'PC'}', pricePaidCents: state.copies.firstOrNull?.pricePaidCents, addedAt: item.addedAt),
                                      ),
                                      ...myInfo,
                                    ],
                                  ),
                                (0, _) => Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: myInfo),
                                (1, final loadAchievements?) => SteamAchievementsTab(key: ValueKey('achievements-$steamAppId'), load: () => loadAchievements(steamAppId!)),
                                _ when storeSheetOf != null => SteamStoreTab(
                                    key: ValueKey('store-$steamAppId'),
                                    load: () => storeSheetOf(steamAppId!),
                                    loadDlcs: switch (steamStoreDlcsOf) {
                                      final dlcsOf? => () => dlcsOf(steamAppId!),
                                      null => null,
                                    },
                                    onWishDlc: onWishSteamDlc,
                                  ),
                                _ => LearnMoreTab(
                                    details: state.details,
                                    isFetching: state.isFetchingDetails,
                                    canFetch: state.canFetchDetails,
                                    onRefresh: () => detail.refreshDetails(l10n.localeName),
                                    isEmbedded: true,
                                  ),
                              },
                            );
                          },
                        ),
                      ],
                    ],
                  ),
                ),
                if (isDeck)
                  if (deckCardsOf case final cardsOf?)
                    SliverPadding(
                      padding: listPadding.copyWith(top: 0),
                      sliver: DeckTabs(
                        key: ValueKey(item.id),
                        cards: cardsOf(item.id),
                        onFetchTraits: switch (onFetchCardTraits) {
                          final fetchTraits? => () => fetchTraits(item.id),
                          null => null,
                        },
                        onSetCommander: onSetCommander,
                        onSwapCommanders: switch (onSwapCommanders) {
                          final swap? => () => swap(item.id),
                          null => null,
                        },
                      ),
                    ),
              ],
            ),
          ),
        );
      },
    );
  }
}
