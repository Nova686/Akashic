import 'package:akashic/layers/functional/Collection/domain/entities/collection_item.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/item_copy.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/item_progress.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/shelf_group.dart';
import 'package:akashic/layers/functional/Collection/domain/use_cases/resolve_display_title.dart';
import 'package:akashic/layers/functional/Collection/domain/use_cases/search_text_normalizer.dart';
import 'package:akashic/layers/functional/Settings/domain/entities/preferred_languages.dart';
import 'package:equatable/equatable.dart';

enum ShelfSort { bySeries, title, creator, newest, oldest, bestRated, recentlyAdded, pricePaid, location }

enum SealingFilter { sealed, opened }

const String arrangedGroupPrefix = 'arranged:';

class ShelfFilter extends Equatable {
  const ShelfFilter({this.progressStatus, this.minimumRating, this.sealing, this.onlyLent = false, this.location, this.tag});

  final ProgressStatus? progressStatus;
  final int? minimumRating;
  final SealingFilter? sealing;
  final bool onlyLent;
  final String? location;
  final String? tag;

  bool get isActive => activeCount > 0;

  int get activeCount => [progressStatus != null, minimumRating != null, sealing != null, onlyLent, location != null, tag != null].where((isSet) => isSet).length;

  bool accepts(CollectionItem item, [ItemCopy? copy, Set<String> tags = const {}]) {
    if (tag case final wanted? when !tags.contains(wanted)) {
      return false;
    }
    final status = progressStatus;
    if (status != null && (item.progress?.status ?? ProgressStatus.notStarted) != status) {
      return false;
    }
    final rating = minimumRating;
    if (rating != null && (item.rating ?? 0) < rating) {
      return false;
    }
    if (sealing case final wanted? when (copy?.isOpened ?? false) != (wanted == SealingFilter.opened)) {
      return false;
    }
    if (onlyLent && copy?.loanedTo == null) {
      return false;
    }
    return location == null || copy?.location == location;
  }

  @override
  List<Object?> get props => [progressStatus, minimumRating, sealing, onlyLent, location, tag];
}

List<ShelfGroup> arrangeShelf(List<ShelfGroup> groups, {required ShelfSort sort, required ShelfFilter filter, required PreferredLanguages languages, Map<String, ItemCopy> copies = const {}, Map<String, Set<String>> tags = const {}}) {
  if (sort == ShelfSort.bySeries) {
    return filter.isActive ? _filteredSeries(groups, filter, copies, tags) : groups;
  }
  final items = [
    for (final group in groups)
      for (final entry in group.entries)
        if (entry case ShelfItem(:final item) when filter.accepts(item, copies[item.id], tags[item.id] ?? const {})) item,
  ];
  String titleOf(CollectionItem item) => normalizeForSearch(resolveDisplayTitle(item.titles, languages) ?? '');
  int byTitle(CollectionItem first, CollectionItem second) {
    final byName = titleOf(first).compareTo(titleOf(second));
    return byName != 0 ? byName : (first.volumeNumber ?? 0).compareTo(second.volumeNumber ?? 0);
  }

  int missingLast<T extends Comparable<T>>(T? first, T? second, {required bool descending}) {
    if (first == null || second == null) {
      return first == null ? (second == null ? 0 : 1) : -1;
    }
    return descending ? second.compareTo(first) : first.compareTo(second);
  }

  items.sort((first, second) {
    final primary = switch (sort) {
      ShelfSort.bySeries || ShelfSort.title => 0,
      ShelfSort.creator => missingLast(first.creator == null ? null : normalizeForSearch(first.creator!), second.creator == null ? null : normalizeForSearch(second.creator!), descending: false),
      ShelfSort.newest => missingLast(first.year, second.year, descending: true),
      ShelfSort.oldest => missingLast(first.year, second.year, descending: false),
      ShelfSort.bestRated => missingLast(first.rating, second.rating, descending: true),
      ShelfSort.recentlyAdded => missingLast(first.addedAt, second.addedAt, descending: true),
      ShelfSort.pricePaid => missingLast(copies[first.id]?.pricePaidCents, copies[second.id]?.pricePaidCents, descending: true),
      ShelfSort.location => missingLast(copies[first.id]?.location == null ? null : normalizeForSearch(copies[first.id]!.location!), copies[second.id]?.location == null ? null : normalizeForSearch(copies[second.id]!.location!), descending: false),
    };
    return primary != 0 ? primary : byTitle(first, second);
  });
  String shelfLabelOf(CollectionItem item) => switch (sort) {
        ShelfSort.bySeries || ShelfSort.title => _initialOf(titleOf(item)),
        ShelfSort.creator => item.creator?.trim() ?? '',
        ShelfSort.newest || ShelfSort.oldest => item.year?.toString() ?? '',
        ShelfSort.bestRated => item.rating == null || item.rating == 0 ? '' : '★' * item.rating!,
        ShelfSort.recentlyAdded => item.addedAt?.year.toString() ?? '',
        ShelfSort.pricePaid => _priceRangeOf(copies[item.id]?.pricePaidCents),
        ShelfSort.location => copies[item.id]?.location?.trim() ?? '',
      };
  final itemsByLabel = <String, List<CollectionItem>>{};
  for (final item in items) {
    itemsByLabel.putIfAbsent(sort == ShelfSort.creator || sort == ShelfSort.location ? normalizeForSearch(shelfLabelOf(item)) : shelfLabelOf(item), () => []).add(item);
  }
  final arranged = [
    for (final MapEntry(key: key, value: shelfItems) in itemsByLabel.entries)
      ShelfGroup(
        id: '$arrangedGroupPrefix${sort.name}:$key',
        label: shelfLabelOf(shelfItems.first),
        entries: [for (final item in shelfItems) ShelfItem(item)],
        isSeries: false,
        ownedCount: shelfItems.length,
      ),
  ];
  return [
    ...arranged.where((group) => group.label.isNotEmpty),
    ...arranged.where((group) => group.label.isEmpty),
  ];
}

bool isArrangedGroup(ShelfGroup group) => group.id.startsWith(arrangedGroupPrefix);

String _initialOf(String normalizedTitle) {
  final initial = normalizedTitle.isEmpty ? '' : normalizedTitle.substring(0, 1).toUpperCase();
  return RegExp(r'\p{L}', unicode: true).hasMatch(initial) ? initial : '#';
}

String _priceRangeOf(int? cents) => switch (cents) {
      null => '',
      < 1000 => '< 10 €',
      < 3000 => '10 – 30 €',
      < 10000 => '30 – 100 €',
      _ => '> 100 €',
    };

List<ShelfGroup> _filteredSeries(List<ShelfGroup> groups, ShelfFilter filter, Map<String, ItemCopy> copies, Map<String, Set<String>> tags) => [
      for (final group in groups)
        if ([for (final entry in group.entries) if (entry case ShelfItem(:final item) when filter.accepts(item, copies[item.id], tags[item.id] ?? const {})) ShelfItem(item)] case final kept when kept.isNotEmpty)
          ShelfGroup(id: group.id, label: group.label, entries: kept, isSeries: group.isSeries, ownedCount: kept.length),
    ];
