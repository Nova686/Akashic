import 'dart:typed_data';

import 'package:akashic/layers/functional/Check/domain/entities/check_verdict.dart';
import 'package:akashic/layers/functional/Check/domain/entities/scan_session.dart';
import 'package:akashic/layers/functional/Check/domain/gateways/scan_history_gateway.dart';
import 'package:akashic/layers/functional/Check/domain/use_cases/add_from_match.dart';
import 'package:akashic/layers/functional/Check/domain/use_cases/check_ownership.dart';
import 'package:akashic/layers/functional/Check/domain/use_cases/cover_text_lines.dart';
import 'package:akashic/layers/functional/Check/domain/use_cases/normalize_barcode.dart';
import 'package:akashic/layers/functional/Check/domain/use_cases/suggest_category.dart';
import 'package:akashic/layers/functional/Check/presentation/cubit/chain_scan_state.dart';
import 'package:akashic/layers/functional/Check/presentation/widgets/cover_text_reader.dart';
import 'package:akashic/layers/functional/Check/presentation/widgets/shelf_spine_reader.dart';
import 'package:akashic/layers/functional/Check/domain/use_cases/shelf_spines.dart';
import 'package:akashic/layers/functional/Collection/domain/use_cases/resolve_display_title.dart';
import 'package:akashic/layers/functional/Lookup/domain/entities/source_match.dart';
import 'package:akashic/layers/functional/Catalog/domain/entities/category.dart';
import 'package:akashic/layers/functional/Settings/domain/entities/preferred_languages.dart';
import 'package:akashic/layers/functional/Wishes/domain/entities/wish.dart';
import 'package:akashic/layers/functional/Wishes/domain/use_cases/add_wish.dart';
import 'package:akashic/layers/functional/Wishes/domain/use_cases/find_wish_for.dart';
import 'package:akashic/layers/functional/Wishes/domain/use_cases/wish_for_match.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChainScanCubit extends Cubit<ChainScanState> {
  ChainScanCubit(this._checkOwnership, this._addFromMatch, this._suggestCategory, {this._coverTextReader, this._shelfSpineReader, this._findWishFor, this._addWish, this._addAnother, this._history, DateTime Function()? now})
      : _now = now ?? DateTime.now,
        super(const ChainScanState());

  final CheckOwnership _checkOwnership;
  final AddFromMatch _addFromMatch;
  final SuggestCategory _suggestCategory;
  final CoverTextReader? _coverTextReader;
  final ShelfSpineReader? _shelfSpineReader;
  final Future<String?> Function(String itemId, {String? barcode})? _addAnother;
  final FindWishFor? _findWishFor;
  final AddWish? _addWish;
  final ScanHistoryGateway? _history;
  final DateTime Function() _now;
  final Map<String, ShelfPhoto> _shelfPhotos = {};
  final List<ScanSessionEntry> _addedEntries = [];
  DateTime? _startedAt;
  Future<void> _processing = Future<void>.value();
  int _coverSequence = 0;
  int _shelfSequence = 0;
  int _failureSequence = 0;

  bool get canPhotographCovers => _coverTextReader != null;

  bool get canPhotographShelves => _shelfSpineReader != null;

  ShelfPhoto? shelfPhoto(String photoId) => _shelfPhotos[photoId];

  void photographShelf(Uint8List photo, {required String pendingLabel}) {
    final reader = _shelfSpineReader;
    if (reader == null) {
      return;
    }
    final entryId = 'shelf-${_shelfSequence++}';
    _append(ChainEntry(id: entryId, label: pendingLabel, source: ChainEntrySource.shelf, status: ChainEntryStatus.resolving));
    _processing = _processing.then((_) => _resolveShelf(entryId, photo, reader)).catchError((Object _) => _markUnreadable(entryId));
  }

  Future<void> _resolveShelf(String entryId, Uint8List photo, ShelfSpineReader reader) async {
    final ShelfReading reading;
    final List<SpineText> spines;
    try {
      reading = await reader.readShelf(photo);
      spines = spineReadingsOf(reading.spines);
    } on Exception {
      _replace(entryId, (entry) => entry.copyWith(status: ChainEntryStatus.unreadable));
      return;
    }
    if (isClosed) {
      return;
    }
    final known = {for (final entry in state.entries) entry.label};
    final fresh = [for (final spine in spines) if (!known.contains(spine.text)) spine];
    final hasPhoto = reading.photo != null && reading.width > 0 && reading.height > 0;
    if (hasPhoto) {
      _shelfPhotos[entryId] = ShelfPhoto(bytes: Uint8List.fromList(reading.photo!), width: reading.width, height: reading.height);
    }
    if (fresh.isEmpty) {
      _replace(entryId, (entry) => entry.copyWith(status: ChainEntryStatus.unreadable));
      return;
    }
    emit(ChainScanState(
      entries: [
        for (final entry in state.entries)
          if (entry.id != entryId) entry,
        for (final (index, spine) in fresh.indexed)
          ChainEntry(
            id: '$entryId-$index',
            label: spine.text,
            source: ChainEntrySource.shelf,
            status: ChainEntryStatus.resolving,
            shelfPhotoId: hasPhoto ? entryId : null,
            spineBounds: hasPhoto ? spine.bounds : null,
          ),
      ],
      isCommitting: state.isCommitting,
      lastFailure: state.lastFailure,
    ));
    for (final (index, spine) in fresh.indexed) {
      if (isClosed) {
        return;
      }
      CheckVerdict verdict;
      try {
        verdict = await _checkOwnership.spine(spine.text);
      } on Exception {
        verdict = CatalogsUnavailable(spine.text);
      }
      await _settle('$entryId-$index', verdict, label: spine.text);
    }
  }

  void scan(String raw) {
    final barcode = normalizeBarcode(raw);
    if (barcode == null || state.entries.any((entry) => entry.barcode == barcode)) {
      return;
    }
    _append(ChainEntry(id: barcode, label: barcode, barcode: barcode, status: ChainEntryStatus.resolving));
    _processing = _processing.then((_) => _resolveBarcode(barcode)).catchError((Object _) => _markUnreadable(barcode));
  }

  void photographCover(Uint8List photo, {required String pendingLabel}) {
    final reader = _coverTextReader;
    if (reader == null) {
      return;
    }
    final entryId = 'cover-${_coverSequence++}';
    _append(ChainEntry(id: entryId, label: pendingLabel, source: ChainEntrySource.cover, status: ChainEntryStatus.resolving));
    _processing = _processing.then((_) => _resolveCover(entryId, photo, reader)).catchError((Object _) => _markUnreadable(entryId));
  }

  void lookUpWords(String words) {
    final text = words.trim();
    if (text.isEmpty) {
      return;
    }
    final entryId = 'voice-${_coverSequence++}';
    _append(ChainEntry(id: entryId, label: text, source: ChainEntrySource.cover, status: ChainEntryStatus.resolving));
    _processing = _processing.then((_) => _resolveWords(entryId, text)).catchError((Object _) => _markUnreadable(entryId));
  }

  Future<void> _resolveWords(String entryId, String text) async {
    CheckVerdict verdict;
    try {
      verdict = await _checkOwnership.spine(text);
    } on Exception {
      verdict = CatalogsUnavailable(text);
    }
    await _settle(entryId, verdict, label: text);
  }

  Future<void> whenIdle() => _processing;

  void _markUnreadable(String entryId) => _replace(entryId, (entry) => entry.status == ChainEntryStatus.resolving ? entry.copyWith(status: ChainEntryStatus.unreadable) : entry);

  void _append(ChainEntry entry) {
    _startedAt ??= _now();
    emit(ChainScanState(entries: [...state.entries, entry], isCommitting: state.isCommitting));
  }


  Future<void> _resolveBarcode(String barcode) async {
    CheckVerdict verdict;
    try {
      verdict = await _checkOwnership.barcode(barcode);
    } on Exception {
      verdict = CatalogsUnavailable(barcode);
    }
    await _settle(barcode, verdict, label: barcode);
  }

  Future<void> _resolveCover(String entryId, Uint8List photo, CoverTextReader reader) async {
    final List<String> lines;
    try {
      lines = prominentCoverLines(await reader.readLines(photo));
    } on Exception {
      _replace(entryId, (entry) => entry.copyWith(status: ChainEntryStatus.unreadable));
      return;
    }
    if (lines.isEmpty) {
      _replace(entryId, (entry) => entry.copyWith(status: ChainEntryStatus.unreadable));
      return;
    }
    CheckVerdict verdict;
    try {
      verdict = await _checkOwnership.cover(lines);
    } on Exception {
      verdict = CatalogsUnavailable(lines.first);
    }
    await _settle(entryId, verdict, label: lines.first);
  }

  Future<void> _settle(String entryId, CheckVerdict verdict, {required String label}) async {
    if (verdict case NotOwned(:final match?)) {
      final barcode = state.entries.where((entry) => entry.id == entryId).firstOrNull?.barcode;
      final targetCategory = await _suggestCategory.forMatch(match);
      final isWished = await _isWished(match, barcode);
      _replace(entryId, (entry) => entry.copyWith(
            label: label,
            status: ChainEntryStatus.found,
            match: match,
            targetCategory: targetCategory,
            isAccepted: targetCategory != null,
            isWished: isWished,
          ));
      return;
    }
    _replace(entryId, (entry) => switch (verdict) {
          Owned(:final item) || OwnedOtherEdition(:final item) => entry.copyWith(
              label: label,
              status: ChainEntryStatus.alreadyOwned,
              ownedTitle: resolveDisplayTitle(item.titles, PreferredLanguages.defaults),
              ownedItemId: item.id,
              ownedImagePath: item.imagePath,
            ),
          CatalogsUnavailable(:final isRateLimited) =>
            entry.copyWith(label: label, status: isRateLimited ? ChainEntryStatus.rateLimited : ChainEntryStatus.unreachable),
          NotOwned() => entry.copyWith(label: label, status: ChainEntryStatus.notFound),
        });
  }

  Future<bool> _isWished(SourceMatch match, String? barcode) async {
    final findWishFor = _findWishFor;
    if (findWishFor == null) {
      return false;
    }
    return await findWishFor(wishKeyForMatch(match, scannedBarcode: barcode)) != null;
  }

  bool get canAddToWishes => _addWish != null;

  bool get canAddAnother => _addAnother != null;

  Future<void> addAnotherOf(int index) async {
    final entry = state.entries[index];
    final addAnother = _addAnother;
    final itemId = entry.ownedItemId;
    if (addAnother == null || itemId == null || entry.status != ChainEntryStatus.alreadyOwned) {
      return;
    }
    if (await addAnother(itemId, barcode: entry.barcode) != null) {
      _replace(entry.id, (current) => current.copyWith(addedAgainCount: current.addedAgainCount + 1));
    }
  }

  void moveTo(int index, Category category) {
    final entry = state.entries[index];
    if (entry.status != ChainEntryStatus.found) {
      return;
    }
    final entries = [...state.entries]..[index] = entry.copyWith(targetCategory: category, isAccepted: true);
    emit(ChainScanState(entries: entries, isCommitting: state.isCommitting, lastFailure: state.lastFailure));
  }

  Future<void> addToWishes(int index) async {
    final entry = state.entries[index];
    final addWish = _addWish;
    final match = entry.match;
    if (addWish == null || match == null || entry.isWished) {
      return;
    }
    await addWish(wishDraftForMatch(
      match,
      title: resolveDisplayTitle(match.titles, PreferredLanguages.defaults) ?? entry.label,
      origin: WishOrigin.search,
      categoryId: entry.targetCategory?.id,
      scannedBarcode: entry.barcode,
    ));
    _replace(entry.id, (current) => current.copyWith(isWished: true));
  }

  void _replace(String entryId, ChainEntry Function(ChainEntry entry) update) {
    if (isClosed) {
      return;
    }
    ChainFailure? failure;
    final entries = [
      for (final entry in state.entries)
        if (entry.id == entryId) update(entry) else entry,
    ];
    final updated = entries.where((entry) => entry.id == entryId).firstOrNull;
    if (updated != null && updated.hasFailed) {
      failure = ChainFailure(sequence: _failureSequence++, label: updated.label, status: updated.status);
    }
    emit(ChainScanState(entries: entries, isCommitting: state.isCommitting, lastFailure: failure ?? state.lastFailure));
  }

  void toggle(int index) {
    final entry = state.entries[index];
    if (!entry.canBeAdded) {
      return;
    }
    final entries = [...state.entries]..[index] = entry.copyWith(isAccepted: !entry.isAccepted);
    emit(ChainScanState(entries: entries, isCommitting: state.isCommitting, lastFailure: state.lastFailure));
  }

  void remove(int index) => emit(ChainScanState(entries: [...state.entries]..removeAt(index), isCommitting: state.isCommitting, lastFailure: state.lastFailure));

  bool _isCommitting = false;

  Future<int> commit() async {
    if (_isCommitting) {
      return 0;
    }
    _isCommitting = true;
    try {
      return await _commit();
    } finally {
      _isCommitting = false;
    }
  }

  Future<int> _commit() async {
    await whenIdle();
    if (isClosed) {
      return 0;
    }
    emit(ChainScanState(entries: state.entries, isCommitting: true, lastFailure: state.lastFailure));
    final addedIds = <String>{};
    var failed = 0;
    final accepted = state.entries.where((entry) => entry.isAccepted && entry.canBeAdded).toList();
    for (final entry in accepted) {
      if (isClosed) {
        break;
      }
      try {
        final item = await _addFromMatch(entry.match!, categoryId: entry.targetCategory!.id, barcode: entry.barcode);
        addedIds.add(entry.id);
        _addedEntries.add(ScanSessionEntry(title: _titleOf(entry), outcome: ScanOutcome.added, source: _sourceOf(entry), itemId: item.id));
      } on Exception {
        failed++;
      }
    }
    if (!isClosed) {
      emit(ChainScanState(
        entries: [for (final entry in state.entries) if (!addedIds.contains(entry.id)) entry],
        addedCount: addedIds.length,
        failedAddCount: failed,
        lastFailure: state.lastFailure,
      ));
    }
    return addedIds.length;
  }

  String _titleOf(ChainEntry entry) => switch (entry) {
        ChainEntry(:final match?) => resolveDisplayTitle(match.titles, PreferredLanguages.defaults) ?? entry.label,
        ChainEntry(:final ownedTitle?) => ownedTitle,
        _ => entry.label,
      };

  ScanSource _sourceOf(ChainEntry entry) => switch (entry.source) {
        ChainEntrySource.barcode => ScanSource.barcode,
        ChainEntrySource.cover => ScanSource.cover,
        ChainEntrySource.shelf => ScanSource.shelf,
      };

  List<ScanSessionEntry> get sessionEntries => [
        ..._addedEntries,
        for (final entry in state.entries)
          if (entry.status == ChainEntryStatus.alreadyOwned)
            ScanSessionEntry(title: _titleOf(entry), outcome: ScanOutcome.owned, source: _sourceOf(entry), itemId: entry.ownedItemId)
          else if (entry.status != ChainEntryStatus.resolving)
            ScanSessionEntry(title: _titleOf(entry), outcome: ScanOutcome.missed, source: _sourceOf(entry)),
      ];

  Future<void> _recordSession() async {
    final history = _history;
    final startedAt = _startedAt;
    final entries = sessionEntries;
    if (history == null || startedAt == null || entries.isEmpty) {
      return;
    }
    try {
      await history.save(ScanSession(id: 'scan-${startedAt.microsecondsSinceEpoch}', startedAt: startedAt, mode: dominantSourceOf(entries), entries: entries));
    } on Exception {
      return;
    }
  }

  @override
  Future<void> close() async {
    await _recordSession();
    return super.close();
  }
}
