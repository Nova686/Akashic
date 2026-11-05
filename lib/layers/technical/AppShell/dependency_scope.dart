import 'dart:io';

import 'package:akashic/layers/functional/Settings/domain/use_cases/manage_tutorial.dart';
import 'package:akashic/layers/functional/Settings/domain/use_cases/manage_preferred_languages.dart';
import 'package:akashic/layers/functional/Releases/data/calendars/release_calendars.dart';
import 'package:akashic/layers/functional/Releases/data/gateways/drift_release_store.dart';
import 'package:akashic/layers/functional/Releases/data/notifications/local_release_notifier.dart';
import 'package:akashic/layers/functional/Releases/domain/use_cases/find_upcoming_releases.dart';
import 'package:akashic/layers/functional/Catalog/domain/entities/category_type.dart';
import 'package:akashic/layers/functional/Backup/data/archive/zip_collection_archiver.dart';
import 'package:akashic/layers/functional/Backup/data/gateways/drift_backup_status_gateway.dart';
import 'package:akashic/layers/functional/Backup/data/gateways/google_drive_backup_storage.dart';
import 'package:akashic/layers/functional/Backup/domain/use_cases/backup_use_cases.dart';
import 'package:akashic/layers/functional/Catalog/data/gateways/drift_category_gateway.dart';
import 'package:akashic/layers/functional/Check/presentation/widgets/cover_text_reader.dart';
import 'package:akashic/layers/functional/Collection/data/gateways/drift_collection_gateway.dart';
import 'package:akashic/layers/functional/Discoveries/data/sources/title_resolving_recommendations.dart';
import 'package:akashic/layers/functional/Discoveries/domain/gateways/recommendation_source.dart';
import 'package:akashic/layers/functional/Discoveries/data/gateways/drift_discovery_cache.dart';
import 'package:akashic/layers/functional/Discoveries/data/gateways/drift_dismissed_suggestion_gateway.dart';
import 'package:akashic/layers/functional/Discoveries/data/sources/anilist_recommendations.dart';
import 'package:akashic/layers/functional/Discoveries/data/sources/discogs_recommendations.dart';
import 'package:akashic/layers/functional/Discoveries/data/sources/google_books_recommendations.dart';
import 'package:akashic/layers/functional/Discoveries/data/sources/igdb_similar_games.dart';
import 'package:akashic/layers/functional/Discoveries/data/sources/tmdb_recommendations.dart';
import 'package:akashic/layers/functional/Discoveries/domain/use_cases/build_discoveries.dart';
import 'package:akashic/layers/functional/Discoveries/domain/use_cases/dismiss_suggestion.dart';
import 'package:akashic/layers/functional/Details/data/gateways/drift_details_store.dart';
import 'package:akashic/layers/functional/Details/data/sources/anilist_details_source.dart';
import 'package:akashic/layers/functional/Details/data/sources/discogs_details_source.dart';
import 'package:akashic/layers/functional/Details/data/sources/google_books_details_source.dart';
import 'package:akashic/layers/functional/Details/data/sources/igdb_details_source.dart';
import 'package:akashic/layers/functional/Details/data/sources/tmdb_details_source.dart';
import 'package:akashic/layers/functional/Details/domain/use_cases/fetch_item_details.dart';
import 'package:akashic/layers/functional/Loans/data/gateways/drift_loan_gateway.dart';
import 'package:akashic/layers/functional/Loans/data/gateways/drift_loan_reminder_store.dart';
import 'package:akashic/layers/functional/Loans/data/notifications/local_loan_notifier.dart';
import 'package:akashic/layers/functional/Loans/domain/use_cases/remind_overdue_loans.dart';
import 'package:akashic/layers/functional/Lookup/data/image_search/combined_image_search.dart';
import 'package:akashic/layers/functional/Lookup/data/sources/cardmarket_catalogue.dart';
import 'package:akashic/layers/functional/Lookup/data/sources/mtgjson_precon_catalogue.dart';
import 'package:akashic/layers/functional/Lookup/data/sources/optcg_source.dart';
import 'package:akashic/layers/functional/Lookup/data/sources/deezer_source.dart';
import 'package:akashic/layers/functional/Lookup/data/sources/mangadex_source.dart';
import 'package:akashic/layers/functional/Lookup/data/sources/wikidata_source.dart';
import 'package:akashic/layers/functional/Lookup/domain/use_cases/source_with_backup.dart';
import 'package:akashic/layers/functional/Lookup/data/sources/rebrickable_source.dart';
import 'package:akashic/layers/functional/Lookup/data/sources/igdb_platform_source.dart';
import 'package:akashic/layers/functional/Lookup/data/sources/amiibo_source.dart';
import 'package:akashic/layers/functional/Lookup/data/sources/anilist_source.dart';
import 'package:akashic/layers/functional/Lookup/data/sources/board_game_geek_source.dart';
import 'package:akashic/layers/functional/Lookup/data/sources/bnf_source.dart';
import 'package:akashic/layers/functional/Lookup/data/sources/comic_vine_source.dart';
import 'package:akashic/layers/functional/Lookup/data/sources/discogs_source.dart';
import 'package:akashic/layers/functional/Lookup/data/sources/google_books_source.dart';
import 'package:akashic/layers/functional/Lookup/data/sources/igdb_source.dart';
import 'package:akashic/layers/functional/Lookup/data/sources/jikan_source.dart';
import 'package:akashic/layers/functional/Lookup/data/sources/lorcast_source.dart';
import 'package:akashic/layers/functional/Lookup/data/sources/musicbrainz_source.dart';
import 'package:akashic/layers/functional/Lookup/data/sources/open_library_source.dart';
import 'package:akashic/layers/functional/Lookup/data/sources/riftcodex_source.dart';
import 'package:akashic/layers/functional/Lookup/data/sources/scryfall_source.dart';
import 'package:akashic/layers/functional/Lookup/data/sources/ygoprodeck_source.dart';
import 'package:akashic/layers/functional/Lookup/data/sources/tcgdex_source.dart';
import 'package:akashic/layers/functional/Lookup/data/sources/tmdb_source.dart';
import 'package:akashic/layers/functional/Lookup/data/sources/tvmaze_source.dart';
import 'package:akashic/layers/functional/Lookup/data/sources/upcitemdb_source.dart';
import 'package:akashic/layers/functional/Lookup/domain/use_cases/isbn_with_fallback_source.dart';
import 'package:akashic/layers/functional/Lookup/domain/use_cases/isbn_with_series_source.dart';
import 'package:akashic/layers/functional/Lookup/domain/use_cases/source_registry.dart';
import 'package:akashic/layers/functional/Scans/data/background/local_chapter_notifier.dart';
import 'package:akashic/layers/functional/Lookup/domain/entities/source_unavailable.dart';
import 'package:akashic/layers/technical/Feedback/error_toasts.dart';
import 'package:akashic/layers/functional/Stats/data/gateways/drift_value_history_store.dart';
import 'package:akashic/layers/functional/Stats/domain/use_cases/value_history.dart';
import 'package:akashic/layers/functional/Stats/domain/use_cases/compute_collection_value.dart';
import 'package:akashic/layers/functional/Stats/data/gateways/drift_stats_gateway.dart';
import 'package:akashic/layers/functional/Collection/data/gateways/drift_deck_gateway.dart';
import 'package:akashic/layers/functional/Steam/data/gateways/drift_steam_watch_store.dart';
import 'package:akashic/layers/functional/Steam/data/notifications/local_steam_alerts.dart';
import 'package:akashic/layers/functional/Steam/domain/use_cases/check_new_steam_dlcs.dart';
import 'package:akashic/layers/functional/Steam/domain/use_cases/watch_steam_wishes.dart';
import 'package:akashic/layers/functional/Steam/data/gateways/drift_steam_wishlist_memory.dart';
import 'package:akashic/layers/functional/Steam/domain/use_cases/sync_steam_wishlist.dart';
import 'package:akashic/layers/functional/SealedPrices/data/gateways/drift_price_alert_store.dart';
import 'package:akashic/layers/functional/SealedPrices/data/notifications/local_price_alert_notifier.dart';
import 'package:akashic/layers/functional/SealedPrices/data/gateways/drift_sealed_price_store.dart';
import 'package:akashic/layers/functional/SealedPrices/data/sources/cardmarket_price_guide.dart';
import 'package:akashic/layers/functional/SealedPrices/domain/use_cases/refresh_sealed_prices.dart';
import 'package:akashic/layers/functional/Scans/data/gateways/drift_scan_gateway.dart';
import 'package:akashic/layers/functional/Scans/data/sources/manga_updates_source.dart';
import 'package:akashic/layers/functional/Scans/domain/use_cases/scan_releases.dart';
import 'package:akashic/layers/functional/Stats/data/widget/home_screen_summary.dart';
import 'package:akashic/layers/functional/Settings/data/gateways/drift_settings_gateway.dart';
import 'package:akashic/layers/functional/SourceLimits/data/gateways/drift_source_block_gateway.dart';
import 'package:akashic/layers/functional/Wishes/data/gateways/drift_wish_gateway.dart';
import 'package:akashic/layers/functional/Wishes/domain/use_cases/add_wish.dart';
import 'package:akashic/layers/functional/Wishes/domain/use_cases/find_wish_for.dart';
import 'package:akashic/layers/functional/Wishes/domain/use_cases/remove_fulfilled_wishes.dart';
import 'package:akashic/layers/functional/Wishes/domain/use_cases/watch_fulfilled_wishes.dart';
import 'package:akashic/layers/technical/HttpAccess/api_keys.dart';
import 'package:akashic/layers/technical/HttpAccess/throttled_http_client.dart';
import 'package:akashic/layers/technical/AppShell/root_navigator.dart';
import 'package:akashic/layers/technical/HttpAccess/user_agent_client.dart';
import 'package:akashic/layers/technical/AppShell/background_tasks.dart';
import 'package:akashic/layers/technical/LocalDatabase/akashic_database.dart';
import 'package:akashic/layers/technical/MediaStorage/local_image_store.dart';
import 'package:akashic/layers/technical/MediaStorage/phone_image_picker.dart';
import 'package:akashic/layers/technical/MediaStorage/remote_image_downloader.dart';
import 'package:akashic/layers/functional/Check/presentation/widgets/shelf_spine_reader.dart';
import 'package:akashic/layers/functional/Import/data/libraries/anilist_library.dart';
import 'package:akashic/layers/functional/Import/data/libraries/steam_grid_db_covers.dart';
import 'package:akashic/layers/functional/Import/data/libraries/itch_io_library.dart';
import 'package:akashic/layers/functional/Import/data/libraries/my_anime_list_library.dart';
import 'package:akashic/layers/functional/Import/data/libraries/rebrickable_collection_library.dart';
import 'package:akashic/layers/functional/Import/data/libraries/board_game_geek_collection_library.dart';
import 'package:akashic/layers/functional/Import/data/libraries/open_library_library.dart';
import 'package:akashic/layers/functional/Import/data/libraries/playnite_export_library.dart';
import 'package:akashic/layers/functional/Import/data/libraries/steam_library.dart';
import 'package:akashic/layers/functional/Import/data/libraries/trakt_library.dart';
import 'package:akashic/layers/functional/Import/domain/use_cases/import_account_library.dart';
import 'package:akashic/layers/functional/Lookup/data/sources/archidekt_deck_source.dart';
import 'package:akashic/layers/functional/Check/data/gateways/downloaded_cover_gateway.dart';
import 'package:akashic/layers/functional/Check/domain/use_cases/add_from_match.dart';
import 'package:akashic/layers/functional/Collection/domain/use_cases/add_item.dart';
import 'package:akashic/layers/functional/Import/data/gateways/drift_linked_account_gateway.dart';
import 'package:akashic/layers/functional/Import/domain/use_cases/find_game_match.dart';
import 'package:akashic/layers/functional/Import/domain/use_cases/sync_linked_accounts.dart';
import 'package:akashic/layers/technical/MediaStorage/dominant_color_extractor.dart';
import 'package:akashic/layers/functional/Steam/data/gateways/drift_steam_stats_gateway.dart';
import 'package:akashic/layers/functional/Steam/data/sources/steam_player_client.dart';
import 'package:akashic/layers/functional/Steam/data/sources/steam_store_client.dart';
import 'package:akashic/layers/functional/Steam/domain/use_cases/load_steam_achievements.dart';
import 'package:akashic/layers/functional/Steam/domain/use_cases/load_steam_store_sheet.dart';
import 'package:akashic/layers/functional/Steam/domain/use_cases/refresh_steam_stats.dart';
import 'package:akashic/layers/functional/Activity/data/gateways/drift_activity_log.dart';
import 'package:akashic/layers/functional/Budget/data/gateways/drift_budget_store.dart';
import 'package:akashic/layers/functional/Collection/domain/use_cases/merge_items.dart';
import 'package:akashic/layers/functional/Friends/domain/use_cases/compare_collections.dart';
import 'package:akashic/layers/functional/Preorders/data/gateways/drift_preorder_alert_memory.dart';
import 'package:akashic/layers/functional/Preorders/data/notifications/local_preorder_alerts.dart';
import 'package:akashic/layers/functional/Preorders/domain/use_cases/preorder_use_cases.dart';
import 'package:akashic/layers/technical/HttpAccess/offline_pill.dart';
import 'package:akashic/layers/technical/Voice/voice_search_sheet.dart';
import 'package:akashic/layers/functional/Releases/data/calendar/device_calendar_writer.dart';
import 'package:akashic/layers/functional/Releases/data/gateways/drift_calendar_sync_store.dart';
import 'package:akashic/layers/functional/Releases/domain/use_cases/sync_release_calendar.dart';
import 'package:akashic/layers/functional/Releases/presentation/views/calendar_sync_view.dart';
import 'package:akashic/layers/functional/Budget/data/notifications/local_budget_alerts.dart';
import 'package:akashic/layers/functional/Budget/domain/use_cases/budget_use_cases.dart';
import 'package:akashic/layers/functional/Inventory/domain/use_cases/insurance_inventory.dart';
import 'package:akashic/layers/functional/Activity/domain/use_cases/build_journal.dart';
import 'package:akashic/layers/functional/Trades/data/gateways/drift_trade_gateway.dart';
import 'package:akashic/layers/functional/Organisation/data/gateways/drift_organisation_gateways.dart';
import 'package:akashic/layers/functional/Collection/domain/use_cases/set_item_progress.dart';
import 'package:akashic/layers/functional/Goals/data/gateways/drift_goal_store.dart';
import 'package:akashic/layers/functional/Goals/domain/use_cases/compute_goal_progress.dart';
import 'package:akashic/layers/functional/Stats/domain/use_cases/compute_recap.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';

