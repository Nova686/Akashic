import 'dart:async';

import 'package:akashic/layers/functional/Catalog/domain/entities/category.dart';
import 'package:akashic/layers/functional/Catalog/domain/gateways/category_gateway.dart';
import 'package:akashic/layers/functional/Goals/domain/entities/goal.dart';
import 'package:akashic/layers/functional/Goals/domain/gateways/goal_store.dart';
import 'package:akashic/layers/functional/Goals/domain/use_cases/compute_goal_progress.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';

class GoalsState extends Equatable {
  const GoalsState({required this.year, this.progress = const [], this.categories = const [], this.isLoading = true});

  final int year;
  final List<GoalProgress> progress;
  final List<Category> categories;
  final bool isLoading;

  @override
  List<Object?> get props => [year, progress, categories, isLoading];
}

class GoalsCubit extends Cubit<GoalsState> {
  GoalsCubit(this._store, this._compute, this._categories, {DateTime Function()? now, String Function()? newId})
      : _newId = newId ?? const Uuid().v4,
        super(GoalsState(year: (now ?? DateTime.now)().year));

  final GoalStore _store;
  final ComputeGoalProgress _compute;
  final CategoryGateway _categories;
  final String Function() _newId;
  StreamSubscription<List<Goal>>? _subscription;
  int _generation = 0;

  void start() {
    _subscription = _store.watchYear(state.year).listen(_refresh);
  }

  Future<void> _refresh(List<Goal> goals) async {
    final generation = ++_generation;
    final tree = await _categories.watchTree().first;
    final progress = await _compute(goals);
    if (!isClosed && generation == _generation) {
      emit(GoalsState(year: state.year, progress: progress, categories: [for (final node in tree) node.category], isLoading: false));
    }
  }

  Future<void> add({required GoalMeasure measure, required int target, String? categoryId}) =>
      _store.save(Goal(id: _newId(), year: state.year, measure: measure, target: target, categoryId: categoryId));

  Future<void> remove(String goalId) => _store.delete(goalId);

  @override
  Future<void> close() async {
    await _subscription?.cancel();
    return super.close();
  }
}
