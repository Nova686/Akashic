import 'package:akashic/layers/functional/Catalog/domain/entities/category.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/collection_item.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/item_copy.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/shelf_group.dart';
import 'package:akashic/layers/functional/Collection/domain/use_cases/arrange_shelf.dart';
import 'package:akashic/layers/functional/Settings/domain/entities/preferred_languages.dart';
import 'package:equatable/equatable.dart';

class CategoryShelf extends Equatable {
  const CategoryShelf({required this.category, required this.groups, required this.itemCount});

  final Category category;
  final List<ShelfGroup> groups;
  final int itemCount;

  Iterable<String> get seriesIds => groups.where((group) => group.isSeries).map((group) => group.id);

  @override
  List<Object?> get props => [category, groups, itemCount];
}

class CategoryShelvesState extends Equatable {
  const CategoryShelvesState({
    required this.category,
    required this.shelves,
    required this.collapsedSeriesIds,
    required this.isLoading,
    this.selectedSubcategoryId,
    this.preferredLanguages = PreferredLanguages.defaults,
    this.showsScans = false,
    this.sort = ShelfSort.bySeries,
    this.filter = const ShelfFilter(),
    this.selectedItemIds = const {},
    this.copies = const {},
    this.tags = const {},
  });

  const CategoryShelvesState.loading()
      : category = null,
        shelves = const [],
        collapsedSeriesIds = const {},
        isLoading = true,
        selectedSubcategoryId = null,
        preferredLanguages = PreferredLanguages.defaults,
        showsScans = false,
        sort = ShelfSort.bySeries,
        filter = const ShelfFilter(),
        selectedItemIds = const {},
        copies = const {},
        tags = const {};

  final Category? category;
  final List<CategoryShelf> shelves;
  final Set<String> collapsedSeriesIds;
  final bool isLoading;
  final String? selectedSubcategoryId;
  final PreferredLanguages preferredLanguages;
  final bool showsScans;
  final ShelfSort sort;
  final ShelfFilter filter;
  final Set<String> selectedItemIds;
  final Map<String, ItemCopy> copies;
  final Map<String, Set<String>> tags;

  List<String> get knownTags => ({for (final itemTags in tags.values) ...itemTags}.toList()..sort());

  List<String> get knownLocations => ({for (final copy in copies.values) ?copy.location?.trim()}.where((location) => location.isNotEmpty).toList()..sort());

  bool get isSelecting => selectedItemIds.isNotEmpty;

  List<CollectionItem> get selectedItems => [
        for (final shelf in shelves)
          for (final group in shelf.groups)
            for (final entry in group.entries)
              if (entry case ShelfItem(:final item) when selectedItemIds.contains(item.id)) item,
      ];

  bool get isArranged => sort != ShelfSort.bySeries || filter.isActive;

  List<ShelfGroup> arrangedGroupsOf(CategoryShelf shelf) => arrangeShelf(shelf.groups, sort: sort, filter: filter, languages: preferredLanguages, copies: copies, tags: tags);

  List<ShelfGroup> groupsOf(CategoryShelf shelf) => isArranged ? arrangedGroupsOf(shelf) : shelf.groups;

  (CategoryShelf, ShelfGroup)? findGroup(String groupId) {
    for (final shelf in shelves) {
      for (final group in groupsOf(shelf)) {
        if (group.id == groupId) {
          return (shelf, group);
        }
      }
    }
    return null;
  }

  List<CategoryShelf> get visibleShelves =>
      selectedSubcategoryId == null ? shelves : shelves.where((shelf) => shelf.category.id == selectedSubcategoryId).toList();

  int get totalItems => shelves.fold(0, (total, shelf) => total + shelf.itemCount);

  bool get hasSubcategories => shelves.length > 1 || (shelves.isNotEmpty && shelves.single.category.id != category?.id);

  CategoryShelvesState copyWith({
    Category? category,
    List<CategoryShelf>? shelves,
    Set<String>? collapsedSeriesIds,
    bool? isLoading,
    String? Function()? selectedSubcategoryId,
    PreferredLanguages? preferredLanguages,
    bool? showsScans,
    ShelfSort? sort,
    ShelfFilter? filter,
    Set<String>? selectedItemIds,
    Map<String, ItemCopy>? copies,
    Map<String, Set<String>>? tags,
  }) {
    return CategoryShelvesState(
      category: category ?? this.category,
      shelves: shelves ?? this.shelves,
      collapsedSeriesIds: collapsedSeriesIds ?? this.collapsedSeriesIds,
      isLoading: isLoading ?? this.isLoading,
      selectedSubcategoryId: selectedSubcategoryId == null ? this.selectedSubcategoryId : selectedSubcategoryId(),
      preferredLanguages: preferredLanguages ?? this.preferredLanguages,
      showsScans: showsScans ?? this.showsScans,
      sort: sort ?? this.sort,
      filter: filter ?? this.filter,
      selectedItemIds: selectedItemIds ?? this.selectedItemIds,
      copies: copies ?? this.copies,
      tags: tags ?? this.tags,
    );
  }

  @override
  List<Object?> get props => [category, shelves, collapsedSeriesIds, isLoading, selectedSubcategoryId, preferredLanguages, showsScans, sort, filter, selectedItemIds, copies, tags];
}
