import 'package:akashic/layers/technical/Theme/safe_bottom_sheet.dart';
import 'package:akashic/layers/functional/Catalog/domain/entities/category.dart';
import 'package:akashic/layers/functional/Catalog/domain/entities/category_type.dart';
import 'package:akashic/layers/functional/Catalog/domain/use_cases/manage_categories.dart';
import 'package:akashic/layers/functional/Catalog/presentation/widgets/card_game_suggestions.dart';
import 'package:akashic/layers/functional/Catalog/presentation/widgets/category_actions.dart';
import 'package:akashic/layers/functional/Collection/presentation/views/shelf_group_view.dart';
import 'package:akashic/layers/functional/Collection/presentation/widgets/empty_shelf_line.dart';
import 'package:akashic/layers/functional/Collection/presentation/widgets/move_item_sheet.dart';
import 'package:akashic/layers/functional/Collection/domain/use_cases/move_item.dart';
import 'package:akashic/layers/functional/Collection/domain/use_cases/bulk_item_actions.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/collection_item.dart';
import 'package:akashic/layers/functional/Collection/presentation/cubit/category_shelves_cubit.dart';
import 'package:akashic/layers/functional/Collection/presentation/cubit/category_shelves_state.dart';
import 'package:akashic/layers/functional/Collection/presentation/widgets/cover_shelf.dart';
import 'package:akashic/layers/functional/Collection/presentation/widgets/shelf_arrangement_sheet.dart';
import 'package:akashic/layers/functional/Collection/domain/use_cases/arrange_shelf.dart';
import 'package:akashic/layers/functional/Collection/presentation/widgets/shelf_header.dart';
import 'package:akashic/layers/technical/Localization/app_localizations.dart';
import 'package:akashic/layers/technical/Theme/akashic_empty_state.dart';
import 'package:akashic/layers/technical/Theme/akashic_colors.dart';
import 'package:akashic/layers/technical/Theme/akashic_typography.dart';
import 'package:akashic/layers/technical/Theme/safe_scroll_padding.dart';
import 'package:akashic/layers/functional/Collection/presentation/widgets/cover_badge.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CategoryShelvesView extends StatelessWidget {
  const CategoryShelvesView({required this.onAddItem, required this.onOpenItem, this.onOpenSeries, this.scansViewBuilder, this.onAddSubcategory, this.manageCategories, this.bulkItemActions, this.loadCategoryTree, this.coverBadges, this.onSaveSmartShelf, super.key});

  final ValueChanged<String> onAddItem;
  final ValueChanged<CollectionItem> onOpenItem;
  final Stream<Map<String, CoverBadge>>? coverBadges;
  final ValueChanged<String>? onOpenSeries;
  final Widget Function(String categoryId)? scansViewBuilder;
  final Future<void> Function(Category parent, String name)? onAddSubcategory;
  final ManageCategories? manageCategories;
  final BulkItemActions? bulkItemActions;
  final Future<List<CategoryNode>> Function()? loadCategoryTree;
  final Future<void> Function(String name, String categoryId, ShelfFilter filter)? onSaveSmartShelf;

  Future<void> _moveSelection(BuildContext context, CategoryShelvesState state, BulkItemActions bulkActions, Future<List<CategoryNode>> Function() loadTree) async {
    final shelvesCubit = context.read<CategoryShelvesCubit>();
    final l10n = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);
    final items = state.selectedItems;
    final tree = await loadTree();
    if (!context.mounted || items.isEmpty) {
      return;
    }
    final target = await pickTargetCategory(context, tree: tree, currentCategoryId: items.first.categoryId);
    if (target == null || !context.mounted) {
      return;
    }
    var seriesMove = SeriesMove.thisItemOnly;
    if (items.any((item) => item.seriesId != null)) {
      final chosen = await askSeriesMove(context);
      if (chosen == null) {
        return;
      }
      seriesMove = chosen;
    }
    await bulkActions.move(items, targetCategoryId: target.id, seriesMove: seriesMove);
    shelvesCubit.clearSelection();
    messenger.showSnackBar(SnackBar(content: Text(l10n.movedInto(target.name))));
  }

  Future<void> _storeSelection(BuildContext context, CategoryShelvesState state, BulkItemActions bulkActions) async {
    final shelvesCubit = context.read<CategoryShelvesCubit>();
    final l10n = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);
    final location = await showDialog<String>(context: context, builder: (dialogContext) => const _LocationDialog());
    if (location == null) {
      return;
    }
    await bulkActions.storeAt(state.selectedItems, location);
    shelvesCubit.clearSelection();
    messenger.showSnackBar(SnackBar(content: Text(l10n.locationApplied)));
  }

  Future<void> _deleteSelection(BuildContext context, CategoryShelvesState state, BulkItemActions bulkActions) async {
    final shelvesCubit = context.read<CategoryShelvesCubit>();
    final l10n = AppLocalizations.of(context);
    final items = state.selectedItems;
    final isConfirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.deleteSelectedItemsTitle(items.length)),
        content: Text(l10n.deleteSelectedItemsExplanation),
        actions: [
          TextButton(onPressed: () => Navigator.of(dialogContext).pop(false), child: Text(l10n.cancel)),
          FilledButton(style: FilledButton.styleFrom(backgroundColor: AkashicColors.missing), onPressed: () => Navigator.of(dialogContext).pop(true), child: Text(l10n.delete)),
        ],
      ),
    );
    if (isConfirmed ?? false) {
      await bulkActions.delete(items);
      shelvesCubit.clearSelection();
    }
  }

  PreferredSizeWidget _selectionBar(BuildContext context, CategoryShelvesState state) {
    final l10n = AppLocalizations.of(context);
    final shelvesCubit = context.read<CategoryShelvesCubit>();
    final bulkActions = bulkItemActions;
    final loadTree = loadCategoryTree;
    return AppBar(
      leading: IconButton(tooltip: l10n.clearSelection, icon: const Icon(Icons.close), onPressed: shelvesCubit.clearSelection),
      title: Text(l10n.selectedItemsCount(state.selectedItemIds.length), style: AkashicTypography.body(size: 18, weight: FontWeight.w700)),
      actions: [
        if (bulkActions != null && loadTree != null)
          IconButton(tooltip: l10n.moveItem, icon: const Icon(Icons.drive_file_move_outline), onPressed: () => _moveSelection(context, state, bulkActions, loadTree)),
        if (bulkActions != null)
          IconButton(tooltip: l10n.setStorageLocation, icon: const Icon(Icons.inventory_2_outlined), onPressed: () => _storeSelection(context, state, bulkActions)),
        if (bulkActions != null)
          IconButton(tooltip: l10n.delete, icon: Icon(Icons.delete_outline, color: AkashicColors.missing), onPressed: () => _deleteSelection(context, state, bulkActions)),
      ],
    );
  }

  Future<void> _run(BuildContext context, CategoryAction action, Category target, {required bool isPageCategory}) async {
    final manage = manageCategories;
    if (manage == null) {
      return;
    }
    final outcome = await runCategoryAction(context, action, target, manage);
    if (outcome == CategoryActionOutcome.deleted && isPageCategory && context.mounted) {
      Navigator.of(context).maybePop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final shelvesCubit = context.read<CategoryShelvesCubit>();
    return BlocBuilder<CategoryShelvesCubit, CategoryShelvesState>(
      builder: (context, state) {
        final category = state.category;
        if (state.isLoading || category == null) {
          return const Scaffold(body: AkashicLoader());
        }
        final visibleShelves = state.visibleShelves;
        final targetCategoryId = state.selectedSubcategoryId ?? (state.hasSubcategories ? null : category.id);
        final hasSeries = visibleShelves.any((shelf) => shelf.seriesIds.isNotEmpty);
        final allCollapsed = hasSeries && visibleShelves.expand((shelf) => shelf.seriesIds).every(state.collapsedSeriesIds.contains);
        final buildScansView = category.type == CategoryType.manga ? scansViewBuilder : null;
        final showsScans = buildScansView != null && state.showsScans;
        return Scaffold(
          appBar: state.isSelecting
              ? _selectionBar(context, state)
              : AppBar(
            title: Text(category.name, style: AkashicTypography.body(size: 18, weight: FontWeight.w700)),
            actions: [
              if (!showsScans)
                IconButton(
                  tooltip: l10n.arrangeShelf,
                  icon: Badge(
                    isLabelVisible: state.isArranged,
                    label: state.filter.activeCount > 0 ? Text('${state.filter.activeCount}') : null,
                    smallSize: 8,
                    backgroundColor: AkashicColors.teal,
                    textColor: AkashicColors.night,
                    child: const Icon(Icons.tune),
                  ),
                  onPressed: () async {
                    final messenger = ScaffoldMessenger.of(context);
                    final arrangement = await pickShelfArrangement(
                      context,
                      sort: state.sort,
                      filter: state.filter,
                      categoryType: category.type,
                      locations: state.knownLocations,
                      tags: state.knownTags,
                      canSaveAsShelf: onSaveSmartShelf != null,
                    );
                    if (arrangement != null) {
                      shelvesCubit.arrange(sort: arrangement.sort, filter: arrangement.filter);
                      if ((onSaveSmartShelf, arrangement.smartShelfName) case (final save?, final name?)) {
                        await save(name, category.id, arrangement.filter);
                        messenger.showSnackBar(SnackBar(content: Text(l10n.smartShelfSaved(name))));
                      }
                    }
                  },
                ),
              if (onAddSubcategory case final addSubcategory? when category.parentId == null)
                IconButton(
                  tooltip: l10n.addSubcategory,
                  icon: const Icon(Icons.create_new_folder_outlined),
                  onPressed: () async {
                    final name = await askSubcategoryName(context, suggestsCardGames: category.type == CategoryType.cards, existingNames: state.shelves.map((shelf) => shelf.category.name));
                    if (name != null) {
                      await addSubcategory(category, name);
                    }
                  },
                ),
              if (manageCategories != null)
                PopupMenuButton<CategoryAction>(
                  tooltip: l10n.categoryActions,
                  onSelected: (action) => _run(context, action, category, isPageCategory: true),
                  itemBuilder: (context) => [
                    for (final action in CategoryAction.values)
                      PopupMenuItem(
                        value: action,
                        child: ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: Icon(categoryActionIcon(action), color: action == CategoryAction.delete ? AkashicColors.missing : null),
                          title: Text(categoryActionLabel(action, l10n)),
                        ),
                      ),
                  ],
                ),
            ],
            bottom: buildScansView == null
                ? null
                : PreferredSize(
                    preferredSize: const Size.fromHeight(52),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(18, 0, 18, 8),
                      child: SegmentedButton<bool>(
                        segments: [
                          ButtonSegment(value: false, label: Text(l10n.physicalTab)),
                          ButtonSegment(value: true, label: Text(l10n.scansTab)),
                        ],
                        selected: {showsScans},
                        onSelectionChanged: (selection) => shelvesCubit.showScans(selection.first),
                      ),
                    ),
                  ),
          ),
          floatingActionButton: showsScans || state.isSelecting
              ? null
              : FloatingActionButton(
                  tooltip: l10n.addItem,
                  onPressed: () async {
                    final target = targetCategoryId ?? await _pickSubcategory(context, [for (final shelf in visibleShelves) shelf.category]);
                    if (target != null) {
                      onAddItem(target);
                    }
                  },
                  child: const Icon(Icons.add),
                ),
          body: showsScans
              ? buildScansView(category.id)
              : ListView(
                  padding: safeListPadding(context, bottom: 96),
                  children: [
                    if (state.isArranged)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Row(
                          children: [
                            Icon(Icons.tune, size: 16, color: AkashicColors.teal),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                [if (state.sort != ShelfSort.bySeries) shelfSortLabel(state.sort, l10n), ...shelfFilterLabels(state.filter, l10n, category.type)].join(' · '),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: AkashicTypography.body(size: 12, weight: FontWeight.w600).copyWith(color: AkashicColors.textSoft),
                              ),
                            ),
                            IconButton(
                              tooltip: l10n.clearArrangement,
                              icon: const Icon(Icons.close, size: 18),
                              onPressed: () => shelvesCubit.arrange(sort: ShelfSort.bySeries, filter: const ShelfFilter()),
                            ),
                          ],
                        ),
                      ),
                    if (state.hasSubcategories)
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            _FilterChip(label: l10n.allSubcategories, count: state.totalItems, selected: state.selectedSubcategoryId == null, onTap: () => shelvesCubit.selectSubcategory(null)),
                            for (final shelf in state.shelves)
                              _FilterChip(
                                label: shelf.category.name,
                                count: shelf.itemCount,
                                selected: state.selectedSubcategoryId == shelf.category.id,
                                onTap: () => shelvesCubit.selectSubcategory(shelf.category.id),
                                onLongPress: manageCategories == null
                                    ? null
                                    : () async {
                                        final action = await pickCategoryAction(context, shelf.category);
                                        if (action != null && context.mounted) {
                                          await _run(context, action, shelf.category, isPageCategory: false);
                                        }
                                      },
                              ),
                          ],
                        ),
                      ),
                    if (hasSeries)
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () => shelvesCubit.setAllSeriesCollapsed(!allCollapsed),
                          child: Text(
                            allCollapsed ? l10n.unfoldAll : l10n.foldAll,
                            style: AkashicTypography.body(size: 12, weight: FontWeight.w600).copyWith(color: AkashicColors.teal),
                          ),
                        ),
                      ),
                    for (final shelf in visibleShelves) ...[
                      const SizedBox(height: 14),
                      if (state.hasSubcategories) ShelfHeader(name: shelf.category.name, colorValue: shelf.category.colorValue, itemCount: shelf.itemCount),
                      if (shelf.groups.isEmpty)
                        _EmptyShelf(isCompact: state.hasSubcategories, onAdd: () => onAddItem(shelf.category.id))
                      else if (state.isArranged && state.groupsOf(shelf).every((group) => group.entries.isEmpty))
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          child: Text(l10n.noItemMatchesArrangement, style: AkashicTypography.body(size: 13).copyWith(color: AkashicColors.textSoft)),
                        )
                      else
                        StreamBuilder<Map<String, CoverBadge>>(
                          stream: coverBadges,
                          builder: (context, badges) => CoverShelf(
                          badgesByItem: badges.data ?? const {},
                          groups: state.groupsOf(shelf),
                          preferredLanguages: state.preferredLanguages,
                          categoryColorValue: shelf.category.colorValue,
                          collapsedSeriesIds: state.collapsedSeriesIds,
                          onOpenItem: (item) => state.isSelecting ? shelvesCubit.toggleSelection(item.id) : onOpenItem(item),
                          selectedItemIds: state.selectedItemIds,
                          onLongPressItem: bulkItemActions == null ? null : (item) => shelvesCubit.toggleSelection(item.id),
                          onToggleSeries: shelvesCubit.toggleSeries,
                          onOpenSeries: onOpenSeries,
                          onSeeAllGroup: (group) => Navigator.of(context).push(MaterialPageRoute<void>(
                            builder: (_) => BlocProvider.value(
                              value: shelvesCubit,
                              child: ShelfGroupView(groupId: group.id, onOpenItem: onOpenItem, onOpenSeries: onOpenSeries),
                            ),
                          )),
                          ),
                        ),
                    ],
                  ],
                ),
        );
      },
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({required this.label, required this.count, required this.selected, required this.onTap, this.onLongPress});

  final String label;
  final int count;
  final bool selected;
  final VoidCallback onTap;
  final VoidCallback? onLongPress;

  @override
  Widget build(BuildContext context) {
    final foreground = selected ? AkashicColors.night : AkashicColors.text;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: GestureDetector(
        onLongPress: onLongPress,
        child: ChoiceChip(
          selected: selected,
          onSelected: (_) => onTap(),
          showCheckmark: false,
          selectedColor: AkashicColors.lavender,
          label: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                label,
                style: AkashicTypography.body(size: 13, weight: FontWeight.w600).copyWith(color: foreground),
              ),
              const SizedBox(width: 6),
              Text('$count', style: AkashicTypography.numeral(size: 12).copyWith(color: foreground.withValues(alpha: 0.75))),
            ],
          ),
        ),
      ),
    );
  }
}

