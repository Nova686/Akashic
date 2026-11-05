import 'package:akashic/layers/functional/Loans/domain/entities/loan.dart';

abstract interface class LoanGateway {
  Stream<List<Loan>> watchLoans();
  Future<void> lend(String copyId, {required String borrower, required DateTime since, DateTime? dueOn, bool remindsAtDue = true, bool followsUp = true});
  Future<void> returnCopy(String copyId);
}
