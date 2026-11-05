import 'package:equatable/equatable.dart';

class BudgetSettings extends Equatable {
  const BudgetSettings({this.ceilingCents, this.alertPercent = 80, this.countsSteam = true});

  final int? ceilingCents;
  final int alertPercent;
  final bool countsSteam;

  @override
  List<Object?> get props => [ceilingCents, alertPercent, countsSteam];
}

class BudgetExpense extends Equatable {
  const BudgetExpense({required this.itemId, required this.title, required this.cents, required this.at, this.note});

  final String itemId;
  final String title;
  final int cents;
  final DateTime at;
  final String? note;

  @override
  List<Object?> get props => [itemId, title, cents, at, note];
}

class BudgetStatus extends Equatable {
  const BudgetStatus({required this.settings, required this.expenses, required this.month});

  final BudgetSettings settings;
  final List<BudgetExpense> expenses;
  final DateTime month;

  int get spentCents => expenses.fold(0, (total, expense) => total + expense.cents);

  int? get remainingCents => settings.ceilingCents == null ? null : settings.ceilingCents! - spentCents;

  double get ratio => settings.ceilingCents == null || settings.ceilingCents == 0 ? 0 : spentCents / settings.ceilingCents!;

  bool get isPastAlert => settings.ceilingCents != null && ratio * 100 >= settings.alertPercent;

  bool get isOver => settings.ceilingCents != null && spentCents > settings.ceilingCents!;

  int daysLeftFrom(DateTime now) => DateTime(month.year, month.month + 1).difference(DateTime(now.year, now.month, now.day)).inDays;

  @override
  List<Object?> get props => [settings, expenses, month];
}
