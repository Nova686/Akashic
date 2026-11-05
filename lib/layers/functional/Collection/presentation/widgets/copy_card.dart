import 'package:akashic/layers/functional/Collection/domain/entities/item_copy.dart';
import 'package:akashic/layers/functional/Collection/presentation/widgets/condition_labels.dart';
import 'package:akashic/layers/functional/Collection/presentation/widgets/trade_channel_label.dart';
import 'package:akashic/layers/technical/Localization/app_localizations.dart';
import 'package:akashic/layers/technical/Theme/akashic_colors.dart';
import 'package:akashic/layers/technical/Theme/akashic_typography.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CopyCard extends StatelessWidget {
  const CopyCard({required this.copy, required this.onTap, this.onLend, this.onReturn, this.showsSealing = false, super.key});

  final ItemCopy copy;
  final VoidCallback onTap;
  final VoidCallback? onLend;
  final VoidCallback? onReturn;
  final bool showsSealing;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final priceCents = copy.pricePaidCents;
    final price = priceCents == null ? null : NumberFormat.currency(locale: l10n.localeName, symbol: '€').format(priceCents / 100);
    final purchase = [
      if (copy.purchasedOn case final purchasedOn?) l10n.boughtOn(DateFormat.yMMMd(l10n.localeName).format(purchasedOn)),
      if (copy.purchaseChannel case final channel?) tradeChannelLabel(channel, l10n),
    ].join(' · ');
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Material(
        color: AkashicColors.surface,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Expanded(child: Text(copy.edition ?? l10n.copyWithoutDetails, style: AkashicTypography.body(weight: FontWeight.w700))),
                    if (showsSealing)
                      Container(
                        margin: const EdgeInsets.only(right: 8),
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: (copy.isOpened ? AkashicColors.gold : AkashicColors.teal).withValues(alpha: 0.16),
                          borderRadius: BorderRadius.circular(7),
                        ),
                        child: Text(
                          copy.isOpened ? l10n.openedState : l10n.sealedState,
                          style: AkashicTypography.body(size: 11, weight: FontWeight.w700).copyWith(color: copy.isOpened ? AkashicColors.gold : AkashicColors.teal),
                        ),
                      ),
                    if (price != null) Text(price, style: AkashicTypography.numeral(size: 13)),
                  ],
                ),
                if (purchase.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 2),
                    child: Text(purchase, style: AkashicTypography.body(size: 12).copyWith(color: AkashicColors.textSoft)),
                  ),
                if (copy.location != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 2),
                    child: Row(
                      children: [
                        Icon(Icons.place_outlined, size: 14, color: AkashicColors.textSoft),
                        const SizedBox(width: 4),
                        Text(copy.location!, style: AkashicTypography.body(size: 12).copyWith(color: AkashicColors.textSoft)),
                      ],
                    ),
                  ),
                if (copy.loanedTo case final borrower?)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      l10n.lentToSince(borrower, DateFormat.yMMMd(l10n.localeName).format(copy.loanedSince ?? DateTime.now())),
                      style: AkashicTypography.body(size: 12, weight: FontWeight.w600).copyWith(color: AkashicColors.teal),
                    ),
                  ),
                if (copy.conditions.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: [
                        for (final MapEntry(key: part, value: condition) in copy.conditions.entries)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(color: AkashicColors.line, borderRadius: BorderRadius.circular(7)),
                            child: Text(l10n.partCondition(part, condition.label(l10n)), style: AkashicTypography.body(size: 11, weight: FontWeight.w600)),
                          ),
                      ],
                    ),
                  ),
                if ((copy.isLent ? onReturn : onLend) case final loanAction?)
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: loanAction,
                      child: Text(copy.isLent ? l10n.returnCopy : l10n.lendCopy, style: const TextStyle(color: AkashicColors.teal)),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
