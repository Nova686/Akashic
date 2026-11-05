import 'package:akashic/layers/functional/Collection/domain/entities/localized_titles.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/series.dart';
import 'package:akashic/layers/functional/Collection/domain/use_cases/series_completion.dart';
import 'package:akashic/layers/functional/Collection/presentation/cubit/series_detail_cubit.dart';
import 'package:akashic/layers/functional/Collection/presentation/cubit/series_detail_state.dart';
import 'package:akashic/layers/functional/Collection/presentation/views/series_detail_view.dart';
import 'package:akashic/layers/functional/Scans/data/gateways/drift_scan_gateway.dart';
import 'package:akashic/layers/functional/Scans/domain/entities/scan_follow.dart';
import 'package:akashic/layers/functional/Scans/domain/entities/scan_progress.dart';
import 'package:akashic/layers/functional/Scans/domain/gateways/chapter_release_source.dart';
import 'package:akashic/layers/functional/Scans/domain/use_cases/scan_releases.dart';
import 'package:akashic/layers/functional/Scans/presentation/cubit/scan_follow_cubit.dart';
import 'package:akashic/layers/functional/Scans/presentation/cubit/scan_follow_state.dart';
import 'package:akashic/layers/functional/Scans/presentation/widgets/scan_follow_panel.dart';
import 'package:akashic/layers/technical/Localization/app_localizations.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../Collection/collection_harness.dart';
import 'check_scan_releases_test.dart' show RecordingNotifier;
import 'manga_updates_test.dart' show ScriptedReleases;

class MockSeriesDetailCubit extends MockCubit<SeriesDetailState> implements SeriesDetailCubit {}

class MockScanFollowCubit extends MockCubit<ScanFollowState> implements ScanFollowCubit {}

Widget inApp(Widget child) => MaterialApp(
      locale: const Locale('fr'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: child,
    );

void main() {
  group('scan follow cubit', () {
    late CollectionHarness harness;
    late DriftScanGateway scans;
    late ScriptedReleases source;
    late ScanFollowCubit cubit;

    setUp(() async {
      harness = CollectionHarness();
      scans = DriftScanGateway(harness.database);
      source = ScriptedReleases();
      final mangas = await harness.mangas();
      await harness.collection.saveSeries(Series(id: 'frieren', categoryId: mangas.id, titles: const LocalizedTitles(byLanguage: {'fr': 'Frieren'})));
      cubit = ScanFollowCubit(
        seriesId: 'frieren',
        scans: scans,
        searchReleaseSeries: SearchReleaseSeries(source),
        linkReleaseSeries: LinkReleaseSeries(scans),
        refreshScanReleases: RefreshScanReleases(scans, source),
        notifier: RecordingNotifier(),
      )..start();
      await pumpEventQueue();
    });

    tearDown(() async {
      await cubit.close();
      await harness.database.close();
    });

    test('checking chapters updates the last read', () async {
      expect(cubit.state.isFollowed, isFalse);
      await cubit.follow();
      await cubit.markReadUpTo('12');
      await pumpEventQueue();
      expect(cubit.state.progress?.lastRead, 12);
      await cubit.toggleChapter(12);
      await pumpEventQueue();
      expect(cubit.state.progress?.lastRead, 11);
    });

    test('linking MangaUpdates shows the new chapters', () async {
      await cubit.follow();
      await cubit.markReadUpTo('145');
      source.published = const [PublishedChapters(chapters: [145, 146, 147], teamName: 'Likemanga')];
      await cubit.link(const ReleaseSeriesCandidate(id: '66296374554', title: 'Sousou no Frieren'));
      await pumpEventQueue();
      expect(cubit.state.progress?.follow.isLinked, isTrue);
      expect(cubit.state.progress?.newChapters, [146, 147]);
    });

    test('alerts stay off when notifications are refused', () async {
      await cubit.follow();
      await pumpEventQueue();
      final refusing = ScanFollowCubit(
        seriesId: 'frieren',
        scans: scans,
        searchReleaseSeries: SearchReleaseSeries(source),
        linkReleaseSeries: LinkReleaseSeries(scans),
        refreshScanReleases: RefreshScanReleases(scans, source),
        notifier: RefusingNotifier(),
      )..start();
      await pumpEventQueue();
      await refusing.setAlerts(true);
      expect(refusing.state.notice, ScanFollowNotice.notificationsRefused);
      expect((await scans.followOf('frieren'))!.alertsEnabled, isFalse);
      await refusing.close();
    });
  });

  testWidgets('a manga series page has a Physical and a Scans tab', (tester) async {
    final seriesCubit = MockSeriesDetailCubit();
    const frieren = Series(id: 'frieren', categoryId: 'mangas', titles: LocalizedTitles(byLanguage: {'fr': 'Frieren'}));
    when(() => seriesCubit.state).thenReturn(SeriesDetailState(
      series: frieren,
      completion: computeSeriesCompletion(frieren, {1}),
      isLoading: false,
    ));
    final scanCubit = MockScanFollowCubit();
    when(() => scanCubit.state).thenReturn(ScanFollowState(
      isLoading: false,
      progress: const ScanProgress(follow: ScanFollow(seriesId: 'frieren', teamName: 'Likemanga'), readChapters: [1, 2, 3]),
    ));
    await tester.pumpWidget(inApp(BlocProvider<SeriesDetailCubit>.value(
      value: seriesCubit,
      child: SeriesDetailView(
        onOpenItem: (_) {},
        scansTabBuilder: (seriesId) => BlocProvider<ScanFollowCubit>.value(value: scanCubit, child: const ScanFollowPanel()),
      ),
    )));
    expect(find.text('Physique'), findsOneWidget);
    await tester.tap(find.text('Scans'));
    await tester.pumpAndSettle();
    expect(find.text('Dernier chapitre lu'), findsOneWidget);
    expect(find.text('3'), findsWidgets);
    expect(find.text('À jour'), findsOneWidget);
  });

  testWidgets('a series without the scans tab keeps a single page', (tester) async {
    final seriesCubit = MockSeriesDetailCubit();
    const novels = Series(id: 'dune', categoryId: 'books', titles: LocalizedTitles(byLanguage: {'fr': 'Dune'}));
    when(() => seriesCubit.state).thenReturn(SeriesDetailState(series: novels, completion: computeSeriesCompletion(novels, {1}), isLoading: false));
    await tester.pumpWidget(inApp(BlocProvider<SeriesDetailCubit>.value(value: seriesCubit, child: SeriesDetailView(onOpenItem: (_) {}))));
    expect(find.text('Scans'), findsNothing);
  });
}

class RefusingNotifier extends RecordingNotifier {
  @override
  Future<bool> requestPermission() async => false;
}
