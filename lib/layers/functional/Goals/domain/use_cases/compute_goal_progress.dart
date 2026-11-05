import 'package:akashic/layers/functional/Activity/domain/entities/activity_event.dart';
import 'package:akashic/layers/functional/Activity/domain/gateways/activity_log.dart';
import 'package:akashic/layers/functional/Catalog/domain/gateways/category_gateway.dart';
import 'package:akashic/layers/functional/Catalog/domain/use_cases/root_categories.dart';
import 'package:akashic/layers/functional/Collection/domain/gateways/collection_gateway.dart';
import 'package:akashic/layers/functional/Goals/domain/entities/goal.dart';

double yearElapsedAt(DateTime moment) {
  final start = DateTime(moment.year);
  final end = DateTime(moment.year + 1);
  return moment.difference(start).inMinutes / end.difference(start).inMinutes;
}

class ComputeGoalProgress {
  ComputeGoalProgress(this._collection, this._categories, this._activityLog, {DateTime Function()? now}) : _now = now ?? DateTime.now;

  final CollectionGateway _collection;
  final CategoryGateway _categories;
  final ActivityLog _activityLog;
  final DateTime Function() _now;

  Future<List<GoalProgress>> call(List<Goal> goals) async {
    if (goals.isEmpty) {
      return const [];
    }
    final now = _now();
    final roots = rootCategoryById(await _categories.watchTree().first);
    final items = await _collection.allItems();
    final progress = <GoalProgress>[];
    for (final goal in goals) {
      final start = DateTime(goal.year);
      final end = DateTime(goal.year + 1);
      bool counts(String? categoryId) => goal.categoryId == null || (categoryId != null && roots[categoryId]?.id == goal.categoryId);
      final done = switch (goal.measure) {
        GoalMeasure.added => items.where((item) => item.addedAt != null && !item.addedAt!.isBefore(start) && item.addedAt!.isBefore(end) && counts(item.categoryId)).length,
        GoalMeasure.finished => {
            for (final event in await _activityLog.between(start, end))
              if (event.kind == ActivityKind.finished && counts(event.categoryId)) event.itemId ?? event.title,
          }.length,
      };
      final elapsed = goal.year < now.year ? 1.0 : (goal.year > now.year ? 0.0 : yearElapsedAt(now));
      progress.add(GoalProgress(goal: goal, done: done, yearElapsed: elapsed, categoryName: goal.categoryId == null ? null : roots[goal.categoryId]?.name));
    }
    return progress;
  }
}
