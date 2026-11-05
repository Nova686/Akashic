import 'package:akashic/layers/functional/Collection/domain/entities/trade_channel.dart';
import 'package:akashic/layers/functional/Collection/domain/use_cases/parse_price_to_cents.dart';
import 'package:akashic/layers/functional/Collection/presentation/cubit/copy_editor_cubit.dart';
import 'package:akashic/layers/functional/Collection/presentation/cubit/copy_editor_state.dart';
import 'package:akashic/layers/functional/Collection/presentation/widgets/condition_scale.dart';
import 'package:akashic/layers/technical/Localization/app_localizations.dart';
import 'package:akashic/layers/technical/Theme/akashic_colors.dart';
import 'package:akashic/layers/technical/Theme/akashic_typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class CopyEditorSheet extends StatelessWidget {
  const CopyEditorSheet({this.pickPlace, super.key});

  final Future<String?> Function(BuildContext context)? pickPlace;

  Future<void> _confirmDeletion(BuildContext context, {required bool isLastCopy}) async {
    final l10n = AppLocalizations.of(context);
    final editor = context.read<CopyEditorCubit>();
    final isConfirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.deleteLastCopyTitle),
        content: Text(l10n.deleteLastCopyExplanation),
        actions: [
          TextButton(onPressed: () => Navigator.of(dialogContext).pop(false), child: Text(l10n.cancel)),
          FilledButton(onPressed: () => Navigator.of(dialogContext).pop(true), child: Text(l10n.delete)),
        ],
      ),
    );
    if (isConfirmed ?? false) {
      await editor.delete();
    }
  }

  Future<void> _askSale(BuildContext context, {required bool isLastCopy}) async {
    final editor = context.read<CopyEditorCubit>();
    final sale = await showDialog<CopySaleDraft>(context: context, builder: (dialogContext) => _SaleDialog(isLastCopy: isLastCopy));
    if (sale != null) {
      await editor.sell(sale);
    }
  }

  Future<void> _pickPurchaseDate(BuildContext context, DateTime? current) async {
    final editor = context.read<CopyEditorCubit>();
    final now = DateTime.now();
    final picked = await showDatePicker(context: context, initialDate: current ?? now, firstDate: DateTime(1950), lastDate: now);
    if (picked != null) {
      editor.setPurchasedOn(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final editor = context.read<CopyEditorCubit>();
    return BlocConsumer<CopyEditorCubit, CopyEditorState>(
      listenWhen: (previous, current) => previous.status != current.status && (current.status == CopyEditorStatus.saved || current.status == CopyEditorStatus.deleted || current.status == CopyEditorStatus.failed),
      listener: (context, state) => state.status == CopyEditorStatus.failed
          ? ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.saveFailedRetry)))
          : Navigator.of(context).maybePop(state.deletion),
      builder: (context, state) {
        return Padding(
          padding: EdgeInsets.fromLTRB(18, 18, 18, 18 + MediaQuery.viewInsetsOf(context).bottom),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(l10n.editCopy, style: AkashicTypography.displayTitle(size: 24)),
                const SizedBox(height: 12),
                TextFormField(initialValue: state.edition, onChanged: editor.setEdition, decoration: InputDecoration(labelText: l10n.edition)),
                TextFormField(
                  initialValue: state.priceText,
                  onChanged: editor.setPriceText,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  decoration: InputDecoration(labelText: l10n.pricePaid, suffixText: '€', errorText: state.priceError ? l10n.priceInvalid : null),
                ),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.event_outlined),
                  title: Text(l10n.purchaseDate),
                  subtitle: Text(state.purchasedOn == null ? l10n.noDateSet : DateFormat.yMMMd(l10n.localeName).format(state.purchasedOn!)),
                  trailing: state.purchasedOn == null ? null : IconButton(tooltip: l10n.clearPurchaseDate, icon: const Icon(Icons.close), onPressed: () => editor.setPurchasedOn(null)),
                  onTap: () => _pickPurchaseDate(context, state.purchasedOn),
                ),
                Text(l10n.purchaseChannel, style: AkashicTypography.body(size: 13, weight: FontWeight.w700).copyWith(color: AkashicColors.textSoft)),
                const SizedBox(height: 6),
                TradeChannelPicker(selected: state.purchaseChannel, onChanged: editor.setPurchaseChannel),
                _LocationField(initial: state.location, onChanged: editor.setLocation, pickPlace: pickPlace),
                if (state.tracksSealing)
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(l10n.productOpened),
                    subtitle: Text(state.isOpened ? l10n.openedState : l10n.sealedState),
                    value: state.isOpened,
                    onChanged: editor.setOpened,
                  ),
                const SizedBox(height: 16),
                Text(l10n.condition, style: AkashicTypography.body(size: 15, weight: FontWeight.w800)),
                for (final part in state.parts)
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: ConditionScale(part: part, selected: state.conditions[part], onChanged: (condition) => editor.setCondition(part, condition)),
                  ),
                const SizedBox(height: 18),
                FilledButton(onPressed: state.status == CopyEditorStatus.saving ? null : editor.save, child: Text(l10n.save)),
                if (editor.canSell) ...[
                  const SizedBox(height: 8),
                  OutlinedButton.icon(
                    onPressed: state.status == CopyEditorStatus.deleting ? null : () => _askSale(context, isLastCopy: state.isLastCopy),
                    icon: const Icon(Icons.sell_outlined),
                    label: Text(l10n.sellCopy),
                  ),
                ],
                if (editor.canDelete) ...[
                  const SizedBox(height: 8),
                  TextButton.icon(
                    style: TextButton.styleFrom(foregroundColor: AkashicColors.missing),
                    onPressed: state.status == CopyEditorStatus.deleting ? null : () => _confirmDeletion(context, isLastCopy: state.isLastCopy),
                    icon: const Icon(Icons.delete_outline),
                    label: Text(l10n.deleteCopy),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}

class TradeChannelPicker extends StatelessWidget {
  const TradeChannelPicker({required this.selected, required this.onChanged, super.key});

  final TradeChannel? selected;
  final ValueChanged<TradeChannel?> onChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return SegmentedButton<TradeChannel>(
      emptySelectionAllowed: true,
      showSelectedIcon: false,
      segments: [
        ButtonSegment(value: TradeChannel.store, icon: const Icon(Icons.storefront_outlined), label: Text(l10n.channelStore)),
        ButtonSegment(value: TradeChannel.online, icon: const Icon(Icons.language), label: Text(l10n.channelOnline)),
      ],
      selected: {?selected},
      onSelectionChanged: (channels) => onChanged(channels.firstOrNull),
    );
  }
}

