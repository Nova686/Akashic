import 'package:akashic/layers/functional/SealedPrices/domain/entities/sealed_price.dart';

abstract interface class SealedPriceStore {
  Future<void> savePrices(List<SealedPrice> prices);
  Stream<SealedPrice?> watchPrice(String productId);
  Future<DateTime?> lastPricedAt();
}
