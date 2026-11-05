import 'package:akashic/layers/functional/Collection/domain/entities/localized_titles.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/series.dart';
import 'package:akashic/layers/functional/Scans/data/background/local_chapter_notifier.dart';
import 'package:akashic/layers/functional/Scans/data/gateways/drift_scan_gateway.dart';
import 'package:akashic/layers/functional/Scans/domain/entities/scan_follow.dart';
import 'package:akashic/layers/functional/Scans/domain/gateways/chapter_alerts.dart';
import 'package:akashic/layers/functional/Scans/domain/gateways/chapter_release_source.dart';
import 'package:akashic/layers/functional/Scans/domain/use_cases/check_scan_releases.dart';
import 'package:akashic/layers/functional/Scans/domain/use_cases/scan_releases.dart';
import 'package:akashic/layers/functional/Settings/domain/entities/preferred_languages.dart';
import 'package:flutter_test/flutter_test.dart';

import '../Collection/collection_harness.dart';
import 'manga_updates_test.dart' show ScriptedReleases;

class RecordingNotifier implements ChapterNotifier {
  final List<ChapterNotice> announced = [];

  @override
  Future<bool> requestPermission() async => true;

  @override
  Future<void> announce(List<ChapterNotice> notices) async => announced.addAll(notices);
}

void main() {
  late CollectionHarness harness;
  late DriftScanGateway scans;
  late ScriptedReleases source;
  late RecordingNotifier notifier;
  late CheckScanReleases check;

  setUp(() async {
    harness = CollectionHarness();
    scans = DriftScanGateway(harness.database);
    source = ScriptedReleases();
    notifier = RecordingNotifier();
    check = CheckScanReleases(RefreshScanReleases(scans, source), harness.collection, notifier, () async => PreferredLanguages.defaults);
    final mangas = await harness.mangas();
    for (final (id, title) in [('frieren', 'Frieren'), ('dandadan', 'Dandadan')]) {
      await harness.collection.saveSeries(Series(id: id, categoryId: mangas.id, titles: LocalizedTitles(byLanguage: {'fr': title})));
      await scans.saveFollow(ScanFollow(seriesId: id, mangaUpdatesSeriesId: 'mu-$id', alertsEnabled: true));
    }
    source.published = const [PublishedChapters(chapters: [10], teamName: 'Team')];
    await check();
  });

  tearDown(() => harness.database.close());

  test('a background check announces each series once', () async {
    source.published = const [PublishedChapters(chapters: [11, 12], teamName: 'Team'), PublishedChapters(chapters: [10], teamName: 'Team')];
    await check();
    await check();
    expect(notifier.announced, [
      const ChapterNotice(seriesId: 'frieren', seriesTitle: 'Frieren', chapters: [11, 12]),
      const ChapterNotice(seriesId: 'dandadan', seriesTitle: 'Dandadan', chapters: [11, 12]),
    ]);
  });

  test('a series without alerts is never announced', () async {
    final follow = (await scans.followOf('dandadan'))!;
    await scans.saveFollow(follow.copyWith(alertsEnabled: false));
    source.published = const [PublishedChapters(chapters: [11], teamName: 'Team')];
    await check();
    expect(notifier.announced.map((notice) => notice.seriesId), ['frieren']);
  });

  test('without network nothing is announced and nothing is lost', () async {
    source.isDown = true;
    final outcome = await check();
    expect(outcome.failedSeries, 2);
    expect(notifier.announced, isEmpty);
    source
      ..isDown = false
      ..published = const [PublishedChapters(chapters: [11], teamName: 'Team')];
    await check();
    expect(notifier.announced, hasLength(2));
    expect((await scans.watchSeries('frieren').first)!.releases.map((release) => release.chapter), unorderedEquals([10, 11]));
  });

  test('notification ids are stable per series', () {
    expect(notificationIdFor('frieren'), notificationIdFor('frieren'));
    expect(notificationIdFor('frieren'), isNot(notificationIdFor('dandadan')));
    expect(notificationIdFor('frieren'), greaterThanOrEqualTo(0));
  });

  test('the background check does not ask about series without alerts', () async {
    final follow = (await scans.followOf('dandadan'))!;
    await scans.saveFollow(follow.copyWith(alertsEnabled: false));
    final asked = <String>[];
    final tracking = CheckScanReleases(RefreshScanReleases(scans, RecordingReleases(source, asked)), harness.collection, notifier, () async => PreferredLanguages.defaults);
    await tracking();
    expect(asked, ['mu-frieren']);
  });
}

class RecordingReleases implements ChapterReleaseSource {
  RecordingReleases(this._inner, this.asked);

  final ChapterReleaseSource _inner;
  final List<String> asked;

  @override
  Future<List<ReleaseSeriesCandidate>> searchSeries(String query) => _inner.searchSeries(query);

  @override
  Future<List<PublishedChapters>> releasesOf(String releaseSeriesId) {
    asked.add(releaseSeriesId);
    return _inner.releasesOf(releaseSeriesId);
  }
}
