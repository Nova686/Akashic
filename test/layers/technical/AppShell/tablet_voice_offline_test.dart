import 'package:akashic/layers/functional/Check/domain/entities/check_verdict.dart';
import 'package:akashic/layers/functional/Check/domain/use_cases/add_from_match.dart';
import 'package:akashic/layers/functional/Check/domain/use_cases/check_ownership.dart';
import 'package:akashic/layers/functional/Check/domain/use_cases/suggest_category.dart';
import 'package:akashic/layers/functional/Check/presentation/cubit/chain_scan_cubit.dart';
import 'package:akashic/layers/functional/Check/presentation/cubit/chain_scan_state.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/collection_item.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/localized_titles.dart';
import 'package:akashic/layers/technical/AppShell/adaptive_home_layout.dart';
import 'package:akashic/layers/technical/HttpAccess/offline_pill.dart';
import 'package:akashic/layers/technical/Localization/app_localizations.dart';
import 'package:akashic/layers/technical/Voice/voice_search_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockCheckOwnership extends Mock implements CheckOwnership {}

class MockAddFromMatch extends Mock implements AddFromMatch {}

class MockSuggestCategory extends Mock implements SuggestCategory {}

class ScriptedVoice implements VoiceListener {
  ScriptedVoice(this.words);

  final String words;
  bool wasStopped = false;

  @override
  Future<bool> start({required String localeId, required void Function(HeardWords heard) onHeard, required VoidCallback onDone}) async {
    onHeard((words: words.split(' ').first, isFinal: false));
    Future<void>.delayed(const Duration(milliseconds: 10), () => onHeard((words: words, isFinal: true)));
    return true;
  }

  @override
  Future<void> stop() async => wasStopped = true;
}

Widget localized(Widget child) => MaterialApp(
      locale: const Locale('fr'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: child,
    );

void main() {
  testWidgets('a wide screen shows the item next to the list instead of opening it', (tester) async {
    tester.view.physicalSize = const Size(1180, 820);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    final pushed = <String>[];
    await tester.pumpWidget(localized(Scaffold(
      body: AdaptiveHomeLayout(
        pushItem: pushed.add,
        detail: (itemId) => Text('fiche $itemId'),
        home: (openItem) => TextButton(onPressed: () => openItem('kob'), child: const Text('Kind of Blue')),
      ),
    )));
    expect(find.text('Choisis un objet à gauche pour voir sa fiche ici.'), findsOneWidget);
    await tester.tap(find.text('Kind of Blue'));
    await tester.pump();
    expect(find.text('fiche kob'), findsOneWidget);
    expect(pushed, isEmpty);
  });

  testWidgets('a phone keeps opening items on their own page', (tester) async {
    tester.view.physicalSize = const Size(400, 800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    final pushed = <String>[];
    await tester.pumpWidget(localized(Scaffold(
      body: AdaptiveHomeLayout(pushItem: pushed.add, detail: (itemId) => Text('fiche $itemId'), home: (openItem) => TextButton(onPressed: () => openItem('kob'), child: const Text('Kind of Blue'))),
    )));
    await tester.tap(find.text('Kind of Blue'));
    expect(pushed, ['kob']);
  });

  testWidgets('the voice sheet hands back what was said', (tester) async {
    String? heard;
    final voice = ScriptedVoice('zelda tears of the kingdom');
    await tester.pumpWidget(localized(Builder(builder: (context) => Scaffold(body: TextButton(onPressed: () async => heard = await listenForSearch(context, voice), child: const Text('micro'))))));
    await tester.tap(find.text('micro'));
    await tester.pumpAndSettle(const Duration(milliseconds: 50));
    await tester.pump(const Duration(milliseconds: 20));
    await tester.pumpAndSettle();
    expect(heard, 'zelda tears of the kingdom');
    expect(voice.wasStopped, isTrue);
  });

  testWidgets('the offline pill only shows without a connection', (tester) async {
    await tester.pumpWidget(localized(Scaffold(body: OfflinePill(isOffline: Stream.value(true)))));
    await tester.pump();
    expect(find.text('Hors ligne'), findsOneWidget);
    await tester.pumpWidget(localized(Scaffold(body: OfflinePill(isOffline: Stream.value(false)))));
    await tester.pump();
    expect(find.text('Hors ligne'), findsNothing);
  });

  test('words said in the scan are checked like a title', () async {
    final checkOwnership = MockCheckOwnership();
    const owned = CollectionItem(id: 'kob', categoryId: 'jazz', titles: LocalizedTitles(byLanguage: {'en': 'Kind of Blue'}));
    when(() => checkOwnership.spine('kind of blue')).thenAnswer((_) async => const Owned(owned, []));
    final cubit = ChainScanCubit(checkOwnership, MockAddFromMatch(), MockSuggestCategory())..lookUpWords(' kind of blue ');
    await cubit.whenIdle();
    expect(cubit.state.entries.single.status, ChainEntryStatus.alreadyOwned);
    await cubit.close();
  });
}
