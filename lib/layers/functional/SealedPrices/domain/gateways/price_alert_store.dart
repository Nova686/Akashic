import 'package:akashic/layers/functional/SealedPrices/domain/entities/price_alert.dart';

abstract interface class PriceAlertStore {
  Stream<PriceAlert?> watch(String itemId);
  Future<List<PriceAlert>> all();
  Future<void> save(PriceAlert alert);
  Future<void> remove(String itemId);
}

abstract interface class PriceAlertNotifier {
  Future<void> crossed(String title, int cents, PriceAlert alert);
}
