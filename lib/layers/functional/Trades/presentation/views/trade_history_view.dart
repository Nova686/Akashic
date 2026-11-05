import 'package:akashic/layers/functional/Collection/domain/use_cases/resolve_display_title.dart';
import 'package:akashic/layers/functional/Collection/presentation/widgets/trade_channel_label.dart';
import 'package:akashic/layers/functional/Stats/presentation/views/stats_view.dart';
import 'package:akashic/layers/functional/Trades/domain/entities/trade_history.dart';
import 'package:akashic/layers/functional/Trades/presentation/cubit/trade_history_cubit.dart';
import 'package:akashic/layers/technical/Localization/app_localizations.dart';
import 'package:akashic/layers/technical/Theme/akashic_colors.dart';
import 'package:akashic/layers/technical/Theme/akashic_empty_state.dart';
import 'package:akashic/layers/technical/Theme/akashic_typography.dart';
import 'package:akashic/layers/technical/Theme/safe_scroll_padding.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class TradeHistoryView extends StatelessWidget {
  const TradeHistoryView({required this.onOpenItem, super.key});

  final ValueChanged<String> onOpenItem;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return BlocBuilder<TradeHistoryCubit, TradeHistoryState>(
      builder: (context, state) {
        final history = state.history;
        final entries = history.entries;
        return Scaffold(
          appBar: AppBar(title: Text(l10n.tradeHistory, style: AkashicTypography.displayTitle(size: 26))),
          body: state.isLoading
              ? const AkashicLoader()
              : history.isEmpty
                  ? Center(child: AkashicEmptyState(message: l10n.noTrades))
                  : ListView(
                      padding: safeListPadding(context),
                      children: [
                        IntrinsicHeight(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Expanded(child: _TotalTile(label: l10n.tradeSpent, value: formatEuros(l10n, history.spentCents))),
                              const SizedBox(width: 10),
                              Expanded(child: _TotalTile(label: l10n.tradeEarned, value: formatEuros(l10n, history.earnedCents))),
                            ],
                          ),
                        ),
                        if (history.sales.isNotEmpty) ...[
                          const SizedBox(height: 10),
                          _TotalTile(
                            label: l10n.tradeMargin,
                            value: '${history.marginCents > 0 ? '+' : ''}${formatEuros(l10n, history.marginCents)}',
                            caption: l10n.tradeMarginCaption,
                            valueColor: history.marginCents >= 0 ? AkashicColors.teal : AkashicColors.gold,
                          ),
                        ],
                        for (final (index, entry) in entries.indexed) ...[
                          if (index == 0 || !_sameMonth(entries[index - 1].happenedOn, entry.happenedOn))
                            Padding(
                              padding: const EdgeInsets.only(top: 22, bottom: 4),
                              child: Semantics(
                                header: true,
                                child: Text(toBeginningOfSentenceCase(DateFormat.yMMMM(l10n.localeName).format(entry.happenedOn)), style: AkashicTypography.displayTitle(size: 18)),
                              ),
                            ),
                          _TradeTile(entry: entry, title: resolveDisplayTitle(entry.titles, state.preferredLanguages) ?? l10n.untitled, onTap: () => onOpenItem(entry.itemId)),
                        ],
                      ],
                    ),
        );
      },
    );
  }

  bool _sameMonth(DateTime first, DateTime second) => first.year == second.year && first.month == second.month;
}

class _TotalTile extends StatelessWidget {
  const _TotalTile({required this.label, required this.value, this.caption, this.valueColor});

  final String label;
  final String value;
  final String? caption;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: AkashicColors.surface, borderRadius: BorderRadius.circular(18)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label.toUpperCase(), style: AkashicTypography.body(size: 11, weight: FontWeight.w700).copyWith(color: AkashicColors.textSoft, letterSpacing: 1.1)),
            const SizedBox(height: 6),
            FittedBox(fit: BoxFit.scaleDown, alignment: Alignment.centerLeft, child: Text(value, style: AkashicTypography.numeral(size: 24).copyWith(color: valueColor))),
            if (caption != null) Text(caption!, style: AkashicTypography.body(size: 12).copyWith(color: AkashicColors.textSoft)),
          ],
        ),
      );
}

class _TradeTile extends StatelessWidget {
  const _TradeTile({required this.entry, required this.title, required this.onTap});

  final TradeEntry entry;
  final String title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final date = DateFormat.yMMMd(l10n.localeName).format(entry.happenedOn);
    final (kind, icon, color, amount, details, margin) = switch (entry) {
      PurchaseEntry(:final purchase) => (
          l10n.tradePurchase,
          Icons.south_west,
          AkashicColors.lavender,
          purchase.priceCents == null ? '—' : '−${formatEuros(l10n, purchase.priceCents!)}',
          [?purchase.edition, if (purchase.channel case final channel?) tradeChannelLabel(channel, l10n)],
          null,
        ),
      SaleEntry(:final sale) => (
          l10n.tradeSale,
          Icons.north_east,
          AkashicColors.teal,
          '+${formatEuros(l10n, sale.salePriceCents)}',
          [?sale.edition, if (sale.saleChannel case final channel?) tradeChannelLabel(channel, l10n), if (sale.wasOpened) l10n.openedState],
          sale.marginCents,
        ),
    };
    return Semantics(
      button: true,
      label: '$kind, $title, $date, $amount',
      onTap: onTap,
      excludeSemantics: true,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(color: color.withValues(alpha: 0.18), shape: BoxShape.circle),
                child: Icon(icon, size: 18, color: color),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, maxLines: 1, overflow: TextOverflow.ellipsis, style: AkashicTypography.body(size: 14, weight: FontWeight.w700)),
                    Text([kind, date, ...details].join(' · '), maxLines: 1, overflow: TextOverflow.ellipsis, style: AkashicTypography.body(size: 12).copyWith(color: AkashicColors.textSoft)),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(amount, style: AkashicTypography.numeral(size: 15).copyWith(color: entry is SaleEntry ? AkashicColors.teal : null)),
                  if (margin != null)
                    Text(
                      l10n.marginOf('${margin > 0 ? '+' : ''}${formatEuros(l10n, margin)}'),
                      style: AkashicTypography.body(size: 11, weight: FontWeight.w600).copyWith(color: margin >= 0 ? AkashicColors.teal : AkashicColors.gold),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
