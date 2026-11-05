import 'package:akashic/layers/functional/Catalog/domain/entities/category_type.dart';
import 'package:akashic/layers/functional/Check/domain/entities/check_verdict.dart';
import 'package:akashic/layers/functional/Check/domain/use_cases/check_ownership.dart';
import 'package:akashic/layers/functional/Check/domain/use_cases/find_locally.dart';
import 'package:akashic/layers/functional/Check/domain/use_cases/shelf_spines.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/collection_item.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/localized_titles.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/series.dart';
import 'package:akashic/layers/functional/Lookup/domain/use_cases/source_registry.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:akashic/layers/technical/MediaStorage/silent_frame_capture.dart';
import 'dart:typed_data';

import '../Collection/collection_harness.dart';
import 'cover_search_test.dart';

SpineLine lineAt(String text, double left, double top, {double width = 200, double height = 30}) => SpineLine(text, left: left, top: top, right: left + width, bottom: top + height);

void main() {
  test('lines read along the same spine are joined in reading order, neighbouring spines stay apart', () {
    final spines = spinesFromLines([
      lineAt('Eiichiro Oda', 700, 102, width: 160, height: 22),
      lineAt('ONE PIECE', 300, 100),
      lineAt('104', 40, 98, width: 50, height: 34),
      lineAt('ONE PIECE', 300, 160),
      lineAt('105', 40, 158, width: 50, height: 34),
      lineAt('NARUTO', 3200, 100),
    ]);
    expect(spines.map((spine) => spine.text), ['104 ONE PIECE Eiichiro Oda', 'NARUTO', '105 ONE PIECE']);
  });

  test('the volume number is read from the spine, never from an age rating or a platform', () {
    expect(spineVolumeNumberOf('104 ONE PIECE Eiichiro Oda'), 104);
    expect(spineVolumeNumberOf('NARUTO T.07 Kana'), 7);
    expect(spineVolumeNumberOf('Frieren tome 3'), 3);
    expect(spineVolumeNumberOf('The Legend of Zelda PEGI 12 Nintendo Switch'), isNull);
    expect(spineVolumeNumberOf('Final Fantasy VII Remake PS4'), isNull);
  });

  test('short japanese titles read on a spine are kept', () {
    expect(spineTitlesOf(const [SpineText('呪術廻戦 2'), SpineText('呪術 3'), SpineText('の')]), ['呪術廻戦 2', '呪術 3']);
    expect(spineVolumeNumberOf('呪術廻戦 12'), 12);
  });

  test('the search query keeps the title words only', () {
    expect(spineSearchQueryOf('THE LEGEND OF ZELDA Tears of the Kingdom NINTENDO SWITCH PEGI 12'), 'the legend of zelda tears of the kingdom');
    expect(spineSearchQueryOf('104 ONE PIECE Eiichiro Oda Glénat'), 'one piece eiichiro oda');
    expect(spineSearchQueryOf('Spy x Family T05 Kurokawa'), 'spy x family');
  });

  test('words misread by text recognition still resemble the expected ones, short words stay exact', () {
    expect(wordsResemble('0ne', 'one'), isTrue);
    expect(wordsResemble('fireren', 'frieren'), isTrue);
    expect(wordsResemble('tolkein', 'tolkien'), isTrue);
    expect(wordsResemble('berserx', 'berserk'), isTrue);
    expect(wordsResemble('naruto', 'narutos'), isTrue);
    expect(wordsResemble('nana', 'nara'), isFalse);
    expect(wordsResemble('bleach', 'beach'), isTrue);
    expect(wordsResemble('dune', 'dunes'), isFalse);
    expect(wordsResemble('frieren', 'friends'), isFalse);
  });

  test('a sharper frame is chosen over a blurred one', () {
    CapturedFrame frameOf(int Function(int x, int y) shade) {
      final bytes = Uint8List(40 * 40 * 3 ~/ 2);
      for (var y = 0; y < 40; y++) {
        for (var x = 0; x < 40; x++) {
          bytes[y * 40 + x] = shade(x, y);
        }
      }
      return CapturedFrame(planes: [CapturedPlane(bytes: bytes, bytesPerRow: 40)], width: 40, height: 40, rotationDegrees: 0);
    }
    final sharp = frameOf((x, y) => (x ~/ 2 + y ~/ 2).isEven ? 230 : 20);
    final blurred = frameOf((x, y) => 120 + (x % 4));
    expect(sharpnessOf(sharp), greaterThan(sharpnessOf(blurred) * 10));
  });

  group('spine search', () {
    late CollectionHarness harness;
    late RecordingSource books;
    late RecordingSource manga;
    late RecordingSource games;
    late CheckOwnership checkOwnership;

    setUp(() async {
      harness = CollectionHarness();
      final mangas = await harness.mangas();
      await harness.createCategory(name: 'Livres', colorValue: 0, type: CategoryType.books);
      await harness.createCategory(name: 'Jeux', colorValue: 0, type: CategoryType.videoGames);
      await harness.collection.saveSeries(Series(id: 'one-piece', categoryId: mangas.id, titles: const LocalizedTitles(byLanguage: {'fr': 'One Piece'})));
      await harness.collection.saveItem(CollectionItem(id: 'op-104', categoryId: mangas.id, seriesId: 'one-piece', volumeNumber: 104, titles: const LocalizedTitles(byLanguage: {'fr': 'One Piece'})));
      books = RecordingSource('googlebooks', CategoryType.books, {
        'one piece eiichiro oda': [matchOf('googlebooks', CategoryType.books, 'Le guide officiel des pirates')],
        'the legend of zelda tears of the kingdom': [matchOf('googlebooks', CategoryType.books, 'Zelda : le guide du jeu')],
      });
      manga = RecordingSource('mangadex', CategoryType.manga, {
        'one piece eiichiro oda': [matchOf('mangadex', CategoryType.manga, 'One Piece', creator: 'Eiichiro Oda')],
      });
      games = RecordingSource('igdb', CategoryType.videoGames, {
        'the legend of zelda tears of the kingdom': [
          matchOf('igdb', CategoryType.videoGames, 'The Legend of Zelda: Breath of the Wild'),
          matchOf('igdb', CategoryType.videoGames, 'The Legend of Zelda: Tears of the Kingdom'),
        ],
      });
      checkOwnership = CheckOwnership(FindLocally(harness.collection), SourceRegistry([books, manga, games]), harness.collection, harness.categories);
    });
    tearDown(() => harness.database.close());

    test('a spine misread by text recognition still finds the owned volume', () async {
      final verdict = await checkOwnership.spine('104 0NE PlECE Eiichiro 0da');
      expect((verdict as Owned).item.id, 'op-104');
    });

    test('a cover naming an owned two-word title is recognised even with a misread letter', () async {
      final verdict = await checkOwnership.cover(['0NE PIECE', '104', 'EIICHIRO ODA']);
      expect((verdict as Owned).item.id, 'op-104');
    });

    test('an owned volume is recognised from its spine without asking any catalogue', () async {
      final verdict = await checkOwnership.spine('104 ONE PIECE Eiichiro Oda Glénat');
      expect((verdict as Owned).item.id, 'op-104');
      expect(manga.queries, isEmpty);
    });

    test('a missing volume is searched without its noise and kept as that volume of the series', () async {
      final verdict = await checkOwnership.spine('105 ONE PIECE Eiichiro Oda Glénat');
      final match = (verdict as NotOwned).match!;
      expect((match.sourceKey, match.volumeNumber, match.seriesTitle), ('mangadex', 105, 'One Piece'));
      expect(manga.queries, ['one piece eiichiro oda']);
    });

    test('a game spine picks the catalogue entry whose title is written on it, not the first answer', () async {
      final verdict = await checkOwnership.spine('THE LEGEND OF ZELDA Tears of the Kingdom NINTENDO SWITCH PEGI 12');
      expect((verdict as NotOwned).match?.titles.byLanguage['fr'], 'The Legend of Zelda: Tears of the Kingdom');
    });

    test('answers that do not look like the spine are not taken for it', () async {
      final verdict = await checkOwnership.spine('Mon voisin Totoro');
      expect((verdict as NotOwned).match, isNull);
    });
  });
}
