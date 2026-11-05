import 'package:akashic/layers/technical/Theme/akashic_empty_state.dart';
import 'package:akashic/layers/functional/Collection/presentation/views/deck_editor_view.dart';
import 'package:akashic/layers/functional/Lookup/domain/entities/source_unavailable.dart';
import 'package:akashic/layers/functional/Steam/domain/entities/steam_store_page.dart';
import 'package:akashic/layers/technical/Localization/app_localizations.dart';
import 'package:akashic/layers/technical/Theme/akashic_colors.dart';
import 'package:akashic/layers/technical/Theme/akashic_typography.dart';
import 'package:akashic/layers/technical/Theme/zoom_gallery.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class SteamStoreTab extends StatefulWidget {
  const SteamStoreTab({required this.load, this.loadDlcs, this.onWishDlc, super.key});

  final Future<SteamStoreSheet> Function() load;
  final Future<List<SteamDlc>> Function()? loadDlcs;
  final Future<void> Function(SteamDlc dlc)? onWishDlc;

  @override
  State<SteamStoreTab> createState() => _SteamStoreTabState();
}

class _SteamStoreTabState extends State<SteamStoreTab> {
  late Future<SteamStoreSheet> _sheet = widget.load();
  late Future<List<SteamDlc>>? _dlcs = widget.loadDlcs?.call();
  final Set<String> _wished = {};

  List<Widget> _dlcSection(List<SteamDlc> dlcs, AppLocalizations l10n) => [
        if (dlcs.isNotEmpty) ...[
              _SectionTitle(l10n.steamDlcTitle),
              for (final dlc in dlcs)
                _DlcRow(
                  dlc: dlc,
                  isWished: _wished.contains(dlc.appId),
                  onWish: switch (widget.onWishDlc) {
                    final wish? when !dlc.isInCollection => () async {
                        await wish(dlc);
                        if (mounted) {
                          setState(() => _wished.add(dlc.appId));
                        }
                      },
                    _ => null,
                  },
                ),
              Padding(
                padding: const EdgeInsets.only(top: 6),
                child: Text(l10n.steamDlcOwnershipNote, style: AkashicTypography.body(size: 12).copyWith(color: AkashicColors.textSoft)),
              ),
        ],
      ];

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return FutureBuilder<SteamStoreSheet>(
      future: _sheet,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Padding(padding: EdgeInsets.all(32), child: Center(child: LabelledSpinner()));
        }
        final sheet = snapshot.data;
        if (sheet == null) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 24),
            child: Column(
              children: [
                Text(snapshot.error is SourceUnavailable ? l10n.steamAchievementsUnavailable : l10n.steamStorePageMissing, textAlign: TextAlign.center, style: AkashicTypography.body(size: 14).copyWith(color: AkashicColors.textSoft)),
                TextButton(
                  onPressed: () => setState(() {
                    _sheet = widget.load();
                    _dlcs = widget.loadDlcs?.call();
                  }),
                  child: Text(l10n.retry),
                ),
              ],
            ),
          );
        }
        final page = sheet.page;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 14),
            _PriceCard(page: page),
            if (sheet.news.isNotEmpty) ...[
              _SectionTitle(l10n.steamNewsTitle),
              for (final news in sheet.news) _NewsCard(news: news),
            ],
            if (widget.loadDlcs == null)
              ..._dlcSection(sheet.dlcs, l10n)
            else if (page.dlcIds.isNotEmpty)
              FutureBuilder<List<SteamDlc>>(
                future: _dlcs,
                builder: (context, snapshot) => switch (snapshot) {
                  AsyncSnapshot(hasData: true, :final data?) => Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: _dlcSection(data, l10n)),
                  AsyncSnapshot(hasError: true) => const SizedBox.shrink(),
                  _ => Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _SectionTitle(l10n.steamDlcTitle),
                        const Padding(padding: EdgeInsets.symmetric(vertical: 8), child: LinearProgressIndicator(minHeight: 2)),
                      ],
                    ),
                },
              ),
            _SectionTitle(l10n.steamAboutTitle),
            if (page.shortDescription case final description?) Text(description, style: AkashicTypography.body(size: 14)),
            if (page.genres.isNotEmpty) ...[
              const SizedBox(height: 10),
              Wrap(spacing: 6, runSpacing: 6, children: [for (final genre in page.genres) Chip(label: Text(genre))]),
            ],
            const SizedBox(height: 10),
            if (page.developers.isNotEmpty) _Fact(label: l10n.steamDeveloper, value: page.developers.join(', ')),
            if (page.publishers.isNotEmpty) _Fact(label: l10n.steamPublisher, value: page.publishers.join(', ')),
            if (page.releaseDate case final releaseDate?) _Fact(label: l10n.steamReleaseDate, value: releaseDate),
            if (page.screenshots.isNotEmpty || page.trailerThumbnailUrl != null) ...[
              _SectionTitle(l10n.steamMediaTitle),
              SizedBox(
                height: 112,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    if (page.trailerThumbnailUrl case final trailer?)
                      _Media(
                        imageUrl: trailer,
                        label: l10n.steamTrailer,
                        isVideo: true,
                        onTap: () => launchUrl(page.storeUrl, mode: LaunchMode.externalApplication),
                      ),
                    for (final (index, screenshot) in page.screenshots.indexed)
                      _Media(
                        imageUrl: screenshot.thumbnailUrl,
                        label: l10n.steamScreenshot(index + 1),
                        onTap: () => showZoomGallery(
                          context,
                          initialIndex: index,
                          images: [
                            for (final shot in page.screenshots) ZoomGalleryImage(heroTag: 'steam-shot-${shot.fullUrl}', image: NetworkImage(shot.fullUrl), aspectRatio: 16 / 9),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ],
            if (page.features.isNotEmpty) ...[
              _SectionTitle(l10n.steamFeaturesTitle),
              Wrap(spacing: 6, runSpacing: 6, children: [for (final feature in page.features) Chip(label: Text(feature))]),
            ],
            if (page.languages case final languages?) ...[
              _SectionTitle(l10n.steamLanguagesTitle),
              Text(languages, style: AkashicTypography.body(size: 13).copyWith(color: AkashicColors.textSoft)),
            ],
            if (page.minimumRequirements != null || page.recommendedRequirements != null)
              Theme(
                data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                child: ExpansionTile(
                  tilePadding: EdgeInsets.zero,
                  title: Text(l10n.steamRequirementsTitle, style: AkashicTypography.body(size: 15, weight: FontWeight.w800)),
                  children: [
                    for (final requirements in [?page.minimumRequirements, ?page.recommendedRequirements])
                      Align(alignment: Alignment.centerLeft, child: Padding(padding: const EdgeInsets.only(bottom: 10), child: Text(requirements, style: AkashicTypography.body(size: 13)))),
                  ],
                ),
              ),
            TextButton.icon(onPressed: () => launchUrl(page.storeUrl, mode: LaunchMode.externalApplication), icon: const Icon(Icons.open_in_new), label: Text(l10n.steamOpenStore)),
          ],
        );
      },
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.title);

  final String title;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(top: 22, bottom: 8),
        child: Semantics(header: true, child: Text(title, style: AkashicTypography.displayTitle(size: 20))),
      );
}