class AkashicDependencies {
  AkashicDependencies({
    required this.database,
    required Directory imageRoot,
    PhoneImagePicker? imagePicker,
    CoverTextReader? coverTextReader,
    ShelfSpineReader? shelfSpineReader,
    http.Client? httpClient,
  })  : categoryGateway = DriftCategoryGateway(database),
        collectionGateway = DriftCollectionGateway(database),
        settingsGateway = DriftSettingsGateway(database),
        wishGateway = DriftWishGateway(database),
        sourceBlocks = DriftSourceBlockGateway(database),
        scanGateway = DriftScanGateway(database),
        imageStore = LocalImageStore(imageRoot),
        documents = imageRoot,
        imagePicker = imagePicker ?? ImagePickerPhoneImagePicker(navigator: () => rootNavigatorKey.currentState),
        coverTextReader = coverTextReader ?? MlKitCoverTextReader(),
        shelfSpineReader = shelfSpineReader ?? MlKitShelfSpineReader(),
        _httpClient = UserAgentClient(httpClient ?? http.Client());

  final AkashicDatabase database;
  final DriftCategoryGateway categoryGateway;
  final DriftCollectionGateway collectionGateway;
  final DriftSettingsGateway settingsGateway;
  final DriftWishGateway wishGateway;
  final DriftSourceBlockGateway sourceBlocks;
  final DriftScanGateway scanGateway;
  final LocalImageStore imageStore;
  final Directory documents;
  final PhoneImagePicker imagePicker;
  final CoverTextReader coverTextReader;
  final ShelfSpineReader shelfSpineReader;
  final http.Client _httpClient;

