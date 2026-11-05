import 'package:akashic/layers/functional/Collection/domain/entities/collection_item.dart';
import 'package:equatable/equatable.dart';

sealed class ShelfEntry extends Equatable {
  const ShelfEntry();
}

class ShelfDivider extends ShelfEntry {
  const ShelfDivider({required this.label, required this.groupId});

  final String label;
  final String groupId;

  @override
  List<Object?> get props => [label, groupId];
}

class ShelfGap extends ShelfEntry {
  const ShelfGap();

  @override
  List<Object?> get props => const [];
}

class ShelfItem extends ShelfEntry {
  const ShelfItem(this.item);

  final CollectionItem item;

  @override
  List<Object?> get props => [item];
}

class ShelfMissingVolume extends ShelfEntry {
  const ShelfMissingVolume({required this.seriesId, required this.volumeNumber});

  final String seriesId;
  final int volumeNumber;

  @override
  List<Object?> get props => [seriesId, volumeNumber];
}

class ShelfGroup extends Equatable {
  const ShelfGroup({required this.id, required this.label, required this.entries, required this.isSeries, required this.ownedCount});

  final String id;
  final String label;
  final List<ShelfEntry> entries;
  final bool isSeries;
  final int ownedCount;

  bool get isIncomplete => entries.any((entry) => entry is ShelfMissingVolume);

  @override
  List<Object?> get props => [id, label, entries, isSeries, ownedCount];
}
