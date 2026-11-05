import 'dart:convert';

import 'package:akashic/layers/functional/Budget/domain/entities/budget.dart';
import 'package:akashic/layers/functional/Budget/domain/gateways/budget_store.dart';
import 'package:akashic/layers/technical/LocalDatabase/akashic_database.dart';

class DriftBudgetStore implements BudgetStore {
  DriftBudgetStore(this._database);

  static const String _settingsKey = 'budgetSettings';
  static const String _alertedKey = 'budgetAlertedMonth';

  final AkashicDatabase _database;

  Stream<String?> _watch(String key) => (_database.select(_database.preferences)..where((table) => table.key.equals(key))).watchSingleOrNull().map((row) => row?.value);

  Future<void> _write(String key, String value) => _database.into(_database.preferences).insertOnConflictUpdate(PreferencesCompanion.insert(key: key, value: value));

  @override
  Stream<BudgetSettings> watchSettings() => _watch(_settingsKey).map((value) {
        if (value == null) {
          return const BudgetSettings();
        }
        final fields = jsonDecode(value) as Map<String, Object?>;
        return BudgetSettings(ceilingCents: fields['ceilingCents'] as int?, alertPercent: fields['alertPercent'] as int? ?? 80, countsSteam: fields['countsSteam'] as bool? ?? true);
      });

  @override
  Future<void> save(BudgetSettings settings) => _write(_settingsKey, jsonEncode({'ceilingCents': settings.ceilingCents, 'alertPercent': settings.alertPercent, 'countsSteam': settings.countsSteam}));

  @override
  Future<String?> alertedMonth() => _watch(_alertedKey).first;

  @override
  Future<void> markAlerted(String month) => _write(_alertedKey, month);
}
