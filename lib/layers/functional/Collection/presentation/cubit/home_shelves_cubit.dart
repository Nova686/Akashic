import 'dart:async';

import 'package:akashic/layers/functional/Catalog/domain/entities/category.dart';
import 'package:akashic/layers/functional/Catalog/domain/use_cases/watch_category_tree.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/shelf_group.dart';
import 'package:akashic/layers/functional/Collection/domain/use_cases/search_collection.dart';
import 'package:akashic/layers/functional/Collection/domain/use_cases/watch_shelf.dart';
import 'package:akashic/layers/functional/Collection/presentation/cubit/home_shelves_state.dart';
import 'package:akashic/layers/functional/Settings/domain/use_cases/manage_collapsed_series.dart';
import 'package:akashic/layers/functional/Settings/domain/use_cases/manage_preferred_languages.dart';
import 'package:akashic/layers/functional/Settings/domain/use_cases/manage_recent_searches.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeShelvesCubit extends Cubit<HomeShelvesState> {
  HomeShelvesCubit({
    required this._watchCategoryTree,
    required this._watchShelf,
    required this._searchCollection,
    required this._preferredLanguages,
    required this._collapsedSeries,
    this._searchDelay = const Duration(milliseconds: 250),
    this._recentSearches,
  }) : super(const HomeShelvesState());

  final WatchCategoryTree _watchCategoryTree;
  final WatchShelf _watchShelf;
  final SearchCollection _searchCollection;
  final ManagePreferredLanguages _preferredLanguages;
  final ManageCollapsedSeries _collapsedSeries;
  final Duration _searchDelay;
  final ManageRecentSearches? _recentSearches;
  final List<StreamSubscription<Object?>> _subscriptions = [];
  final Map<String, StreamSubscription<List<ShelfGroup>>> _shelfSubscriptions = {};
  final Map<String, List<ShelfGroup>> _groupsByCategory = {};
  List<CategoryNode> _nodes = const [];

  void start() {
    _subscriptions
      ..add(_watchCategoryTree().listen(_onTree))
      ..add(_preferredLanguages.watch().listen((languages) => emit(state.copyWith(preferredLanguages: languages))))
      ..add(_collapsedSeries.watch().listen((collapsed) => emit(state.copyWith(collapsedSeriesIds: collapsed))));
    if (_recentSearches case final recent?) {
      _subscriptions.add(recent.watch().listen((queries) {
        if (!isClosed) {
          emit(state.copyWith(recentSearches: queries));
        }
      }));
    }
  }

  void filterSearch(String? categoryId) => emit(state.copyWith(searchCategoryId: () => categoryId));

  Future<void> rememberSearch() async => _recentSearches?.remember(state.searchQuery);

  Future<void> forgetSearch(String query) async => _recentSearches?.forget(query);

  void _onTree(List<CategoryNode> nodes) {
    _nodes = nodes;
    final rootIds = nodes.map((node) => node.category.id).toSet();
    for (final staleId in _shelfSubscriptions.keys.where((id) => !rootIds.contains(id)).toList()) {
      _shelfSubscriptions.remove(staleId)?.cancel();
      _groupsByCategory.remove(staleId);
    }
    for (final rootId in rootIds.where((id) => !_shelfSubscriptions.containsKey(id))) {
      _shelfSubscriptions[rootId] = _watchShelf(rootId).listen((groups) {
        _groupsByCategory[rootId] = groups;
        _publishShelves();
      });
    }
    _publishShelves();
  }

  void _publishShelves() {
    if (isClosed) {
      return;
    }
    emit(state.copyWith(
      isLoading: false,
      shelves: [for (final node in _nodes) HomeShelf(node: node, groups: _groupsByCategory[node.category.id] ?? const [])],
    ));
  }

  Future<void> search(String query) async {
    emit(state.copyWith(searchQuery: query, searchCategoryId: () => null));
    if (query.trim().isNotEmpty) {
      await Future<void>.delayed(_searchDelay);
      if (isClosed || state.searchQuery != query) {
        return;
      }
    }
    final results = query.trim().isEmpty ? const <Never>[] : await _searchCollection(query);
    if (!isClosed && state.searchQuery == query) {
      emit(state.copyWith(searchResults: results));
    }
  }

  Future<void> toggleSeries(String seriesId) => _collapsedSeries.toggle(seriesId);

  @override
  Future<void> close() async {
    for (final subscription in [..._subscriptions, ..._shelfSubscriptions.values]) {
      await subscription.cancel();
    }
    return super.close();
  }
}
