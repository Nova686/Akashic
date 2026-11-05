import 'package:akashic/layers/technical/Theme/safe_bottom_sheet.dart';
import 'package:akashic/layers/functional/Catalog/domain/entities/category.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/collection_item.dart';
import 'package:akashic/layers/functional/Collection/domain/use_cases/move_item.dart';
import 'package:akashic/layers/technical/Localization/app_localizations.dart';
import 'package:akashic/layers/technical/Theme/akashic_colors.dart';
import 'package:akashic/layers/technical/Theme/akashic_typography.dart';
import 'package:flutter/material.dart';

Future<Category?> pickTargetCategory(BuildContext context, {required List<CategoryNode> tree, required String currentCategoryId}) {
  return showSafeBottomSheet<Category>(
    context: context,
    isScrollControlled: true,
    builder: (sheetContext) => FractionallySizedBox(heightFactor: 0.75, child: _CategoryPicker(tree: tree, currentCategoryId: currentCategoryId)),
  );
}

Future<SeriesMove?> askSeriesMove(BuildContext context) {
  final l10n = AppLocalizations.of(context);
  return showDialog<SeriesMove>(
    context: context,
    builder: (dialogContext) => AlertDialog(
      title: Text(l10n.moveSeriesQuestion),
      content: Text(l10n.moveSeriesExplanation),
      actions: [
        TextButton(onPressed: () => Navigator.of(dialogContext).pop(SeriesMove.thisItemOnly), child: Text(l10n.moveThisVolumeOnly)),
        FilledButton(onPressed: () => Navigator.of(dialogContext).pop(SeriesMove.wholeSeries), child: Text(l10n.moveWholeSeries)),
      ],
    ),
  );
}

Future<void> moveItemInteractively(
  BuildContext context, {
  required CollectionItem item,
  required Future<List<CategoryNode>> Function() loadTree,
  required MoveItem moveItem,
}) async {
  final l10n = AppLocalizations.of(context);
  final messenger = ScaffoldMessenger.of(context);
  final tree = await loadTree();
  if (!context.mounted) {
    return;
  }
  final target = await pickTargetCategory(context, tree: tree, currentCategoryId: item.categoryId);
  if (target == null || !context.mounted) {
    return;
  }
  var seriesMove = SeriesMove.thisItemOnly;
  if (item.seriesId != null) {
    final chosen = await askSeriesMove(context);
    if (chosen == null) {
      return;
    }
    seriesMove = chosen;
  } else if (target.id == item.categoryId) {
    return;
  }
  await moveItem(item, targetCategoryId: target.id, seriesMove: seriesMove);
  messenger.showSnackBar(SnackBar(content: Text(l10n.movedInto(target.name))));
}

class _CategoryPicker extends StatelessWidget {
  const _CategoryPicker({required this.tree, required this.currentCategoryId});

  final List<CategoryNode> tree;
  final String currentCategoryId;

  Widget _tile(BuildContext context, Category category, {required bool isChild}) {
    final isCurrent = category.id == currentCategoryId;
    return ListTile(
      contentPadding: EdgeInsets.only(left: isChild ? 32 : 0, right: 8),
      leading: Icon(Icons.circle, size: isChild ? 10 : 14, color: Color(category.colorValue)),
      title: Text(category.name, style: AkashicTypography.body(size: 15, weight: isCurrent ? FontWeight.w700 : FontWeight.w500)),
      trailing: isCurrent ? const Icon(Icons.check, color: AkashicColors.lavender) : null,
      onTap: () => Navigator.of(context).pop(category),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(l10n.moveItem, style: AkashicTypography.displayTitle(size: 24)),
          const SizedBox(height: 8),
          Expanded(
            child: ListView(
              children: [
                for (final node in tree) ...[
                  if (node.children.isEmpty)
                    _tile(context, node.category, isChild: false)
                  else ...[
                    Padding(
                      padding: const EdgeInsets.only(top: 12, bottom: 4),
                      child: Text(node.category.name, style: AkashicTypography.body(size: 13, weight: FontWeight.w800).copyWith(color: AkashicColors.textSoft)),
                    ),
                    for (final child in node.children) _tile(context, child, isChild: true),
                  ],
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
