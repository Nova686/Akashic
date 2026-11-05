import 'package:equatable/equatable.dart';

class SealedPrice extends Equatable {
  const SealedPrice({
    required this.productId,
    required this.pricedAt,
    this.lowCents,
    this.averageCents,
    this.trendCents,
    this.average1Cents,
    this.average7Cents,
    this.average30Cents,
  });

  final String productId;
  final DateTime pricedAt;
  final int? lowCents;
  final int? averageCents;
  final int? trendCents;
  final int? average1Cents;
  final int? average7Cents;
  final int? average30Cents;

  int? get referenceCents => trendCents ?? average30Cents ?? averageCents ?? lowCents;

  @override
  List<Object?> get props => [productId, pricedAt, lowCents, averageCents, trendCents, average1Cents, average7Cents, average30Cents];
}
