import 'dart:io';

import 'package:akashic/layers/functional/Collection/domain/entities/collection_item.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/shelf_group.dart';
import 'package:akashic/layers/functional/Collection/domain/use_cases/resolve_display_title.dart';
import 'package:akashic/layers/functional/Collection/presentation/widgets/shelf_plank.dart';
import 'package:akashic/layers/functional/Collection/presentation/widgets/spine_text_color.dart';
import 'package:akashic/layers/functional/Settings/domain/entities/preferred_languages.dart';
import 'package:akashic/layers/technical/Localization/app_localizations.dart';
import 'package:akashic/layers/technical/Theme/akashic_colors.dart';
import 'package:akashic/layers/technical/Theme/akashic_typography.dart';
import 'package:akashic/layers/functional/Collection/presentation/widgets/cover_badge.dart';
import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';

class CoverShelf extends StatelessWidget {
  const CoverShelf({
    required this.groups,
    required this.preferredLanguages,
    required this.categoryColorValue,
    required this.collapsedSeriesIds,
    required this.onOpenItem,
    required this.onToggleSeries,
    this.onOpenSeries,
    this.onSeeAllGroup,
    this.showsWholeGroups = false,
    this.scrollPadding,
    this.hidesGroupHeaders = false,
    this.selectedItemIds = const {},
    this.onLongPressItem,
    this.badgesByItem = const {},
    super.key,
  });

  static const double coverWidth = 76;
  static const double minimumCoverWidth = 72;
  static const double coverSpacing = 8;
  static const double coverAspectRatio = 1.45;
  static const double shelfInset = 6;
  static const int minimumColumns = 3;
  static const int missingTilesShown = 6;

  final List<ShelfGroup> groups;
  final PreferredLanguages preferredLanguages;
  final int categoryColorValue;
  final Set<String> collapsedSeriesIds;
  final ValueChanged<CollectionItem> onOpenItem;
  final ValueChanged<String> onToggleSeries;
  final ValueChanged<String>? onOpenSeries;
  final ValueChanged<ShelfGroup>? onSeeAllGroup;
  final Map<String, CoverBadge> badgesByItem;
  final bool showsWholeGroups;
  final EdgeInsets? scrollPadding;
  final bool hidesGroupHeaders;
  final Set<String> selectedItemIds;
  final ValueChanged<CollectionItem>? onLongPressItem;

  static int columnsFor(double width) => (((width - 2 * shelfInset + coverSpacing) / (minimumCoverWidth + coverSpacing)).floor()).clamp(minimumColumns, 12);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    if ((showsWholeGroups, scrollPadding, groups) case (true, final padding?, [final group])) {
      return _CoverRows(group: group, shelf: this, scrollPadding: padding);
    }
    if (showsWholeGroups) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [for (final group in groups) _CoverRows(group: group, shelf: this)],
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (final group in groups) ...[
          if (!hidesGroupHeaders)
            _GroupHeader(
            group: group,
            label: group.label.isEmpty ? l10n.otherItems : group.label,
            isCollapsed: group.isSeries && collapsedSeriesIds.contains(group.id),
            onTap: group.isSeries
                ? () => onToggleSeries(group.id)
                : onSeeAllGroup == null
                ? null
                : () => onSeeAllGroup!(group),
            onSeeAll: onSeeAllGroup == null ? null : () => onSeeAllGroup!(group),
            onOpenSeries: group.isSeries && onOpenSeries != null ? () => onOpenSeries!(group.id) : null,
          ),
          if (!group.isSeries || !collapsedSeriesIds.contains(group.id)) _CoverStrip(group: group, shelf: this),
          const SizedBox(height: 10),
        ],
      ],
    );
  }
}

class _GroupHeader extends StatelessWidget {
  const _GroupHeader({required this.group, required this.label, required this.isCollapsed, this.onTap, this.onSeeAll, this.onOpenSeries});

