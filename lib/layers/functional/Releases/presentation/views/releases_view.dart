import 'package:akashic/layers/functional/Releases/domain/entities/upcoming_release.dart';
import 'package:akashic/layers/functional/Releases/presentation/cubit/releases_cubit.dart';
import 'package:akashic/layers/technical/Localization/app_localizations.dart';
import 'package:akashic/layers/technical/Theme/akashic_colors.dart';
import 'package:akashic/layers/technical/Theme/akashic_empty_state.dart';
import 'package:akashic/layers/technical/Theme/akashic_typography.dart';
import 'package:akashic/layers/technical/Theme/filter_search_field.dart';
import 'package:akashic/layers/technical/Theme/safe_scroll_padding.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class ReleasesView extends StatelessWidget {
  const ReleasesView({this.onOpenCalendarSync, super.key});

  final VoidCallback? onOpenCalendarSync;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final releasesCubit = context.read<ReleasesCubit>();
    return BlocBuilder<ReleasesCubit, ReleasesState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: Text(l10n.upcomingReleases, style: AkashicTypography.displayTitle(size: 26)),
            actions: [
              if (onOpenCalendarSync case final openCalendarSync?) IconButton(tooltip: l10n.calendarSync, onPressed: openCalendarSync, icon: const Icon(Icons.edit_calendar_outlined)),
              IconButton(
                tooltip: l10n.refreshReleases,
                onPressed: state.isRefreshing ? null : releasesCubit.refresh,
                icon: state.isRefreshing
                    ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2))
                    : const Icon(Icons.refresh, color: AkashicColors.teal),
              ),
            ],
          ),
          body: state.isLoading ? const AkashicLoader(size: 96) : _content(context, state),
        );
      },
    );
  }

  Widget _content(BuildContext context, ReleasesState state) {
    final l10n = AppLocalizations.of(context);
    final outlook = state.outlook;
    if (outlook == null || outlook.releases.isEmpty) {
      final message = outlook == null
          ? l10n.releasesOfflineEmpty
          : outlook.followedSubjects == 0
              ? l10n.releasesNeedInterests
              : l10n.releasesNothingAnnounced;
      return Center(child: AkashicEmptyState(message: message, animationSize: 140));
    }
    final monthFormat = DateFormat.yMMMM(l10n.localeName);
    final dayFormat = DateFormat.MMMd(l10n.localeName);
    String dateOf(UpcomingRelease release) => switch (release.datePrecision) {
          ReleaseDatePrecision.day => dayFormat.format(release.releaseDate),
          ReleaseDatePrecision.month => monthFormat.format(release.releaseDate),
          ReleaseDatePrecision.year => '${release.releaseDate.year}',
        };
    final releasesCubit = context.read<ReleasesCubit>();
    final sections = state.sections;
    return ListView(
      padding: safeListPadding(context),
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 4),
          child: FilterSearchField(value: state.query, onChanged: releasesCubit.search, hint: l10n.releasesSearchHint),
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.only(top: 10),
          child: Row(
            children: [
              if (state.availableKinds.length > 1)
                for (final kind in state.availableKinds)
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: FilterChip(
                      label: Text(switch (kind) {
                        ReleaseKind.cardSet => l10n.releaseKindCardSet,
                        ReleaseKind.nextVolume => l10n.releaseKindNextVolume,
                        ReleaseKind.album => l10n.releaseKindAlbum,
                      }),
                      selected: state.kinds.contains(kind),
                      onSelected: (_) => releasesCubit.toggleKind(kind),
                    ),
                  ),
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: FilterChip(label: Text(l10n.filterConfirmedDates), selected: state.confirmedOnly, onSelected: (_) => releasesCubit.toggleConfirmedOnly()),
              ),
              FilterChip(label: Text(l10n.filterWished), selected: state.wishedOnly, onSelected: (_) => releasesCubit.toggleWishedOnly()),
            ],
          ),
        ),
        if (sections.isEmpty && state.isFiltered)
          Padding(
            padding: const EdgeInsets.only(top: 32),
            child: Column(
              children: [
                Text(l10n.noFilteredReleases, textAlign: TextAlign.center, style: AkashicTypography.body().copyWith(color: AkashicColors.textSoft)),
                TextButton(onPressed: releasesCubit.resetFilters, child: Text(l10n.resetFilters)),
              ],
            ),
          ),
        for (final section in sections) ...[
          Padding(
            padding: const EdgeInsets.only(top: 16, bottom: 6),
            child: Text(
              switch (section) {
                ReleaseSection(isAlreadyOut: true) => l10n.releasesAlreadyOut,
                ReleaseSection(:final month?) => toBeginningOfSentenceCase(monthFormat.format(month)),
                ReleaseSection(:final year) => '$year',
              },
              style: AkashicTypography.body(size: 13, weight: FontWeight.w700).copyWith(color: AkashicColors.lavender),
            ),
          ),
          for (final release in section.releases)
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: _ReleaseImage(release: release),
              title: Text(release.title, maxLines: 2, overflow: TextOverflow.ellipsis, style: AkashicTypography.body(size: 15, weight: FontWeight.w700)),
              subtitle: Text(
                [
                  if (release.isWished) l10n.wishedRelease,
                  release.subject,
                  if (release.isEstimated) l10n.estimatedReleaseAround(dateOf(release)) else dateOf(release),
                ].join(' · '),
                style: AkashicTypography.body(size: 12).copyWith(color: release.isEstimated ? AkashicColors.textSoft : AkashicColors.teal, fontStyle: release.isEstimated ? FontStyle.italic : null),
              ),
              trailing: release.isEstimated
                  ? Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(border: Border.all(color: AkashicColors.line), borderRadius: BorderRadius.circular(999)),
                      child: Text(l10n.estimateBadge, style: AkashicTypography.body(size: 11, weight: FontWeight.w600).copyWith(color: AkashicColors.textSoft)),
                    )
                  : null,
            ),
        ],
      ],
    );
  }
}

class _ReleaseImage extends StatelessWidget {
  const _ReleaseImage({required this.release});

  final UpcomingRelease release;

  @override
  Widget build(BuildContext context) {
    final fallback = ColoredBox(
      color: AkashicColors.surface,
      child: Icon(switch (release.kind) {
        ReleaseKind.cardSet => Icons.style_outlined,
        ReleaseKind.nextVolume => Icons.menu_book_outlined,
        ReleaseKind.album => Icons.album_outlined,
      }, color: AkashicColors.lavender),
    );
    return ClipRRect(
      borderRadius: BorderRadius.circular(6),
      child: SizedBox(
        width: 48,
        height: 48,
        child: release.imageUrl == null
            ? fallback
            : CachedNetworkImage(imageUrl: release.imageUrl!, fit: BoxFit.contain, memCacheWidth: 150, errorWidget: (context, url, error) => fallback),
      ),
    );
  }
}
