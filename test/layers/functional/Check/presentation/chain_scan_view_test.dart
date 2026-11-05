import 'package:akashic/layers/functional/Catalog/domain/entities/category.dart';
import 'package:akashic/layers/functional/Catalog/domain/entities/category_type.dart';
import 'package:akashic/layers/functional/Check/presentation/cubit/chain_scan_cubit.dart';
import 'package:akashic/layers/functional/Check/presentation/cubit/chain_scan_state.dart';
import 'package:akashic/layers/functional/Check/presentation/views/chain_scan_view.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/localized_titles.dart';
import 'package:akashic/layers/functional/Lookup/domain/entities/source_match.dart';
import 'package:akashic/layers/technical/Localization/app_localizations.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockChainScanCubit extends MockCubit<ChainScanState> implements ChainScanCubit {}

const jazz = Category(id: 'jazz', name: 'Jazz', colorValue: 0, type: CategoryType.music, conditionParts: ['Disque'], position: 0);

const bebop = Category(id: 'bebop', name: 'Bebop', colorValue: 0, type: CategoryType.music, conditionParts: ['Disque'], position: 1);

SourceMatch album(String title) => SourceMatch(sourceKey: 'discogs', externalWorkId: title, titles: LocalizedTitles(byLanguage: {'en': title}), suggestedType: CategoryType.music);

Future<void> showChainScan(WidgetTester tester, ChainScanCubit cubit, {List<String>? openedItems}) => _show(tester, cubit, openedItems ?? []);

