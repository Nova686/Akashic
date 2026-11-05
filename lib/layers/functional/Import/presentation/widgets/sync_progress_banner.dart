import 'package:akashic/layers/functional/Import/domain/entities/linked_account_sync_progress.dart';
import 'package:akashic/layers/functional/Import/presentation/views/account_import_view.dart';
import 'package:akashic/layers/technical/Localization/app_localizations.dart';
import 'package:akashic/layers/technical/Theme/akashic_colors.dart';
import 'package:akashic/layers/technical/Theme/akashic_typography.dart';
import 'package:flutter/material.dart';

String syncProgressLabel(AppLocalizations l10n, LinkedAccountSyncProgress progress) {
  final service = libraryServiceName(progress.service);
  if (progress.isRefreshingDetails) {
    return l10n.syncRefreshingDetails(service);
  }
  return progress.total == 0 ? l10n.syncReading(service) : l10n.syncProgress(service, progress.done, progress.total);
}

class SyncProgressBar extends StatelessWidget {
  const SyncProgressBar({required this.progress, super.key});

  final LinkedAccountSyncProgress progress;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final label = syncProgressLabel(l10n, progress);
    return Semantics(
      liveRegion: true,
      label: label,
      excludeSemantics: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(label, style: AkashicTypography.body(size: 12, weight: FontWeight.w700).copyWith(color: AkashicColors.textSoft)),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(value: progress.fraction, minHeight: 4, color: AkashicColors.lavender, backgroundColor: AkashicColors.line),
          ),
        ],
      ),
    );
  }
}

class SyncProgressBanner extends StatelessWidget {
  const SyncProgressBanner({required this.progress, this.initialProgress, super.key});

  final Stream<LinkedAccountSyncProgress?> progress;
  final LinkedAccountSyncProgress? initialProgress;

  @override
  Widget build(BuildContext context) => StreamBuilder<LinkedAccountSyncProgress?>(
        stream: progress,
        initialData: initialProgress,
        builder: (context, snapshot) => AnimatedSize(
          duration: const Duration(milliseconds: 200),
          child: switch (snapshot.data) {
            final current? => ColoredBox(
                color: AkashicColors.surface,
                child: Padding(padding: const EdgeInsets.fromLTRB(16, 10, 16, 10), child: SyncProgressBar(progress: current)),
              ),
            null => const SizedBox(width: double.infinity),
          },
        ),
      );
}
