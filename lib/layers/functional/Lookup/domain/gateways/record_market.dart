import 'package:akashic/layers/functional/Collection/domain/entities/market_value.dart';

abstract interface class RecordMarket {
  bool get isConfigured;
  Future<MarketValue?> lowestPriceOf(String releaseId);
  Future<String?> mainReleaseOf(String masterId);
}
