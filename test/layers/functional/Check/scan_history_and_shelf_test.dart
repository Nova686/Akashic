import 'dart:typed_data';

import 'package:akashic/layers/functional/Catalog/domain/entities/category.dart';
import 'package:akashic/layers/functional/Catalog/domain/entities/category_type.dart';
import 'package:akashic/layers/functional/Check/data/gateways/drift_scan_history_gateway.dart';
import 'package:akashic/layers/functional/Check/domain/entities/check_verdict.dart';
import 'package:akashic/layers/functional/Check/domain/entities/scan_session.dart';
import 'package:akashic/layers/functional/Check/domain/use_cases/add_from_match.dart';
import 'package:akashic/layers/functional/Check/domain/use_cases/check_ownership.dart';
import 'package:akashic/layers/functional/Check/domain/use_cases/shelf_spines.dart';
import 'package:akashic/layers/functional/Check/domain/use_cases/suggest_category.dart';
import 'package:akashic/layers/functional/Check/presentation/cubit/chain_scan_cubit.dart';
import 'package:akashic/layers/functional/Check/presentation/views/scan_history_view.dart';
import 'package:akashic/layers/functional/Check/presentation/views/shelf_frames_view.dart';
import 'package:akashic/layers/functional/Check/presentation/widgets/shelf_spine_reader.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/collection_item.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/localized_titles.dart';
import 'package:akashic/layers/functional/Lookup/domain/entities/source_match.dart';
import 'package:akashic/layers/technical/Localization/app_localizations.dart';
import 'package:akashic/layers/technical/LocalDatabase/akashic_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image/image.dart' as img;
import 'package:mocktail/mocktail.dart';

class MockCheckOwnership extends Mock implements CheckOwnership {}

class MockAddFromMatch extends Mock implements AddFromMatch {}

class MockSuggestCategory extends Mock implements SuggestCategory {}

class PhotographedShelf implements ShelfSpineReader {
  PhotographedShelf(this.reading);

  final ShelfReading reading;

  @override
  Future<ShelfReading> readShelf(Uint8List photo) async => reading;
}

const jazz = Category(id: 'jazz', name: 'Jazz', colorValue: 0, type: CategoryType.music, conditionParts: ['Disque'], position: 0);

SourceMatch album(String id) => SourceMatch(sourceKey: 'musicbrainz', externalWorkId: id, titles: LocalizedTitles(byLanguage: {'en': id}), suggestedType: CategoryType.music);

const kindOfBlue = CollectionItem(id: 'kob', categoryId: 'jazz', titles: LocalizedTitles(byLanguage: {'en': 'Kind of Blue'}));

const blueTrain = CollectionItem(id: 'train', categoryId: 'jazz', titles: LocalizedTitles(byLanguage: {'en': 'Blue Train'}));

