import 'dart:async';

import 'package:akashic/layers/functional/Collection/domain/entities/collection_item.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/series.dart';
import 'package:akashic/layers/functional/Collection/domain/use_cases/resolve_display_title.dart';
import 'package:akashic/layers/functional/Collection/domain/use_cases/series_completion.dart';
import 'package:akashic/layers/functional/Collection/domain/use_cases/series_volumes.dart';
import 'package:akashic/layers/functional/Collection/domain/use_cases/update_series_from_source.dart';
import 'package:akashic/layers/functional/Collection/presentation/cubit/series_detail_state.dart';
import 'package:akashic/layers/functional/Lookup/domain/entities/source_unavailable.dart';
import 'package:akashic/layers/functional/Settings/domain/use_cases/manage_preferred_languages.dart';
import 'package:akashic/layers/functional/Wishes/domain/use_cases/wish_missing_volumes.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SeriesDetailCubit extends Cubit<SeriesDetailState> {
  SeriesDetailCubit({
    required this.seriesId,
    required this._watchSeriesVolumes,
    required this._setPublishedVolumes,
    this._updateFromSource,
    this._preferredLanguages,
    this._wishMissingVolumes,
  }) : super(const SeriesDetailState());

  final String seriesId;
  final WatchSeriesVolumes _watchSeriesVolumes;
  final SetPublishedVolumes _setPublishedVolumes;
  final UpdateSeriesFromSource? _updateFromSource;
  final ManagePreferredLanguages? _preferredLanguages;
  final WishMissingVolumes? _wishMissingVolumes;
  final List<StreamSubscription<Object?>> _subscriptions = [];
  StreamSubscription<List<CollectionItem>>? _volumesSubscription;
  String? _watchedCategoryId;

  void start() {
    _subscriptions.add(_watchSeriesVolumes.series(seriesId).listen(_onSeries));
    final preferredLanguages = _preferredLanguages;
    if (preferredLanguages != null) {
      _subscriptions.add(preferredLanguages.watch().listen((languages) => emit(state.copyWith(preferredLanguages: languages))));
    }
  }

  void _onSeries(Series? series) {
    if (series == null || isClosed) {
      return;
    }
    emit(state.copyWith(series: series, isLoading: false, completion: _completionFor(series, state.volumes)));
    if (_watchedCategoryId != series.categoryId) {
      _watchedCategoryId = series.categoryId;
      _volumesSubscription?.cancel();
      _volumesSubscription = _watchSeriesVolumes.volumes(series).listen((volumes) {
        final current = state.series;
        if (!isClosed && current != null) {
          emit(state.copyWith(volumes: volumes, completion: _completionFor(current, volumes)));
        }
      });
    }
  }

  SeriesCompletion _completionFor(Series series, List<CollectionItem> volumes) =>
      computeSeriesCompletion(series, {for (final volume in volumes) ?volume.volumeNumber});

  Future<void> setPublishedVolumes(String text) async {
    final series = state.series;
    if (series == null) {
      return;
    }
    await _setPublishedVolumes(series, int.tryParse(text.trim()));
  }

  Future<void> updateFromSource() async {
    final series = state.series;
    final update = _updateFromSource;
    if (series == null || update == null) {
      return;
    }
    emit(state.copyWith(isUpdating: true));
    try {
      await update(series, ownedVolumes: {for (final volume in state.volumes) ?volume.volumeNumber});
      if (!isClosed) {
        emit(state.copyWith(isUpdating: false));
      }
    } on SourceUnavailable {
      if (!isClosed) {
        emit(state.copyWith(isUpdating: false, updateFailed: true));
      }
    }
  }

  Future<void> wishMissingVolumes() async {
    final series = state.series;
    final completion = state.completion;
    final wishMissing = _wishMissingVolumes;
    if (series == null || completion == null || wishMissing == null) {
      return;
    }
    final added = await wishMissing(
      series: series,
      seriesTitle: resolveDisplayTitle(series.titles, state.preferredLanguages) ?? '',
      missingVolumes: completion.missing,
    );
    if (!isClosed) {
      emit(state.copyWith(missingVolumesWished: added));
    }
  }

  @override
  Future<void> close() async {
    await _volumesSubscription?.cancel();
    for (final subscription in _subscriptions) {
      await subscription.cancel();
    }
    return super.close();
  }
}
