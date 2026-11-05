import 'package:akashic/layers/functional/Catalog/presentation/widgets/labeled_text_entry.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('the add button sits on its own line under the field', (tester) async {
    final added = <String>[];
    await tester.pumpWidget(MaterialApp(home: Scaffold(body: LabeledTextEntry(hint: 'Nom de la sous-catégorie', actionLabel: 'Ajouter', onSubmitted: added.add))));
    final field = tester.getRect(find.byType(TextField));
    final button = tester.getRect(find.widgetWithText(TextButton, 'Ajouter'));
    expect(button.top, greaterThanOrEqualTo(field.bottom));
    expect(field.width, tester.view.physicalSize.width / tester.view.devicePixelRatio);
    await tester.enterText(find.byType(TextField), 'Lorcana');
    await tester.tap(find.widgetWithText(TextButton, 'Ajouter'));
    expect(added, ['Lorcana']);
  });
}
