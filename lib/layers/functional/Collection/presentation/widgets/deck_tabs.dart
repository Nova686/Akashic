import 'dart:async';

import 'package:akashic/layers/functional/Collection/domain/entities/deck_card.dart';
import 'package:akashic/layers/functional/Collection/domain/use_cases/analyze_deck.dart';
import 'package:akashic/layers/functional/Collection/presentation/widgets/deck_analysis_panel.dart';
import 'package:akashic/layers/functional/Collection/presentation/widgets/deck_card_grid.dart';
import 'package:akashic/layers/technical/Localization/app_localizations.dart';
import 'package:flutter/material.dart';

class DeckTabs extends StatefulWidget {
  const DeckTabs({required this.cards, this.onFetchTraits, this.onSetCommander, this.onSwapCommanders, super.key});

  final Stream<List<DeckCard>> cards;
  final Future<int> Function()? onFetchTraits;
  final Future<void> Function(String cardId, CommanderRole role)? onSetCommander;
  final Future<void> Function()? onSwapCommanders;

  @override
  State<DeckTabs> createState() => _DeckTabsState();
}

class _DeckTabsState extends State<DeckTabs> {
  final StreamController<List<DeckCard>> _updates = StreamController<List<DeckCard>>.broadcast();
  late final StreamSubscription<List<DeckCard>> _subscription;
  List<DeckCard>? _latest;
  (bool, int)? _shownView;
  Stream<List<DeckCard>>? _shownCards;

  @override
  void initState() {
    super.initState();
    _subscription = widget.cards.listen((cards) {
      _latest = cards;
      _updates.add(cards);
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _subscription.cancel();
    _updates.close();
    super.dispose();
  }

  Stream<List<DeckCard>> _replay() async* {
    if (_latest case final latest?) {
      yield latest;
    }
    yield* _updates.stream;
  }

  Stream<List<DeckCard>> _cardsFor({required bool isTabbed, required int tab}) {
    if (_shownView != (isTabbed, tab) || _shownCards == null) {
      _shownView = (isTabbed, tab);
      _shownCards = _replay();
    }
    return _shownCards!;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final fetchTraits = widget.onFetchTraits;
    final setCommander = widget.onSetCommander;
    final swapCommanders = widget.onSwapCommanders;
    final cards = _latest;
    if (cards == null) {
      return const SliverToBoxAdapter(child: SizedBox.shrink());
    }
    if (fetchTraits == null || setCommander == null || swapCommanders == null || !isMagicDeck(cards)) {
      return DeckCardGrid(cards: _cardsFor(isTabbed: false, tab: 0));
    }
    final tabs = DefaultTabController.of(context);
    return SliverMainAxisGroup(
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.only(top: 12),
            child: TabBar(
              tabs: [
                Tab(text: l10n.deckCardsTab),
                Tab(text: l10n.deckAnalysisTab),
              ],
            ),
          ),
        ),
        AnimatedBuilder(
          animation: tabs,
          builder: (context, _) => tabs.index == 0
              ? DeckCardGrid(cards: _cardsFor(isTabbed: true, tab: 0))
              : SliverToBoxAdapter(
                  child: DeckAnalysisPanel(cards: _cardsFor(isTabbed: true, tab: 1), onFetchTraits: fetchTraits, onSetCommander: setCommander, onSwapCommanders: swapCommanders),
                ),
        ),
      ],
    );
  }
}
