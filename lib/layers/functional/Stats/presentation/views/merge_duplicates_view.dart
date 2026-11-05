import 'dart:io';

import 'package:akashic/layers/functional/Collection/domain/entities/collection_item.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/item_copy.dart';
import 'package:akashic/layers/functional/Collection/domain/use_cases/merge_items.dart';
import 'package:akashic/layers/functional/Collection/domain/use_cases/resolve_display_title.dart';
import 'package:akashic/layers/functional/Settings/domain/entities/preferred_languages.dart';
import 'package:akashic/layers/functional/Stats/presentation/views/stats_view.dart';
import 'package:akashic/layers/technical/Localization/app_localizations.dart';
import 'package:akashic/layers/technical/Theme/akashic_colors.dart';
import 'package:akashic/layers/technical/Theme/akashic_typography.dart';
import 'package:akashic/layers/technical/Theme/safe_scroll_padding.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MergeDuplicatesView extends StatefulWidget {
  const MergeDuplicatesView({required this.first, required this.second, required this.loadCopy, required this.merge, super.key});

  final CollectionItem first;
  final CollectionItem second;
  final Future<ItemCopy?> Function(String itemId) loadCopy;
  final Future<void> Function(MergePlan plan) merge;

  @override
  State<MergeDuplicatesView> createState() => _MergeDuplicatesViewState();
}

class _MergeDuplicatesViewState extends State<MergeDuplicatesView> {
  MergePlan _plan = const MergePlan();
  late final Future<(ItemCopy?, ItemCopy?)> _copies = Future.wait([widget.loadCopy(widget.first.id), widget.loadCopy(widget.second.id)]).then((copies) => (copies[0], copies[1]));
  bool _isMerging = false;

  String _title(CollectionItem item, AppLocalizations l10n) {
    final title = resolveDisplayTitle(item.titles, PreferredLanguages.defaults) ?? l10n.untitled;
    return [item.volumeNumber == null ? title : '$title ${item.volumeNumber}', ?item.creator, if (item.year case final year?) '$year'].join(' · ');
  }

  String? _purchase(ItemCopy? copy, AppLocalizations l10n) {
    if (copy == null) {
      return null;
    }
    final parts = [
      if (copy.pricePaidCents case final cents?) formatEuros(l10n, cents),
      if (copy.purchasedOn case final date?) DateFormat.yMMMd(l10n.localeName).format(date),
      if (copy.location?.trim() case final location? when location.isNotEmpty) location,
    ];
    return parts.isEmpty ? null : parts.join(' · ');
  }

  String? _valueOf(MergeField field, CollectionItem item, ItemCopy? copy, AppLocalizations l10n) => switch (field) {
        MergeField.identity => _title(item, l10n),
        MergeField.cover => item.imagePath == null ? null : l10n.mergeHasCover,
        MergeField.purchase => _purchase(copy, l10n),
        MergeField.rating => item.rating == null || item.rating == 0 ? null : '★' * item.rating!,
        MergeField.progress => item.progress == null ? null : l10n.mergeHasProgress,
      };

  String _fieldLabel(MergeField field, AppLocalizations l10n) => switch (field) {
        MergeField.identity => l10n.mergeFieldTitle,
        MergeField.cover => l10n.mergeFieldCover,
        MergeField.purchase => l10n.mergeFieldPurchase,
        MergeField.rating => l10n.mergeFieldRating,
        MergeField.progress => l10n.mergeFieldProgress,
      };

