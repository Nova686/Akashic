import 'package:akashic/layers/functional/Catalog/domain/entities/category.dart';
import 'package:akashic/layers/functional/Check/presentation/cubit/chain_scan_cubit.dart';
import 'package:akashic/layers/functional/Check/presentation/cubit/chain_scan_state.dart';
import 'package:akashic/layers/functional/Check/presentation/widgets/scan_entry_cover.dart';
import 'package:akashic/layers/technical/Localization/app_localizations.dart';
import 'package:akashic/layers/technical/Theme/akashic_colors.dart';
import 'package:akashic/layers/technical/Theme/akashic_typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

const double scanDrawerPeekHeight = 96;
const double _halfExtent = 0.5;
const double _fullExtent = 0.92;
const double _reviewThreshold = 0.75;

class ScanDrawer extends StatefulWidget {
  const ScanDrawer({required this.titleOf, required this.statusLabel, required this.onSeeItem, required this.pickCategory, this.onOpenShelf, this.budgetLine, super.key});

  final String Function(ChainEntry entry) titleOf;
  final String Function(ChainEntryStatus status, AppLocalizations l10n) statusLabel;
  final ValueChanged<String> onSeeItem;
  final Future<Category?> Function(BuildContext context, Category? current) pickCategory;
  final ValueChanged<String>? onOpenShelf;
  final Widget? budgetLine;

  @override
  State<ScanDrawer> createState() => _ScanDrawerState();
}

class _ScanDrawerState extends State<ScanDrawer> {
  final DraggableScrollableController _drawer = DraggableScrollableController();
  double _extent = 0;
  double _peekExtent = 0.15;

  @override
  void initState() {
    super.initState();
    _drawer.addListener(_followExtent);
  }

  void _followExtent() {
    final extent = _drawer.size;
    if ((extent >= _reviewThreshold) != (_extent >= _reviewThreshold) || (extent > _peekExtent + 0.02) != (_extent > _peekExtent + 0.02)) {
      setState(() => _extent = extent);
    } else {
      _extent = extent;
    }
  }

  bool get _isOpen => _extent > _peekExtent + 0.02;

  void _moveTo(double extent) {
    if (_drawer.isAttached) {
      if (MediaQuery.disableAnimationsOf(context)) {
        _drawer.jumpTo(extent);
      } else {
        _drawer.animateTo(extent, duration: const Duration(milliseconds: 260), curve: Curves.easeOutCubic);
      }
    }
  }

  void _toggle() => _moveTo(_isOpen ? _peekExtent : _halfExtent);

  @override
  void dispose() {
    _drawer
      ..removeListener(_followExtent)
      ..dispose();
    super.dispose();
  }

