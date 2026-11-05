import 'package:akashic/layers/functional/Collection/domain/entities/localized_titles.dart';
import 'package:equatable/equatable.dart';

class Loan extends Equatable {
  const Loan({required this.copyId, required this.itemId, required this.itemTitles, required this.borrower, required this.since, this.edition, this.dueOn, this.remindsAtDue = true, this.followsUp = true});

  final String copyId;
  final String itemId;
  final LocalizedTitles itemTitles;
  final String? edition;
  final String borrower;
  final DateTime since;
  final DateTime? dueOn;
  final bool remindsAtDue;
  final bool followsUp;

  int? daysLateOn(DateTime today) => switch (dueOn) {
        final due? when DateTime(today.year, today.month, today.day).isAfter(due) => DateTime(today.year, today.month, today.day).difference(DateTime(due.year, due.month, due.day)).inDays,
        _ => null,
      };

  @override
  List<Object?> get props => [copyId, itemId, itemTitles, edition, borrower, since, dueOn, remindsAtDue, followsUp];
}
