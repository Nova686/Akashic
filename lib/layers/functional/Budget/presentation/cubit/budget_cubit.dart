import 'dart:async';

import 'package:akashic/layers/functional/Budget/domain/entities/budget.dart';
import 'package:akashic/layers/functional/Budget/domain/gateways/budget_store.dart';
import 'package:akashic/layers/functional/Budget/domain/use_cases/budget_use_cases.dart';
import 'package:akashic/layers/functional/Collection/domain/gateways/collection_gateway.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BudgetCubit extends Cubit<BudgetStatus?> {
  BudgetCubit(this._compute, this._store, this._collection) : super(null);

  final ComputeBudget _compute;
  final BudgetStore _store;
  final CollectionGateway _collection;
  final List<StreamSubscription<Object?>> _subscriptions = [];
  BudgetSettings? _settings;
  int _generation = 0;

  void start() {
    _subscriptions
      ..add(_store.watchSettings().listen((settings) {
        _settings = settings;
        _refresh();
      }))
      ..add(_collection.watchOwnedWorks().listen((_) => _refresh()));
  }

  Future<void> _refresh() async {
    final settings = _settings;
    if (settings == null) {
      return;
    }
    final generation = ++_generation;
    final status = await _compute(settings);
    if (!isClosed && generation == _generation) {
      emit(status);
    }
  }

  Future<void> save(BudgetSettings settings) => _store.save(settings);

  @override
  Future<void> close() async {
    for (final subscription in _subscriptions) {
      await subscription.cancel();
    }
    return super.close();
  }
}
