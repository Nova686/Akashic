import 'package:akashic/layers/functional/Collection/domain/entities/deck_analysis.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/deck_card.dart';
import 'package:akashic/layers/functional/Collection/domain/use_cases/analyze_deck.dart';
import 'package:akashic/layers/technical/Localization/app_localizations.dart';
import 'package:akashic/layers/technical/Theme/akashic_colors.dart';
import 'package:akashic/layers/technical/Theme/akashic_typography.dart';
import 'package:akashic/layers/technical/Theme/safe_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

const Map<String, Color> manaColorSwatches = {
  'W': Color(0xFFF4EBC6),
  'U': Color(0xFF7FB6E8),
  'B': Color(0xFF9B8C99),
  'R': Color(0xFFEE8A6E),
  'G': Color(0xFF7CC08E),
};

String cardFamilyLabel(AppLocalizations l10n, CardFamily family) => switch (family) {
      CardFamily.creature => l10n.cardFamilyCreature,
      CardFamily.planeswalker => l10n.cardFamilyPlaneswalker,
      CardFamily.battle => l10n.cardFamilyBattle,
      CardFamily.instant => l10n.cardFamilyInstant,
      CardFamily.sorcery => l10n.cardFamilySorcery,
      CardFamily.artifact => l10n.cardFamilyArtifact,
      CardFamily.enchantment => l10n.cardFamilyEnchantment,
      CardFamily.land => l10n.cardFamilyLand,
      CardFamily.other => l10n.cardFamilyOther,
    };

String manaColorName(AppLocalizations l10n, String color) => switch (color) {
      'W' => l10n.manaWhite,
      'U' => l10n.manaBlue,
      'B' => l10n.manaBlack,
      'R' => l10n.manaRed,
      _ => l10n.manaGreen,
    };

class DeckAnalysisPanel extends StatefulWidget {
  const DeckAnalysisPanel({required this.cards, required this.onFetchTraits, required this.onSetCommander, required this.onSwapCommanders, super.key});

  final Stream<List<DeckCard>> cards;
  final Future<int> Function() onFetchTraits;
  final Future<void> Function(String cardId, CommanderRole role) onSetCommander;
  final Future<void> Function() onSwapCommanders;

  @override
  State<DeckAnalysisPanel> createState() => _DeckAnalysisPanelState();
}

class _DeckAnalysisPanelState extends State<DeckAnalysisPanel> {
  late final Stream<List<DeckCard>> _cards = widget.cards.asBroadcastStream();
  bool _isFetching = false;

  Future<void> _fetchTraits() async {
    setState(() => _isFetching = true);
    try {
      await widget.onFetchTraits();
    } finally {
      if (mounted) {
        setState(() => _isFetching = false);
      }
    }
  }

  Future<void> _chooseCommander(List<DeckCard> cards) => showSafeBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        builder: (sheetContext) => _CommanderPicker(cards: _cards, initialCards: cards, onSetCommander: widget.onSetCommander),
      );

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return StreamBuilder<List<DeckCard>>(
      stream: _cards,
      builder: (context, snapshot) {
        final cards = snapshot.data ?? const <DeckCard>[];
        final value = DeckValueSection(cards: cards);
        if (!isMagicDeck(cards)) {
          return value;
        }
        final analysis = analyzeDeck(cards);
        return Padding(
          padding: const EdgeInsets.only(top: 18, bottom: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              value,
              if (analysis.cardsWithoutTraits > 0)
                Row(
                  children: [
                    Expanded(child: Text(l10n.cardsWithoutTraits(analysis.cardsWithoutTraits), style: AkashicTypography.body(size: 13).copyWith(color: AkashicColors.textSoft))),
                    if (_isFetching)
                      const SizedBox.square(dimension: 20, child: CircularProgressIndicator(strokeWidth: 2))
                    else
                      TextButton(onPressed: _fetchTraits, child: Text(l10n.fetchCardTraits)),
                  ],
                ),
              if (analysis.colorIdentity.isNotEmpty) _ColorIdentity(colors: analysis.colorIdentity),
              if (analysis.familyCounts.isNotEmpty) ...[
                const SizedBox(height: 10),
                _FamilyBars(analysis: analysis),
              ],
              if (analysis.averageManaValue != null) ...[
                const SizedBox(height: 14),
                _ManaCurve(analysis: analysis),
              ],
              const SizedBox(height: 16),
              _CommanderRules(analysis: analysis, onChooseCommander: () => _chooseCommander(cards), onSwapCommanders: widget.onSwapCommanders),
            ],
          ),
        );
      },
    );
  }
}

