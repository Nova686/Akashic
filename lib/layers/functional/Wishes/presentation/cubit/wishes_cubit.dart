import 'dart:async';

import 'package:akashic/layers/functional/Catalog/domain/entities/category_type.dart';
import 'package:akashic/layers/functional/Wishes/domain/entities/wish.dart';
import 'package:akashic/layers/functional/Wishes/domain/gateways/wish_gateway.dart';
import 'package:akashic/layers/functional/Wishes/domain/use_cases/remove_wish.dart';
import 'package:akashic/layers/functional/Wishes/presentation/cubit/wishes_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WishesCubit extends Cubit<WishesState> {
  WishesCubit(this._wishes, this._removeWish) : super(const WishesState());

  final WishGateway _wishes;
  final RemoveWish _removeWish;
  StreamSubscription<List<Wish>>? _subscription;

  void start() {
    _subscription = _wishes.watchAll().listen((wishes) {
      if (isClosed) {
        return;
      }
      final filter = state.typeFilter;
      final keepsFilter = filter != null && wishes.any((wish) => wish.categoryType == filter);
      emit(state.copyWith(wishes: wishes, isLoading: false, typeFilter: () => keepsFilter ? filter : null));
    });
  }

  void filterBy(CategoryType? type) => emit(state.copyWith(typeFilter: () => type));

  Future<void> savePlan(String wishId, {required WishPriority priority, int? maxPriceCents}) => _wishes.savePlan(wishId, priority: priority, maxPriceCents: maxPriceCents);

  Future<void> remove(String wishId) async {
    emit(state.copyWith(wishes: state.wishes.where((wish) => wish.id != wishId).toList()));
    await _removeWish(wishId);
  }

  @override
  Future<void> close() async {
    await _subscription?.cancel();
    return super.close();
  }
}
