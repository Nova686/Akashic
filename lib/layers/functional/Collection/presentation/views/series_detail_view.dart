import 'package:akashic/layers/technical/Theme/akashic_empty_state.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/collection_item.dart';
import 'package:akashic/layers/functional/Collection/domain/use_cases/resolve_display_title.dart';
import 'package:akashic/layers/functional/Collection/presentation/cubit/series_detail_cubit.dart';
import 'package:akashic/layers/functional/Collection/presentation/cubit/series_detail_state.dart';
import 'package:akashic/layers/functional/Collection/presentation/widgets/series_completion_grid.dart';
import 'package:akashic/layers/technical/Localization/app_localizations.dart';
import 'package:akashic/layers/technical/Theme/akashic_colors.dart';
import 'package:akashic/layers/technical/Theme/akashic_typography.dart';
import 'package:akashic/layers/technical/Theme/safe_scroll_padding.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SeriesDetailView extends StatelessWidget {
  const SeriesDetailView({required this.onOpenItem, this.canUpdateFromSource = false, this.canWishMissingVolumes = false, this.scansTabBuilder, super.key});

  final ValueChanged<CollectionItem> onOpenItem;
  final bool canUpdateFromSource;
  final bool canWishMissingVolumes;
  final Widget Function(String seriesId)? scansTabBuilder;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final seriesCubit = context.read<SeriesDetailCubit>();
    return BlocConsumer<SeriesDetailCubit, SeriesDetailState>(
      listenWhen: (previous, current) => current.updateFailed || current.missingVolumesWished != null,
      listener: (context, state) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(switch (state.missingVolumesWished) {
          final count? => l10n.missingAddedToWishes(count),
          null => l10n.updateFailed,
        }),
      )),
      builder: (context, state) {
        final series = state.series;
        final completion = state.completion;
        if (series == null || completion == null) {
          return const Scaffold(body: Center(child: LabelledSpinner()));
        }
        final title = resolveDisplayTitle(series.titles, state.preferredLanguages) ?? l10n.untitled;
        final physical = ListView(
            padding: safeListPadding(context),
            children: [
              Text(title, style: AkashicTypography.displayTitle(size: 32)),
              if (series.creator != null) Text(series.creator!, style: AkashicTypography.body().copyWith(color: AkashicColors.textSoft)),
              const SizedBox(height: 18),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(color: AkashicColors.surface, borderRadius: BorderRadius.circular(18)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(child: Text(l10n.toComplete, style: AkashicTypography.displayTitle(size: 22))),
                        if (completion.published != null)
                          Text(l10n.ownedOfPublished(completion.owned.length, completion.published!), style: AkashicTypography.numeral(size: 12).copyWith(color: AkashicColors.textSoft)),
                      ],
                    ),
                    const SizedBox(height: 12),
                    SeriesCompletionGrid(completion: completion),
                    if (completion.missing.isNotEmpty) ...[
                      const SizedBox(height: 10),
                      Text(l10n.missingVolumesList(completion.missing.join(', ')), style: AkashicTypography.body(size: 13)),
                      if (canWishMissingVolumes)
                        Align(
                          alignment: Alignment.centerLeft,
                          child: TextButton.icon(
                            onPressed: seriesCubit.wishMissingVolumes,
                            icon: const Icon(Icons.favorite_border, size: 18, color: AkashicColors.teal),
                            label: Text(l10n.addMissingToWishes, style: AkashicTypography.body(size: 13, weight: FontWeight.w600).copyWith(color: AkashicColors.teal)),
                          ),
                        ),
                    ],
                    if (completion.nextUnreleased != null)
                      Text(l10n.nextNotReleased(completion.nextUnreleased!), style: AkashicTypography.body(size: 12).copyWith(color: AkashicColors.textSoft)),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              TextFormField(
                key: ValueKey('published-${series.publishedVolumes}'),
                initialValue: series.publishedVolumes?.toString() ?? '',
                keyboardType: TextInputType.number,
                style: AkashicTypography.numeral(size: 16),
                decoration: InputDecoration(labelText: l10n.publishedVolumes),
                onFieldSubmitted: seriesCubit.setPublishedVolumes,
              ),
              if (canUpdateFromSource && series.externalWorkId != null)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: OutlinedButton.icon(
                    onPressed: state.isUpdating ? null : seriesCubit.updateFromSource,
                    icon: const Icon(Icons.refresh),
                    label: Text(l10n.updateFromAniList),
                  ),
                ),
              const SizedBox(height: 18),
              Text(l10n.ownedVolumes, style: AkashicTypography.body(size: 15, weight: FontWeight.w800)),
              for (final volume in state.volumes)
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Text('${volume.volumeNumber ?? ''}', style: AkashicTypography.numeral(size: 16)),
                  title: Text(resolveDisplayTitle(volume.titles, state.preferredLanguages) ?? title),
                  onTap: () => onOpenItem(volume),
                ),
            ],
          );
        final buildScansTab = scansTabBuilder;
        if (buildScansTab == null) {
          return Scaffold(appBar: AppBar(), body: physical);
        }
        return DefaultTabController(
          length: 2,
          child: Scaffold(
            appBar: AppBar(
              title: Text(title, maxLines: 1, overflow: TextOverflow.ellipsis, style: AkashicTypography.displayTitle(size: 22)),
              bottom: TabBar(tabs: [Tab(text: l10n.physicalTab), Tab(text: l10n.scansTab)]),
            ),
            body: TabBarView(
              children: [
                physical,
                buildScansTab(series.id),
              ],
            ),
          ),
        );
      },
    );
  }
}
