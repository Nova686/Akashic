import 'dart:async';

import 'package:akashic/layers/functional/Catalog/domain/entities/category.dart';
import 'package:akashic/layers/functional/Catalog/domain/use_cases/watch_category_tree.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/item_copy.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/item_progress.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/item_photo.dart';
import 'package:akashic/layers/functional/Collection/domain/use_cases/manage_item_photos.dart';
import 'package:akashic/layers/technical/MediaStorage/phone_image_picker.dart';
import 'package:akashic/layers/functional/Collection/domain/use_cases/set_item_progress.dart';
import 'package:akashic/layers/functional/Collection/domain/use_cases/add_copy.dart';
import 'package:akashic/layers/functional/Collection/domain/use_cases/rate_item.dart';
import 'package:akashic/layers/functional/Collection/domain/use_cases/watch_item_detail.dart';
import 'package:akashic/layers/functional/Collection/presentation/cubit/item_detail_state.dart';
import 'package:akashic/layers/functional/Details/domain/use_cases/fetch_item_details.dart';
import 'package:akashic/layers/functional/Settings/domain/use_cases/manage_preferred_languages.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ItemDetailCubit extends Cubit<ItemDetailState> {
  ItemDetailCubit({
    required this.itemId,
    required this._watchItemDetail,
    required this._watchCategoryTree,
    required this._preferredLanguages,
    required this._rateItem,
    required this._addCopy,
    this._setItemProgress,
    this._manageItemPhotos,
    this._imagePicker,
    this._fetchItemDetails,
  }) : super(const ItemDetailState());

  final String itemId;
  final WatchItemDetail _watchItemDetail;
  final WatchCategoryTree _watchCategoryTree;
  final ManagePreferredLanguages _preferredLanguages;
  final RateItem _rateItem;
  final AddCopy _addCopy;
  final SetItemProgress? _setItemProgress;
  final ManageItemPhotos? _manageItemPhotos;
  final PhoneImagePicker? _imagePicker;

  bool get canManagePhotos => _manageItemPhotos != null && _imagePicker != null;
  final FetchItemDetails? _fetchItemDetails;
  final List<StreamSubscription<Object?>> _subscriptions = [];
  List<CategoryNode> _tree = const [];

  void start() {
    _loadCachedDetails();
    _subscriptions
      ..add(_watchItemDetail.item(itemId).listen((item) {
        if (item == null) {
          return;
        }
        emit(state.copyWith(item: item, isLoading: false, canFetchDetails: _fetchItemDetails?.canDescribe(item) ?? false));
        _resolveCategory();
      }))
      ..add(_watchItemDetail.copies(itemId).listen((copies) => emit(state.copyWith(copies: copies))))
      ..addAll([
        if (_manageItemPhotos case final managePhotos?) managePhotos.watch(itemId).listen((photos) => emit(state.copyWith(photos: photos))),
      ])
      ..add(_watchCategoryTree().listen((tree) {
        _tree = tree;
        _resolveCategory();
      }))
      ..add(_preferredLanguages.watch().listen((languages) => emit(state.copyWith(preferredLanguages: languages))));
  }

  void _resolveCategory() {
    final categoryId = state.item?.categoryId;
    if (categoryId == null || isClosed) {
      return;
    }
    for (final node in _tree) {
      if (node.category.id == categoryId) {
        emit(state.copyWith(category: node.category, parentCategory: () => null));
        return;
      }
      final child = node.children.where((child) => child.id == categoryId).firstOrNull;
      if (child != null) {
        emit(state.copyWith(category: child, parentCategory: () => node.category));
        return;
      }
    }
  }

  Future<void> _loadCachedDetails() async {
    final cached = await _fetchItemDetails?.cached(itemId);
    if (cached != null && !isClosed) {
      emit(state.copyWith(details: cached));
    }
  }

  Future<void> refreshDetails(String languageCode) async {
    final fetch = _fetchItemDetails;
    final item = state.item;
    if (fetch == null || item == null) {
      return;
    }
    emit(state.copyWith(isFetchingDetails: true));
    try {
      final details = await fetch.refresh(item, languageCode: languageCode, editionId: state.copies.map((copy) => copy.externalEditionId).nonNulls.firstOrNull);
      if (!isClosed) {
        emit(state.copyWith(details: details, isFetchingDetails: false));
      }
    } on DetailsUnavailable {
      if (!isClosed) {
        emit(state.copyWith(isFetchingDetails: false, detailsFailed: true));
      }
    }
  }

  Future<void> rate(int? rating) async {
    final item = state.item;
    if (item != null) {
      await _rateItem(item, rating);
    }
  }

  Future<ItemCopy> addCopy() => _addCopy(itemId);

  Future<void> setProgress(ItemProgress? progress) async => _setItemProgress?.call(itemId, progress);

  Future<void> addPhoto({required String copyId, required bool fromCamera}) async {
    final managePhotos = _manageItemPhotos;
    final imagePicker = _imagePicker;
    if (managePhotos == null || imagePicker == null) {
      return;
    }
    final bytes = fromCamera ? await imagePicker.takePhoto() : await imagePicker.pickFromGallery();
    if (bytes != null) {
      await managePhotos.add(itemId, bytes, copyId: copyId);
    }
  }

  Future<void> deletePhoto(ItemPhoto photo) async => _manageItemPhotos?.delete(photo);

  @override
  Future<void> close() async {
    for (final subscription in _subscriptions) {
      await subscription.cancel();
    }
    return super.close();
  }
}
