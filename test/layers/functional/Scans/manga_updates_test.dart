import 'package:akashic/layers/functional/Collection/domain/entities/localized_titles.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/series.dart';
import 'package:akashic/layers/functional/Lookup/domain/entities/source_unavailable.dart';
import 'package:akashic/layers/functional/Scans/data/gateways/drift_scan_gateway.dart';
import 'package:akashic/layers/functional/Scans/data/sources/manga_updates_source.dart';
import 'package:akashic/layers/functional/Scans/domain/entities/scan_follow.dart';
import 'package:akashic/layers/functional/Scans/domain/entities/scan_release.dart';
import 'package:akashic/layers/functional/Scans/domain/gateways/chapter_release_source.dart';
import 'package:akashic/layers/functional/Scans/domain/use_cases/scan_reading.dart';
import 'package:akashic/layers/functional/Scans/domain/use_cases/scan_releases.dart';
import 'package:flutter_test/flutter_test.dart';

import '../Collection/collection_harness.dart';
import '../Lookup/data/fixture_client.dart';

class ScriptedReleases implements ChapterReleaseSource {
  List<PublishedChapters> published = const [];
  bool isDown = false;

  @override
  Future<List<ReleaseSeriesCandidate>> searchSeries(String query) async => const [];

  @override
  Future<List<PublishedChapters>> releasesOf(String releaseSeriesId) async {
    if (isDown) {
      throw const SourceUnavailable('mangaupdates');
    }
    return published;
  }
}

void main() {
  test('the series search proposes neither doujinshi nor adult series', () async {
    final candidates = await MangaUpdatesSource(clientReturning(fixture('mangaupdates_search.json'))).searchSeries('frieren');
    expect(candidates.first.title, 'Sousou no Frieren');
    expect(candidates.first.id, '66296374554');
    expect(candidates.any((candidate) => candidate.kind == 'Doujinshi'), isFalse);
    expect(candidates.any((candidate) => candidate.title.startsWith('2-Ri de Watashi')), isFalse);
  });

  test('the release feed gives each chapter with its team', () async {
    final releases = await MangaUpdatesSource(clientReturning(fixture('mangaupdates_series_rss.xml'))).releasesOf('66296374554');
    expect(releases.first.chapters, [147]);
    expect(releases.first.teamName, 'Likemanga');
    expect(releases.any((release) => release.teamName == 'Kirei Cake'), isTrue);
  });

  test('team names are decoded and joint releases count for each team', () async {
    const feed = '<rss><channel><item><title>Frieren c.148</title><description>Hachi&#039;s Scans &amp; Kirei Cake</description></item></channel></rss>';
    final releases = await MangaUpdatesSource(clientReturning(feed)).releasesOf('1');
    expect(releases.single.teamName, "Hachi's Scans & Kirei Cake");
    final release = ScanRelease(seriesId: 'frieren', chapter: 148, teamName: releases.single.teamName);
    expect(release.isFromTeam('kirei cake'), isTrue);
    expect(release.isFromTeam("Hachi's Scans"), isTrue);
    expect(release.isFromTeam('Other'), isFalse);
  });

  group('refreshing releases', () {
    late CollectionHarness harness;
    late DriftScanGateway scans;
    late ScriptedReleases source;
    late RefreshScanReleases refreshReleases;

    Future<ReleaseRefresh> refresh() async {
      final outcome = await refreshReleases();
      await refreshReleases.acknowledge(outcome.unannouncedReleases);
      return outcome;
    }

    setUp(() async {
      harness = CollectionHarness();
      scans = DriftScanGateway(harness.database);
      source = ScriptedReleases();
      refreshReleases = RefreshScanReleases(scans, source, now: () => DateTime(2026, 10, 27));
      final mangas = await harness.mangas();
      await harness.collection.saveSeries(Series(id: 'frieren', categoryId: mangas.id, titles: const LocalizedTitles(byLanguage: {'fr': 'Frieren'})));
      await scans.saveFollow(const ScanFollow(seriesId: 'frieren', mangaUpdatesSeriesId: '66296374554', alertsEnabled: true));
      source.published = const [PublishedChapters(chapters: [145, 146], teamName: 'Likemanga')];
    });

    tearDown(() => harness.database.close());

    test('the first check announces nothing from the back catalogue', () async {
      expect((await refresh()).announcements, isEmpty);
      expect((await scans.watchSeries('frieren').first)!.newChapters, [145, 146]);
    });

    test('the same release is announced once', () async {
      await refresh();
      await MarkReadUpTo(scans)('frieren', 146);
      source.published = const [PublishedChapters(chapters: [147], teamName: 'Likemanga'), PublishedChapters(chapters: [146], teamName: 'Likemanga')];
      expect((await refresh()).announcements, [const ChapterAnnouncement(seriesId: 'frieren', chapters: [147])]);
      expect((await refresh()).announcements, isEmpty);
    });

    test('a release of another team is not announced when the filter is on', () async {
      await refresh();
      final follow = (await scans.followOf('frieren'))!;
      await scans.saveFollow(follow.copyWith(teamName: () => 'Likemanga', onlyFollowedTeam: true));
      source.published = const [PublishedChapters(chapters: [147], teamName: 'Other team')];
      expect((await refresh()).announcements, isEmpty);
    });

    test('offline refresh keeps everything', () async {
      await refresh();
      source.isDown = true;
      final outcome = await refresh();
      expect(outcome.failedSeries, 1);
      expect((await scans.watchSeries('frieren').first)!.releases, hasLength(2));
      expect((await scans.followOf('frieren'))!.lastCheckedAt, DateTime(2026, 10, 27));
    });

    test('releases left unannounced by an interrupted run are announced next time', () async {
      await refresh();
      source.published = const [PublishedChapters(chapters: [147], teamName: 'Likemanga')];
      await refreshReleases();
      final next = await refresh();
      expect(next.announcements, [const ChapterAnnouncement(seriesId: 'frieren', chapters: [147])]);
    });

    test('an empty first feed does not use up the first check', () async {
      source.published = const [];
      await refresh();
      expect((await scans.followOf('frieren'))!.lastCheckedAt, isNull);
      source.published = const [PublishedChapters(chapters: [145, 146], teamName: 'Likemanga')];
      expect((await refresh()).announcements, isEmpty);
    });

    test('linking another series forgets the previous releases but keeps the reading', () async {
      await refresh();
      await MarkReadUpTo(scans)('frieren', 3);
      await LinkReleaseSeries(scans)((await scans.followOf('frieren'))!, 'another');
      final progress = (await scans.watchSeries('frieren').first)!;
      expect(progress.releases, isEmpty);
      expect(progress.lastRead, 3);
    });
  });
}
