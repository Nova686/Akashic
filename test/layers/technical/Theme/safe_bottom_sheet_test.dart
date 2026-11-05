import 'package:akashic/layers/technical/Theme/safe_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('a sheet keeps its last button above the phone navigation buttons', (tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 3;
    tester.view.padding = const FakeViewPadding(top: 72, bottom: 144);
    tester.view.viewPadding = const FakeViewPadding(top: 72, bottom: 144);
    addTearDown(tester.view.reset);
    await tester.pumpWidget(MaterialApp(
      home: Builder(
        builder: (context) => Scaffold(
          body: Center(
            child: TextButton(
              onPressed: () => showSafeBottomSheet<void>(
                context: context,
                isScrollControlled: true,
                builder: (sheetContext) => FractionallySizedBox(
                  heightFactor: 0.7,
                  child: Column(children: [const Expanded(child: SizedBox()), FilledButton(onPressed: () {}, child: const Text('Add'))]),
                ),
              ),
              child: const Text('Open'),
            ),
          ),
        ),
      ),
    ));
    await tester.tap(find.text('Open'));
    await tester.pumpAndSettle();
    expect(tester.getRect(find.widgetWithText(FilledButton, 'Add')).bottom, lessThanOrEqualTo(800 - 48));
  });
}
