import 'package:akashic/layers/functional/Details/domain/entities/item_details.dart';

abstract interface class DetailsStore {
  Future<ItemDetails?> read(String itemId);
  Future<void> write(String itemId, ItemDetails details);
}
