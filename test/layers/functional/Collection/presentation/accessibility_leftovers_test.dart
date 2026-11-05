import 'package:akashic/layers/functional/Collection/domain/use_cases/series_completion.dart';
import 'package:akashic/layers/functional/Collection/presentation/widgets/series_completion_grid.dart';
import 'package:akashic/layers/technical/Localization/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Widget host(Widget child, {double textScale = 1}) => MaterialApp(
      locale: const Locale('fr'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: MediaQuery(
        data: MediaQueryData(textScaler: TextScaler.linear(textScale)),
        child: Scaffold(body: SingleChildScrollView(child: child)),
      ),
    );

void main() {
  const completion = SeriesCompletion(owned: [1, 3], missing: [2], published: 3, nextUnreleased: 4);

  testWidgets('each volume of a series says its number and whether it is owned, missing or not out yet', (tester) async {
    final semantics = tester.ensureSemantics();
    await tester.pumpWidget(host(SeriesCompletionGrid(completion: completion)));
    expect(find.bySemanticsLabel('Tome 1, possédé'), findsOneWidget);
    expect(find.bySemanticsLabel('Tome 2, manquant'), findsOneWidget);
    expect(find.bySemanticsLabel('Tome 4, pas encore sorti'), findsOneWidget);
    semantics.dispose();
  });

  testWidgets('the series grid holds large text without overflowing', (tester) async {
    await tester.pumpWidget(host(SeriesCompletionGrid(completion: completion), textScale: 2));
    expect(tester.takeException(), isNull);
  });
}
