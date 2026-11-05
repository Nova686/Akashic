import 'package:akashic/layers/functional/Loans/domain/entities/loan.dart';
import 'package:akashic/layers/functional/Loans/domain/gateways/loan_gateway.dart';

abstract interface class LoanReminderStore {
  Future<Set<String>> remindedLoans();
  Future<void> saveRemindedLoans(Set<String> loanKeys);
}

abstract interface class LoanNotifier {
  Future<bool> requestPermission();
  Future<void> remind(List<Loan> overdueLoans);
}

String loanKeyOf(Loan loan) => '${loan.copyId}@${loan.since.millisecondsSinceEpoch}';

class RemindOverdueLoans {
  RemindOverdueLoans(this._loans, this._reminders, this._notifier, {DateTime Function()? now, this._delay = const Duration(days: 30)}) : _now = now ?? DateTime.now;

  final LoanGateway _loans;
  final LoanReminderStore _reminders;
  final LoanNotifier _notifier;
  final DateTime Function() _now;
  final Duration _delay;

  static const Duration followUpDelay = Duration(days: 7);
  static const String followUpSuffix = '|followup';

  Future<List<Loan>> call() async {
    final loans = await _loans.watchLoans().first;
    final reminded = await _reminders.remindedLoans();
    final now = _now();
    final overdue = <Loan>[];
    final newlyReminded = <String>{};
    for (final loan in loans) {
      final due = loan.dueOn ?? loan.since.add(_delay);
      final key = loanKeyOf(loan);
      final followUpKey = '$key$followUpSuffix';
      if (loan.remindsAtDue && !now.isBefore(due) && !reminded.contains(key)) {
        overdue.add(loan);
        newlyReminded.add(key);
      } else if (loan.followsUp && loan.dueOn != null && !now.isBefore(due.add(followUpDelay)) && !reminded.contains(followUpKey)) {
        overdue.add(loan);
        newlyReminded.add(followUpKey);
      }
    }
    if (overdue.isNotEmpty) {
      await _notifier.remind(overdue);
    }
    final stillLent = {for (final loan in loans) loanKeyOf(loan)};
    await _reminders.saveRemindedLoans({...reminded.where((key) => stillLent.contains(key.replaceAll(followUpSuffix, ''))), ...newlyReminded});
    return overdue;
  }
}
