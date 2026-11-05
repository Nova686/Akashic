import 'package:akashic/layers/functional/Settings/domain/entities/preferred_languages.dart';
import 'package:akashic/layers/functional/Stats/domain/entities/collection_value.dart';
import 'package:equatable/equatable.dart';

class CollectionValueState extends Equatable {
  const CollectionValueState({
    this.value,
    this.duplicates,
    this.preferredLanguages = PreferredLanguages.defaults,
    this.isRefreshing = false,
    this.refreshDone = 0,
    this.refreshTotal = 0,
    this.lastRefresh,
  });

  final CollectionValue? value;
  final Duplicates? duplicates;
  final PreferredLanguages preferredLanguages;
  final bool isRefreshing;
  final int refreshDone;
  final int refreshTotal;
  final ValueRefresh? lastRefresh;

  CollectionValueState copyWith({
    CollectionValue? value,
    Duplicates? duplicates,
    PreferredLanguages? preferredLanguages,
    bool? isRefreshing,
    int? refreshDone,
    int? refreshTotal,
    ValueRefresh? lastRefresh,
  }) => CollectionValueState(
    value: value ?? this.value,
    duplicates: duplicates ?? this.duplicates,
    preferredLanguages: preferredLanguages ?? this.preferredLanguages,
    isRefreshing: isRefreshing ?? this.isRefreshing,
    refreshDone: refreshDone ?? this.refreshDone,
    refreshTotal: refreshTotal ?? this.refreshTotal,
    lastRefresh: lastRefresh ?? this.lastRefresh,
  );

  @override
  List<Object?> get props => [value, duplicates, preferredLanguages, isRefreshing, refreshDone, refreshTotal, lastRefresh];
}
