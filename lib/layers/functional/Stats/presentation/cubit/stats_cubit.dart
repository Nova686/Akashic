import 'dart:async';

import 'package:akashic/layers/functional/Stats/domain/entities/collection_stats.dart';
import 'package:akashic/layers/functional/Stats/domain/use_cases/compute_collection_stats.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StatsCubit extends Cubit<CollectionStats?> {
  StatsCubit(this._computeCollectionStats) : super(null);

  final ComputeCollectionStats _computeCollectionStats;
  StreamSubscription<CollectionStats>? _subscription;

  void start() {
    _subscription = _computeCollectionStats().listen((stats) {
      if (!isClosed) {
        emit(stats);
      }
    });
  }

  @override
  Future<void> close() async {
    await _subscription?.cancel();
    return super.close();
  }
}
