import 'package:akashic/layers/functional/Collection/domain/use_cases/search_text_normalizer.dart';
import 'package:akashic/layers/functional/Loans/domain/entities/loan.dart';

List<Loan> searchLoans(List<Loan> loans, String query) {
  final normalizedQuery = normalizeForSearch(query);
  if (normalizedQuery.isEmpty) {
    return loans;
  }
  return [
    for (final loan in loans)
      if ([...loan.itemTitles.byLanguage.values, loan.borrower, ?loan.edition].any((text) => normalizeForSearch(text).contains(normalizedQuery))) loan,
  ];
}
