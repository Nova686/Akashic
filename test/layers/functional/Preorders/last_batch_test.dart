import 'package:akashic/layers/functional/Activity/data/gateways/drift_activity_log.dart';
import 'package:akashic/layers/functional/Activity/domain/entities/activity_event.dart';
import 'package:akashic/layers/functional/Check/domain/gateways/cover_image_gateway.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/collection_item.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/deck_card.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/item_copy.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/item_photo.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/localized_titles.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/series.dart';
import 'package:akashic/layers/functional/Collection/domain/use_cases/merge_items.dart';
import 'package:akashic/layers/functional/Collection/presentation/widgets/deck_analysis_panel.dart';
import 'package:akashic/layers/functional/Covers/domain/use_cases/bulk_covers.dart';
import 'package:akashic/layers/functional/Covers/presentation/cubit/bulk_covers_cubit.dart';
import 'package:akashic/layers/functional/Details/domain/entities/item_details.dart';
import 'package:akashic/layers/functional/Details/domain/use_cases/track_sides.dart';
import 'package:akashic/layers/functional/Friends/domain/use_cases/compare_collections.dart';
import 'package:akashic/layers/functional/Import/domain/entities/import_table.dart';
import 'package:akashic/layers/functional/Lookup/domain/entities/source_match.dart';
import 'package:akashic/layers/functional/Lookup/domain/gateways/image_search.dart';
import 'package:akashic/layers/functional/Preorders/domain/gateways/preorder_alerts.dart';
import 'package:akashic/layers/functional/Preorders/domain/use_cases/preorder_use_cases.dart';
import 'package:akashic/layers/functional/Wishes/data/gateways/drift_wish_gateway.dart';
import 'package:akashic/layers/functional/Wishes/domain/entities/wish.dart';
import 'package:akashic/layers/functional/Wishes/domain/use_cases/add_wish.dart';
import 'package:akashic/layers/functional/Catalog/domain/entities/category.dart';
import 'package:akashic/layers/functional/Catalog/domain/entities/category_type.dart';
import 'package:flutter_test/flutter_test.dart';

import '../Collection/collection_harness.dart';

class RecordedArrivals implements PreorderAlerts, PreorderAlertMemory {
  final List<List<String>> said = [];
  Set<String> keys = {};

  @override
  Future<void> arrivesToday(List<String> titles) async => said.add(titles);

  @override
  Future<Set<String>> announced() async => keys;

  @override
  Future<void> saveAnnounced(Set<String> announcedKeys) async => keys = announcedKeys;
}

class FixedImages implements ImageSearch {
  @override
  Future<List<String>> imagesFor(SourceMatch? match, String query) async => query.contains('Inconnu') ? const [] : ['https://img/$query/1.jpg', 'https://img/$query/2.jpg'];
}

class StoredCovers implements CoverImageGateway {
  @override
  Future<StoredCover?> storeCover(String url) async => StoredCover(path: '/covers/${url.hashCode}.jpg', spineColorValue: 0xFF112233);
}

