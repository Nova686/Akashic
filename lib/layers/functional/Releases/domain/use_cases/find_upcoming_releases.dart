import 'dart:async';

import 'package:akashic/layers/functional/Catalog/domain/entities/category_type.dart';
import 'package:akashic/layers/functional/Catalog/domain/gateways/category_gateway.dart';
import 'package:akashic/layers/functional/Collection/domain/gateways/collection_gateway.dart';
import 'package:akashic/layers/functional/Collection/domain/use_cases/work_identity.dart';
import 'package:akashic/layers/functional/Collection/domain/use_cases/resolve_display_title.dart';
import 'package:akashic/layers/functional/Lookup/domain/entities/card_game.dart';
import 'package:akashic/layers/functional/Lookup/domain/entities/source_unavailable.dart';
import 'package:akashic/layers/functional/Releases/domain/entities/release_interests.dart';
import 'package:akashic/layers/functional/Releases/domain/entities/upcoming_release.dart';
import 'package:akashic/layers/functional/Releases/domain/gateways/release_calendar.dart';
import 'package:akashic/layers/functional/Releases/domain/gateways/release_store.dart';
import 'package:akashic/layers/functional/Settings/domain/entities/preferred_languages.dart';
import 'package:akashic/layers/functional/Wishes/domain/entities/wish.dart';

class ReleasesUnavailable implements Exception {
  const ReleasesUnavailable();
}

class FindUpcomingReleases {
  FindUpcomingReleases(
    this._calendars,
    this._collection,
    this._categories,
    this._store, {
    required this._preferredLanguages,
    this._wishes,
    DateTime Function()? now,
    this._deadline = const Duration(seconds: 30),
  }) : _now = now ?? DateTime.now;

  static const int maximumFollowedSeries = 12;
  static const int maximumFollowedArtists = 12;
  static const Set<CategoryType> numberedTypes = {CategoryType.books, CategoryType.manga, CategoryType.comics};

  final List<ReleaseCalendar> _calendars;
  final CollectionGateway _collection;
  final CategoryGateway _categories;
  final ReleaseStore _store;
  final Future<PreferredLanguages> Function() _preferredLanguages;
  final Future<List<Wish>> Function()? _wishes;
  final DateTime Function() _now;
  final Duration _deadline;

  Future<ReleaseOutlook?> cached() => _store.cachedOutlook();

  Future<ReleaseOutlook> call() async {
    final interests = await followedInterests();
    final now = _now();
    final today = DateTime(now.year, now.month, now.day);
    final calendars = [for (final calendar in _calendars) if (calendar.isConfigured) calendar];
    final answers = interests.followedSubjects == 0 ? const <List<UpcomingRelease>?>[] : await Future.wait(calendars.map((calendar) => _ask(calendar, interests, today)));
    if (answers.isNotEmpty && answers.every((answer) => answer == null)) {
      throw const ReleasesUnavailable();
    }
    final releasesByKey = <String, UpcomingRelease>{
      for (final answer in answers)
        for (final release in answer ?? const <UpcomingRelease>[])
          if (release.kind == ReleaseKind.nextVolume || !release.isOutBy(today.subtract(recentReleaseWindow))) release.key: release,
    };
    final releases = releasesByKey.values.toList()
      ..sort((first, second) {
        final byDate = first.latestDate.compareTo(second.latestDate);
        return byDate != 0 ? byDate : first.title.compareTo(second.title);
      });
    final outlook = ReleaseOutlook(releases: releases, computedAt: now, followedSubjects: interests.followedSubjects);
    await _store.saveOutlook(outlook);
    return outlook;
  }

  Future<ReleaseInterests> followedInterests() async {
    final categories = [
      for (final node in await _categories.watchTree().first) ...[node.category, ...node.children],
    ];
    final typesByCategory = {for (final category in categories) category.id: category.type};
    final artistCounts = <String, int>{};
    final ownedTitles = <String>{};
    final highestVolumes = <String, int>{};
    final latestAdditions = <String, DateTime>{};
    for (final work in await _collection.watchOwnedWorks().first) {
      if (typesByCategory[work.categoryId] == CategoryType.music) {
        if (work.creator?.trim() case final artist? when artist.isNotEmpty) {
          artistCounts[artist] = (artistCounts[artist] ?? 0) + 1;
        }
        ownedTitles.addAll(work.titles.byLanguage.values.map(titleIdentityOf));
      }
      final seriesId = work.seriesId;
      final volumeNumber = work.volumeNumber;
      if (seriesId == null || volumeNumber == null || !numberedTypes.contains(typesByCategory[work.categoryId])) {
        continue;
      }
      if (volumeNumber > (highestVolumes[seriesId] ?? 0)) {
        highestVolumes[seriesId] = volumeNumber;
      }
      final addedAt = work.addedAt ?? DateTime(0);
      if (addedAt.isAfter(latestAdditions[seriesId] ?? DateTime(0))) {
        latestAdditions[seriesId] = addedAt;
      }
    }
    final preferredLanguages = await _preferredLanguages();
    final wishedVolumes = <String, Set<int>>{};
    for (final wish in await _wishes?.call() ?? const <Wish>[]) {
      if ((wish.key.seriesId, wish.key.volumeNumber) case (final seriesId?, final volumeNumber?)) {
        wishedVolumes.putIfAbsent(seriesId, () => {}).add(volumeNumber);
      }
    }
    final followed = <(FollowedSeries, DateTime)>[];
    final wished = <FollowedSeries>[];
    for (final series in await _collection.watchAllSeries().first) {
      final highestVolume = highestVolumes[series.id];
      final title = resolveDisplayTitle(series.titles, preferredLanguages);
      final wishedHere = wishedVolumes[series.id] ?? const <int>{};
      if (title != null) {
        wished.addAll([
          for (final volumeNumber in wishedHere.toList()..sort())
            if (volumeNumber > (highestVolume ?? 0)) FollowedSeries(seriesId: series.id, title: title, nextVolume: volumeNumber, isWished: true),
        ]);
      }
      if (highestVolume != null && wishedHere.contains(highestVolume + 1)) {
        continue;
      }
      final isComplete = (series.status?.toLowerCase().startsWith('finish') ?? false) && highestVolume != null && highestVolume >= (series.publishedVolumes ?? 0);
      if (highestVolume == null || title == null || isComplete) {
        continue;
      }
      followed.add((FollowedSeries(seriesId: series.id, title: title, nextVolume: highestVolume + 1), latestAdditions[series.id] ?? DateTime(0)));
    }
    followed.sort((first, second) => second.$2.compareTo(first.$2));
    return ReleaseInterests(
      cardGames: {
        for (final category in categories)
          if (category.type == CategoryType.cards) ?cardGameNamed(category.name),
      },
      series: [...wished, for (final (series, _) in followed.take(maximumFollowedSeries)) series],
      artists: [for (final MapEntry(key: artist) in (artistCounts.entries.toList()..sort((first, second) => second.value.compareTo(first.value))).take(maximumFollowedArtists)) artist],
      ownedTitles: ownedTitles,
    );
  }

  Future<List<UpcomingRelease>?> _ask(ReleaseCalendar calendar, ReleaseInterests interests, DateTime today) async {
    try {
      return await calendar.upcoming(interests, today: today).timeout(_deadline);
    } on SourceUnavailable {
      return null;
    } on TimeoutException {
      return null;
    }
  }
}
