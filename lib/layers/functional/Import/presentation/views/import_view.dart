import 'dart:convert';
import 'dart:typed_data';

import 'package:akashic/layers/functional/Catalog/domain/entities/category.dart';
import 'package:akashic/layers/functional/Collection/domain/use_cases/resolve_display_title.dart';
import 'package:akashic/layers/functional/Import/domain/entities/import_table.dart';
import 'package:akashic/layers/functional/Import/domain/use_cases/map_import_columns.dart';
import 'package:akashic/layers/functional/Import/presentation/cubit/import_cubit.dart';
import 'package:akashic/layers/functional/Import/presentation/cubit/import_state.dart';
import 'package:akashic/layers/functional/Settings/domain/entities/preferred_languages.dart';
import 'package:akashic/layers/technical/Localization/app_localizations.dart';
import 'package:akashic/layers/technical/MediaStorage/spreadsheet_files.dart';
import 'package:akashic/layers/technical/Theme/akashic_animation.dart';
import 'package:akashic/layers/technical/Theme/akashic_colors.dart';
import 'package:akashic/layers/technical/Theme/akashic_typography.dart';
import 'package:akashic/layers/technical/Theme/safe_scroll_padding.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

extension ImportFieldLabel on ImportField {
  String label(AppLocalizations l10n) => switch (this) {
        ImportField.ignored => l10n.importFieldIgnored,
        ImportField.title => l10n.importFieldTitle,
        ImportField.creator => l10n.importFieldCreator,
        ImportField.barcode => l10n.importFieldBarcode,
        ImportField.edition => l10n.importFieldEdition,
        ImportField.price => l10n.importFieldPrice,
        ImportField.location => l10n.importFieldLocation,
        ImportField.condition => l10n.importFieldCondition,
        ImportField.year => l10n.importFieldYear,
        ImportField.series => l10n.importFieldSeries,
        ImportField.volume => l10n.importFieldVolume,
      };
}

Uint8List importTemplate(AppLocalizations l10n) {
  final headers = [for (final field in ImportField.values.skip(1)) field.label(l10n)];
  return Uint8List.fromList(utf8.encode('﻿${headers.join(';')}\r\n'));
}

class ImportView extends StatelessWidget {
  const ImportView({required this.categories, required this.files, super.key});

  final List<Category> categories;
  final SpreadsheetFiles files;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return BlocConsumer<ImportCubit, ImportState>(
      listenWhen: (previous, current) => current.notice != ImportNotice.none,
      listener: (context, state) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.unreadableSpreadsheet))),
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(title: Text(l10n.importCollection, style: AkashicTypography.body(size: 18, weight: FontWeight.w700))),
          body: switch (state.step) {
            ImportStep.chooseFile => _ChooseFileStep(state: state, categories: categories, files: files),
            ImportStep.mapColumns => _MapColumnsStep(state: state),
            ImportStep.review => _ReviewStep(state: state),
            ImportStep.done => _DoneStep(addedCount: state.addedCount),
          },
        );
      },
    );
  }
}

class _ChooseFileStep extends StatelessWidget {
  const _ChooseFileStep({required this.state, required this.categories, required this.files});

  final ImportState state;
  final List<Category> categories;
  final SpreadsheetFiles files;

  Future<void> _pick(BuildContext context) async {
    final importCubit = context.read<ImportCubit>();
    final picked = await files.pick();
    if (picked != null) {
      importCubit.loadFile(picked.name, picked.bytes);
    }
  }

