import 'dart:async';

import 'package:akashic/layers/functional/Catalog/domain/entities/category.dart';
import 'package:akashic/layers/functional/Catalog/domain/use_cases/watch_category_tree.dart';
import 'package:akashic/layers/functional/Collection/domain/use_cases/arrange_shelf.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/item_copy.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/shelf_group.dart';
import 'package:akashic/layers/functional/Collection/domain/use_cases/watch_shelf.dart';
import 'package:akashic/layers/functional/Collection/presentation/cubit/category_shelves_state.dart';
import 'package:akashic/layers/functional/Settings/domain/use_cases/manage_collapsed_series.dart';
import 'package:akashic/layers/functional/Settings/domain/use_cases/manage_preferred_languages.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CategoryShelvesCubit extends Cubit<CategoryShelvesState> {
  CategoryShelvesCubit({
    required this.categoryId,
    required this._watchCategoryTree,
    required this._watchShelf,
    required this._collapsedSeries,
    this._preferredLanguages,
    this._loadCopies,
    this._loadTags,
  }) : super(const CategoryShelvesState.loading());

  final String categoryId;
  final WatchCategoryTree _watchCategoryTree;
  final WatchShelf _watchShelf;
  final ManageCollapsedSeries _collapsedSeries;
  final ManagePreferredLanguages? _preferredLanguages;
  final Future<Map<String, ItemCopy>> Function()? _loadCopies;
  final Future<Map<String, Set<String>>> Function()? _loadTags;
  final List<StreamSubscription<Object?>> _subscriptions = [];
  final Map<String, StreamSubscription<List<ShelfGroup>>> _shelfSubscriptions = {};
  final Map<String, List<ShelfGroup>> _groupsByCategory = {};
  List<Category> _shelfCategories = const [];
  Category? _category;

  void start() {
    _subscriptions
      ..add(_watchCategoryTree().listen(_onTree))
      ..add(_collapsedSeries.watch().listen((collapsed) => emit(state.copyWith(collapsedSeriesIds: collapsed))));
    final preferredLanguages = _preferredLanguages;
    if (preferredLanguages != null) {
      _subscriptions.add(preferredLanguages.watch().listen((languages) => emit(state.copyWith(preferredLanguages: languages))));
    }
  }

  void _onTree(List<CategoryNode> nodes) {
    final node = nodes.where((node) => node.category.id == categoryId).firstOrNull;
    final child = nodes.expand((node) => node.children).where((child) => child.id == categoryId).firstOrNull;
    _category = node?.category ?? child;
    _shelfCategories = node == null ? [?child] : (node.children.isEmpty ? [node.category] : node.children);
    final shelfIds = _shelfCategories.map((category) => category.id).toSet();
    for (final staleId in _shelfSubscriptions.keys.where((id) => !shelfIds.contains(id)).toList()) {
      _shelfSubscriptions.remove(staleId)?.cancel();
      _groupsByCategory.remove(staleId);
    }
    for (final shelfId in shelfIds.where((id) => !_shelfSubscriptions.containsKey(id))) {
      _shelfSubscriptions[shelfId] = _watchShelf(shelfId).listen((groups) {
        _groupsByCategory[shelfId] = groups;
        _publish();
      });
    }
    _publish();
  }

  void _publish() {
    if (isClosed || _category == null) {
      return;
    }
    emit(state.copyWith(
      category: _category,
      isLoading: false,
      shelves: [
        for (final category in _shelfCategories)
          CategoryShelf(
            category: category,
            groups: _groupsByCategory[category.id] ?? const [],
            itemCount: (_groupsByCategory[category.id] ?? const []).fold(0, (total, group) => total + group.ownedCount),
          ),
      ],
    ));
    unawaited(_refreshCopies());
  }

  Future<void> _refreshCopies() async {
    final loadCopies = _loadCopies;
    if (loadCopies == null) {
      return;
    }
    final copies = await loadCopies();
    final tags = await _loadTags?.call();
    if (!isClosed) {
      emit(state.copyWith(copies: copies, tags: tags));
    }
  }

  Future<void> toggleSeries(String seriesId) async {
    emit(state.copyWith(collapsedSeriesIds: await _collapsedSeries.toggle(seriesId)));
  }

  Future<void> setAllSeriesCollapsed(bool collapsed) async {
    final seriesIds = state.visibleShelves.expand((shelf) => shelf.seriesIds);
    emit(state.copyWith(collapsedSeriesIds: await _collapsedSeries.setCollapsed(seriesIds, collapsed: collapsed)));
  }

  void selectSubcategory(String? subcategoryId) => emit(state.copyWith(selectedSubcategoryId: () => subcategoryId));

  void showScans(bool showsScans) => emit(state.copyWith(showsScans: showsScans));

  void arrange({required ShelfSort sort, required ShelfFilter filter}) => emit(state.copyWith(sort: sort, filter: filter));

  void toggleSelection(String itemId) {
    final selected = {...state.selectedItemIds};
    if (!selected.remove(itemId)) {
      selected.add(itemId);
    }
    emit(state.copyWith(selectedItemIds: selected));
  }

  void clearSelection() => emit(state.copyWith(selectedItemIds: const {}));

  @override
  Future<void> close() async {
    for (final subscription in [..._subscriptions, ..._shelfSubscriptions.values]) {
      await subscription.cancel();
    }
    return super.close();
  }
}
