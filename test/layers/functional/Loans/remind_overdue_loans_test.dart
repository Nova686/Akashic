import 'package:akashic/layers/functional/Collection/domain/entities/collection_item.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/item_copy.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/localized_titles.dart';
import 'package:akashic/layers/functional/Loans/data/gateways/drift_loan_gateway.dart';
import 'package:akashic/layers/functional/Loans/data/gateways/drift_loan_reminder_store.dart';
import 'package:akashic/layers/functional/Loans/domain/entities/loan.dart';
import 'package:akashic/layers/functional/Loans/domain/use_cases/remind_overdue_loans.dart';
import 'package:flutter_test/flutter_test.dart';

import '../Collection/collection_harness.dart';

class RecordingLoanNotifier implements LoanNotifier {
  final List<List<Loan>> reminders = [];

  @override
  Future<bool> requestPermission() async => true;

  @override
  Future<void> remind(List<Loan> overdueLoans) async => reminders.add(overdueLoans);
}

void main() {
  late CollectionHarness harness;
  late DriftLoanGateway loans;
  late RecordingLoanNotifier notifier;
  late DateTime today;
  late RemindOverdueLoans remindOverdueLoans;

  setUp(() async {
    harness = CollectionHarness();
    loans = DriftLoanGateway(harness.database);
    notifier = RecordingLoanNotifier();
    today = DateTime(2026, 11, 30);
    remindOverdueLoans = RemindOverdueLoans(loans, DriftLoanReminderStore(harness.database), notifier, now: () => today);
    final vinyls = await harness.vinyls();
    for (final itemId in ['kob', 'blue-train']) {
      await harness.collection.saveItem(CollectionItem(id: itemId, categoryId: vinyls.id, titles: LocalizedTitles(byLanguage: {'en': itemId})));
      await harness.collection.saveCopy(ItemCopy(id: '$itemId-copy', itemId: itemId));
    }
  });
  tearDown(() => harness.database.close());

  test('a loan reaching 30 days is reminded once, a recent one is not', () async {
    await loans.lend('kob-copy', borrower: 'Camille', since: DateTime(2026, 10, 31));
    await loans.lend('blue-train-copy', borrower: 'Sam', since: DateTime(2026, 11, 20));
    expect((await remindOverdueLoans()).map((loan) => loan.borrower), ['Camille']);
    expect(await remindOverdueLoans(), isEmpty);
    expect(notifier.reminders, hasLength(1));
  });

  test('a copy lent again later is reminded again after its own 30 days', () async {
    await loans.lend('kob-copy', borrower: 'Camille', since: DateTime(2026, 10, 1));
    await remindOverdueLoans();
    await loans.returnCopy('kob-copy');
    await loans.lend('kob-copy', borrower: 'Alex', since: DateTime(2026, 10, 25));
    expect((await remindOverdueLoans()).map((loan) => loan.borrower), ['Alex']);
  });
}
