import 'dart:convert';

import 'package:akashic/layers/functional/Collection/data/gateways/drift_deck_gateway.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/card_kind.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/collection_item.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/deck_analysis.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/deck_card.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/localized_titles.dart';
import 'package:akashic/layers/functional/Collection/domain/use_cases/analyze_deck.dart';
import 'package:akashic/layers/functional/Collection/presentation/widgets/deck_analysis_panel.dart';
import 'package:akashic/layers/functional/Collection/presentation/widgets/deck_tabs.dart';
import 'package:akashic/layers/functional/Collection/domain/use_cases/manage_deck.dart';
import 'package:akashic/layers/functional/Lookup/data/sources/scryfall_source.dart';
import 'package:akashic/layers/functional/Lookup/domain/gateways/card_traits_catalogue.dart';
import 'package:akashic/layers/technical/Localization/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

import '../collection_harness.dart';

const String commanderId = 'ab12cd34-0000-0000-0000-000000000000';

DeckCard magicCard(String name, {int quantity = 1, String? typeLine, String identity = '', double? manaValue, CommanderRole role = CommanderRole.none, String? id}) => DeckCard(
      id: id ?? name,
      itemId: 'deck',
      name: name,
      quantity: quantity,
      externalCardId: commanderId,
      sourceKey: 'scryfall',
      traits: typeLine == null ? null : CardTraits(typeLine: typeLine, colorIdentity: identity, manaValue: manaValue),
      commanderRole: role,
    );

class FakeTraitsCatalogue implements CardTraitsCatalogue {
  final List<List<String>> askedIds = [];

  @override
  String get key => 'scryfall';

  @override
  Future<Map<String, CardTraits>> traitsOf(List<String> externalCardIds) async {
    askedIds.add(externalCardIds);
    return {'known': const CardTraits(typeLine: 'Artifact', colorIdentity: '', manaValue: 1)};
  }
}

