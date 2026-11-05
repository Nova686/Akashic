import 'dart:typed_data';

import 'package:akashic/layers/technical/Theme/zoom_gallery.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('the zoomed view slides from one image to the next and closes on the blurred background', (tester) async {
    await tester.pumpWidget(MaterialApp(
      home: Builder(
        builder: (context) => Scaffold(
          body: Center(
            child: TextButton(
              onPressed: () => showZoomGallery(
                context,
                initialIndex: 0,
                images: const [
                  ZoomGalleryImage(heroTag: 'first', image: null, caption: 'Sol Ring', badge: '×2'),
                  ZoomGalleryImage(heroTag: 'second', image: null, caption: 'Plains'),
                ],
              ),
              child: const Text('open'),
            ),
          ),
        ),
      ),
    ));
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();
    expect(find.text('1 / 2'), findsOneWidget);
    expect(find.text('×2'), findsOneWidget);
    await tester.drag(find.byType(PageView), const Offset(-400, 0));
    await tester.pumpAndSettle();
    expect(find.text('2 / 2'), findsOneWidget);
    await tester.tapAt(const Offset(10, 10));
    await tester.pumpAndSettle();
    expect(find.text('2 / 2'), findsNothing);
    expect(find.text('open'), findsOneWidget);
  });

  testWidgets('a card zoom shows only the card, without its name nor its position', (tester) async {
    await tester.pumpWidget(MaterialApp(
      home: Builder(
        builder: (context) => Scaffold(
          body: Center(
            child: TextButton(
              onPressed: () => showZoomGallery(
                context,
                initialIndex: 0,
                showsPosition: false,
                images: [
                  ZoomGalleryImage(heroTag: 'sol-ring', image: MemoryImage(Uint8List(0)), placeholder: 'Sol Ring', badge: '×2'),
                  ZoomGalleryImage(heroTag: 'plains', image: MemoryImage(Uint8List(0)), placeholder: 'Plains'),
                ],
              ),
              child: const Text('open'),
            ),
          ),
        ),
      ),
    ));
    await tester.tap(find.text('open'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));
    expect(find.text('1 / 2'), findsNothing);
    expect(find.text('×2'), findsOneWidget);
    expect(find.byType(Text).evaluate().where((element) => (element.widget as Text).data == 'Sol Ring' && element.findAncestorWidgetOfExactType<Hero>() == null), isEmpty);
  });
}
