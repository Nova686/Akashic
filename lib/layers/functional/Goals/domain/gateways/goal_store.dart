import 'package:akashic/layers/functional/Goals/domain/entities/goal.dart';

abstract interface class GoalStore {
  Future<void> save(Goal goal);
  Future<void> delete(String goalId);
  Stream<List<Goal>> watchYear(int year);
}
