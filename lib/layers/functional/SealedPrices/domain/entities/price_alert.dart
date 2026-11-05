import 'package:equatable/equatable.dart';

class PriceAlert extends Equatable {
  const PriceAlert({required this.itemId, required this.thresholdCents, required this.isAbove, this.notifiedAt});

  final String itemId;
  final int thresholdCents;
  final bool isAbove;
  final DateTime? notifiedAt;

  bool isCrossedBy(int cents) => isAbove ? cents >= thresholdCents : cents <= thresholdCents;

  PriceAlert notified(DateTime? at) => PriceAlert(itemId: itemId, thresholdCents: thresholdCents, isAbove: isAbove, notifiedAt: at);

  @override
  List<Object?> get props => [itemId, thresholdCents, isAbove, notifiedAt];
}