class _SaleDialog extends StatefulWidget {
  const _SaleDialog({required this.isLastCopy});

  final bool isLastCopy;

  @override
  State<_SaleDialog> createState() => _SaleDialogState();
}

class _SaleDialogState extends State<_SaleDialog> {
  final TextEditingController _priceController = TextEditingController();
  DateTime _soldOn = DateTime.now();
  TradeChannel? _channel;
  bool _hasPriceError = false;

  @override
  void dispose() {
    _priceController.dispose();
    super.dispose();
  }

  Future<void> _pickSaleDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(context: context, initialDate: _soldOn, firstDate: DateTime(1950), lastDate: now);
    if (picked != null && mounted) {
      setState(() => _soldOn = picked);
    }
  }

  void _confirm() {
    int? priceCents;
    try {
      priceCents = parsePriceToCents(_priceController.text);
    } on InvalidPrice {
      priceCents = null;
    }
    if (priceCents == null) {
      setState(() => _hasPriceError = true);
      return;
    }
    Navigator.of(context).pop<CopySaleDraft>((priceCents: priceCents, soldOn: _soldOn, channel: _channel));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return AlertDialog(
      title: Text(l10n.sellCopy),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(l10n.sellLastCopyExplanation, style: AkashicTypography.body(size: 13).copyWith(color: AkashicColors.textSoft)),
            const SizedBox(height: 12),
            TextField(
              controller: _priceController,
              autofocus: true,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(labelText: l10n.salePrice, suffixText: '€', errorText: _hasPriceError ? l10n.priceInvalid : null),
              onChanged: (_) => _hasPriceError ? setState(() => _hasPriceError = false) : null,
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.event_outlined),
              title: Text(l10n.saleDate),
              subtitle: Text(DateFormat.yMMMd(l10n.localeName).format(_soldOn)),
              onTap: _pickSaleDate,
            ),
            Text(l10n.saleChannel, style: AkashicTypography.body(size: 13, weight: FontWeight.w700).copyWith(color: AkashicColors.textSoft)),
            const SizedBox(height: 6),
            TradeChannelPicker(selected: _channel, onChanged: (channel) => setState(() => _channel = channel)),
          ],
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.of(context).pop(), child: Text(l10n.cancel)),
        FilledButton(onPressed: _confirm, child: Text(l10n.sell)),
      ],
    );
  }
}

class _LocationField extends StatefulWidget {
  const _LocationField({required this.initial, required this.onChanged, this.pickPlace});

  final String initial;
  final ValueChanged<String> onChanged;
  final Future<String?> Function(BuildContext context)? pickPlace;

  @override
  State<_LocationField> createState() => _LocationFieldState();
}

class _LocationFieldState extends State<_LocationField> {
  late final TextEditingController _controller = TextEditingController(text: widget.initial);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final pickPlace = widget.pickPlace;
    return TextField(
      controller: _controller,
      onChanged: widget.onChanged,
      decoration: InputDecoration(
        labelText: l10n.storedAt,
        suffixIcon: pickPlace == null
            ? null
            : IconButton(
                tooltip: l10n.chooseStoragePlace,
                icon: const Icon(Icons.account_tree_outlined),
                onPressed: () async {
                  final path = await pickPlace(context);
                  if (path != null) {
                    _controller.text = path;
                    widget.onChanged(path);
                  }
                },
              ),
      ),
    );
  }
}
