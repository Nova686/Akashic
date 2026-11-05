import 'package:akashic/layers/functional/Activity/domain/entities/activity_event.dart';
import 'package:akashic/layers/functional/Activity/domain/gateways/activity_log.dart';
import 'package:akashic/layers/functional/Collection/domain/use_cases/resolve_display_title.dart';
import 'package:akashic/layers/functional/Loans/domain/entities/loan.dart';
import 'package:akashic/layers/functional/Settings/domain/entities/preferred_languages.dart';
import 'package:akashic/layers/functional/Loans/domain/gateways/loan_gateway.dart';

Future<void> _recordLoanEvent(ActivityLog? log, LoanGateway loans, String copyId, ActivityKind kind, DateTime at, {Loan? known}) async {
  if (log == null) {
    return;
  }
  final loan = known ?? (await loans.watchLoans().first).where((candidate) => candidate.copyId == copyId).firstOrNull;
  if (loan == null) {
    return;
  }
  await log.record(ActivityEvent(kind: kind, title: resolveDisplayTitle(loan.itemTitles, PreferredLanguages.defaults) ?? '', at: at, itemId: loan.itemId, detail: loan.borrower));
}

class LendCopy {
  LendCopy(this._loans, {DateTime Function()? now, this._activityLog}) : _now = now ?? DateTime.now;

  final LoanGateway _loans;
  final DateTime Function() _now;
  final ActivityLog? _activityLog;

  Future<bool> call(String copyId, String borrower, {DateTime? dueOn, bool remindsAtDue = true, bool followsUp = true}) async {
    final name = borrower.trim();
    if (name.isEmpty) {
      return false;
    }
    final since = _now();
    await _loans.lend(copyId, borrower: name, since: since, dueOn: dueOn, remindsAtDue: remindsAtDue, followsUp: followsUp);
    await _recordLoanEvent(_activityLog, _loans, copyId, ActivityKind.lent, since);
    return true;
  }
}

class ReturnCopy {
  ReturnCopy(this._loans, {this._activityLog, DateTime Function()? now}) : _now = now ?? DateTime.now;

  final LoanGateway _loans;
  final ActivityLog? _activityLog;
  final DateTime Function() _now;

  Future<void> call(String copyId) async {
    final loan = _activityLog == null ? null : (await _loans.watchLoans().first).where((candidate) => candidate.copyId == copyId).firstOrNull;
    await _loans.returnCopy(copyId);
    if (loan != null) {
      await _recordLoanEvent(_activityLog, _loans, copyId, ActivityKind.returned, _now(), known: loan);
    }
  }
}

class WatchLoans {
  WatchLoans(this._loans);

  final LoanGateway _loans;

  Stream<List<Loan>> call() => _loans.watchLoans();
}
