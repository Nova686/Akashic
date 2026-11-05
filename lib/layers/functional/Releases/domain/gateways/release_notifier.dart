import 'package:akashic/layers/functional/Releases/domain/entities/upcoming_release.dart';

abstract interface class ReleaseNotifier {
  Future<bool> requestPermission();
  Future<void> announce(List<UpcomingRelease> releases);
  Future<void> announceWishedOut(List<UpcomingRelease> releases);
}
