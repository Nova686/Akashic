import 'package:akashic/layers/functional/Details/domain/entities/item_details.dart';
import 'package:akashic/layers/technical/Localization/app_localizations.dart';
import 'package:akashic/layers/technical/Theme/akashic_colors.dart';
import 'package:akashic/layers/technical/Theme/akashic_typography.dart';
import 'package:akashic/layers/functional/Details/domain/use_cases/track_sides.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class LearnMoreTab extends StatelessWidget {
  const LearnMoreTab({required this.details, required this.isFetching, required this.canFetch, required this.onRefresh, this.isEmbedded = false, super.key});

  final ItemDetails? details;
  final bool isFetching;
  final bool canFetch;
  final VoidCallback onRefresh;
  final bool isEmbedded;

  String _factLabel(FactKind kind, AppLocalizations l10n) => switch (kind) {
        FactKind.label => l10n.factLabel,
        FactKind.status => l10n.factStatus,
        FactKind.volumes => l10n.factVolumes,
        FactKind.chapters => l10n.factChapters,
        FactKind.runtime => l10n.factRuntime,
        FactKind.director => l10n.factDirector,
        FactKind.studio => l10n.factStudio,
        FactKind.platforms => l10n.factPlatforms,
        FactKind.pages => l10n.factPages,
        FactKind.publisher => l10n.factPublisher,
        FactKind.format => l10n.factFormat,
      };

  String _factValue(DetailFact fact, AppLocalizations l10n) => switch ((fact.kind, fact.value)) {
        (FactKind.status, 'FINISHED') => l10n.publicationStatusFinished,
        (FactKind.status, 'RELEASING') => l10n.publicationStatusReleasing,
        (FactKind.status, 'NOT_YET_RELEASED') => l10n.publicationStatusNotYetReleased,
        (FactKind.status, 'CANCELLED') => l10n.publicationStatusCancelled,
        (FactKind.status, 'HIATUS') => l10n.publicationStatusHiatus,
        _ => fact.value,
      };

  Widget _heading(String text, String? source) {
    return Padding(
      padding: const EdgeInsets.only(top: 14, bottom: 6),
      child: Row(
        children: [
          Expanded(child: Text(text, style: AkashicTypography.body(size: 14, weight: FontWeight.w800))),
          if (source != null) Text(source, style: AkashicTypography.body(size: 11).copyWith(color: AkashicColors.teal)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final current = details;
    final updateRow = Row(
      children: [
        if (current != null)
          Expanded(
            child: Text(
              l10n.fetchedOn(DateFormat.yMMMd(l10n.localeName).format(current.fetchedAt)),
              style: AkashicTypography.body(size: 12).copyWith(color: AkashicColors.textFaint),
            ),
          )
        else
          Expanded(child: Text(canFetch ? l10n.noDetailsYet : l10n.noOnlineDetailsForItem, style: AkashicTypography.body(size: 12).copyWith(color: AkashicColors.textSoft))),
        if (canFetch)
          TextButton.icon(
            onPressed: isFetching ? null : onRefresh,
            icon: isFetching ? const SizedBox(width: 14, height: 14, child: CircularProgressIndicator(strokeWidth: 2)) : const Icon(Icons.refresh, size: 16, color: AkashicColors.teal),
            label: Text(current == null ? l10n.fetchDetails : l10n.updateDetails, style: AkashicTypography.body(size: 12, weight: FontWeight.w600).copyWith(color: AkashicColors.teal)),
          ),
      ],
    );
    return ListView(
      shrinkWrap: isEmbedded,
      physics: isEmbedded ? const NeverScrollableScrollPhysics() : null,
      padding: isEmbedded ? EdgeInsets.zero : EdgeInsets.only(bottom: 24 + MediaQuery.paddingOf(context).bottom),
      children: [
        updateRow,
        for (final section in current?.sections ?? const <DetailSection>[])
          switch (section) {
            TextSection(:final text, :final sourceLabel) => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [_heading(l10n.sectionSummary, sourceLabel), Text(text, style: AkashicTypography.body(size: 13).copyWith(color: AkashicColors.textSoft, height: 1.5))],
              ),
            TrackListSection(:final tracks, :final sourceLabel) => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _heading(l10n.sectionTracks, sourceLabel),
                  for (final side in trackSidesOf(tracks)) ...[
                    if (side.label != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 8, bottom: 2),
                        child: Row(
                          children: [
                            Expanded(child: Text(side.label == null ? '' : l10n.trackSide(side.label!), style: AkashicTypography.body(size: 12, weight: FontWeight.w800).copyWith(color: AkashicColors.lavender))),
                            if (side.totalSeconds case final seconds?) Text(formatDuration(seconds), style: AkashicTypography.numeral(size: 11).copyWith(color: AkashicColors.lavender)),
                          ],
                        ),
                      ),
                  for (final track in side.tracks)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 2),
                      child: Row(
                        children: [
                          SizedBox(width: 36, child: Text(track.position, style: AkashicTypography.numeral(size: 11).copyWith(color: AkashicColors.textFaint))),
                          Expanded(child: Text(track.title, style: AkashicTypography.body(size: 13))),
                          if (track.duration != null) Text(track.duration!, style: AkashicTypography.numeral(size: 11).copyWith(color: AkashicColors.textSoft)),
                        ],
                      ),
                    ),
                  ],
                  if (totalDurationOf(tracks) case final total?)
                    Padding(
                      padding: const EdgeInsets.only(top: 6),
                      child: Text(l10n.albumLength(formatDuration(total)), style: AkashicTypography.body(size: 12, weight: FontWeight.w700).copyWith(color: AkashicColors.teal)),
                    ),
                ],
              ),
            FactsSection(:final facts, :final sourceLabel) => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _heading(l10n.sectionFacts, sourceLabel),
                  for (final fact in facts)
                    Text(l10n.factLine(_factLabel(fact.kind, l10n), _factValue(fact, l10n)), style: AkashicTypography.body(size: 13)),
                ],
              ),
            TagSection(:final tags) => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _heading(l10n.sectionGenres, null),
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: [for (final tag in tags) Chip(label: Text(tag, style: AkashicTypography.body(size: 12)), visualDensity: VisualDensity.compact)],
                  ),
                ],
              ),
            LinkSection(:final links) => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _heading(l10n.sectionLinks, null),
                  Wrap(
                    spacing: 8,
                    children: [
                      for (final link in links)
                        ActionChip(
                          avatar: const Icon(Icons.link, size: 16, color: AkashicColors.teal),
                          label: Text(link.label, style: AkashicTypography.body(size: 12).copyWith(color: AkashicColors.teal)),
                          onPressed: () => launchUrl(Uri.parse(link.url), mode: LaunchMode.externalApplication),
                        ),
                    ],
                  ),
                ],
              ),
          },
      ],
    );
  }
}
