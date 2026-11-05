import 'package:akashic/layers/functional/Catalog/domain/entities/category_type.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/collection_item.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/item_progress.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/localized_titles.dart';
import 'package:akashic/layers/functional/Collection/domain/use_cases/set_item_progress.dart';
import 'package:akashic/layers/functional/Collection/presentation/widgets/progress_section.dart';
import 'package:akashic/layers/technical/Localization/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'collection_harness.dart';

void main() {
  group('saving progress', () {
    late CollectionHarness harness;

    setUp(() async {
      harness = CollectionHarness();
      final mangas = await harness.mangas();
      await harness.collection.saveItem(CollectionItem(id: 'frieren-1', categoryId: mangas.id, titles: const LocalizedTitles(byLanguage: {'fr': 'Frieren 1'})));
    });
    tearDown(() => harness.database.close());

    Future<ItemProgress?> progressOf() async => (await harness.collection.watchItem('frieren-1').first)?.progress;

    test('an item in progress keeps its chapter and page', () async {
      await SetItemProgress(harness.collection)('frieren-1', const ItemProgress(status: ProgressStatus.inProgress, chapter: ' 4 ', page: 87));
      expect(await progressOf(), const ItemProgress(status: ProgressStatus.inProgress, chapter: '4', page: 87));
    });

    test('a finished item forgets where it stopped, and clearing removes the status', () async {
      await SetItemProgress(harness.collection)('frieren-1', const ItemProgress(status: ProgressStatus.inProgress, chapter: '4', page: 87));
      await SetItemProgress(harness.collection)('frieren-1', const ItemProgress(status: ProgressStatus.finished, chapter: '4', page: 87));
      expect(await progressOf(), const ItemProgress(status: ProgressStatus.finished));
      await SetItemProgress(harness.collection)('frieren-1', null);
      expect(await progressOf(), isNull);
    });

    test('editing an item keeps its progress', () async {
      await SetItemProgress(harness.collection)('frieren-1', const ItemProgress(status: ProgressStatus.abandoned, chapter: '2', page: 30));
      final item = (await harness.collection.watchItem('frieren-1').first)!;
      await harness.collection.saveItem(item.copyWith(rating: () => 4));
      expect(await progressOf(), const ItemProgress(status: ProgressStatus.abandoned, chapter: '2', page: 30));
    });
  });

  testWidgets('a reading category names its statuses and asks for chapter and page while reading', (tester) async {
    ItemProgress? changed;
    await tester.pumpWidget(MaterialApp(
      locale: const Locale('fr'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(
        body: ProgressSection(
          progress: const ItemProgress(status: ProgressStatus.inProgress),
          categoryType: CategoryType.manga,
          onChanged: (progress) => changed = progress,
        ),
      ),
    ));
    expect(find.text('À lire'), findsOneWidget);
    expect(find.text('Lu'), findsOneWidget);
    await tester.enterText(find.widgetWithText(TextField, 'Chapitre'), '12');
    await tester.enterText(find.widgetWithText(TextField, 'Page'), '154');
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pump();
    expect(changed, const ItemProgress(status: ProgressStatus.inProgress, chapter: '12', page: 154));
  });

  testWidgets('a video game uses play words and never asks for a page', (tester) async {
    await tester.pumpWidget(MaterialApp(
      locale: const Locale('fr'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(body: ProgressSection(progress: const ItemProgress(status: ProgressStatus.inProgress), categoryType: CategoryType.videoGames, onChanged: (_) {})),
    ));
    expect(find.text('À jouer'), findsOneWidget);
    expect(find.text('Terminé'), findsOneWidget);
    expect(find.widgetWithText(TextField, 'Page'), findsNothing);
  });
}
