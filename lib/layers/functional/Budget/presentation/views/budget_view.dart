import 'package:akashic/layers/functional/Budget/domain/entities/budget.dart';
import 'package:akashic/layers/functional/Budget/presentation/cubit/budget_cubit.dart';
import 'package:akashic/layers/functional/Budget/presentation/widgets/budget_gauge.dart';
import 'package:akashic/layers/functional/Collection/domain/use_cases/parse_price_to_cents.dart';
import 'package:akashic/layers/functional/Stats/presentation/views/stats_view.dart';
import 'package:akashic/layers/technical/Localization/app_localizations.dart';
import 'package:akashic/layers/technical/Theme/akashic_colors.dart';
import 'package:akashic/layers/technical/Theme/akashic_empty_state.dart';
import 'package:akashic/layers/technical/Theme/akashic_typography.dart';
import 'package:akashic/layers/technical/Theme/safe_scroll_padding.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class BudgetView extends StatelessWidget {
  const BudgetView({required this.onOpenItem, super.key});

  final ValueChanged<String> onOpenItem;

  Future<void> _editCeiling(BuildContext context, BudgetStatus status) async {
    final l10n = AppLocalizations.of(context);
    final cubit = context.read<BudgetCubit>();
    final controller = TextEditingController(text: status.settings.ceilingCents == null ? '' : '${status.settings.ceilingCents! ~/ 100}');
    final value = await showDialog<String>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.budgetCeiling),
        content: TextField(controller: controller, autofocus: true, keyboardType: const TextInputType.numberWithOptions(decimal: true), decoration: InputDecoration(suffixText: '€', helperText: l10n.budgetCeilingHelp)),
        actions: [
          TextButton(onPressed: () => Navigator.of(dialogContext).pop(), child: Text(l10n.cancel)),
          FilledButton(onPressed: () => Navigator.of(dialogContext).pop(controller.text), child: Text(l10n.save)),
        ],
      ),
    );
    controller.dispose();
    if (value == null) {
      return;
    }
    int? cents;
    try {
      cents = parsePriceToCents(value);
    } on InvalidPrice {
      return;
    }
    await cubit.save(BudgetSettings(ceilingCents: cents, alertPercent: status.settings.alertPercent, countsSteam: status.settings.countsSteam));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final cubit = context.read<BudgetCubit>();
    return BlocBuilder<BudgetCubit, BudgetStatus?>(
      builder: (context, status) => Scaffold(
        appBar: AppBar(title: Text(l10n.budget, style: AkashicTypography.displayTitle(size: 26))),
        body: status == null
            ? const AkashicLoader()
            : ListView(
                padding: safeListPadding(context),
                children: [
                  Text(
                    '${toBeginningOfSentenceCase(DateFormat.yMMMM(l10n.localeName).format(status.month))} · ${l10n.budgetDaysLeft(status.daysLeftFrom(DateTime.now()))}',
                    style: AkashicTypography.body(size: 13).copyWith(color: AkashicColors.textSoft),
                  ),
                  const SizedBox(height: 6),
                  Wrap(
                    crossAxisAlignment: WrapCrossAlignment.end,
                    spacing: 8,
                    children: [
                      Text(formatEuros(l10n, status.spentCents), style: AkashicTypography.numeral(size: 40).copyWith(color: budgetColor(status), height: 1.1)),
                      if (status.settings.ceilingCents case final ceiling?)
                        Padding(padding: const EdgeInsets.only(bottom: 6), child: Text(l10n.budgetOutOf(formatEuros(l10n, ceiling)), style: AkashicTypography.body(size: 15).copyWith(color: AkashicColors.textSoft))),
                    ],
                  ),
                  if (status.settings.ceilingCents != null) ...[
                    const SizedBox(height: 12),
                    Semantics(label: l10n.budgetGaugeLabel((status.ratio * 100).round(), status.settings.alertPercent), excludeSemantics: true, child: BudgetGauge(status: status)),
                    const SizedBox(height: 10),
                    if (status.isPastAlert)
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(14), border: Border.all(color: budgetColor(status), width: 1.5)),
                        child: Row(
                          children: [
                            Icon(Icons.notifications_active_outlined, color: budgetColor(status)),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                status.isOver
                                    ? l10n.budgetOverBy(formatEuros(l10n, -status.remainingCents!))
                                    : l10n.budgetOnlyLeft(formatEuros(l10n, status.remainingCents!), status.daysLeftFrom(DateTime.now())),
                                style: AkashicTypography.body(size: 14, weight: FontWeight.w700),
                              ),
                            ),
                          ],
                        ),
                      ),
                  ] else
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(l10n.budgetNoCeiling, style: AkashicTypography.body(size: 13).copyWith(color: AkashicColors.textSoft)),
                    ),
                  const SizedBox(height: 18),
                  Text(l10n.budgetSpendingOfMonth.toUpperCase(), style: AkashicTypography.body(size: 11, weight: FontWeight.w800).copyWith(color: AkashicColors.textSoft, letterSpacing: 1.1)),
                  if (status.expenses.isEmpty) Padding(padding: const EdgeInsets.only(top: 8), child: Text(l10n.budgetNothingSpent, style: AkashicTypography.body(size: 13).copyWith(color: AkashicColors.textSoft))),
                  for (final expense in status.expenses)
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      onTap: () => onOpenItem(expense.itemId),
                      title: Text(expense.title, maxLines: 2, overflow: TextOverflow.ellipsis, style: AkashicTypography.body(size: 14, weight: FontWeight.w700)),
                      subtitle: Text([DateFormat.MMMd(l10n.localeName).format(expense.at), ?expense.note].join(' · '), style: AkashicTypography.body(size: 12).copyWith(color: AkashicColors.textSoft)),
                      trailing: Text(formatEuros(l10n, expense.cents), style: AkashicTypography.body(size: 15, weight: FontWeight.w800)),
                    ),
                  const SizedBox(height: 18),
                  Text(l10n.settings.toUpperCase(), style: AkashicTypography.body(size: 11, weight: FontWeight.w800).copyWith(color: AkashicColors.textSoft, letterSpacing: 1.1)),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    onTap: () => _editCeiling(context, status),
                    title: Text(l10n.budgetCeiling, style: AkashicTypography.body(weight: FontWeight.w700)),
                    subtitle: Text(l10n.budgetCeilingHelp),
                    trailing: Text(status.settings.ceilingCents == null ? l10n.budgetNone : formatEuros(l10n, status.settings.ceilingCents!), style: AkashicTypography.body(size: 15, weight: FontWeight.w800)),
                  ),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(l10n.budgetAlertAt, style: AkashicTypography.body(weight: FontWeight.w700)),
                    subtitle: Text(l10n.budgetAlertAtHelp),
                    trailing: DropdownButton<int>(
                      value: status.settings.alertPercent,
                      items: [for (final percent in const [50, 70, 80, 90, 100]) DropdownMenuItem(value: percent, child: Text('$percent %'))],
                      onChanged: (percent) => percent == null ? null : cubit.save(BudgetSettings(ceilingCents: status.settings.ceilingCents, alertPercent: percent, countsSteam: status.settings.countsSteam)),
                    ),
                  ),
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    value: status.settings.countsSteam,
                    onChanged: (counts) => cubit.save(BudgetSettings(ceilingCents: status.settings.ceilingCents, alertPercent: status.settings.alertPercent, countsSteam: counts)),
                    title: Text(l10n.budgetCountSteam, style: AkashicTypography.body(weight: FontWeight.w700)),
                    subtitle: Text(l10n.budgetCountSteamHelp),
                  ),
                ],
              ),
      ),
    );
  }
}
