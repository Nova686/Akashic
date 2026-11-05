import 'dart:typed_data';

import 'package:akashic/layers/functional/Catalog/domain/entities/category.dart';
import 'package:akashic/layers/functional/Check/domain/use_cases/shelf_spines.dart';
import 'package:akashic/layers/functional/Lookup/domain/entities/source_match.dart';
import 'package:equatable/equatable.dart';

enum ChainEntryStatus { resolving, found, alreadyOwned, notFound, unreadable, rateLimited, unreachable }

enum ChainEntrySource { barcode, cover, shelf }

class ChainEntry extends Equatable {
  const ChainEntry({
    required this.id,
    required this.label,
    required this.status,
    this.barcode,
    this.source = ChainEntrySource.barcode,
    this.match,
    this.ownedTitle,
    this.ownedItemId,
    this.ownedImagePath,
    this.targetCategory,
    this.isAccepted = false,
    this.isWished = false,
    this.addedAgainCount = 0,
    this.shelfPhotoId,
    this.spineBounds,
  });

  final String id;
  final String label;
  final String? barcode;
  final ChainEntrySource source;
  final ChainEntryStatus status;
  final SourceMatch? match;
  final String? ownedTitle;
  final String? ownedItemId;
  final String? ownedImagePath;
  final Category? targetCategory;
  final bool isAccepted;
  final bool isWished;
  final int addedAgainCount;
  final String? shelfPhotoId;
  final SpineBounds? spineBounds;

  bool get isFromCover => barcode == null;

  bool get canBeAdded => status == ChainEntryStatus.found && targetCategory != null;

  bool get hasFailed => const {ChainEntryStatus.notFound, ChainEntryStatus.unreadable, ChainEntryStatus.rateLimited, ChainEntryStatus.unreachable}.contains(status);

  ChainEntry copyWith({
    String? label,
    ChainEntryStatus? status,
    SourceMatch? match,
    String? ownedTitle,
    String? ownedItemId,
    String? ownedImagePath,
    Category? targetCategory,
    bool? isAccepted,
    bool? isWished,
    int? addedAgainCount,
  }) {
    return ChainEntry(
      id: id,
      label: label ?? this.label,
      barcode: barcode,
      source: source,
      status: status ?? this.status,
      match: match ?? this.match,
      ownedTitle: ownedTitle ?? this.ownedTitle,
      ownedItemId: ownedItemId ?? this.ownedItemId,
      ownedImagePath: ownedImagePath ?? this.ownedImagePath,
      targetCategory: targetCategory ?? this.targetCategory,
      isAccepted: isAccepted ?? this.isAccepted,
      isWished: isWished ?? this.isWished,
      addedAgainCount: addedAgainCount ?? this.addedAgainCount,
      shelfPhotoId: shelfPhotoId,
      spineBounds: spineBounds,
    );
  }

  @override
  List<Object?> get props => [id, label, barcode, source, status, match, ownedTitle, ownedItemId, ownedImagePath, targetCategory, isAccepted, isWished, addedAgainCount, shelfPhotoId, spineBounds];
}

class ShelfPhoto {
  const ShelfPhoto({required this.bytes, required this.width, required this.height});

  final Uint8List bytes;
  final int width;
  final int height;
}

class ChainFailure extends Equatable {
  const ChainFailure({required this.sequence, required this.label, required this.status});

  final int sequence;
  final String label;
  final ChainEntryStatus status;

  @override
  List<Object?> get props => [sequence, label, status];
}

class ChainScanState extends Equatable {
  const ChainScanState({this.entries = const [], this.isCommitting = false, this.addedCount, this.failedAddCount = 0, this.lastFailure});

  final List<ChainEntry> entries;
  final bool isCommitting;
  final int? addedCount;
  final int failedAddCount;
  final ChainFailure? lastFailure;

  int get acceptedCount => entries.where((entry) => entry.isAccepted && entry.canBeAdded).length;

  bool get isResolving => entries.any((entry) => entry.status == ChainEntryStatus.resolving);

  @override
  List<Object?> get props => [entries, isCommitting, addedCount, failedAddCount, lastFailure];
}
