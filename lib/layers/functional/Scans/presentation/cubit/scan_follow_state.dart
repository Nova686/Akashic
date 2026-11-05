import 'package:akashic/layers/functional/Scans/domain/entities/scan_progress.dart';
import 'package:akashic/layers/functional/Scans/domain/gateways/chapter_release_source.dart';
import 'package:equatable/equatable.dart';

enum ScanFollowNotice { none, refreshFailed, notificationsRefused, nothingFound }

class ScanFollowState extends Equatable {
  const ScanFollowState({
    this.progress,
    this.isLoading = true,
    this.candidates = const [],
    this.isSearching = false,
    this.isRefreshing = false,
    this.showsAllChapters = false,
    this.notice = ScanFollowNotice.none,
  });

  final ScanProgress? progress;
  final bool isLoading;
  final List<ReleaseSeriesCandidate> candidates;
  final bool isSearching;
  final bool isRefreshing;
  final bool showsAllChapters;
  final ScanFollowNotice notice;

  bool get isFollowed => progress != null;

  ScanFollowState copyWith({
    ScanProgress? Function()? progress,
    bool? isLoading,
    List<ReleaseSeriesCandidate>? candidates,
    bool? isSearching,
    bool? isRefreshing,
    bool? showsAllChapters,
    ScanFollowNotice? notice,
  }) {
    return ScanFollowState(
      progress: progress == null ? this.progress : progress(),
      isLoading: isLoading ?? this.isLoading,
      candidates: candidates ?? this.candidates,
      isSearching: isSearching ?? this.isSearching,
      isRefreshing: isRefreshing ?? this.isRefreshing,
      showsAllChapters: showsAllChapters ?? this.showsAllChapters,
      notice: notice ?? ScanFollowNotice.none,
    );
  }

  @override
  List<Object?> get props => [progress, isLoading, candidates, isSearching, isRefreshing, showsAllChapters, notice];
}