  http.Client _throttled(String sourceKey, Duration interval, {Map<String, String> headers = const {}, bool cachesPosts = false}) =>
      ThrottledHttpClient(_httpClient, sourceKey: sourceKey, minimumInterval: interval, defaultHeaders: headers, rateLimits: sourceBlocks, cachesPosts: cachesPosts);

  late final http.Client steamClient = _throttled(SteamLibrary.sourceKey, const Duration(milliseconds: 300));

  late final SteamLibrary steamLibrary = SteamLibrary(steamClient, apiKey: ApiKeys.steamApiKey);

  late final DriftSteamStatsGateway steamStats = DriftSteamStatsGateway(database);

  late final http.Client steamStoreClient = _throttled(SteamPlayerClient.storeSourceKey, const Duration(milliseconds: 1600));

  late final SteamPlayerClient steamPlayer = SteamPlayerClient(steamClient, steamStoreClient, apiKey: ApiKeys.steamApiKey);

  late final LoadSteamStoreSheet loadSteamStoreSheet = LoadSteamStoreSheet(SteamStoreClient(steamStoreClient, steamClient), collectionGateway, preferredLanguages: ManagePreferredLanguages(settingsGateway).current);

  final Map<String, String> _steamIdsByAccount = {};

  Future<String?> steamIdOfLinkedAccount() async {
    final account = (await linkedAccounts.watchAll().first).where((linked) => linked.service == LibraryService.steam).firstOrNull;
    if (account == null) {
      return null;
    }
    return _steamIdsByAccount[account.accountName] ??= await steamLibrary.steamIdOf(account.accountName);
  }

