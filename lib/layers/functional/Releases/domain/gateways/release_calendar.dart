import 'package:akashic/layers/functional/Releases/domain/entities/release_interests.dart';
import 'package:akashic/layers/functional/Releases/domain/entities/upcoming_release.dart';

abstract interface class ReleaseCalendar {
  String get key;
  bool get isConfigured;
  Future<List<UpcomingRelease>> upcoming(ReleaseInterests interests, {required DateTime today});
}