Future<String?> _pickSubcategory(BuildContext context, List<Category> subcategories) {
  if (subcategories.length == 1) {
    return Future.value(subcategories.single.id);
  }
  final l10n = AppLocalizations.of(context);
  return showSafeBottomSheet<String>(
    context: context,
    builder: (sheetContext) => Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(18, 18, 18, 8),
          child: Text(l10n.addToWhichSubcategory, style: AkashicTypography.displayTitle(size: 22)),
        ),
        Flexible(
          child: ListView(
            shrinkWrap: true,
            children: [
              for (final subcategory in subcategories)
                ListTile(
                  leading: Icon(Icons.circle, size: 14, color: Color(subcategory.colorValue)),
                  title: Text(subcategory.name),
                  onTap: () => Navigator.of(sheetContext).pop(subcategory.id),
                ),
            ],
          ),
        ),
      ],
    ),
  );
}

class _EmptyShelf extends StatelessWidget {
  const _EmptyShelf({required this.isCompact, required this.onAdd});

  final bool isCompact;
  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    if (isCompact) {
      return EmptyShelfLine(message: l10n.emptyShelf, actionLabel: l10n.addItemShort, onAction: onAdd);
    }
    return AkashicEmptyState(
      message: l10n.emptyShelf,
      action: OutlinedButton.icon(onPressed: onAdd, icon: const Icon(Icons.add), label: Text(l10n.addFirstItem)),
    );
  }
}

class _LocationDialog extends StatefulWidget {
  const _LocationDialog();

  @override
  State<_LocationDialog> createState() => _LocationDialogState();
}

class _LocationDialogState extends State<_LocationDialog> {
  final TextEditingController _locationController = TextEditingController();

  @override
  void dispose() {
    _locationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return AlertDialog(
      title: Text(l10n.setStorageLocation),
      content: TextField(
        controller: _locationController,
        autofocus: true,
        decoration: InputDecoration(labelText: l10n.storedAt),
        onSubmitted: (location) => Navigator.of(context).pop(location),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.of(context).pop(), child: Text(l10n.cancel)),
        FilledButton(onPressed: () => Navigator.of(context).pop(_locationController.text), child: Text(l10n.save)),
      ],
    );
  }
}