  late final LoadSteamAchievements loadSteamAchievements = LoadSteamAchievements(steamPlayer, steamIdOfLinkedAccount);

  late final RefreshSteamStats refreshSteamStats = RefreshSteamStats(
    steamPlayer,
    steamStats,
    collectionGateway,
  );

  late final List<LibrarySource> accountLibraries = [
    steamLibrary,
    ItchIoLibrary(_throttled(ItchIoLibrary.sourceKey, const Duration(milliseconds: 500))),
    TraktLibrary(_throttled(TraktLibrary.sourceKey, const Duration(milliseconds: 400)), clientId: ApiKeys.traktClientId),
    AnilistLibrary(_throttled('anilist-library', const Duration(milliseconds: 700))),
    MyAnimeListLibrary(_throttled(MyAnimeListLibrary.serviceKey, const Duration(milliseconds: 500)), clientId: ApiKeys.myAnimeListClientId),
    OpenLibraryLibrary(_throttled('openlibrary-library', const Duration(milliseconds: 1000))),
    RebrickableCollectionLibrary(_throttled('rebrickable-collection', const Duration(milliseconds: 1100)), apiKey: ApiKeys.rebrickableApiKey),
    BoardGameGeekCollectionLibrary(_throttled('boardgamegeek-collection', const Duration(milliseconds: 2000)), token: ApiKeys.boardGameGeekToken),
    PlayniteExportLibrary(),
  ];

