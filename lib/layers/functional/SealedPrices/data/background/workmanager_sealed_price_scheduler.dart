import 'package:workmanager/workmanager.dart';

class WorkmanagerSealedPriceScheduler {
  WorkmanagerSealedPriceScheduler(this._dispatcher);

  static const String uniqueName = 'akashic-sealed-prices';
  static const String taskName = 'refreshSealedPrices';
  static const Duration refreshInterval = Duration(hours: 24);

  final void Function() _dispatcher;

  Future<void> ensureScheduled() async {
    await Workmanager().initialize(_dispatcher);
    await Workmanager().registerPeriodicTask(
      uniqueName,
      taskName,
      frequency: refreshInterval,
      constraints: Constraints(networkType: NetworkType.unmetered),
      existingWorkPolicy: ExistingPeriodicWorkPolicy.keep,
    );
  }
}
