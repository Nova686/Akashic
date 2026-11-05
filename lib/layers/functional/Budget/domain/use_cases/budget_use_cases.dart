import 'package:akashic/layers/functional/Budget/domain/entities/budget.dart';
import 'package:akashic/layers/functional/Budget/domain/gateways/budget_store.dart';
import 'package:akashic/layers/functional/Collection/domain/gateways/collection_gateway.dart';
import 'package:akashic/layers/functional/Collection/domain/use_cases/resolve_display_title.dart';
import 'package:akashic/layers/functional/Settings/domain/entities/preferred_languages.dart';

const String _steamSourceKey = 'steam';

String budgetMonthKey(DateTime moment) => '${moment.year}-${moment.month.toString().padLeft(2, '0')}';

class ComputeBudget {
  ComputeBudget(this._collection, this._store, {DateTime Function()? now}) : _now = now ?? DateTime.now;

  final CollectionGateway _collection;
  final BudgetStore _store;
  final DateTime Function() _now;

  Future<BudgetStatus> call([BudgetSettings? known]) async {
    final settings = known ?? await _store.watchSettings().first;
    final now = _now();
    final month = DateTime(now.year, now.month);
    final next = DateTime(now.year, now.month + 1);
    final copies = await _collection.firstCopiesByItem();
    final expenses = <BudgetExpense>[];
    for (final item in await _collection.allItems()) {
      final copy = copies[item.id];
      final paid = copy?.pricePaidCents;
      final at = copy?.purchasedOn ?? item.addedAt;
      if (paid == null || paid == 0 || at == null || at.isBefore(month) || !at.isBefore(next)) {
        continue;
      }
      if (!settings.countsSteam && item.sourceKey == _steamSourceKey) {
        continue;
      }
      expenses.add(BudgetExpense(itemId: item.id, title: resolveDisplayTitle(item.titles, PreferredLanguages.defaults) ?? '', cents: paid, at: at, note: item.sourceKey == _steamSourceKey ? 'Steam' : null));
    }
    expenses.sort((first, second) => second.at.compareTo(first.at));
    return BudgetStatus(settings: settings, expenses: expenses, month: month);
  }

  Stream<BudgetStatus> watch() => _store.watchSettings().asyncMap(call);
}

class CheckBudgetAlert {
  CheckBudgetAlert(this._compute, this._store, this._alerts);

  final ComputeBudget _compute;
  final BudgetStore _store;
  final BudgetAlerts _alerts;

  Future<bool> call() async {
    final status = await _compute();
    final ceiling = status.settings.ceilingCents;
    final month = budgetMonthKey(status.month);
    if (ceiling == null || !status.isPastAlert || await _store.alertedMonth() == month) {
      return false;
    }
    await _alerts.nearCeiling(status.remainingCents!, ceiling);
    await _store.markAlerted(month);
    return true;
  }
}