  late final SteamGridDbCovers steamGridDbCovers = SteamGridDbCovers(_throttled(SteamGridDbCovers.sourceKey, const Duration(milliseconds: 300)), apiKey: ApiKeys.steamGridDbApiKey);

  late final ArchidektDeckSource archidektDecks = ArchidektDeckSource(_throttled(ArchidektDeckSource.sourceKey, const Duration(milliseconds: 1000)));

  late final http.Client discogsClient = _throttled(DiscogsSource.sourceKey, const Duration(milliseconds: 1100));

  late final AniListSource aniListSource = AniListSource(_throttled(AniListSource.sourceKey, const Duration(milliseconds: 250), cachesPosts: true));

  late final SourceRegistry sourceRegistry = SourceRegistry([
    SourceWithBackup(DiscogsSource(discogsClient, token: ApiKeys.discogsToken), DeezerSource(_throttled(DeezerSource.sourceKey, const Duration(milliseconds: 150)))),
    SourceWithBackup(aniListSource, MangaDexSource(_throttled(MangaDexSource.sourceKey, const Duration(milliseconds: 250)))),
    IsbnWithSeriesSource(
      IsbnWithFallbackSource(
        GoogleBooksSource(_throttled(GoogleBooksSource.sourceKey, const Duration(milliseconds: 250)), apiKey: ApiKeys.googleBooksApiKey),
        BnfSource(_throttled(BnfSource.sourceKey, const Duration(milliseconds: 1100))),
      ),
      aniListSource,
    ),
    MusicBrainzSource(_throttled(MusicBrainzSource.sourceKey, const Duration(milliseconds: 1100), headers: const {'Accept': 'application/json'})),
    OpenLibrarySource(_throttled(OpenLibrarySource.sourceKey, const Duration(milliseconds: 1000))),
    JikanSource(_throttled(JikanSource.sourceKey, const Duration(milliseconds: 400))),
    SourceWithBackup(tmdbSource, _wikidata(CategoryType.films)),
    TvmazeSource(_throttled(TvmazeSource.sourceKey, const Duration(milliseconds: 500))),
    SourceWithBackup(igdbSource, _wikidata(CategoryType.videoGames)),
    TcgdexSource(_throttled(TcgdexSource.sourceKey, const Duration(milliseconds: 200))),
    ScryfallSource(_throttled(ScryfallSource.sourceKey, const Duration(milliseconds: 120), headers: const {'Accept': 'application/json'})),
    YgoprodeckSource(_throttled(YgoprodeckSource.sourceKey, const Duration(milliseconds: 100))),
    LorcastSource(_throttled(LorcastSource.sourceKey, const Duration(milliseconds: 100))),
    RiftcodexSource(_throttled(RiftcodexSource.sourceKey, const Duration(milliseconds: 250))),
    OptcgSource(_throttled(OptcgSource.sourceKey, const Duration(milliseconds: 500))),
    rebrickableSource,
    amiiboSource,
    IgdbPlatformSource(igdbSource),
    SourceWithBackup(BoardGameGeekSource(_throttled(BoardGameGeekSource.sourceKey, const Duration(seconds: 2)), token: ApiKeys.boardGameGeekToken), _wikidata(CategoryType.boardGames)),
    ComicVineSource(_throttled(ComicVineSource.sourceKey, const Duration(seconds: 1)), apiKey: ApiKeys.comicVineApiKey),
  ], barcodeFallbacks: [
    UpcItemDbSource(_throttled(UpcItemDbSource.sourceKey, const Duration(seconds: 2)), titleSources: {CategoryType.films: tmdbSource, CategoryType.videoGames: igdbSource, CategoryType.lego: rebrickableSource, CategoryType.amiibo: amiiboSource}),
  ]);