class _ColorIdentity extends StatelessWidget {
  const _ColorIdentity({required this.colors});

  final String colors;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Semantics(
      label: l10n.colorIdentityLabel([for (final color in colors.split('')) manaColorName(l10n, color)].join(', ')),
      excludeSemantics: true,
      child: Row(
        children: [
          Text(l10n.colorIdentityTitle, style: AkashicTypography.body(size: 14, weight: FontWeight.w600)),
          const SizedBox(width: 10),
          for (final color in colors.split(''))
            Container(
              width: 26,
              height: 26,
              margin: const EdgeInsets.only(right: 6),
              alignment: Alignment.center,
              decoration: BoxDecoration(color: manaColorSwatches[color], shape: BoxShape.circle),
              child: Text(color, style: AkashicTypography.numeral(size: 12).copyWith(color: AkashicColors.night)),
            ),
        ],
      ),
    );
  }
}

class _FamilyBars extends StatelessWidget {
  const _FamilyBars({required this.analysis});

  final DeckAnalysis analysis;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final largest = analysis.familyCounts.values.fold(1, (most, count) => count > most ? count : most);
    return Column(
      children: [
        for (final family in CardFamily.values)
          if (analysis.familyCounts[family] case final count?)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 3),
              child: Row(
                children: [
                  SizedBox(width: 110, child: Text(cardFamilyLabel(l10n, family), style: AkashicTypography.body(size: 13))),
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(value: count / largest, minHeight: 6, color: AkashicColors.lavender, backgroundColor: AkashicColors.line),
                    ),
                  ),
                  SizedBox(width: 36, child: Text('$count', textAlign: TextAlign.right, style: AkashicTypography.numeral(size: 13))),
                ],
              ),
            ),
      ],
    );
  }
}

class _ManaCurve extends StatelessWidget {
  const _ManaCurve({required this.analysis});

  static const double chartHeight = 70;

