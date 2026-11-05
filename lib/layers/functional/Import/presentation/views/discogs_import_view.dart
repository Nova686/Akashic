import 'package:akashic/layers/functional/Import/presentation/cubit/discogs_import_cubit.dart';
import 'package:akashic/layers/technical/Localization/app_localizations.dart';
import 'package:akashic/layers/technical/Theme/akashic_animation.dart';
import 'package:akashic/layers/technical/Theme/akashic_colors.dart';
import 'package:akashic/layers/technical/Theme/akashic_empty_state.dart';
import 'package:akashic/layers/technical/Theme/akashic_typography.dart';
import 'package:akashic/layers/technical/Theme/safe_scroll_padding.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DiscogsImportView extends StatelessWidget {
  const DiscogsImportView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final importCubit = context.read<DiscogsImportCubit>();
    return BlocBuilder<DiscogsImportCubit, DiscogsImportState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(title: Text(l10n.discogsImportTitle, style: AkashicTypography.body(size: 18, weight: FontWeight.w700))),
          body: ListView(
            padding: safeListPadding(context, top: 12),
            children: [
              if (!importCubit.isConfigured)
                AkashicEmptyState(message: l10n.discogsImportNeedsToken)
              else if (state.categories.isEmpty)
                AkashicEmptyState(message: l10n.discogsImportNeedsMusicCategory)
              else ...[
                Text(l10n.discogsImportExplanation, style: AkashicTypography.body(size: 14).copyWith(color: AkashicColors.textSoft)),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  initialValue: state.selectedCategoryId,
                  decoration: InputDecoration(labelText: l10n.discogsImportTarget),
                  items: [for (final category in state.categories) DropdownMenuItem(value: category.id, child: Text(category.name))],
                  onChanged: state.status == DiscogsImportStatus.importing ? null : (categoryId) => categoryId == null ? null : importCubit.chooseCategory(categoryId),
                ),
                const SizedBox(height: 20),
                if (state.status == DiscogsImportStatus.importing) ...[
                  LinearProgressIndicator(value: state.total == 0 ? null : state.done / state.total),
                  const SizedBox(height: 8),
                  Text(
                    state.total == 0 ? l10n.discogsImportReading : l10n.discogsImportProgress(state.done, state.total),
                    textAlign: TextAlign.center,
                    style: AkashicTypography.body(size: 13).copyWith(color: AkashicColors.textSoft),
                  ),
                ] else
                  FilledButton.icon(onPressed: importCubit.start, icon: const Icon(Icons.download), label: Text(l10n.discogsImportStart)),
                if (state.outcome case final outcome? when state.status == DiscogsImportStatus.done) ...[
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
