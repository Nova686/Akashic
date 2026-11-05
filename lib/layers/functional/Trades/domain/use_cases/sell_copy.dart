import 'package:akashic/layers/functional/Collection/domain/entities/item_copy.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/localized_titles.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/trade_channel.dart';
import 'package:akashic/layers/functional/Collection/domain/gateways/collection_gateway.dart';
import 'package:akashic/layers/functional/Collection/domain/use_cases/delete_copy.dart';
import 'package:akashic/layers/functional/Trades/domain/entities/trade_history.dart';
import 'package:akashic/layers/functional/Trades/domain/gateways/trade_gateway.dart';
import 'package:uuid/uuid.dart';

class SellCopy {
  SellCopy(this._collection, this._trades, this._deleteCopy, {String Function()? newId}) : _newId = newId ?? const Uuid().v4;

  final CollectionGateway _collection;
  final TradeGateway _trades;
  final DeleteCopy _deleteCopy;
  final String Function() _newId;

  Future<CopyDeletion> call(ItemCopy copy, {required int salePriceCents, required DateTime soldOn, TradeChannel? channel}) async {
    final item = await _collection.watchItem(copy.itemId).first;
    await _trades.recordSale(CopySale(
      id: _newId(),
      itemId: copy.itemId,
      titles: item?.titles ?? const LocalizedTitles(byLanguage: {}),
      salePriceCents: salePriceCents,
      soldOn: soldOn,
      categoryId: item?.categoryId,
      edition: copy.edition,
      wasOpened: copy.isOpened,
      purchasePriceCents: copy.pricePaidCents,
      purchasedOn: copy.purchasedOn,
      purchaseChannel: copy.purchaseChannel,
      saleChannel: channel,
    ));
    return _deleteCopy(copy);
  }
}
