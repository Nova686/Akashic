import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:akashic/layers/functional/Catalog/domain/entities/category.dart';
import 'package:akashic/layers/functional/Catalog/domain/entities/category_type.dart';
import 'package:akashic/layers/functional/Check/domain/entities/check_verdict.dart';
import 'package:akashic/layers/functional/Check/domain/gateways/cover_image_gateway.dart';
import 'package:akashic/layers/functional/Check/domain/use_cases/add_from_match.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/collection_item.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/item_condition.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/localized_titles.dart';
import 'package:akashic/layers/functional/Collection/domain/use_cases/add_item.dart';
import 'package:akashic/layers/functional/Collection/domain/use_cases/create_series.dart';
import 'package:akashic/layers/functional/Import/data/readers/spreadsheet_reader.dart';
import 'package:akashic/layers/functional/Import/domain/entities/import_table.dart';
import 'package:akashic/layers/functional/Import/domain/use_cases/import_rows.dart';
import 'package:akashic/layers/functional/Import/presentation/cubit/import_cubit.dart';
import 'package:akashic/layers/functional/Import/presentation/cubit/import_state.dart';
import 'package:akashic/layers/functional/Lookup/domain/entities/source_match.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../Collection/collection_harness.dart';

class NoCovers implements CoverImageGateway {
  @override
  Future<StoredCover?> storeCover(String url) async => null;
}

class ScriptedResolution extends Mock implements ResolveImportLine {}

const blueTrain = SourceMatch(
  sourceKey: 'musicbrainz',
  externalWorkId: 'rg-blue-train',
  titles: LocalizedTitles(byLanguage: {'en': 'Blue Train'}),
  creator: 'John Coltrane',
  suggestedType: CategoryType.music,
);

Uint8List csvOf(String text) => Uint8List.fromList(utf8.encode(text));

void main() {
  late CollectionHarness harness;
  late Category vinyls;
  late ImportRows importRows;
  late ScriptedResolution resolution;
  late ImportCubit cubit;

  setUpAll(() => registerFallbackValue(const ImportLine(rowNumber: 0)));

  setUp(() async {
    harness = CollectionHarness();
    vinyls = await harness.vinyls();
    final addItem = AddItem(harness.collection, harness.categories, newId: harness.newId);
    importRows = ImportRows(
      AddFromMatch(addItem, harness.collection, NoCovers(), newId: harness.newId),
      addItem,
      harness.collection,
      harness.categories,
      CreateSeries(harness.collection, newId: harness.newId),
      newId: harness.newId,
    );
    resolution = ScriptedResolution();
    when(() => resolution(any())).thenAnswer((invocation) async {
      final line = invocation.positionalArguments.single as ImportLine;
      return line.title == 'Blue Train' ? const NotOwned(blueTrain, 'Blue Train') : NotOwned(null, line.searchText);
    });
    cubit = ImportCubit(readSpreadsheet: readSpreadsheet, resolveLine: resolution, importRows: importRows)..chooseCategory(vinyls.id);
  });

  tearDown(() async {
    await cubit.close();
    await harness.database.close();
  });

  Future<void> loadAndReview() async {
    cubit.loadFile('collection.csv', csvOf('Titre;Artiste;Prix;Emplacement;État\nBlue Train;John Coltrane;12,50 €;Bac 2;Très bon\nPressage maison;Inconnu;3;;\n'));
    await cubit.startReview();
  }

  test('nothing is added before validation', () async {
    await loadAndReview();
    expect(cubit.state.step, ImportStep.review);
    expect(cubit.state.entries.map((entry) => entry.status), [ImportEntryStatus.found, ImportEntryStatus.notFound]);
    expect(cubit.state.includedCount, 1);
    expect(await harness.collection.allItems(), isEmpty);
  });

  test('a resolved row is added with its copy fields', () async {
    await loadAndReview();
    await cubit.commit('fr');
    expect(cubit.state.step, ImportStep.done);
    expect(cubit.state.addedCount, 1);
    final item = (await harness.collection.allItems()).single;
    expect(item.sourceKey, 'musicbrainz');
    final copy = (await harness.collection.watchCopies(item.id).first).single;
    expect(copy.pricePaidCents, 1250);
    expect(copy.location, 'Bac 2');
    expect(copy.conditions, {'Disque': ItemCondition.veryGood, 'Pochette': ItemCondition.veryGood});
  });

  test('an unresolved row can be added as is', () async {
    await loadAndReview();
    cubit
      ..toggle(0)
      ..toggle(1);
    await cubit.commit('fr');
    final item = (await harness.collection.allItems()).single;
    expect(item.titles.byLanguage, {'fr': 'Pressage maison'});
    expect(item.creator, 'Inconnu');
    expect((await harness.collection.watchCopies(item.id).first).single.pricePaidCents, 300);
  });

  test('rows of the same series end up in one series', () async {
    final mangas = await harness.mangas();
    for (final volume in [1, 2]) {
      await importRows(ImportLine(rowNumber: volume + 1, title: 'Frieren $volume', seriesTitle: 'Frieren', volumeNumber: volume), categoryId: mangas.id, languageCode: 'fr');
    }
    final series = await harness.collection.watchSeriesInCategoryTree(mangas.id).first;
    expect(series, hasLength(1));
    expect(await harness.collection.volumeNumbersOf(series.single.id), {1, 2});
  });

  test('an unreadable file stays on the first step with a notice', () {
    cubit.loadFile('photo.xlsx', Uint8List.fromList([1, 2, 3]));
    expect(cubit.state.step, ImportStep.chooseFile);
    expect(cubit.state.notice, ImportNotice.unreadable);
  });

  test('a row repeated in the file is imported once', () async {
    cubit.loadFile('collection.csv', csvOf('Titre;Artiste\nBlue Train;John Coltrane\nblue train;John Coltrane\n'));
    await cubit.startReview();
    expect(cubit.state.entries.map((entry) => entry.status), [ImportEntryStatus.found, ImportEntryStatus.duplicateInFile]);
    expect(cubit.state.includedCount, 1);
  });

  test('a row that fails does not stop the others and is never added twice', () async {
    final failingRows = FailingImportRows(importRows);
    final failingCubit = ImportCubit(readSpreadsheet: readSpreadsheet, resolveLine: resolution, importRows: failingRows)..chooseCategory(vinyls.id);
    failingCubit.loadFile('collection.csv', csvOf('Titre;Artiste\nBlue Train;John Coltrane\nPressage maison;Inconnu\n'));
    await failingCubit.startReview();
    failingCubit.toggle(1);
    await failingCubit.commit('fr');
    expect(failingCubit.state.step, ImportStep.review);
    expect(failingCubit.state.entries.map((entry) => entry.status), [ImportEntryStatus.failed, ImportEntryStatus.added]);
    expect(failingCubit.state.includedCount, 0);
    failingRows.isBroken = false;
    failingCubit.toggle(0);
    await failingCubit.commit('fr');
    expect(failingCubit.state.step, ImportStep.done);
    expect(failingCubit.state.addedCount, 2);
    expect(await harness.collection.allItems(), hasLength(2));
    await failingCubit.close();
  });
}

class FailingImportRows implements ImportRows {
  FailingImportRows(this._real);

  final ImportRows _real;
  bool isBroken = true;

  @override
  Future<CollectionItem> call(ImportLine line, {required String categoryId, required String languageCode, SourceMatch? match}) {
    if (isBroken && match != null) {
      throw const FileSystemException('disk full');
    }
    return _real(line, categoryId: categoryId, languageCode: languageCode, match: match);
  }
}
