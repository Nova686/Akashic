import 'package:akashic/layers/functional/Catalog/domain/entities/category.dart';
import 'package:akashic/layers/functional/Catalog/domain/use_cases/manage_categories.dart';
import 'package:akashic/layers/functional/Catalog/presentation/widgets/category_actions.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/collection_item.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/localized_titles.dart';
import 'package:akashic/layers/technical/Localization/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../Collection/collection_harness.dart';

void main() {
  late CollectionHarness harness;
  late ManageCategories manageCategories;

  setUp(() {
    harness = CollectionHarness();
    manageCategories = ManageCategories(harness.categories, harness.collection);
  });
  tearDown(() => harness.database.close());

  CategoryActionOutcome? outcome;

  Future<void> waitForOutcome(WidgetTester tester) async {
    for (var attempt = 0; attempt < 100 && outcome == null; attempt++) {
      await tester.runAsync(() => Future<void>.delayed(const Duration(milliseconds: 50)));
      await tester.pump();
    }
  }

  Future<CategoryActionOutcome?> runOnScreen(WidgetTester tester, CategoryAction action, Category category) async {
    outcome = null;
    await tester.pumpWidget(MaterialApp(
      locale: const Locale('fr'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Builder(
        builder: (context) => Scaffold(
          body: TextButton(
            onPressed: () async => outcome = await runCategoryAction(context, action, category, manageCategories),
            child: const Text('agir'),
          ),
        ),
      ),
    ));
    await tester.tap(find.text('agir'));
    await tester.runAsync(() => Future<void>.delayed(const Duration(milliseconds: 50)));
    await tester.pumpAndSettle();
    return outcome;
  }

  testWidgets('the edit page renames the category, edits its condition parts and adds a subcategory', (tester) async {
    final vinyls = await tester.runAsync(harness.vinyls);
    await runOnScreen(tester, CategoryAction.edit, vinyls!);
    expect(find.text('Modifier la catégorie'), findsOneWidget);
    await tester.enterText(find.byType(TextField).first, 'Disques');
    await tester.tap(find.descendant(of: find.widgetWithText(InputChip, 'Pochette'), matching: find.byType(Icon)).last);
    await tester.pump();
    final subcategoryField = find.widgetWithText(TextField, 'Nom de la sous-catégorie');
    await tester.scrollUntilVisible(subcategoryField, 200, scrollable: find.byType(Scrollable).first);
    await tester.enterText(subcategoryField, 'Jazz');
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pump();
    await tester.tap(find.text('Enregistrer'));
    await tester.pumpAndSettle();
    await waitForOutcome(tester);
    expect(outcome, CategoryActionOutcome.changed);
    final saved = await tester.runAsync(() => harness.categories.findById(vinyls.id));
    expect(saved?.name, 'Disques');
    expect(saved?.conditionParts, ['Disque']);
    final subcategories = await tester.runAsync(() => manageCategories.subcategoriesOf(saved!));
    expect(subcategories?.map((subcategory) => subcategory.name), ['Jazz']);
  });

  testWidgets('the edit page can delete the category after confirmation', (tester) async {
    final vinyls = await tester.runAsync(harness.vinyls);
    await runOnScreen(tester, CategoryAction.edit, vinyls!);
    await tester.scrollUntilVisible(find.widgetWithText(OutlinedButton, 'Supprimer la catégorie'), 200, scrollable: find.byType(Scrollable).first);
    await tester.tap(find.widgetWithText(OutlinedButton, 'Supprimer la catégorie'));
    await tester.runAsync(() => Future<void>.delayed(const Duration(milliseconds: 50)));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(FilledButton, 'Supprimer'));
    await tester.pumpAndSettle();
    await waitForOutcome(tester);
    expect(outcome, CategoryActionOutcome.deleted);
    expect(await tester.runAsync(() => harness.categories.findById(vinyls.id)), isNull);
  });

  testWidgets('deleting announces what goes with the category', (tester) async {
    final vinyls = await tester.runAsync(harness.vinyls);
    await tester.runAsync(() => harness.collection.saveItem(CollectionItem(id: 'kob', categoryId: vinyls!.id, titles: const LocalizedTitles(byLanguage: {'en': 'Kind of Blue'}))));
    await runOnScreen(tester, CategoryAction.delete, vinyls!);
    expect(find.text('Supprimer « Vinyles » ?'), findsOneWidget);
    expect(find.textContaining('1 objet, aucune série et aucune sous-catégorie'), findsOneWidget);
    await tester.tap(find.text('Supprimer'));
    await tester.pumpAndSettle();
    await waitForOutcome(tester);
    expect(outcome, CategoryActionOutcome.deleted);
    expect(await tester.runAsync(() => harness.categories.findById(vinyls.id)), isNull);
  });
}
