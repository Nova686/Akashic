import 'dart:async';

import 'package:akashic/layers/functional/Collection/domain/entities/deck_card.dart';
import 'package:akashic/layers/functional/Collection/domain/use_cases/update_card_prices.dart';
import 'package:akashic/layers/functional/Collection/domain/use_cases/manage_deck.dart';
import 'package:akashic/layers/functional/Lookup/presentation/source_failure_toast.dart';
import 'package:akashic/layers/functional/Lookup/domain/entities/card_search_result.dart';
import 'package:akashic/layers/functional/Lookup/domain/entities/source_unavailable.dart';
import 'package:akashic/layers/functional/Lookup/domain/entities/precon_deck.dart';
import 'package:akashic/layers/functional/Lookup/domain/gateways/card_search.dart';
import 'package:akashic/layers/functional/Lookup/domain/gateways/precon_deck_catalogue.dart';
import 'package:equatable/equatable.dart';
import 'package:akashic/layers/technical/HttpAccess/debounced_search.dart';
import 'package:akashic/layers/functional/Lookup/domain/entities/imported_deck_list.dart';
import 'package:akashic/layers/functional/Lookup/domain/gateways/deck_list_source.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DeckEditorState extends Equatable {
  const DeckEditorState({
    this.cards = const [],
    this.searchResults = const [],
    this.isSearching = false,
    this.typedName = '',
    this.canSearchCards = false,
    this.isPricing = false,
    this.canPriceCards = false,
    this.canAddPrecon = false,
    this.isAddingPrecon = false,
    this.canImportDeckList = false,
    this.isImportingDeckList = false,
  });

  final List<DeckCard> cards;
  final List<CardSearchResult> searchResults;
  final bool isSearching;
  final String typedName;
  final bool canSearchCards;
  final bool isPricing;
  final bool canPriceCards;
  final bool canAddPrecon;
  final bool isAddingPrecon;
  final bool canImportDeckList;
  final bool isImportingDeckList;

  Map<String, int> get valueByCurrency => deckValueByCurrency(cards);

  int get totalCards => cards.fold(0, (total, card) => total + card.quantity);

  DeckEditorState copyWith({List<DeckCard>? cards, List<CardSearchResult>? searchResults, bool? isSearching, String? typedName, bool? isPricing, bool? isAddingPrecon, bool? isImportingDeckList}) {
    return DeckEditorState(
      cards: cards ?? this.cards,
      searchResults: searchResults ?? this.searchResults,
      isSearching: isSearching ?? this.isSearching,
      typedName: typedName ?? this.typedName,
      canSearchCards: canSearchCards,
      isPricing: isPricing ?? this.isPricing,
      canPriceCards: canPriceCards,
      canAddPrecon: canAddPrecon,
      isAddingPrecon: isAddingPrecon ?? this.isAddingPrecon,
      canImportDeckList: canImportDeckList,
      isImportingDeckList: isImportingDeckList ?? this.isImportingDeckList,
    );
  }

  @override
  List<Object?> get props => [cards, searchResults, isSearching, typedName, canSearchCards, isPricing, canPriceCards, canAddPrecon, isAddingPrecon, canImportDeckList, isImportingDeckList];
}

class DeckEditorCubit extends Cubit<DeckEditorState> {
  DeckEditorCubit({
    required this.itemId,
    required this._manageDeck,
    required this._cardSearches,
    this._searchDelay = DebouncedSearch.defaultDelay,
    this._updateCardPrices,
    this._preconDecks,
    this._deckListSources = const [],
  }) : super(DeckEditorState(canSearchCards: _cardSearches.isNotEmpty, canPriceCards: _updateCardPrices != null, canAddPrecon: _preconDecks != null, canImportDeckList: _deckListSources.isNotEmpty));

  final List<DeckListSource> _deckListSources;

  Future<(String, int)?> importDeckList(String link) async {
    final source = _deckListSources.where((candidate) => candidate.recognizes(link)).firstOrNull;
    if (source == null) {
      throw const DeckListNotFound();
    }
    if (state.isImportingDeckList) {
      return null;
    }
    emit(state.copyWith(isImportingDeckList: true));
    try {
      final deckList = await source.deckAt(link);
      final added = await _manageDeck.addAll(
        itemId,
        [for (final entry in deckList.cards) (entry.card, entry.quantity)],
        commanderNames: [for (final entry in deckList.cards) if (entry.isCommander) entry.card.name],
        traitsByCardId: {
          for (final entry in deckList.cards)
            if ((entry.card.externalCardId, entry.traits) case (final cardId?, final traits?)) cardId: traits,
        },
      );
      return (deckList.name, added);
    } on SourceUnavailable catch (failure) {
      showSourceFailure(failure);
      return null;
    } finally {
      if (!isClosed) {
        emit(state.copyWith(isImportingDeckList: false));
      }
    }
  }