  WikidataSource _wikidata(CategoryType type) => WikidataSource.forType(_throttled('${WikidataSource.sourceKey}-${type.name}', const Duration(milliseconds: 500)), type);

  late final RefreshSealedPrices refreshSealedPrices = RefreshSealedPrices(collectionGateway, categoryGateway, CardmarketPriceGuide(_httpClient), DriftSealedPriceStore(database), alerts: DriftPriceAlertStore(database), alertNotifier: LocalPriceAlertNotifier(() => localizationsFor(settingsGateway)));

  late final CardmarketCatalogue sealedProducts = CardmarketCatalogue(_throttled(CardmarketCatalogue.sourceKey, const Duration(milliseconds: 500)));

  late final MtgjsonPreconCatalogue preconDecks = MtgjsonPreconCatalogue(_throttled(MtgjsonPreconCatalogue.sourceKey, const Duration(milliseconds: 500)));

  late final RebrickableSource rebrickableSource = RebrickableSource(_throttled(RebrickableSource.sourceKey, const Duration(milliseconds: 1100)), apiKey: ApiKeys.rebrickableApiKey);

  late final AmiiboSource amiiboSource = AmiiboSource(_throttled(AmiiboSource.sourceKey, const Duration(milliseconds: 500)));

  late final TmdbSource tmdbSource = TmdbSource(_throttled(TmdbSource.sourceKey, const Duration(milliseconds: 250)), apiKey: ApiKeys.tmdbApiKey);

  late final IgdbSource igdbSource = IgdbSource(_throttled(IgdbSource.sourceKey, const Duration(milliseconds: 250)), clientId: ApiKeys.igdbClientId, clientSecret: ApiKeys.igdbClientSecret);

  late final CombinedImageSearch imageSearch = CombinedImageSearch(_throttled('commons', const Duration(milliseconds: 250)));

  late final DriftDiscoveryCache discoveryCache = DriftDiscoveryCache(database);

  late final DriftDismissedSuggestionGateway dismissedSuggestionGateway = DriftDismissedSuggestionGateway(database);

  RecommendationSource _resolvingTitles(RecommendationSource recommendations, Set<CategoryType> types) => switch (sourceRegistry.byKey(recommendations.key)) {
        final catalog? => TitleResolvingRecommendations(recommendations, catalog, resolvableTypes: types),
        null => recommendations,
      };

  late final BuildDiscoveries buildDiscoveries = BuildDiscoveries(
    [
      _resolvingTitles(AniListRecommendations(_throttled('anilist-recommendations', const Duration(milliseconds: 700), cachesPosts: true)), {CategoryType.manga}),
      _resolvingTitles(GoogleBooksRecommendations(_throttled('googlebooks-recommendations', const Duration(milliseconds: 250)), apiKey: ApiKeys.googleBooksApiKey), {CategoryType.books, CategoryType.comics}),
      DiscogsRecommendations(discogsClient, token: ApiKeys.discogsToken),
      _resolvingTitles(TmdbRecommendations(_throttled('tmdb-recommendations', const Duration(milliseconds: 250)), apiKey: ApiKeys.tmdbApiKey), {CategoryType.films}),
      if (sourceRegistry.byKey('igdb') case final IgdbSource igdb) _resolvingTitles(IgdbSimilarGames(igdb), {CategoryType.videoGames}),
    ],
    collectionGateway,
    categoryGateway,
    dismissedSuggestionGateway,
    discoveryCache,
  );

  late final DismissSuggestion dismissSuggestion = DismissSuggestion(dismissedSuggestionGateway, discoveryCache);

  late final MangaUpdatesSource mangaUpdatesSource = MangaUpdatesSource(mangaUpdatesClient(_httpClient, sourceBlocks));

  late final RefreshScanReleases refreshScanReleases = RefreshScanReleases(scanGateway, mangaUpdatesSource);

  late final HomeScreenSummary homeScreenSummary = HomeScreenSummary(collectionGateway, DriftLoanGateway(database), () => localizationsFor(settingsGateway));

  late final LocalLoanNotifier loanNotifier = LocalLoanNotifier(() => localizationsFor(settingsGateway));

