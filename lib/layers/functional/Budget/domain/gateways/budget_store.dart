import 'package:akashic/layers/functional/Budget/domain/entities/budget.dart';

abstract interface class BudgetStore {
  Stream<BudgetSettings> watchSettings();
  Future<void> save(BudgetSettings settings);
  Future<String?> alertedMonth();
  Future<void> markAlerted(String month);
}

abstract interface class BudgetAlerts {
  Future<void> nearCeiling(int remainingCents, int ceilingCents);
}
