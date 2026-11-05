import 'dart:io';

import 'package:akashic/layers/technical/AppShell/tour_targets.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/collection_item.dart';
import 'package:akashic/layers/functional/Collection/domain/use_cases/resolve_display_title.dart';
import 'package:akashic/layers/functional/Collection/presentation/cubit/home_shelves_cubit.dart';
import 'package:akashic/layers/functional/Collection/presentation/cubit/home_shelves_state.dart';
import 'package:akashic/layers/functional/Collection/presentation/widgets/empty_shelf_line.dart';
import 'package:akashic/layers/functional/Collection/presentation/widgets/item_spine.dart';
import 'package:akashic/layers/functional/Collection/presentation/widgets/shelf_header.dart';
import 'package:akashic/layers/functional/Collection/presentation/widgets/shelf_row.dart';
import 'package:akashic/layers/technical/Localization/app_localizations.dart';
import 'package:akashic/layers/technical/Theme/akashic_empty_state.dart';
import 'package:akashic/layers/technical/Theme/akashic_colors.dart';
import 'package:akashic/layers/technical/Theme/akashic_typography.dart';
import 'package:akashic/layers/technical/Theme/safe_scroll_padding.dart';
import 'package:akashic/layers/technical/HttpAccess/offline_pill.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeShelvesView extends StatelessWidget {
  const HomeShelvesView({
    required this.onOpenCategory,
    required this.onCreateCategory,
    required this.onOpenSettings,
    required this.onOpenItem,
    this.onOpenLoans,
    this.onOpenStats,
    this.onOpenMissingVolumes,
    this.onOpenScanHistory,
    this.onOpenTonight,
    this.onOpenGoals,
    this.onOpenRecap,
    this.goalsStrip,
    this.onOpenJournal,
    this.onOpenStoragePlan,
    this.onOpenWhereIs,
    this.smartShelvesSection,
    this.onOpenBudget,
    this.onOpenInsurance,
    this.listenVoice,
    this.onOpenCompare,
    this.onOpenMissingCovers,
    this.preordersSection,
    this.isOffline,
    this.onCheck,
    this.onSearchOnline,
    super.key,
  });

  final ValueChanged<String> onOpenCategory;
  final VoidCallback onCreateCategory;
  final VoidCallback onOpenSettings;
  final ValueChanged<CollectionItem> onOpenItem;
  final VoidCallback? onOpenLoans;
  final VoidCallback? onOpenStats;
  final VoidCallback? onOpenMissingVolumes;
  final VoidCallback? onOpenScanHistory;
  final VoidCallback? onOpenTonight;
  final VoidCallback? onOpenGoals;
  final VoidCallback? onOpenRecap;
  final Widget? goalsStrip;
  final VoidCallback? onOpenJournal;
  final VoidCallback? onOpenStoragePlan;
  final VoidCallback? onOpenWhereIs;
  final Widget? smartShelvesSection;
  final VoidCallback? onOpenBudget;
  final VoidCallback? onOpenInsurance;
  final Future<String?> Function(BuildContext context)? listenVoice;
  final VoidCallback? onOpenCompare;
  final VoidCallback? onOpenMissingCovers;
  final Widget? preordersSection;
  final Stream<bool>? isOffline;
  final VoidCallback? onCheck;
  final void Function(String query, String? categoryId)? onSearchOnline;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final home = context.read<HomeShelvesCubit>();
    return BlocBuilder<HomeShelvesCubit, HomeShelvesState>(
      builder: (context, state) {
        return Scaffold(
          floatingActionButton: switch (onCheck) {
            final check? => FloatingActionButton(
              key: TourTargets.scanButton,
              onPressed: check,
              tooltip: l10n.navCheck,
              backgroundColor: AkashicColors.lavender,
              foregroundColor: AkashicColors.night,
              child: const Icon(Icons.qr_code_scanner),
            ),
            null => null,
          },
          body: SafeArea(
            child: ListView(
              padding: safeListPadding(context, top: 14),
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(l10n.myCollection, style: AkashicTypography.displayTitle(size: 36)),
                          const SizedBox(height: 6),
                          Wrap(
                            crossAxisAlignment: WrapCrossAlignment.center,
                            spacing: 8,
                            children: [
                              Text(l10n.objectsInCategories(state.totalItems, state.categoryCount), style: AkashicTypography.body(size: 12).copyWith(color: AkashicColors.textSoft)),
                              if (isOffline case final offline?) OfflinePill(isOffline: offline),
                            ],
                          ),
                        ],
                      ),
                    ),
                    PopupMenuButton<VoidCallback>(
                      key: TourTargets.menu,
                      tooltip: l10n.settings,
                      icon: const Icon(Icons.more_vert),
                      onSelected: (open) => open(),
                      itemBuilder: (menuContext) => [
                        if (onOpenTonight case final openTonight?) PopupMenuItem(value: openTonight, child: Text(l10n.tonightMenu)),
                        if (onOpenGoals case final openGoals?) PopupMenuItem(value: openGoals, child: Text(l10n.goalsMenu)),
                        if (onOpenRecap case final openRecap?) PopupMenuItem(value: openRecap, child: Text(l10n.monthlyRecap)),
                        if (onOpenWhereIs case final openWhereIs?) PopupMenuItem(value: openWhereIs, child: Text(l10n.whereIs)),
                        if (onOpenStoragePlan case final openStoragePlan?) PopupMenuItem(value: openStoragePlan, child: Text(l10n.storagePlan)),
                        if (onOpenJournal case final openJournal?) PopupMenuItem(value: openJournal, child: Text(l10n.journal)),
                        if (onOpenLoans case final openLoans?) PopupMenuItem(value: openLoans, child: Text(l10n.loans)),
                        if (onOpenBudget case final openBudget?) PopupMenuItem(value: openBudget, child: Text(l10n.budget)),
                        if (onOpenInsurance case final openInsurance?) PopupMenuItem(value: openInsurance, child: Text(l10n.insuranceInventory)),
                        if (onOpenCompare case final openCompare?) PopupMenuItem(value: openCompare, child: Text(l10n.compareTitle)),
                        if (onOpenMissingCovers case final openMissingCovers?) PopupMenuItem(value: openMissingCovers, child: Text(l10n.missingCovers)),
                        if (onOpenStats case final openStats?) PopupMenuItem(value: openStats, child: Text(l10n.statistics)),
                        if (onOpenMissingVolumes case final openMissingVolumes?) PopupMenuItem(value: openMissingVolumes, child: Text(l10n.missingVolumesTitle)),
                        if (onOpenScanHistory case final openScanHistory?) PopupMenuItem(value: openScanHistory, child: Text(l10n.scanHistory)),
                        PopupMenuItem(value: onOpenSettings, child: Text(l10n.settings)),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _HomeSearchField(query: state.searchQuery, recentSearches: state.recentSearches, onChanged: home.search, onForget: home.forgetSearch, listenVoice: listenVoice),
                if (goalsStrip case final strip? when state.searchQuery.trim().isEmpty) strip,
                if (preordersSection case final preorders? when state.searchQuery.trim().isEmpty) preorders,
                if (smartShelvesSection case final smartShelves? when state.searchQuery.trim().isEmpty) smartShelves,
                if (state.searchQuery.trim().isNotEmpty)
                  _SearchResults(
                    state: state,
                    onOpenItem: (item) {
                      home.rememberSearch();
                      onOpenItem(item);
                    },
                    onFilter: home.filterSearch,
                    onSearchOnline: switch (onSearchOnline) {
                      final searchOnline? => () => searchOnline(state.searchQuery.trim(), state.searchCategoryId ?? state.shelves.firstOrNull?.node.category.id),
                      null => null,
                    },
                  )
                else if (!state.isLoading && state.shelves.isEmpty)
                  AkashicEmptyState(message: l10n.emptyCollection, animationSize: 140)
                else
                  for (final shelf in state.shelves)
                    Padding(
                      padding: const EdgeInsets.only(top: 16),
                      child: Semantics(
                        button: true,
                        label: [shelf.node.category.name, l10n.groupItemCount(shelf.node.itemCount), if (shelf.incompleteSeriesCount > 0) l10n.seriesToComplete(shelf.incompleteSeriesCount)].join(', '),
                        excludeSemantics: true,
                        onTap: () => onOpenCategory(shelf.node.category.id),
                        child: GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: () => onOpenCategory(shelf.node.category.id),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              ShelfHeader(
                                name: shelf.node.category.name,
                                colorValue: shelf.node.category.colorValue,
                                itemCount: shelf.node.itemCount,
                                highlight: shelf.incompleteSeriesCount > 0 ? l10n.seriesToComplete(shelf.incompleteSeriesCount) : null,
                                onTap: () => onOpenCategory(shelf.node.category.id),
                              ),
                              if (shelf.groups.isEmpty)
                                EmptyShelfLine(message: l10n.emptyShelf)
                              else
                                ShelfRow(
                                  groups: shelf.groups,
                                  type: shelf.node.category.type,
                                  size: SpineSize.compact,
                                  categoryColorValue: shelf.node.category.colorValue,
                                  collapsedSeriesIds: state.collapsedSeriesIds,
                                  onToggleSeries: (_) => onOpenCategory(shelf.node.category.id),
                                  onOpenItem: (_) => onOpenCategory(shelf.node.category.id),
                                  preferredLanguages: state.preferredLanguages,
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                ListTile(
                  key: TourTargets.newCategory,
                  contentPadding: EdgeInsets.zero,
                  leading: Icon(Icons.add, color: AkashicColors.textSoft),
                  title: Text(
                    l10n.newCategory,
                    style: AkashicTypography.body(weight: FontWeight.w600).copyWith(color: AkashicColors.textSoft),
                  ),
                  onTap: onCreateCategory,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _HomeSearchField extends StatefulWidget {
  const _HomeSearchField({required this.query, required this.recentSearches, required this.onChanged, required this.onForget, this.listenVoice});

  final String query;
  final List<String> recentSearches;
  final ValueChanged<String> onChanged;
  final ValueChanged<String> onForget;
  final Future<String?> Function(BuildContext context)? listenVoice;

  @override
  State<_HomeSearchField> createState() => _HomeSearchFieldState();
}

class _HomeSearchFieldState extends State<_HomeSearchField> {
  late final TextEditingController _controller = TextEditingController(text: widget.query);
  final FocusNode _focus = FocusNode();

  @override
  void initState() {
    super.initState();
    _focus.addListener(() => setState(() {}));
  }

  @override
  void didUpdateWidget(_HomeSearchField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.query != _controller.text) {
      _controller.text = widget.query;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _focus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final showsRecent = _focus.hasFocus && widget.query.trim().isEmpty && widget.recentSearches.isNotEmpty;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextField(
          key: TourTargets.search,
          controller: _controller,
          focusNode: _focus,
          onChanged: widget.onChanged,
          textInputAction: TextInputAction.search,
          decoration: InputDecoration(
            hintText: l10n.searchCollection,
            prefixIcon: const Icon(Icons.search),
            suffixIcon: switch ((widget.query.isEmpty, widget.listenVoice)) {
              (false, _) => IconButton(tooltip: l10n.close, icon: const Icon(Icons.close), onPressed: () => widget.onChanged('')),
              (true, final listen?) => IconButton(
                  tooltip: l10n.voiceSearch,
                  icon: const Icon(Icons.mic_none),
                  onPressed: () async {
                    final words = await listen(context);
                    if (words != null && words.isNotEmpty) {
                      _controller.text = words;
                      widget.onChanged(words);
                    }
                  },
                ),
              _ => null,
            },
            filled: true,
            fillColor: AkashicColors.surface,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(24), borderSide: BorderSide.none),
          ),
        ),
        if (showsRecent) ...[
          Padding(
            padding: const EdgeInsets.fromLTRB(4, 14, 4, 4),
            child: Text(l10n.recentSearches.toUpperCase(), style: AkashicTypography.body(size: 11, weight: FontWeight.w700).copyWith(color: AkashicColors.textSoft, letterSpacing: 1.1)),
          ),
          for (final recent in widget.recentSearches)
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Icon(Icons.history, color: AkashicColors.textSoft),
              title: Text(recent),
              trailing: IconButton(tooltip: l10n.forgetSearch, icon: const Icon(Icons.close, size: 18), onPressed: () => widget.onForget(recent)),
              onTap: () => widget.onChanged(recent),
            ),
        ],
      ],
    );
  }
}

class _SearchResults extends StatelessWidget {
  const _SearchResults({required this.state, required this.onOpenItem, required this.onFilter, this.onSearchOnline});

  final HomeShelvesState state;
  final ValueChanged<CollectionItem> onOpenItem;
  final ValueChanged<String?> onFilter;
  final VoidCallback? onSearchOnline;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    if (state.searchResults.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 24),
        child: Column(
          children: [
            Text(l10n.noSearchResults, textAlign: TextAlign.center, style: AkashicTypography.body().copyWith(color: AkashicColors.textSoft)),
            if (onSearchOnline case final searchOnline?) ...[
              const SizedBox(height: 12),
              FilledButton.tonalIcon(onPressed: searchOnline, icon: const Icon(Icons.public), label: Text(l10n.searchOnlineAction)),
            ],
          ],
        ),
      );
    }
    final counts = state.searchCategoryCounts;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (counts.length > 1)
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.only(top: 12),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(label: Text('${l10n.allTypes} · ${state.searchResults.length}'), selected: state.searchCategoryId == null, onSelected: (_) => onFilter(null)),
                ),
                for (final (category, count) in counts)
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      avatar: CircleAvatar(radius: 5, backgroundColor: Color(category.colorValue)),
                      label: Text('${category.name} · $count'),
                      selected: state.searchCategoryId == category.id,
                      onSelected: (_) => onFilter(state.searchCategoryId == category.id ? null : category.id),
                    ),
                  ),
              ],
            ),
          ),
        const SizedBox(height: 6),
        for (final item in state.visibleSearchResults) _SearchResultRow(item: item, state: state, onTap: () => onOpenItem(item)),
      ],
    );
  }
}

