import 'dart:async';

import 'package:akashic/layers/functional/Collection/domain/entities/collection_item.dart';
import 'package:akashic/layers/functional/Collection/domain/gateways/collection_gateway.dart';
import 'package:akashic/layers/functional/Collection/domain/use_cases/parse_price_to_cents.dart';
import 'package:akashic/layers/functional/Collection/domain/use_cases/resolve_display_title.dart';
import 'package:akashic/layers/functional/Preorders/domain/use_cases/preorder_use_cases.dart';
import 'package:akashic/layers/functional/Settings/domain/entities/preferred_languages.dart';
import 'package:akashic/layers/functional/Stats/presentation/views/stats_view.dart';
import 'package:akashic/layers/technical/Localization/app_localizations.dart';
import 'package:akashic/layers/technical/Theme/akashic_colors.dart';
import 'package:akashic/layers/technical/Theme/akashic_typography.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

String preorderCountdown(Preorder preorder, AppLocalizations l10n, DateTime today) => switch (preorder.daysLeftFrom(today)) {
      <= 0 => l10n.preorderToday,
      final days => l10n.preorderInDays(days),
    };

Future<(DateTime, int?)?> askPreorder(BuildContext context, {Preorder? current}) => showModalBottomSheet<(DateTime, int?)>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (sheetContext) => _PreorderSheet(current: current),
    );

class _PreorderSheet extends StatefulWidget {
  const _PreorderSheet({this.current});

  final Preorder? current;

  @override
  State<_PreorderSheet> createState() => _PreorderSheetState();
}

class _PreorderSheetState extends State<_PreorderSheet> {
  late DateTime? _dueOn = widget.current?.dueOn;
  late final TextEditingController _deposit = TextEditingController(text: widget.current?.depositCents == null ? '' : (widget.current!.depositCents! / 100).toStringAsFixed(2).replaceAll('.', ','));
  bool _hasDepositError = false;

  @override
  void dispose() {
    _deposit.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final today = DateTime.now();
    return Padding(
      padding: EdgeInsets.fromLTRB(18, 0, 18, 16 + MediaQuery.viewInsetsOf(context).bottom + MediaQuery.paddingOf(context).bottom),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(l10n.preorderTitle, style: AkashicTypography.displayTitle(size: 24)),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            icon: const Icon(Icons.event),
            label: Text(_dueOn == null ? l10n.preorderPickDate : l10n.preorderDeliveryOn(DateFormat.yMMMMEEEEd(l10n.localeName).format(_dueOn!))),
            onPressed: () async {
              final picked = await showDatePicker(context: context, initialDate: _dueOn ?? today.add(const Duration(days: 30)), firstDate: DateTime(today.year - 1), lastDate: DateTime(today.year + 3));
              if (picked != null) {
                setState(() => _dueOn = picked);
              }
            },
          ),
          const SizedBox(height: 10),
          TextField(
            controller: _deposit,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: InputDecoration(labelText: l10n.preorderDeposit, suffixText: '€', errorText: _hasDepositError ? l10n.priceInvalid : null),
          ),
          const SizedBox(height: 14),
          FilledButton(
            onPressed: _dueOn == null
                ? null
                : () {
                    int? deposit;
                    try {
                      deposit = parsePriceToCents(_deposit.text);
                    } on InvalidPrice {
                      setState(() => _hasDepositError = true);
                      return;
                    }
                    Navigator.of(context).pop((_dueOn!, deposit));
                  },
            child: Text(l10n.save),
          ),
        ],
      ),
    );
  }
}

class PreorderPanel extends StatelessWidget {
  const PreorderPanel({required this.item, required this.manage, super.key});

