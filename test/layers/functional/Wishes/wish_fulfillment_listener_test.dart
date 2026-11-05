import 'dart:async';

import 'package:akashic/layers/functional/Catalog/domain/entities/category_type.dart';
import 'package:akashic/layers/functional/Wishes/domain/entities/wish.dart';
import 'package:akashic/layers/functional/Wishes/presentation/widgets/wish_fulfillment_listener.dart';
import 'package:akashic/layers/technical/Localization/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('each fulfilled wish is announced', (tester) async {
    final fulfilled = StreamController<List<Wish>>();
    await tester.pumpWidget(MaterialApp(
      locale: const Locale('fr'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: WishFulfillmentListener(fulfilledWishes: fulfilled.stream, child: const Scaffold()),
    ));
    fulfilled.add([
      Wish(id: 'w1', createdAt: DateTime(2026), draft: const WishDraft(categoryType: CategoryType.music, title: 'Blue Train', origin: WishOrigin.search)),
    ]);
    await tester.pump();
    expect(find.text('Blue Train est dans ta collection, retiré de tes envies.'), findsOneWidget);
    await fulfilled.close();
  });

  testWidgets('several wishes fulfilled together get a single message', (tester) async {
    final fulfilled = StreamController<List<Wish>>();
    await tester.pumpWidget(MaterialApp(
      locale: const Locale('fr'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: WishFulfillmentListener(fulfilledWishes: fulfilled.stream, child: const Scaffold()),
    ));
    fulfilled.add([
      for (final title in ['Frieren', 'Dandadan'])
        Wish(id: title, createdAt: DateTime(2026), draft: WishDraft(categoryType: CategoryType.manga, title: title, origin: WishOrigin.search)),
    ]);
    await tester.pump();
    expect(find.text('2 envies sont dans ta collection, retirées de tes envies.'), findsOneWidget);
    await fulfilled.close();
  });
}
