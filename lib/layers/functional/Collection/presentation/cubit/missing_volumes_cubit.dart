import 'dart:async';

import 'package:akashic/layers/functional/Collection/domain/entities/series.dart';
import 'package:akashic/layers/functional/Collection/domain/gateways/collection_gateway.dart';
import 'package:akashic/layers/functional/Collection/domain/use_cases/resolve_display_title.dart';
import 'package:akashic/layers/functional/Collection/domain/use_cases/series_completion.dart';
import 'package:akashic/layers/functional/Settings/domain/entities/preferred_languages.dart';
import 'package:akashic/layers/functional/Settings/domain/use_cases/manage_preferred_languages.dart';
import 'package:akashic/layers/functional/Wishes/domain/gateways/wish_gateway.dart';
import 'package:akashic/layers/functional/Wishes/domain/use_cases/wish_missing_volumes.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SeriesGaps extends Equatable {
  const SeriesGaps({required this.series, required this.title, required this.completion, required this.wishedVolumes});

  final Series series;
  final String title;
  final SeriesCompletion completion;
  final Set<int> wishedVolumes;

  List<int> get unwishedMissing => [for (final number in completion.missing) if (!wishedVolumes.contains(number)) number];

  @override
  List<Object?> get props => [series, title, completion, wishedVolumes];
}

class MissingVolumesState extends Equatable {
  const MissingVolumesState({this.series = const [], this.isLoading = true});

  final List<SeriesGaps> series;
  final bool isLoading;

  int get missingCount => series.fold(0, (total, gaps) => total + gaps.completion.missing.length);

  int get unwishedCount => series.fold(0, (total, gaps) => total + gaps.unwishedMissing.length);

  @override
  List<Object?> get props => [series, isLoading];
}

class MissingVolumesCubit extends Cubit<MissingVolumesState> {
  MissingVolumesCubit(this._collection, this._wishes, this._wishMissingVolumes, {this.preferredLanguages})
      : super(const MissingVolumesState());

  final CollectionGateway _collection;
  final WishGateway _wishes;
  final WishMissingVolumes _wishMissingVolumes;
  final ManagePreferredLanguages? preferredLanguages;
  final List<StreamSubscription<Object?>> _subscriptions = [];
  int _generation = 0;

  void start() {
    _subscriptions
      ..add(_collection.watchAllSeries().listen((_) => _refresh()))
      ..add(_collection.watchOwnedWorks().listen((_) => _refresh()))
      ..add(_wishes.watchAll().listen((_) => _refresh()));
  }

  Future<void> _refresh() async {
    final generation = ++_generation;
    try {
      await _compute(generation);
    } on Exception {
      if (!isClosed && generation == _generation) {
        emit(MissingVolumesState(series: state.series, isLoading: false));
      }
    }
  }

  Future<void> _compute(int generation) async {
    final languages = await preferredLanguages?.current() ?? PreferredLanguages.defaults;
    final owned = await _collection.ownedVolumesBySeries();
    final wishedBySeries = <String, Set<int>>{};
    for (final wish in await _wishes.all()) {
      if ((wish.key.seriesId, wish.key.volumeNumber) case (final seriesId?, final volume?)) {
        wishedBySeries.putIfAbsent(seriesId, () => {}).add(volume);
      }
    }
    final gaps = [
      for (final series in await _collection.watchAllSeries().first)
        if (computeSeriesCompletion(series, owned[series.id] ?? const {}) case final completion when completion.missing.isNotEmpty && completion.owned.isNotEmpty)
          SeriesGaps(series: series, title: resolveDisplayTitle(series.titles, languages) ?? '', completion: completion, wishedVolumes: wishedBySeries[series.id] ?? const {}),
    ]..sort((first, second) => first.title.toLowerCase().compareTo(second.title.toLowerCase()));
    if (!isClosed && generation == _generation) {
      emit(MissingVolumesState(series: gaps, isLoading: false));
    }
  }

  Future<int> wish(SeriesGaps gaps, List<int> volumes) => _wishMissingVolumes(series: gaps.series, seriesTitle: gaps.title, missingVolumes: volumes);

  Future<int> wishEverything() async {
    var added = 0;
    for (final gaps in state.series) {
      added += await wish(gaps, gaps.unwishedMissing);
    }
    return added;
  }

  @override
  Future<void> close() async {
    for (final subscription in _subscriptions) {
      await subscription.cancel();
    }
    return super.close();
  }
}
