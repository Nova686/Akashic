import 'package:equatable/equatable.dart';

enum CardFamily { creature, planeswalker, battle, instant, sorcery, artifact, enchantment, land, other }

const List<String> manaColors = ['W', 'U', 'B', 'R', 'G'];

sealed class CommanderIssue extends Equatable {
  const CommanderIssue();
}

class WrongDeckSize extends CommanderIssue {
  const WrongDeckSize(this.cardCount);

  final int cardCount;

  @override
  List<Object?> get props => [cardCount];
}

class MissingCommander extends CommanderIssue {
  const MissingCommander();

  @override
  List<Object?> get props => [];
}

class DuplicateCards extends CommanderIssue {
  const DuplicateCards(this.cardNames);

  final List<String> cardNames;

  @override
  List<Object?> get props => [cardNames];
}

class OutsideColorIdentity extends CommanderIssue {
  const OutsideColorIdentity(this.cardNames);

  final List<String> cardNames;

  @override
  List<Object?> get props => [cardNames];
}

class DeckAnalysis extends Equatable {
  const DeckAnalysis({
    required this.cardCount,
    required this.familyCounts,
    required this.colorIdentity,
    required this.manaCurve,
    required this.averageManaValue,
    required this.cardsWithoutTraits,
    required this.commanderNames,
    required this.commanderIssues,
  });

  static const int manaCurveTop = 7;

  final int cardCount;
  final Map<CardFamily, int> familyCounts;
  final String colorIdentity;
  final List<int> manaCurve;
  final double? averageManaValue;
  final int cardsWithoutTraits;
  final List<String> commanderNames;
  final List<CommanderIssue> commanderIssues;

  bool get isCommanderLegal => commanderIssues.isEmpty;

  @override
  List<Object?> get props => [cardCount, familyCounts, colorIdentity, manaCurve, averageManaValue, cardsWithoutTraits, commanderNames, commanderIssues];
}
