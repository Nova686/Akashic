import 'dart:io';
import 'dart:typed_data';

import 'package:akashic/layers/functional/Catalog/domain/entities/category.dart';
import 'package:akashic/layers/functional/Catalog/domain/entities/category_type.dart';
import 'package:akashic/layers/functional/Check/domain/use_cases/suggest_category.dart';
import 'package:akashic/layers/functional/Wishes/data/gateways/drift_wish_gateway.dart';
import 'package:akashic/layers/functional/Wishes/domain/use_cases/add_wish.dart';
import 'package:akashic/layers/functional/Wishes/domain/use_cases/find_wish_for.dart';
import 'package:akashic/layers/technical/LocalDatabase/akashic_database.dart';
import 'package:akashic/layers/functional/Check/domain/entities/check_verdict.dart';
import 'package:akashic/layers/functional/Check/domain/use_cases/add_from_match.dart';
import 'package:akashic/layers/functional/Check/domain/use_cases/check_ownership.dart';
import 'package:akashic/layers/functional/Check/presentation/cubit/chain_scan_cubit.dart';
import 'package:akashic/layers/functional/Check/presentation/cubit/chain_scan_state.dart';
import 'package:akashic/layers/functional/Check/domain/use_cases/cover_text_lines.dart';
import 'package:akashic/layers/functional/Check/presentation/widgets/cover_text_reader.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/collection_item.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/localized_titles.dart';
import 'package:akashic/layers/functional/Lookup/domain/entities/source_match.dart';
import 'package:akashic/layers/functional/Check/domain/use_cases/shelf_spines.dart';
import 'package:akashic/layers/functional/Check/presentation/widgets/shelf_spine_reader.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockCheckOwnership extends Mock implements CheckOwnership {}

class MockAddFromMatch extends Mock implements AddFromMatch {}

class MockSuggestCategory extends Mock implements SuggestCategory {}

const jazz = Category(id: 'jazz', name: 'Jazz', colorValue: 0, type: CategoryType.music, conditionParts: ['Disque'], position: 0);

const bebop = Category(id: 'bebop', name: 'Bebop', colorValue: 0, type: CategoryType.music, conditionParts: ['Disque'], position: 1);

class ScriptedCoverReader implements CoverTextReader {
  ScriptedCoverReader(this.readings);

  final List<List<CoverTextLine>> readings;

  @override
  Future<List<CoverTextLine>> readLines(Uint8List image) async => readings.removeAt(0);
}

class ScriptedSpineReader implements ShelfSpineReader {
  ScriptedSpineReader(this.spines);

  final List<SpineText> spines;

  @override
  Future<ShelfReading> readShelf(Uint8List photo) async => ShelfReading(spines: spines);
}

SourceMatch album(String id) => SourceMatch(
      sourceKey: 'musicbrainz',
      externalWorkId: id,
      titles: LocalizedTitles(byLanguage: {'en': id}),
      suggestedType: CategoryType.music,
    );

const owned = CollectionItem(id: 'kob', categoryId: 'jazz', titles: LocalizedTitles(byLanguage: {'en': 'Kind of Blue'}));

