import 'package:akashic/layers/functional/Catalog/domain/entities/category.dart';
import 'package:akashic/layers/functional/Catalog/domain/entities/category_type.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/collection_item.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/item_copy.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/localized_titles.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/series.dart';
import 'package:akashic/layers/functional/Wishes/data/gateways/drift_wish_gateway.dart';
import 'package:akashic/layers/functional/Wishes/domain/entities/wish.dart';
import 'package:akashic/layers/functional/Wishes/domain/entities/wish_key.dart';
import 'package:akashic/layers/functional/Wishes/domain/use_cases/add_wish.dart';
import 'package:akashic/layers/functional/Wishes/domain/use_cases/remove_fulfilled_wishes.dart';
import 'package:akashic/layers/functional/Wishes/domain/use_cases/watch_fulfilled_wishes.dart';
import 'package:flutter_test/flutter_test.dart';

import '../Collection/collection_harness.dart';

void main() {
  late CollectionHarness harness;
  late DriftWishGateway wishes;
  late AddWish addWish;
  late RemoveFulfilledWishes removeFulfilled;
  late Category vinyls;

  setUp(() async {
    harness = CollectionHarness();
    wishes = DriftWishGateway(harness.database);
    addWish = AddWish(wishes, newId: () => 'wish-${harness.newId()}');
    removeFulfilled = RemoveFulfilledWishes(wishes);
    vinyls = await harness.vinyls();
  });

  tearDown(() => harness.database.close());

  Future<List<Wish>> removeAfterCollectionChange() async => removeFulfilled(await harness.collection.watchOwnedWorks().first);

  CollectionItem album(String id, {String? sourceKey, String? externalWorkId}) {
    return CollectionItem(id: id, categoryId: vinyls.id, titles: LocalizedTitles(byLanguage: {'en': id}), sourceKey: sourceKey, externalWorkId: externalWorkId);
  }

  test('adding an item with the same source id removes the wish', () async {
    await addWish(const WishDraft(categoryType: CategoryType.music, title: 'Blue Train', origin: WishOrigin.discovery, key: WishKey(sourceKey: 'musicbrainz', externalWorkId: 'rg-1')));
    await harness.collection.saveItem(album('blue-train', sourceKey: 'musicbrainz', externalWorkId: 'rg-1'));
    final removed = await removeAfterCollectionChange();
    expect(removed.single.title, 'Blue Train');
    expect(await wishes.all(), isEmpty);
  });

  test('a copy with the wished barcode removes the wish', () async {
    await addWish(const WishDraft(categoryType: CategoryType.music, title: 'Giant Steps', origin: WishOrigin.search, key: WishKey(barcode: '075678133725')));
    await harness.collection.saveItem(album('giant-steps'));
    await harness.collection.saveCopy(const ItemCopy(id: 'copy', itemId: 'giant-steps', barcode: '075678133725'));
    expect((await removeAfterCollectionChange()).single.title, 'Giant Steps');
  });

  test('the wished volume of a series removes the wish', () async {
    final mangas = await harness.mangas();
    await harness.collection.saveSeries(Series(id: 'frieren', categoryId: mangas.id, titles: const LocalizedTitles(byLanguage: {'fr': 'Frieren'})));
    await addWish(const WishDraft(categoryType: CategoryType.manga, title: 'Frieren 4', origin: WishOrigin.missingVolume, key: WishKey(seriesId: 'frieren', volumeNumber: 4)));
    await addWish(const WishDraft(categoryType: CategoryType.manga, title: 'Frieren 5', origin: WishOrigin.missingVolume, key: WishKey(seriesId: 'frieren', volumeNumber: 5)));
    await harness.collection.saveItem(CollectionItem(id: 'frieren-4', categoryId: mangas.id, titles: const LocalizedTitles(byLanguage: {'fr': 'Frieren'}), seriesId: 'frieren', volumeNumber: 4));
    expect((await removeAfterCollectionChange()).single.title, 'Frieren 4');
    expect((await wishes.all()).single.title, 'Frieren 5');
  });

  test('an unrelated item removes nothing', () async {
    await addWish(const WishDraft(categoryType: CategoryType.music, title: 'Blue Train', origin: WishOrigin.discovery, key: WishKey(sourceKey: 'musicbrainz', externalWorkId: 'rg-1')));
    await harness.collection.saveItem(album('kind-of-blue', sourceKey: 'musicbrainz', externalWorkId: 'rg-2'));
    await harness.collection.saveItem(album('no-ids'));
    expect(await removeAfterCollectionChange(), isEmpty);
    expect(await wishes.all(), hasLength(1));
  });

  test('the watcher reports a wish fulfilled by an item added any other way', () async {
    await addWish(const WishDraft(categoryType: CategoryType.music, title: 'Blue Train', origin: WishOrigin.discovery, key: WishKey(sourceKey: 'musicbrainz', externalWorkId: 'rg-1')));
    final reported = <List<Wish>>[];
    final subscription = WatchFulfilledWishes(harness.collection, wishes, removeFulfilled)().listen(reported.add);
    await pumpEventQueue();
    await harness.collection.saveItem(album('blue-train', sourceKey: 'musicbrainz', externalWorkId: 'rg-1'));
    await pumpEventQueue();
    expect(reported.single.single.title, 'Blue Train');
    await subscription.cancel();
  });
}
