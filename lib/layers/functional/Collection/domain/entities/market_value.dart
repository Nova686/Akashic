import 'package:equatable/equatable.dart';

class MarketValue extends Equatable {
  const MarketValue({required this.cents, required this.currency, required this.valuedAt});

  final int cents;
  final String currency;
  final DateTime valuedAt;

  @override
  List<Object?> get props => [cents, currency, valuedAt];
}
