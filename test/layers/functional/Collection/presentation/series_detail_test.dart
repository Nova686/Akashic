import 'package:akashic/layers/functional/Collection/domain/entities/collection_item.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/localized_titles.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/series.dart';
import 'package:akashic/layers/functional/Collection/domain/use_cases/series_completion.dart';
import 'package:akashic/layers/functional/Collection/domain/use_cases/series_volumes.dart';
import 'package:akashic/layers/functional/Collection/presentation/cubit/series_detail_cubit.dart';
import 'package:akashic/layers/functional/Collection/presentation/cubit/series_detail_state.dart';
import 'package:akashic/layers/functional/Collection/presentation/views/series_detail_view.dart';
import 'package:akashic/layers/functional/Collection/presentation/widgets/series_completion_grid.dart';
import 'package:akashic/layers/technical/Localization/app_localizations.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../collection_harness.dart';

class MockSeriesDetailCubit extends MockCubit<SeriesDetailState> implements SeriesDetailCubit {}

const frieren = Series(id: 'frieren', categoryId: 'mangas', titles: LocalizedTitles(byLanguage: {'fr': 'Frieren'}), publishedVolumes: 5, status: 'RELEASING');

CollectionItem volume(int number) => CollectionItem(id: 'v$number', categoryId: 'mangas', seriesId: 'frieren', volumeNumber: number, titles: frieren.titles);

void main() {
  testWidgets('the grid shows owned, missing and unreleased volumes', (tester) async {
    final cubit = MockSeriesDetailCubit();
    final volumes = [volume(1), volume(2), volume(4)];
    when(() => cubit.state).thenReturn(SeriesDetailState(
      series: frieren,
      volumes: volumes,
      completion: computeSeriesCompletion(frieren, {1, 2, 4}),
      isLoading: false,
    ));
    await tester.pumpWidget(MaterialApp(
      locale: const Locale('fr'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: BlocProvider<SeriesDetailCubit>.value(value: cubit, child: SeriesDetailView(onOpenItem: (_) {})),
    ));
    final grid = tester.widget<SeriesCompletionGrid>(find.byType(SeriesCompletionGrid));
    expect(grid.cells.map((cell) => '${cell.number}:${cell.state.name}'), ['1:owned', '2:owned', '3:missing', '4:owned', '5:missing', '6:unreleased']);
    expect(find.text('3 / 5 parus'), findsOneWidget);
  });

  test('editing the published count updates the series', () async {
    final harness = CollectionHarness();
    final mangas = await harness.mangas();
    await harness.collection.saveSeries(Series(id: 'frieren', categoryId: mangas.id, titles: frieren.titles));
    await harness.collection.saveItem(CollectionItem(id: 'v1', categoryId: mangas.id, seriesId: 'frieren', volumeNumber: 1, titles: frieren.titles));
    final cubit = SeriesDetailCubit(
      seriesId: 'frieren',
      watchSeriesVolumes: WatchSeriesVolumes(harness.collection),
      setPublishedVolumes: SetPublishedVolumes(harness.collection),
    )..start();
    await expectLater(cubit.stream, emitsThrough(predicate<SeriesDetailState>((state) => state.series != null && state.volumes.isNotEmpty)));
    final completionUpdated = expectLater(cubit.stream, emitsThrough(predicate<SeriesDetailState>((state) => state.completion?.missing.length == 12)));
    await cubit.setPublishedVolumes('13');
    await completionUpdated;
    final stored = (await harness.collection.watchAllSeries().first).single;
    expect(stored.publishedVolumes, 13);
    await cubit.close();
    await harness.database.close();
  });
}
