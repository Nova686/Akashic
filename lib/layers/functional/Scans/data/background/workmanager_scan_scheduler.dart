import 'package:akashic/layers/functional/Scans/domain/gateways/chapter_alerts.dart';
import 'package:workmanager/workmanager.dart';

class WorkmanagerScanScheduler implements ScanAlertsScheduler {
  WorkmanagerScanScheduler(this._dispatcher);

  static const String uniqueName = 'akashic-scan-releases';
  static const String taskName = 'checkScanReleases';
  static const Duration checkInterval = Duration(hours: 6);

  final void Function() _dispatcher;

  @override
  Future<void> ensureScheduled() async {
    await Workmanager().initialize(_dispatcher);
    await Workmanager().registerPeriodicTask(
      uniqueName,
      taskName,
      frequency: checkInterval,
      constraints: Constraints(networkType: NetworkType.connected),
      existingWorkPolicy: ExistingPeriodicWorkPolicy.keep,
    );
  }
}