class _Fact extends StatelessWidget {
  const _Fact({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 3),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(width: 110, child: Text(label, style: AkashicTypography.body(size: 13).copyWith(color: AkashicColors.textSoft))),
            Expanded(child: Text(value, style: AkashicTypography.body(size: 13, weight: FontWeight.w600))),
          ],
        ),
      );
}

class SteamPriceLine extends StatelessWidget {
  const SteamPriceLine({required this.price, this.isFree = false, this.size = 26, super.key});

  final SteamPrice? price;
  final bool isFree;
  final double size;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final price = this.price;
    if (price == null) {
      return Text(isFree ? l10n.steamFree : l10n.steamNoPrice, style: AkashicTypography.numeral(size: size * 0.7));
    }
    return Wrap(
      spacing: 8,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        if (price.isDiscounted)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(color: AkashicColors.gold, borderRadius: BorderRadius.circular(8)),
            child: Text('−${price.discountPercent} %', style: AkashicTypography.numeral(size: 14).copyWith(color: AkashicColors.night)),
          ),
        Text(formatMoney(price.finalCents, price.currency, l10n.localeName), style: AkashicTypography.numeral(size: size).copyWith(color: price.isDiscounted ? AkashicColors.gold : AkashicColors.text)),
        if (price.isDiscounted)
          Text(
            formatMoney(price.initialCents, price.currency, l10n.localeName),
            semanticsLabel: l10n.steamPriceBefore(formatMoney(price.initialCents, price.currency, l10n.localeName)),
            style: AkashicTypography.numeral(size: size * 0.6).copyWith(color: AkashicColors.textSoft, decoration: TextDecoration.lineThrough),
          ),
      ],
    );
  }
}

