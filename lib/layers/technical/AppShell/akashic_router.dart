import 'package:akashic/layers/technical/Theme/akashic_empty_state.dart';
import 'dart:async';

import 'package:akashic/layers/functional/Wishes/domain/use_cases/describe_wish.dart';
import 'package:akashic/layers/functional/Check/presentation/widgets/scan_drawer.dart';
import 'package:akashic/layers/functional/Collection/presentation/widgets/precon_group_label.dart';
import 'package:akashic/layers/technical/Theme/safe_bottom_sheet.dart';
import 'package:akashic/layers/functional/Collection/domain/use_cases/precon_deck_library.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/card_kind.dart';
import 'package:akashic/layers/functional/Import/data/readers/spreadsheet_writer.dart';
import 'package:akashic/layers/functional/Import/domain/use_cases/export_collection_rows.dart';
import 'package:akashic/layers/functional/Collection/presentation/widgets/trade_channel_label.dart';
import 'package:akashic/layers/functional/Collection/presentation/widgets/condition_labels.dart';
import 'package:akashic/layers/functional/Collection/presentation/widgets/cover_badge.dart';
import 'package:akashic/layers/functional/Collection/domain/use_cases/add_another_item.dart';
import 'package:akashic/layers/functional/Collection/domain/use_cases/sealed_product_library.dart';
import 'package:akashic/layers/functional/SealedPrices/data/gateways/drift_price_alert_store.dart';
import 'package:akashic/layers/functional/SealedPrices/data/gateways/drift_sealed_price_store.dart';
import 'package:akashic/layers/technical/HttpAccess/metered_network.dart';
import 'package:akashic/layers/technical/Feedback/error_toasts.dart';
import 'package:akashic/layers/functional/Trades/data/gateways/drift_trade_gateway.dart';
import 'package:akashic/layers/functional/Trades/domain/use_cases/sell_copy.dart';
import 'package:akashic/layers/functional/Trades/presentation/cubit/trade_history_cubit.dart';
import 'package:akashic/layers/functional/Trades/presentation/views/trade_history_view.dart';
import 'package:akashic/layers/functional/Discoveries/domain/use_cases/describe_suggestion.dart';
import 'package:akashic/layers/functional/Releases/presentation/cubit/releases_cubit.dart';
import 'package:akashic/layers/functional/Releases/presentation/views/releases_view.dart';
import 'package:akashic/layers/functional/Backup/data/files/device_archive_files.dart';
import 'package:akashic/layers/functional/Backup/domain/use_cases/backup_use_cases.dart';
import 'package:akashic/layers/functional/Backup/presentation/cubit/backup_cubit.dart';
import 'package:akashic/layers/functional/Backup/presentation/views/backup_view.dart';
import 'package:akashic/layers/functional/Catalog/domain/entities/category.dart';
import 'package:akashic/layers/functional/Catalog/domain/entities/category_type.dart';
import 'package:akashic/layers/functional/Check/domain/use_cases/check_ownership.dart';
import 'package:akashic/layers/functional/Check/domain/use_cases/find_locally.dart';
import 'package:akashic/layers/functional/Check/domain/use_cases/suggest_category.dart';
import 'package:akashic/layers/functional/Check/presentation/cubit/chain_scan_cubit.dart';
import 'package:akashic/layers/functional/Check/presentation/views/chain_scan_view.dart';
import 'package:akashic/layers/functional/Check/presentation/widgets/barcode_scanner_panel.dart';
import 'package:akashic/layers/functional/Check/presentation/widgets/check_camera_panel.dart';
import 'package:akashic/layers/functional/Catalog/domain/use_cases/create_category.dart';
import 'package:akashic/layers/functional/Catalog/domain/use_cases/manage_categories.dart';
import 'package:akashic/layers/functional/Catalog/domain/use_cases/watch_category_tree.dart';
import 'package:akashic/layers/functional/Catalog/presentation/cubit/category_editor_cubit.dart';
import 'package:akashic/layers/functional/Catalog/presentation/views/category_editor_view.dart';
import 'package:akashic/layers/functional/Catalog/presentation/widgets/category_type_labels.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/item_copy.dart';
import 'package:akashic/layers/functional/Collection/domain/use_cases/update_card_prices.dart';
import 'package:akashic/layers/functional/Collection/domain/use_cases/bulk_item_actions.dart';
import 'package:akashic/layers/functional/Collection/domain/use_cases/add_copy.dart';
import 'package:akashic/layers/functional/Collection/domain/use_cases/add_item.dart';
import 'package:akashic/layers/functional/Collection/domain/use_cases/add_series_volumes.dart';
import 'package:akashic/layers/functional/Collection/domain/use_cases/create_series.dart';
import 'package:akashic/layers/functional/Collection/domain/use_cases/rate_item.dart';
import 'package:akashic/layers/functional/Collection/domain/use_cases/search_collection.dart';
import 'package:akashic/layers/functional/Collection/domain/use_cases/delete_copy.dart';
import 'package:akashic/layers/functional/Collection/domain/use_cases/manage_item_photos.dart';
import 'package:akashic/layers/functional/Collection/domain/use_cases/move_item.dart';
import 'package:akashic/layers/functional/Collection/presentation/widgets/move_item_sheet.dart';
import 'package:akashic/layers/functional/Collection/domain/use_cases/update_copy.dart';
import 'package:akashic/layers/functional/Collection/data/gateways/drift_deck_gateway.dart';
import 'package:akashic/layers/functional/Collection/domain/use_cases/manage_deck.dart';
import 'package:akashic/layers/functional/Collection/domain/use_cases/resolve_display_title.dart';
import 'package:akashic/layers/functional/Collection/domain/use_cases/series_volumes.dart';
import 'package:akashic/layers/functional/Collection/presentation/cubit/deck_editor_cubit.dart';
import 'package:akashic/layers/functional/Collection/presentation/views/deck_editor_view.dart';
import 'package:akashic/layers/functional/Lookup/domain/gateways/card_price_catalogue.dart';
import 'package:akashic/layers/functional/Lookup/domain/gateways/card_traits_catalogue.dart';
import 'package:akashic/layers/functional/Collection/domain/use_cases/analyze_deck.dart';
import 'package:akashic/layers/functional/Lookup/domain/gateways/card_search.dart';
import 'package:akashic/layers/functional/Lookup/domain/gateways/catalog_source.dart';
import 'package:akashic/layers/functional/Collection/domain/use_cases/update_item.dart';
import 'package:akashic/layers/functional/Collection/domain/use_cases/update_series_from_source.dart';
import 'package:akashic/layers/functional/Collection/presentation/cubit/series_detail_cubit.dart';
import 'package:akashic/layers/functional/Collection/presentation/views/series_detail_view.dart';
import 'package:akashic/layers/functional/Lookup/domain/gateways/series_info_source.dart';
import 'package:akashic/layers/functional/Collection/domain/use_cases/watch_category_series.dart';
import 'package:akashic/layers/functional/Collection/domain/use_cases/watch_item_detail.dart';
import 'package:akashic/layers/functional/Collection/domain/use_cases/watch_shelf.dart';
import 'package:akashic/layers/functional/Collection/presentation/cubit/category_shelves_cubit.dart';
import 'package:akashic/layers/functional/Collection/presentation/cubit/copy_editor_cubit.dart';
import 'package:akashic/layers/functional/Collection/presentation/cubit/home_shelves_cubit.dart';
import 'package:akashic/layers/functional/Collection/presentation/cubit/item_detail_cubit.dart';
import 'package:akashic/layers/functional/Collection/presentation/cubit/item_editor_cubit.dart';
import 'package:akashic/layers/functional/Collection/presentation/views/category_shelves_view.dart';
import 'package:akashic/layers/functional/Collection/presentation/views/copy_editor_sheet.dart';
import 'package:akashic/layers/functional/Collection/presentation/views/home_shelves_view.dart';
import 'package:akashic/layers/functional/Collection/presentation/views/missing_volumes_view.dart';
import 'package:akashic/layers/functional/Collection/presentation/cubit/tonight_cubit.dart';
import 'package:akashic/layers/functional/Collection/presentation/views/tonight_view.dart';
import 'package:akashic/layers/functional/Goals/presentation/cubit/goals_cubit.dart';
import 'package:akashic/layers/functional/Goals/presentation/views/goals_view.dart';
import 'package:akashic/layers/functional/Goals/presentation/widgets/goal_rings.dart';
import 'package:akashic/layers/functional/Stats/presentation/views/recap_view.dart';
import 'package:akashic/layers/functional/Activity/presentation/views/journal_view.dart';
import 'package:akashic/layers/functional/Covers/domain/use_cases/bulk_covers.dart';
import 'package:akashic/layers/functional/Covers/presentation/cubit/bulk_covers_cubit.dart';
import 'package:akashic/layers/functional/Covers/presentation/views/bulk_covers_view.dart';
import 'package:akashic/layers/functional/Friends/domain/use_cases/compare_collections.dart';
import 'package:akashic/layers/functional/Friends/presentation/views/compare_view.dart';
import 'package:akashic/layers/functional/Preorders/presentation/widgets/preorder_widgets.dart';
import 'package:akashic/layers/functional/Stats/presentation/views/merge_duplicates_view.dart';
import 'package:akashic/layers/functional/Releases/data/gateways/drift_release_store.dart';
import 'package:akashic/layers/functional/Releases/presentation/cubit/calendar_sync_cubit.dart';
import 'package:akashic/layers/functional/Releases/presentation/views/calendar_sync_view.dart';
import 'package:akashic/layers/functional/Budget/domain/entities/budget.dart';
import 'package:akashic/layers/functional/Budget/presentation/cubit/budget_cubit.dart';
import 'package:akashic/layers/functional/Budget/presentation/views/budget_view.dart';
import 'package:akashic/layers/functional/Budget/presentation/widgets/budget_gauge.dart';
import 'package:akashic/layers/functional/Inventory/presentation/views/insurance_view.dart';
import 'package:akashic/layers/functional/Organisation/domain/entities/smart_shelf.dart';
import 'package:akashic/layers/functional/Organisation/presentation/cubit/smart_shelves_cubit.dart';
import 'package:akashic/layers/functional/Organisation/presentation/cubit/storage_plan_cubit.dart';
import 'package:akashic/layers/functional/Organisation/presentation/views/storage_plan_view.dart';
import 'package:akashic/layers/functional/Organisation/presentation/widgets/item_tags_editor.dart';
import 'package:akashic/layers/functional/Organisation/presentation/widgets/smart_shelves_section.dart';
import 'package:akashic/layers/functional/Check/data/gateways/drift_scan_history_gateway.dart';
import 'package:akashic/layers/functional/Check/presentation/views/scan_history_view.dart';
import 'package:akashic/layers/functional/Collection/presentation/cubit/missing_volumes_cubit.dart';
import 'package:akashic/layers/functional/Collection/presentation/views/item_detail_view.dart';
import 'package:akashic/layers/functional/Collection/presentation/views/item_editor_view.dart';
import 'package:akashic/layers/functional/Discoveries/presentation/cubit/discoveries_cubit.dart';
import 'package:akashic/layers/functional/Discoveries/presentation/views/discoveries_view.dart';
import 'package:akashic/layers/functional/Loans/data/gateways/drift_loan_gateway.dart';
import 'package:akashic/layers/functional/Loans/domain/use_cases/lending.dart';
import 'package:akashic/layers/functional/Loans/presentation/cubit/loans_cubit.dart';
import 'package:akashic/layers/functional/Loans/presentation/views/loans_view.dart';
import 'package:akashic/layers/functional/Lookup/data/sources/discogs_collection_source.dart';
import 'package:akashic/layers/functional/Import/presentation/views/discogs_import_view.dart';
import 'package:akashic/layers/functional/Import/presentation/views/account_import_view.dart';
import 'package:akashic/layers/functional/Import/presentation/cubit/account_import_cubit.dart';
import 'package:akashic/layers/functional/Import/presentation/cubit/discogs_import_cubit.dart';
import 'package:akashic/layers/functional/Import/domain/use_cases/import_discogs_collection.dart';
import 'package:akashic/layers/functional/Import/data/readers/spreadsheet_reader.dart';
import 'package:akashic/layers/functional/Import/domain/use_cases/import_rows.dart';
import 'package:akashic/layers/functional/Import/presentation/cubit/import_cubit.dart';
import 'package:akashic/layers/functional/Import/presentation/views/import_view.dart';
import 'package:akashic/layers/functional/Lookup/domain/entities/source_match.dart';
import 'package:akashic/layers/functional/Lookup/domain/entities/source_unavailable.dart';
import 'package:akashic/layers/functional/Settings/domain/entities/preferred_languages.dart';
import 'package:akashic/layers/functional/Stats/data/gateways/drift_stats_gateway.dart';
import 'package:akashic/layers/functional/Stats/domain/use_cases/compute_collection_stats.dart';
import 'package:akashic/layers/functional/Stats/presentation/cubit/stats_cubit.dart';
import 'package:akashic/layers/functional/Stats/presentation/views/stats_view.dart';
import 'package:akashic/layers/functional/Stats/presentation/views/duplicates_view.dart';
import 'package:akashic/layers/functional/Stats/presentation/cubit/collection_value_cubit.dart';
import 'package:akashic/layers/functional/Stats/domain/use_cases/compute_collection_value.dart';
import 'package:akashic/layers/functional/Stats/domain/use_cases/refresh_collection_values.dart';
import 'package:akashic/layers/functional/Lookup/data/sources/discogs_marketplace.dart';
import 'package:akashic/layers/functional/Settings/domain/use_cases/manage_app_language.dart';
import 'package:akashic/layers/functional/Settings/domain/use_cases/manage_collapsed_series.dart';
import 'package:akashic/layers/functional/Settings/domain/use_cases/manage_preferred_languages.dart';
import 'package:akashic/layers/functional/Settings/presentation/cubit/settings_cubit.dart';
import 'package:akashic/layers/functional/Settings/presentation/views/settings_view.dart';
import 'package:akashic/layers/functional/SourceLimits/presentation/widgets/source_blocks_view.dart';
import 'package:akashic/layers/functional/Scans/domain/use_cases/scan_releases.dart';
import 'package:akashic/layers/functional/Scans/presentation/cubit/scan_follow_cubit.dart';
import 'package:akashic/layers/functional/Scans/presentation/cubit/scan_list_cubit.dart';
import 'package:akashic/layers/functional/Scans/presentation/views/scan_list_view.dart';
import 'package:akashic/layers/functional/Scans/presentation/widgets/scan_follow_panel.dart';
import 'package:akashic/layers/functional/Wishes/domain/entities/wish.dart';
import 'package:akashic/layers/functional/Wishes/domain/use_cases/remove_wish.dart';
import 'package:akashic/layers/functional/Wishes/domain/use_cases/wish_for_match.dart';
import 'package:akashic/layers/functional/Wishes/domain/use_cases/wish_missing_volumes.dart';
import 'package:akashic/layers/functional/Wishes/presentation/cubit/wishes_cubit.dart';
import 'package:akashic/layers/functional/Wishes/presentation/views/wishes_view.dart';
import 'package:akashic/layers/functional/Wishes/presentation/widgets/wish_fulfillment_listener.dart';
import 'package:akashic/layers/technical/HttpAccess/api_keys.dart';
import 'package:akashic/layers/technical/AppShell/dependency_scope.dart';
import 'package:akashic/layers/technical/AppShell/keyboard_focus.dart';
import 'package:akashic/layers/technical/AppShell/main_navigation_scaffold.dart';
import 'package:akashic/layers/technical/AppShell/resolved_once.dart';
import 'package:akashic/layers/technical/Localization/app_localizations.dart';
import 'package:akashic/layers/technical/MediaStorage/dominant_color_extractor.dart';
import 'package:akashic/layers/technical/MediaStorage/spreadsheet_files.dart';
import 'package:akashic/layers/functional/Steam/domain/use_cases/load_steam_store_sheet.dart';
import 'package:akashic/layers/functional/Wishes/domain/entities/wish_key.dart';
import 'package:akashic/layers/functional/Steam/domain/use_cases/compute_steam_collection_stats.dart';
import 'package:akashic/layers/functional/Import/presentation/widgets/sync_progress_banner.dart';
import 'package:akashic/layers/technical/AppShell/adaptive_home_layout.dart';
import 'package:akashic/layers/technical/Voice/voice_search_sheet.dart';
import 'package:akashic/layers/technical/AppShell/root_navigator.dart';
import 'package:akashic/layers/functional/Steam/domain/entities/steam_game_stats.dart';
import 'package:akashic/layers/technical/Theme/akashic_colors.dart';
import 'package:akashic/layers/functional/Settings/domain/use_cases/manage_recent_searches.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

