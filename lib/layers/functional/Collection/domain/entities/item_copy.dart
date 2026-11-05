import 'package:akashic/layers/functional/Collection/domain/entities/item_condition.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/trade_channel.dart';
import 'package:equatable/equatable.dart';

class ItemCopy extends Equatable {
  const ItemCopy({required this.id, required this.itemId, this.edition, this.pricePaidCents, this.location, this.conditions = const {}, this.barcode, this.externalEditionId, this.loanedTo, this.loanedSince, this.isOpened = false, this.purchasedOn, this.purchaseChannel});

  final String id;
  final String itemId;
  final String? edition;
  final int? pricePaidCents;
  final String? location;
  final Map<String, ItemCondition> conditions;
  final String? barcode;
  final String? externalEditionId;
  final String? loanedTo;
  final DateTime? loanedSince;
  final bool isOpened;
  final DateTime? purchasedOn;
  final TradeChannel? purchaseChannel;

  bool get isLent => loanedTo != null;

  @override
  List<Object?> get props => [id, itemId, edition, pricePaidCents, location, conditions, barcode, externalEditionId, loanedTo, loanedSince, isOpened, purchasedOn, purchaseChannel];
}
