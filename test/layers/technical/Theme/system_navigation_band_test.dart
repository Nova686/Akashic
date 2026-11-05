import 'package:akashic/layers/technical/Theme/system_navigation_band.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Widget withBottomInset(double inset) => MaterialApp(
        theme: ThemeData(navigationBarTheme: const NavigationBarThemeData(backgroundColor: Color(0xFF221E40))),
        home: MediaQuery(
          data: MediaQueryData(size: const Size(400, 800), viewPadding: EdgeInsets.only(bottom: inset), padding: EdgeInsets.only(bottom: inset)),
          child: const SystemNavigationBand(child: Scaffold(body: Text('Contenu'))),
        ),
      );

  testWidgets('the system buttons sit on an opaque band the colour of the navigation bar', (tester) async {
    await tester.pumpWidget(withBottomInset(48));
    final band = tester.widget<ColoredBox>(find.descendant(of: find.byType(IgnorePointer), matching: find.byType(ColoredBox)).last);
    expect(band.color, const Color(0xFF221E40));
    expect(tester.getSize(find.byWidget(band)).height, 48);
    expect(find.text('Contenu'), findsOneWidget);
  });

  testWidgets('without system buttons no band is drawn', (tester) async {
    await tester.pumpWidget(withBottomInset(0));
    expect(find.descendant(of: find.byType(SystemNavigationBand), matching: find.byType(Positioned)), findsNothing);
  });

  testWidgets('a full-screen camera hides the band while it is shown', (tester) async {
    Widget app({required bool isScanning}) => MaterialApp(
          home: MediaQuery(
            data: const MediaQueryData(size: Size(400, 800), viewPadding: EdgeInsets.only(bottom: 48), padding: EdgeInsets.only(bottom: 48)),
            child: SystemNavigationBand(child: isScanning ? const ImmersiveSystemBars(child: Scaffold(body: Text('Caméra'))) : const Scaffold(body: Text('Contenu'))),
          ),
        );
    Finder band() => find.descendant(of: find.byType(SystemNavigationBand), matching: find.byType(Positioned));
    await tester.pumpWidget(app(isScanning: true));
    await tester.pump();
    expect(band(), findsNothing);
    await tester.pumpWidget(app(isScanning: false));
    await tester.pump();
    expect(band(), findsOneWidget);
  });

  testWidgets('a full-screen camera covered by another page gives the band back', (tester) async {
    Widget app({required bool isCovered}) => MaterialApp(
          home: MediaQuery(
            data: const MediaQueryData(size: Size(400, 800), viewPadding: EdgeInsets.only(bottom: 48), padding: EdgeInsets.only(bottom: 48)),
            child: SystemNavigationBand(child: TickerMode(enabled: !isCovered, child: const ImmersiveSystemBars(child: Scaffold(body: Text('Caméra'))))),
          ),
        );
    Finder band() => find.descendant(of: find.byType(SystemNavigationBand), matching: find.byType(Positioned));
    await tester.pumpWidget(app(isCovered: false));
    await tester.pump();
    expect(band(), findsNothing);
    await tester.pumpWidget(app(isCovered: true));
    await tester.pump();
    expect(band(), findsOneWidget);
    await tester.pumpWidget(app(isCovered: false));
    await tester.pump();
    expect(band(), findsNothing);
  });
}
