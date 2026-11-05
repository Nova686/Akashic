import 'package:akashic/layers/functional/Collection/domain/entities/localized_titles.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/series.dart';
import 'package:akashic/layers/functional/Scans/data/gateways/drift_scan_gateway.dart';
import 'package:akashic/layers/functional/Scans/domain/entities/chapter_number.dart';
import 'package:akashic/layers/functional/Scans/domain/entities/scan_follow.dart';
import 'package:akashic/layers/functional/Scans/domain/entities/scan_progress.dart';
import 'package:akashic/layers/functional/Scans/domain/entities/scan_release.dart';
import 'package:akashic/layers/functional/Scans/domain/use_cases/scan_reading.dart';
import 'package:flutter_test/flutter_test.dart';

import '../Collection/collection_harness.dart';

void main() {
  late CollectionHarness harness;
  late DriftScanGateway scans;

  setUp(() async {
    harness = CollectionHarness();
    scans = DriftScanGateway(harness.database);
    final mangas = await harness.mangas();
    await harness.collection.saveSeries(Series(id: 'frieren', categoryId: mangas.id, titles: const LocalizedTitles(byLanguage: {'fr': 'Frieren'})));
    await FollowSeriesInScans(scans)('frieren');
  });

  tearDown(() => harness.database.close());

  Future<ScanProgress> progress() async => (await scans.watchSeries('frieren').first)!;

  test('read up to 12 then unchecking 12 makes 11 the last read', () async {
    await scans.addReleases(const [ScanRelease(seriesId: 'frieren', chapter: 10.5, teamName: 'Team A')]);
    await MarkReadUpTo(scans)('frieren', 12);
    expect((await progress()).lastRead, 12);
    expect((await progress()).readChapters, contains(10.5));
    await UnmarkChapter(scans)('frieren', 12);
    expect((await progress()).lastRead, 11);
    await MarkChapterRead(scans)('frieren', 14);
    expect((await progress()).lastRead, 14);
  });

  test('other teams do not count when the filter is on', () async {
    await scans.addReleases(const [
      ScanRelease(seriesId: 'frieren', chapter: 13, teamName: 'Team A'),
      ScanRelease(seriesId: 'frieren', chapter: 14, teamName: 'Team B'),
      ScanRelease(seriesId: 'frieren', chapter: 14, teamName: 'team a'),
      ScanRelease(seriesId: 'frieren', chapter: 15, teamName: 'Team B'),
    ]);
    await MarkReadUpTo(scans)('frieren', 12);
    expect((await progress()).newChapters, [13, 14, 15]);
    await UpdateScanFollow(scans)(const ScanFollow(seriesId: 'frieren', teamName: 'Team A', onlyFollowedTeam: true));
    expect((await progress()).newChapters, [13, 14]);
    expect((await progress()).latestReleased, 14);
  });

  test('the same release is stored once', () async {
    const release = ScanRelease(seriesId: 'frieren', chapter: 13, teamName: 'Team A');
    expect(await scans.addReleases(const [release]), [release]);
    expect(await scans.addReleases(const [release]), isEmpty);
  });

  test('following twice keeps the first settings', () async {
    await UpdateScanFollow(scans)(const ScanFollow(seriesId: 'frieren', siteUrl: 'https://example.org'));
    final follow = await FollowSeriesInScans(scans)('frieren');
    expect(follow.siteUrl, 'https://example.org');
  });

  test('chapter ranges expand', () {
    expect(chaptersIn('147'), [147]);
    expect(chaptersIn('10.5'), [10.5]);
    expect(chaptersIn('1-3'), [1, 2, 3]);
    expect(chaptersIn('c.12'), [12]);
    expect(chaptersIn('Oneshot'), isEmpty);
    expect(chaptersIn('1-900'), [900]);
    expect(formatChapter(12), '12');
    expect(formatChapter(10.5), '10.5');
  });
}
