import 'package:akashic/layers/technical/Tour/guided_tour.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('the tour lights each target in turn and explains it next to it', (tester) async {
    final searchKey = GlobalKey();
    final scanKey = GlobalKey();
    var finished = 0;
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: Stack(
          children: [
            Positioned(top: 40, left: 20, child: SizedBox(key: searchKey, width: 200, height: 40)),
            Positioned(bottom: 40, right: 20, child: SizedBox(key: scanKey, width: 56, height: 56)),
            Positioned.fill(
              child: GuidedTour(
                steps: [
                  const TourStep(title: 'Bienvenue', text: 'Petit tour'),
                  TourStep(title: 'Recherche', text: 'Cherche ici', target: searchKey),
                  TourStep(title: 'Scanner', text: 'Scanne ici', target: scanKey),
                ],
                labels: TourLabels(previous: 'Précédent', next: 'Suivant', done: 'Terminer', close: 'Fermer', progress: (current, total) => '$current / $total'),
                onFinished: () => finished++,
              ),
            ),
          ],
        ),
      ),
    ));
    await tester.pump();
    expect(find.text('Bienvenue'), findsOneWidget);
    expect(find.text('1 / 3'), findsOneWidget);
    expect(find.text('Précédent'), findsNothing);
    await tester.tap(find.text('Suivant'));
    await tester.pumpAndSettle();
    expect(find.text('Recherche'), findsOneWidget);
    final searchRect = tester.getRect(find.byKey(searchKey));
    expect(tester.getRect(find.text('Recherche')).top, greaterThan(searchRect.bottom));
    await tester.tap(find.text('Suivant'));
    await tester.pumpAndSettle();
    expect(tester.getRect(find.text('Scanner')).bottom, lessThan(tester.getRect(find.byKey(scanKey)).top));
    expect(find.text('Terminer'), findsOneWidget);
    await tester.tap(find.text('Précédent'));
    await tester.pumpAndSettle();
    expect(find.text('Recherche'), findsOneWidget);
    await tester.tap(find.byTooltip('Fermer'));
    expect(finished, 1);
  });
}