  final String itemId;
  final ManageDeck _manageDeck;
  final List<CardSearch> _cardSearches;
  final Duration _searchDelay;
  final UpdateCardPrices? _updateCardPrices;
  final PreconDeckCatalogue? _preconDecks;

  Future<List<PreconDeck>> precons() async {
    final preconDecks = _preconDecks;
    if (preconDecks == null) {
      return const [];
    }
    try {
      return await preconDecks.decks();
    } on SourceUnavailable catch (failure) {
      showSourceFailure(failure);
      return const [];
    }
  }

  Future<int?> addPrecon(PreconDeck deck) async {
    final preconDecks = _preconDecks;
    if (preconDecks == null || state.isAddingPrecon) {
      return null;
    }
    emit(state.copyWith(isAddingPrecon: true));
    try {
      final cards = await preconDecks.cardsOf(deck);
      return await _manageDeck.addAll(itemId, [for (final card in cards) (card.card, card.quantity)], commanderNames: [for (final card in cards) if (card.isCommander) card.card.name]);
    } on SourceUnavailable catch (failure) {
      showSourceFailure(failure);
      return null;
    } finally {
      if (!isClosed) {
        emit(state.copyWith(isAddingPrecon: false));
      }
    }
  }

  Future<void> updatePrices() async {
    final updateCardPrices = _updateCardPrices;
    if (updateCardPrices == null || state.isPricing) {
      return;
    }
    emit(state.copyWith(isPricing: true));
    final pricing = await updateCardPrices(itemId);
    if (pricing.failure case final failure?) {
      showSourceFailure(failure);
    }
    if (!isClosed) {
      emit(state.copyWith(isPricing: false));
    }
  }
  StreamSubscription<List<DeckCard>>? _subscription;

  void start() {
    _subscription = _manageDeck.watch(itemId).listen((cards) {
      if (!isClosed) {
        emit(state.copyWith(cards: cards));
      }
    });
  }

  late final DebouncedSearch<CardSearchResult> _cardSearch = DebouncedSearch<CardSearchResult>(
    _searchAllCards,
    delay: _searchDelay,
    onOutcome: (outcome) {
      if (isClosed) {
        return;
      }
      emit(switch (outcome) {
        SearchCleared() => state.copyWith(searchResults: const [], isSearching: false),
        SearchStarted() => state.copyWith(isSearching: true),
        SearchFinished(:final results) => state.copyWith(searchResults: results, isSearching: false),
      });
    },
  );

  void search(String query) {
    emit(state.copyWith(typedName: query.trim()));
    if (_cardSearches.isNotEmpty) {
      _cardSearch.request(query);
    }
  }

  Future<void> addTypedCard() async {
    final name = state.typedName;
    if (name.isEmpty) {
      return;
    }
    await _manageDeck.add(itemId, CardSearchResult(name: name));
  }

  Future<List<CardSearchResult>> _searchAllCards(String query) async {
    final answers = await Future.wait(_cardSearches.map((cardSearch) => cardSearch.searchCards(query).catchError((Object failure) {
          showSourceFailure(failure as SourceUnavailable);
          return const <CardSearchResult>[];
        }, test: (error) => error is SourceUnavailable)));
    final results = <CardSearchResult>[];
    for (var rank = 0; answers.any((answer) => rank < answer.length); rank++) {
      for (final answer in answers) {
        if (rank < answer.length) {
          results.add(answer[rank]);
        }
      }
    }
    return results;
  }

  Future<void> add(CardSearchResult card) => _manageDeck.add(itemId, card);

  Future<void> setQuantity(String cardId, int quantity) => _manageDeck.setQuantity(cardId, quantity);

  Future<void> remove(String cardId) => _manageDeck.remove(cardId);

  @override
  Future<void> close() async {
    _cardSearch.close();
    await _subscription?.cancel();
    return super.close();
  }
}