  final ShelfGroup group;
  final String label;
  final bool isCollapsed;
  final VoidCallback? onTap;
  final VoidCallback? onSeeAll;
  final VoidCallback? onOpenSeries;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 2),
        child: Row(
          children: [
            if (group.isSeries) ...[Icon(isCollapsed ? Icons.chevron_right : Icons.expand_more, color: AkashicColors.textSoft), const SizedBox(width: 4)],
            Expanded(
              child: Text(label, maxLines: 1, overflow: TextOverflow.ellipsis, style: AkashicTypography.displayTitle(size: 20)),
            ),
            if (group.isSeries && group.isIncomplete)
              Semantics(
                label: l10n.incompleteSeries,
                child: Container(
                  margin: const EdgeInsets.only(left: 6),
                  width: 7,
                  height: 7,
                  decoration: const BoxDecoration(color: AkashicColors.teal, shape: BoxShape.circle),
                ),
              ),
            const SizedBox(width: 8),
            Text(l10n.groupItemCount(group.ownedCount), style: AkashicTypography.body(size: 12).copyWith(color: AkashicColors.textSoft)),
            if (onOpenSeries case final open?)
              IconButton(
                tooltip: l10n.seeSeries,
                icon: const Icon(Icons.collections_bookmark_outlined, color: AkashicColors.teal),
                onPressed: open,
              ),
            if (onSeeAll case final seeAll?)
              IconButton(
                tooltip: l10n.seeAll,
                icon: const Icon(Icons.arrow_forward, color: AkashicColors.teal),
                onPressed: seeAll,
              ),
          ],
        ),
      ),
    );
  }
}

List<Widget> _tilesOf(BuildContext context, ShelfGroup group, CoverShelf shelf) {
  final l10n = AppLocalizations.of(context);
  final missing = [
    for (final entry in group.entries)
      if (entry is ShelfMissingVolume) entry.volumeNumber,
  ];
  final showsEveryMissing = missing.length <= CoverShelf.missingTilesShown;
  return [
    for (final entry in group.entries)
      switch (entry) {
        ShelfItem(:final item) => _CoverTile(item: item, shelf: shelf, isVolume: group.isSeries),
        ShelfMissingVolume(:final volumeNumber) when showsEveryMissing => _MissingTile(label: l10n.missingVolumeShort(volumeNumber)),
        _ => null,
      },
    if (!showsEveryMissing) _MissingTile(label: l10n.missingVolumesMore(missing.length), onTap: shelf.onOpenSeries == null ? null : () => shelf.onOpenSeries!(group.id)),
  ].nonNulls.toList();
}

class _CoverStrip extends StatelessWidget {
  const _CoverStrip({required this.group, required this.shelf});

  final ShelfGroup group;
  final CoverShelf shelf;

  @override
  Widget build(BuildContext context) {
    final tiles = _tilesOf(context, group, shelf);
    if (tiles.isEmpty) {
      return const SizedBox.shrink();
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(
          height: CoverShelf.coverWidth * CoverShelf.coverAspectRatio + 4,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.only(top: 4, left: CoverShelf.shelfInset, right: CoverShelf.shelfInset),
            itemCount: tiles.length,
            separatorBuilder: (context, index) => const SizedBox(width: CoverShelf.coverSpacing),
            itemBuilder: (context, index) => SizedBox(width: CoverShelf.coverWidth, child: tiles[index]),
          ),
        ),
        const ShelfPlank(),
      ],
    );
  }
}

class _CoverRows extends StatelessWidget {
  const _CoverRows({required this.group, required this.shelf, this.scrollPadding});

  final ShelfGroup group;
  final CoverShelf shelf;
  final EdgeInsets? scrollPadding;

  @override
  Widget build(BuildContext context) {
    final tiles = _tilesOf(context, group, shelf);
    if (tiles.isEmpty) {
      return const SizedBox.shrink();
    }
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth - (scrollPadding?.horizontal ?? 0);
        final columns = CoverShelf.columnsFor(width);
        final coverWidth = (width - 2 * CoverShelf.shelfInset - CoverShelf.coverSpacing * (columns - 1)) / columns;
        Widget rowAt(int start) => Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: EdgeInsets.only(top: start == 0 ? 4 : 18, left: CoverShelf.shelfInset, right: CoverShelf.shelfInset),
                  child: SizedBox(
                    height: coverWidth * CoverShelf.coverAspectRatio,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        for (var column = 0; column < columns; column++) ...[
                          if (column > 0) const SizedBox(width: CoverShelf.coverSpacing),
                          Expanded(child: start + column < tiles.length ? tiles[start + column] : const SizedBox.shrink()),
                        ],
                      ],
                    ),
                  ),
                ),
                const ShelfPlank(),
              ],
            );
        final rowCount = (tiles.length / columns).ceil();
        if (scrollPadding case final padding?) {
          return ListView.builder(padding: padding, itemCount: rowCount, itemBuilder: (context, row) => rowAt(row * columns));
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [for (var row = 0; row < rowCount; row++) rowAt(row * columns)],
        );
      },
    );
  }
}

