import 'package:akashic/layers/functional/Collection/domain/entities/collection_item.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/localized_titles.dart';
import 'package:akashic/layers/functional/Details/domain/entities/item_details.dart';
import 'package:akashic/layers/functional/Details/domain/use_cases/fetch_item_details.dart';
import 'package:akashic/layers/functional/Wishes/domain/entities/wish.dart';

class DescribeWish {
  const DescribeWish(this._details);

  final FetchItemDetails _details;

  CollectionItem _asItem(Wish wish) => CollectionItem(
        id: 'wish:${wish.id}',
        categoryId: wish.categoryId ?? '',
        titles: LocalizedTitles(byLanguage: {'en': wish.title}),
        creator: wish.creator,
        sourceKey: wish.draft.key.sourceKey,
        externalWorkId: wish.draft.key.externalWorkId,
      );

  bool canDescribe(Wish wish) => wish.draft.key.sourceKey != null && _details.canDescribe(_asItem(wish));

  Future<ItemDetails> call(Wish wish, {required String languageCode}) => _details.preview(_asItem(wish), languageCode: languageCode);
}
