import 'package:akashic/layers/functional/Catalog/domain/entities/category_type.dart';
import 'package:akashic/layers/functional/Check/domain/entities/check_verdict.dart';
import 'package:akashic/layers/functional/Check/domain/use_cases/check_ownership.dart';
import 'package:akashic/layers/functional/Check/domain/use_cases/find_locally.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/collection_item.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/item_copy.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/localized_titles.dart';
import 'package:akashic/layers/functional/Lookup/domain/entities/source_match.dart';
import 'package:akashic/layers/functional/Lookup/domain/gateways/catalog_source.dart';
import 'package:akashic/layers/functional/Lookup/domain/use_cases/source_registry.dart';
import 'package:akashic/layers/functional/Lookup/domain/entities/source_unavailable.dart';
import 'package:flutter_test/flutter_test.dart';

import '../Collection/collection_harness.dart';

class FakeMusicSource implements CatalogSource {
  FakeMusicSource({this.isDown = false, this.matches = const []});

  bool isDown;
  bool isRateLimited = false;
  List<SourceMatch> matches;
  int calls = 0;

  @override
  String get key => 'musicbrainz';

  @override
  Set<CategoryType> get types => const {CategoryType.music};

  @override
  bool get isConfigured => true;

  @override
  bool get supportsBarcode => true;

  Future<List<SourceMatch>> _answer() async {
    calls++;
    if (isDown) {
      throw SourceUnavailable('musicbrainz', isRateLimited ? 'rate limited for 60 s' : 'offline', isRateLimited);
    }
    return matches;
  }

  @override
  Future<List<SourceMatch>> lookupBarcode(String barcode) => _answer();

  @override
  Future<List<SourceMatch>> search(String query) => _answer();
}

const kindOfBlueReissue = SourceMatch(
  sourceKey: 'musicbrainz',
  externalWorkId: 'kob-group',
  externalEditionId: 'reissue-2015',
  titles: LocalizedTitles(byLanguage: {'en': 'Kind of Blue'}),
  creator: 'Miles Davis',
  barcode: '0888751238211',
  suggestedType: CategoryType.music,
);

void main() {
  late CollectionHarness harness;
  late FakeMusicSource source;
  late CheckOwnership checkOwnership;

  setUp(() async {
    harness = CollectionHarness();
    source = FakeMusicSource();
    checkOwnership = CheckOwnership(FindLocally(harness.collection), SourceRegistry([source]), harness.collection, harness.categories);
    final vinyls = await harness.vinyls();
    await harness.collection.saveItem(CollectionItem(
      id: 'kob',
      categoryId: vinyls.id,
      titles: const LocalizedTitles(byLanguage: {'en': 'Kind of Blue'}),
      creator: 'Miles Davis',
      sourceKey: 'musicbrainz',
      externalWorkId: 'kob-group',
    ));
    await harness.collection.saveCopy(const ItemCopy(id: 'copy', itemId: 'kob', barcode: '4547366033267'));
  });
  tearDown(() => harness.database.close());

  test('a local barcode answers even when every source is down', () async {
    source.isDown = true;
    final verdict = await checkOwnership.barcode('4547366033267');
    expect(verdict, isA<Owned>());
    expect(source.calls, 0);
  });

  test('an unknown barcode whose work is owned is another edition', () async {
    source.matches = [kindOfBlueReissue];
    final verdict = await checkOwnership.barcode('0888751238211');
    expect(verdict, isA<OwnedOtherEdition>());
    expect((verdict as OwnedOtherEdition).item.id, 'kob');
  });

  test('the same title and artist from another source is also another edition', () async {
    source.matches = [
      const SourceMatch(
        sourceKey: 'musicbrainz',
        externalWorkId: 'unknown-group',
        titles: LocalizedTitles(byLanguage: {'en': 'Kind Of Blue'}),
        creator: 'Miles Davis',
        suggestedType: CategoryType.music,
      ),
    ];
    expect(await checkOwnership.barcode('0888751238211'), isA<OwnedOtherEdition>());
  });

  test('an unknown work is not owned with its match', () async {
    source.matches = [
      const SourceMatch(sourceKey: 'musicbrainz', externalWorkId: 'blue-train', titles: LocalizedTitles(byLanguage: {'en': 'Blue Train'}), suggestedType: CategoryType.music),
    ];
    final verdict = await checkOwnership.text('Blue Train');
    expect(verdict, isA<NotOwned>());
    expect((verdict as NotOwned).match?.externalWorkId, 'blue-train');
  });

  test('all sources down says the catalogues cannot be reached', () async {
    source.isDown = true;
    final verdict = await checkOwnership.barcode('0888751238211');
    expect(verdict, const CatalogsUnavailable('0888751238211'));
    expect((verdict as CatalogsUnavailable).isRateLimited, isFalse);
  });

  test('a catalogue over its quota without any answer is named as rate limited', () async {
    source
      ..isDown = true
      ..isRateLimited = true;
    final verdict = await checkOwnership.barcode('0888751238211');
    expect(verdict, const CatalogsUnavailable('0888751238211', rateLimitedSources: ['musicbrainz']));
  });

  test('all sources answering nothing is not owned without match', () async {
    final verdict = await checkOwnership.barcode('0888751238211');
    expect(verdict, const NotOwned(null, '0888751238211'));
  });

  test('the product barcode fallback is only asked when the catalogues found nothing', () async {
    final fallback = FakeMusicSource(matches: [kindOfBlueReissue]);
    final withFallback = CheckOwnership(FindLocally(harness.collection), SourceRegistry([source], barcodeFallbacks: [fallback]), harness.collection, harness.categories);
    source.matches = [kindOfBlueReissue];
    await withFallback.barcode('0888751238299');
    expect(fallback.calls, 0);
    source.matches = [];
    final verdict = await withFallback.barcode('0888751238298');
    expect(fallback.calls, 1);
    expect(verdict, isNot(isA<NotOwned>().having((notOwned) => notOwned.match, 'match', isNull)));
  });
}
