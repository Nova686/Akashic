import 'package:akashic/layers/functional/Collection/domain/entities/collection_item.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/item_copy.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/localized_titles.dart';
import 'package:akashic/layers/functional/Loans/data/gateways/drift_loan_gateway.dart';
import 'package:akashic/layers/functional/Loans/data/gateways/drift_loan_reminder_store.dart';
import 'package:akashic/layers/functional/Loans/domain/entities/loan.dart';
import 'package:akashic/layers/functional/Loans/domain/use_cases/remind_overdue_loans.dart';
import 'package:akashic/layers/functional/Loans/presentation/views/loans_view.dart';
import 'package:akashic/layers/functional/Releases/data/gateways/drift_calendar_sync_store.dart';
import 'package:akashic/layers/functional/Releases/data/gateways/drift_release_store.dart';
import 'package:akashic/layers/functional/Releases/domain/entities/calendar_sync.dart';
import 'package:akashic/layers/functional/Releases/domain/entities/upcoming_release.dart';
import 'package:akashic/layers/functional/Releases/domain/gateways/calendar_writer.dart';
import 'package:akashic/layers/functional/Releases/domain/use_cases/sync_release_calendar.dart';
import 'package:akashic/layers/technical/Localization/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../Collection/collection_harness.dart';

class RecordingLoanNotifier implements LoanNotifier {
  final List<List<String>> reminded = [];

  @override
  Future<bool> requestPermission() async => true;

  @override
  Future<void> remind(List<Loan> overdueLoans) async => reminded.add([for (final loan in overdueLoans) loan.borrower]);
}

class FakeCalendar implements CalendarWriter {
  final Map<String, CalendarEventDraft> events = {};
  int _sequence = 0;

  @override
  Future<bool> requestAccess() async => true;

  @override
  Future<List<DeviceCalendarChoice>> writableCalendars() async => const [DeviceCalendarChoice(id: 'cal', name: 'Collection')];

  @override
  Future<String> createCalendar(String name) async => 'cal';

  @override
  Future<String> upsert(String calendarId, String? eventId, CalendarEventDraft draft) async {
    final id = eventId ?? 'event-${_sequence++}';
    events[id] = draft;
    return id;
  }

  @override
  Future<void> remove(String eventId) async => events.remove(eventId);
}

UpcomingRelease release(String id, String subject, ReleaseKind kind, DateTime day) =>
    UpcomingRelease(sourceKey: 'books', externalId: id, kind: kind, subject: subject, title: '$subject · $id', releaseDate: day);

void main() {
  late CollectionHarness harness;
  late DriftLoanGateway loans;

  setUp(() async {
    harness = CollectionHarness();
    loans = DriftLoanGateway(harness.database);
    final vinyls = await harness.vinyls();
    await harness.collection.saveItem(CollectionItem(id: 'kob', categoryId: vinyls.id, titles: const LocalizedTitles(byLanguage: {'en': 'Kind of Blue'})));
    await harness.collection.saveCopy(const ItemCopy(id: 'kob-copy', itemId: 'kob'));
  });
  tearDown(() => harness.database.close());

  test('a loan with a return date is reminded on that day, then followed up a week later, once each', () async {
    await loans.lend('kob-copy', borrower: 'Tom', since: DateTime(2026, 11, 1), dueOn: DateTime(2026, 11, 15));
    final notifier = RecordingLoanNotifier();
    var today = DateTime(2026, 11, 14);
    final remind = RemindOverdueLoans(loans, DriftLoanReminderStore(harness.database), notifier, now: () => today);
    await remind();
    expect(notifier.reminded, isEmpty);
    today = DateTime(2026, 11, 15);
    await remind();
    await remind();
    today = DateTime(2026, 11, 22);
    await remind();
    await remind();
    expect(notifier.reminded, [
      ['Tom'],
      ['Tom'],
    ]);
    final loan = (await loans.watchLoans().first).single;
    expect(loan.daysLateOn(DateTime(2026, 11, 18)), 3);
    expect(loan.daysLateOn(DateTime(2026, 11, 15)), isNull);
  });

  test('a loan without follow-up is reminded once only', () async {
    await loans.lend('kob-copy', borrower: 'Tom', since: DateTime(2026, 11, 1), dueOn: DateTime(2026, 11, 15), followsUp: false);
    final notifier = RecordingLoanNotifier();
    var today = DateTime(2026, 11, 16);
    final remind = RemindOverdueLoans(loans, DriftLoanReminderStore(harness.database), notifier, now: () => today);
    await remind();
    today = DateTime(2026, 12, 1);
    await remind();
    expect(notifier.reminded, hasLength(1));
  });

  testWidgets('the loan sheet hands back the borrower and the chosen return date', (tester) async {
    LoanTerms? terms;
    await tester.pumpWidget(MaterialApp(
      locale: const Locale('fr'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Builder(builder: (context) => Scaffold(body: TextButton(onPressed: () async => terms = await askLoanTerms(context, now: () => DateTime(2026, 11, 5)), child: const Text('prêter')))),
    ));
    await tester.tap(find.text('prêter'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), 'Tom');
    await tester.tap(find.text('1 semaine'));
    await tester.pump();
    await tester.tap(find.widgetWithText(FilledButton, 'Prêter'));
    await tester.pumpAndSettle();
    expect((terms?.borrower, terms?.dueOn, terms?.remindsAtDue), ('Tom', DateTime(2026, 11, 12), true));
  });

  test('releases go to the calendar as chosen, are updated in place and removed when no longer wanted', () async {
    final releaseStore = DriftReleaseStore(harness.database);
    final today = DateTime(2026, 11, 5);
    await releaseStore.saveOutlook(ReleaseOutlook(
      releases: [
        release('15', 'Frieren', ReleaseKind.nextVolume, DateTime(2026, 12, 12)),
        release('a1', 'Miles Davis', ReleaseKind.album, DateTime(2026, 11, 20)),
        release('old', 'Frieren', ReleaseKind.nextVolume, DateTime(2026, 10, 1)),
      ],
      computedAt: today,
      followedSubjects: 2,
    ));
    final store = DriftCalendarSyncStore(harness.database);
    final calendar = FakeCalendar();
    final sync = SyncReleaseCalendar(releaseStore, store, calendar, () async => (release, {required remindsTheEveBefore}) => CalendarEventDraft(title: release.title, day: release.releaseDate, description: '', remindsTheEveBefore: remindsTheEveBefore), now: () => today);
    expect(await sync(), 0);
    await store.saveSettings(const CalendarSyncSettings(isEnabled: true, calendarId: 'cal', kinds: {ReleaseKind.nextVolume, ReleaseKind.album}));
    expect(await sync(), 2);
    expect(calendar.events.values.map((event) => event.title).toSet(), {'Frieren · 15', 'Miles Davis · a1'});
    await sync();
    expect(calendar.events, hasLength(2));
    await store.saveSettings(const CalendarSyncSettings(isEnabled: true, calendarId: 'cal', kinds: {ReleaseKind.nextVolume, ReleaseKind.album}, mutedSubjects: {'Miles Davis'}, remindsTheEveBefore: false));
    expect(await sync(), 1);
    expect(calendar.events.values.single.remindsTheEveBefore, isFalse);
    expect((await store.watchSettings().first).mutedSubjects, {'Miles Davis'});
    await store.saveSettings(const CalendarSyncSettings());
    await sync();
    expect(calendar.events, isEmpty);
  });
}