void main() {
  late CollectionHarness harness;
  late Category mangas;

  CollectionItem item(String id, String title, {String? creator, int? rating, String? seriesId, int? volume, String? imagePath}) =>
      CollectionItem(id: id, categoryId: mangas.id, titles: LocalizedTitles(byLanguage: {'fr': title}), creator: creator, rating: rating, seriesId: seriesId, volumeNumber: volume, imagePath: imagePath);

  setUp(() async {
    harness = CollectionHarness();
    mangas = await harness.mangas();
  });
  tearDown(() => harness.database.close());

  test('a preorder counts down, is announced once on its day and joins the collection when received', () async {
    await harness.collection.saveItem(item('h', 'Hades II'));
    final log = DriftActivityLog(harness.database);
    var today = DateTime(2026, 12, 17);
    final manage = ManagePreorder(harness.collection, activityLog: log, now: () => today, newId: () => 'copy');
    await manage.set('h', dueOn: DateTime(2026, 12, 18), depositCents: 1000);
    final preordered = (await harness.collection.watchItem('h').first)!;
    expect((preordered.preorder!.daysLeftFrom(today), preordered.preorder!.depositCents), (1, 1000));
    final memory = RecordedArrivals();
    final announce = AnnouncePreorderArrivals(harness.collection, memory, memory, now: () => today);
    expect(await announce(), isEmpty);
    today = DateTime(2026, 12, 18);
    expect(await announce(), ['Hades II']);
    expect(await announce(), isEmpty);
    await manage.receive('h');
    final received = (await harness.collection.watchItem('h').first)!;
    expect(received.isPreordered, isFalse);
    expect((await harness.collection.watchCopies('h').first).single.purchasedOn, today);
    expect((await log.between(DateTime(2026), DateTime(2027))).single.kind, ActivityKind.received);
  });

  test('merging keeps the chosen fields, the photos of both and removes the second item', () async {
    await harness.collection.saveItem(item('a', 'Blacksad', creator: 'Canales', rating: 3));
    await harness.collection.saveItem(item('b', 'Blacksad T1', creator: 'Juan Díaz Canales', rating: 5, imagePath: '/b.jpg'));
    await harness.collection.saveCopy(const ItemCopy(id: 'ca', itemId: 'a', pricePaidCents: 1000));
    await harness.collection.saveCopy(const ItemCopy(id: 'cb', itemId: 'b', pricePaidCents: 1450, location: 'Salon'));
    await harness.collection.savePhoto(const ItemPhoto(id: 'p', itemId: 'b', path: '/photo.jpg', position: 0));
    final first = (await harness.collection.watchItem('a').first)!;
    final second = (await harness.collection.watchItem('b').first)!;
    final plan = const MergePlan().choose(MergeField.rating, MergeSide.second).choose(MergeField.purchase, MergeSide.second);
    await MergeItems(harness.collection)(first, second, plan);
    final merged = (await harness.collection.watchItem('a').first)!;
    expect((merged.creator, merged.rating, merged.imagePath), ('Canales', 5, '/b.jpg'));
    expect((await harness.collection.watchCopies('a').first).map((copy) => (copy.pricePaidCents, copy.location)), [(1450, 'Salon')]);
    expect((await harness.collection.watchPhotos('a').first).single.path, '/photo.jpg');
    expect(await harness.collection.watchItem('b').first, isNull);
  });

  test('a friend\'s export is compared by series volume or title, with swap ideas', () async {
    await harness.collection.saveSeries(Series(id: 'op', categoryId: mangas.id, titles: const LocalizedTitles(byLanguage: {'fr': 'One Piece'}), publishedVolumes: 3));
    await harness.collection.saveItem(item('op1', 'One Piece', seriesId: 'op', volume: 1));
    await harness.collection.saveItem(item('dune', 'Dune', creator: 'Frank Herbert'));
    final wishes = DriftWishGateway(harness.database);
    await AddWish(wishes)(const WishDraft(categoryType: CategoryType.books, title: 'Wingspan', origin: WishOrigin.manual));
    final table = const ImportTable(headers: ['Titre', 'Auteur', 'Série', 'Tome'], rows: [
      ['One Piece', '', 'One Piece', '1'],
      ['One Piece', '', 'One Piece', '2'],
      ['Wingspan', '', '', ''],
      ['Celeste', '', '', ''],
    ]);
    final comparison = await CompareCollections(harness.collection, wishes)(friendWorksOf(table));
    expect(comparison.inCommon.map((work) => work.label), ['One Piece · 1']);
    expect(comparison.onlyMine.map((work) => work.label), ['Dune']);
    expect(comparison.exchangeIdeas.map((work) => (work.label, work.reason)), [('One Piece · 2', ExchangeReason.fillsMissingVolume), ('Wingspan', ExchangeReason.wished)]);
  });

  test('a deck is valued from its priced cards and its priciest ones', () {
    final at = DateTime(2026, 11, 4);
    DeckCard card(String name, int cents, {int quantity = 1}) => DeckCard(id: name, itemId: 'deck', name: name, quantity: quantity, price: CardPrice(cents: cents, currency: 'EUR', pricedAt: at));
    final value = deckValueOf([card('Charizard ex', 16200), card('Pikachu ex', 4800), card('Energy', 10, quantity: 10), const DeckCard(id: 'x', itemId: 'deck', name: 'Unpriced', quantity: 2)], shown: 2);
    expect((value.totalCents, value.pricedCards, value.cardCount, value.pricedAt), (21100, 12, 14, at));
    expect(value.priciest.map((entry) => entry.$1.name), ['Charizard ex', 'Pikachu ex']);
  });

  test('tracks are grouped by side with their lengths', () {
    const tracks = [
      DetailTrack(position: 'A1', title: 'So What', duration: '9:22'),
      DetailTrack(position: 'A2', title: 'Freddie Freeloader', duration: '9:46'),
      DetailTrack(position: 'B1', title: 'Blue in Green', duration: '5:37'),
    ];
    final sides = trackSidesOf(tracks);
    expect(sides.map((side) => (side.label, side.totalSeconds)), [('A', 1148), ('B', 337)]);
    expect(formatDuration(totalDurationOf(tracks)!), '24:45');
    expect(trackSidesOf(const [DetailTrack(position: '1', title: 'Intro')]).single.label, isNull);
  });

  test('missing covers are searched in bulk and accepted one by one or all at once', () async {
    await harness.collection.saveItem(item('v', 'Vinland Saga', volume: 3));
    await harness.collection.saveItem(item('u', 'Inconnu'));
    await harness.collection.saveItem(item('c', 'Celeste'));
    await harness.collection.saveItem(item('done', 'Frieren', imagePath: '/f.jpg'));
    final cubit = BulkCoversCubit(FindCoverlessItems(harness.collection, harness.categories), ProposeCovers(FixedImages()), AcceptCover(StoredCovers(), harness.collection));
    await cubit.load();
    expect(cubit.state.coverlessCount, 3);
    await cubit.search();
    expect(cubit.state.proposals.map((proposal) => (proposal.item.id, proposal.status)).toSet(), {('v', ProposalStatus.proposed), ('u', ProposalStatus.nothingFound), ('c', ProposalStatus.proposed)});
    cubit.showAnother('v');
    expect(cubit.state.proposals.firstWhere((proposal) => proposal.item.id == 'v').shownUrl, endsWith('/2.jpg'));
    await cubit.acceptAll();
    expect(cubit.state.acceptedCount, 2);
    expect((await harness.collection.watchItem('c').first)!.imagePath, startsWith('/covers/'));
    await cubit.close();
  });
}