  Future<void> _pickCategoryFor(ChainEntry entry) async {
    final chain = context.read<ChainScanCubit>();
    final category = await widget.pickCategory(context, entry.targetCategory);
    final index = chain.state.entries.indexWhere((current) => current.id == entry.id);
    if (category != null && index >= 0) {
      chain.moveTo(index, category);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.paddingOf(context).bottom;
    return LayoutBuilder(
      builder: (context, constraints) {
        _peekExtent = ((scanDrawerPeekHeight + bottomInset) / constraints.maxHeight).clamp(0.08, 0.3);
        return BlocListener<ChainScanCubit, ChainScanState>(
          listenWhen: (previous, current) => _shelfEntriesResolving(current) > _shelfEntriesResolving(previous) && current.entries.length > previous.entries.length,
          listener: (context, state) {
            if (!_isOpen) {
              _moveTo(_halfExtent);
            }
          },
          child: DraggableScrollableSheet(
            controller: _drawer,
            initialChildSize: _peekExtent,
            minChildSize: _peekExtent,
            maxChildSize: _fullExtent,
            snap: true,
            snapSizes: [_halfExtent],
            builder: (context, scrollController) => Material(
              color: AkashicColors.surface,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
              clipBehavior: Clip.antiAlias,
              child: BlocBuilder<ChainScanCubit, ChainScanState>(
                builder: (context, state) => Stack(
                  children: [
                    CustomScrollView(
                      controller: scrollController,
                      slivers: [
                        SliverToBoxAdapter(child: _DrawerHandle(isOpen: _isOpen, onTap: _toggle)),
                        SliverToBoxAdapter(
                          child: _isOpen
                              ? _DrawerSummary(state: state, onOpenShelf: widget.onOpenShelf, budgetLine: state.acceptedCount > 0 ? widget.budgetLine : null)
                              : _PeekRow(
                                  state: state,
                                  titleOf: widget.titleOf,
                                  statusLabel: widget.statusLabel,
                                  onTap: _toggle,
                                  onSeeItem: widget.onSeeItem,
                                  onAddAnother: context.read<ChainScanCubit>().canAddAnother ? () => context.read<ChainScanCubit>().addAnotherOf(state.entries.length - 1) : null,
                                ),
                        ),
                        if (_isOpen && _extent >= _reviewThreshold)
                          ..._groupedReview(context, state)
                        else if (_isOpen)
                          SliverList.builder(
                            itemCount: state.entries.length,
                            itemBuilder: (context, position) {
                              final index = state.entries.length - 1 - position;
                              final entry = state.entries[index];
                              return _CompactEntryRow(
                                entry: entry,
                                title: widget.titleOf(entry),
                                status: widget.statusLabel(entry.status, AppLocalizations.of(context)),
                                onToggle: () => context.read<ChainScanCubit>().toggle(index),
                                onSeeItem: widget.onSeeItem,
                              );
                            },
                          ),
                        SliverToBoxAdapter(child: SizedBox(height: _isOpen ? 88 + bottomInset : 0)),
                      ],
                    ),
                    if (_isOpen)
                      Positioned(
                        left: 18,
                        right: 18,
                        bottom: 12 + bottomInset,
                        child: FilledButton(
                          onPressed: state.acceptedCount == 0 || state.isCommitting ? null : context.read<ChainScanCubit>().commit,
                          child: Text(AppLocalizations.of(context).addScannedItems(state.acceptedCount)),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  List<Widget> _groupedReview(BuildContext context, ChainScanState state) {
    final l10n = AppLocalizations.of(context);
    final chain = context.read<ChainScanCubit>();
    final indexed = [for (final (index, entry) in state.entries.indexed) (index, entry)].reversed.toList();
    final groups = [
      (l10n.chainGroupToAdd, [for (final pair in indexed) if (pair.$2.status == ChainEntryStatus.found || pair.$2.status == ChainEntryStatus.resolving) pair]),
      (l10n.chainGroupOwned, [for (final pair in indexed) if (pair.$2.status == ChainEntryStatus.alreadyOwned) pair]),
      (l10n.chainGroupMissing, [for (final pair in indexed) if (pair.$2.hasFailed) pair]),
    ];
    return [
      for (final (label, members) in groups)
        if (members.isNotEmpty) ...[
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(18, 16, 18, 4),
              child: Text('${label.toUpperCase()} · ${members.length}', style: AkashicTypography.body(size: 11, weight: FontWeight.w800).copyWith(color: AkashicColors.textSoft, letterSpacing: 1.1)),
            ),
          ),
          SliverList.list(
            children: [
              for (final (index, entry) in members)
                _ReviewEntryTile(
                  entry: entry,
                  title: widget.titleOf(entry),
                  status: widget.statusLabel(entry.status, l10n),
                  canWish: chain.canAddToWishes,
                  canAddAnother: chain.canAddAnother,
                  onAddAnother: () => chain.addAnotherOf(index),
                  onToggle: () => chain.toggle(index),
                  onWish: () => chain.addToWishes(index),
                  onSeeItem: widget.onSeeItem,
                  onPickCategory: () => _pickCategoryFor(entry),
                ),
            ],
          ),
        ],
    ];
  }
}

int _shelfEntriesResolving(ChainScanState state) => state.entries.where((entry) => entry.source == ChainEntrySource.shelf && entry.status == ChainEntryStatus.resolving).length;

String chainSourceLabel(ChainEntrySource source, AppLocalizations l10n) => switch (source) {
      ChainEntrySource.barcode => l10n.chainSourceBarcode,
      ChainEntrySource.cover => l10n.chainSourceCover,
      ChainEntrySource.shelf => l10n.chainSourceShelf,
    };

class _DrawerHandle extends StatelessWidget {
  const _DrawerHandle({required this.isOpen, required this.onTap});

  final bool isOpen;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Semantics(
      button: true,
      label: isOpen ? l10n.hideScannedList : l10n.showScannedList,
      child: InkWell(
        onTap: onTap,
        child: SizedBox(
          height: 24,
          child: Center(child: Container(width: 40, height: 4, decoration: BoxDecoration(color: AkashicColors.textFaint, borderRadius: BorderRadius.circular(2)))),
        ),
      ),
    );
  }
}

class _ToAddCounter extends StatelessWidget {
  const _ToAddCounter({required this.count});

  final int count;

  @override
  Widget build(BuildContext context) => Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text('$count', style: AkashicTypography.numeral(size: 24).copyWith(color: AkashicColors.teal, height: 1)),
          Text(AppLocalizations.of(context).toAdd, style: AkashicTypography.body(size: 11, weight: FontWeight.w600).copyWith(color: AkashicColors.textSoft)),
        ],
      );
}

class _PeekRow extends StatelessWidget {
  const _PeekRow({required this.state, required this.titleOf, required this.statusLabel, required this.onTap, required this.onSeeItem, this.onAddAnother});

  final ChainScanState state;
  final String Function(ChainEntry entry) titleOf;
  final String Function(ChainEntryStatus status, AppLocalizations l10n) statusLabel;
  final VoidCallback onTap;
  final ValueChanged<String> onSeeItem;
  final VoidCallback? onAddAnother;

  (String, String, Color) _lineOf(ChainEntry latest, AppLocalizations l10n) => switch (latest) {
        ChainEntry(status: ChainEntryStatus.unreadable, source: ChainEntrySource.shelf) => (l10n.shelfUnreadableTitle, l10n.shelfUnreadableHint, AkashicColors.gold),
        ChainEntry(status: ChainEntryStatus.unreadable) => (l10n.chainUnreadable, l10n.coverUnreadableHint, AkashicColors.gold),
        ChainEntry(status: ChainEntryStatus.rateLimited) => (statusLabel(latest.status, l10n), l10n.chainFailureRateLimited(latest.label), AkashicColors.gold),
        ChainEntry(status: ChainEntryStatus.unreachable) => (statusLabel(latest.status, l10n), l10n.chainFailureUnreachable(latest.label), AkashicColors.gold),
        _ => (titleOf(latest), statusLabel(latest.status, l10n), scanStatusColor(latest)),
      };

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final latest = state.entries.lastOrNull;
    if (latest == null) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(18, 4, 18, 16),
        child: Text(l10n.scansPileHere, textAlign: TextAlign.center, style: AkashicTypography.body(size: 14).copyWith(color: AkashicColors.textSoft)),
      );
    }
    final (title, detail, color) = _lineOf(latest, l10n);
    final previous = state.entries.reversed.skip(1).take(2).toList();
    return InkWell(
      onTap: switch (latest.ownedItemId) {
        final itemId? when latest.status == ChainEntryStatus.alreadyOwned => () => onSeeItem(itemId),
        _ => onTap,
      },
      child: Padding(
        padding: const EdgeInsets.fromLTRB(18, 0, 18, 12),
        child: Row(
          children: [
            SizedBox(
              width: 40 + previous.length * 10,
              height: 56,
              child: Stack(
                children: [
                  for (final (offset, entry) in previous.reversed.indexed)
                    Positioned(left: (previous.length - offset) * 10, child: Opacity(opacity: 0.5, child: ScanEntryCover(entry: entry, title: titleOf(entry)))),
                  ScanEntryCover(entry: latest, title: titleOf(latest)),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, maxLines: 1, overflow: TextOverflow.ellipsis, style: AkashicTypography.body(size: 14, weight: FontWeight.w700)),
                  Text(detail, maxLines: 2, overflow: TextOverflow.ellipsis, style: AkashicTypography.body(size: 12, weight: FontWeight.w600).copyWith(color: color)),
                ],
              ),
            ),
            if (latest.status == ChainEntryStatus.alreadyOwned && onAddAnother != null)
              IconButton(
                tooltip: l10n.addAnotherItem,
                onPressed: onAddAnother,
                icon: Icon(latest.addedAgainCount > 0 ? Icons.check_circle : Icons.add_circle_outline, color: AkashicColors.teal),
              ),
            if (state.acceptedCount > 0) ...[const SizedBox(width: 12), _ToAddCounter(count: state.acceptedCount)],
          ],
        ),
      ),
    );
  }
}

class _DrawerSummary extends StatelessWidget {
  const _DrawerSummary({required this.state, this.onOpenShelf, this.budgetLine});

  final ChainScanState state;
  final ValueChanged<String>? onOpenShelf;
  final Widget? budgetLine;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final owned = state.entries.where((entry) => entry.status == ChainEntryStatus.alreadyOwned).length;
    final missing = state.entries.where((entry) => entry.hasFailed).length;
    final shelfEntries = state.entries.where((entry) => entry.source == ChainEntrySource.shelf).length;
    final searching = _shelfEntriesResolving(state);
    final summary = [
      l10n.chainScannedCount(state.entries.length),
      if (owned > 0) l10n.chainOwnedCount(owned),
      if (missing > 0) l10n.chainMissingCount(missing),
    ].join(' · ');
    final latestShelfPhoto = state.entries.reversed.map((entry) => entry.shelfPhotoId).nonNulls.firstOrNull;
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 0, 18, 8),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(l10n.scannedCodes, style: AkashicTypography.displayTitle(size: 22)),
                Text(
                  searching > 0 ? '${l10n.shelfSpinesRead(shelfEntries)} · ${l10n.shelfSpinesSearching(searching)}' : summary,
                  style: AkashicTypography.body(size: 12).copyWith(color: AkashicColors.textSoft),
                ),
                if ((onOpenShelf, latestShelfPhoto) case (final openShelf?, final photoId?))
                  TextButton.icon(
                    onPressed: () => openShelf(photoId),
                    style: TextButton.styleFrom(padding: EdgeInsets.zero, foregroundColor: AkashicColors.teal),
                    icon: const Icon(Icons.crop_free, size: 18),
                    label: Text(l10n.seeShelf),
                  ),
                ?budgetLine,
              ],
            ),
          ),
          if (state.acceptedCount > 0) _ToAddCounter(count: state.acceptedCount),
        ],
      ),
    );
  }
}

