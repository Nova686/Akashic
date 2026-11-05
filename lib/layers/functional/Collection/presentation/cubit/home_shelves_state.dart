import 'package:akashic/layers/functional/Catalog/domain/entities/category.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/collection_item.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/shelf_group.dart';
import 'package:akashic/layers/functional/Settings/domain/entities/preferred_languages.dart';
import 'package:equatable/equatable.dart';

class HomeShelf extends Equatable {
  const HomeShelf({required this.node, required this.groups});

  final CategoryNode node;
  final List<ShelfGroup> groups;

  int get incompleteSeriesCount => groups.where((group) => group.isSeries && group.isIncomplete).length;

  @override
  List<Object?> get props => [node, groups];
}

class HomeShelvesState extends Equatable {
  const HomeShelvesState({
    this.shelves = const [],
    this.collapsedSeriesIds = const {},
    this.preferredLanguages = PreferredLanguages.defaults,
    this.searchQuery = '',
    this.searchResults = const [],
    this.searchCategoryId,
    this.recentSearches = const [],
    this.isLoading = true,
  });

  final List<HomeShelf> shelves;
  final Set<String> collapsedSeriesIds;
  final PreferredLanguages preferredLanguages;
  final String searchQuery;
  final List<CollectionItem> searchResults;
  final String? searchCategoryId;
  final List<String> recentSearches;
  final bool isLoading;

  Category? topCategoryOf(CollectionItem item) {
    for (final shelf in shelves) {
      if (shelf.node.category.id == item.categoryId || shelf.node.children.any((child) => child.id == item.categoryId)) {
        return shelf.node.category;
      }
    }
    return null;
  }

  List<(Category, int)> get searchCategoryCounts {
    final counts = <String, int>{};
    for (final item in searchResults) {
      if (topCategoryOf(item) case final category?) {
        counts[category.id] = (counts[category.id] ?? 0) + 1;
      }
    }
    return [for (final shelf in shelves) if (counts[shelf.node.category.id] case final count?) (shelf.node.category, count)];
  }

  List<CollectionItem> get visibleSearchResults =>
      searchCategoryId == null ? searchResults : [for (final item in searchResults) if (topCategoryOf(item)?.id == searchCategoryId) item];

  int get totalItems => shelves.fold(0, (total, shelf) => total + shelf.node.itemCount);

  int get categoryCount => shelves.length;

  HomeShelvesState copyWith({
    List<HomeShelf>? shelves,
    Set<String>? collapsedSeriesIds,
    PreferredLanguages? preferredLanguages,
    String? searchQuery,
    List<CollectionItem>? searchResults,
    String? Function()? searchCategoryId,
    List<String>? recentSearches,
    bool? isLoading,
  }) {
    return HomeShelvesState(
      shelves: shelves ?? this.shelves,
      collapsedSeriesIds: collapsedSeriesIds ?? this.collapsedSeriesIds,
      preferredLanguages: preferredLanguages ?? this.preferredLanguages,
      searchQuery: searchQuery ?? this.searchQuery,
      searchResults: searchResults ?? this.searchResults,
      searchCategoryId: searchCategoryId == null ? this.searchCategoryId : searchCategoryId(),
      recentSearches: recentSearches ?? this.recentSearches,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  @override
  List<Object?> get props => [shelves, collapsedSeriesIds, preferredLanguages, searchQuery, searchResults, searchCategoryId, recentSearches, isLoading];
}
