import 'package:akashic/layers/functional/Catalog/domain/entities/category_type.dart';
import 'package:akashic/layers/functional/Collection/domain/use_cases/search_text_normalizer.dart';
import 'package:akashic/layers/functional/Discoveries/domain/entities/suggestion.dart';
import 'package:equatable/equatable.dart';

class DiscoveriesState extends Equatable {
  const DiscoveriesState({
    this.discoveries,
    this.wishedIdentities = const {},
    this.ownedIdentities = const {},
    this.typeFilter,
    this.query = '',
    this.hidesWished = false,
    this.recentOnly = false,
    this.isLoading = true,
    this.isRefreshing = false,
    this.isOffline = false,
  });

  final Discoveries? discoveries;
  final Set<String> wishedIdentities;
  final Set<String> ownedIdentities;
  final CategoryType? typeFilter;
  final String query;
  final bool hidesWished;
  final bool recentOnly;
  final bool isLoading;
  final bool isRefreshing;
  final bool isOffline;

  List<CategoryType> get availableTypes =>
      {for (final group in discoveries?.groups ?? const <SuggestionGroup>[]) group.categoryType}.toList()..sort((first, second) => first.index.compareTo(second.index));

  static const int recentYears = 3;

  bool get isFiltered => typeFilter != null || query.trim().isNotEmpty || hidesWished || recentOnly;

  bool _keeps(SuggestionGroup group, Suggestion suggestion) {
    if (suggestion.isExcludedBy(ownedIdentities) || (hidesWished && isWished(suggestion))) {
      return false;
    }
    final computedYear = discoveries?.computedAt.year;
    if (recentOnly && (suggestion.year == null || computedYear == null || suggestion.year! < computedYear - recentYears)) {
      return false;
    }
    final words = normalizeForSearch(query).split(' ').where((word) => word.isNotEmpty);
    final haystack = normalizeForSearch('${suggestion.title} ${suggestion.creator ?? ''} ${group.seedTitle}');
    return words.every(haystack.contains);
  }

  List<SuggestionGroup> get visibleGroups {
    return [
      for (final group in discoveries?.groups ?? const <SuggestionGroup>[])
        if (typeFilter == null || group.categoryType == typeFilter)
          if (group.suggestions.where((suggestion) => _keeps(group, suggestion)).toList() case final remaining when remaining.isNotEmpty)
            SuggestionGroup(seedItemId: group.seedItemId, seedTitle: group.seedTitle, categoryType: group.categoryType, suggestions: remaining),
    ];
  }

  bool isWished(Suggestion suggestion) => wishedIdentities.contains(suggestion.sourceIdentity);

  DiscoveriesState copyWith({
    Discoveries? discoveries,
    Set<String>? wishedIdentities,
    Set<String>? ownedIdentities,
    CategoryType? Function()? typeFilter,
    String? query,
    bool? hidesWished,
    bool? recentOnly,
    bool? isLoading,
    bool? isRefreshing,
    bool? isOffline,
  }) {
    return DiscoveriesState(
      discoveries: discoveries ?? this.discoveries,
      wishedIdentities: wishedIdentities ?? this.wishedIdentities,
      ownedIdentities: ownedIdentities ?? this.ownedIdentities,
      typeFilter: typeFilter == null ? this.typeFilter : typeFilter(),
      query: query ?? this.query,
      hidesWished: hidesWished ?? this.hidesWished,
      recentOnly: recentOnly ?? this.recentOnly,
      isLoading: isLoading ?? this.isLoading,
      isRefreshing: isRefreshing ?? this.isRefreshing,
      isOffline: isOffline ?? this.isOffline,
    );
  }

  @override
  List<Object?> get props => [discoveries, wishedIdentities, ownedIdentities, typeFilter, query, hidesWished, recentOnly, isLoading, isRefreshing, isOffline];
}