Widget localized(Widget child) => MaterialApp(
      locale: const Locale('fr'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: child,
    );

void main() {
  late MockCheckOwnership checkOwnership;
  late MockAddFromMatch addFromMatch;
  late MockSuggestCategory suggestCategory;
  late AkashicDatabase database;
  late DriftScanHistoryGateway history;

  setUpAll(() => registerFallbackValue(album('fallback')));

  setUp(() {
    checkOwnership = MockCheckOwnership();
    addFromMatch = MockAddFromMatch();
    suggestCategory = MockSuggestCategory();
    database = AkashicDatabase.forTesting();
    history = DriftScanHistoryGateway(database);
    when(() => suggestCategory.forMatch(any())).thenAnswer((_) async => jazz);
    when(() => checkOwnership.spine('Blue Train John Coltrane')).thenAnswer((_) async => NotOwned(album('Blue Train'), 'Blue Train John Coltrane'));
    when(() => checkOwnership.spine('Kind of Blue Miles Davis')).thenAnswer((_) async => const Owned(kindOfBlue, []));
    when(() => checkOwnership.spine('Mingus Ah Um')).thenAnswer((_) async => const NotOwned(null, 'Mingus Ah Um'));
    when(() => addFromMatch(any(), categoryId: any(named: 'categoryId'), barcode: any(named: 'barcode'))).thenAnswer((_) async => blueTrain);
  });
  tearDown(() => database.close());

  ShelfReading shelfOfThree() => ShelfReading(
        spines: const [
          SpineText('Kind of Blue Miles Davis', confidence: 0.9, bounds: SpineBounds(left: 0.1, top: 0.1, right: 0.2, bottom: 0.9)),
          SpineText('Blue Train John Coltrane', confidence: 0.9, bounds: SpineBounds(left: 0.3, top: 0.1, right: 0.4, bottom: 0.9)),
          SpineText('Mingus Ah Um', confidence: 0.9, bounds: SpineBounds(left: 0.6, top: 0.2, right: 0.7, bottom: 0.8)),
        ],
        photo: img.encodePng(img.Image(width: 40, height: 20)),
        width: 40,
        height: 20,
      );

  test('a frame read on a turned photo lands on the same spot of the upright photo', () {
    const upright = SpineBounds(left: 10, top: 5, right: 20, bottom: 15);
    final quarter = uprightBoundsOf(const SpineBounds(left: 35, top: 10, right: 45, bottom: 20), quarterTurns: 1, width: 100, height: 50);
    final threeQuarters = uprightBoundsOf(const SpineBounds(left: 5, top: 80, right: 15, bottom: 90), quarterTurns: 3, width: 100, height: 50);
    for (final bounds in [quarter, threeQuarters]) {
      expect((bounds.left, bounds.top, bounds.right, bounds.bottom), (upright.left, upright.top, upright.right, upright.bottom));
    }
  });

  test('a spine frame covers every line read along it, and survives the title filter', () {
    final spines = spinesFromLines(const [
      SpineLine('Blue Train', left: 10, top: 100, right: 200, bottom: 130),
      SpineLine('John Coltrane', left: 220, top: 102, right: 400, bottom: 128),
    ]);
    final bounds = spineReadingsOf(spines).single.bounds!;
    expect((bounds.left, bounds.top, bounds.right, bounds.bottom), (10, 100, 400, 130));
  });

  test('closing a scan records the session with what was added, owned and missed', () async {
    final cubit = ChainScanCubit(checkOwnership, addFromMatch, suggestCategory, shelfSpineReader: PhotographedShelf(shelfOfThree()), history: history, now: () => DateTime(2026, 11, 3, 14, 7))
      ..photographShelf(Uint8List(1), pendingLabel: 'Lecture…');
    await cubit.whenIdle();
    final framed = cubit.state.entries.where((entry) => entry.spineBounds != null).toList();
    expect(framed, hasLength(3));
    expect(cubit.shelfPhoto(framed.first.shelfPhotoId!)?.width, 40);
    expect(await cubit.commit(), 1);
    await cubit.close();
    final session = (await history.watchAll().first).single;
    expect(session.startedAt, DateTime(2026, 11, 3, 14, 7));
    expect(session.mode, ScanSource.shelf);
    expect(session.entries.map((entry) => (entry.title, entry.outcome, entry.itemId)), [
      ('Blue Train', ScanOutcome.added, 'train'),
      ('Kind of Blue', ScanOutcome.owned, 'kob'),
      ('Mingus Ah Um', ScanOutcome.missed, null),
    ]);
  });

  test('a scan closed without reading anything leaves no session', () async {
    await ChainScanCubit(checkOwnership, addFromMatch, suggestCategory, history: history).close();
    expect(await history.watchAll().first, isEmpty);
  });

  testWidgets('the history groups sessions by month and the detail splits them by outcome', (tester) async {
    final sessions = [
      ScanSession(id: 'november', startedAt: DateTime(2026, 11, 3, 14, 7), mode: ScanSource.shelf, entries: const [
        ScanSessionEntry(title: 'Blue Train', outcome: ScanOutcome.added, source: ScanSource.shelf, itemId: 'train'),
        ScanSessionEntry(title: 'Kind of Blue', outcome: ScanOutcome.owned, source: ScanSource.shelf, itemId: 'kob'),
        ScanSessionEntry(title: 'Mingus Ah Um', outcome: ScanOutcome.missed, source: ScanSource.shelf),
      ]),
      ScanSession(id: 'october', startedAt: DateTime(2026, 10, 12, 9, 30), mode: ScanSource.barcode, entries: const [
        ScanSessionEntry(title: 'Moanin', outcome: ScanOutcome.added, source: ScanSource.barcode, itemId: 'moanin'),
      ]),
    ];
    String? opened;
    await tester.pumpWidget(localized(ScanHistoryView(sessions: Stream.value(sessions), onOpenSession: (sessionId) => opened = sessionId)));
    await tester.pumpAndSettle();
    expect(find.text('NOVEMBRE 2026'), findsOneWidget);
    expect(find.text('OCTOBRE 2026'), findsOneWidget);
    expect(find.text('1 ajouté · 1 déjà à toi · 1 introuvable'), findsOneWidget);
    await tester.tap(find.textContaining('Mardi 3 novembre'));
    expect(opened, 'november');
    String? item;
    await tester.pumpWidget(localized(ScanSessionView(session: Stream.value(sessions.first), onOpenItem: (itemId) => item = itemId)));
    await tester.pumpAndSettle();
    expect(find.text('AJOUTÉS · 1'), findsOneWidget);
    expect(find.text('DÉJÀ À TOI · 1'), findsOneWidget);
    expect(find.text('INTROUVABLES · 1'), findsOneWidget);
    await tester.tap(find.text('Kind of Blue'));
    expect(item, 'kob');
  });

  testWidgets('touching a frame lights its line up', (tester) async {
    final cubit = ChainScanCubit(checkOwnership, addFromMatch, suggestCategory, shelfSpineReader: PhotographedShelf(shelfOfThree()))..photographShelf(Uint8List(1), pendingLabel: 'Lecture…');
    await tester.runAsync(cubit.whenIdle);
    final photoId = cubit.state.entries.first.shelfPhotoId!;
    await tester.pumpWidget(localized(BlocProvider.value(
      value: cubit,
      child: ShelfFramesView(photoId: photoId, titleOf: (entry) => entry.label, statusLabel: (status, l10n) => status.name),
    )));
    await tester.pump();
    expect(find.text('Étagère lue'), findsOneWidget);
    expect(find.text('Ajouter 1 objet'), findsOneWidget);
    final frame = find.byWidgetPredicate((widget) => widget is Semantics && (widget.properties.label?.startsWith('3. Mingus Ah Um') ?? false));
    expect(frame, findsOneWidget);
    await tester.tap(frame);
    await tester.pumpAndSettle();
    final row = tester.widget<ListTile>(find.ancestor(of: find.text('Mingus Ah Um'), matching: find.byType(ListTile)));
    expect(row.selected, isTrue);
    await tester.runAsync(cubit.close);
  });
}
