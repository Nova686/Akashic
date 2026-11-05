import 'package:akashic/layers/functional/Collection/domain/entities/collection_item.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/localized_titles.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/series.dart';
import 'package:akashic/layers/functional/Collection/presentation/cubit/missing_volumes_cubit.dart';
import 'package:akashic/layers/functional/Collection/presentation/views/missing_volumes_view.dart';
import 'package:akashic/layers/functional/Wishes/data/gateways/drift_wish_gateway.dart';
import 'package:akashic/layers/functional/Wishes/domain/use_cases/add_wish.dart';
import 'package:akashic/layers/functional/Wishes/domain/use_cases/wish_missing_volumes.dart';
import 'package:akashic/layers/technical/Localization/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

import '../collection_harness.dart';

void main() {
  late CollectionHarness harness;
  late DriftWishGateway wishes;
  late MissingVolumesCubit cubit;
  late String mangasId;

  Future<void> seriesWith(String id, String title, int? published, List<int> owned) async {
    final titles = LocalizedTitles(byLanguage: {'fr': title});
    await harness.collection.saveSeries(Series(id: id, categoryId: mangasId, titles: titles, publishedVolumes: published));
    for (final number in owned) {
      await harness.collection.saveItem(CollectionItem(id: '$id-$number', categoryId: mangasId, seriesId: id, volumeNumber: number, titles: titles));
    }
  }

  setUp(() async {
    harness = CollectionHarness();
    wishes = DriftWishGateway(harness.database);
    mangasId = (await harness.mangas()).id;
    await seriesWith('frieren', 'Frieren', 6, [1, 2, 5]);
    await seriesWith('dandadan', 'Dandadan', 3, [1, 2, 3]);
    await seriesWith('akira', 'Akira', 4, [3]);
    cubit = MissingVolumesCubit(harness.collection, wishes, WishMissingVolumes(wishes, AddWish(wishes, newId: harness.newId), harness.categories));
  });
  tearDown(() async {
    await cubit.close();
    await harness.database.close();
  });

  test('only series with gaps are listed, sorted by title', () async {
    cubit.start();
    final state = await cubit.stream.firstWhere((state) => !state.isLoading);
    expect(state.series.map((gaps) => gaps.title), ['Akira', 'Frieren']);
    expect(state.missingCount, 6);
    final frieren = state.series.last;
    expect(volumeRunsOf(frieren).map((run) => (run.kind, run.from, run.to)), [
      (VolumeRunKind.owned, 1, 2),
      (VolumeRunKind.missing, 3, 4),
      (VolumeRunKind.owned, 5, 5),
      (VolumeRunKind.missing, 6, 6),
    ]);
  });

  test('wishing a range marks it wished, and everything else follows', () async {
    cubit.start();
    final loaded = await cubit.stream.firstWhere((state) => !state.isLoading);
    expect(await cubit.wish(loaded.series.last, [3, 4]), 2);
    final afterRange = await cubit.stream.firstWhere((state) => state.series.last.wishedVolumes.length == 2);
    expect(volumeRunsOf(afterRange.series.last)[1].kind, VolumeRunKind.wished);
    expect(afterRange.unwishedCount, 4);
    expect(await cubit.wishEverything(), 4);
    expect(await wishes.all(), hasLength(6));
    await cubit.stream.firstWhere((state) => state.unwishedCount == 0);
  });

  Finder chipLabelled(String label) => find.byWidgetPredicate((widget) => widget is Semantics && widget.properties.label == label);

  testWidgets('the screen sums the gaps and wishes a tapped range', (tester) async {
    cubit.start();
    await tester.runAsync(() => cubit.stream.firstWhere((state) => !state.isLoading));
    await tester.pumpWidget(MaterialApp(
      locale: const Locale('fr'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: BlocProvider.value(value: cubit, child: MissingVolumesView(onOpenSeries: (_) {})),
    ));
    await tester.pump();
    expect(find.text('Tout ajouter à mes envies (6)'), findsOneWidget);
    expect(find.textContaining('dans 2 séries'), findsOneWidget);
    expect(chipLabelled('Tome 6 : manquant, touche pour le mettre en envie'), findsOneWidget);
    await tester.tap(chipLabelled('Tomes 3 à 4 : manquants, touche pour les mettre en envie'));
    await tester.runAsync(() => cubit.stream.firstWhere((state) => state.unwishedCount == 4));
    await tester.pump();
    expect(chipLabelled('Tomes 3 à 4 : dans tes envies'), findsOneWidget);
    expect(find.text('Tout ajouter à mes envies (4)'), findsOneWidget);
    expect(find.byIcon(Icons.favorite), findsOneWidget);
  });
}
