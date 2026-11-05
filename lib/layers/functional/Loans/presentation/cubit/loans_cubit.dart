import 'dart:async';

import 'package:akashic/layers/functional/Loans/domain/entities/loan.dart';
import 'package:akashic/layers/functional/Loans/domain/use_cases/lending.dart';
import 'package:akashic/layers/functional/Loans/domain/use_cases/search_loans.dart';
import 'package:akashic/layers/functional/Settings/domain/entities/preferred_languages.dart';
import 'package:akashic/layers/functional/Settings/domain/use_cases/manage_preferred_languages.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoansState extends Equatable {
  const LoansState({this.loans = const [], this.isLoading = true, this.preferredLanguages = PreferredLanguages.defaults, this.query = ''});

  final List<Loan> loans;
  final bool isLoading;
  final PreferredLanguages preferredLanguages;
  final String query;

  List<Loan> get visibleLoans => searchLoans(loans, query);

  LoansState copyWith({List<Loan>? loans, bool? isLoading, PreferredLanguages? preferredLanguages, String? query}) => LoansState(
        loans: loans ?? this.loans,
        isLoading: isLoading ?? this.isLoading,
        preferredLanguages: preferredLanguages ?? this.preferredLanguages,
        query: query ?? this.query,
      );

  @override
  List<Object?> get props => [loans, isLoading, preferredLanguages, query];
}

class LoansCubit extends Cubit<LoansState> {
  LoansCubit(this._watchLoans, this._returnCopy, {this._preferredLanguages}) : super(const LoansState());

  final WatchLoans _watchLoans;
  final ReturnCopy _returnCopy;
  final ManagePreferredLanguages? _preferredLanguages;
  final List<StreamSubscription<Object?>> _subscriptions = [];

  void start() {
    _subscriptions.add(_watchLoans().listen((loans) {
      if (!isClosed) {
        emit(state.copyWith(loans: loans, isLoading: false));
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

  Future<void> markReturned(String copyId) => _returnCopy(copyId);

  void search(String query) => emit(state.copyWith(query: query));

  @override
  Future<void> close() async {
    for (final subscription in _subscriptions) {
      await subscription.cancel();
    }
    return super.close();
  }
}