  late final RemindOverdueLoans remindOverdueLoans = RemindOverdueLoans(DriftLoanGateway(database), DriftLoanReminderStore(database), loanNotifier);

  final ValueNotifier<int> tourRequests = ValueNotifier(0);

  void requestTour() => tourRequests.value++;

  late final ManageTutorial manageTutorial = ManageTutorial(settingsGateway, categoryGateway);

  late final LocalReleaseNotifier releaseNotifier = LocalReleaseNotifier(() => localizationsFor(settingsGateway));

  late final FindUpcomingReleases findUpcomingReleases = FindUpcomingReleases(
    releaseCalendars((calendarKey) => _throttled(calendarKey, const Duration(milliseconds: 300)), googleBooksApiKey: ApiKeys.googleBooksApiKey),
    collectionGateway,
    categoryGateway,
    DriftReleaseStore(database),
    preferredLanguages: ManagePreferredLanguages(settingsGateway).current,
    wishes: wishGateway.all,
  );

  late final LocalChapterNotifier chapterNotifier = LocalChapterNotifier(() => localizationsFor(settingsGateway));

  late final DriftBackupStatusGateway backupStatus = DriftBackupStatusGateway(database);

  late final DriveBackupLocation _backupLocation = DriveBackupLocation.fromSetting(ApiKeys.driveBackupFolder);

  late final GoogleDriveBackupStorage backupStorage = GoogleDriveBackupStorage(
    _httpClient,
    GoogleSignInDriveAuthorization(serverClientId: ApiKeys.googleServerClientId.isEmpty ? null : ApiKeys.googleServerClientId, scopes: [_backupLocation.scope]),
    location: _backupLocation,
  );

  late final ZipCollectionArchiver collectionArchiver = ZipCollectionArchiver(database: database, documents: documents, workDirectory: Directory('${documents.path}/backup-work'));

  late final BackUpCollection backUpCollection = BackUpCollection(collectionArchiver, backupStorage, backupStatus);

  late final AutomaticBackup automaticBackup = AutomaticBackup(backUpCollection, backupStatus);

  late final AddWish addWish = AddWish(wishGateway);

  Future<int> importSteamWishlistOnce() async {
    if ((await DriftSteamWishlistMemory(database).importedAppIds()).isNotEmpty) {
      return 0;
    }
    final account = (await linkedAccounts.watchAll().first).where((linked) => linked.service == LibraryService.steam).firstOrNull;
    final steamId = await steamIdOfLinkedAccount();
    if (account == null || steamId == null) {
      return 0;
    }
    return syncSteamWishlist(steamId, categoryId: account.categoryId);
  }

  late final DriftSteamWatchStore steamWatchStore = DriftSteamWatchStore(database);

  late final LocalSteamAlerts steamAlerts = LocalSteamAlerts(() => localizationsFor(settingsGateway));

  late final WatchSteamWishes watchSteamWishes = WatchSteamWishes(steamPlayer, SteamStoreClient(steamStoreClient, steamClient), wishGateway, steamWatchStore, steamAlerts);

  late final CheckNewSteamDlcs checkNewSteamDlcs = CheckNewSteamDlcs(steamStats, SteamStoreClient(steamStoreClient, steamClient), collectionGateway, steamWatchStore, steamAlerts);

  late final DriftValueHistoryStore valueHistoryStore = DriftValueHistoryStore(database);

  late final RecordMonthlyValue recordMonthlyValue = RecordMonthlyValue(
    ComputeCollectionValue(collectionGateway, DriftDeckGateway(database), DriftStatsGateway(database), categoryGateway).call,
    collectionGateway,
    valueHistoryStore,
  );

  late final ComputeValueTrend computeValueTrend = ComputeValueTrend(collectionGateway, valueHistoryStore);

  late final DriftActivityLog activityLog = DriftActivityLog(database);

  late final SetItemProgress setItemProgress = SetItemProgress(collectionGateway, activityLog: activityLog);

  late final DriftGoalStore goalStore = DriftGoalStore(database);

  late final ComputeGoalProgress computeGoalProgress = ComputeGoalProgress(collectionGateway, categoryGateway, activityLog);

  late final ComputeRecap computeRecap = ComputeRecap(collectionGateway, activityLog, valueHistoryStore);

  late final DriftTagGateway tagGateway = DriftTagGateway(database);

  late final DriftBudgetStore budgetStore = DriftBudgetStore(database);

  late final ManagePreorder managePreorder = ManagePreorder(collectionGateway, activityLog: activityLog);

  late final AnnouncePreorderArrivals announcePreorderArrivals = AnnouncePreorderArrivals(collectionGateway, LocalPreorderAlerts(() => localizationsFor(settingsGateway)), DriftPreorderAlertMemory(database));

