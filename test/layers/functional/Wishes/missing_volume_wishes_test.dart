import 'package:akashic/layers/functional/Collection/domain/entities/collection_item.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/localized_titles.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/series.dart';
import 'package:akashic/layers/functional/Collection/domain/use_cases/series_volumes.dart';
import 'package:akashic/layers/functional/Collection/presentation/cubit/series_detail_cubit.dart';
import 'package:akashic/layers/functional/Collection/presentation/cubit/series_detail_state.dart';
import 'package:akashic/layers/functional/Wishes/data/gateways/drift_wish_gateway.dart';
import 'package:akashic/layers/functional/Wishes/domain/entities/wish.dart';
import 'package:akashic/layers/functional/Wishes/domain/use_cases/add_wish.dart';
import 'package:akashic/layers/functional/Wishes/domain/use_cases/wish_missing_volumes.dart';
import 'package:flutter_test/flutter_test.dart';

import '../Collection/collection_harness.dart';

void main() {
  test('missing volumes become wishes, once each', () async {
    final harness = CollectionHarness();
    final wishes = DriftWishGateway(harness.database);
    final mangas = await harness.mangas();
    const titles = LocalizedTitles(byLanguage: {'fr': 'Frieren'});
    await harness.collection.saveSeries(Series(id: 'frieren', categoryId: mangas.id, titles: titles, publishedVolumes: 4, creator: 'Kanehito Yamada'));
    for (final number in [1, 3]) {
      await harness.collection.saveItem(CollectionItem(id: 'v$number', categoryId: mangas.id, seriesId: 'frieren', volumeNumber: number, titles: titles));
    }
    final cubit = SeriesDetailCubit(
      seriesId: 'frieren',
      watchSeriesVolumes: WatchSeriesVolumes(harness.collection),
      setPublishedVolumes: SetPublishedVolumes(harness.collection),
      wishMissingVolumes: WishMissingVolumes(wishes, AddWish(wishes, newId: harness.newId), harness.categories),
    )..start();
    await expectLater(cubit.stream, emitsThrough(predicate<SeriesDetailState>((state) => state.completion?.missing.length == 2)));
    await cubit.wishMissingVolumes();
    expect(cubit.state.missingVolumesWished, 2);
    final stored = await wishes.all();
    expect({for (final wish in stored) wish.key.volumeNumber}, {2, 4});
    expect(stored.every((wish) => wish.origin == WishOrigin.missingVolume && wish.title == 'Frieren' && wish.categoryId == mangas.id), isTrue);
    await cubit.wishMissingVolumes();
    expect(cubit.state.missingVolumesWished, 0);
    expect(await wishes.all(), hasLength(2));
    await cubit.close();
    await harness.database.close();
  });
}
