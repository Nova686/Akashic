import 'dart:async';

import 'package:akashic/layers/functional/Collection/domain/entities/localized_titles.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/series.dart';
import 'package:akashic/layers/functional/Collection/domain/gateways/collection_gateway.dart';
import 'package:akashic/layers/functional/Collection/domain/use_cases/create_series.dart';
import 'package:akashic/layers/functional/Collection/domain/use_cases/resolve_display_title.dart';
import 'package:akashic/layers/functional/Collection/domain/use_cases/search_text_normalizer.dart';
import 'package:akashic/layers/functional/Scans/domain/entities/scan_progress.dart';
import 'package:akashic/layers/functional/Scans/domain/gateways/scan_gateway.dart';
import 'package:akashic/layers/functional/Scans/domain/use_cases/scan_reading.dart';
import 'package:akashic/layers/functional/Settings/domain/entities/preferred_languages.dart';
import 'package:akashic/layers/functional/Settings/domain/use_cases/manage_preferred_languages.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ScanListEntry extends Equatable {
  const ScanListEntry({required this.series, required this.title, required this.progress});

  final Series series;
  final String title;
  final ScanProgress progress;

  @override
  List<Object?> get props => [series, title, progress];
}

class ScanListState extends Equatable {
  const ScanListState({this.entries = const [], this.unfollowedSeries = const [], this.isLoading = true});

  final List<ScanListEntry> entries;
  final List<(Series, String)> unfollowedSeries;
  final bool isLoading;

  @override
  List<Object?> get props => [entries, unfollowedSeries, isLoading];
}

class ScanListCubit extends Cubit<ScanListState> {
  ScanListCubit({
    required this.categoryId,
    required this._scans,
    required this._collection,
    required this._createSeries,
    this._preferredLanguages,
  }) : super(const ScanListState());

  final String categoryId;
  final ScanGateway _scans;
  final CollectionGateway _collection;
  final CreateSeries _createSeries;
  final ManagePreferredLanguages? _preferredLanguages;
  PreferredLanguages _languages = PreferredLanguages.defaults;
  final List<StreamSubscription<Object?>> _subscriptions = [];
  List<ScanProgress>? _latestProgress;
  List<Series>? _latestSeries;

  void start() {
    final preferredLanguages = _preferredLanguages;
    if (preferredLanguages != null) {
      _subscriptions.add(preferredLanguages.watch().listen((languages) {
        _languages = languages;
        _publish();
      }));
    }
    _subscriptions
      ..add(_scans.watchAll().listen((progress) {
        _latestProgress = progress;
        _publish();
      }))
      ..add(_collection.watchSeriesInCategoryTree(categoryId).listen((series) {
        _latestSeries = series;
        _publish();
      }));
  }

  void _publish() {
    final progress = _latestProgress;
    final series = _latestSeries;
    if (progress == null || series == null || isClosed) {
      return;
    }
    final progressBySeries = {for (final entry in progress) entry.follow.seriesId: entry};
    String titleOf(Series oneSeries) => resolveDisplayTitle(oneSeries.titles, _languages) ?? '';
    final entries = [
      for (final oneSeries in series)
        if (progressBySeries[oneSeries.id] case final followed?) ScanListEntry(series: oneSeries, title: titleOf(oneSeries), progress: followed),
    ]..sort((first, second) {
        final byNews = second.progress.newChapters.length.compareTo(first.progress.newChapters.length);
        return byNews != 0 ? byNews : normalizeForSearch(first.title).compareTo(normalizeForSearch(second.title));
      });
    final unfollowed = [
      for (final oneSeries in series)
        if (!progressBySeries.containsKey(oneSeries.id)) (oneSeries, titleOf(oneSeries)),
    ]..sort((first, second) => normalizeForSearch(first.$2).compareTo(normalizeForSearch(second.$2)));
    emit(ScanListState(entries: entries, unfollowedSeries: unfollowed, isLoading: false));
  }

  Future<String> follow(String seriesId) async {
    await FollowSeriesInScans(_scans)(seriesId);
    return seriesId;
  }

  Future<String?> createAndFollow(String title) async {
    if (title.trim().isEmpty) {
      return null;
    }
    final series = await _createSeries(categoryId: categoryId, titles: LocalizedTitles(byLanguage: {_languages.codes.firstOrNull ?? 'fr': title.trim()}));
    return follow(series.id);
  }

  @override
  Future<void> close() async {
    for (final subscription in _subscriptions) {
      await subscription.cancel();
    }
    return super.close();
  }
}
