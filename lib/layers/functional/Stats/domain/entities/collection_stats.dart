import 'package:akashic/layers/functional/Catalog/domain/entities/category.dart';
import 'package:equatable/equatable.dart';

class CopyFact extends Equatable {
  const CopyFact({required this.itemId, required this.categoryId, required this.addedAt, this.pricePaidCents});

  final String itemId;
  final String categoryId;
  final DateTime addedAt;
  final int? pricePaidCents;

  @override
  List<Object?> get props => [itemId, categoryId, addedAt, pricePaidCents];
}

class CategoryStat extends Equatable {
  const CategoryStat({required this.category, required this.itemCount, required this.copyCount, required this.paidCents});

  final Category category;
  final int itemCount;
  final int copyCount;
  final int paidCents;

  @override
  List<Object?> get props => [category, itemCount, copyCount, paidCents];
}

class MonthlyPurchases extends Equatable {
  const MonthlyPurchases({required this.month, required this.copyCount, required this.paidCents});

  final DateTime month;
  final int copyCount;
  final int paidCents;

  @override
  List<Object?> get props => [month, copyCount, paidCents];
}

class YearlyAdditions extends Equatable {
  const YearlyAdditions({required this.year, required this.copyCount});

  final int year;
  final int copyCount;

  @override
  List<Object?> get props => [year, copyCount];
}

class SeriesShare extends Equatable {
  const SeriesShare({required this.complete, required this.incomplete});

  static const SeriesShare none = SeriesShare(complete: 0, incomplete: 0);

  final int complete;
  final int incomplete;

  int get total => complete + incomplete;

  @override
  List<Object?> get props => [complete, incomplete];
}

class CollectionStats extends Equatable {
  const CollectionStats({
    required this.totalPaidCents,
    required this.itemCount,
    required this.copyCount,
    required this.categories,
    required this.months,
    this.years = const [],
    this.series = SeriesShare.none,
  });

  final int totalPaidCents;
  final int itemCount;
  final int copyCount;
  final List<CategoryStat> categories;
  final List<MonthlyPurchases> months;
  final List<YearlyAdditions> years;
  final SeriesShare series;

  @override
  List<Object?> get props => [totalPaidCents, itemCount, copyCount, categories, months, years, series];
}