GoRouter buildAkashicRouter(AkashicDependencies dependencies) {
  final watchShelf = WatchShelf(
    dependencies.collectionGateway,
    dependencies.categoryGateway,
    dependencies.settingsGateway,
    watchLastPlayed: () => dependencies.steamStats.watchAll().map((games) => {
          for (final game in games) game.itemId: ?game.lastPlayedAt,
        }),
  );
  final watchCategoryTree = WatchCategoryTree(dependencies.categoryGateway);
  final preferredLanguages = ManagePreferredLanguages(dependencies.settingsGateway);
  final scanHistory = DriftScanHistoryGateway(dependencies.database);
  final collapsedSeries = ManageCollapsedSeries(dependencies.settingsGateway);
  UpdateCardPrices updateCardPrices() => UpdateCardPrices(DriftDeckGateway(dependencies.database), [
        for (final source in dependencies.sourceRegistry.configuredFor(CategoryType.cards))
          if (source case final CardPriceCatalogue priceCatalogue) priceCatalogue,
      ]);
  CollectionValueCubit collectionValueCubit() => CollectionValueCubit(
        ComputeCollectionValue(dependencies.collectionGateway, DriftDeckGateway(dependencies.database), DriftStatsGateway(dependencies.database), dependencies.categoryGateway),
        RefreshCollectionValues(
          dependencies.collectionGateway,
          dependencies.categoryGateway,
          DiscogsMarketplace(dependencies.discogsClient, token: ApiKeys.discogsToken),
          updateCardPrices(),
        ),
        preferredLanguages: preferredLanguages.current,
      )..start();
  final checkOwnership = CheckOwnership(
    FindLocally(dependencies.collectionGateway),
    dependencies.sourceRegistry,
    dependencies.collectionGateway,
    dependencies.categoryGateway,
  );
  final addFromMatch = dependencies.addFromMatch;

  Future<List<SourceMatch>> lookupBarcode(String normalizedBarcode) async {
    for (final source in [...dependencies.sourceRegistry.barcodeSources(normalizedBarcode), ...dependencies.sourceRegistry.barcodeFallbacksFor(normalizedBarcode)]) {
      try {
        final matches = await source.lookupBarcode(normalizedBarcode);
        if (matches.isNotEmpty) {
          return matches;
        }
      } on SourceUnavailable {
        continue;
      }
    }
    return const [];
  }

  Future<List<Category>> loadLeafCategories() async => [
        for (final node in await dependencies.categoryGateway.watchTree().first)
          ...(node.children.isEmpty ? [node.category] : node.children),
      ];

  final fulfilledWishes = dependencies.watchFulfilledWishes();
  final loanGateway = DriftLoanGateway(dependencies.database);

  Future<void> lendCopy(BuildContext context, ItemCopy copy) async {
    final terms = await askLoanTerms(context);
    if (terms != null) {
      await LendCopy(loanGateway, activityLog: dependencies.activityLog)(copy.id, terms.borrower, dueOn: terms.dueOn, remindsAtDue: terms.remindsAtDue, followsUp: terms.followsUp);
      unawaited(dependencies.loanNotifier.requestPermission());
    }
  }

  Future<void> wishMatch(SourceMatch match, {String? categoryId}) async {
    final languages = await preferredLanguages.current();
    await dependencies.addWish(wishDraftForMatch(
      match,
      title: resolveDisplayTitle(match.titles, languages) ?? '',
      origin: WishOrigin.search,
      categoryId: categoryId,
    ));
  }

  Future<CategoryType?> categoryTypeOfSeries(String seriesId) async {
    final series = (await dependencies.collectionGateway.watchAllSeries().first).where((candidate) => candidate.id == seriesId).firstOrNull;
    return series == null ? null : (await dependencies.categoryGateway.findById(series.categoryId))?.type;
  }

  Widget scansTabFor(String seriesId) => BlocProvider(
        create: (_) => ScanFollowCubit(
          seriesId: seriesId,
          scans: dependencies.scanGateway,
          searchReleaseSeries: SearchReleaseSeries(dependencies.mangaUpdatesSource),
          linkReleaseSeries: LinkReleaseSeries(dependencies.scanGateway),
          refreshScanReleases: dependencies.refreshScanReleases,
          notifier: dependencies.chapterNotifier,
        )..start(),
        child: const ScanFollowPanel(),
      );

  void openCheck(BuildContext context) {
    Navigator.of(context, rootNavigator: true).push(MaterialPageRoute<void>(
      fullscreenDialog: true,
      builder: (checkContext) => BlocProvider(
        create: (_) => ChainScanCubit(
          checkOwnership,
          addFromMatch,
          SuggestCategory(dependencies.categoryGateway, collection: dependencies.collectionGateway),
          coverTextReader: dependencies.coverTextReader,
          shelfSpineReader: dependencies.shelfSpineReader,
          findWishFor: dependencies.findWishFor,
          addWish: dependencies.addWish,
          addAnother: (itemId, {barcode}) => AddAnotherItem(dependencies.collectionGateway, decks: DriftDeckGateway(dependencies.database))(itemId, barcode: barcode),
          history: scanHistory,
        ),
        child: ChainScanView(
          cameraBuilder: (onBarcode, onPhoto, onShelfPhoto) => CheckCameraPanel(onBarcode: onBarcode, onPhoto: onPhoto, onShelfPhoto: onShelfPhoto, shutterBottomSpace: scanDrawerPeekHeight + 16),
          onSeeItem: (itemId) => checkContext.push('/items/$itemId'),
          pickCategory: (pickerContext, current) async {
            final tree = await dependencies.categoryGateway.watchTree().first;
            if (!pickerContext.mounted) {
              return null;
            }
            return pickTargetCategory(pickerContext, tree: tree, currentCategoryId: current?.id ?? '');
          },
          onClose: () => Navigator.of(checkContext).pop(),
          listenVoice: (voiceContext) => listenForSearch(voiceContext, dependencies.voiceListener),
          budgetLine: StreamBuilder<BudgetStatus>(stream: dependencies.computeBudget.watch(), builder: (context, snapshot) => BudgetScanLine(status: snapshot.data)),
        ),
      ),
    ));
  }


  Future<void> refreshSealedPricesInteractively(BuildContext context) async {
    final l10n = AppLocalizations.of(context);
    if (await isOnMeteredNetwork()) {
      final size = await dependencies.refreshSealedPrices.downloadSize();
      if (!context.mounted) {
        return;
      }
      final isConfirmed = await showDialog<bool>(
        context: context,
        builder: (dialogContext) => AlertDialog(
          title: Text(l10n.meteredDownloadTitle),
          content: Text(size > 0 ? l10n.meteredDownloadBody(megabytesLabel(size, l10n.localeName)) : l10n.meteredDownloadUnknownSize),
          actions: [
            TextButton(onPressed: () => Navigator.of(dialogContext).pop(false), child: Text(l10n.cancel)),
            FilledButton(onPressed: () => Navigator.of(dialogContext).pop(true), child: Text(l10n.continueAnyway)),
          ],
        ),
      );
      if (!(isConfirmed ?? false)) {
        return;
      }
    }
    try {
      final priced = await dependencies.refreshSealedPrices();
      ErrorToasts.instance.show((l10n) => l10n.sealedPricesUpdated(priced));
    } on SourceUnavailable {
      ErrorToasts.instance.show((l10n) => l10n.sealedPricesUnavailable);
    }
  }

  Future<void> openCopyEditor(BuildContext context, ItemCopy copy, List<String> parts) async {
    final item = await dependencies.collectionGateway.watchItem(copy.itemId).first;
    if (!context.mounted) {
      return;
    }
    final deleteCopy = DeleteCopy(dependencies.collectionGateway, deleteImage: dependencies.imageStore.delete);
    final sellCopy = SellCopy(dependencies.collectionGateway, DriftTradeGateway(dependencies.database), deleteCopy);
    final deletion = await showSafeBottomSheet<CopyDeletion>(
      context: context,
      isScrollControlled: true,
      builder: (context) => BlocProvider(
        create: (_) => CopyEditorCubit(
          UpdateCopy(dependencies.collectionGateway),
          copy,
          parts: parts,
          deleteCopy: deleteCopy,
          sellCopy: (soldCopy, sale) => sellCopy(soldCopy, salePriceCents: sale.priceCents, soldOn: sale.soldOn, channel: sale.channel),
          tracksSealing: item?.cardKind == CardKind.sealed,
        )..start(),
        child: CopyEditorSheet(
          pickPlace: (sheetContext) async {
            final places = await dependencies.storagePlanGateway.watchAll().first;
            return sheetContext.mounted ? pickStoragePlace(sheetContext, places) : null;
          },
        ),
      ),
    );
    if (deletion == CopyDeletion.wholeItem && context.mounted) {
      context.pop();
    }
  }

  Widget itemDetailPage(String itemId) => BlocProvider(
      create: (_) => ItemDetailCubit(
        itemId: itemId,
        watchItemDetail: WatchItemDetail(dependencies.collectionGateway),
        watchCategoryTree: watchCategoryTree,
        preferredLanguages: preferredLanguages,
        rateItem: RateItem(dependencies.collectionGateway),
        addCopy: AddCopy(dependencies.collectionGateway),
        setItemProgress: dependencies.setItemProgress,
        manageItemPhotos: ManageItemPhotos(dependencies.collectionGateway, storeImage: dependencies.imageStore.save, deleteImage: dependencies.imageStore.delete),
        imagePicker: dependencies.imagePicker,
        fetchItemDetails: dependencies.fetchItemDetails,
      )..start(),
      child: Builder(
        builder: (context) => ItemDetailView(
          tagsEditorOf: (itemId) => ItemTagsEditor(itemId: itemId, tags: dependencies.tagGateway),
          preorderPanelOf: (item) => PreorderPanel(item: item, manage: dependencies.managePreorder),
          onEditCopy: (copy, parts) => openCopyEditor(context, copy, parts),
          onEditItem: (itemId) => context.push('/items/$itemId/edit'),
          onOpenSeries: (seriesId) => context.push('/series/$seriesId'),
          onEditDeck: (itemId) => context.push('/items/$itemId/deck'),
          deckCardsOf: DriftDeckGateway(dependencies.database).watchCards,
          onFetchCardTraits: switch (dependencies.sourceRegistry.configuredFor(CategoryType.cards).whereType<CardTraitsCatalogue>().firstOrNull) {
            final catalogue? => FetchCardTraits(DriftDeckGateway(dependencies.database), catalogue).call,
            null => null,
          },
          onSetCommander: (cardId, role) => ManageDeck(DriftDeckGateway(dependencies.database)).setCommanderRole(cardId, role),
          onSwapCommanders: (itemId) => ManageDeck(DriftDeckGateway(dependencies.database)).swapCommanders(itemId),
          steamAchievementsOf: dependencies.loadSteamAchievements.call,
          steamStoreSheetOf: dependencies.loadSteamStoreSheet.call,
          steamStoreDlcsOf: dependencies.loadSteamStoreSheet.dlcsOf,
          prefetchSteamStore: dependencies.loadSteamStoreSheet.prefetch,
          steamStatsOf: dependencies.steamStats.watch,
          sealedPriceOf: DriftSealedPriceStore(dependencies.database).watchPrice,
          onRefreshSealedPrices: () => refreshSealedPricesInteractively(context),
          priceAlerts: DriftPriceAlertStore(dependencies.database),
          onWishSteamDlc: (dlc) => dependencies.addWish(WishDraft(
            categoryType: CategoryType.videoGames,
            title: dlc.name,
            origin: WishOrigin.manual,
            key: WishKey(sourceKey: LoadSteamStoreSheet.steamSourceKey, externalWorkId: dlc.appId),
            imageUrl: dlc.imageUrl,
          )),
          onLendCopy: (copy) => lendCopy(context, copy),
          onAddAnother: (itemId) async {
            final messenger = ScaffoldMessenger.of(context);
            final l10n = AppLocalizations.of(context);
            final router = GoRouter.of(context);
            final anotherId = await AddAnotherItem(dependencies.collectionGateway, decks: DriftDeckGateway(dependencies.database))(itemId);
            if (anotherId == null || !context.mounted) {
              return;
            }
            messenger
              ..hideCurrentSnackBar()
              ..showSnackBar(SnackBar(
                behavior: SnackBarBehavior.floating,
                content: Text(l10n.anotherItemAdded),
                action: SnackBarAction(label: l10n.seeItem, onPressed: () => router.push('/items/$anotherId')),
              ));
          },
          onReturnCopy: (copy) => ReturnCopy(loanGateway, activityLog: dependencies.activityLog)(copy.id),
          onMoveItem: (item) => moveItemInteractively(
            context,
            item: item,
            loadTree: () => dependencies.categoryGateway.watchTree().first,
            moveItem: MoveItem(dependencies.collectionGateway),
          ),
        ),
      ),
    );

  return GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: '/',
    observers: [KeyboardFocusDropper()],
    routes: [
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) => WishFulfillmentListener(
          fulfilledWishes: fulfilledWishes,
          child: MainNavigationScaffold(
            navigationShell: navigationShell,
            statusBanner: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SyncProgressBanner(progress: dependencies.syncLinkedAccounts.progress, initialProgress: dependencies.syncLinkedAccounts.currentProgress),
                SourceBlocksBanner(blocks: dependencies.sourceBlocks),
              ],
            ),
          ),
        ),
        branches: [
          StatefulShellBranch(routes: [
            GoRoute(
              path: '/',
              builder: (context, state) => AdaptiveHomeLayout(
                pushItem: (itemId) => context.push('/items/$itemId'),
                detail: itemDetailPage,
                home: (openItem) => BlocProvider(
                create: (_) => HomeShelvesCubit(
                  watchCategoryTree: watchCategoryTree,
                  watchShelf: watchShelf,
                  searchCollection: SearchCollection(dependencies.collectionGateway),
                  recentSearches: ManageRecentSearches(dependencies.settingsGateway),
                  preferredLanguages: preferredLanguages,
                  collapsedSeries: collapsedSeries,
                )..start(),
                child: HomeShelvesView(
                  onOpenCategory: (categoryId) => context.push('/categories/$categoryId'),
                  onCreateCategory: () => context.push('/categories/new'),
                  onOpenSettings: () => context.push('/settings'),
                  onOpenItem: (item) => openItem(item.id),
                  onOpenLoans: () => context.push('/loans'),
                  onOpenStats: () => context.push('/stats'),
                  onOpenMissingVolumes: () => context.push('/missing-volumes'),
                  onOpenScanHistory: () => context.push('/scan-history'),
                  onOpenTonight: () => context.push('/tonight'),
                  onOpenGoals: () => context.push('/goals'),
                  onOpenRecap: () => context.push('/recap'),
                  onOpenJournal: () => context.push('/journal'),
                  onOpenStoragePlan: () => context.push('/storage-plan'),
                  onOpenWhereIs: () => context.push('/where-is'),
                  onOpenBudget: () => context.push('/budget'),
                  onOpenInsurance: () => context.push('/insurance'),
                  onOpenCompare: () => context.push('/compare'),
                  onOpenMissingCovers: () => context.push('/covers'),
                  preordersSection: PreordersSection(collection: dependencies.collectionGateway, onOpenItem: openItem),
                  listenVoice: (voiceContext) => listenForSearch(voiceContext, dependencies.voiceListener),
                  isOffline: dependencies.offline,
                  smartShelvesSection: BlocProvider(
                    create: (_) => SmartShelvesCubit(dependencies.smartShelfGateway, dependencies.collectionGateway, dependencies.categoryGateway, dependencies.tagGateway)..start(),
                    child: SmartShelvesSection(onOpenShelf: (shelfId) => context.push('/smart-shelves/$shelfId'), onOpenItem: (item) => context.push('/items/${item.id}')),
                  ),
                  goalsStrip: BlocProvider(
                    create: (_) => GoalsCubit(dependencies.goalStore, dependencies.computeGoalProgress, dependencies.categoryGateway)..start(),
                    child: BlocBuilder<GoalsCubit, GoalsState>(builder: (context, goals) => GoalRings(progress: goals.progress, onOpen: () => context.push('/goals'))),
                  ),
                  onCheck: () => openCheck(context),
                  onSearchOnline: (query, categoryId) => categoryId == null ? null : context.push(Uri(path: '/categories/$categoryId/add', queryParameters: {'query': query}).toString()),
                ),
              ),
              ),
            ),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
              path: '/wishes',
              builder: (context, state) => BlocProvider(
                create: (_) => WishesCubit(dependencies.wishGateway, RemoveWish(dependencies.wishGateway))..start(),
                child: WishesView(describeWish: DescribeWish(dependencies.fetchItemDetails), steamWatches: dependencies.steamWatchStore.watchWishWatches()),
              ),
            ),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
              path: '/discoveries',
              builder: (context, state) {
                final languageCode = Localizations.localeOf(context).languageCode;
                return BlocProvider(
                  create: (_) => DiscoveriesCubit(
                    buildDiscoveries: dependencies.buildDiscoveries,
                    dismissSuggestion: dependencies.dismissSuggestion,
                    wishes: dependencies.wishGateway,
                    addWish: dependencies.addWish,
                    languageCode: () => languageCode,
                    preferredLanguages: preferredLanguages.current,
                  )..start(),
                  child: DiscoveriesView(describeSuggestion: DescribeSuggestion(dependencies.fetchItemDetails)),
                );
              },
            ),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
              path: '/releases',
              builder: (context, state) => BlocProvider(
                create: (_) => ReleasesCubit(dependencies.findUpcomingReleases, dependencies.releaseNotifier)..start(),
                child: ReleasesView(onOpenCalendarSync: () => context.push('/calendar-sync')),
              ),
            ),
          ]),
        ],
      ),
      GoRoute(
        path: '/stats',
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) => MultiBlocProvider(
          providers: [
            BlocProvider(create: (_) => StatsCubit(ComputeCollectionStats(DriftStatsGateway(dependencies.database), dependencies.categoryGateway, collection: dependencies.collectionGateway))..start()),
            BlocProvider(create: (_) => collectionValueCubit()),
          ],
          child: StatsView(
            onOpenDuplicates: () => context.push('/stats/duplicates'),
            onOpenTrades: () => context.push('/trades'),
            loadValueTrend: dependencies.computeValueTrend.call,
            onOpenMissingVolumes: () => context.push('/missing-volumes'),
            steamStats: ComputeSteamCollectionStats(dependencies.steamStats, dependencies.collectionGateway)(),
            onOpenItem: (itemId) => context.push('/items/$itemId'),
          ),
        ),
      ),
      GoRoute(
        path: '/stats/duplicates',
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) => BlocProvider(
          create: (_) => collectionValueCubit(),
          child: Builder(
            builder: (duplicatesContext) => DuplicatesView(
              onOpenItem: (itemId) => context.push('/items/$itemId'),
              onMerge: (first, second) => Navigator.of(duplicatesContext).push(MaterialPageRoute<void>(
                builder: (_) => MergeDuplicatesView(
                  first: first,
                  second: second,
                  loadCopy: (itemId) async => (await dependencies.collectionGateway.watchCopies(itemId).first).firstOrNull,
                  merge: (plan) async {
                    await dependencies.mergeItems(first, second, plan);
                    if (duplicatesContext.mounted) {
                      await duplicatesContext.read<CollectionValueCubit>().start();
                    }
                  },
                ),
              )),
            ),
          ),
        ),
      ),
      GoRoute(
        path: '/trades',
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) => BlocProvider(
          create: (_) => TradeHistoryCubit(DriftTradeGateway(dependencies.database), preferredLanguages: preferredLanguages)..start(),
          child: TradeHistoryView(onOpenItem: (itemId) => context.push('/items/$itemId')),
        ),
      ),
      GoRoute(
        path: '/scan-history',
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) => ScanHistoryView(sessions: scanHistory.watchAll(), onOpenSession: (sessionId) => context.push('/scan-history/$sessionId')),
      ),
      GoRoute(
        path: '/scan-history/:sessionId',
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) => ScanSessionView(
          session: scanHistory.watchAll().map((sessions) => sessions.where((session) => session.id == state.pathParameters['sessionId']).firstOrNull),
          onOpenItem: (itemId) => context.push('/items/$itemId'),
        ),
      ),
      GoRoute(
        path: '/smart-shelves/:shelfId',
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) => BlocProvider(
          create: (_) => SmartShelvesCubit(dependencies.smartShelfGateway, dependencies.collectionGateway, dependencies.categoryGateway, dependencies.tagGateway)..start(),
          child: SmartShelfView(shelfId: state.pathParameters['shelfId']!, onOpenItem: (item) => context.push('/items/${item.id}')),
        ),
      ),
      GoRoute(
        path: '/storage-plan',
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) => BlocProvider(
          create: (_) => StoragePlanCubit(dependencies.storagePlanGateway, dependencies.collectionGateway)..start(),
          child: StoragePlanView(onWhereIs: () => context.push('/where-is')),
        ),
      ),
      GoRoute(
        path: '/where-is',
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) => BlocProvider(
          create: (_) => StoragePlanCubit(dependencies.storagePlanGateway, dependencies.collectionGateway)..start(),
          child: WhereIsView(onOpenItem: (itemId) => context.push('/items/$itemId')),
        ),
      ),
      GoRoute(
        path: '/calendar-sync',
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) => BlocProvider(
          create: (_) => CalendarSyncCubit(
            dependencies.calendarSyncStore,
            dependencies.calendarWriter,
            DriftReleaseStore(dependencies.database),
            dependencies.syncReleaseCalendar,
            newCalendarName: AppLocalizations.of(context).calendarDefaultName,
          )..start(),
          child: const CalendarSyncView(),
        ),
      ),
      GoRoute(
        path: '/compare',
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) => CompareView(
          pickAndCompare: () async {
            final file = await DeviceSpreadsheetFiles().pick();
            if (file == null) {
              return null;
            }
            return dependencies.compareCollections(friendWorksOf(readSpreadsheet(file.name, file.bytes)));
          },
        ),
      ),
      GoRoute(
        path: '/covers',
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) => BlocProvider(
          create: (_) => BulkCoversCubit(
            FindCoverlessItems(dependencies.collectionGateway, dependencies.categoryGateway),
            ProposeCovers(dependencies.imageSearch),
            AcceptCover(dependencies.coverGateway, dependencies.collectionGateway),
          )..load(),
          child: const BulkCoversView(),
        ),
      ),
      GoRoute(
        path: '/budget',
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) => BlocProvider(
          create: (_) => BudgetCubit(dependencies.computeBudget, dependencies.budgetStore, dependencies.collectionGateway)..start(),
          child: BudgetView(onOpenItem: (itemId) => context.push('/items/$itemId')),
        ),
      ),
      GoRoute(
        path: '/insurance',
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) => InsuranceView(loadInventory: dependencies.loadInsuranceInventory.call),
      ),
      GoRoute(
        path: '/journal',
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) => JournalView(loadJournal: dependencies.buildJournal.call, onOpenItem: (itemId) => context.push('/items/$itemId')),
      ),
      GoRoute(
        path: '/tonight',
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) => BlocProvider(
          create: (_) => TonightCubit(dependencies.collectionGateway, dependencies.categoryGateway, dependencies.fetchItemDetails.cached, dependencies.setItemProgress)..load(),
          child: TonightView(onOpenItem: (itemId) => context.push('/items/$itemId')),
        ),
      ),
      GoRoute(
        path: '/goals',
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) => BlocProvider(
          create: (_) => GoalsCubit(dependencies.goalStore, dependencies.computeGoalProgress, dependencies.categoryGateway)..start(),
          child: const GoalsView(),
        ),
      ),
      GoRoute(
        path: '/recap',
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) => RecapView(loadMonth: dependencies.computeRecap.month, onOpenYear: (year) => context.push('/recap/$year'), now: DateTime.now()),
      ),
      GoRoute(
        path: '/recap/:year',
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) => YearPosterView(year: int.parse(state.pathParameters['year']!), loadYear: dependencies.computeRecap.year),
      ),
      GoRoute(
        path: '/missing-volumes',
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) => BlocProvider(
          create: (_) => MissingVolumesCubit(
            dependencies.collectionGateway,
            dependencies.wishGateway,
            WishMissingVolumes(dependencies.wishGateway, dependencies.addWish, dependencies.categoryGateway),
            preferredLanguages: preferredLanguages,
          )..start(),
          child: MissingVolumesView(onOpenSeries: (seriesId) => context.push('/series/$seriesId')),
        ),
      ),
      GoRoute(
        path: '/loans',
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) => BlocProvider(
          create: (_) => LoansCubit(WatchLoans(loanGateway), ReturnCopy(loanGateway, activityLog: dependencies.activityLog), preferredLanguages: preferredLanguages)..start(),
          child: LoansView(onOpenItem: (itemId) => context.push('/items/$itemId')),
        ),
      ),
      GoRoute(
        path: '/settings',
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) => BlocProvider(
          create: (_) => SettingsCubit(preferredLanguages, ManageAppLanguage(dependencies.settingsGateway))..load(),
          child: SettingsView(
            onOpenImport: () => context.push('/import'),
            onOpenDiscogsImport: () => context.push('/import/discogs'),
            onOpenAccountImport: () => context.push('/import/accounts'),
            onOpenBackup: () => context.push('/backup'),
            onReplayTutorial: dependencies.requestTour,
            apiLimitsSection: SourceBlocksList(blocks: dependencies.sourceBlocks),
            highContrast: dependencies.settingsGateway.watchHighContrast(),
            onHighContrastChanged: dependencies.settingsGateway.saveHighContrast,
            onExportSpreadsheet: () async {
              final l10n = AppLocalizations.of(context);
              final messenger = ScaffoldMessenger.of(context);
              final rows = await ExportCollectionRows(dependencies.collectionGateway, dependencies.categoryGateway)(
                SpreadsheetWording(
                  headers: l10n.exportHeaders.split('|'),
                  conditionLabel: (condition) => condition.label(l10n),
                  channelLabel: (channel) => tradeChannelLabel(channel, l10n),
                ),
                await preferredLanguages.current(),
              );
              final today = DateTime.now();
              final fileName = 'akashic-${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}.csv';
              final isSaved = await DeviceSpreadsheetFiles().save(fileName, csvBytesOf(rows));
              messenger.showSnackBar(SnackBar(content: Text(isSaved ? l10n.exportSpreadsheetDone(rows.length - 1) : l10n.exportSpreadsheetFailed)));
            },
          ),
        ),
      ),
      GoRoute(
        path: '/backup',
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) => BlocProvider(
          create: (_) => BackupCubit(
            backUp: dependencies.backUpCollection,
            listBackups: ListRemoteBackups(dependencies.backupStorage),
            restore: RestoreCollection(dependencies.collectionArchiver, dependencies.backupStorage),
            storage: dependencies.backupStorage,
            status: dependencies.backupStatus,
            archiver: dependencies.collectionArchiver,
            exportCollection: ExportCollection(dependencies.collectionArchiver, DeviceArchiveFiles()),
            restoreFromFile: RestoreCollectionFromFile(dependencies.collectionArchiver, DeviceArchiveFiles()),
          )..start(),
          child: const BackupView(),
        ),
      ),
      GoRoute(
        path: '/import/discogs',
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) => ResolvedOnce<List<Category>>(
          resolve: () async => [for (final category in await loadLeafCategories()) if (category.type == CategoryType.music) category],
          builder: (context, musicCategories) => BlocProvider(
            create: (_) => DiscogsImportCubit(
              ImportDiscogsCollection(DiscogsCollectionSource(dependencies.discogsClient, token: ApiKeys.discogsToken), dependencies.collectionGateway, addFromMatch),
              musicCategories: musicCategories,
            ),
            child: const DiscogsImportView(),
          ),
        ),
      ),
      GoRoute(
        path: '/import/accounts',
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) => ResolvedOnce<List<Category>>(
          resolve: loadLeafCategories,
          builder: (context, categories) => BlocProvider(
            create: (_) => AccountImportCubit(
              dependencies.importAccountLibrary,
              linkedAccounts: dependencies.linkedAccounts,
              syncLinkedAccounts: dependencies.syncLinkedAccounts,
              libraries: dependencies.accountLibraries,
              categories: categories,
            ),
            child: AccountImportView(files: DeviceSpreadsheetFiles(), syncProgress: dependencies.syncLinkedAccounts.progress, initialSyncProgress: dependencies.syncLinkedAccounts.currentProgress),
          ),
        ),
      ),
      GoRoute(
        path: '/import',
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) => ResolvedOnce<List<Category>>(
          resolve: loadLeafCategories,
          builder: (context, categories) => BlocProvider(
            create: (_) => ImportCubit(
              readSpreadsheet: readSpreadsheet,
              resolveLine: ResolveImportLine(checkOwnership),
              importRows: ImportRows(
                addFromMatch,
                AddItem(dependencies.collectionGateway, dependencies.categoryGateway),
                dependencies.collectionGateway,
                dependencies.categoryGateway,
                CreateSeries(dependencies.collectionGateway),
              ),
            ),
            child: ImportView(categories: categories, files: DeviceSpreadsheetFiles()),
          ),
        ),
      ),
      GoRoute(
        path: '/categories/new',
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) => BlocProvider(
          create: (_) => CategoryEditorCubit(
            CreateCategory(dependencies.categoryGateway),
            localizePart: (kind) => kind.label(AppLocalizations.of(context)),
            deleteCategory: dependencies.categoryGateway.delete,
          ),
          child: const CategoryEditorView(),
        ),
      ),
      GoRoute(
        path: '/categories/:categoryId',
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) {
          final categoryId = state.pathParameters['categoryId']!;
          return BlocProvider(
            create: (_) => CategoryShelvesCubit(
              categoryId: categoryId,
              watchCategoryTree: watchCategoryTree,
              watchShelf: watchShelf,
              collapsedSeries: collapsedSeries,
              preferredLanguages: preferredLanguages,
              loadCopies: dependencies.collectionGateway.firstCopiesByItem,
              loadTags: dependencies.tagGateway.tagsByItem,
            )..start(),
            child: CategoryShelvesView(
              onSaveSmartShelf: (name, categoryId, filter) => dependencies.smartShelfGateway.save(SmartShelf(id: const Uuid().v4(), name: name, categoryId: categoryId, filter: filter)),
              onAddItem: (targetCategoryId) => context.push('/categories/$targetCategoryId/add'),
              manageCategories: ManageCategories(dependencies.categoryGateway, dependencies.collectionGateway, deleteImage: dependencies.imageStore.delete),
              bulkItemActions: BulkItemActions(dependencies.collectionGateway, deleteImage: dependencies.imageStore.delete),
              loadCategoryTree: () => dependencies.categoryGateway.watchTree().first,
              coverBadges: dependencies.steamStats.watchAll().map((allStats) {
                final l10n = AppLocalizations.of(rootNavigatorKey.currentContext ?? context);
                final deckLabels = (l10n.steamDeck, l10n.steamDeckVerified, l10n.steamDeckPlayable);
                return {
                  for (final stats in allStats)
                    if (stats.deckStatus == SteamDeckStatus.verified)
                      stats.itemId: CoverBadge(icon: Icons.verified, color: AkashicColors.teal, label: '${deckLabels.$1} · ${deckLabels.$2}')
                    else if (stats.deckStatus == SteamDeckStatus.playable)
                      stats.itemId: CoverBadge(icon: Icons.check_circle_outline, color: AkashicColors.gold, label: '${deckLabels.$1} · ${deckLabels.$3}'),
                };
              }),
              onOpenItem: (item) => context.push('/items/${item.id}'),
              onOpenSeries: (seriesId) => context.push('/series/$seriesId'),
              onAddSubcategory: (parent, name) => CreateCategory(dependencies.categoryGateway)(name: name, colorValue: parent.colorValue, type: parent.type, parentId: parent.id, conditionParts: parent.conditionParts),
              scansViewBuilder: (scansCategoryId) => BlocProvider(
                create: (_) => ScanListCubit(
                  categoryId: scansCategoryId,
                  scans: dependencies.scanGateway,
                  collection: dependencies.collectionGateway,
                  createSeries: CreateSeries(dependencies.collectionGateway),
                  preferredLanguages: preferredLanguages,
                )..start(),
                child: ScanListView(onOpenSeries: (seriesId) => context.push('/series/$seriesId')),
              ),
            ),
          );
        },
      ),
      GoRoute(
        path: '/categories/:categoryId/add',
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) {
          final categoryId = state.pathParameters['categoryId']!;
          return FutureBuilder(
            future: Future.wait([dependencies.categoryGateway.findById(categoryId), preferredLanguages.current()]),
            builder: (context, snapshot) {
              final loaded = snapshot.data;
              if (loaded == null) {
                return const Scaffold(body: Center(child: LabelledSpinner()));
              }
              final category = loaded[0] as Category?;
              final categoryName = category?.name ?? '';
              final onlineSources = category == null ? const <CatalogSource>[] : dependencies.sourceRegistry.forCategory(category);
              return BlocProvider(
                create: (_) => ItemEditorCubit(
                  categoryId: categoryId,
                  categoryType: category?.type ?? CategoryType.free,
                  preferredLanguages: loaded[1] as PreferredLanguages,
                  addItem: AddItem(dependencies.collectionGateway, dependencies.categoryGateway),
                  addSeriesVolumes: AddSeriesVolumes(dependencies.collectionGateway),
                  createSeries: CreateSeries(dependencies.collectionGateway),
                  imagePicker: dependencies.imagePicker,
                  imageStore: dependencies.imageStore,
                  extractColor: extractDominantColor,
                  onlineSources: onlineSources,
                  imageSearch: dependencies.imageSearch,
                  imageDownloader: dependencies.imageDownloader,
                  barcodeLookup: lookupBarcode,
                  preconDecks: offersPreconDecks(category, dependencies.preconDecks)
                      ? PreconDeckLibrary(dependencies.preconDecks, ManageDeck(DriftDeckGateway(dependencies.database)), groupOf: (deck) => preconGroupLabel(deck, AppLocalizations.of(context)))
                      : null,
                  sealedProducts: switch (sealedGameOf(category, dependencies.sealedProducts)) {
                    final game? => (query) => SealedProductLibrary(dependencies.sealedProducts).search(query, game),
                    null => null,
                  },
                )..watchExistingSeries(WatchCategorySeries(dependencies.collectionGateway)(categoryId))
                  ..searchOnline(state.uri.queryParameters['query'] ?? ''),
                child: ItemEditorView(
                  initialQuery: state.uri.queryParameters['query'] ?? '',
                  categoryName: categoryName,
                  barcodeScannerBuilder: (onBarcode) => BarcodeScannerPanel(onBarcode: onBarcode),
                  onWishMatch: (match) => wishMatch(match, categoryId: categoryId),
                ),
              );
            },
          );
        },
      ),
      GoRoute(
        path: '/items/:itemId/deck',
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) {
          final itemId = state.pathParameters['itemId']!;
          return FutureBuilder(
            future: () async {
              final item = await dependencies.collectionGateway.watchItem(itemId).first;
              final category = item == null ? null : await dependencies.categoryGateway.findById(item.categoryId);
              return (item, category);
            }(),
            builder: (context, snapshot) {
              final loaded = snapshot.data;
              if (loaded == null) {
                return const Scaffold(body: Center(child: LabelledSpinner()));
              }
              final cardSearches = [
                for (final source in loaded.$2 == null ? dependencies.sourceRegistry.configuredFor(CategoryType.cards) : dependencies.sourceRegistry.forCategory(loaded.$2!))
                  if (source case final CardSearch cardSearch) cardSearch,
              ];
              return BlocProvider(
                create: (_) => DeckEditorCubit(
                  itemId: itemId,
                  manageDeck: ManageDeck(DriftDeckGateway(dependencies.database)),
                  cardSearches: cardSearches,
                  preconDecks: offersPreconDecks(loaded.$2, dependencies.preconDecks) ? dependencies.preconDecks : null,
                  updateCardPrices: updateCardPrices(),
                  deckListSources: offersPreconDecks(loaded.$2, dependencies.preconDecks) ? [dependencies.archidektDecks] : const [],
                )..start(),
                child: DeckEditorView(deckName: loaded.$1 == null ? '' : resolveDisplayTitle(loaded.$1!.titles, PreferredLanguages.defaults) ?? ''),
              );
            },
          );
        },
      ),
      GoRoute(
        path: '/series/:seriesId',
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) {
          final aniList = dependencies.sourceRegistry.byKey('anilist');
          final seriesId = state.pathParameters['seriesId']!;
          return ResolvedOnce<CategoryType?>(
            key: ValueKey('series-$seriesId'),
            resolve: () => categoryTypeOfSeries(seriesId),
            builder: (context, seriesType) {
              return BlocProvider(
                create: (_) => SeriesDetailCubit(
                  seriesId: seriesId,
                  watchSeriesVolumes: WatchSeriesVolumes(dependencies.collectionGateway),
                  setPublishedVolumes: SetPublishedVolumes(dependencies.collectionGateway),
                  updateFromSource: aniList is SeriesInfoSource ? UpdateSeriesFromSource(dependencies.collectionGateway, aniList as SeriesInfoSource) : null,
                  preferredLanguages: preferredLanguages,
                  wishMissingVolumes: WishMissingVolumes(dependencies.wishGateway, dependencies.addWish, dependencies.categoryGateway),
                )..start(),
                child: SeriesDetailView(
                  onOpenItem: (item) => context.push('/items/${item.id}'),
                  canUpdateFromSource: aniList is SeriesInfoSource,
                  canWishMissingVolumes: true,
                  scansTabBuilder: seriesType == CategoryType.manga ? scansTabFor : null,
                ),
              );
            },
          );
        },
      ),
      GoRoute(
        path: '/items/:itemId/edit',
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) {
          final itemId = state.pathParameters['itemId']!;
          return FutureBuilder(
            future: () async {
              final item = await dependencies.collectionGateway.watchItem(itemId).first;
              final category = item == null ? null : await dependencies.categoryGateway.findById(item.categoryId);
              return (item, category, await preferredLanguages.current());
            }(),
            builder: (context, snapshot) {
              final loaded = snapshot.data;
              final item = loaded?.$1;
              if (loaded == null || item == null) {
                return const Scaffold(body: Center(child: LabelledSpinner()));
              }
              final type = loaded.$2?.type ?? CategoryType.free;
              return BlocProvider(
                create: (_) => ItemEditorCubit.edit(
                  item: item,
                  categoryType: type,
                  preferredLanguages: loaded.$3,
                  updateItem: UpdateItem(dependencies.collectionGateway),
                  addItem: AddItem(dependencies.collectionGateway, dependencies.categoryGateway),
                  addSeriesVolumes: AddSeriesVolumes(dependencies.collectionGateway),
                  createSeries: CreateSeries(dependencies.collectionGateway),
                  imagePicker: dependencies.imagePicker,
                  imageStore: dependencies.imageStore,
                  extractColor: extractDominantColor,
                  onlineSources: loaded.$2 == null ? dependencies.sourceRegistry.configuredFor(type) : dependencies.sourceRegistry.forCategory(loaded.$2!),
                  imageSearch: dependencies.imageSearch,
                  imageDownloader: dependencies.imageDownloader,
                ),
                child: ItemEditorView(categoryName: loaded.$2?.name ?? ''),
              );
            },
          );
        },
      ),
      GoRoute(
        path: '/items/:itemId',
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) => itemDetailPage(state.pathParameters['itemId']!),
      ),
    ],
  );
}
