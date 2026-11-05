import 'package:akashic/layers/functional/Collection/domain/entities/collection_item.dart';
import 'package:akashic/layers/functional/Details/domain/entities/item_details.dart';

abstract interface class DetailsSource {
  bool supports(CollectionItem item);
  Future<List<DetailSection>> fetch(CollectionItem item, {required String languageCode, String? editionId});
}
