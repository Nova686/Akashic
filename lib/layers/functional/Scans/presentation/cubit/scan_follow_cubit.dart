import 'dart:async';

import 'package:akashic/layers/functional/Scans/domain/entities/scan_follow.dart';
import 'package:akashic/layers/functional/Scans/domain/entities/scan_progress.dart';
import 'package:akashic/layers/functional/Scans/domain/gateways/chapter_alerts.dart';
import 'package:akashic/layers/functional/Scans/domain/gateways/chapter_release_source.dart';
import 'package:akashic/layers/functional/Scans/domain/gateways/scan_gateway.dart';
import 'package:akashic/layers/functional/Scans/domain/use_cases/scan_reading.dart';
import 'package:akashic/layers/functional/Scans/domain/use_cases/scan_releases.dart';
import 'package:akashic/layers/functional/Scans/presentation/cubit/scan_follow_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ScanFollowCubit extends Cubit<ScanFollowState> {
  ScanFollowCubit({
    required this.seriesId,
    required this._scans,
    required this._searchReleaseSeries,
    required this._linkReleaseSeries,
    required this._refreshScanReleases,
    required this._notifier,
  }) : super(const ScanFollowState());

  final String seriesId;
  final ScanGateway _scans;
  final SearchReleaseSeries _searchReleaseSeries;
  final LinkReleaseSeries _linkReleaseSeries;
  final RefreshScanReleases _refreshScanReleases;
  final ChapterNotifier _notifier;
  StreamSubscription<ScanProgress?>? _subscription;

  void start() {
    _subscription = _scans.watchSeries(seriesId).listen(
      (progress) {
        if (!isClosed) {
          emit(state.copyWith(progress: () => progress, isLoading: false));
        }
      },
      onError: (Object _) {
        if (!isClosed) {
          emit(state.copyWith(isLoading: false, notice: ScanFollowNotice.refreshFailed));
        }
      },
    );
  }

  Future<void> follow() => FollowSeriesInScans(_scans)(seriesId);

  Future<void> unfollow() => _scans.unfollow(seriesId);

  Future<void> toggleChapter(double chapter) async {
    final isRead = state.progress?.readChapters.contains(chapter) ?? false;
    await (isRead ? UnmarkChapter(_scans)(seriesId, chapter) : MarkChapterRead(_scans)(seriesId, chapter));
  }

  Future<void> markReadUpTo(String text) async {
    final chapter = double.tryParse(text.trim().replaceAll(',', '.'));
    if (chapter != null) {
      await MarkReadUpTo(_scans)(seriesId, chapter);
    }
  }

  Future<void> _update(ScanFollow Function(ScanFollow follow) change) async {
    final follow = await _scans.followOf(seriesId);
    if (follow != null) {
      await UpdateScanFollow(_scans)(change(follow));
    }
  }

  Future<void> setSite(String url) => _update((follow) => follow.copyWith(siteUrl: () => url.trim().isEmpty ? null : url.trim()));

  Future<void> setTeam(String team) => _update((follow) => follow.copyWith(teamName: () => team.trim().isEmpty ? null : team.trim()));

  Future<void> setOnlyFollowedTeam(bool isOnly) => _update((follow) => follow.copyWith(onlyFollowedTeam: isOnly));

  Future<void> setAlerts(bool isEnabled) async {
    if (isEnabled && !await _notifier.requestPermission()) {
      if (!isClosed) {
        emit(state.copyWith(notice: ScanFollowNotice.notificationsRefused));
      }
      return;
    }
    await _update((follow) => follow.copyWith(alertsEnabled: isEnabled));
  }

  void showAllChapters() => emit(state.copyWith(showsAllChapters: true));

  Future<void> searchReleaseSeries(String query) async {
    emit(state.copyWith(isSearching: true));
    try {
      final candidates = await _searchReleaseSeries(query);
      if (!isClosed) {
        emit(state.copyWith(candidates: candidates, isSearching: false, notice: candidates.isEmpty ? ScanFollowNotice.nothingFound : null));
      }
    } on Exception {
      if (!isClosed) {
        emit(state.copyWith(isSearching: false, notice: ScanFollowNotice.refreshFailed));
      }
    }
  }

  Future<void> link(ReleaseSeriesCandidate candidate) async {
    final follow = await _scans.followOf(seriesId);
    if (follow == null) {
      return;
    }
    emit(state.copyWith(candidates: const []));
    await _linkReleaseSeries(follow, candidate.id);
    await refresh();
  }

  Future<void> unlink() async {
    final follow = await _scans.followOf(seriesId);
    if (follow != null) {
      await _linkReleaseSeries(follow.copyWith(alertsEnabled: false), null);
    }
  }

  Future<void> refresh() async {
    if (state.isRefreshing) {
      return;
    }
    emit(state.copyWith(isRefreshing: true));
    try {
      final outcome = await _refreshScanReleases(onlySeriesId: seriesId);
      await _refreshScanReleases.acknowledge(outcome.unannouncedReleases);
      if (!isClosed) {
        emit(state.copyWith(isRefreshing: false, notice: outcome.failedSeries > 0 ? ScanFollowNotice.refreshFailed : null));
      }
    } on Exception {
      if (!isClosed) {
        emit(state.copyWith(isRefreshing: false, notice: ScanFollowNotice.refreshFailed));
      }
    }
  }

  @override
  Future<void> close() async {
    await _subscription?.cancel();
    return super.close();
  }
}
