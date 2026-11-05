import 'package:akashic/layers/functional/Import/domain/entities/import_table.dart';
import 'package:akashic/layers/functional/Lookup/domain/entities/source_match.dart';
import 'package:equatable/equatable.dart';

enum ImportStep { chooseFile, mapColumns, review, done }

enum ImportEntryStatus { resolving, found, alreadyOwned, notFound, duplicateInFile, added, failed }

enum ImportNotice { none, unreadable }

class ImportEntry extends Equatable {
  const ImportEntry({required this.line, required this.status, this.match, this.isIncluded = false});

  final ImportLine line;
  final ImportEntryStatus status;
  final SourceMatch? match;
  final bool isIncluded;

  bool get canBeIncluded => status == ImportEntryStatus.found || status == ImportEntryStatus.notFound || status == ImportEntryStatus.failed;

  ImportEntry copyWith({ImportEntryStatus? status, SourceMatch? match, bool? isIncluded}) =>
      ImportEntry(line: line, status: status ?? this.status, match: match ?? this.match, isIncluded: isIncluded ?? this.isIncluded);

  @override
  List<Object?> get props => [line, status, match, isIncluded];
}

class ImportState extends Equatable {
  const ImportState({
    this.step = ImportStep.chooseFile,
    this.categoryId,
    this.table,
    this.mapping = const {},
    this.entries = const [],
    this.isCommitting = false,
    this.addedCount = 0,
    this.notice = ImportNotice.none,
  });

  final ImportStep step;
  final String? categoryId;
  final ImportTable? table;
  final Map<int, ImportField> mapping;
  final List<ImportEntry> entries;
  final bool isCommitting;
  final int addedCount;
  final ImportNotice notice;

  int get resolvedCount => entries.where((entry) => entry.status != ImportEntryStatus.resolving).length;

  bool get isResolving => entries.any((entry) => entry.status == ImportEntryStatus.resolving);

  int get includedCount => entries.where((entry) => entry.isIncluded).length;

  ImportState copyWith({
    ImportStep? step,
    String? categoryId,
    ImportTable? table,
    Map<int, ImportField>? mapping,
    List<ImportEntry>? entries,
    bool? isCommitting,
    int? addedCount,
    ImportNotice? notice,
  }) {
    return ImportState(
      step: step ?? this.step,
      categoryId: categoryId ?? this.categoryId,
      table: table ?? this.table,
      mapping: mapping ?? this.mapping,
      entries: entries ?? this.entries,
      isCommitting: isCommitting ?? this.isCommitting,
      addedCount: addedCount ?? this.addedCount,
      notice: notice ?? ImportNotice.none,
    );
  }

  @override
  List<Object?> get props => [step, categoryId, table, mapping, entries, isCommitting, addedCount, notice];
}
