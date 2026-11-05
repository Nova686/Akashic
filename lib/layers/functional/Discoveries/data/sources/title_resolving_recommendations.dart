import 'package:akashic/layers/functional/Catalog/domain/entities/category_type.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/owned_work.dart';
import 'package:akashic/layers/functional/Collection/domain/use_cases/search_text_normalizer.dart';
import 'package:akashic/layers/functional/Discoveries/domain/entities/suggestion.dart';
import 'package:akashic/layers/functional/Discoveries/domain/gateways/recommendation_source.dart';
import 'package:akashic/layers/functional/Lookup/domain/entities/source_match.dart';
import 'package:akashic/layers/functional/Lookup/domain/gateways/catalog_source.dart';

class TitleResolvingRecommendations implements RecommendationSource {
  TitleResolvingRecommendations(this._recommendations, this._catalog, {required this.resolvableTypes});

  final RecommendationSource _recommendations;
  final CatalogSource _catalog;
  final Set<CategoryType> resolvableTypes;
  final Map<String, Future<OwnedWork?>> _resolvedByItem = {};

  @override
  String get key => _recommendations.key;

  @override
  bool get isConfigured => _recommendations.isConfigured;

  @override
  int get maximumSeeds => _recommendations.maximumSeeds;

  bool _isNative(OwnedWork work) => work.sourceKey == key && work.externalWorkId != null;

  @override
  bool supports(OwnedWork work, CategoryType type) =>
      _recommendations.supports(work, type) || (!_isNative(work) && _catalog.isConfigured && resolvableTypes.contains(type) && work.titles.byLanguage.values.any((title) => normalizeForSearch(title).isNotEmpty));

  @override
  String queryKeyFor(OwnedWork work) => _isNative(work) ? _recommendations.queryKeyFor(work) : 'title:${normalizeForSearch(work.titles.byLanguage.values.first)}';

  @override
  Future<List<Suggestion>> recommendationsFor(OwnedWork work, {required String languageCode}) async {
    if (_isNative(work)) {
      return _recommendations.recommendationsFor(work, languageCode: languageCode);
    }
    final OwnedWork? resolved;
    try {
      resolved = await (_resolvedByItem[work.itemId] ??= _resolve(work));
    } on Exception {
      _resolvedByItem.remove(work.itemId);
      rethrow;
    }
    if (resolved == null) {
      _resolvedByItem.remove(work.itemId);
      return const [];
    }
    return _recommendations.recommendationsFor(resolved, languageCode: languageCode);
  }

  Future<OwnedWork?> _resolve(OwnedWork work) async {
    for (final title in {...work.titles.byLanguage.values}) {
      final wanted = normalizeForSearch(title);
      if (wanted.isEmpty) {
        continue;
      }
      final candidates = [for (final match in await _catalog.search(title)) if (match.sourceKey == key) match];
      for (final isExact in [true, false]) {
        for (final match in candidates) {
          if (!_titlesOf(match).any((found) => isExact ? found == wanted : found.startsWith('$wanted ') || wanted.startsWith('$found '))) {
            continue;
          }
          final resolved = OwnedWork(
            itemId: work.itemId,
            categoryId: work.categoryId,
            titles: work.titles,
            creator: work.creator,
            sourceKey: match.sourceKey,
            externalWorkId: match.externalWorkId,
            rating: work.rating,
            addedAt: work.addedAt,
          );
          if (resolvableTypes.any((type) => _recommendations.supports(resolved, type))) {
            return resolved;
          }
        }
      }
    }
    return null;
  }

  Iterable<String> _titlesOf(SourceMatch match) => [...match.titles.byLanguage.values, ?match.seriesTitle].map(normalizeForSearch);
}
