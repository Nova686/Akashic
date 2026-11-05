import 'dart:io';

import 'package:akashic/layers/functional/Collection/domain/entities/collection_item.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/localized_titles.dart';
import 'package:akashic/layers/technical/AppShell/akashic_app.dart';
import 'package:akashic/layers/technical/AppShell/dependency_scope.dart';
import 'package:akashic/layers/technical/LocalDatabase/akashic_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late AkashicDependencies dependencies;

  setUp(() => dependencies = AkashicDependencies(database: AkashicDatabase.forTesting(), imageRoot: Directory.systemTemp));
  tearDown(() => dependencies.database.close());

  Future<void> bootIn(WidgetTester tester, Locale deviceLocale) async {
    tester.platformDispatcher.localesTestValue = [deviceLocale];
    addTearDown(tester.platformDispatcher.clearLocalesTestValue);
    tester.platformDispatcher.accessibilityFeaturesTestValue = const FakeAccessibilityFeatures(disableAnimations: true);
    addTearDown(tester.platformDispatcher.clearAccessibilityFeaturesTestValue);
    await tester.runAsync(dependencies.settingsGateway.markTutorialSeen);
    await tester.pumpWidget(AkashicApp(dependencies: dependencies));
    await tester.pumpAndSettle();
  }

  Future<void> unmountApp(WidgetTester tester) async {
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump(Duration.zero);
  }

  testWidgets('a fresh install opens the tutorial over the collection', (tester) async {
    tester.platformDispatcher.localesTestValue = [const Locale('fr')];
    addTearDown(tester.platformDispatcher.clearLocalesTestValue);
    await tester.pumpWidget(AkashicApp(dependencies: dependencies));
    for (var attempt = 0; attempt < 20 && find.text('Bienvenue dans Akashic').evaluate().isEmpty; attempt++) {
      await tester.runAsync(() => Future<void>.delayed(const Duration(milliseconds: 20)));
      await tester.pump(const Duration(milliseconds: 100));
    }
    expect(find.text('Bienvenue dans Akashic'), findsOneWidget);
    await unmountApp(tester);
  });

  testWidgets('replaying the tutorial from the settings brings the tour back over the collection', (tester) async {
    await bootIn(tester, const Locale('fr'));
    dependencies.requestTour();
    await tester.pump();
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
    expect(find.text('Bienvenue dans Akashic'), findsOneWidget);
    await tester.tap(find.text('Suivant'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
    expect(find.text('Crée tes catégories'), findsOneWidget);
    await tester.tap(find.byTooltip('Fermer'));
    await tester.pump();
    expect(find.text('Crée tes catégories'), findsNothing);
    await unmountApp(tester);
  });

  testWidgets('app boots on the collection tab in french when the device is french', (tester) async {
    await bootIn(tester, const Locale('fr'));
    expect(find.text('Ma collection'), findsOneWidget);
    expect(find.byTooltip("Je l'ai ?"), findsOneWidget);
    expect(find.text("Je l'ai ?"), findsNothing);
    expect(find.byType(NavigationDestination), findsNWidgets(4));
    expect(find.text('Sorties'), findsOneWidget);
    expect(find.text('Découvertes'), findsOneWidget);
    await unmountApp(tester);
  });

  testWidgets('switching to english in settings relabels the navigation', (tester) async {
    await bootIn(tester, const Locale('fr'));
    final saving = dependencies.settingsGateway.saveAppLanguageCode('en');
    await tester.pumpAndSettle();
    await saving;
    await tester.pumpAndSettle();
    expect(find.byTooltip('Got it?'), findsOneWidget);
    expect(find.text('Wishes'), findsOneWidget);
    expect(find.text('My collection'), findsOneWidget);
    await unmountApp(tester);
  });

  testWidgets('the four tabs navigate', (tester) async {
    await bootIn(tester, const Locale('en'));
    await tester.tap(find.text('Wishes'));
    await tester.pumpAndSettle();
    expect(find.textContaining('No wishes yet'), findsOneWidget);
    await tester.tap(find.text('Discoveries'));
    await tester.pump();
    await tester.runAsync(() => Future<void>.delayed(const Duration(milliseconds: 300)));
    await tester.pump();
    expect(find.textContaining('Add items found online'), findsOneWidget);
    await tester.tap(find.text('Collection'));
    await tester.pumpAndSettle();
    expect(find.text('My collection'), findsOneWidget);
    await unmountApp(tester);
  });

  test('video games keep their details source behind the backup catalogue', () {
    final game = CollectionItem(id: 'witcher', categoryId: 'games', titles: const LocalizedTitles(byLanguage: {'en': 'The Witcher 3'}), sourceKey: 'igdb', externalWorkId: '1942');
    expect(dependencies.fetchItemDetails.canDescribe(game), dependencies.igdbSource.isConfigured);
  });
}
