import 'package:akashic/layers/functional/Import/domain/use_cases/import_account_library.dart';
import 'package:akashic/layers/functional/Import/presentation/cubit/account_import_cubit.dart';
import 'package:akashic/layers/technical/Localization/app_localizations.dart';
import 'package:akashic/layers/technical/Theme/akashic_animation.dart';
import 'package:akashic/layers/technical/Theme/akashic_colors.dart';
import 'package:akashic/layers/technical/Theme/akashic_empty_state.dart';
import 'package:akashic/layers/technical/Theme/akashic_typography.dart';
import 'package:akashic/layers/technical/Theme/safe_scroll_padding.dart';
import 'package:akashic/layers/technical/MediaStorage/spreadsheet_files.dart';
import 'package:akashic/layers/functional/Import/domain/entities/linked_account_sync_progress.dart';
import 'package:akashic/layers/functional/Import/presentation/widgets/sync_progress_banner.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

String libraryServiceName(LibraryService service) => switch (service) {
      LibraryService.steam => 'Steam',
      LibraryService.itchIo => 'itch.io',
      LibraryService.myAnimeList => 'MyAnimeList',
      LibraryService.rebrickable => 'Rebrickable',
      LibraryService.trakt => 'Trakt',
      LibraryService.anilist => 'AniList',
      LibraryService.openLibrary => 'Open Library',
      LibraryService.boardGameGeek => 'BoardGameGeek',
      LibraryService.playnite => 'Playnite',
    };

IconData libraryServiceIcon(LibraryService service) => switch (service) {
      LibraryService.steam => Icons.sports_esports_outlined,
      LibraryService.itchIo => Icons.storefront_outlined,
      LibraryService.myAnimeList => Icons.auto_stories_outlined,
      LibraryService.rebrickable => Icons.extension_outlined,
      LibraryService.trakt => Icons.movie_outlined,
      LibraryService.anilist => Icons.auto_stories_outlined,
      LibraryService.openLibrary => Icons.menu_book_outlined,
      LibraryService.boardGameGeek => Icons.casino_outlined,
      LibraryService.playnite => Icons.videogame_asset_outlined,
    };

class AccountImportView extends StatelessWidget {
  const AccountImportView({required this.files, this.syncProgress, this.initialSyncProgress, super.key});

  final SpreadsheetFiles files;
  final Stream<LinkedAccountSyncProgress?>? syncProgress;
  final LinkedAccountSyncProgress? initialSyncProgress;

  String _explanation(AppLocalizations l10n, LibraryService service) => switch (service) {
        LibraryService.steam => l10n.steamImportExplanation,
        LibraryService.itchIo => l10n.itchIoImportExplanation,
        LibraryService.myAnimeList => l10n.myAnimeListImportExplanation,
        LibraryService.rebrickable => l10n.rebrickableImportExplanation,
        LibraryService.trakt => l10n.traktImportExplanation,
        LibraryService.anilist => l10n.anilistImportExplanation,
        LibraryService.openLibrary => l10n.openLibraryImportExplanation,
        LibraryService.boardGameGeek => l10n.boardGameGeekImportExplanation,
        LibraryService.playnite => l10n.playniteImportExplanation,
      };

