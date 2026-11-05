import 'package:akashic/layers/technical/Theme/safe_bottom_sheet.dart';
import 'package:akashic/layers/functional/Catalog/domain/entities/category.dart';
import 'package:akashic/layers/functional/Catalog/domain/use_cases/manage_categories.dart';
import 'package:akashic/layers/functional/Catalog/presentation/views/category_edit_page.dart';
import 'package:akashic/layers/technical/Localization/app_localizations.dart';
import 'package:akashic/layers/technical/Theme/akashic_colors.dart';
import 'package:akashic/layers/technical/Theme/akashic_typography.dart';
import 'package:flutter/material.dart';

enum CategoryAction { edit, reorder, delete }

enum CategoryActionOutcome { unchanged, changed, deleted }

Future<CategoryActionOutcome> runCategoryAction(BuildContext context, CategoryAction action, Category category, ManageCategories manageCategories) async {
  switch (action) {
    case CategoryAction.edit:
      return _editCategory(context, category, manageCategories);
    case CategoryAction.reorder:
      return await _reorderCategories(context, category, manageCategories) ? CategoryActionOutcome.changed : CategoryActionOutcome.unchanged;
    case CategoryAction.delete:
      return await _deleteCategory(context, category, manageCategories) ? CategoryActionOutcome.deleted : CategoryActionOutcome.unchanged;
  }
}

Future<CategoryAction?> pickCategoryAction(BuildContext context, Category category) {
  final l10n = AppLocalizations.of(context);
  return showSafeBottomSheet<CategoryAction>(
    context: context,
    builder: (sheetContext) => SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(title: Text(category.name, style: AkashicTypography.body(size: 16, weight: FontWeight.w700))),
          for (final action in CategoryAction.values)
            ListTile(
              leading: Icon(categoryActionIcon(action), color: action == CategoryAction.delete ? AkashicColors.missing : null),
              title: Text(categoryActionLabel(action, l10n)),
              onTap: () => Navigator.of(sheetContext).pop(action),
            ),
        ],
      ),
    ),
  );
}

IconData categoryActionIcon(CategoryAction action) => switch (action) {
      CategoryAction.edit => Icons.edit_outlined,
      CategoryAction.reorder => Icons.swap_vert,
      CategoryAction.delete => Icons.delete_outline,
    };

String categoryActionLabel(CategoryAction action, AppLocalizations l10n) => switch (action) {
      CategoryAction.edit => l10n.editCategory,
      CategoryAction.reorder => l10n.reorderCategories,
      CategoryAction.delete => l10n.deleteCategory,
    };

Future<CategoryActionOutcome> _editCategory(BuildContext context, Category category, ManageCategories manageCategories) async {
  final result = await Navigator.of(context).push<CategoryEditResult>(MaterialPageRoute(
    fullscreenDialog: true,
    builder: (_) => CategoryEditPage(
      category: category,
      manageCategories: manageCategories,
      confirmDeletion: (pageContext) => _deleteCategory(pageContext, category, manageCategories),
    ),
  ));
  return switch (result) {
    CategoryEditResult.saved => CategoryActionOutcome.changed,
    CategoryEditResult.deleted => CategoryActionOutcome.deleted,
    null => CategoryActionOutcome.unchanged,
  };
}

Future<bool> _reorderCategories(BuildContext context, Category category, ManageCategories manageCategories) async {
  final siblings = await manageCategories.siblingsOf(category);
  if (!context.mounted || siblings.length < 2) {
    return false;
  }
  final ordered = await showSafeBottomSheet<List<Category>>(
    context: context,
    isScrollControlled: true,
    builder: (sheetContext) => FractionallySizedBox(heightFactor: 0.7, child: _CategoryOrderSheet(categories: siblings)),
  );
  if (ordered == null) {
    return false;
  }
  await manageCategories.reorder(ordered);
  return true;
}

Future<bool> _deleteCategory(BuildContext context, Category category, ManageCategories manageCategories) async {
  final l10n = AppLocalizations.of(context);
  final contents = await manageCategories.contentsOf(category);
  if (!context.mounted) {
    return false;
  }
  final isConfirmed = await showDialog<bool>(
    context: context,
    builder: (dialogContext) => AlertDialog(
      title: Text(l10n.deleteCategoryTitle(category.name)),
      content: Text(contents.isEmpty
          ? l10n.deleteEmptyCategoryExplanation
          : l10n.deleteCategoryExplanation(contents.itemCount, contents.seriesCount, contents.subcategoryCount)),
      actions: [
        TextButton(onPressed: () => Navigator.of(dialogContext).pop(false), child: Text(l10n.cancel)),
        FilledButton(
          style: FilledButton.styleFrom(backgroundColor: AkashicColors.missing),
          onPressed: () => Navigator.of(dialogContext).pop(true),
          child: Text(l10n.delete),
        ),
      ],
    ),
  );
  if (!(isConfirmed ?? false)) {
    return false;
  }
  await manageCategories.delete(category);
  return true;
}

class _CategoryOrderSheet extends StatefulWidget {
  const _CategoryOrderSheet({required this.categories});

  final List<Category> categories;

  @override
  State<_CategoryOrderSheet> createState() => _CategoryOrderSheetState();
}

class _CategoryOrderSheetState extends State<_CategoryOrderSheet> {
  late final List<Category> _ordered = [...widget.categories];

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(l10n.reorderCategories, style: AkashicTypography.displayTitle(size: 24)),
          const SizedBox(height: 8),
          Expanded(
            child: ReorderableListView(
              buildDefaultDragHandles: false,
              onReorderItem: (oldIndex, newIndex) => setState(() => _ordered.insert(newIndex, _ordered.removeAt(oldIndex))),
              children: [
                for (final (index, category) in _ordered.indexed)
                  ListTile(
                    key: ValueKey(category.id),
                    contentPadding: EdgeInsets.zero,
                    leading: Icon(Icons.circle, size: 14, color: Color(category.colorValue)),
                    title: Text(category.name),
                    trailing: ReorderableDragStartListener(index: index, child: Icon(Icons.drag_indicator, color: AkashicColors.textFaint)),
                  ),
              ],
            ),
          ),
          FilledButton(onPressed: () => Navigator.of(context).pop(_ordered), child: Text(l10n.save)),
        ],
      ),
    );
  }
}