class _SearchResultRow extends StatelessWidget {
  const _SearchResultRow({required this.item, required this.state, required this.onTap});

  final CollectionItem item;
  final HomeShelvesState state;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final title = [resolveDisplayTitle(item.titles, state.preferredLanguages) ?? l10n.untitled, if (item.volumeNumber != null) '${item.volumeNumber}'].join(' ');
    final category = state.topCategoryOf(item);
    final color = Color(item.spineColorValue ?? category?.colorValue ?? AkashicColors.lavender.toARGB32());
    final details = [?item.creator, ?item.year?.toString()].join(' · ');
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: SizedBox(
                width: 40,
                height: 56,
                child: item.imagePath == null
                    ? ColoredBox(color: color)
                    : Image.file(File(item.imagePath!), fit: BoxFit.cover, cacheWidth: 120, errorBuilder: (context, error, stack) => ColoredBox(color: color)),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, maxLines: 2, overflow: TextOverflow.ellipsis, style: AkashicTypography.body(size: 15, weight: FontWeight.w700)),
                  if (details.isNotEmpty) Text(details, maxLines: 1, overflow: TextOverflow.ellipsis, style: AkashicTypography.body(size: 12).copyWith(color: AkashicColors.textSoft)),
                ],
              ),
            ),
            if (category != null) ...[
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(color: Color(category.colorValue).withValues(alpha: 0.18), borderRadius: BorderRadius.circular(8)),
                child: Text(category.name, style: AkashicTypography.body(size: 11, weight: FontWeight.w700)),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