  String _accountHint(AppLocalizations l10n, LibraryService service) => switch (service) {
        LibraryService.steam => l10n.steamAccountHint,
        _ => l10n.accountNameHint,
      };

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final importCubit = context.read<AccountImportCubit>();
    return BlocBuilder<AccountImportCubit, AccountImportState>(
      builder: (context, state) {
        final isImporting = state.status == AccountImportStatus.importing;
        final targets = importCubit.targetCategories;
        return Scaffold(
          appBar: AppBar(title: Text(l10n.accountImportTitle, style: AkashicTypography.body(size: 18, weight: FontWeight.w700))),
          body: ListView(
            padding: safeListPadding(context, top: 12),
            children: [
              if (state.linkedAccounts.isNotEmpty) ...[
                Text(l10n.linkedAccountsTitle, style: AkashicTypography.body(size: 15, weight: FontWeight.w800)),
                for (final linked in state.linkedAccounts)
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Icon(libraryServiceIcon(linked.service), color: AkashicColors.teal),
                    title: Text('${libraryServiceName(linked.service)} · ${linked.accountName}'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text([
                          ?importCubit.categoryNameOf(linked.categoryId),
                          if (linked.lastSyncedAt case final syncedAt?) l10n.lastSyncedAt(DateFormat.MMMd(l10n.localeName).add_Hm().format(syncedAt)),
                        ].join(' · ')),
                        if (syncProgress case final progress?)
                          StreamBuilder<LinkedAccountSyncProgress?>(
                            stream: progress,
                            initialData: initialSyncProgress,
                            builder: (context, snapshot) => switch (snapshot.data) {
                              final current? when current.service == linked.service => Padding(padding: const EdgeInsets.only(top: 6), child: SyncProgressBar(progress: current)),
                              _ => const SizedBox.shrink(),
                            },
                          ),
                      ],
                    ),
                    isThreeLine: true,
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (state.syncingService == linked.service && syncProgress == null)
                          const Padding(padding: EdgeInsets.all(14), child: SizedBox.square(dimension: 20, child: CircularProgressIndicator(strokeWidth: 2)))
                        else
                          IconButton(tooltip: l10n.syncNow, icon: const Icon(Icons.sync), onPressed: state.syncingService == null ? () => importCubit.syncNow(linked) : null),
                        IconButton(tooltip: l10n.stopSyncing, icon: const Icon(Icons.link_off), onPressed: () => importCubit.unlink(linked.service)),
                      ],
                    ),
                  ),
                const Divider(height: 24),
              ],
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final service in importCubit.services)
                    ChoiceChip(
                      avatar: Icon(libraryServiceIcon(service), size: 18),
                      label: Text(libraryServiceName(service)),
                      selected: state.service == service,
                      onSelected: isImporting ? null : (_) => importCubit.chooseService(service),
                    ),
                ],
              ),
              const SizedBox(height: 16),
              Text(_explanation(l10n, state.service), style: AkashicTypography.body(size: 14).copyWith(color: AkashicColors.textSoft)),
              const SizedBox(height: 16),
              if (!importCubit.isConfigured)
                AkashicEmptyState(message: l10n.accountImportNeedsKey(libraryServiceName(state.service)))
              else if (targets.isEmpty)
                AkashicEmptyState(message: l10n.accountImportNeedsCategory)
              else ...[
                if (state.readsFile)
                  OutlinedButton.icon(
                    onPressed: isImporting
                        ? null
                        : () async {
                            if (await files.pick() case final picked?) {
                              importCubit.chooseExportFile(picked.name, picked.bytes);
                            }
                          },
                    icon: const Icon(Icons.upload_file),
                    label: Text(state.exportFileName ?? l10n.chooseExportFile),
                  )
                else if (state.accountField == AccountField.apiKey)
                  TextField(
                    key: ValueKey(state.service),
                    enabled: !isImporting,
                    onChanged: importCubit.setAccountName,
                    autocorrect: false,
                    obscureText: true,
                    decoration: InputDecoration(labelText: l10n.personalApiKeyLabel, hintText: l10n.personalApiKeyHint),
                  )
                else ...[
                  TextField(
                    key: ValueKey(state.service),
                    enabled: !isImporting,
                    onChanged: importCubit.setAccountName,
                    autocorrect: false,
                    decoration: InputDecoration(
                      labelText: state.service == LibraryService.steam ? l10n.steamAccountLabel : l10n.accountNameLabel,
                      hintText: _accountHint(l10n, state.service),
                      helperText: state.service == LibraryService.steam ? l10n.steamAccountHelper : null,
                      helperMaxLines: 4,
                    ),
                  ),
                  if (state.accountField == AccountField.accountAndPassword) ...[
                    const SizedBox(height: 12),
                    TextField(
                      key: ValueKey('password-${state.service}'),
                      enabled: !isImporting,
                      onChanged: importCubit.setPassword,
                      autocorrect: false,
                      obscureText: true,
                      decoration: InputDecoration(labelText: l10n.accountPasswordLabel, helperText: l10n.accountPasswordNotKept),
                    ),
                  ],
                ],
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  key: ValueKey('target-${state.service}'),
                  initialValue: state.selectedCategoryId,
                  decoration: InputDecoration(labelText: l10n.accountImportTarget),
                  items: [for (final category in targets) DropdownMenuItem(value: category.id, child: Text(category.name))],
                  onChanged: isImporting ? null : (categoryId) => categoryId == null ? null : importCubit.chooseCategory(categoryId),
                ),
                if (importCubit.canKeepCurrentSynced)
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    value: state.keepSynced,
                    onChanged: isImporting ? null : importCubit.setKeepSynced,
                    title: Text(l10n.keepAccountSynced),
                    subtitle: Text(l10n.keepAccountSyncedExplanation),
                  ),
                const SizedBox(height: 20),
                if (isImporting) ...[
                  LinearProgressIndicator(value: state.total == 0 ? null : state.done / state.total),
                  const SizedBox(height: 8),
                  Text(
                    state.total == 0 ? l10n.accountImportReading : l10n.discogsImportProgress(state.done, state.total),
                    textAlign: TextAlign.center,
                    style: AkashicTypography.body(size: 13).copyWith(color: AkashicColors.textSoft),
                  ),
                ] else
                  FilledButton.icon(onPressed: state.canStart ? importCubit.start : null, icon: const Icon(Icons.download), label: Text(l10n.discogsImportStart)),
                if (state.status == AccountImportStatus.unreadableFile) ...[
                  const SizedBox(height: 16),
                  Text(l10n.exportFileUnreadable, textAlign: TextAlign.center, style: AkashicTypography.body(size: 14).copyWith(color: AkashicColors.missing)),
                ],
                if (state.status == AccountImportStatus.accountNotFound) ...[
                  const SizedBox(height: 16),
                  Text(
                    switch ((state.service, state.notFoundProblem)) {
                      (LibraryService.steam, LibraryProblem.unknownAccount) => l10n.steamProfileNotFound(state.accountName.trim()),
                      (LibraryService.steam, LibraryProblem.privateLibrary) => l10n.steamLibraryPrivate,
                      (_, LibraryProblem.privateLibrary) => l10n.libraryPrivate(libraryServiceName(state.service)),
                      (_, LibraryProblem.unknownAccount) => l10n.accountNotFound(libraryServiceName(state.service)),
                    },
                    textAlign: TextAlign.center,
                    style: AkashicTypography.body(size: 14).copyWith(color: AkashicColors.missing),
                  ),
                ],
                if (state.outcome case final outcome? when state.status == AccountImportStatus.done) ...[
                  const SizedBox(height: 24),
                  const AkashicLottie(AkashicAnimation.addedCheck, size: 96),
                  const SizedBox(height: 8),
                  Text(
                    l10n.discogsImportOutcome(outcome.added, outcome.alreadyOwned, outcome.failed),
                    textAlign: TextAlign.center,
                    style: AkashicTypography.body(size: 15, weight: FontWeight.w600),
                  ),
                ],
              ],
            ],
          ),
        );
      },
    );
  }
}