  final DeckAnalysis analysis;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final busiest = analysis.manaCurve.fold(1, (most, count) => count > most ? count : most);
    String costLabel(int cost) => cost == DeckAnalysis.manaCurveTop ? '$cost+' : '$cost';
    return Semantics(
      label: '${l10n.manaCurveTitle}. ${[for (final (cost, count) in analysis.manaCurve.indexed) l10n.manaCurveEntry(costLabel(cost), count)].join(', ')}',
      excludeSemantics: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l10n.manaCurveSummary(analysis.averageManaValue!.toStringAsFixed(2)), style: AkashicTypography.body(size: 14, weight: FontWeight.w600)),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              for (final (cost, count) in analysis.manaCurve.indexed)
                Expanded(
                  child: Column(
                    children: [
                      SizedBox(
                        height: chartHeight + 2,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Container(
                              margin: const EdgeInsets.symmetric(horizontal: 4),
                              height: chartHeight * count / busiest + 2,
                              decoration: BoxDecoration(color: count == 0 ? AkashicColors.line : AkashicColors.teal, borderRadius: BorderRadius.circular(3)),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(costLabel(cost), style: AkashicTypography.numeral(size: 11).copyWith(color: AkashicColors.textSoft)),
                      Text('$count', style: AkashicTypography.numeral(size: 10)),
                    ],
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CommanderRules extends StatelessWidget {
  const _CommanderRules({required this.analysis, required this.onChooseCommander, required this.onSwapCommanders});

  final DeckAnalysis analysis;
  final VoidCallback onChooseCommander;
  final Future<void> Function() onSwapCommanders;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    T? issueOf<T extends CommanderIssue>() => analysis.commanderIssues.whereType<T>().firstOrNull;
    final duplicates = issueOf<DuplicateCards>();
    final outside = issueOf<OutsideColorIdentity>();
    final identityUnknown = analysis.commanderNames.isEmpty || analysis.cardsWithoutTraits > 0;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(l10n.commanderRulesTitle, style: AkashicTypography.body(size: 15, weight: FontWeight.w800)),
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (analysis.commanderNames.isEmpty)
                    Text(l10n.noCommanderChosen, style: AkashicTypography.body(size: 13).copyWith(color: AkashicColors.textSoft))
                  else ...[
                    Text(l10n.primaryCommanderIs(analysis.commanderNames.first), style: AkashicTypography.body(size: 13, weight: FontWeight.w600)),
                    if (analysis.commanderNames.length > 1)
                      Text(l10n.secondaryCommanderIs(analysis.commanderNames[1]), style: AkashicTypography.body(size: 13).copyWith(color: AkashicColors.textSoft)),
                  ],
                ],
              ),
            ),
            if (analysis.commanderNames.length > 1) IconButton(tooltip: l10n.swapCommanders, icon: const Icon(Icons.swap_vert), onPressed: onSwapCommanders),
          ],
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: TextButton(onPressed: onChooseCommander, child: Text(l10n.chooseCommander)),
        ),
        _RuleLine(isMet: issueOf<WrongDeckSize>() == null, text: l10n.commanderRuleSize(analysis.cardCount)),
        _RuleLine(isMet: analysis.commanderNames.isNotEmpty, text: l10n.commanderRuleCommander),
        _RuleLine(isMet: duplicates == null, text: duplicates == null ? l10n.commanderRuleSingleton : l10n.commanderRuleDuplicates(duplicates.cardNames.join(', '))),
        if (identityUnknown && outside == null)
          _RuleLine(isMet: null, text: l10n.commanderRuleIdentityUnknown)
        else
          _RuleLine(isMet: outside == null, text: outside == null ? l10n.commanderRuleIdentity : l10n.commanderRuleOutsideIdentity(outside.cardNames.join(', '))),
      ],
    );
  }
}

class _RuleLine extends StatelessWidget {
  const _RuleLine({required this.isMet, required this.text});

  final bool? isMet;
  final String text;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final (icon, color, state) = switch (isMet) {
      true => (Icons.check_circle, AkashicColors.teal, l10n.ruleMet),
      false => (Icons.cancel, AkashicColors.missing, l10n.ruleNotMet),
      null => (Icons.help_outline, AkashicColors.textSoft, l10n.ruleUnknown),
    };
    return Semantics(
      label: '$state. $text',
      excludeSemantics: true,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 18, color: color),
            const SizedBox(width: 8),
            Expanded(child: Text(text, style: AkashicTypography.body(size: 13))),
          ],
        ),
      ),
    );
  }
}

class _CommanderPicker extends StatelessWidget {
  const _CommanderPicker({required this.cards, required this.initialCards, required this.onSetCommander});

