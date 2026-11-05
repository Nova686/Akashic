import 'package:akashic/layers/functional/Collection/domain/use_cases/resolve_display_title.dart';
import 'package:akashic/layers/functional/Covers/presentation/cubit/bulk_covers_cubit.dart';
import 'package:akashic/layers/functional/Settings/domain/entities/preferred_languages.dart';
import 'package:akashic/layers/technical/Localization/app_localizations.dart';
import 'package:akashic/layers/technical/Theme/akashic_colors.dart';
import 'package:akashic/layers/technical/Theme/akashic_empty_state.dart';
import 'package:akashic/layers/technical/Theme/akashic_typography.dart';
import 'package:akashic/layers/technical/Theme/safe_scroll_padding.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BulkCoversView extends StatelessWidget {
  const BulkCoversView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final cubit = context.read<BulkCoversCubit>();
    return BlocBuilder<BulkCoversCubit, BulkCoversState>(
      builder: (context, state) => Scaffold(
        appBar: AppBar(title: Text(state.hasStarted ? l10n.coverProposals : l10n.missingCovers, style: AkashicTypography.displayTitle(size: 24))),
        body: switch (state) {
          BulkCoversState(isLoading: true) => const AkashicLoader(),
          BulkCoversState(coverlessCount: 0) => Center(child: AkashicEmptyState(message: l10n.noMissingCovers)),
          BulkCoversState(hasStarted: false) => ListView(
              padding: safeListPadding(context, bottom: 100),
              children: [
                Text(l10n.itemsWithoutCover(state.coverlessCount), style: AkashicTypography.displayTitle(size: 22)),
                const SizedBox(height: 10),
                for (final group in state.groups)
                  CheckboxListTile(
                    contentPadding: EdgeInsets.zero,
                    value: state.selectedCategories.contains(group.category.id),
                    onChanged: (_) => cubit.toggleCategory(group.category.id),
                    title: Text(group.category.name, style: AkashicTypography.body(weight: FontWeight.w700)),
                    secondary: Text('${group.items.length}', style: AkashicTypography.numeral(size: 16)),
                  ),
              ],
            ),
          _ => ListView(
              padding: safeListPadding(context, bottom: 120),
              children: [
                Semantics(
                  liveRegion: true,
                  child: Text(l10n.coverSearchProgress(state.searchedCount, state.proposals.length, state.acceptedCount), style: AkashicTypography.body(size: 14, weight: FontWeight.w700)),
                ),
                const SizedBox(height: 6),
                LinearProgressIndicator(value: state.proposals.isEmpty ? 0 : state.searchedCount / state.proposals.length),
                for (final proposal in state.proposals) _ProposalRow(proposal: proposal, cubit: cubit),
              ],
            ),
        },
        bottomNavigationBar: state.isLoading || state.coverlessCount == 0
            ? null
            : SafeArea(
                minimum: const EdgeInsets.fromLTRB(16, 8, 16, 12),
                child: state.hasStarted
                    ? FilledButton.icon(onPressed: state.pendingCount == 0 ? null : cubit.acceptAll, icon: const Icon(Icons.done_all), label: Text(l10n.acceptAllCovers(state.pendingCount)))
                    : FilledButton.icon(onPressed: state.selectedCount == 0 ? null : cubit.search, icon: const Icon(Icons.image_search), label: Text(l10n.searchCovers(state.selectedCount))),
              ),
      ),
    );
  }
}

class _ProposalRow extends StatelessWidget {
  const _ProposalRow({required this.proposal, required this.cubit});

  final CoverProposal proposal;
  final BulkCoversCubit cubit;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final title = resolveDisplayTitle(proposal.item.titles, PreferredLanguages.defaults) ?? l10n.untitled;
    final url = proposal.shownUrl;
    return Container(
      margin: const EdgeInsets.only(top: 10),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(color: AkashicColors.surface, borderRadius: BorderRadius.circular(14), border: Border.all(color: AkashicColors.line)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: SizedBox(
              width: 56,
              height: 78,
              child: switch (proposal.status) {
                ProposalStatus.searching => const Center(child: SizedBox.square(dimension: 20, child: CircularProgressIndicator(strokeWidth: 2))),
                _ when url == null => ColoredBox(color: AkashicColors.line, child: const Icon(Icons.image_not_supported_outlined, color: AkashicColors.gold)),
                _ => CachedNetworkImage(imageUrl: url, fit: BoxFit.cover, memCacheWidth: 170, errorWidget: (context, failedUrl, error) => ColoredBox(color: AkashicColors.line)),
              },
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(proposal.item.volumeNumber == null ? title : '$title · ${proposal.item.volumeNumber}', maxLines: 2, overflow: TextOverflow.ellipsis, style: AkashicTypography.body(size: 14, weight: FontWeight.w700)),
                const SizedBox(height: 6),
                switch (proposal.status) {
                  ProposalStatus.searching => Text(l10n.coverSearching, style: AkashicTypography.body(size: 12).copyWith(color: AkashicColors.textSoft)),
                  ProposalStatus.nothingFound => Row(children: [const Icon(Icons.search_off, size: 16, color: AkashicColors.gold), const SizedBox(width: 4), Text(l10n.coverNothingFound, style: AkashicTypography.body(size: 12, weight: FontWeight.w700).copyWith(color: AkashicColors.gold))]),
                  ProposalStatus.accepted => Row(children: [const Icon(Icons.check_circle, size: 16, color: AkashicColors.teal), const SizedBox(width: 4), Text(l10n.coverAccepted, style: AkashicTypography.body(size: 12, weight: FontWeight.w700).copyWith(color: AkashicColors.teal))]),
                  ProposalStatus.refused => Text(l10n.coverRefused, style: AkashicTypography.body(size: 12).copyWith(color: AkashicColors.textSoft)),
                  ProposalStatus.proposed => Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: [
                        ActionChip(avatar: const Icon(Icons.check, size: 16), label: Text(l10n.coverAccept), onPressed: () => cubit.accept(proposal.item.id)),
                        ActionChip(avatar: const Icon(Icons.close, size: 16), label: Text(l10n.coverRefuse), onPressed: () => cubit.refuse(proposal.item.id)),
                        if (proposal.urls.length > 1) ActionChip(avatar: const Icon(Icons.photo_library_outlined, size: 16), label: Text(l10n.coverAnother), onPressed: () => cubit.showAnother(proposal.item.id)),
                      ],
                    ),
                },
              ],
            ),
          ),
        ],
      ),
    );
  }
}