  final CollectionItem item;
  final ManagePreorder manage;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final preorder = item.preorder;
    if (preorder == null) {
      return Align(
        alignment: Alignment.centerLeft,
        child: TextButton.icon(
          onPressed: () async {
            final answer = await askPreorder(context);
            if (answer != null) {
              await manage.set(item.id, dueOn: answer.$1, depositCents: answer.$2);
            }
          },
          icon: const Icon(Icons.local_shipping_outlined),
          label: Text(l10n.markPreordered),
        ),
      );
    }
    final today = DateTime.now();
    final days = preorder.daysLeftFrom(today);
    return Container(
      margin: const EdgeInsets.only(top: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: AkashicColors.surface, borderRadius: BorderRadius.circular(16), border: Border.all(color: AkashicColors.gold, width: 1.5)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const Icon(Icons.local_shipping_outlined, color: AkashicColors.gold),
              const SizedBox(width: 8),
              Text(l10n.preordered, style: AkashicTypography.body(size: 13, weight: FontWeight.w800).copyWith(color: AkashicColors.gold)),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            days <= 0 ? l10n.preorderToday : l10n.preorderInDays(days),
            style: AkashicTypography.numeral(size: 26).copyWith(color: days <= 0 ? AkashicColors.teal : AkashicColors.text),
          ),
          Text(l10n.preorderDeliveryOn(DateFormat.yMMMMEEEEd(l10n.localeName).format(preorder.dueOn)), style: AkashicTypography.body(size: 13).copyWith(color: AkashicColors.textSoft)),
          if (preorder.depositCents case final deposit?) Text(l10n.preorderDepositPaid(formatEuros(l10n, deposit)), style: AkashicTypography.body(size: 13).copyWith(color: AkashicColors.textSoft)),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              FilledButton.icon(onPressed: () => manage.receive(item.id), icon: const Icon(Icons.check), label: Text(l10n.preorderReceived)),
              OutlinedButton.icon(
                onPressed: () async {
                  final answer = await askPreorder(context, current: preorder);
                  if (answer != null) {
                    await manage.set(item.id, dueOn: answer.$1, depositCents: answer.$2);
                  }
                },
                icon: const Icon(Icons.edit_calendar_outlined),
                label: Text(l10n.preorderChangeDate),
              ),
              TextButton(onPressed: () => manage.cancel(item.id), child: Text(l10n.preorderCancel)),
            ],
          ),
        ],
      ),
    );
  }
}

class PreordersSection extends StatefulWidget {
  const PreordersSection({required this.collection, required this.onOpenItem, super.key});

  final CollectionGateway collection;
  final ValueChanged<String> onOpenItem;

  @override
  State<PreordersSection> createState() => _PreordersSectionState();
}

class _PreordersSectionState extends State<PreordersSection> {
  StreamSubscription<Object?>? _subscription;
  List<CollectionItem> _preorders = const [];

  @override
  void initState() {
    super.initState();
    _subscription = widget.collection.watchOwnedWorks().listen((_) => _refresh());
  }

  Future<void> _refresh() async {
    final preorders = [for (final item in await widget.collection.allItems()) if (item.isPreordered) item]..sort((first, second) => first.preorder!.dueOn.compareTo(second.preorder!.dueOn));
    if (mounted) {
      setState(() => _preorders = preorders);
    }
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_preorders.isEmpty) {
      return const SizedBox.shrink();
    }
    final l10n = AppLocalizations.of(context);
    final today = DateTime.now();
    final deposits = _preorders.fold<int>(0, (total, item) => total + (item.preorder!.depositCents ?? 0));
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 16),
        Row(
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(color: AkashicColors.gold, borderRadius: BorderRadius.circular(6)),
              child: const Icon(Icons.local_shipping_outlined, size: 15, color: AkashicColors.night),
            ),
            const SizedBox(width: 8),
            Expanded(child: Text(l10n.toReceive, style: AkashicTypography.displayTitle(size: 20))),
            Text('${_preorders.length}', style: AkashicTypography.numeral(size: 18)),
          ],
        ),
        if (deposits > 0) Text(l10n.preorderDepositsTotal(formatEuros(l10n, deposits)), style: AkashicTypography.body(size: 12, weight: FontWeight.w600).copyWith(color: AkashicColors.gold)),
        for (final item in _preorders)
          ListTile(
            contentPadding: EdgeInsets.zero,
            onTap: () => widget.onOpenItem(item.id),
            title: Text(resolveDisplayTitle(item.titles, PreferredLanguages.defaults) ?? l10n.untitled, maxLines: 1, overflow: TextOverflow.ellipsis, style: AkashicTypography.body(size: 14, weight: FontWeight.w700)),
            subtitle: Text(DateFormat.yMMMMd(l10n.localeName).format(item.preorder!.dueOn), style: AkashicTypography.body(size: 12).copyWith(color: AkashicColors.textSoft)),
            trailing: Text(
              preorderCountdown(item.preorder!, l10n, today),
              style: AkashicTypography.body(size: 13, weight: FontWeight.w800).copyWith(color: item.preorder!.daysLeftFrom(today) <= 0 ? AkashicColors.teal : AkashicColors.lavender),
            ),
          ),
      ],
    );
  }
}
