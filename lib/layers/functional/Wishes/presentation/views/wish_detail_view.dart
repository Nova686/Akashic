import 'package:akashic/layers/functional/Catalog/presentation/widgets/category_type_labels.dart';
import 'package:akashic/layers/functional/Collection/presentation/widgets/learn_more_tab.dart';
import 'package:akashic/layers/functional/Details/domain/entities/item_details.dart';
import 'package:akashic/layers/functional/Details/domain/use_cases/fetch_item_details.dart';
import 'package:akashic/layers/functional/Wishes/domain/entities/wish.dart';
import 'package:akashic/layers/functional/Wishes/domain/use_cases/describe_wish.dart';
import 'package:akashic/layers/functional/Wishes/presentation/widgets/wish_labels.dart';
import 'package:akashic/layers/technical/Feedback/error_toasts.dart';
import 'package:akashic/layers/technical/Localization/app_localizations.dart';
import 'package:akashic/layers/technical/Theme/akashic_colors.dart';
import 'package:akashic/layers/technical/Theme/akashic_typography.dart';
import 'package:akashic/layers/functional/Collection/domain/use_cases/parse_price_to_cents.dart';
import 'package:akashic/layers/functional/Wishes/presentation/widgets/wish_priority_labels.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class WishDetailView extends StatefulWidget {
  const WishDetailView({required this.wish, required this.onRemove, this.describeWish, this.onSavePlan, super.key});

  final Wish wish;
  final VoidCallback onRemove;
  final DescribeWish? describeWish;
  final Future<void> Function(WishPriority priority, int? maxPriceCents)? onSavePlan;

  @override
  State<WishDetailView> createState() => _WishDetailViewState();
}

class _WishDetailViewState extends State<WishDetailView> {
  ItemDetails? _details;
  bool _isFetching = false;

  bool get _canDescribe => widget.describeWish?.canDescribe(widget.wish) ?? false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_canDescribe && _details == null && !_isFetching) {
      _describe();
    }
  }

  Future<void> _describe() async {
    final describeWish = widget.describeWish;
    if (describeWish == null) {
      return;
    }
    setState(() => _isFetching = true);
    try {
      final details = await describeWish(widget.wish, languageCode: Localizations.localeOf(context).languageCode);
      if (mounted) {
        setState(() => _details = details);
      }
    } on DetailsUnavailable {
      ErrorToasts.instance.show((l10n) => l10n.detailsUnavailable);
    } finally {
      if (mounted) {
        setState(() => _isFetching = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final wish = widget.wish;
    final imageUrl = wish.imageUrl;
    return Scaffold(
      appBar: AppBar(title: Text(wish.displayTitle(l10n), maxLines: 1, overflow: TextOverflow.ellipsis, style: AkashicTypography.body(size: 18, weight: FontWeight.w700))),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: SizedBox(
                    width: 110,
                    height: 160,
                    child: imageUrl == null
                        ? const ColoredBox(color: AkashicColors.surface, child: Icon(Icons.favorite_border, color: AkashicColors.lavender))
                        : CachedNetworkImage(imageUrl: imageUrl, fit: BoxFit.cover, memCacheWidth: 330, errorWidget: (context, url, error) => const ColoredBox(color: AkashicColors.surface)),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(wish.displayTitle(l10n), style: AkashicTypography.displayTitle(size: 22)),
                      if (wish.creator case final creator?) ...[
                        const SizedBox(height: 4),
                        Text(creator, style: AkashicTypography.body(size: 14).copyWith(color: AkashicColors.textSoft)),
                      ],
                      const SizedBox(height: 4),
                      Text(wish.categoryType.label(l10n), style: AkashicTypography.body(size: 12).copyWith(color: AkashicColors.teal)),
                      Text(
                        l10n.wishOriginOn(wish.origin.label(l10n), DateFormat.yMMMd(l10n.localeName).format(wish.createdAt)),
                        style: AkashicTypography.body(size: 12).copyWith(color: AkashicColors.textFaint),
                      ),
                      const SizedBox(height: 10),
                      OutlinedButton.icon(
                        onPressed: () {
                          widget.onRemove();
                          Navigator.of(context).pop();
                        },
                        icon: const Icon(Icons.heart_broken_outlined, size: 18),
                        label: Text(l10n.removeWish),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if (widget.onSavePlan case final savePlan?) _WishPlan(wish: wish, onSave: savePlan),
            const SizedBox(height: 8),
            Expanded(child: LearnMoreTab(details: _details, isFetching: _isFetching, canFetch: _canDescribe, onRefresh: _describe)),
          ],
        ),
      ),
    );
  }
}

class _WishPlan extends StatefulWidget {
  const _WishPlan({required this.wish, required this.onSave});

  final Wish wish;
  final Future<void> Function(WishPriority priority, int? maxPriceCents) onSave;

  @override
  State<_WishPlan> createState() => _WishPlanState();
}

class _WishPlanState extends State<_WishPlan> {
  late WishPriority _priority = widget.wish.priority;
  late final TextEditingController _maximum = TextEditingController(text: widget.wish.maxPriceCents == null ? '' : (widget.wish.maxPriceCents! / 100).toStringAsFixed(widget.wish.maxPriceCents! % 100 == 0 ? 0 : 2));
  bool _hasPriceError = false;

  @override
  void dispose() {
    _maximum.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    int? maximum;
    try {
      maximum = parsePriceToCents(_maximum.text);
    } on InvalidPrice {
      setState(() => _hasPriceError = true);
      return;
    }
    setState(() => _hasPriceError = false);
    await widget.onSave(_priority, maximum);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 14),
        Text(l10n.wishPriority, style: AkashicTypography.body(size: 14, weight: FontWeight.w800)),
        const SizedBox(height: 6),
        Row(
          children: [
            for (final priority in WishPriority.values)
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(right: priority == WishPriority.values.last ? 0 : 8),
                  child: Semantics(
                    button: true,
                    selected: _priority == priority,
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size(0, 56),
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        backgroundColor: _priority == priority ? wishPriorityColor(priority).withValues(alpha: 0.2) : null,
                        side: BorderSide(color: _priority == priority ? wishPriorityColor(priority) : AkashicColors.line, width: 2),
                      ),
                      onPressed: () {
                        setState(() => _priority = priority);
                        _save();
                      },
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(wishPriorityIcon(priority), size: 18, color: wishPriorityColor(priority)),
                          Text(wishPriorityLabel(priority, l10n), textAlign: TextAlign.center, style: AkashicTypography.body(size: 12, weight: FontWeight.w700).copyWith(color: AkashicColors.text)),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 10),
        TextField(
          controller: _maximum,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          textInputAction: TextInputAction.done,
          onSubmitted: (_) => _save(),
          onTapOutside: (_) => _save(),
          decoration: InputDecoration(labelText: l10n.wishMaximumLabel, helperText: l10n.wishMaximumHelp, suffixText: '€', errorText: _hasPriceError ? l10n.priceInvalid : null),
        ),
      ],
    );
  }
}