Future<void> _show(WidgetTester tester, ChainScanCubit cubit, List<String> openedItems) => tester.pumpWidget(MaterialApp(
      locale: const Locale('fr'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: BlocProvider<ChainScanCubit>.value(
        value: cubit,
        child: ChainScanView(
          cameraBuilder: (onBarcode, onPhoto, onShelfPhoto) => const ColoredBox(key: Key('camera'), color: Colors.black),
          onSeeItem: openedItems.add,
          pickCategory: (_, _) async => bebop,
        ),
      ),
    ));

void main() {
  testWidgets('the camera fills the whole screen', (tester) async {
    final cubit = MockChainScanCubit();
    when(() => cubit.canPhotographShelves).thenReturn(false);
    when(() => cubit.canAddAnother).thenReturn(false);
    when(() => cubit.state).thenReturn(const ChainScanState());
    await showChainScan(tester, cubit);
    expect(tester.getSize(find.byKey(const Key('camera'))), tester.view.physicalSize / tester.view.devicePixelRatio);
  });

  testWidgets('the drawer peeks with the latest scan and the count, then opens to the list and to the grouped review', (tester) async {
    final cubit = MockChainScanCubit();
    when(() => cubit.canPhotographShelves).thenReturn(false);
    when(() => cubit.canAddAnother).thenReturn(false);
    when(() => cubit.state).thenReturn(ChainScanState(entries: [
      ChainEntry(id: '111', label: '111', barcode: '111', status: ChainEntryStatus.found, match: album('Blue Train'), targetCategory: jazz, isAccepted: true),
      const ChainEntry(id: '333', label: '333', barcode: '333', status: ChainEntryStatus.alreadyOwned, ownedTitle: 'Giant Steps', ownedItemId: 'gs'),
      ChainEntry(id: 'cover-0', label: 'Kind of Blue', source: ChainEntrySource.cover, status: ChainEntryStatus.found, match: album('Kind of Blue'), targetCategory: jazz, isAccepted: true),
    ]));
    when(() => cubit.canAddToWishes).thenReturn(false);
    await showChainScan(tester, cubit);
    await tester.pumpAndSettle();
    expect(find.text('Kind of Blue'), findsOneWidget);
    expect(find.text('Pas encore à toi'), findsOneWidget);
    expect(find.text('2'), findsOneWidget);
    expect(find.text('à ajouter'), findsOneWidget);
    expect(find.byType(Checkbox), findsNothing);
    await tester.tap(find.bySemanticsLabel('Afficher la liste des scans'));
    await tester.pumpAndSettle();
    expect(find.text('Codes scannés'), findsOneWidget);
    expect(find.text('3 scannés · 1 déjà à toi'), findsOneWidget);
    final titles = tester.widgetList<ListTile>(find.byType(ListTile)).map((tile) => (tile.title! as Text).data).toList();
    expect(titles, ['Kind of Blue', 'Giant Steps', 'Blue Train']);
    await tester.tap(find.byType(Checkbox).first);
    verify(() => cubit.toggle(2)).called(1);
    await tester.drag(find.text('Codes scannés'), const Offset(0, -500));
    await tester.pumpAndSettle();
    expect(find.text('À AJOUTER · 2'), findsOneWidget);
    expect(find.text('DÉJÀ DANS TA COLLECTION · 1'), findsOneWidget);
    expect(find.text('Pochette'), findsOneWidget);
    await tester.tap(find.text('Jazz').first);
    await tester.pumpAndSettle();
    verify(() => cubit.moveTo(2, bebop)).called(1);
  });

  testWidgets('a failed scan is told inside the drawer instead of over the controls', (tester) async {
    final cubit = MockChainScanCubit();
    when(() => cubit.canPhotographShelves).thenReturn(false);
    when(() => cubit.canAddAnother).thenReturn(false);
    when(() => cubit.state).thenReturn(const ChainScanState(entries: [
      ChainEntry(id: '072', label: '0724349532521', barcode: '0724349532521', status: ChainEntryStatus.rateLimited),
    ]));
    await showChainScan(tester, cubit);
    await tester.pumpAndSettle();
    expect(find.text('Quota d’appels dépassé : 0724349532521 n’a pas pu être vérifié.'), findsOneWidget);
    expect(find.byType(SnackBar), findsNothing);
  });

  testWidgets('an unreadable cover asks for a closer photo', (tester) async {
    final cubit = MockChainScanCubit();
    when(() => cubit.canPhotographShelves).thenReturn(true);
    when(() => cubit.canAddAnother).thenReturn(false);
    when(() => cubit.state).thenReturn(const ChainScanState(entries: [
      ChainEntry(id: 'cover-0', label: 'Lecture de la pochette…', source: ChainEntrySource.cover, status: ChainEntryStatus.unreadable),
    ]));
    await showChainScan(tester, cubit);
    await tester.pumpAndSettle();
    expect(find.text('Pochette illisible'), findsOneWidget);
    expect(find.text('Reprends la photo, plus près et sans reflet.'), findsOneWidget);
  });

  testWidgets('the latest owned scan answers the question and opens its item', (tester) async {
    final cubit = MockChainScanCubit();
    when(() => cubit.canPhotographShelves).thenReturn(false);
    when(() => cubit.canAddAnother).thenReturn(false);
    when(() => cubit.state).thenReturn(const ChainScanState(entries: [
      ChainEntry(id: '222', label: '222', barcode: '222', status: ChainEntryStatus.alreadyOwned, ownedTitle: 'Kind of Blue', ownedItemId: 'kob'),
    ]));
    when(() => cubit.canAddToWishes).thenReturn(true);
    final openedItems = <String>[];
    await showChainScan(tester, cubit, openedItems: openedItems);
    await tester.pumpAndSettle();
    expect(find.text('Déjà à toi'), findsOneWidget);
    await tester.tap(find.text('Kind of Blue'));
    expect(openedItems, ['kob']);
  });

  testWidgets('something already owned can be added once more from the latest scan', (tester) async {
    final cubit = MockChainScanCubit();
    when(() => cubit.canPhotographShelves).thenReturn(false);
    when(() => cubit.canAddAnother).thenReturn(true);
    when(() => cubit.addAnotherOf(0)).thenAnswer((_) async {});
    when(() => cubit.state).thenReturn(const ChainScanState(entries: [
      ChainEntry(id: '222', label: '222', barcode: '222', status: ChainEntryStatus.alreadyOwned, ownedTitle: 'Kind of Blue', ownedItemId: 'kob'),
    ]));
    await showChainScan(tester, cubit);
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('J\'en ai un autre'));
    verify(() => cubit.addAnotherOf(0)).called(1);
  });
}
