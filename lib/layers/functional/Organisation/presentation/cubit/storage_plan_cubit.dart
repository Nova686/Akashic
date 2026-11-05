import 'dart:async';

import 'package:akashic/layers/functional/Collection/domain/entities/collection_item.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/item_copy.dart';
import 'package:akashic/layers/functional/Collection/domain/gateways/collection_gateway.dart';
import 'package:akashic/layers/functional/Collection/domain/use_cases/resolve_display_title.dart';
import 'package:akashic/layers/functional/Collection/domain/use_cases/search_text_normalizer.dart';
import 'package:akashic/layers/functional/Organisation/domain/entities/storage_place.dart';
import 'package:akashic/layers/functional/Organisation/domain/gateways/organisation_gateways.dart';
import 'package:akashic/layers/functional/Settings/domain/entities/preferred_languages.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';

class WhereIsAnswer extends Equatable {
  const WhereIsAnswer({required this.item, required this.title, this.copy});

  final CollectionItem item;
  final String title;
  final ItemCopy? copy;

  String? get location => copy?.location?.trim().isEmpty ?? true ? null : copy!.location!.trim();

  String? get borrower => copy?.loanedTo;

  @override
  List<Object?> get props => [item.id, title, copy];
}

class StoragePlanState extends Equatable {
  const StoragePlanState({required this.places, this.countByPath = const {}, this.query = '', this.answers = const [], this.isLoading = true});

  final List<StoragePlace> places;
  final Map<String, int> countByPath;
  final String query;
  final List<WhereIsAnswer> answers;
  final bool isLoading;

  StoragePlan get plan => StoragePlan(places);

  int countUnder(String path) => countByPath.entries.where((entry) => isStoredUnder(entry.key, path)).fold(0, (total, entry) => total + entry.value);

  @override
  List<Object?> get props => [places, countByPath, query, answers, isLoading];
}

class StoragePlanCubit extends Cubit<StoragePlanState> {
  StoragePlanCubit(this._places, this._collection, {String Function()? newId})
      : _newId = newId ?? const Uuid().v4,
        super(const StoragePlanState(places: []));

  final StoragePlanGateway _places;
  final CollectionGateway _collection;
  final String Function() _newId;
  StreamSubscription<List<StoragePlace>>? _subscription;
  List<CollectionItem> _items = const [];
  Map<String, ItemCopy> _copies = const {};

  static const int answersShown = 20;

  Future<void> start() async {
    _items = await _collection.allItems();
    _copies = await _collection.firstCopiesByItem();
    final counts = <String, int>{};
    for (final copy in _copies.values) {
      if (copy.location?.trim() case final location? when location.isNotEmpty) {
        counts[location] = (counts[location] ?? 0) + 1;
      }
    }
    _subscription = _places.watchAll().listen((places) {
      if (!isClosed) {
        emit(StoragePlanState(places: places, countByPath: counts, query: state.query, answers: state.answers, isLoading: false));
      }
    });
  }

  Future<void> addPlace(String name, {String? parentId}) {
    final siblings = state.plan.childrenOf(parentId);
    return _places.save(StoragePlace(id: _newId(), parentId: parentId, name: name.trim(), position: siblings.length));
  }

  Future<void> rename(StoragePlace place, String name) => _places.save(StoragePlace(id: place.id, parentId: place.parentId, name: name.trim(), position: place.position));

  Future<void> remove(StoragePlace place) => _places.delete([place.id, ...state.plan.descendantsOf(place.id)]);

  void search(String query) {
    final words = normalizeForSearch(query).split(' ').where((word) => word.isNotEmpty).toList();
    final answers = <WhereIsAnswer>[];
    if (words.isNotEmpty) {
      for (final item in _items) {
        final title = resolveDisplayTitle(item.titles, PreferredLanguages.defaults) ?? '';
        final haystack = normalizeForSearch('$title ${item.creator ?? ''}');
        if (words.every(haystack.contains)) {
          answers.add(WhereIsAnswer(item: item, title: title, copy: _copies[item.id]));
          if (answers.length == answersShown) {
            break;
          }
        }
      }
    }
    emit(StoragePlanState(places: state.places, countByPath: state.countByPath, query: query, answers: answers, isLoading: false));
  }

  @override
  Future<void> close() async {
    await _subscription?.cancel();
    return super.close();
  }
}
