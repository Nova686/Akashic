import 'dart:isolate';
import 'dart:typed_data';

import 'package:akashic/layers/technical/Feedback/error_toasts.dart';
import 'package:akashic/layers/functional/Check/domain/entities/check_verdict.dart';
import 'package:akashic/layers/functional/Collection/domain/use_cases/search_text_normalizer.dart';
import 'package:akashic/layers/functional/Import/domain/entities/import_table.dart';
import 'package:akashic/layers/functional/Import/domain/use_cases/import_rows.dart';
import 'package:akashic/layers/functional/Import/domain/use_cases/map_import_columns.dart';
import 'package:akashic/layers/functional/Import/presentation/cubit/import_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ImportCubit extends Cubit<ImportState> {
  ImportCubit({required this._readSpreadsheet, required this._resolveLine, required this._importRows}) : super(const ImportState());

  final ImportTable Function(String fileName, Uint8List bytes) _readSpreadsheet;
  final ResolveImportLine _resolveLine;
  final ImportRows _importRows;

  void chooseCategory(String categoryId) => emit(state.copyWith(categoryId: categoryId));

  static const int backgroundReadThreshold = 512 * 1024;

  Future<void> loadFile(String fileName, Uint8List bytes) async {
    final read = _readSpreadsheet;
    try {
      final table = bytes.length > backgroundReadThreshold ? await Isolate.run(() => read(fileName, bytes)) : read(fileName, bytes);
      if (isClosed) {
        return;
      }
      emit(state.copyWith(step: ImportStep.mapColumns, table: table, mapping: guessColumnMapping(table.headers)));
    } on UnreadableSpreadsheet {
      emit(state.copyWith(notice: ImportNotice.unreadable));
    }
  }

  void mapColumn(int column, ImportField field) => emit(state.copyWith(mapping: {...state.mapping, column: field}));

  List<ImportLine> get _lines {
    final table = state.table;
    return table == null ? const [] : importLinesOf(table, state.mapping);
  }

  Future<void> startReview() async {
    final lines = _lines;
    if (lines.isEmpty || state.categoryId == null) {
      return;
    }
    emit(state.copyWith(step: ImportStep.review, entries: [for (final line in lines) ImportEntry(line: line, status: ImportEntryStatus.resolving)]));
    final seen = <String>{};
    for (final (index, line) in lines.indexed) {
      final identities = {
        if (line.barcode case final barcode?) 'barcode|$barcode',
        if (line.title case final title?) 'title|${normalizeForSearch(title)}|${normalizeForSearch(line.creator ?? '')}|${line.volumeNumber ?? ''}',
      };
      if (identities.any(seen.contains)) {
        emit(state.copyWith(entries: [...state.entries]..[index] = state.entries[index].copyWith(status: ImportEntryStatus.duplicateInFile)));
        continue;
      }
      seen.addAll(identities);
      CheckVerdict verdict;
      try {
        verdict = await _resolveLine(line);
      } on Exception {
        ErrorToasts.instance.show((l10n) => l10n.importLineFailedToast(line.rowNumber));
        verdict = NotOwned(null, line.searchText);
      }
      if (isClosed) {
        return;
      }
      final resolved = switch (verdict) {
        Owned() || OwnedOtherEdition() => state.entries[index].copyWith(status: ImportEntryStatus.alreadyOwned),
        NotOwned(:final match?) => state.entries[index].copyWith(status: ImportEntryStatus.found, match: match, isIncluded: true),
        _ => state.entries[index].copyWith(status: ImportEntryStatus.notFound),
      };
      emit(state.copyWith(entries: [...state.entries]..[index] = resolved));
    }
  }

  void toggle(int index) {
    final entry = state.entries[index];
    if (!entry.canBeIncluded) {
      return;
    }
    emit(state.copyWith(entries: [...state.entries]..[index] = entry.copyWith(isIncluded: !entry.isIncluded)));
  }

  Future<void> commit(String languageCode) async {
    final categoryId = state.categoryId;
    if (categoryId == null || state.isResolving || state.isCommitting) {
      return;
    }
    emit(state.copyWith(isCommitting: true));
    var added = state.addedCount;
    var failed = 0;
    for (final (index, entry) in state.entries.indexed) {
      if (!entry.isIncluded) {
        continue;
      }
      if (isClosed) {
        return;
      }
      ImportEntryStatus outcome;
      try {
        await _importRows(entry.line, categoryId: categoryId, languageCode: languageCode, match: entry.match);
        outcome = ImportEntryStatus.added;
        added++;
      } on Exception {
        outcome = ImportEntryStatus.failed;
        failed++;
      }
      if (isClosed) {
        return;
      }
      emit(state.copyWith(entries: [...state.entries]..[index] = entry.copyWith(status: outcome, isIncluded: false), addedCount: added));
    }
    if (!isClosed) {
      emit(state.copyWith(step: failed == 0 ? ImportStep.done : ImportStep.review, isCommitting: false, addedCount: added));
    }
  }
}
