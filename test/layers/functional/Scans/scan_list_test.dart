import 'package:akashic/layers/functional/Collection/domain/entities/collection_item.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/localized_titles.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/series.dart';
import 'package:akashic/layers/functional/Collection/domain/use_cases/create_series.dart';
import 'package:akashic/layers/functional/Collection/domain/use_cases/watch_shelf.dart';
import 'package:akashic/layers/functional/Scans/data/gateways/drift_scan_gateway.dart';
import 'package:akashic/layers/functional/Scans/domain/entities/scan_release.dart';
import 'package:akashic/layers/functional/Scans/domain/use_cases/scan_reading.dart';
import 'package:akashic/layers/functional/Scans/presentation/cubit/scan_list_cubit.dart';
import 'package:akashic/layers/functional/Scans/presentation/views/scan_list_view.dart';
import 'package:akashic/layers/technical/Localization/app_localizations.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../Collection/collection_harness.dart';

class MockScanListCubit extends MockCubit<ScanListState> implements ScanListCubit {}

void main() {
  group('with a database', () {
    late CollectionHarness harness;
    late DriftScanGateway scans;
    late String mangasId;

    setUp(() async {
      harness = CollectionHarness();
      scans = DriftScanGateway(harness.database);
      mangasId = (await harness.mangas()).id;
      await harness.collection.saveSeries(Series(id: 'frieren', categoryId: mangasId, titles: const LocalizedTitles(byLanguage: {'fr': 'Frieren'})));
      await harness.collection.saveSeries(Series(id: 'dandadan', categoryId: mangasId, titles: const LocalizedTitles(byLanguage: {'fr': 'Dandadan'})));
      await harness.collection.saveItem(CollectionItem(id: 'frieren-1', categoryId: mangasId, seriesId: 'frieren', volumeNumber: 1, titles: const LocalizedTitles(byLanguage: {'fr': 'Frieren'})));
    });

    tearDown(() => harness.database.close());

    test('scan-only series stay off the physical shelf', () async {
      await FollowSeriesInScans(scans)('dandadan');
      final groups = await WatchShelf(harness.collection, harness.categories, harness.settings)(mangasId).first;
      final seriesOnShelf = groups.where((group) => group.isSeries).map((group) => group.label);
      expect(seriesOnShelf, ['Frieren']);
    });

    test('the scans view lists new chapters first and offers the others', () async {
      for (final seriesId in ['frieren', 'dandadan']) {
        await FollowSeriesInScans(scans)(seriesId);
      }
      await MarkReadUpTo(scans)('dandadan', 10);
      await scans.addReleases(const [ScanRelease(seriesId: 'dandadan', chapter: 11, teamName: 'Team')]);
      await harness.collection.saveSeries(Series(id: 'blame', categoryId: mangasId, titles: const LocalizedTitles(byLanguage: {'fr': 'Blame!'})));
      final cubit = ScanListCubit(categoryId: mangasId, scans: scans, collection: harness.collection, createSeries: CreateSeries(harness.collection, newId: harness.newId))..start();
      await expectLater(cubit.stream, emitsThrough(predicate<ScanListState>((state) => state.entries.length == 2 && state.unfollowedSeries.length == 1)));
      expect(cubit.state.entries.first.title, 'Dandadan');
      expect(cubit.state.entries.first.progress.newChapters, [11]);
      final createdId = await cubit.createAndFollow('Berserk');
      expect(await scans.followOf(createdId!), isNotNull);
      await cubit.close();
    });
  });

  testWidgets('the scans view shows the last read and the new chapters', (tester) async {
    final cubit = MockScanListCubit();
    when(() => cubit.state).thenReturn(const ScanListState(isLoading: false));
    await tester.pumpWidget(MaterialApp(
      locale: const Locale('fr'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(body: BlocProvider<ScanListCubit>.value(value: cubit, child: ScanListView(onOpenSeries: (_) {}))),
    ));
    expect(find.text('Aucune série suivie en scans pour l’instant.'), findsOneWidget);
    expect(find.text('Suivre une série en scans'), findsOneWidget);
  });
}
