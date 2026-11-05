import 'package:akashic/layers/technical/Theme/safe_bottom_sheet.dart';
import 'package:akashic/layers/functional/Backup/domain/entities/backup.dart';
import 'package:akashic/layers/functional/Backup/presentation/cubit/backup_cubit.dart';
import 'package:akashic/layers/technical/Localization/app_localizations.dart';
import 'package:akashic/layers/technical/Theme/akashic_colors.dart';
import 'package:akashic/layers/technical/Theme/akashic_typography.dart';
import 'package:akashic/layers/technical/Theme/safe_scroll_padding.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class BackupView extends StatelessWidget {
  const BackupView({this.closeApp = SystemNavigator.pop, super.key});

  final Future<void> Function() closeApp;

  Future<void> _chooseBackupToRestore(BuildContext context) async {
    final l10n = AppLocalizations.of(context);
    final backupCubit = context.read<BackupCubit>();
    await backupCubit.loadRemoteBackups();
    final backups = backupCubit.state.remoteBackups;
    if (backups.isEmpty || !context.mounted) {
      return;
    }
    String dateOf(RemoteBackup backup) => DateFormat.yMMMd(l10n.localeName).add_Hm().format(backup.createdAt);
    final chosen = await showSafeBottomSheet<RemoteBackup>(
      context: context,
      builder: (sheetContext) => ListView(
        shrinkWrap: true,
        padding: safeListPadding(sheetContext, top: 12),
        children: [
          for (final backup in backups)
            ListTile(
              leading: const Icon(Icons.history, color: AkashicColors.lavender),
              title: Text(dateOf(backup), style: AkashicTypography.numeral(size: 14)),
              onTap: () => Navigator.of(sheetContext).pop(backup),
            ),
        ],
      ),
    );
    if (chosen == null || !context.mounted) {
      return;
    }
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        content: Text(l10n.restoreQuestion(dateOf(chosen))),
        actions: [
          TextButton(onPressed: () => Navigator.of(dialogContext).pop(false), child: Text(l10n.cancel)),
          FilledButton(onPressed: () => Navigator.of(dialogContext).pop(true), child: Text(l10n.restoreConfirm)),
        ],
      ),
    );
    if (confirmed ?? false) {
      await backupCubit.restore(chosen);
    }
  }

  Future<void> _announceRestore(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => PopScope(
        canPop: false,
        child: AlertDialog(
          content: Text(l10n.restoreReady),
          actions: [FilledButton(onPressed: closeApp, child: Text(l10n.closeAkashic))],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final backupCubit = context.read<BackupCubit>();
    return BlocConsumer<BackupCubit, BackupState>(
      listenWhen: (previous, current) => current.notice != BackupNotice.none,
      listener: (context, state) {
        if (state.notice == BackupNotice.restoreStaged) {
          _announceRestore(context);
          return;
        }
        final message = switch (state.notice) {
          BackupNotice.backedUp => l10n.backupDone,
          BackupNotice.exported => l10n.exportDone,
          BackupNotice.unavailable => l10n.backupUnavailable,
          BackupNotice.authorizationRefused => l10n.backupAuthorizationRefused,
          BackupNotice.corrupt => l10n.backupCorrupt,
          BackupNotice.noRemoteBackup => l10n.noRemoteBackup,
          BackupNotice.restoreFailed => l10n.restoreFailed,
          BackupNotice.restoreStaged || BackupNotice.none => null,
        };
        if (message != null) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
        }
      },
      builder: (context, state) {
        final lastBackupAt = state.lastBackupAt;
        return Scaffold(
          appBar: AppBar(title: Text(l10n.backup, style: AkashicTypography.body(size: 18, weight: FontWeight.w700))),
          body: ListView(
            padding: safeListPadding(context, top: 12),
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(color: AkashicColors.surface, borderRadius: BorderRadius.circular(18)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      lastBackupAt == null ? l10n.noBackupYet : l10n.lastBackupOn(DateFormat.yMMMd(l10n.localeName).add_Hm().format(lastBackupAt)),
                      style: AkashicTypography.body(size: 15, weight: FontWeight.w700),
                    ),
                    const SizedBox(height: 6),
                    Text(l10n.backupExplanation, style: AkashicTypography.body(size: 12).copyWith(color: AkashicColors.textSoft)),
                  ],
                ),
              ),
              if (state.needsReconnect)
                Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: Row(
                    children: [
                      const Icon(Icons.info_outline, size: 18, color: AkashicColors.teal),
                      const SizedBox(width: 8),
                      Expanded(child: Text(l10n.backupReconnectReminder, style: AkashicTypography.body(size: 13).copyWith(color: AkashicColors.teal))),
                    ],
                  ),
                ),
              const SizedBox(height: 18),
              FilledButton.icon(
                onPressed: state.isWorking ? null : backupCubit.backUpNow,
                icon: state.isWorking ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2)) : const Icon(Icons.cloud_upload_outlined),
                label: Text(state.needsReconnect ? l10n.reconnectGoogle : l10n.backUpNow),
              ),
              const SizedBox(height: 10),
              OutlinedButton.icon(
                onPressed: state.isWorking ? null : () => _chooseBackupToRestore(context),
                icon: const Icon(Icons.cloud_download_outlined),
                label: Text(l10n.restoreBackup),
              ),
              if (backupCubit.canUseFiles) ...[
                const SizedBox(height: 28),
                Text(l10n.backupFileSection, style: AkashicTypography.body(size: 15, weight: FontWeight.w700)),
                const SizedBox(height: 6),
                Text(l10n.backupFileExplanation, style: AkashicTypography.body(size: 12).copyWith(color: AkashicColors.textSoft)),
                const SizedBox(height: 12),
                OutlinedButton.icon(
                  onPressed: state.isWorking ? null : backupCubit.exportToFile,
                  icon: const Icon(Icons.save_alt),
                  label: Text(l10n.exportToFile),
                ),
                const SizedBox(height: 10),
                OutlinedButton.icon(
                  onPressed: state.isWorking ? null : backupCubit.restoreFromFile,
                  icon: const Icon(Icons.folder_open_outlined),
                  label: Text(l10n.restoreFromFile),
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}
