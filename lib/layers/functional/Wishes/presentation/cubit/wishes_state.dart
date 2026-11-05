import 'package:akashic/layers/functional/Catalog/domain/entities/category_type.dart';
import 'package:akashic/layers/functional/Wishes/domain/entities/wish.dart';
import 'package:equatable/equatable.dart';

class WishesState extends Equatable {
  const WishesState({this.wishes = const [], this.typeFilter, this.isLoading = true});

  final List<Wish> wishes;
  final CategoryType? typeFilter;
  final bool isLoading;

  List<CategoryType> get availableTypes => {for (final wish in wishes) wish.categoryType}.toList()..sort((first, second) => first.index.compareTo(second.index));

  List<Wish> get visibleWishes => [
        for (final priority in WishPriority.values)
          for (final wish in wishes)
            if (wish.priority == priority && (typeFilter == null || wish.categoryType == typeFilter)) wish,
      ];

  WishesState copyWith({List<Wish>? wishes, CategoryType? Function()? typeFilter, bool? isLoading}) {
    return WishesState(
      wishes: wishes ?? this.wishes,
      typeFilter: typeFilter == null ? this.typeFilter : typeFilter(),
      isLoading: isLoading ?? this.isLoading,
    );
  }

  @override
  List<Object?> get props => [wishes, typeFilter, isLoading];
}
