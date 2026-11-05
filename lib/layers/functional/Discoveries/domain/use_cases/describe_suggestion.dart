import 'package:akashic/layers/functional/Collection/domain/entities/collection_item.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/localized_titles.dart';
import 'package:akashic/layers/functional/Details/domain/entities/item_details.dart';
import 'package:akashic/layers/functional/Details/domain/use_cases/fetch_item_details.dart';
import 'package:akashic/layers/functional/Discoveries/domain/entities/suggestion.dart';

class DescribeSuggestion {
  const DescribeSuggestion(this._details);

  final FetchItemDetails _details;

  CollectionItem _asItem(Suggestion suggestion) => CollectionItem(
        id: suggestion.sourceIdentity,
        categoryId: '',
        titles: LocalizedTitles(byLanguage: {'en': suggestion.title}),
        creator: suggestion.creator,
        year: suggestion.year,
        sourceKey: suggestion.sourceKey,
        externalWorkId: suggestion.externalWorkId,
      );

  bool canDescribe(Suggestion suggestion) => _details.canDescribe(_asItem(suggestion));

  Future<ItemDetails> call(Suggestion suggestion, {required String languageCode}) => _details.preview(_asItem(suggestion), languageCode: languageCode);
}