  final Stream<List<DeckCard>> cards;
  final List<DeckCard> initialCards;
  final Future<void> Function(String cardId, CommanderRole role) onSetCommander;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return StreamBuilder<List<DeckCard>>(
      stream: cards,
      initialData: initialCards,
      builder: (context, snapshot) {
        final all = snapshot.data ?? initialCards;
        final candidates = [for (final card in all) if (card.isCommander || isLegendaryCreature(card)) card];
        final hasCardsWithoutTraits = all.any((card) => card.traits == null);
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.6,
          builder: (context, controller) => ListView(
            controller: controller,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                child: Text(l10n.chooseCommander, style: AkashicTypography.displayTitle(size: 22)),
              ),
              if (candidates.isEmpty || hasCardsWithoutTraits)
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                  child: Text(
                    hasCardsWithoutTraits ? l10n.commanderCandidatesNeedTraits : l10n.noLegendaryCreature,
                    style: AkashicTypography.body(size: 13).copyWith(color: AkashicColors.textSoft),
                  ),
                ),
              for (final card in candidates)
                ListTile(
                  title: Text(card.name),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (card.traits case final traits?) Text(traits.typeLine),
                      const SizedBox(height: 4),
                      Wrap(
                        spacing: 8,
                        children: [
                          for (final (role, label) in [(CommanderRole.primary, l10n.primaryCommander), (CommanderRole.secondary, l10n.secondaryCommander)])
                            ChoiceChip(
                              label: Text(label),
                              selected: card.commanderRole == role,
                              onSelected: (isSelected) => onSetCommander(card.id, isSelected ? role : CommanderRole.none),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}

typedef DeckValue = ({int totalCents, int pricedCards, int cardCount, List<(DeckCard, int)> priciest, DateTime? pricedAt});

DeckValue deckValueOf(List<DeckCard> cards, {String currency = 'EUR', int shown = 5}) {
  final priced = [
    for (final card in cards)
      if (card.price case final price? when price.currency == currency) (card, price.cents * card.quantity),
  ]..sort((first, second) => second.$2.compareTo(first.$2));
  final latest = [for (final card in cards) ?card.price?.pricedAt].fold<DateTime?>(null, (newest, date) => newest == null || date.isAfter(newest) ? date : newest);
  return (
    totalCents: priced.fold(0, (total, entry) => total + entry.$2),
    pricedCards: priced.fold(0, (total, entry) => total + entry.$1.quantity),
    cardCount: cards.fold(0, (total, card) => total + card.quantity),
    priciest: priced.take(shown).toList(),
    pricedAt: latest,
  );
}

class DeckValueSection extends StatelessWidget {
  const DeckValueSection({required this.cards, super.key});

  final List<DeckCard> cards;

  @override
  Widget build(BuildContext context) {
    final value = deckValueOf(cards);
    if (value.totalCents == 0) {
      return const SizedBox.shrink();
    }
    final l10n = AppLocalizations.of(context);
    final money = NumberFormat.currency(locale: l10n.localeName, symbol: '€');
    final topShare = value.priciest.fold<int>(0, (total, entry) => total + entry.$2) / value.totalCents;
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(l10n.deckValue.toUpperCase(), style: AkashicTypography.body(size: 11, weight: FontWeight.w800).copyWith(color: AkashicColors.textSoft, letterSpacing: 1.1)),
          Text(money.format(value.totalCents / 100), style: AkashicTypography.numeral(size: 34).copyWith(color: AkashicColors.gold)),
          Text(
            [
              l10n.deckPricedCards(value.pricedCards, value.cardCount),
              if (value.pricedAt case final date?) l10n.deckPricedOn(DateFormat.yMMMd(l10n.localeName).format(date)),
            ].join(' · '),
            style: AkashicTypography.body(size: 12).copyWith(color: AkashicColors.textSoft),
          ),
          const SizedBox(height: 10),
          Text(l10n.deckPriciestCards.toUpperCase(), style: AkashicTypography.body(size: 11, weight: FontWeight.w800).copyWith(color: AkashicColors.textSoft, letterSpacing: 1.1)),
          for (final (index, (card, cents)) in value.priciest.indexed)
            Padding(
              padding: const EdgeInsets.only(top: 6),
              child: Row(
                children: [
                  SizedBox(width: 22, child: Text('${index + 1}', style: AkashicTypography.numeral(size: 14).copyWith(color: AkashicColors.textSoft))),
                  Expanded(child: Text(card.quantity > 1 ? '${card.quantity} × ${card.name}' : card.name, maxLines: 1, overflow: TextOverflow.ellipsis, style: AkashicTypography.body(size: 14, weight: FontWeight.w700))),
                  Text(money.format(cents / 100), style: AkashicTypography.body(size: 14, weight: FontWeight.w800)),
                ],
              ),
            ),
          const SizedBox(height: 4),
          Text(l10n.deckTopShare((topShare * 100).round()), style: AkashicTypography.body(size: 12).copyWith(color: AkashicColors.textSoft)),
        ],
      ),
    );
  }
}