class _PriceCard extends StatelessWidget {
  const _PriceCard({required this.page});

  final SteamStorePage page;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: AkashicColors.surface, borderRadius: BorderRadius.circular(20)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l10n.steamPriceToday, style: AkashicTypography.body(size: 13).copyWith(color: AkashicColors.textSoft)),
          const SizedBox(height: 6),
          SteamPriceLine(price: page.price, isFree: page.isFree),
        ],
      ),
    );
  }
}

class _NewsCard extends StatelessWidget {
  const _NewsCard({required this.news});

  final SteamNews news;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => launchUrl(Uri.parse(news.url), mode: LaunchMode.externalApplication),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                [DateFormat.yMMMd(l10n.localeName).format(news.publishedAt.toLocal()), ?news.feedLabel].join(' · '),
                style: AkashicTypography.body(size: 12).copyWith(color: AkashicColors.teal),
              ),
              const SizedBox(height: 4),
              Text(news.title, style: AkashicTypography.body(size: 15, weight: FontWeight.w700)),
              if (news.snippet case final snippet?) Text(snippet, maxLines: 3, overflow: TextOverflow.ellipsis, style: AkashicTypography.body(size: 13).copyWith(color: AkashicColors.textSoft)),
            ],
          ),
        ),
      ),
    );
  }
}

class _DlcRow extends StatelessWidget {
  const _DlcRow({required this.dlc, required this.isWished, this.onWish});

  final SteamDlc dlc;
  final bool isWished;
  final Future<void> Function()? onWish;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: SizedBox(
              width: 92,
              height: 43,
              child: dlc.imageUrl == null
                  ? ColoredBox(color: AkashicColors.line)
                  : Image.network(dlc.imageUrl!, fit: BoxFit.cover, cacheWidth: 230, errorBuilder: (context, error, stack) => ColoredBox(color: AkashicColors.line)),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(dlc.name, maxLines: 2, overflow: TextOverflow.ellipsis, style: AkashicTypography.body(size: 14, weight: FontWeight.w700)),
                if (dlc.isInCollection)
                  Row(
                    children: [
                      const Icon(Icons.check_circle, size: 16, color: AkashicColors.teal),
                      const SizedBox(width: 4),
                      Text(l10n.steamDlcInCollection, style: AkashicTypography.body(size: 12, weight: FontWeight.w600).copyWith(color: AkashicColors.teal)),
                    ],
                  )
                else if (dlc.isComingSoon && dlc.releaseDate != null)
                  Text(l10n.steamComingOn(dlc.releaseDate!), style: AkashicTypography.body(size: 12).copyWith(color: AkashicColors.textSoft))
                else
                  SteamPriceLine(price: dlc.price, isFree: dlc.isFree, size: 15),
              ],
            ),
          ),
          if (onWish case final wish? when !dlc.isInCollection)
            isWished
                ? Tooltip(message: l10n.steamDlcWished, child: const Padding(padding: EdgeInsets.all(12), child: Icon(Icons.favorite, color: AkashicColors.lavender)))
                : TextButton.icon(onPressed: wish, icon: const Icon(Icons.favorite_border, size: 18), label: Text(l10n.steamWishAction)),
        ],
      ),
    );
  }
}

class _Media extends StatelessWidget {
  const _Media({required this.imageUrl, required this.label, required this.onTap, this.isVideo = false});

  final String imageUrl;
  final String label;
  final VoidCallback onTap;
  final bool isVideo;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(right: 8),
        child: Semantics(
          button: true,
          label: label,
          onTap: onTap,
          excludeSemantics: true,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(10),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Image.network(imageUrl, width: 199, height: 112, fit: BoxFit.cover, cacheWidth: 400, errorBuilder: (context, error, stack) => SizedBox(width: 199, height: 112, child: ColoredBox(color: AkashicColors.line))),
                  if (isVideo)
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(color: AkashicColors.night.withValues(alpha: 0.7), shape: BoxShape.circle),
                      child: Icon(Icons.play_arrow, color: AkashicColors.text),
                    ),
                ],
              ),
            ),
          ),
        ),
      );
}
