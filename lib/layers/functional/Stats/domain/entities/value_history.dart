import 'package:akashic/layers/functional/Collection/domain/entities/collection_item.dart';
import 'package:equatable/equatable.dart';

class ValueSnapshot extends Equatable {
  const ValueSnapshot({required this.month, required this.totals});

  final DateTime month;
  final Map<String, int> totals;

  @override
  List<Object?> get props => [month, totals];
}

class ItemValueChange extends Equatable {
  const ItemValueChange({required this.item, required this.fromCents, required this.toCents, required this.currency});

  final CollectionItem item;
  final int fromCents;
  final int toCents;
  final String currency;

  int get deltaCents => toCents - fromCents;

  double get ratio => fromCents == 0 ? 0 : deltaCents / fromCents;

  @override
  List<Object?> get props => [item, fromCents, toCents, currency];
}

class ValueTrend extends Equatable {
  const ValueTrend({required this.points, required this.risers, required this.fallers, required this.currency});

  final List<ValueSnapshot> points;
  final List<ItemValueChange> risers;
  final List<ItemValueChange> fallers;
  final String currency;

  @override
  List<Object?> get props => [points, risers, fallers, currency];
}
