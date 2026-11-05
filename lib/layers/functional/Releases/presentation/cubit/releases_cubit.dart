import 'package:akashic/layers/functional/Collection/domain/use_cases/search_text_normalizer.dart';
import 'package:akashic/layers/functional/Releases/domain/entities/upcoming_release.dart';
import 'package:akashic/layers/functional/Releases/domain/gateways/release_notifier.dart';
import 'package:akashic/layers/functional/Releases/domain/use_cases/find_upcoming_releases.dart';
import 'package:akashic/layers/technical/Feedback/error_toasts.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ReleaseSection extends Equatable {
  const ReleaseSection({required this.releases, this.isAlreadyOut = false, this.month, this.year});

  final List<UpcomingRelease> releases;
  final bool isAlreadyOut;
  final DateTime? month;
  final int? year;

  @override
  List<Object?> get props => [releases, isAlreadyOut, month, year];
}

class ReleasesState extends Equatable {
  const ReleasesState({
    this.outlook,
    this.isLoading = true,
    this.isRefreshing = false,
    this.isOffline = false,
    this.kinds = const {},
    this.confirmedOnly = false,
    this.wishedOnly = false,
    this.query = '',
  });

  final ReleaseOutlook? outlook;
  final bool isLoading;
  final bool isRefreshing;
  final bool isOffline;
  final Set<ReleaseKind> kinds;
  final bool confirmedOnly;
  final bool wishedOnly;
  final String query;

  bool get isFiltered => kinds.isNotEmpty || confirmedOnly || wishedOnly || query.trim().isNotEmpty;

  List<ReleaseKind> get availableKinds => [for (final kind in ReleaseKind.values) if (outlook?.releases.any((release) => release.kind == kind) ?? false) kind];

  bool _keeps(UpcomingRelease release) {
    if ((kinds.isNotEmpty && !kinds.contains(release.kind)) || (confirmedOnly && release.isEstimated) || (wishedOnly && !release.isWished)) {
      return false;
    }
    final haystack = normalizeForSearch('${release.title} ${release.subject}');
    return normalizeForSearch(query).split(' ').where((word) => word.isNotEmpty).every(haystack.contains);
  }

  List<ReleaseSection> get sections {
    final outlook = this.outlook;
    if (outlook == null) {
      return const [];
    }
    final today = DateTime(outlook.computedAt.year, outlook.computedAt.month, outlook.computedAt.day);
    final kept = outlook.releases.where(_keeps).toList();
    final alreadyOut = [for (final release in kept) if (release.isOutBy(today)) release];
    final upcoming = <String, List<UpcomingRelease>>{};
    for (final release in kept.where((release) => !release.isOutBy(today))) {
      final key = release.datePrecision == ReleaseDatePrecision.year ? '${release.releaseDate.year}' : '${release.releaseDate.year}-${release.releaseDate.month}';
      upcoming.putIfAbsent(key, () => []).add(release);
    }
    return [
      if (alreadyOut.isNotEmpty) ReleaseSection(releases: alreadyOut, isAlreadyOut: true),
      for (final releases in upcoming.values)
        releases.first.datePrecision == ReleaseDatePrecision.year
            ? ReleaseSection(releases: releases, year: releases.first.releaseDate.year)
            : ReleaseSection(releases: releases, month: DateTime(releases.first.releaseDate.year, releases.first.releaseDate.month)),
    ];
  }

  ReleasesState copyWith({ReleaseOutlook? outlook, bool? isLoading, bool? isRefreshing, bool? isOffline, Set<ReleaseKind>? kinds, bool? confirmedOnly, bool? wishedOnly, String? query}) {
    return ReleasesState(
      outlook: outlook ?? this.outlook,
      isLoading: isLoading ?? this.isLoading,
      isRefreshing: isRefreshing ?? this.isRefreshing,
      isOffline: isOffline ?? this.isOffline,
      kinds: kinds ?? this.kinds,
      confirmedOnly: confirmedOnly ?? this.confirmedOnly,
      wishedOnly: wishedOnly ?? this.wishedOnly,
      query: query ?? this.query,
    );
  }

  @override
  List<Object?> get props => [outlook, isLoading, isRefreshing, isOffline, kinds, confirmedOnly, wishedOnly, query];
}

class ReleasesCubit extends Cubit<ReleasesState> {
  ReleasesCubit(this._findUpcomingReleases, this._notifier, {DateTime Function()? now, this._staleAfter = const Duration(days: 1)})
      : _now = now ?? DateTime.now,
        super(const ReleasesState());

  final FindUpcomingReleases _findUpcomingReleases;
  final ReleaseNotifier _notifier;
  final DateTime Function() _now;
  final Duration _staleAfter;

  Future<void> start() async {
    final cached = await _findUpcomingReleases.cached();
    if (isClosed) {
      return;
    }
    emit(state.copyWith(outlook: cached, isLoading: cached == null));
    if (cached == null || _now().difference(cached.computedAt) > _staleAfter) {
      await refresh();
    }
    await _notifier.requestPermission();
  }

  void toggleKind(ReleaseKind kind) => emit(state.copyWith(kinds: state.kinds.contains(kind) ? ({...state.kinds}..remove(kind)) : {...state.kinds, kind}));

  void toggleConfirmedOnly() => emit(state.copyWith(confirmedOnly: !state.confirmedOnly));

  void toggleWishedOnly() => emit(state.copyWith(wishedOnly: !state.wishedOnly));

  void search(String query) => emit(state.copyWith(query: query));

  void resetFilters() => emit(state.copyWith(kinds: const {}, confirmedOnly: false, wishedOnly: false, query: ''));

  Future<void> refresh() async {
    if (state.isRefreshing) {
      return;
    }
    emit(state.copyWith(isRefreshing: true));
    try {
      final outlook = await _findUpcomingReleases();
      if (!isClosed) {
        emit(state.copyWith(outlook: outlook, isOffline: false));
      }
    } on ReleasesUnavailable {
      ErrorToasts.instance.show((l10n) => l10n.releasesFailedToast);
      if (!isClosed) {
        emit(state.copyWith(isOffline: true));
      }
    } on Exception catch (failure) {
      ErrorToasts.instance.showUnexpected(failure);
      if (!isClosed) {
        emit(state.copyWith(isOffline: true));
      }
    } finally {
      if (!isClosed) {
        emit(state.copyWith(isLoading: false, isRefreshing: false));
      }
    }
  }
}
