import 'dart:async';

import 'package:akashic/layers/functional/Settings/domain/entities/preferred_languages.dart';
import 'package:akashic/layers/functional/Settings/domain/use_cases/manage_preferred_languages.dart';
import 'package:akashic/layers/functional/Trades/domain/entities/trade_history.dart';
import 'package:akashic/layers/functional/Trades/domain/gateways/trade_gateway.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TradeHistoryState extends Equatable {
  const TradeHistoryState({this.history = const TradeHistory(), this.isLoading = true, this.preferredLanguages = PreferredLanguages.defaults});

  final TradeHistory history;
  final bool isLoading;
  final PreferredLanguages preferredLanguages;

  TradeHistoryState copyWith({TradeHistory? history, bool? isLoading, PreferredLanguages? preferredLanguages}) => TradeHistoryState(
        history: history ?? this.history,
        isLoading: isLoading ?? this.isLoading,
        preferredLanguages: preferredLanguages ?? this.preferredLanguages,
      );

  @override
  List<Object?> get props => [history, isLoading, preferredLanguages];
}

class TradeHistoryCubit extends Cubit<TradeHistoryState> {
  TradeHistoryCubit(this._trades, {this._preferredLanguages}) : super(const TradeHistoryState());

  final TradeGateway _trades;
  final ManagePreferredLanguages? _preferredLanguages;
  final List<StreamSubscription<Object?>> _subscriptions = [];

  void start() {
    _subscriptions.add(_trades.watchHistory().listen((history) {
      if (!isClosed) {
        emit(state.copyWith(history: history, isLoading: false));
      }
    }));
    final preferredLanguages = _preferredLanguages;
    if (preferredLanguages != null) {
      _subscriptions.add(preferredLanguages.watch().listen((languages) {
        if (!isClosed) {
          emit(state.copyWith(preferredLanguages: languages));
        }
      }));
    }
  }

  @override
  Future<void> close() async {
    for (final subscription in _subscriptions) {
      await subscription.cancel();
    }
    return super.close();
  }
}
