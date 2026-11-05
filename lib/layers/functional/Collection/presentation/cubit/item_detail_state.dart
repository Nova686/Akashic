import 'package:akashic/layers/functional/Catalog/domain/entities/category.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/item_photo.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/collection_item.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/item_copy.dart';
import 'package:akashic/layers/functional/Details/domain/entities/item_details.dart';
import 'package:akashic/layers/functional/Settings/domain/entities/preferred_languages.dart';
import 'package:equatable/equatable.dart';

class ItemDetailState extends Equatable {
  const ItemDetailState({
    this.item,
    this.category,
    this.parentCategory,
    this.copies = const [],
    this.photos = const [],
    this.preferredLanguages = PreferredLanguages.defaults,
    this.isLoading = true,
    this.details,
    this.isFetchingDetails = false,
    this.detailsFailed = false,
    this.canFetchDetails = false,
  });

  final CollectionItem? item;
  final Category? category;
  final Category? parentCategory;
  final List<ItemCopy> copies;
  final List<ItemPhoto> photos;
  final PreferredLanguages preferredLanguages;
  final bool isLoading;
  final ItemDetails? details;
  final bool isFetchingDetails;
  final bool detailsFailed;
  final bool canFetchDetails;

  List<String> get conditionParts => category?.conditionParts ?? const [];

  List<ItemPhoto> photosOf(String copyId) {
    final firstCopyId = copies.firstOrNull?.id;
    return [for (final photo in photos) if (photo.copyId == copyId || (photo.copyId == null && copyId == firstCopyId)) photo];
  }

  ItemDetailState copyWith({
    CollectionItem? item,
    Category? category,
    Category? Function()? parentCategory,
    List<ItemCopy>? copies,
    List<ItemPhoto>? photos,
    PreferredLanguages? preferredLanguages,
    bool? isLoading,
    ItemDetails? details,
    bool? isFetchingDetails,
    bool? detailsFailed,
    bool? canFetchDetails,
  }) {
    return ItemDetailState(
      item: item ?? this.item,
      category: category ?? this.category,
      parentCategory: parentCategory == null ? this.parentCategory : parentCategory(),
      copies: copies ?? this.copies,
      photos: photos ?? this.photos,
      preferredLanguages: preferredLanguages ?? this.preferredLanguages,
      isLoading: isLoading ?? this.isLoading,
      details: details ?? this.details,
      isFetchingDetails: isFetchingDetails ?? this.isFetchingDetails,
      detailsFailed: detailsFailed ?? false,
      canFetchDetails: canFetchDetails ?? this.canFetchDetails,
    );
  }

  @override
  List<Object?> get props => [item, category, parentCategory, copies, photos, preferredLanguages, isLoading, details, isFetchingDetails, detailsFailed, canFetchDetails];
}
