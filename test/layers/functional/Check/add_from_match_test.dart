import 'dart:io';
import 'dart:typed_data';

import 'package:akashic/layers/functional/Catalog/domain/entities/category_type.dart';
import 'package:akashic/layers/functional/Check/data/gateways/downloaded_cover_gateway.dart';
import 'package:akashic/layers/functional/Check/domain/use_cases/add_from_match.dart';
import 'package:akashic/layers/functional/Check/domain/use_cases/suggest_category.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/localized_titles.dart';
import 'package:akashic/layers/functional/Collection/domain/use_cases/add_item.dart';
import 'package:akashic/layers/functional/Lookup/domain/entities/source_match.dart';
import 'package:akashic/layers/technical/MediaStorage/local_image_store.dart';
import 'package:akashic/layers/technical/MediaStorage/remote_image_downloader.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

import '../Collection/collection_harness.dart';

const kindOfBlue = SourceMatch(
  sourceKey: 'musicbrainz',
  externalWorkId: 'kob-group',
  externalEditionId: 'release-2007',
  titles: LocalizedTitles(byLanguage: {'en': 'Kind of Blue'}),
  creator: 'Miles Davis',
  year: 2007,
  publisher: 'Sony Records International',
  barcode: '4547366033267',
  imageUrl: 'https://coverartarchive.org/release-group/kob-group/front-250',
  suggestedType: CategoryType.music,
);

void main() {
  late CollectionHarness harness;
  late Directory imageRoot;

  setUp(() async {
    harness = CollectionHarness();
    imageRoot = await Directory.systemTemp.createTemp('akashic-cover');
  });
  tearDown(() async {
    await harness.database.close();
    await imageRoot.delete(recursive: true);
  });

  AddFromMatch addFromMatch(http.Client client) => AddFromMatch(
        AddItem(harness.collection, harness.categories, newId: harness.newId),
        harness.collection,
        DownloadedCoverGateway(RemoteImageDownloader(client), LocalImageStore(imageRoot), extractColor: (_) async => 0xFF20304A),
        newId: harness.newId,
      );

  test('adding from a match keeps titles, ids, barcode and downloads the cover', () async {
    final vinyls = await harness.vinyls();
    final client = MockClient((request) async => http.Response.bytes(Uint8List.fromList([1, 2, 3]), 200, headers: {'content-type': 'image/jpeg'}));
    final item = await addFromMatch(client)(kindOfBlue, categoryId: vinyls.id, barcode: '4547366033267');
    final stored = (await harness.collection.watchItem(item.id).first)!;
    expect(stored.sourceKey, 'musicbrainz');
    expect(stored.externalWorkId, 'kob-group');
    expect(stored.creator, 'Miles Davis');
    expect(stored.groupKey, 'Miles Davis');
    expect(stored.spineColorValue, 0xFF20304A);
    expect(File(stored.imagePath!).existsSync(), isTrue);
    final copy = (await harness.collection.watchCopies(item.id).first).single;
    expect(copy.barcode, '4547366033267');
    expect(copy.externalEditionId, 'release-2007');
  });

  test('a failed image download still adds the item', () async {
    final vinyls = await harness.vinyls();
    final client = MockClient((request) async => http.Response('not found', 404));
    final item = await addFromMatch(client)(kindOfBlue, categoryId: vinyls.id);
    expect((await harness.collection.watchItem(item.id).first)!.imagePath, isNull);
  });

  test('another edition adds a copy to the owned item', () async {
    final vinyls = await harness.vinyls();
    final client = MockClient((request) async => http.Response('', 404));
    final owned = await addFromMatch(client)(kindOfBlue, categoryId: vinyls.id, barcode: '4547366033267');
    await addFromMatch(client).addCopyFromMatch(owned, const SourceMatch(
      sourceKey: 'musicbrainz',
      externalWorkId: 'kob-group',
      externalEditionId: 'reissue-2015',
      titles: LocalizedTitles(byLanguage: {'en': 'Kind of Blue'}),
      format: 'Vinyl',
      year: 2015,
      suggestedType: CategoryType.music,
    ), barcode: '0888751238211');
    final copies = await harness.collection.watchCopies(owned.id).first;
    expect(copies, hasLength(2));
    expect(copies.last.barcode, '0888751238211');
    expect(copies.last.edition, 'Vinyl, 2015');
  });

  test('suggested category is the first leaf of that type', () async {
    final vinyls = await harness.vinyls();
    final jazz = await harness.createCategory(name: 'Jazz', colorValue: 0, type: CategoryType.music, parentId: vinyls.id);
    await harness.createCategory(name: 'Rock', colorValue: 0, type: CategoryType.music, parentId: vinyls.id);
    await harness.mangas();
    expect((await SuggestCategory(harness.categories).forMatch(kindOfBlue))?.id, jazz.id);
    expect(await SuggestCategory(harness.categories).forMatch(const SourceMatch(sourceKey: 'tmdb', externalWorkId: '603', titles: LocalizedTitles(byLanguage: {'en': 'The Matrix'}), suggestedType: CategoryType.films)), isNull);
  });
}
