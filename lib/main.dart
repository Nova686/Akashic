import 'dart:async';
import 'dart:ui';

import 'package:akashic/layers/functional/Collection/presentation/widgets/precon_group_label.dart';
import 'package:akashic/layers/functional/Collection/domain/use_cases/group_precon_decks.dart';
import 'package:akashic/layers/functional/Backup/data/archive/pending_restore.dart';
import 'package:akashic/layers/functional/SealedPrices/data/background/workmanager_sealed_price_scheduler.dart';
import 'package:akashic/layers/functional/Scans/data/background/workmanager_scan_scheduler.dart';
import 'package:akashic/layers/technical/AppShell/akashic_app.dart';
import 'package:akashic/layers/technical/AppShell/background_tasks.dart';
import 'package:akashic/layers/technical/AppShell/dependency_scope.dart';
import 'package:akashic/layers/technical/Feedback/error_toasts.dart';
import 'package:akashic/layers/technical/LocalDatabase/akashic_database.dart';
import 'package:akashic/layers/technical/Theme/akashic_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  FlutterError.onError = (details) {
    FlutterError.presentError(details);
    ErrorToasts.instance.showUnexpected(details.exception);
  };
  PlatformDispatcher.instance.onError = (error, stackTrace) {
    ErrorToasts.instance.showUnexpected(error);
    return true;
  };
  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  SystemChrome.setSystemUIOverlayStyle(akashicSystemBars);
  final documents = await getApplicationDocumentsDirectory();
  await applyPendingRestore(documents: documents, databaseFileName: AkashicDatabase.fileName, maximumSchema: AkashicDatabase.currentSchemaVersion);
  final dependencies = AkashicDependencies(
    database: AkashicDatabase.open(),
    imageRoot: documents,
  );
  runApp(AkashicApp(dependencies: dependencies));
  unawaited(dependencies.sourceBlocks.load());
  WidgetsBinding.instance.addPostFrameCallback((_) => Timer(deferredStartupDelay, () => runDeferredStartupTasks(dependencies)));
}

const Duration deferredStartupDelay = Duration(seconds: 2);

void runDeferredStartupTasks(AkashicDependencies dependencies) {
  unawaited(dependencies.homeScreenSummary.publish().then<void>((_) {}).catchError((Object _) {}, test: (error) => error is Exception));
  unawaited(groupPreconDecks(dependencies).catchError((Object _) => 0, test: (error) => error is Exception));
  unawaited(dependencies
      .syncLinkedAccounts()
      .catchError((Object _) => 0, test: (error) => error is Exception)
      .then((_) => dependencies.importSteamWishlistOnce())
      .catchError((Object _) => 0, test: (error) => error is Exception));
  unawaited(dependencies.remindOverdueLoans().then<void>((_) {}).catchError(ErrorToasts.instance.showUnexpected, test: (error) => error is Exception));
  unawaited(dependencies.automaticBackup().catchError((Object _) {
    ErrorToasts.instance.show((l10n) => l10n.automaticBackupFailedToast);
    return false;
  }, test: (error) => error is Exception));
  unawaited(WorkmanagerScanScheduler(scanReleaseCheckDispatcher).ensureScheduled().catchError((Object failure) {
    ErrorToasts.instance.showUnexpected(failure);
  }, test: (error) => error is PlatformException));
  unawaited(dependencies.recordMonthlyValue().catchError((Object _) => false, test: (error) => error is Exception));
  unawaited(dependencies.checkBudgetAlert().catchError((Object _) => false, test: (error) => error is Exception));
  unawaited(dependencies.syncReleaseCalendar().catchError((Object _) => 0, test: (error) => error is Exception));
  unawaited(dependencies.announcePreorderArrivals().catchError((Object _) => const <String>[], test: (error) => error is Exception));
  unawaited(WorkmanagerSealedPriceScheduler(scanReleaseCheckDispatcher).ensureScheduled().catchError((Object failure) {
    ErrorToasts.instance.showUnexpected(failure);
  }, test: (error) => error is PlatformException));
}

Future<int> groupPreconDecks(AkashicDependencies dependencies) async {
  final l10n = await localizationsFor(dependencies.settingsGateway);
  return GroupPreconDecks(dependencies.collectionGateway, dependencies.preconDecks, (deck) => preconGroupLabel(deck, l10n), settings: dependencies.settingsGateway)();
}
