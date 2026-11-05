import 'package:akashic/layers/technical/Localization/app_localizations.dart';
import 'package:akashic/layers/functional/Catalog/domain/entities/category_type.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/collection_item.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/shelf_group.dart';
import 'package:akashic/layers/functional/Collection/domain/use_cases/resolve_display_title.dart';
import 'package:akashic/layers/functional/Collection/presentation/widgets/collapsed_series_block.dart';
import 'package:akashic/layers/functional/Collection/presentation/widgets/console_case_spine.dart';
import 'package:akashic/layers/functional/Collection/presentation/widgets/item_spine.dart';
import 'package:akashic/layers/functional/Collection/presentation/widgets/missing_volume_spine.dart';
import 'package:akashic/layers/functional/Collection/presentation/widgets/shelf_gap_view.dart';
import 'package:akashic/layers/functional/Collection/presentation/widgets/shelf_plank.dart';
import 'package:akashic/layers/functional/Settings/domain/entities/preferred_languages.dart';
import 'package:flutter/material.dart';

class ShelfRow extends StatelessWidget {
  const ShelfRow({
    required this.groups,
    required this.type,
    required this.size,
    required this.categoryColorValue,
    required this.collapsedSeriesIds,
    required this.onToggleSeries,
    required this.onOpenItem,
    this.preferredLanguages = PreferredLanguages.defaults,
    this.onOpenSeries,
    super.key,
  });

  final List<ShelfGroup> groups;
  final CategoryType type;
  final SpineSize size;
  final int categoryColorValue;
  final Set<String> collapsedSeriesIds;
  final ValueChanged<String> onToggleSeries;
  final ValueChanged<CollectionItem> onOpenItem;
  final PreferredLanguages preferredLanguages;
  final ValueChanged<String>? onOpenSeries;

  SpineShape get _shape => type == CategoryType.cards ? SpineShape.deckBox : SpineShape.flat;

  SpineThickness get _thickness => type == CategoryType.music ? SpineThickness.record : SpineThickness.volume;

  String _accessibleLabelOf(CollectionItem item, AppLocalizations l10n) {
    final title = resolveDisplayTitle(item.titles, preferredLanguages) ?? l10n.untitled;
    return item.volumeNumber == null ? title : l10n.wishVolumeTitle(title, item.volumeNumber!);
  }

  List<Widget> _entriesOf(ShelfGroup group, AppLocalizations l10n) {
    if (group.isSeries && collapsedSeriesIds.contains(group.id)) {
      final firstVolume = group.entries.whereType<ShelfItem>().firstOrNull?.item;
      return [
        CollapsedSeriesBlock(
          label: group.label,
          ownedCount: group.ownedCount,
          isIncomplete: group.isIncomplete,
          colorValue: firstVolume?.spineColorValue ?? categoryColorValue,
          size: size,
          onTap: () => onToggleSeries(group.id),
          onLongPress: onOpenSeries == null ? null : () => onOpenSeries!(group.id),
        ),
      ];
    }
    return [
      for (final entry in group.entries)
        if (entry is! ShelfDivider)
          switch (entry) {
            ShelfDivider() => const SizedBox.shrink(),
            ShelfItem(:final item) when type == CategoryType.videoGames => ConsoleCaseSpine(item: item, label: _labelOf(item), size: size, onTap: () => onOpenItem(item)),
            ShelfItem(:final item) => ItemSpine(
              item: item,
              label: _labelOf(item),
              labelIsNumber: item.volumeNumber != null,
              shape: _shape,
              thickness: _thickness,
              size: size,
              fallbackColorValue: categoryColorValue,
              onTap: () => onOpenItem(item),
              semanticsLabel: _accessibleLabelOf(item, l10n),
            ),
            ShelfMissingVolume(:final volumeNumber) => MissingVolumeSpine(volumeNumber: volumeNumber, size: size),
          ShelfGap() => ShelfGapView(size: size),
          },
    ];
  }

  String? _labelOf(CollectionItem item) {
    if (item.volumeNumber != null) {
      return '${item.volumeNumber}';
    }
    if (size == SpineSize.compact) {
      return null;
    }
    return resolveDisplayTitle(item.titles, preferredLanguages);
  }

  @override
  Widget build(BuildContext context) {
    final spines = [
      for (final (index, group) in groups.indexed) ...[
        if (index > 0 && group.entries.firstOrNull is! ShelfGap) ShelfGapView(size: size),
        ..._entriesOf(group, AppLocalizations.of(context)),
      ],
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(
          height: size.shelfHeight,
          child: ShaderMask(
            shaderCallback: (bounds) => const LinearGradient(colors: [Colors.white, Colors.white, Colors.transparent], stops: [0, 0.85, 1]).createShader(bounds),
            blendMode: BlendMode.dstIn,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 6),
              itemCount: spines.length,
              separatorBuilder: (context, index) => const SizedBox(width: 3),
              itemBuilder: (context, index) => Align(alignment: Alignment.bottomCenter, child: spines[index]),
            ),
          ),
        ),
        const ShelfPlank(),
      ],
    );
  }
}
