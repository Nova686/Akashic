import 'dart:typed_data';

import 'package:akashic/layers/functional/Check/domain/use_cases/add_from_match.dart';
import 'package:akashic/layers/functional/Check/domain/use_cases/check_ownership.dart';
import 'package:akashic/layers/functional/Check/domain/use_cases/suggest_category.dart';
import 'package:akashic/layers/functional/Check/presentation/cubit/chain_scan_cubit.dart';
import 'package:akashic/layers/functional/Check/presentation/views/chain_scan_view.dart';
import 'package:akashic/layers/functional/Check/domain/use_cases/cover_text_lines.dart';
import 'package:akashic/layers/functional/Check/presentation/widgets/cover_text_reader.dart';
import 'package:akashic/layers/technical/AppShell/keyboard_focus.dart';
import 'package:akashic/layers/technical/Localization/app_localizations.dart';
import 'package:akashic/layers/technical/MediaStorage/phone_image_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockCheckOwnership extends Mock implements CheckOwnership {}

class MockAddFromMatch extends Mock implements AddFromMatch {}

class MockSuggestCategory extends Mock implements SuggestCategory {}

class SilentReader implements CoverTextReader {
  @override
  Future<List<CoverTextLine>> readLines(Uint8List image) async => const [];
}

class NoPicker implements PhoneImagePicker {
  @override
  Future<Uint8List?> pickFromGallery() async => null;

  @override
  Future<Uint8List?> takePhoto() async => null;
}

Widget localized(Widget home, {List<NavigatorObserver> observers = const []}) => MaterialApp(
      locale: const Locale('fr'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      navigatorObservers: observers,
      builder: (context, child) => TapOutsideClosesKeyboard(child: child!),
      home: home,
    );

void main() {
  testWidgets('the check opens as a panel over the page and closes with its button', (tester) async {
    await tester.pumpWidget(localized(Builder(
      builder: (context) => Scaffold(
        body: const Text('Ma collection'),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () => showModalBottomSheet<void>(
            context: context,
            isScrollControlled: true,
            builder: (sheetContext) => BlocProvider(
              create: (_) => ChainScanCubit(MockCheckOwnership(), MockAddFromMatch(), MockSuggestCategory(), coverTextReader: SilentReader()),
              child: ChainScanView(
                cameraBuilder: (onBarcode, onPhoto, onShelfPhoto) => const Text('caméra'),
                onSeeItem: (_) {},
                pickCategory: (_, _) async => null,
                onClose: () => Navigator.of(sheetContext).pop(),
              ),
            ),
          ),
          label: const Text("Je l'ai ?"),
        ),
      ),
    )));
    await tester.tap(find.text("Je l'ai ?"));
    await tester.pumpAndSettle();
    expect(find.text('caméra'), findsOneWidget);
    expect(find.text('Ma collection'), findsOneWidget);
    expect(find.byType(SegmentedButton<Object>), findsNothing);
    expect(find.text('Code-barres'), findsNothing);
    await tester.tap(find.byTooltip('Fermer'));
    await tester.pumpAndSettle();
    expect(find.text('caméra'), findsNothing);
  });

  testWidgets('a search field does not take the keyboard back when coming back to its page', (tester) async {
    await tester.pumpWidget(localized(
      Builder(
        builder: (context) => Scaffold(
          body: Column(
            children: [
              const TextField(key: Key('search')),
              TextButton(
                onPressed: () => Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => const Scaffold(body: Text('fiche')))),
                child: const Text('ouvrir'),
              ),
            ],
          ),
        ),
      ),
      observers: [KeyboardFocusDropper()],
    ));
    await tester.tap(find.byKey(const Key('search')));
    await tester.pump();
    expect(tester.testTextInput.isVisible, isTrue);
    await tester.tap(find.text('ouvrir'));
    await tester.pumpAndSettle();
    tester.state<NavigatorState>(find.byType(Navigator)).pop();
    await tester.pumpAndSettle();
    expect(FocusManager.instance.primaryFocus?.context?.widget, isNot(isA<EditableText>()));
    expect(tester.testTextInput.isVisible, isFalse);
  });

  testWidgets('touching outside a field closes the keyboard', (tester) async {
    await tester.pumpWidget(localized(const Scaffold(body: Column(children: [TextField(key: Key('search')), SizedBox(height: 300)]))));
    await tester.tap(find.byKey(const Key('search')));
    await tester.pump();
    expect(tester.testTextInput.isVisible, isTrue);
    await tester.tapAt(const Offset(200, 500));
    await tester.pump();
    expect(tester.testTextInput.isVisible, isFalse);
  });
}
