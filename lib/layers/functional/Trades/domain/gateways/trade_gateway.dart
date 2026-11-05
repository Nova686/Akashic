import 'package:akashic/layers/functional/Trades/domain/entities/trade_history.dart';

abstract interface class TradeGateway {
  Stream<TradeHistory> watchHistory();
  Future<void> recordSale(CopySale sale);
}
