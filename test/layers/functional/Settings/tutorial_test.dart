import 'package:akashic/layers/functional/Settings/domain/use_cases/manage_tutorial.dart';
import 'package:flutter_test/flutter_test.dart';

import '../Collection/collection_harness.dart';

void main() {
  test('a fresh install shows the tutorial once, until it is seen', () async {
    final harness = CollectionHarness();
    addTearDown(harness.database.close);
    final tutorial = ManageTutorial(harness.settings, harness.categories);
    expect(await tutorial.shouldShowOnFirstLaunch(), isTrue);
    expect(await tutorial.shouldShowOnFirstLaunch(), isTrue);
    await tutorial.markSeen();
    expect(await tutorial.shouldShowOnFirstLaunch(), isFalse);
  });

  test('an app already in use never shows the tutorial by itself', () async {
    final harness = CollectionHarness();
    addTearDown(harness.database.close);
    await harness.mangas();
    final tutorial = ManageTutorial(harness.settings, harness.categories);
    expect(await tutorial.shouldShowOnFirstLaunch(), isFalse);
    expect(await harness.settings.hasSeenTutorial(), isTrue);
  });
}
