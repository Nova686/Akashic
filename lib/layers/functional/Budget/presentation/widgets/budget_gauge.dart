import 'package:akashic/layers/functional/Budget/domain/entities/budget.dart';
import 'package:akashic/layers/functional/Stats/presentation/views/stats_view.dart';
import 'package:akashic/layers/technical/Localization/app_localizations.dart';
import 'package:akashic/layers/technical/Theme/akashic_colors.dart';
import 'package:akashic/layers/technical/Theme/akashic_typography.dart';
import 'package:flutter/material.dart';

Color budgetColor(BudgetStatus status) => status.isOver ? AkashicColors.coral : (status.isPastAlert ? AkashicColors.gold : AkashicColors.teal);

class BudgetGauge extends StatelessWidget {
  const BudgetGauge({required this.status, this.height = 12, super.key});

  final BudgetStatus status;
  final double height;

  @override
  Widget build(BuildContext context) {
    final color = budgetColor(status);
    return LayoutBuilder(
      builder: (context, constraints) => Stack(
        clipBehavior: Clip.none,
        children: [
          Container(height: height, decoration: BoxDecoration(borderRadius: BorderRadius.circular(height), border: Border.all(color: AkashicColors.line, width: 1.5))),
          Container(height: height, width: constraints.maxWidth * status.ratio.clamp(0, 1), decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(height))),
          Positioned(
            left: (constraints.maxWidth * status.settings.alertPercent / 100).clamp(0, constraints.maxWidth - 2),
            top: -3,
            child: Container(width: 2, height: height + 6, color: AkashicColors.coral),
          ),
        ],
      ),
    );
  }
}

class BudgetScanLine extends StatelessWidget {
  const BudgetScanLine({required this.status, super.key});

  final BudgetStatus? status;

  @override
  Widget build(BuildContext context) {
    final current = status;
    final remaining = current?.remainingCents;
    if (current == null || remaining == null) {
      return const SizedBox.shrink();
    }
    final l10n = AppLocalizations.of(context);
    final label = remaining >= 0 ? l10n.budgetLeft(formatEuros(l10n, remaining)) : l10n.budgetOverBy(formatEuros(l10n, -remaining));
    return Semantics(
      label: label,
      excludeSemantics: true,
      child: Padding(
        padding: const EdgeInsets.only(top: 6),
        child: Row(
          children: [
            Icon(Icons.account_balance_wallet_outlined, size: 16, color: budgetColor(current)),
            const SizedBox(width: 8),
            Expanded(child: BudgetGauge(status: current, height: 6)),
            const SizedBox(width: 10),
            Text(label, style: AkashicTypography.body(size: 12, weight: FontWeight.w800).copyWith(color: budgetColor(current))),
          ],
        ),
      ),
    );
  }
}
