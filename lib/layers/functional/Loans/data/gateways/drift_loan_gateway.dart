import 'package:akashic/layers/functional/Collection/domain/entities/localized_titles.dart';
import 'package:akashic/layers/functional/Loans/domain/entities/loan.dart';
import 'package:akashic/layers/functional/Loans/domain/gateways/loan_gateway.dart';
import 'package:akashic/layers/technical/LocalDatabase/akashic_database.dart';
import 'package:drift/drift.dart';

class DriftLoanGateway implements LoanGateway {
  DriftLoanGateway(this._database);

  final AkashicDatabase _database;

  @override
  Stream<List<Loan>> watchLoans() {
    return _database.customSelect('SELECT 1', readsFrom: {_database.copies, _database.items, _database.itemTitles}).watch().asyncMap((_) async {
      final copyRows = await (_database.select(_database.copies)
            ..where((table) => table.loanedTo.isNotNull())
            ..orderBy([(table) => OrderingTerm.asc(table.loanedSince)]))
          .get();
      final itemIds = copyRows.map((row) => row.itemId).toSet();
      final itemRows = await (_database.select(_database.items)..where((table) => table.id.isIn(itemIds))).get();
      final titleRows = await (_database.select(_database.itemTitles)..where((table) => table.itemId.isIn(itemIds))).get();
      final originalLanguageByItem = {for (final item in itemRows) item.id: item.originalLanguage};
      final titlesByItem = <String, Map<String, String>>{};
      for (final title in titleRows) {
        titlesByItem.putIfAbsent(title.itemId, () => {})[title.languageCode] = title.title;
      }
      return [
        for (final copy in copyRows)
          Loan(
            copyId: copy.id,
            itemId: copy.itemId,
            edition: copy.edition,
            borrower: copy.loanedTo!,
            since: copy.loanedSince ?? copy.createdAt,
            dueOn: copy.loanDueOn,
            remindsAtDue: copy.loanRemindsAtDue,
            followsUp: copy.loanFollowsUp,
            itemTitles: LocalizedTitles(
              byLanguage: titlesByItem[copy.itemId] ?? const {},
              originalLanguage: originalLanguageByItem[copy.itemId],
            ),
          ),
      ];
    });
  }

  @override
  Future<void> lend(String copyId, {required String borrower, required DateTime since, DateTime? dueOn, bool remindsAtDue = true, bool followsUp = true}) {
    return (_database.update(_database.copies)..where((table) => table.id.equals(copyId))).write(CopiesCompanion(
          loanedTo: Value(borrower),
          loanedSince: Value(since),
          loanDueOn: Value(dueOn),
          loanRemindsAtDue: Value(remindsAtDue),
          loanFollowsUp: Value(followsUp),
        ));
  }

  @override
  Future<void> returnCopy(String copyId) {
    return (_database.update(_database.copies)..where((table) => table.id.equals(copyId)))
        .write(const CopiesCompanion(loanedTo: Value(null), loanedSince: Value(null), loanDueOn: Value(null)));
  }
}
