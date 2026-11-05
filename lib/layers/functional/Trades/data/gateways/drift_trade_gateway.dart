import 'dart:convert';

import 'package:akashic/layers/functional/Collection/domain/entities/localized_titles.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/trade_channel.dart';
import 'package:akashic/layers/functional/Trades/domain/entities/trade_history.dart';
import 'package:akashic/layers/functional/Trades/domain/gateways/trade_gateway.dart';
import 'package:akashic/layers/technical/LocalDatabase/akashic_database.dart';
import 'package:drift/drift.dart';

class DriftTradeGateway implements TradeGateway {
  DriftTradeGateway(this._database);

  final AkashicDatabase _database;

  TradeChannel? _channelNamed(String? name) => TradeChannel.values.asNameMap()[name];

  @override
  Stream<TradeHistory> watchHistory() {
    return _database.customSelect('SELECT 1', readsFrom: {_database.copies, _database.items, _database.itemTitles, _database.sales}).watch().asyncMap((_) async {
      final copyRows = await (_database.select(_database.copies)..where((table) => table.pricePaidCents.isNotNull() | table.purchasedOn.isNotNull())).get();
      final itemIds = copyRows.map((row) => row.itemId).toSet();
      final itemRows = await (_database.select(_database.items)..where((table) => table.id.isIn(itemIds))).get();
      final titleRows = await (_database.select(_database.itemTitles)..where((table) => table.itemId.isIn(itemIds))).get();
      final originalLanguageByItem = {for (final item in itemRows) item.id: item.originalLanguage};
      final titlesByItem = <String, Map<String, String>>{};
      for (final title in titleRows) {
        titlesByItem.putIfAbsent(title.itemId, () => {})[title.languageCode] = title.title;
      }
      final saleRows = await _database.select(_database.sales).get();
      return TradeHistory(
        purchases: [
          for (final copy in copyRows)
            CopyPurchase(
              copyId: copy.id,
              itemId: copy.itemId,
              titles: LocalizedTitles(byLanguage: titlesByItem[copy.itemId] ?? const {}, originalLanguage: originalLanguageByItem[copy.itemId]),
              boughtOn: copy.purchasedOn ?? copy.createdAt,
              edition: copy.edition,
              priceCents: copy.pricePaidCents,
              channel: _channelNamed(copy.purchaseChannel),
              isOpened: copy.isOpened,
            ),
        ],
        sales: [
          for (final sale in saleRows)
            CopySale(
              id: sale.id,
              itemId: sale.itemId,
              titles: LocalizedTitles(byLanguage: Map<String, String>.from(jsonDecode(sale.titles) as Map), originalLanguage: sale.originalLanguage),
              salePriceCents: sale.salePriceCents,
              soldOn: sale.soldOn,
              categoryId: sale.categoryId,
              edition: sale.edition,
              wasOpened: sale.wasOpened,
              purchasePriceCents: sale.purchasePriceCents,
              purchasedOn: sale.purchasedOn,
              purchaseChannel: _channelNamed(sale.purchaseChannel),
              saleChannel: _channelNamed(sale.saleChannel),
            ),
        ],
      );
    });
  }

  @override
  Future<void> recordSale(CopySale sale) => _database.into(_database.sales).insert(SalesCompanion.insert(
        id: sale.id,
        itemId: sale.itemId,
        categoryId: Value(sale.categoryId),
        titles: jsonEncode(sale.titles.byLanguage),
        originalLanguage: Value(sale.titles.originalLanguage),
        edition: Value(sale.edition),
        wasOpened: Value(sale.wasOpened),
        purchasePriceCents: Value(sale.purchasePriceCents),
        purchasedOn: Value(sale.purchasedOn),
        purchaseChannel: Value(sale.purchaseChannel?.name),
        salePriceCents: sale.salePriceCents,
        soldOn: sale.soldOn,
        saleChannel: Value(sale.saleChannel?.name),
      ));
}