void main() {
  test('a deck is broken down by card family, colour identity and mana curve, lands aside', () {
    final analysis = analyzeDeck([
      magicCard('Brimaz', typeLine: 'Legendary Creature — Cat Soldier', identity: 'WB', manaValue: 3, role: CommanderRole.primary),
      magicCard('Sol Ring', typeLine: 'Artifact', manaValue: 1),
      magicCard('Swords', typeLine: 'Instant', identity: 'W', manaValue: 1),
      magicCard('Myr', typeLine: 'Artifact Creature — Myr', manaValue: 9),
      magicCard('Plains', quantity: 10, typeLine: 'Basic Land — Plains', identity: 'W'),
      magicCard('Unknown'),
    ]);
    expect(analysis.familyCounts, {CardFamily.creature: 2, CardFamily.artifact: 1, CardFamily.instant: 1, CardFamily.land: 10});
    expect(analysis.colorIdentity, 'WB');
    expect(analysis.manaCurve, [0, 2, 0, 1, 0, 0, 0, 1]);
    expect(analysis.averageManaValue, 3.5);
    expect(analysis.cardsWithoutTraits, 1);
    expect(analysis.cardCount, 15);
  });

  test('commander rules check size, commander, singleton outside basic lands and colour identity', () {
    final legal = analyzeDeck([
      magicCard('Brimaz', typeLine: 'Legendary Creature — Cat', identity: 'WB', manaValue: 3, role: CommanderRole.primary),
      magicCard('Snow-Covered Plains', quantity: 98, typeLine: 'Basic Snow Land — Plains', identity: 'W'),
      magicCard('Sol Ring', typeLine: 'Artifact', manaValue: 1),
    ]);
    expect(legal.commanderIssues, isEmpty);
    final broken = analyzeDeck([
      magicCard('Brimaz', typeLine: 'Legendary Creature — Cat', identity: 'WB', manaValue: 3, role: CommanderRole.primary),
      magicCard('Sol Ring', quantity: 2, typeLine: 'Artifact', manaValue: 1),
      magicCard('Lightning Bolt', typeLine: 'Instant', identity: 'R', manaValue: 1),
    ]);
    expect(broken.commanderIssues, const [
      WrongDeckSize(4),
      DuplicateCards(['Sol Ring']),
      OutsideColorIdentity(['Lightning Bolt']),
    ]);
    expect(analyzeDeck([magicCard('Sol Ring', typeLine: 'Artifact')]).commanderIssues, contains(const MissingCommander()));
  });

  test('scryfall gives the traits of many cards in batches of 75', () async {
    final batches = <int>[];
    final source = ScryfallSource(MockClient((request) async {
      expect(request.url.path, '/cards/collection');
      final identifiers = (jsonDecode(request.body) as Map<String, dynamic>)['identifiers'] as List;
      batches.add(identifiers.length);
      return http.Response(
        jsonEncode({
          'data': [
            for (final identifier in identifiers)
              {'id': (identifier as Map)['id'], 'type_line': 'Legendary Creature — Cat', 'color_identity': ['W', 'B'], 'cmc': 3.0},
          ],
        }),
        200,
        headers: {'content-type': 'application/json'},
      );
    }));
    final traits = await source.traitsOf([for (var index = 0; index < 80; index++) 'card-$index']);
    expect(batches, [75, 5]);
    expect(traits['card-79'], const CardTraits(typeLine: 'Legendary Creature — Cat', colorIdentity: 'WB', manaValue: 3));
  });

  test('missing traits are fetched once for the scryfall cards of a deck', () async {
    final harness = CollectionHarness();
    final mangas = await harness.mangas();
    await harness.collection.saveItem(CollectionItem(id: 'deck', categoryId: mangas.id, titles: const LocalizedTitles(byLanguage: {'fr': 'Deck'}), cardKind: CardKind.deck));
    final deck = DriftDeckGateway(harness.database);
    await deck.saveCard(const DeckCard(id: 'a', itemId: 'deck', name: 'Sol Ring', quantity: 1, externalCardId: 'known', sourceKey: 'scryfall'));
    await deck.saveCard(const DeckCard(id: 'b', itemId: 'deck', name: 'Pikachu', quantity: 1, externalCardId: 'swsh1-1', sourceKey: 'tcgdex'));
    final catalogue = FakeTraitsCatalogue();
    expect(await FetchCardTraits(deck, catalogue)('deck'), 1);
    expect(catalogue.askedIds, [
      ['known'],
    ]);
    expect((await deck.findCard('a'))!.traits, const CardTraits(typeLine: 'Artifact', colorIdentity: '', manaValue: 1));
    expect(await FetchCardTraits(deck, catalogue)('deck'), 0);
    await harness.database.close();
  });

  testWidgets('the deck page shows the analysis and lets the commander be chosen', (tester) async {
    final chosen = <(String, CommanderRole)>[];
    await tester.binding.setSurfaceSize(const Size(600, 1600));
    await tester.pumpWidget(MaterialApp(
      locale: const Locale('fr'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(
        body: SingleChildScrollView(
          child: DeckAnalysisPanel(
            cards: Stream.value([
              magicCard('Brimaz', typeLine: 'Legendary Creature — Cat', identity: 'WB', manaValue: 3),
              magicCard('Sol Ring', quantity: 2, typeLine: 'Artifact', manaValue: 1),
            ]),
            onFetchTraits: () async => 0,
            onSetCommander: (cardId, role) async => chosen.add((cardId, role)),
            onSwapCommanders: () async {},
          ),
        ),
      ),
    ));
    await tester.pump();
    expect(find.text('Créatures'), findsOneWidget);
    expect(find.text('100 cartes exactement (actuellement 3)'), findsOneWidget);
    expect(find.text('En plusieurs exemplaires : Sol Ring'), findsOneWidget);
    await tester.tap(find.text('Choisir le commandant'));
    await tester.pumpAndSettle();
    expect(find.text('Sol Ring'), findsNothing);
    await tester.tap(find.text('Secondaire').first);
    expect(chosen, [('Brimaz', CommanderRole.secondary)]);
    await tester.binding.setSurfaceSize(null);
  });

  test('only legendary creatures, whatever their other types, can lead a commander deck', () {
    bool canLead(String typeLine) => isLegendaryCreature(magicCard('card', typeLine: typeLine));
    expect(canLead('Legendary Creature — Cat Soldier'), isTrue);
    expect(canLead('Legendary Artifact Creature — Golem'), isTrue);
    expect(canLead('Legendary Enchantment Creature — God'), isTrue);
    expect(canLead('Legendary Snow Creature — Elemental'), isTrue);
    expect(canLead('Legendary Creature — Human Wizard // Legendary Planeswalker — Jace'), isTrue);
    expect(canLead('Creature — Cat'), isFalse);
    expect(canLead('Legendary Artifact'), isFalse);
    expect(canLead('Legendary Land'), isFalse);
    expect(canLead('Legendary Planeswalker — Teferi'), isFalse);
    expect(canLead('Legendary Enchantment — Saga // Legendary Creature — Dragon'), isFalse);
    expect(isLegendaryCreature(magicCard('unknown')), isFalse);
  });

  test('a deck has one main and one secondary commander, that can be swapped', () async {
    final harness = CollectionHarness();
    final mangas = await harness.mangas();
    await harness.collection.saveItem(CollectionItem(id: 'deck', categoryId: mangas.id, titles: const LocalizedTitles(byLanguage: {'fr': 'Deck'}), cardKind: CardKind.deck));
    final deck = DriftDeckGateway(harness.database);
    for (final name in ['Tymna', 'Thrasios', 'Kraum']) {
      await deck.saveCard(DeckCard(id: name, itemId: 'deck', name: name, quantity: 1));
    }
    final manage = ManageDeck(deck);
    Future<Map<String, CommanderRole>> roles() async => {for (final card in await deck.watchCards('deck').first) if (card.isCommander) card.name: card.commanderRole};
    await manage.setCommanderRole('Thrasios', CommanderRole.secondary);
    expect(await roles(), {'Thrasios': CommanderRole.primary});
    await manage.setCommanderRole('Tymna', CommanderRole.primary);
    expect(await roles(), {'Tymna': CommanderRole.primary, 'Thrasios': CommanderRole.secondary});
    await manage.swapCommanders('deck');
    expect(await roles(), {'Thrasios': CommanderRole.primary, 'Tymna': CommanderRole.secondary});
    await manage.setCommanderRole('Kraum', CommanderRole.secondary);
    expect(await roles(), {'Thrasios': CommanderRole.primary, 'Kraum': CommanderRole.secondary});
    await manage.setCommanderRole('Kraum', CommanderRole.primary);
    expect(await roles(), {'Kraum': CommanderRole.primary, 'Thrasios': CommanderRole.secondary});
    await manage.setCommanderRole('Kraum', CommanderRole.none);
    expect(await roles(), {'Thrasios': CommanderRole.primary});
    expect(analyzeDeck([
      magicCard('Tymna', typeLine: 'Legendary Creature', identity: 'WB', role: CommanderRole.secondary),
      magicCard('Thrasios', typeLine: 'Legendary Creature', identity: 'GU', role: CommanderRole.primary),
    ]).commanderNames, ['Thrasios', 'Tymna']);
    await harness.database.close();
  });

  testWidgets('the deck page opens on its cards, the analysis sits in the second tab', (tester) async {
    await tester.binding.setSurfaceSize(const Size(600, 1600));
    await tester.pumpWidget(MaterialApp(
      locale: const Locale('fr'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: DefaultTabController(
        length: 2,
        child: Scaffold(
          body: CustomScrollView(
            slivers: [
              DeckTabs(
              cards: Stream.value([
                magicCard('Tymna', typeLine: 'Legendary Creature', identity: 'WB', manaValue: 2, role: CommanderRole.primary),
                magicCard('Thrasios', typeLine: 'Legendary Creature', identity: 'GU', manaValue: 2, role: CommanderRole.secondary),
              ]),
              onFetchTraits: () async => 0,
              onSetCommander: (cardId, role) async {},
              onSwapCommanders: () async {},
            ),
            ],
          ),
        ),
      ),
    ));
    await tester.pumpAndSettle();
    expect(find.text('Cartes'), findsOneWidget);
    expect(find.text('2 cartes dans le deck'), findsOneWidget);
    expect(find.text('Créatures'), findsNothing);
    await tester.tap(find.text('Analyse'));
    await tester.pumpAndSettle();
    expect(find.text('Créatures'), findsOneWidget);
    expect(find.text('Commandant principal : Tymna'), findsOneWidget);
    expect(find.text('Commandant secondaire : Thrasios'), findsOneWidget);
    expect(find.byTooltip('Alterner principal et secondaire'), findsOneWidget);
    await tester.tap(find.text('Cartes'));
    await tester.pumpAndSettle();
    expect(find.text('2 cartes dans le deck'), findsOneWidget);
    await tester.binding.setSurfaceSize(null);
  });

  testWidgets('the analysis holds large text without overflowing', (tester) async {
    await tester.pumpWidget(MaterialApp(
      locale: const Locale('fr'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: MediaQuery(
        data: const MediaQueryData(textScaler: TextScaler.linear(2)),
        child: Scaffold(
          body: SingleChildScrollView(
            child: DeckAnalysisPanel(
              cards: Stream.value([
                magicCard('Brimaz', typeLine: 'Legendary Creature — Cat', identity: 'WB', manaValue: 3, role: CommanderRole.primary),
                magicCard('Sol Ring', typeLine: 'Artifact', manaValue: 1),
                magicCard('Plains', quantity: 30, typeLine: 'Basic Land — Plains', identity: 'W'),
              ]),
              onFetchTraits: () async => 0,
              onSetCommander: (cardId, role) async {},
              onSwapCommanders: () async {},
            ),
          ),
        ),
      ),
    ));
    await tester.pump();
    expect(find.text('Créatures'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('a large deck only builds the cards that are on screen', (tester) async {
    await tester.binding.setSurfaceSize(const Size(400, 700));
    await tester.pumpWidget(MaterialApp(
      locale: const Locale('fr'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: DefaultTabController(
        length: 2,
        child: Scaffold(
          body: CustomScrollView(
            slivers: [
              DeckTabs(cards: Stream.value([for (var index = 0; index < 200; index++) DeckCard(id: 'card-$index', itemId: 'deck', name: 'Pokémon $index', quantity: 1, sourceKey: 'tcgdex')])),
            ],
          ),
        ),
      ),
    ));
    await tester.pump();
    await tester.pump();
    expect(find.text('200 cartes dans le deck'), findsOneWidget);
    expect(find.textContaining('Pokémon '), findsWidgets);
    expect(find.textContaining('Pokémon ').evaluate().length, lessThan(60));
    await tester.binding.setSurfaceSize(null);
  });
}

