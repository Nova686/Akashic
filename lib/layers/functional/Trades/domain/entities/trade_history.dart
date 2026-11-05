import 'package:akashic/layers/functional/Collection/domain/entities/localized_titles.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/trade_channel.dart';
import 'package:equatable/equatable.dart';

class CopyPurchase extends Equatable {
  const CopyPurchase({required this.copyId, required this.itemId, required this.titles, required this.boughtOn, this.edition, this.priceCents, this.channel, this.isOpened = false});

  final String copyId;
  final String itemId;
  final LocalizedTitles titles;
  final DateTime boughtOn;
  final String? edition;
  final int? priceCents;
  final TradeChannel? channel;
  final bool isOpened;

  @override
  List<Object?> get props => [copyId, itemId, titles, boughtOn, edition, priceCents, channel, isOpened];
}

class CopySale extends Equatable {
  const CopySale({
    required this.id,
    required this.itemId,
    required this.titles,
    required this.salePriceCents,
    required this.soldOn,
    this.categoryId,
    this.edition,
    this.wasOpened = false,
    this.purchasePriceCents,
    this.purchasedOn,
    this.purchaseChannel,
    this.saleChannel,
  });

  final String id;
  final String itemId;
  final LocalizedTitles titles;
  final int salePriceCents;
  final DateTime soldOn;
  final String? categoryId;
  final String? edition;
  final bool wasOpened;
  final int? purchasePriceCents;
  final DateTime? purchasedOn;
  final TradeChannel? purchaseChannel;
  final TradeChannel? saleChannel;

  int? get marginCents => switch (purchasePriceCents) {
        final paid? => salePriceCents - paid,
        null => null,
      };

  @override
  List<Object?> get props => [id, itemId, titles, salePriceCents, soldOn, categoryId, edition, wasOpened, purchasePriceCents, purchasedOn, purchaseChannel, saleChannel];
}

sealed class TradeEntry {
  const TradeEntry();

  DateTime get happenedOn;
  LocalizedTitles get titles;
  String get itemId;
}

class PurchaseEntry extends TradeEntry {
  const PurchaseEntry(this.purchase);

  final CopyPurchase purchase;

  @override
  DateTime get happenedOn => purchase.boughtOn;

  @override
  LocalizedTitles get titles => purchase.titles;

  @override
  String get itemId => purchase.itemId;
}

class SaleEntry extends TradeEntry {
  const SaleEntry(this.sale);

  final CopySale sale;

  @override
  DateTime get happenedOn => sale.soldOn;

  @override
  LocalizedTitles get titles => sale.titles;

  @override
  String get itemId => sale.itemId;
}

class TradeHistory extends Equatable {
  const TradeHistory({this.purchases = const [], this.sales = const []});

  final List<CopyPurchase> purchases;
  final List<CopySale> sales;

  bool get isEmpty => purchases.isEmpty && sales.isEmpty;

  int get spentCents => purchases.fold(0, (total, purchase) => total + (purchase.priceCents ?? 0)) + sales.fold(0, (total, sale) => total + (sale.purchasePriceCents ?? 0));

  int get earnedCents => sales.fold(0, (total, sale) => total + sale.salePriceCents);

  int get marginCents => sales.fold(0, (total, sale) => total + (sale.marginCents ?? 0));

  List<TradeEntry> get entries => [
        for (final purchase in purchases) PurchaseEntry(purchase),
        for (final sale in sales) ...[
          SaleEntry(sale),
          if (sale.purchasePriceCents != null || sale.purchasedOn != null)
            PurchaseEntry(CopyPurchase(
              copyId: sale.id,
              itemId: sale.itemId,
              titles: sale.titles,
              boughtOn: sale.purchasedOn ?? sale.soldOn,
              edition: sale.edition,
              priceCents: sale.purchasePriceCents,
              channel: sale.purchaseChannel,
            )),
        ],
      ]..sort((first, second) => second.happenedOn.compareTo(first.happenedOn));

  @override
  List<Object?> get props => [purchases, sales];
}
