import 'dart:async';

import 'package:akashic/layers/functional/Catalog/domain/gateways/category_gateway.dart';
import 'package:akashic/layers/functional/Catalog/domain/use_cases/root_categories.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/collection_item.dart';
import 'package:akashic/layers/functional/Collection/domain/gateways/collection_gateway.dart';
import 'package:akashic/layers/functional/Organisation/domain/entities/smart_shelf.dart';
import 'package:akashic/layers/functional/Organisation/domain/gateways/organisation_gateways.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FilledSmartShelf extends Equatable {
  const FilledSmartShelf({required this.shelf, required this.items, required this.categoryColorValue});

  final SmartShelf shelf;
  final List<CollectionItem> items;
  final int categoryColorValue;

  @override
  List<Object?> get props => [shelf, items, categoryColorValue];
}

class SmartShelvesCubit extends Cubit<List<FilledSmartShelf>> {
  SmartShelvesCubit(this._shelves, this._collection, this._categories, this._tags) : super(const []);

  final SmartShelfGateway _shelves;
  final CollectionGateway _collection;
  final CategoryGateway _categories;
  final TagGateway _tags;
  final List<StreamSubscription<Object?>> _subscriptions = [];
  List<SmartShelf> _defined = const [];
  int _generation = 0;

  void start() {
    _subscriptions
      ..add(_shelves.watchAll().listen((shelves) {
        _defined = shelves;
        _refresh();
      }))
      ..add(_collection.watchOwnedWorks().listen((_) => _refresh()))
      ..add(_tags.watchTagCounts().listen((_) => _refresh()));
  }

  Future<void> _refresh() async {
    final generation = ++_generation;
    if (_defined.isEmpty) {
      if (!isClosed) {
        emit(const []);
      }
      return;
    }
    final roots = rootCategoryById(await _categories.watchTree().first);
    final items = await _collection.allItems();
    final copies = await _collection.firstCopiesByItem();
    final tags = await _tags.tagsByItem();
    final filled = [
      for (final shelf in _defined)
        FilledSmartShelf(
          shelf: shelf,
          categoryColorValue: roots[shelf.categoryId]?.colorValue ?? 0xFF7FA8FF,
          items: [
            for (final item in items)
              if ((shelf.categoryId == null || roots[item.categoryId]?.id == shelf.categoryId) && shelf.filter.accepts(item, copies[item.id], tags[item.id] ?? const {})) item,
          ],
        ),
    ];
    if (!isClosed && generation == _generation) {
      emit(filled);
    }
  }

  Future<void> delete(String shelfId) => _shelves.delete(shelfId);

  @override
  Future<void> close() async {
    for (final subscription in _subscriptions) {
      await subscription.cancel();
    }
    return super.close();
  }
}
