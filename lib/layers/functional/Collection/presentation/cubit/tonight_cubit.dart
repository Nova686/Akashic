import 'package:akashic/layers/functional/Catalog/domain/gateways/category_gateway.dart';
import 'package:akashic/layers/functional/Catalog/domain/use_cases/root_categories.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/item_progress.dart';
import 'package:akashic/layers/functional/Collection/domain/gateways/collection_gateway.dart';
import 'package:akashic/layers/functional/Collection/domain/use_cases/pick_tonight.dart';
import 'package:akashic/layers/functional/Collection/domain/use_cases/set_item_progress.dart';
import 'package:akashic/layers/functional/Details/domain/entities/item_details.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TonightState extends Equatable {
  const TonightState({this.activity = TonightActivity.any, this.length = TonightLength.any, this.pick, this.candidateCount = 0, this.isLoading = true, this.startedTitle});

  final TonightActivity activity;
  final TonightLength length;
  final TonightCandidate? pick;
  final int candidateCount;
  final bool isLoading;
  final String? startedTitle;

  @override
  List<Object?> get props => [activity, length, pick?.item.id, candidateCount, isLoading, startedTitle];
}

class TonightCubit extends Cubit<TonightState> {
  TonightCubit(this._collection, this._categories, this._cachedDetails, this._setProgress, {PickTonight? pickTonight})
      : _pick = pickTonight ?? PickTonight(),
        super(const TonightState());

  final CollectionGateway _collection;
  final CategoryGateway _categories;
  final Future<ItemDetails?> Function(String itemId) _cachedDetails;
  final SetItemProgress _setProgress;
  final PickTonight _pick;
  List<TonightCandidate> _candidates = const [];

  Future<void> load() async {
    final roots = rootCategoryById(await _categories.watchTree().first);
    final candidates = <TonightCandidate>[];
    for (final item in await _collection.allItems()) {
      final category = roots[item.categoryId];
      if (category == null || !isWaitingToStart(item)) {
        continue;
      }
      final activity = activityOf(category.type);
      if (activity == TonightActivity.any) {
        continue;
      }
      candidates.add(TonightCandidate(item: item, category: category, activity: activity, length: lengthOf(item, category.type, await _cachedDetails(item.id))));
    }
    _candidates = candidates;
    if (!isClosed) {
      _draw(state.activity, state.length);
    }
  }

  void _draw(TonightActivity activity, TonightLength length) => emit(TonightState(
        activity: activity,
        length: length,
        pick: _pick(_candidates, activity: activity, length: length),
        candidateCount: _candidates.length,
        isLoading: false,
      ));

  void chooseActivity(TonightActivity activity) => _draw(activity, state.length);

  void chooseLength(TonightLength length) => _draw(state.activity, length);

  void drawAgain() => _draw(state.activity, state.length);

  Future<void> start(String title) async {
    final pick = state.pick;
    if (pick == null) {
      return;
    }
    await _setProgress(pick.item.id, const ItemProgress(status: ProgressStatus.inProgress));
    _candidates = [for (final candidate in _candidates) if (candidate.item.id != pick.item.id) candidate];
    if (!isClosed) {
      emit(TonightState(activity: state.activity, length: state.length, pick: pick, candidateCount: _candidates.length, isLoading: false, startedTitle: title));
    }
  }
}
