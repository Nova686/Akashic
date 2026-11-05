import 'package:akashic/layers/functional/Collection/domain/entities/deck_analysis.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/deck_card.dart';
import 'package:akashic/layers/functional/Collection/domain/gateways/deck_gateway.dart';
import 'package:akashic/layers/functional/Collection/domain/use_cases/update_card_prices.dart';
import 'package:akashic/layers/functional/Lookup/domain/gateways/card_traits_catalogue.dart';

const int commanderDeckSize = 100;
const Set<String> basicLandNames = {'Plains', 'Island', 'Swamp', 'Mountain', 'Forest', 'Wastes'};

CardFamily familyOf(String typeLine) {
  final front = typeLine.split('//').first;
  for (final (word, family) in const [
    ('Land', CardFamily.land),
    ('Creature', CardFamily.creature),
    ('Planeswalker', CardFamily.planeswalker),
    ('Battle', CardFamily.battle),
    ('Instant', CardFamily.instant),
    ('Sorcery', CardFamily.sorcery),
    ('Artifact', CardFamily.artifact),
    ('Enchantment', CardFamily.enchantment),
  ]) {
    if (front.contains(word)) {
      return family;
    }
  }
  return CardFamily.other;
}

bool isBasicLand(DeckCard card) => basicLandNames.contains(card.name.replaceFirst('Snow-Covered ', '')) || (card.traits?.typeLine.startsWith('Basic') ?? false);

bool isLegendaryCreature(DeckCard card) {
  final front = card.traits?.typeLine.split('//').first ?? '';
  return front.contains('Legendary') && front.contains('Creature');
}

bool isMagicDeck(List<DeckCard> cards) => cards.isNotEmpty && cards.where((card) => cardSourceOf(card) == 'scryfall').length * 2 > cards.length;

DeckAnalysis analyzeDeck(List<DeckCard> cards) {
  final familyCounts = <CardFamily, int>{};
  final manaCurve = List<int>.filled(DeckAnalysis.manaCurveTop + 1, 0);
  final identity = <String>{};
  var manaTotal = 0.0;
  var spellCount = 0;
  var withoutTraits = 0;
  for (final card in cards) {
    final traits = card.traits;
    if (traits == null) {
      withoutTraits += card.quantity;
      continue;
    }
    final family = familyOf(traits.typeLine);
    familyCounts[family] = (familyCounts[family] ?? 0) + card.quantity;
    identity.addAll(traits.colorIdentity.split('').where(manaColors.contains));
    final manaValue = traits.manaValue;
    if (family != CardFamily.land && manaValue != null) {
      manaCurve[manaValue.floor().clamp(0, DeckAnalysis.manaCurveTop)] += card.quantity;
      manaTotal += manaValue * card.quantity;
      spellCount += card.quantity;
    }
  }
  final cardCount = cards.fold(0, (total, card) => total + card.quantity);
  final commanders = [for (final card in cards) if (card.isCommander) card]..sort((first, second) => first.commanderRole.index.compareTo(second.commanderRole.index));
  final commanderIdentity = {for (final commander in commanders) ...?commander.traits?.colorIdentity.split('')};
  final duplicates = <String, int>{};
  for (final card in cards) {
    if (!isBasicLand(card)) {
      duplicates[card.name] = (duplicates[card.name] ?? 0) + card.quantity;
    }
  }
  final outside = commanders.isEmpty || commanders.any((commander) => commander.traits == null)
      ? const <String>[]
      : [
          for (final card in cards)
            if (!card.isCommander && card.traits != null && !card.traits!.colorIdentity.split('').every(commanderIdentity.contains)) card.name,
        ];
  return DeckAnalysis(
    cardCount: cardCount,
    familyCounts: familyCounts,
    colorIdentity: [for (final color in manaColors) if (identity.contains(color)) color].join(),
    manaCurve: manaCurve,
    averageManaValue: spellCount == 0 ? null : manaTotal / spellCount,
    cardsWithoutTraits: withoutTraits,
    commanderNames: [for (final commander in commanders) commander.name],
    commanderIssues: [
      if (cardCount != commanderDeckSize) WrongDeckSize(cardCount),
      if (commanders.isEmpty) const MissingCommander(),
      if ([for (final MapEntry(key: name, value: count) in duplicates.entries) if (count > 1) name] case final names when names.isNotEmpty) DuplicateCards(names..sort()),
      if (outside.isNotEmpty) OutsideColorIdentity(outside..sort()),
    ],
  );
}

class FetchCardTraits {
  FetchCardTraits(this._deck, this._catalogue);

  final DeckGateway _deck;
  final CardTraitsCatalogue _catalogue;

  Future<int> call(String itemId) async {
    final missing = [for (final card in await _deck.watchCards(itemId).first) if (card.traits == null && card.externalCardId != null && cardSourceOf(card) == _catalogue.key) card];
    if (missing.isEmpty) {
      return 0;
    }
    final traits = await _catalogue.traitsOf([for (final card in missing) card.externalCardId!]);
    final filled = [
      for (final card in missing)
        if (traits[card.externalCardId] case final found?) card.copyWith(traits: found),
    ];
    await _deck.saveCards(filled);
    return filled.length;
  }
}
