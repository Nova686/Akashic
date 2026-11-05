import 'package:akashic/layers/functional/Activity/domain/entities/activity_event.dart';

abstract interface class ActivityLog {
  Future<void> record(ActivityEvent event);
  Future<List<ActivityEvent>> between(DateTime from, DateTime to);
  Stream<List<ActivityEvent>> watchRecent({int limit});
}
