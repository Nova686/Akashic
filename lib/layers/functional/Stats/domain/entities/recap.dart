import 'package:akashic/layers/functional/Collection/domain/entities/collection_item.dart';
import 'package:equatable/equatable.dart';

class Recap extends Equatable {
  const Recap({
    required this.from,
    required this.to,
    required this.addedCount,
    required this.spentCents,
    required this.finishedCount,
    required this.completedSeries,
    required this.mostValued,
    this.valueChangeCents,
    this.busiestMonth,
  });

  final DateTime from;
  final DateTime to;
  final int addedCount;
  final int spentCents;
  final int finishedCount;
  final List<String> completedSeries;
  final List<CollectionItem> mostValued;
  final int? valueChangeCents;
  final DateTime? busiestMonth;

  bool get isEmpty => addedCount == 0 && finishedCount == 0 && spentCents == 0;

  @override
  List<Object?> get props => [from, to, addedCount, spentCents, finishedCount, completedSeries, mostValued, valueChangeCents, busiestMonth];
}