void main() {
  late MockCheckOwnership checkOwnership;
  late MockAddFromMatch addFromMatch;
  late MockSuggestCategory suggestCategory;

  setUpAll(() => registerFallbackValue(album('fallback')));

  setUp(() {
    checkOwnership = MockCheckOwnership();
    addFromMatch = MockAddFromMatch();
    suggestCategory = MockSuggestCategory();
    when(() => suggestCategory.forMatch(any())).thenAnswer((_) async => jazz);
    when(() => checkOwnership.barcode('0000000000001')).thenAnswer((_) async => NotOwned(album('blue-train'), '0000000000001'));
    when(() => checkOwnership.barcode('0000000000002')).thenAnswer((_) async => const Owned(owned, []));
    when(() => checkOwnership.barcode('0000000000003')).thenAnswer((_) async => NotOwned(album('mingus'), '0000000000003'));
    when(() => checkOwnership.barcode('0000000000004')).thenAnswer((_) async => const NotOwned(null, '0000000000004'));
    when(() => addFromMatch(any(), categoryId: any(named: 'categoryId'), barcode: any(named: 'barcode'))).thenAnswer((_) async => owned);
  });

  Future<ChainScanCubit> scanned(List<String> barcodes) async {
    final cubit = ChainScanCubit(checkOwnership, addFromMatch, suggestCategory);
    for (final barcode in barcodes) {
      cubit.scan(barcode);
    }
    await cubit.whenIdle();
    return cubit;
  }

  test('adding twice while the first add runs, even after a new scan, adds each item once', () async {
    final cubit = await scanned(['0000000000001', '0000000000003']);
    final first = cubit.commit();
    cubit.scan('0000000000004');
    final second = cubit.commit();
    expect((await first, await second), (2, 0));
    verify(() => addFromMatch(any(), categoryId: any(named: 'categoryId'), barcode: any(named: 'barcode'))).called(2);
    await cubit.close();
  });

  test('the same barcode twice in a session is kept once', () async {
    final cubit = await scanned(['0000000000001', '0000000000001']);
    expect(cubit.state.entries, hasLength(1));
    verify(() => checkOwnership.barcode('0000000000001')).called(1);
    await cubit.close();
  });

  test('an owned barcode is flagged and not added', () async {
    final cubit = await scanned(['0000000000002', '0000000000004']);
    expect(cubit.state.entries.map((entry) => entry.status), [ChainEntryStatus.alreadyOwned, ChainEntryStatus.notFound]);
    expect(cubit.state.entries.first.isAccepted, isFalse);
    await cubit.close();
  });

  test('commit adds only accepted found entries', () async {
    final cubit = await scanned(['0000000000001', '0000000000002', '0000000000003']);
    cubit.toggle(2);
    expect(await cubit.commit(), 1);
    verify(() => addFromMatch(album('blue-train'), categoryId: 'jazz', barcode: '0000000000001')).called(1);
    verifyNever(() => addFromMatch(album('mingus'), categoryId: any(named: 'categoryId'), barcode: any(named: 'barcode')));
    expect(cubit.state.entries.map((entry) => entry.id), ['0000000000002', '0000000000003']);
    await cubit.close();
  });

  test('a cover photo becomes an entry named after its biggest line and is added without barcode', () async {
    when(() => checkOwnership.cover(['Blue Train', 'JOHN COLTRANE'])).thenAnswer((_) async => NotOwned(album('blue-train'), 'Blue Train'));
    final reader = ScriptedCoverReader([
      const [CoverTextLine('JOHN COLTRANE', height: 30), CoverTextLine('Blue Train', height: 60)],
    ]);
    final cubit = ChainScanCubit(checkOwnership, addFromMatch, suggestCategory, coverTextReader: reader)..photographCover(Uint8List(1), pendingLabel: 'Lecture…');
    expect(cubit.state.entries.single.label, 'Lecture…');
    await cubit.whenIdle();
    final entry = cubit.state.entries.single;
    expect(entry.label, 'Blue Train');
    expect(entry.isFromCover, isTrue);
    expect(entry.status, ChainEntryStatus.found);
    await cubit.commit();
    verify(() => addFromMatch(album('blue-train'), categoryId: 'jazz', barcode: null)).called(1);
    await cubit.close();
  });

  test('a shelf photo becomes one entry per readable spine, each searched by its text', () async {
    when(() => checkOwnership.spine('Blue Train John Coltrane')).thenAnswer((_) async => NotOwned(album('blue-train'), 'Blue Train John Coltrane'));
    when(() => checkOwnership.spine('Kind of Blue')).thenAnswer((_) async => const Owned(owned, []));
    final reader = ScriptedSpineReader(const [
      SpineText('Kind of Blue', confidence: 0.9),
      SpineText('Blue Train John Coltrane', confidence: 0.8),
      SpineText('xq7 ==', confidence: 0.9),
      SpineText('Mingus Ah Um', confidence: 0.2),
    ]);
    final cubit = ChainScanCubit(checkOwnership, addFromMatch, suggestCategory, shelfSpineReader: reader)..photographShelf(Uint8List(1), pendingLabel: 'Lecture des tranches…');
    expect(cubit.canPhotographShelves, isTrue);
    expect(cubit.state.entries.single.label, 'Lecture des tranches…');
    await cubit.whenIdle();
    expect(cubit.state.entries.map((entry) => (entry.label, entry.status)), [
      ('Blue Train John Coltrane', ChainEntryStatus.found),
      ('Kind of Blue', ChainEntryStatus.alreadyOwned),
    ]);
    expect(await cubit.commit(), 1);
    verify(() => addFromMatch(album('blue-train'), categoryId: 'jazz', barcode: null)).called(1);
    await cubit.close();
  });

  test('a shelf photo without any readable spine is reported as unreadable', () async {
    final cubit = ChainScanCubit(checkOwnership, addFromMatch, suggestCategory, shelfSpineReader: ScriptedSpineReader(const [SpineText('12 34')]))
      ..photographShelf(Uint8List(1), pendingLabel: 'Lecture des tranches…');
    await cubit.whenIdle();
    expect(cubit.state.lastFailure?.status, ChainEntryStatus.unreadable);
    await cubit.close();
  });

  test('spine texts keep the longest reading, drop gibberish, low confidence and readings inside another', () {
    expect(
      spineTitlesOf(const [
        SpineText('ONE PIECE'),
        SpineText('ONE PIECE  104  Eiichiro Oda'),
        SpineText('Frieren', confidence: 0.95),
        SpineText('Frieren', confidence: 0.9),
        SpineText('|| -- ||'),
        SpineText('Berserk', confidence: 0.3),
        SpineText('Le'),
      ]),
      ['ONE PIECE 104 Eiichiro Oda', 'Frieren'],
    );
    expect(spineTitlesOf([for (var index = 0; index < 40; index++) SpineText('Volume title $index ${'x' * index}')]), hasLength(maximumShelfSpines));
  });

  test('an unreadable cover and a barcode without result are both reported as failures', () async {
    final reader = ScriptedCoverReader([const [CoverTextLine('12', height: 40)]]);
    final cubit = ChainScanCubit(checkOwnership, addFromMatch, suggestCategory, coverTextReader: reader)..photographCover(Uint8List(1), pendingLabel: 'Lecture…');
    await cubit.whenIdle();
    expect(cubit.state.lastFailure?.status, ChainEntryStatus.unreadable);
    cubit.scan('0000000000004');
    await cubit.whenIdle();
    expect(cubit.state.lastFailure?.status, ChainEntryStatus.notFound);
    expect(cubit.state.lastFailure?.label, '0000000000004');
    await cubit.close();
  });

  test('an add that fails is counted without stopping the others', () async {
    when(() => addFromMatch(album('blue-train'), categoryId: any(named: 'categoryId'), barcode: any(named: 'barcode'))).thenThrow(const FileSystemException('disk full'));
    final cubit = ChainScanCubit(checkOwnership, addFromMatch, suggestCategory)
      ..scan('0000000000001')
      ..scan('0000000000003');
    await cubit.whenIdle();
    expect(await cubit.commit(), 1);
    expect(cubit.state.addedCount, 1);
    expect(cubit.state.failedAddCount, 1);
    await cubit.close();
  });

  test('an owned barcode keeps its item so its page can be opened', () async {
    final cubit = await scanned(['0000000000002']);
    expect(cubit.state.entries.single.ownedItemId, 'kob');
    expect(cubit.state.entries.single.ownedTitle, 'Kind of Blue');
    await cubit.close();
  });

  test('a found entry goes to its suggested category unless another one is chosen', () async {
    final cubit = await scanned(['0000000000001', '0000000000003']);
    expect(cubit.state.entries.map((entry) => entry.targetCategory), [jazz, jazz]);
    cubit.moveTo(1, bebop);
    await cubit.commit();
    verify(() => addFromMatch(album('blue-train'), categoryId: 'jazz', barcode: '0000000000001')).called(1);
    verify(() => addFromMatch(album('mingus'), categoryId: 'bebop', barcode: '0000000000003')).called(1);
    await cubit.close();
  });

  test('a match without any category of its type waits for one to be chosen', () async {
    when(() => suggestCategory.forMatch(any())).thenAnswer((_) async => null);
    final cubit = await scanned(['0000000000001']);
    expect(cubit.state.entries.single.isAccepted, isFalse);
    expect(cubit.state.acceptedCount, 0);
    cubit.toggle(0);
    expect(cubit.state.entries.single.isAccepted, isFalse);
    cubit.moveTo(0, jazz);
    expect(cubit.state.acceptedCount, 1);
    await cubit.close();
  });

  test('a found entry can be wished once, and a known wish is recognised on the next scan', () async {
    when(() => suggestCategory.forMatch(any())).thenAnswer((_) async => null);
    final database = AkashicDatabase.forTesting();
    addTearDown(database.close);
    final wishes = DriftWishGateway(database);
    ChainScanCubit wishingCubit() => ChainScanCubit(checkOwnership, addFromMatch, suggestCategory, findWishFor: FindWishFor(wishes), addWish: AddWish(wishes));
    final cubit = wishingCubit()..scan('0000000000001');
    await cubit.whenIdle();
    expect(cubit.canAddToWishes, isTrue);
    expect(cubit.state.entries.single.isWished, isFalse);
    await cubit.addToWishes(0);
    await cubit.addToWishes(0);
    expect(cubit.state.entries.single.isWished, isTrue);
    expect(await wishes.watchAll().first, hasLength(1));
    await cubit.close();
    final rescan = wishingCubit()..scan('0000000000001');
    await rescan.whenIdle();
    expect(rescan.state.entries.single.isWished, isTrue);
    await rescan.close();
  });
}
