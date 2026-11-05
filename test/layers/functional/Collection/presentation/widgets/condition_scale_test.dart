import 'package:akashic/layers/functional/Collection/domain/entities/item_condition.dart';
import 'package:akashic/layers/functional/Collection/presentation/widgets/condition_scale.dart';
import 'package:akashic/layers/technical/Localization/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('tapping a condition selects it and tapping it again clears it', (tester) async {
    final changes = <ItemCondition?>[];
    Widget scaleWith(ItemCondition? selected) => MaterialApp(
          locale: const Locale('fr'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(body: ConditionScale(part: 'Pochette', selected: selected, onChanged: changes.add)),
        );
    await tester.pumpWidget(scaleWith(null));
    await tester.tap(find.text('Manquant'));
    await tester.pumpWidget(scaleWith(ItemCondition.missing));
    await tester.tap(find.text('Manquant').last);
    expect(changes, [ItemCondition.missing, null]);
    expect(tester.takeException(), isNull);
  });
}
