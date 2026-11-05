import 'package:akashic/layers/functional/Catalog/domain/entities/category_type.dart';
import 'package:akashic/layers/functional/Check/domain/entities/check_verdict.dart';
import 'package:akashic/layers/functional/Check/domain/use_cases/check_ownership.dart';
import 'package:akashic/layers/functional/Check/domain/use_cases/cover_text_lines.dart';
import 'package:akashic/layers/functional/Check/domain/use_cases/find_locally.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/collection_item.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/localized_titles.dart';
import 'package:akashic/layers/functional/Lookup/domain/entities/source_match.dart';
import 'package:akashic/layers/functional/Lookup/domain/gateways/catalog_source.dart';
import 'package:akashic/layers/functional/Lookup/domain/use_cases/source_registry.dart';
import 'package:flutter_test/flutter_test.dart';

import '../Collection/collection_harness.dart';

class RecordingSource implements CatalogSource {
  RecordingSource(this.key, this.type, this.answers);

  @override
  final String key;
  final CategoryType type;
  final Map<String, List<SourceMatch>> answers;
  final List<String> queries = [];

  @override
  Set<CategoryType> get types => {type};

  @override
  bool get isConfigured => true;

  @override
  bool get supportsBarcode => false;

  @override
  Future<List<SourceMatch>> lookupBarcode(String barcode) async => const [];

  @override
  Future<List<SourceMatch>> search(String query) async {
    queries.add(query);
    return answers[query] ?? const [];
  }
}

SourceMatch matchOf(String key, CategoryType type, String title, {String? creator}) =>
    SourceMatch(sourceKey: key, externalWorkId: '$key-$title', titles: LocalizedTitles(byLanguage: {'fr': title}), creator: creator, suggestedType: type);

void main() {
  test('cover lines are ranked by text size, without prices, codes or blurbs', () {
    final lines = prominentCoverLines(const [
      CoverTextLine('STEREO', height: 12),
      CoverTextLine('12,99 €', height: 30),
      CoverTextLine('MILES DAVIS', height: 40),
      CoverTextLine('Kind of Blue', height: 64),
      CoverTextLine('KIND OF BLUE', height: 20),
      CoverTextLine('An album that changed jazz forever, recorded in two sessions at Columbia studio in 1959', height: 10),
      CoverTextLine('CL 1355', height: 14),
    ]);
    expect(lines, ['Kind of Blue', 'MILES DAVIS', 'STEREO']);
  });

  test('short japanese titles are kept while short latin noise is dropped', () {
    final lines = prominentCoverLines(const [
      CoverTextLine('進撃の巨人', height: 70),
      CoverTextLine('呪術', height: 50),
      CoverTextLine('ab', height: 40),
      CoverTextLine('ATTACK ON TITAN', height: 30),
    ]);
    expect(lines, ['進撃の巨人', '呪術', 'ATTACK ON TITAN']);
  });

  group('cover search', () {
    late CollectionHarness harness;
    late RecordingSource music;
    late RecordingSource books;
    late CheckOwnership checkOwnership;

    setUp(() async {
      harness = CollectionHarness();
      await harness.vinyls();
      await harness.createCategory(name: 'Livres', colorValue: 0, type: CategoryType.books);
      music = RecordingSource('discogs', CategoryType.music, {
        'Kind of Blue MILES DAVIS': [matchOf('discogs', CategoryType.music, 'Kind of Blue', creator: 'Miles Davis')],
      });
      books = RecordingSource('googlebooks', CategoryType.books, {
        'Kind of Blue MILES DAVIS': [matchOf('googlebooks', CategoryType.books, 'Blue', creator: 'Joni Mitchell')],
      });
      checkOwnership = CheckOwnership(
        FindLocally(harness.collection),
        SourceRegistry([books, music]),
        harness.collection,
        harness.categories,
      );
    });
    tearDown(() => harness.database.close());

    test('title and artist are searched together and the match closest to the cover wins', () async {
      final verdict = await checkOwnership.cover(['Kind of Blue', 'MILES DAVIS']);
      expect(verdict, isA<NotOwned>());
      expect((verdict as NotOwned).match?.sourceKey, 'discogs');
      expect(music.queries, ['Kind of Blue MILES DAVIS']);
    });

    test('without an answer for both lines the main line is searched alone', () async {
      music.answers['Kind of Blue'] = [matchOf('discogs', CategoryType.music, 'Kind of Blue', creator: 'Miles Davis')];
      music.answers.remove('Kind of Blue MILES DAVIS');
      books.answers.clear();
      final verdict = await checkOwnership.cover(['Kind of Blue', 'MILES DAVIS']);
      expect((verdict as NotOwned).match?.sourceKey, 'discogs');
      expect(music.queries, ['Kind of Blue MILES DAVIS', 'Kind of Blue']);
    });

    test('an owned item found by one of the lines answers without going online', () async {
      final vinyls = (await harness.categories.watchTree().first).first.category;
      await harness.collection.saveItem(CollectionItem(id: 'kob', categoryId: vinyls.id, titles: const LocalizedTitles(byLanguage: {'en': 'Kind of Blue'})));
      final verdict = await checkOwnership.cover(['MILES DAVIS', 'Kind of Blue']);
      expect(verdict, isA<Owned>());
      expect(music.queries, isEmpty);
    });
  });
}
