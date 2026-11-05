import 'package:akashic/layers/functional/Catalog/domain/entities/category_type.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/collection_item.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/series.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/shelf_group.dart';
import 'package:akashic/layers/functional/Collection/domain/use_cases/resolve_display_title.dart';
import 'package:akashic/layers/functional/Collection/domain/use_cases/search_text_normalizer.dart';
import 'package:akashic/layers/functional/Settings/domain/entities/preferred_languages.dart';

List<ShelfGroup> groupItemsOnShelf(
  List<CollectionItem> items,
  List<Series> series,
  CategoryType type,
  PreferredLanguages preferred, {
  Map<String, DateTime> lastPlayedByItem = const {},
}) {
  final seriesById = {for (final oneSeries in series) oneSeries.id: oneSeries};
  final itemsBySeries = <String, List<CollectionItem>>{};
  final itemsByGroupLabel = <String, List<CollectionItem>>{};
  final ungroupedItems = <CollectionItem>[];

  for (final item in items) {
    final seriesId = item.seriesId;
    final groupLabel = (item.groupKey ?? item.creator)?.trim();
    if (seriesId != null && seriesById.containsKey(seriesId)) {
      itemsBySeries.putIfAbsent(seriesId, () => []).add(item);
    } else if (groupLabel != null && groupLabel.isNotEmpty) {
      itemsByGroupLabel.putIfAbsent(groupLabel, () => []).add(item);
    } else {
      ungroupedItems.add(item);
    }
  }

  String sortableTitle(CollectionItem item) => normalizeForSearch(resolveDisplayTitle(item.titles, preferred) ?? '');
  final sortsByRecentPlay = type == CategoryType.videoGames && lastPlayedByItem.isNotEmpty;
  int byShelfOrder(CollectionItem first, CollectionItem second) {
    if (sortsByRecentPlay) {
      final (firstPlayed, secondPlayed) = (lastPlayedByItem[first.id], lastPlayedByItem[second.id]);
      if (firstPlayed != secondPlayed) {
        return switch ((firstPlayed, secondPlayed)) {
          (null, _) => 1,
          (_, null) => -1,
          (final firstAt?, final secondAt?) => secondAt.compareTo(firstAt),
        };
      }
    }
    return sortableTitle(first).compareTo(sortableTitle(second));
  }

  DateTime? lastPlayedIn(List<CollectionItem> groupItems) => groupItems.map((item) => lastPlayedByItem[item.id]).nonNulls.fold<DateTime?>(null, (latest, at) => latest == null || at.isAfter(latest) ? at : latest);

  final namedGroups = <ShelfGroup>[
    for (final MapEntry(key: seriesId, value: volumes) in itemsBySeries.entries)
      _seriesGroup(seriesById[seriesId]!, volumes, preferred),
    for (final MapEntry(key: label, value: groupItems) in itemsByGroupLabel.entries)
      ShelfGroup(
        id: 'group:${normalizeForSearch(label)}',
        label: label,
        isSeries: false,
        ownedCount: groupItems.length,
        entries: [
          ShelfDivider(label: label, groupId: 'group:${normalizeForSearch(label)}'),
          for (final item in [...groupItems]..sort(byShelfOrder)) ShelfItem(item),
        ],
      ),
  ]..sort((first, second) {
      if (sortsByRecentPlay) {
        final (firstPlayed, secondPlayed) = (lastPlayedIn(itemsByGroupLabel[first.label] ?? const []), lastPlayedIn(itemsByGroupLabel[second.label] ?? const []));
        if (firstPlayed != secondPlayed) {
          return switch ((firstPlayed, secondPlayed)) {
            (null, _) => 1,
            (_, null) => -1,
            (final firstAt?, final secondAt?) => secondAt.compareTo(firstAt),
          };
        }
      }
      return normalizeForSearch(first.label).compareTo(normalizeForSearch(second.label));
    });

  return [
    ...namedGroups,
    if (ungroupedItems.isNotEmpty)
      ShelfGroup(
        id: 'ungrouped',
        label: '',
        isSeries: false,
        ownedCount: ungroupedItems.length,
        entries: [
          for (final item in [...ungroupedItems]..sort(byShelfOrder)) ShelfItem(item),
        ],
      ),
  ];
}

ShelfGroup _seriesGroup(Series series, List<CollectionItem> volumes, PreferredLanguages preferred) {
  final label = resolveDisplayTitle(series.titles, preferred) ?? '';
  final numbered = {for (final volume in volumes.where((volume) => volume.volumeNumber != null)) volume.volumeNumber!: volume};
  final unnumbered = volumes.where((volume) => volume.volumeNumber == null);
  final highestNumbered = numbered.isEmpty ? 0 : numbered.keys.reduce((first, second) => first > second ? first : second);
  final highestOwned = (series.publishedVolumes ?? 0) > highestNumbered ? series.publishedVolumes! : highestNumbered;
  return ShelfGroup(
    id: series.id,
    label: label,
    isSeries: true,
    ownedCount: volumes.length,
    entries: [
      ShelfDivider(label: label, groupId: series.id),
      for (var number = 1; number <= highestOwned; number++)
        if (numbered[number] case final volume?) ShelfItem(volume) else ShelfMissingVolume(seriesId: series.id, volumeNumber: number),
      for (final volume in unnumbered) ShelfItem(volume),
    ],
  );
}
