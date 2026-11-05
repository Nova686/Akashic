import 'dart:convert';

import 'package:akashic/layers/functional/Loans/domain/use_cases/remind_overdue_loans.dart';
import 'package:akashic/layers/technical/LocalDatabase/akashic_database.dart';

class DriftLoanReminderStore implements LoanReminderStore {
  DriftLoanReminderStore(this._database);

  static const String _remindedLoansKey = 'remindedLoans';

  final AkashicDatabase _database;

  @override
  Future<Set<String>> remindedLoans() async {
    final row = await (_database.select(_database.preferences)..where((table) => table.key.equals(_remindedLoansKey))).getSingleOrNull();
    return row == null ? <String>{} : Set<String>.from(jsonDecode(row.value) as List);
  }

  @override
  Future<void> saveRemindedLoans(Set<String> loanKeys) =>
      _database.into(_database.preferences).insertOnConflictUpdate(PreferencesCompanion.insert(key: _remindedLoansKey, value: jsonEncode(loanKeys.toList())));
}