class _CoverTile extends StatelessWidget {
  const _CoverTile({required this.item, required this.shelf, required this.isVolume});

  final CollectionItem item;
  final CoverShelf shelf;
  final bool isVolume;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final title = resolveDisplayTitle(item.titles, shelf.preferredLanguages) ?? l10n.untitled;
    final imagePath = item.imagePath;
    final color = Color(item.spineColorValue ?? shelf.categoryColorValue);
    final isSelected = shelf.selectedItemIds.contains(item.id);
    final onLongPress = shelf.onLongPressItem;
    return Semantics(
      button: true,
      selected: isSelected,
      excludeSemantics: true,
      label: item.volumeNumber == null ? title : l10n.wishVolumeTitle(title, item.volumeNumber!),
      onTap: () => shelf.onOpenItem(item),
      customSemanticsActions: onLongPress == null ? null : {CustomSemanticsAction(label: isSelected ? l10n.unselectItem : l10n.selectItem): () => onLongPress(item)},
      child: InkWell(
        onTap: () => shelf.onOpenItem(item),
        onLongPress: onLongPress == null ? null : () => onLongPress(item),
        borderRadius: BorderRadius.circular(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: switch (ColoredBox(
                      color: color,
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: Center(
                          child: Text(
                            title,
                            maxLines: 4,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                            style: AkashicTypography.displayTitle(size: 12).copyWith(color: textColorOnSpine(color)),
                          ),
                        ),
                      ),
                    )) {
                      final placeholder when imagePath == null => placeholder,
                      final placeholder => Image.file(File(imagePath), fit: BoxFit.cover, cacheWidth: 300, errorBuilder: (context, error, stack) => placeholder),
                    },
                  ),
                  if (isVolume && item.volumeNumber != null)
                    Positioned(
                      left: 6,
                      bottom: 6,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                        decoration: BoxDecoration(color: AkashicColors.night.withValues(alpha: 0.85), borderRadius: BorderRadius.circular(10)),
                        child: Text('${item.volumeNumber}', style: AkashicTypography.numeral(size: 12).copyWith(color: AkashicColors.lavender)),
                      ),
                    ),
                  if (shelf.badgesByItem[item.id] case final badge?)
                    Positioned(
                      right: 5,
                      bottom: 5,
                      child: Tooltip(
                        message: badge.label,
                        child: Container(
                          padding: const EdgeInsets.all(3),
                          decoration: BoxDecoration(color: AkashicColors.night.withValues(alpha: 0.85), shape: BoxShape.circle),
                          child: Icon(badge.icon, size: 14, color: badge.color),
                        ),
                      ),
                    ),
                  if (isSelected) ...[
                    DecoratedBox(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: AkashicColors.lavender, width: 3),
                        color: AkashicColors.night.withValues(alpha: 0.35),
                      ),
                    ),
                    const Positioned(top: 6, right: 6, child: Icon(Icons.check_circle, color: AkashicColors.lavender)),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MissingTile extends StatelessWidget {
  const _MissingTile({required this.label, this.onTap});

  final String label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: CustomPaint(
              painter: _DashedBorderPainter(),
              child: Center(
                child: Text(
                  label,
                  textAlign: TextAlign.center,
                  style: AkashicTypography.numeral(size: 13).copyWith(color: AkashicColors.textSoft),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DashedBorderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AkashicColors.textSoft.withValues(alpha: 0.6)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;
    final outline = Path()..addRRect(RRect.fromRectAndRadius(Offset.zero & size, const Radius.circular(8)));
    for (final metric in outline.computeMetrics()) {
      for (var distance = 0.0; distance < metric.length; distance += 9) {
        canvas.drawPath(metric.extractPath(distance, distance + 5), paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
