import 'dart:typed_data';

import 'package:akashic/layers/functional/Catalog/domain/entities/category_type.dart';
import 'package:akashic/layers/functional/Check/domain/gateways/cover_image_gateway.dart';
import 'package:akashic/layers/functional/Check/domain/use_cases/add_from_match.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/collection_item.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/item_progress.dart';
import 'package:akashic/layers/functional/Collection/domain/gateways/collection_gateway.dart';
import 'package:akashic/layers/functional/Lookup/domain/entities/source_match.dart';
import 'package:equatable/equatable.dart';

enum LibraryService { steam, itchIo, trakt, anilist, myAnimeList, openLibrary, boardGameGeek, rebrickable, playnite }

enum AccountField { accountName, accountAndPassword, apiKey }

enum LibraryProblem { unknownAccount, privateLibrary }

class LibraryNotFound implements Exception {
  const LibraryNotFound(this.service, {this.problem = LibraryProblem.unknownAccount});

  final LibraryService service;
  final LibraryProblem problem;
}

String libraryEntryKeyOf(LibraryEntry entry) => '${entry.match.sourceKey}|${entry.match.externalWorkId}';

class LibraryEntry extends Equatable {
  const LibraryEntry(this.match, {this.progress, this.needsLookup = false});

  final SourceMatch match;
  final ProgressStatus? progress;
  final bool needsLookup;

  @override
  List<Object?> get props => [match, progress, needsLookup];
}

typedef MatchLookup = Future<SourceMatch?> Function(SourceMatch provisional);

typedef CoverLookup = Future<String?> Function(SourceMatch match);

abstract interface class LibrarySource {
  LibraryService get service;
  CategoryType get categoryType;
  bool get isConfigured;
}

abstract interface class AccountLibrary implements LibrarySource {
  AccountField get accountField;
  Future<List<LibraryEntry>> entriesOf(String accountName, {String password});
}

abstract interface class ExportFileLibrary implements LibrarySource {
  Future<List<LibraryEntry>> entriesOf(String fileName, Uint8List bytes);
}

class LibraryImportOutcome extends Equatable {
  const LibraryImportOutcome({required this.added, required this.alreadyOwned, required this.failed, this.seenKeys = const {}});

  final int added;
  final int alreadyOwned;
  final int failed;
  final Set<String> seenKeys;

  @override
  List<Object?> get props => [added, alreadyOwned, failed];
}

class ImportAccountLibrary {
  const ImportAccountLibrary(this._collection, this._addFromMatch, {this._lookUp, this._findCover, this._covers});

  final CollectionGateway _collection;
  final AddFromMatch _addFromMatch;
  final MatchLookup? _lookUp;
  final CoverLookup? _findCover;
  final CoverImageGateway? _covers;

  Future<LibraryImportOutcome> call(
    AccountLibrary library,
    String accountName, {
    String password = '',
    required String categoryId,
    Set<String> skippedKeys = const {},
    void Function(int done, int total)? onProgress,
  }) async =>
      _import(await library.entriesOf(accountName.trim(), password: password), categoryId: categoryId, skippedKeys: skippedKeys, onProgress: onProgress);

  Future<LibraryImportOutcome> fromFile(ExportFileLibrary library, String fileName, Uint8List bytes, {required String categoryId, void Function(int done, int total)? onProgress}) async =>
      _import(await library.entriesOf(fileName, bytes), categoryId: categoryId, onProgress: onProgress, keepsUnresolved: true);

  Future<SourceMatch?> _resolve(LibraryEntry entry, {required bool keepsUnresolved}) async {
    final lookUp = _lookUp;
    if (!entry.needsLookup || lookUp == null) {
      return entry.match;
    }
    final SourceMatch? found;
    try {
      found = await lookUp(entry.match);
    } on Exception {
      return keepsUnresolved ? entry.match : null;
    }
    if (found == null) {
      return entry.match;
    }
    final provisional = entry.match;
    return SourceMatch(
      sourceKey: found.sourceKey,
      externalWorkId: found.externalWorkId,
      externalEditionId: found.externalEditionId,
      titles: found.titles,
      creator: found.creator ?? provisional.creator,
      year: found.year ?? provisional.year,
      publisher: found.publisher ?? provisional.publisher,
      imageUrl: found.imageUrl ?? provisional.imageUrl,
      format: provisional.format ?? found.format,
      platform: provisional.platform ?? found.platform,
      suggestedType: provisional.suggestedType,
    );
  }

  Future<void> _fillMissingCover(CollectionItem? item, SourceMatch match) async {
    final covers = _covers;
    final findCover = _findCover;
    if (item == null || item.imagePath != null || covers == null || findCover == null) {
      return;
    }
    try {
      final coverUrl = await findCover(match);
      if (coverUrl == null) {
        return;
      }
      if (await covers.storeCover(coverUrl) case final stored?) {
        await _collection.saveCover(item.id, imagePath: stored.path, spineColorValue: stored.spineColorValue);
      }
    } on Exception {
      return;
    }
  }

  Future<SourceMatch> _withCover(SourceMatch match) async {
    final findCover = _findCover;
    if (match.imageUrl != null || findCover == null) {
      return match;
    }
    try {
      return switch (await findCover(match)) {
        final coverUrl? => match.withImageUrl(coverUrl),
        null => match,
      };
    } on Exception {
      return match;
    }
  }

  Future<LibraryImportOutcome> _import(List<LibraryEntry> allEntries, {required String categoryId, Set<String> skippedKeys = const {}, void Function(int done, int total)? onProgress, bool keepsUnresolved = false}) async {
    for (final entry in allEntries) {
      if (skippedKeys.contains(libraryEntryKeyOf(entry))) {
        await _fillMissingCover(await _collection.findByExternalWork(entry.match.sourceKey, entry.match.externalWorkId), entry.match);
      }
    }
    final entries = [for (final entry in allEntries) if (!skippedKeys.contains(libraryEntryKeyOf(entry))) entry];
    var added = 0;
    var alreadyOwned = 0;
    var failed = 0;
    final handledKeys = {for (final entry in allEntries) if (skippedKeys.contains(libraryEntryKeyOf(entry))) libraryEntryKeyOf(entry)};
    for (final (index, entry) in entries.indexed) {
      final match = await _resolve(entry, keepsUnresolved: keepsUnresolved);
      if (match == null) {
        failed++;
      } else if (await _ownedAs(match) ?? await _ownedAs(entry.match) case final owned?) {
        await _fillMissingCover(owned, match);
        alreadyOwned++;
        handledKeys.add(libraryEntryKeyOf(entry));
      } else {
        try {
          final item = await _addFromMatch(await _withCover(match), categoryId: categoryId);
          await _fillMissingCover(item, match);
          if (entry.progress case final status? when status != ProgressStatus.notStarted) {
            await _collection.saveProgress(item.id, ItemProgress(status: status));
          }
          added++;
          handledKeys.add(libraryEntryKeyOf(entry));
        } on Exception {
          failed++;
        }
      }
      onProgress?.call(index + 1, entries.length);
    }
    return LibraryImportOutcome(added: added, alreadyOwned: alreadyOwned, failed: failed, seenKeys: handledKeys);
  }

  Future<CollectionItem?> _ownedAs(SourceMatch match) => _collection.findByExternalWork(match.sourceKey, match.externalWorkId);
}
