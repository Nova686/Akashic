import 'package:akashic/layers/functional/Collection/domain/entities/collection_item.dart';
import 'package:akashic/layers/functional/Collection/domain/use_cases/search_text_normalizer.dart';

class CollectionSearchMatcher {
  const CollectionSearchMatcher();

  bool matches(CollectionItem item, String query) {
    final normalizedQuery = normalizeForSearch(query);
    if (normalizedQuery.isEmpty) {
      return false;
    }
    final searchableTexts = [...item.titles.byLanguage.values, ?item.creator];
    return searchableTexts.any((text) => normalizeForSearch(text).contains(normalizedQuery));
  }
}
