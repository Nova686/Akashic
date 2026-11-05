import 'package:akashic/layers/functional/Collection/domain/use_cases/resolve_display_title.dart';
import 'package:akashic/layers/functional/Settings/domain/entities/preferred_languages.dart';
import 'package:akashic/layers/functional/Stats/domain/use_cases/compute_collection_value.dart';
import 'package:akashic/layers/functional/Stats/domain/use_cases/refresh_collection_values.dart';
import 'package:akashic/layers/functional/Stats/presentation/cubit/collection_value_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CollectionValueCubit extends Cubit<CollectionValueState> {
  CollectionValueCubit(this._computeCollectionValue, this._refreshCollectionValues, {required this._preferredLanguages}) : super(const CollectionValueState());

  final ComputeCollectionValue _computeCollectionValue;
  final RefreshCollectionValues _refreshCollectionValues;
  final Future<PreferredLanguages> Function() _preferredLanguages;

  Future<void> start() => _reload();

  Future<void> refreshMarketValues() async {
    if (state.isRefreshing) {
      return;
    }
    emit(state.copyWith(isRefreshing: true, refreshDone: 0, refreshTotal: 0));
    final refresh = await _refreshCollectionValues(
      onProgress: (done, total) {
        if (!isClosed) {
          emit(state.copyWith(refreshDone: done, refreshTotal: total));
        }
      },
    );
    if (isClosed) {
      return;
    }
    emit(state.copyWith(isRefreshing: false, lastRefresh: refresh));
    await _reload();
  }

  Future<void> _reload() async {
    final languages = await _preferredLanguages();
    final (value, duplicates) = await _computeCollectionValue.valueAndDuplicates(titleOf: (item) => resolveDisplayTitle(item.titles, languages) ?? '');
    if (!isClosed) {
      emit(state.copyWith(value: value, duplicates: duplicates, preferredLanguages: languages));
    }
  }
}