  Future<void> _saveTemplate(BuildContext context) async {
    final l10n = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);
    if (await files.save('akashic-import.csv', importTemplate(l10n))) {
      messenger.showSnackBar(SnackBar(content: Text(l10n.templateSaved)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final importCubit = context.read<ImportCubit>();
    return ListView(
      padding: safeListPadding(context, top: 12),
      children: [
        DropdownButtonFormField<String>(
          initialValue: state.categoryId,
          isExpanded: true,
          decoration: InputDecoration(labelText: l10n.importDestination),
          items: [for (final category in categories) DropdownMenuItem(value: category.id, child: Text(category.name, overflow: TextOverflow.ellipsis))],
          onChanged: (categoryId) {
            if (categoryId != null) {
              importCubit.chooseCategory(categoryId);
            }
          },
        ),
        const SizedBox(height: 20),
        FilledButton.icon(
          onPressed: state.categoryId == null ? null : () => _pick(context),
          icon: const Icon(Icons.upload_file),
          label: Text(l10n.chooseSpreadsheet),
        ),
        const SizedBox(height: 8),
        TextButton.icon(
          onPressed: () => _saveTemplate(context),
          icon: const Icon(Icons.download, color: AkashicColors.teal),
          label: Text(l10n.downloadTemplate, style: const TextStyle(color: AkashicColors.teal)),
        ),
      ],
    );
  }
}

class _MapColumnsStep extends StatelessWidget {
  const _MapColumnsStep({required this.state});

  final ImportState state;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final importCubit = context.read<ImportCubit>();
    final table = state.table!;
    final firstRow = table.rows.firstOrNull ?? const <String>[];
    final rowCount = importLinesOf(table, state.mapping).length;
    return ListView(
      padding: safeListPadding(context, top: 12),
      children: [
        Text(l10n.matchColumns, style: AkashicTypography.displayTitle(size: 24)),
        const SizedBox(height: 8),
        for (final (column, header) in table.headers.indexed)
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(header.isEmpty ? '—' : header, maxLines: 1, overflow: TextOverflow.ellipsis, style: AkashicTypography.body(weight: FontWeight.w700)),
            subtitle: Text(column < firstRow.length ? firstRow[column] : '', maxLines: 1, overflow: TextOverflow.ellipsis, style: AkashicTypography.body(size: 12).copyWith(color: AkashicColors.textSoft)),
            trailing: DropdownButton<ImportField>(
              value: state.mapping[column] ?? ImportField.ignored,
              items: [for (final field in ImportField.values) DropdownMenuItem(value: field, child: Text(field.label(l10n)))],
              onChanged: (field) => importCubit.mapColumn(column, field ?? ImportField.ignored),
            ),
          ),
        const SizedBox(height: 16),
        FilledButton(onPressed: rowCount == 0 ? null : importCubit.startReview, child: Text(l10n.continueWithRows(rowCount))),
      ],
    );
  }
}

class _ReviewStep extends StatelessWidget {
  const _ReviewStep({required this.state});

  final ImportState state;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final importCubit = context.read<ImportCubit>();
    return Column(
      children: [
        if (state.isResolving)
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 8, 18, 0),
            child: Column(
              children: [
                LinearProgressIndicator(value: state.entries.isEmpty ? null : state.resolvedCount / state.entries.length),
                const SizedBox(height: 4),
                Text(l10n.resolvingRows(state.resolvedCount, state.entries.length), style: AkashicTypography.body(size: 12).copyWith(color: AkashicColors.textSoft)),
              ],
            ),
          ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            itemCount: state.entries.length,
            itemBuilder: (context, index) {
              final entry = state.entries[index];
              final title = switch (entry.match) {
                final match? => resolveDisplayTitle(match.titles, PreferredLanguages.defaults),
                null => null,
              };
              return CheckboxListTile(
                contentPadding: EdgeInsets.zero,
                value: entry.isIncluded,
                onChanged: entry.canBeIncluded ? (_) => importCubit.toggle(index) : null,
                title: Text(title ?? entry.line.title ?? entry.line.barcode ?? '', maxLines: 1, overflow: TextOverflow.ellipsis),
                subtitle: Text(
                  l10n.importRowStatus(entry.line.rowNumber, switch (entry.status) {
                    ImportEntryStatus.resolving => l10n.checking,
                    ImportEntryStatus.found => l10n.importFound,
                    ImportEntryStatus.alreadyOwned => l10n.importAlreadyOwned,
                    ImportEntryStatus.notFound => l10n.importNotFound,
                    ImportEntryStatus.duplicateInFile => l10n.importDuplicateInFile,
                    ImportEntryStatus.added => l10n.importAdded,
                    ImportEntryStatus.failed => l10n.importFailed,
                  }),
                  style: AkashicTypography.body(size: 12).copyWith(color: entry.status == ImportEntryStatus.found ? AkashicColors.teal : AkashicColors.textSoft),
                ),
              );
            },
          ),
        ),
        SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(18, 8, 18, 12),
            child: SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: state.isResolving || state.isCommitting || state.includedCount == 0 ? null : () => importCubit.commit(l10n.localeName),
                child: Text(l10n.addImportedRows(state.includedCount)),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _DoneStep extends StatelessWidget {
  const _DoneStep({required this.addedCount});

  final int addedCount;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const AkashicLottie(AkashicAnimation.addedCheck, size: 110),
            const SizedBox(height: 12),
            Text(l10n.importedCount(addedCount), textAlign: TextAlign.center, style: AkashicTypography.displayTitle(size: 26)),
            const SizedBox(height: 16),
            FilledButton(onPressed: () => Navigator.of(context).maybePop(), child: Text(l10n.close)),
          ],
        ),
      ),
    );
  }
}
