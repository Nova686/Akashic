import 'package:akashic/layers/functional/Goals/domain/entities/goal.dart';
import 'package:akashic/layers/functional/Goals/domain/gateways/goal_store.dart';
import 'package:akashic/layers/technical/LocalDatabase/akashic_database.dart';
import 'package:drift/drift.dart';

class DriftGoalStore implements GoalStore {
  DriftGoalStore(this._database);

  final AkashicDatabase _database;

  @override
  Future<void> save(Goal goal) => _database.into(_database.goals).insertOnConflictUpdate(GoalsCompanion.insert(
        id: goal.id,
        year: goal.year,
        measure: goal.measure.name,
        categoryId: Value(goal.categoryId),
        target: goal.target,
        createdAt: DateTime.now(),
      ));

  @override
  Future<void> delete(String goalId) => (_database.delete(_database.goals)..where((table) => table.id.equals(goalId))).go();

  @override
  Stream<List<Goal>> watchYear(int year) => (_database.select(_database.goals)
        ..where((table) => table.year.equals(year))
        ..orderBy([(table) => OrderingTerm.asc(table.createdAt)]))
      .watch()
      .map((rows) => [
            for (final row in rows)
              Goal(id: row.id, year: row.year, measure: GoalMeasure.values.asNameMap()[row.measure] ?? GoalMeasure.finished, categoryId: row.categoryId, target: row.target),
          ]);
}