class _CompactEntryRow extends StatelessWidget {
  const _CompactEntryRow({required this.entry, required this.title, required this.status, required this.onToggle, required this.onSeeItem});

  final ChainEntry entry;
  final String title;
  final String status;
  final VoidCallback onToggle;
  final ValueChanged<String> onSeeItem;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 18),
      leading: ScanEntryCover(entry: entry, title: title, width: 32),
      title: Text(title, maxLines: 1, overflow: TextOverflow.ellipsis, style: AkashicTypography.body(size: 14, weight: FontWeight.w700)),
      subtitle: Text(status, style: AkashicTypography.body(size: 12, weight: FontWeight.w600).copyWith(color: scanStatusColor(entry))),
      trailing: switch (entry) {
        ChainEntry(status: ChainEntryStatus.found) => Checkbox(value: entry.isAccepted && entry.canBeAdded, onChanged: entry.canBeAdded ? (_) => onToggle() : null),
        ChainEntry(status: ChainEntryStatus.alreadyOwned, :final ownedItemId?) =>
          IconButton(tooltip: AppLocalizations.of(context).seeItem, icon: const Icon(Icons.chevron_right), onPressed: () => onSeeItem(ownedItemId)),
        _ => null,
      },
    );
  }
}

class _ReviewEntryTile extends StatelessWidget {
  const _ReviewEntryTile({
    required this.entry,
    required this.title,
    required this.status,
    required this.canWish,
    required this.canAddAnother,
    required this.onAddAnother,
    required this.onToggle,
    required this.onWish,
    required this.onSeeItem,
    required this.onPickCategory,
  });

