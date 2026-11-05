import 'package:akashic/layers/functional/Catalog/domain/entities/category.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/collection_item.dart';
import 'package:equatable/equatable.dart';

class CategoryValue extends Equatable {
  const CategoryValue({required this.category, required this.byCurrency});

  final Category category;
  final Map<String, int> byCurrency;

  @override
  List<Object?> get props => [category, byCurrency];
}

class CollectionValue extends Equatable {
  const CollectionValue({required this.totalByCurrency, required this.categories, required this.marketValuedItems, required this.purchaseValuedItems, required this.unvaluedItems, this.lastValuedAt});

  final Map<String, int> totalByCurrency;
  final List<CategoryValue> categories;
  final int marketValuedItems;
  final int purchaseValuedItems;
  final int unvaluedItems;
  final DateTime? lastValuedAt;

  @override
  List<Object?> get props => [totalByCurrency, categories, marketValuedItems, purchaseValuedItems, unvaluedItems, lastValuedAt];
}

class Duplicates extends Equatable {
  const Duplicates({required this.sameWork});

  final List<List<CollectionItem>> sameWork;

  int get count => sameWork.length;

  @override
  List<Object?> get props => [sameWork];
}

class ValueRefresh extends Equatable {
  const ValueRefresh({required this.recordsValued, required this.decksPriced, required this.isComplete});

  final int recordsValued;
  final int decksPriced;
  final bool isComplete;

  @override
  List<Object?> get props => [recordsValued, decksPriced, isComplete];
}
