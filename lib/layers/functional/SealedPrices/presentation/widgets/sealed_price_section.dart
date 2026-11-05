import 'package:akashic/layers/functional/Collection/domain/use_cases/parse_price_to_cents.dart';
import 'package:akashic/layers/functional/SealedPrices/domain/entities/price_alert.dart';
import 'package:akashic/layers/functional/SealedPrices/domain/entities/sealed_price.dart';
import 'package:akashic/layers/functional/Stats/presentation/views/stats_view.dart';
import 'package:akashic/layers/technical/Localization/app_localizations.dart';
import 'package:akashic/layers/technical/Theme/akashic_colors.dart';
import 'package:akashic/layers/technical/Theme/akashic_typography.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SealedPriceSection extends StatefulWidget {
  const SealedPriceSection({required this.watchPrice, required this.onRefresh, this.hasOpenedCopy = false, this.watchAlert, this.onSaveAlert, this.onRemoveAlert, super.key});

  final Stream<SealedPrice?> Function() watchPrice;
  final Future<void> Function() onRefresh;
  final bool hasOpenedCopy;
  final Stream<PriceAlert?> Function()? watchAlert;
  final Future<void> Function(int thresholdCents, bool isAbove)? onSaveAlert;
  final Future<void> Function()? onRemoveAlert;

  @override
  State<SealedPriceSection> createState() => _SealedPriceSectionState();
}

class _SealedPriceSectionState extends State<SealedPriceSection> {
  late final Stream<SealedPrice?> _price = widget.watchPrice();
  late final Stream<PriceAlert?>? _alert = widget.watchAlert?.call();
  bool _isRefreshing = false;

  Future<void> _refresh() async {
    setState(() => _isRefreshing = true);
    try {
      await widget.onRefresh();
    } finally {
      if (mounted) {
        setState(() => _isRefreshing = false);
      }
    }
  }

