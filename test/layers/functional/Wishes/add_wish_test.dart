import 'package:akashic/layers/functional/Catalog/domain/entities/category_type.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/localized_titles.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/series.dart';
import 'package:akashic/layers/functional/Wishes/data/gateways/drift_wish_gateway.dart';
import 'package:akashic/layers/functional/Wishes/domain/entities/wish.dart';
import 'package:akashic/layers/functional/Wishes/domain/entities/wish_key.dart';
import 'package:akashic/layers/functional/Wishes/domain/use_cases/add_wish.dart';
import 'package:akashic/layers/functional/Wishes/domain/use_cases/find_wish_for.dart';
import 'package:flutter_test/flutter_test.dart';

import '../Collection/collection_harness.dart';

void main() {
  late CollectionHarness harness;
  late DriftWishGateway wishes;
  late AddWish addWish;

  setUp(() {
    harness = CollectionHarness();
    wishes = DriftWishGateway(harness.database);
    addWish = AddWish(wishes, newId: harness.newId, now: () => DateTime(2026, 10, 27));
  });

  tearDown(() => harness.database.close());

  test('the same wish added twice is kept once', () async {
    const fromDiscovery = WishDraft(
      categoryType: CategoryType.music,
      title: 'Blue Train',
      creator: 'John Coltrane',
      origin: WishOrigin.discovery,
      key: WishKey(sourceKey: 'musicbrainz', externalWorkId: 'rg-blue-train'),
    );
    const fromSearch = WishDraft(
      categoryType: CategoryType.music,
      title: 'Blue Train (Remastered)',
      origin: WishOrigin.search,
      key: WishKey(sourceKey: 'musicbrainz', externalWorkId: 'rg-blue-train', barcode: '0724349532725'),
    );
    final first = await addWish(fromDiscovery);
    final second = await addWish(fromSearch);
    expect(second.id, first.id);
    final stored = await wishes.all();
    expect(stored, hasLength(1));
    expect(stored.single.origin, WishOrigin.discovery);
    expect(stored.single.createdAt, DateTime(2026, 10, 27));
  });

  test('a missing volume wish is keyed by series and number', () async {
    final mangas = await harness.mangas();
    await harness.collection.saveSeries(Series(id: 'frieren', categoryId: mangas.id, titles: const LocalizedTitles(byLanguage: {'fr': 'Frieren'})));
    await addWish(WishDraft(
      categoryType: CategoryType.manga,
      categoryId: mangas.id,
      title: 'Frieren 4',
      origin: WishOrigin.missingVolume,
      key: const WishKey(seriesId: 'frieren', volumeNumber: 4),
    ));
    await addWish(WishDraft(
      categoryType: CategoryType.manga,
      categoryId: mangas.id,
      title: 'Frieren 5',
      origin: WishOrigin.missingVolume,
      key: const WishKey(seriesId: 'frieren', volumeNumber: 5),
    ));
    expect(await wishes.all(), hasLength(2));
    final found = await FindWishFor(wishes)(const WishKey(seriesId: 'frieren', volumeNumber: 4));
    expect(found?.title, 'Frieren 4');
    expect(await FindWishFor(wishes)(const WishKey(seriesId: 'frieren', volumeNumber: 6)), isNull);
  });

  test('wishes without any identity are never merged', () async {
    await addWish(const WishDraft(categoryType: CategoryType.free, title: 'Affiche', origin: WishOrigin.manual));
    await addWish(const WishDraft(categoryType: CategoryType.free, title: 'Affiche', origin: WishOrigin.manual));
    expect(await wishes.all(), hasLength(2));
  });
}