  late final MergeItems mergeItems = MergeItems(collectionGateway, activityLog: activityLog);

  late final CompareCollections compareCollections = CompareCollections(collectionGateway, wishGateway);

  late final VoiceListener voiceListener = SpeechVoiceListener();

  late final Stream<bool> offline = watchOffline().asBroadcastStream();

  late final DriftCalendarSyncStore calendarSyncStore = DriftCalendarSyncStore(database);

  late final DeviceCalendarWriter calendarWriter = DeviceCalendarWriter();

  late final SyncReleaseCalendar syncReleaseCalendar = SyncReleaseCalendar(DriftReleaseStore(database), calendarSyncStore, calendarWriter, () async {
    final l10n = await localizationsFor(settingsGateway);
    return (release, {required remindsTheEveBefore}) => describeReleaseEvent(release, l10n, remindsTheEveBefore: remindsTheEveBefore);
  });

  late final ComputeBudget computeBudget = ComputeBudget(collectionGateway, budgetStore);

  late final CheckBudgetAlert checkBudgetAlert = CheckBudgetAlert(computeBudget, budgetStore, LocalBudgetAlerts(() => localizationsFor(settingsGateway)));

  late final LoadInsuranceInventory loadInsuranceInventory = LoadInsuranceInventory(collectionGateway, categoryGateway);

  late final DriftSmartShelfGateway smartShelfGateway = DriftSmartShelfGateway(database);

  late final DriftStoragePlanGateway storagePlanGateway = DriftStoragePlanGateway(database);

  late final BuildJournal buildJournal = BuildJournal(collectionGateway, activityLog, DriftTradeGateway(database), valueHistoryStore);

  late final SyncSteamWishlist syncSteamWishlist = SyncSteamWishlist(steamPlayer, SteamStoreClient(steamStoreClient, steamClient), collectionGateway, addWish, DriftSteamWishlistMemory(database));

  late final FindWishFor findWishFor = FindWishFor(wishGateway);

  late final WatchFulfilledWishes watchFulfilledWishes = WatchFulfilledWishes(collectionGateway, wishGateway, RemoveFulfilledWishes(wishGateway));

  late final RemoteImageDownloader imageDownloader = RemoteImageDownloader(_httpClient);

  late final DownloadedCoverGateway coverGateway = DownloadedCoverGateway(imageDownloader, imageStore, extractColor: extractDominantColor);

  late final AddFromMatch addFromMatch = AddFromMatch(AddItem(collectionGateway, categoryGateway), collectionGateway, coverGateway);

  late final ImportAccountLibrary importAccountLibrary = ImportAccountLibrary(
    collectionGateway,
    addFromMatch,
    lookUp: FindGameMatch(sourceRegistry.byKey('igdb')).call,
    findCover: (match) async => await steamGridDbCovers.coverOf(match) ?? (match.sourceKey == SteamLibrary.sourceKey ? SteamLibrary.headerImageOf(match.externalWorkId) : null),
    covers: coverGateway,
  );

  late final DriftLinkedAccountGateway linkedAccounts = DriftLinkedAccountGateway(database);

  late final SyncLinkedAccounts syncLinkedAccounts = SyncLinkedAccounts(
    linkedAccounts,
    accountLibraries,
    importAccountLibrary,
    followUps: {
      LibraryService.steam: (account) async {
        final steamId = await steamLibrary.steamIdOf(account.accountName);
        try {
          await syncSteamWishlist(steamId, categoryId: account.categoryId);
        } on SourceUnavailable {
          ErrorToasts.instance.show((l10n) => l10n.steamWishlistUnavailable);
        }
        await refreshSteamStats(steamId);
        for (final watch in [watchSteamWishes.call, checkNewSteamDlcs.call]) {
          try {
            await watch();
          } on SourceUnavailable {
            continue;
          }
        }
      },
    },
  );

  late final FetchItemDetails fetchItemDetails = FetchItemDetails([
    DiscogsDetailsSource(discogsClient, token: ApiKeys.discogsToken),
    AniListDetailsSource(_throttled('anilist-details', const Duration(milliseconds: 250), cachesPosts: true)),
    GoogleBooksDetailsSource(_throttled('googlebooks-details', const Duration(milliseconds: 250)), apiKey: ApiKeys.googleBooksApiKey),
    TmdbDetailsSource(_throttled('tmdb-details', const Duration(milliseconds: 250)), apiKey: ApiKeys.tmdbApiKey),
    IgdbDetailsSource(igdbSource),
  ], DriftDetailsStore(database));
}