  Future<void> _editAlert(PriceAlert? current, int? suggestedCents) async {
    final save = widget.onSaveAlert;
    if (save == null) {
      return;
    }
    final chosen = await showDialog<(int, bool)>(context: context, builder: (dialogContext) => _PriceAlertDialog(current: current, suggestedCents: suggestedCents, onRemove: widget.onRemoveAlert));
    if (chosen != null) {
      await save(chosen.$1, chosen.$2);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return StreamBuilder<SealedPrice?>(
      stream: _price,
      builder: (context, snapshot) {
        final price = snapshot.data;
        final details = [
          if (price?.lowCents case final cents?) (l10n.sealedPriceLow, cents),
          if (price?.averageCents case final cents?) (l10n.sealedPriceAverage, cents),
          if (price?.average1Cents case final cents?) (l10n.sealedPriceAverage1, cents),
          if (price?.average7Cents case final cents?) (l10n.sealedPriceAverage7, cents),
          if (price?.average30Cents case final cents?) (l10n.sealedPriceAverage30, cents),
        ];
        return Container(
          margin: const EdgeInsets.only(top: 12),
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(color: AkashicColors.surface, borderRadius: BorderRadius.circular(20)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(l10n.sealedMarketPrice.toUpperCase(), style: AkashicTypography.body(size: 11, weight: FontWeight.w700).copyWith(color: AkashicColors.textSoft, letterSpacing: 1.1)),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(color: AkashicColors.teal.withValues(alpha: 0.16), borderRadius: BorderRadius.circular(7)),
                    child: Text(l10n.sealedMarketPriceSealedOnly, style: AkashicTypography.body(size: 11, weight: FontWeight.w700).copyWith(color: AkashicColors.teal)),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              if (price?.trendCents ?? price?.referenceCents case final reference?) ...[
                Text(l10n.sealedPriceTrend, style: AkashicTypography.body(size: 12).copyWith(color: AkashicColors.textSoft)),
                Text(formatEuros(l10n, reference), style: AkashicTypography.numeral(size: 30).copyWith(color: AkashicColors.teal)),
              ] else
                Text(l10n.sealedPriceMissing, style: AkashicTypography.body(size: 13).copyWith(color: AkashicColors.textSoft)),
              if (details.isNotEmpty) ...[
                const SizedBox(height: 10),
                for (final (label, cents) in details)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 3),
                    child: Row(
                      children: [
                        Expanded(child: Text(label, style: AkashicTypography.body(size: 13))),
                        Text(formatEuros(l10n, cents), style: AkashicTypography.numeral(size: 14)),
                      ],
                    ),
                  ),
              ],
              if (widget.onSaveAlert != null)
                StreamBuilder<PriceAlert?>(
                  stream: _alert,
                  builder: (context, alertSnapshot) {
                    final alert = alertSnapshot.data;
                    final euros = NumberFormat.currency(locale: l10n.localeName, symbol: '€');
                    return Align(
                      alignment: Alignment.centerLeft,
                      child: TextButton.icon(
                        onPressed: () => _editAlert(alert, price?.referenceCents),
                        icon: Icon(alert == null ? Icons.notifications_none : Icons.notifications_active, size: 18, color: AkashicColors.lavender),
                        label: Text(
                          alert == null
                              ? l10n.priceAlert
                              : l10n.priceAlertSummary((alert.isAbove ? l10n.priceAlertAbove : l10n.priceAlertBelow).toLowerCase(), euros.format(alert.thresholdCents / 100)),
                          style: AkashicTypography.body(size: 13, weight: FontWeight.w600).copyWith(color: AkashicColors.lavender),
                        ),
                      ),
                    );
                  },
                ),
              if (widget.hasOpenedCopy) ...[
                const SizedBox(height: 10),
                Text(l10n.sealedOpenedHasNoPrice, style: AkashicTypography.body(size: 12).copyWith(color: AkashicColors.gold)),
              ],
              const SizedBox(height: 8),
              Row(
                children: [
                  if (price != null)
                    Expanded(
                      child: Text(
                        l10n.sealedPricedOn(DateFormat.yMMMd(l10n.localeName).add_Hm().format(price.pricedAt.toLocal())),
                        style: AkashicTypography.body(size: 12).copyWith(color: AkashicColors.textSoft),
                      ),
                    )
                  else
                    const Spacer(),
                  TextButton.icon(
                    onPressed: _isRefreshing ? null : _refresh,
                    icon: _isRefreshing ? const SizedBox.square(dimension: 16, child: CircularProgressIndicator(strokeWidth: 2)) : const Icon(Icons.sync, color: AkashicColors.teal),
                    label: Text(l10n.refreshSealedPrices, style: AkashicTypography.body(size: 13, weight: FontWeight.w600).copyWith(color: AkashicColors.teal)),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

class _PriceAlertDialog extends StatefulWidget {
  const _PriceAlertDialog({required this.current, required this.suggestedCents, this.onRemove});

  final PriceAlert? current;
  final int? suggestedCents;
  final Future<void> Function()? onRemove;

  @override
  State<_PriceAlertDialog> createState() => _PriceAlertDialogState();
}

class _PriceAlertDialogState extends State<_PriceAlertDialog> {
  late final TextEditingController _threshold = TextEditingController(
    text: switch (widget.current?.thresholdCents ?? widget.suggestedCents) {
      final cents? => (cents / 100).toStringAsFixed(2).replaceAll('.', ','),
      null => '',
    },
  );
  late bool _isAbove = widget.current?.isAbove ?? true;
  bool _hasError = false;

  @override
  void dispose() {
    _threshold.dispose();
    super.dispose();
  }

  void _confirm() {
    int? cents;
    try {
      cents = parsePriceToCents(_threshold.text);
    } on InvalidPrice {
      cents = null;
    }
    if (cents == null || cents == 0) {
      setState(() => _hasError = true);
      return;
    }
    Navigator.of(context).pop((cents, _isAbove));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return AlertDialog(
      title: Text(l10n.priceAlert),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SegmentedButton<bool>(
            showSelectedIcon: false,
            segments: [
              ButtonSegment(value: true, icon: const Icon(Icons.trending_up), label: Text(l10n.priceAlertAbove)),
              ButtonSegment(value: false, icon: const Icon(Icons.trending_down), label: Text(l10n.priceAlertBelow)),
            ],
            selected: {_isAbove},
            onSelectionChanged: (selection) => setState(() => _isAbove = selection.first),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _threshold,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: InputDecoration(labelText: l10n.priceAlertThreshold, suffixText: '€', errorText: _hasError ? l10n.priceInvalid : null),
          ),
        ],
      ),
      actions: [
        if (widget.current != null && widget.onRemove != null)
          TextButton(
            onPressed: () async {
              final navigator = Navigator.of(context);
              await widget.onRemove!();
              navigator.pop();
            },
            child: Text(l10n.removePriceAlert),
          ),
        TextButton(onPressed: () => Navigator.of(context).pop(), child: Text(l10n.cancel)),
        FilledButton(onPressed: _confirm, child: Text(l10n.save)),
      ],
    );
  }
}