  Future<void> _confirm(AppLocalizations l10n) async {
    final isConfirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.mergeConfirmTitle),
        content: Text(l10n.mergeConfirmBody),
        actions: [
          TextButton(onPressed: () => Navigator.of(dialogContext).pop(false), child: Text(l10n.cancel)),
          FilledButton(onPressed: () => Navigator.of(dialogContext).pop(true), child: Text(l10n.mergeAction)),
        ],
      ),
    );
    if (isConfirmed != true || !mounted) {
      return;
    }
    setState(() => _isMerging = true);
    final navigator = Navigator.of(context);
    final messenger = ScaffoldMessenger.of(context);
    await widget.merge(_plan);
    messenger.showSnackBar(SnackBar(content: Text(l10n.mergeDone)));
    navigator.pop();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.mergeTitle, style: AkashicTypography.body(size: 18, weight: FontWeight.w700))),
      body: FutureBuilder<(ItemCopy?, ItemCopy?)>(
        future: _copies,
        builder: (context, snapshot) {
          final (firstCopy, secondCopy) = snapshot.data ?? (null, null);
          return ListView(
            padding: safeListPadding(context, bottom: 100),
            children: [
              Row(
                children: [
                  for (final (index, item) in [widget.first, widget.second].indexed)
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(right: index == 0 ? 8 : 0, left: index == 1 ? 8 : 0),
                        child: Column(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: SizedBox(
                                width: 90,
                                height: 126,
                                child: item.imagePath == null
                                    ? ColoredBox(color: AkashicColors.surface, child: Center(child: Text(index == 0 ? 'A' : 'B', style: AkashicTypography.displayTitle(size: 30))))
                                    : Image.file(File(item.imagePath!), fit: BoxFit.cover, cacheWidth: 270, errorBuilder: (context, error, stack) => ColoredBox(color: AkashicColors.surface)),
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text('${index == 0 ? 'A' : 'B'} · ${_title(item, l10n)}', textAlign: TextAlign.center, maxLines: 3, overflow: TextOverflow.ellipsis, style: AkashicTypography.body(size: 13, weight: FontWeight.w700)),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 14),
              Text(l10n.mergeKeepWhat, style: AkashicTypography.body(size: 13).copyWith(color: AkashicColors.textSoft)),
              for (final field in MergeField.values) ...[
                const SizedBox(height: 12),
                Text(_fieldLabel(field, l10n).toUpperCase(), style: AkashicTypography.body(size: 11, weight: FontWeight.w800).copyWith(color: AkashicColors.textSoft, letterSpacing: 1.1)),
                const SizedBox(height: 4),
                RadioGroup<MergeSide>(
                  groupValue: _plan.sideOf(field),
                  onChanged: (chosen) => setState(() => _plan = _plan.choose(field, chosen!)),
                  child: Column(
                    children: [
                      for (final (side, item, copy) in [(MergeSide.first, widget.first, firstCopy), (MergeSide.second, widget.second, secondCopy)])
                        RadioListTile<MergeSide>(
                          contentPadding: EdgeInsets.zero,
                          value: side,
                          title: Text('${side == MergeSide.first ? 'A' : 'B'} · ${_valueOf(field, item, copy, l10n) ?? l10n.mergeEmpty}',
                              style: AkashicTypography.body(size: 14, weight: FontWeight.w600).copyWith(fontStyle: _valueOf(field, item, copy, l10n) == null ? FontStyle.italic : null)),
                        ),
                    ],
                  ),
                ),
              ],
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                value: _plan.joinsPhotos,
                onChanged: (joins) => setState(() => _plan = _plan.withPhotos(joins)),
                title: Text(l10n.mergeJoinPhotos, style: AkashicTypography.body(weight: FontWeight.w700)),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(color: AkashicColors.surface, borderRadius: BorderRadius.circular(14), border: Border.all(color: AkashicColors.teal, width: 1.5)),
                child: Text(l10n.mergeResult(_title(mergedItem(widget.first, widget.second, _plan), l10n)), style: AkashicTypography.body(size: 14, weight: FontWeight.w700)),
              ),
            ],
          );
        },
      ),
      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.fromLTRB(16, 0, 16, 12),
        child: FilledButton.icon(onPressed: _isMerging ? null : () => _confirm(l10n), icon: const Icon(Icons.merge), label: Text(l10n.mergeAction)),
      ),
    );
  }
}
