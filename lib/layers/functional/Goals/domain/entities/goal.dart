import 'package:equatable/equatable.dart';

enum GoalMeasure { finished, added }

class Goal extends Equatable {
  const Goal({required this.id, required this.year, required this.measure, required this.target, this.categoryId});

  final String id;
  final int year;
  final GoalMeasure measure;
  final String? categoryId;
  final int target;

  @override
  List<Object?> get props => [id, year, measure, categoryId, target];
}

class GoalProgress extends Equatable {
  const GoalProgress({required this.goal, required this.done, required this.yearElapsed, this.categoryName});

  final Goal goal;
  final int done;
  final double yearElapsed;
  final String? categoryName;

  double get ratio => goal.target == 0 ? 1 : (done / goal.target).clamp(0, 1).toDouble();

  int get expectedToday => (goal.target * yearElapsed).round();

  int get gap => done - expectedToday;

  int get projected => yearElapsed <= 0 ? done : (done / yearElapsed).round();

  bool get isReached => done >= goal.target;

  @override
  List<Object?> get props => [goal, done, yearElapsed, categoryName];
}