  final ChainEntry entry;
  final String title;
  final String status;
  final bool canWish;
  final bool canAddAnother;
  final VoidCallback onAddAnother;
  final VoidCallback onToggle;
  final VoidCallback onWish;
  final ValueChanged<String> onSeeItem;
  final VoidCallback onPickCategory;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isFound = entry.status == ChainEntryStatus.found;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (isFound) Checkbox(value: entry.isAccepted && entry.canBeAdded, onChanged: entry.canBeAdded ? (_) => onToggle() : null),
          ScanEntryCover(entry: entry, title: title),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, maxLines: 2, overflow: TextOverflow.ellipsis, style: AkashicTypography.body(size: 14, weight: FontWeight.w700)),
                Text(
                  isFound ? chainSourceLabel(entry.source, l10n) : '$status · ${chainSourceLabel(entry.source, l10n)}',
                  style: AkashicTypography.body(size: 12).copyWith(color: isFound ? AkashicColors.textSoft : scanStatusColor(entry)),
                ),
                if (entry.status == ChainEntryStatus.alreadyOwned && canAddAnother)
                  Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: ActionChip(
                      avatar: Icon(entry.addedAgainCount > 0 ? Icons.check : Icons.add, size: 16, color: AkashicColors.teal),
                      label: Text(entry.addedAgainCount > 0 ? '${l10n.anotherItemAdded} ×${entry.addedAgainCount}' : l10n.addAnotherItem),
                      labelStyle: AkashicTypography.body(size: 12, weight: FontWeight.w700).copyWith(color: AkashicColors.teal),
                      onPressed: onAddAnother,
                    ),
                  ),
                if (isFound)
                  Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: ActionChip(
                      avatar: const Icon(Icons.folder_outlined, size: 16, color: AkashicColors.lavender),
                      label: Text(entry.targetCategory?.name ?? l10n.chooseCategory, overflow: TextOverflow.ellipsis),
                      labelStyle: AkashicTypography.body(size: 12, weight: FontWeight.w700).copyWith(color: AkashicColors.lavender),
                      onPressed: onPickCategory,
                    ),
                  ),
              ],
            ),
          ),
          switch (entry) {
            ChainEntry(status: ChainEntryStatus.alreadyOwned, :final ownedItemId?) =>
              IconButton(tooltip: l10n.seeItem, icon: const Icon(Icons.chevron_right), onPressed: () => onSeeItem(ownedItemId)),
            ChainEntry(status: ChainEntryStatus.found) when canWish => IconButton(
                tooltip: entry.isWished ? l10n.wished : l10n.addToWishes,
                icon: Icon(entry.isWished ? Icons.favorite : Icons.favorite_border, color: AkashicColors.lavender),
                onPressed: entry.isWished ? null : onWish,
              ),
            _ => const SizedBox(width: 48),
          },
        ],
      ),
    );
  }
}
