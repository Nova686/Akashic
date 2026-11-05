import 'package:akashic/layers/functional/Collection/presentation/widgets/learn_more_tab.dart';
import 'package:akashic/layers/functional/Details/domain/entities/item_details.dart';
import 'package:akashic/layers/technical/Localization/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Widget learnMoreIn(String languageCode) {
  return MaterialApp(
    locale: Locale(languageCode),
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    home: Scaffold(
      body: LearnMoreTab(
        details: ItemDetails(
          sections: const [
            FactsSection(facts: [DetailFact(kind: FactKind.status, value: 'RELEASING'), DetailFact(kind: FactKind.volumes, value: '13')], sourceLabel: 'AniList'),
          ],
          fetchedAt: DateTime(2026, 10, 26),
        ),
        isFetching: false,
        canFetch: true,
        onRefresh: () {},
      ),
    ),
  );
}

void main() {
  testWidgets('the publication status is translated and punctuated for English', (tester) async {
    await tester.pumpWidget(learnMoreIn('en'));
    expect(find.text('Status: Ongoing'), findsOneWidget);
    expect(find.textContaining('RELEASING'), findsNothing);
  });

  testWidgets('the publication status is translated and punctuated for French', (tester) async {
    await tester.pumpWidget(learnMoreIn('fr'));
    expect(find.text('Statut : En cours'), findsOneWidget);
  });
}
