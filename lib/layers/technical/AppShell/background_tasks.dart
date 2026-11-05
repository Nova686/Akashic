import 'dart:ui';

import 'package:akashic/layers/functional/Releases/data/calendars/release_calendars.dart';
import 'package:akashic/layers/functional/Releases/data/gateways/drift_release_store.dart';
import 'package:akashic/layers/functional/Releases/data/notifications/local_release_notifier.dart';
import 'package:akashic/layers/functional/Releases/domain/use_cases/announce_new_releases.dart';
import 'package:akashic/layers/functional/Releases/domain/use_cases/find_upcoming_releases.dart';
import 'package:akashic/layers/functional/Catalog/data/gateways/drift_category_gateway.dart';
import 'package:akashic/layers/technical/HttpAccess/api_keys.dart';
import 'package:akashic/layers/functional/Collection/data/gateways/drift_collection_gateway.dart';
import 'package:akashic/layers/functional/Loans/data/gateways/drift_loan_gateway.dart';
import 'package:akashic/layers/functional/Loans/data/gateways/drift_loan_reminder_store.dart';
import 'package:akashic/layers/functional/Loans/data/notifications/local_loan_notifier.dart';
import 'package:akashic/layers/functional/Loans/domain/use_cases/remind_overdue_loans.dart';
import 'package:akashic/layers/functional/Scans/data/background/local_chapter_notifier.dart';
import 'package:akashic/layers/functional/Scans/data/gateways/drift_scan_gateway.dart';
import 'package:akashic/layers/functional/Scans/data/sources/manga_updates_source.dart';
import 'package:akashic/layers/functional/Scans/domain/use_cases/check_scan_releases.dart';
import 'package:akashic/layers/functional/Scans/domain/use_cases/scan_releases.dart';
import 'package:akashic/layers/functional/Stats/data/widget/home_screen_summary.dart';
import 'package:akashic/layers/functional/Settings/data/gateways/drift_settings_gateway.dart';
import 'package:akashic/layers/functional/Settings/domain/use_cases/manage_preferred_languages.dart';
import 'package:akashic/layers/functional/SealedPrices/data/background/workmanager_sealed_price_scheduler.dart';
import 'package:akashic/layers/functional/SealedPrices/data/gateways/drift_price_alert_store.dart';
import 'package:akashic/layers/functional/SealedPrices/data/notifications/local_price_alert_notifier.dart';
import 'package:akashic/layers/functional/SealedPrices/data/gateways/drift_sealed_price_store.dart';
import 'package:akashic/layers/functional/SealedPrices/data/sources/cardmarket_price_guide.dart';
import 'package:akashic/layers/functional/SealedPrices/domain/use_cases/refresh_sealed_prices.dart';
import 'package:akashic/layers/functional/SourceLimits/data/gateways/drift_source_block_gateway.dart';
import 'package:akashic/layers/technical/HttpAccess/rate_limits.dart';
import 'package:akashic/layers/technical/HttpAccess/throttled_http_client.dart';
import 'package:akashic/layers/technical/HttpAccess/user_agent_client.dart';
import 'package:akashic/layers/technical/LocalDatabase/akashic_database.dart';
import 'package:akashic/layers/technical/Localization/app_localizations.dart';
import 'package:http/http.dart' as http;
import 'package:workmanager/workmanager.dart';

http.Client mangaUpdatesClient(http.Client client, RateLimitRecorder rateLimits) => ThrottledHttpClient(
      client,
      sourceKey: MangaUpdatesSource.sourceKey,
      minimumInterval: const Duration(milliseconds: 1000),
      rateLimits: rateLimits,
      cachesPosts: true,
    );

Future<AppLocalizations> localizationsFor(DriftSettingsGateway settings) async {
  final languageCode = await settings.watchAppLanguageCode().first ?? PlatformDispatcher.instance.locale.languageCode;
  final locale = Locale(languageCode);
  return lookupAppLocalizations(AppLocalizations.delegate.isSupported(locale) ? locale : const Locale('en'));
}

@pragma('vm:entry-point')
void scanReleaseCheckDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    final database = AkashicDatabase.open();
    final httpClient = UserAgentClient(http.Client());
    try {
      if (task == WorkmanagerSealedPriceScheduler.taskName) {
        await RefreshSealedPrices(DriftCollectionGateway(database), DriftCategoryGateway(database), CardmarketPriceGuide(httpClient),
          DriftSealedPriceStore(database),
          alerts: DriftPriceAlertStore(database),
          alertNotifier: LocalPriceAlertNotifier(() => localizationsFor(DriftSettingsGateway(database))),
        ).refreshIfStale();
        return true;
      }
      final settings = DriftSettingsGateway(database);
      await RemindOverdueLoans(DriftLoanGateway(database), DriftLoanReminderStore(database), LocalLoanNotifier(() => localizationsFor(settings)))();
      await HomeScreenSummary(DriftCollectionGateway(database), DriftLoanGateway(database), () => localizationsFor(settings)).publish();
      final scans = DriftScanGateway(database);
      final sourceBlocks = DriftSourceBlockGateway(database);
      await sourceBlocks.load();
      final checkScanReleases = CheckScanReleases(
        RefreshScanReleases(scans, MangaUpdatesSource(mangaUpdatesClient(httpClient, sourceBlocks))),
        DriftCollectionGateway(database),
        LocalChapterNotifier(() => localizationsFor(settings)),
        ManagePreferredLanguages(settings).current,
      );
      await checkScanReleases();
      final releaseStore = DriftReleaseStore(database);
      await AnnounceNewReleases(
        FindUpcomingReleases(
          releaseCalendars(
            (calendarKey) => ThrottledHttpClient(httpClient, sourceKey: calendarKey, minimumInterval: const Duration(milliseconds: 300), rateLimits: sourceBlocks),
            googleBooksApiKey: ApiKeys.googleBooksApiKey,
          ),
          DriftCollectionGateway(database),
          DriftCategoryGateway(database),
          releaseStore,
          preferredLanguages: ManagePreferredLanguages(settings).current,
        ),
        releaseStore,
        LocalReleaseNotifier(() => localizationsFor(settings)),
      )();
      return true;
    } finally {
      httpClient.close();
      await database.close();
    }
  });
}
