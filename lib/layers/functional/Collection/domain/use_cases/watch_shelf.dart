import 'dart:async';

import 'package:akashic/layers/functional/Catalog/domain/entities/category_type.dart';
import 'package:akashic/layers/functional/Catalog/domain/gateways/category_gateway.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/collection_item.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/series.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/shelf_group.dart';
import 'package:akashic/layers/functional/Collection/domain/gateways/collection_gateway.dart';
import 'package:akashic/layers/functional/Collection/domain/use_cases/group_items_on_shelf.dart';
import 'package:akashic/layers/functional/Settings/domain/entities/preferred_languages.dart';
import 'package:akashic/layers/functional/Settings/domain/gateways/settings_gateway.dart';

class WatchShelf {
  const WatchShelf(this._collection, this._categories, this._settings, {this._watchLastPlayed});

  final CollectionGateway _collection;
  final CategoryGateway _categories;
  final SettingsGateway _settings;
  final Stream<Map<String, DateTime>> Function()? _watchLastPlayed;

  Stream<List<ShelfGroup>> call(String categoryId) {
    late StreamController<List<ShelfGroup>> controller;
    final subscriptions = <StreamSubscription<Object?>>[];
    List<CollectionItem>? latestItems;
    List<Series>? latestSeries;
    PreferredLanguages? latestLanguages;
    var lastPlayedByItem = const <String, DateTime>{};
    CategoryType type = CategoryType.free;
    List<String> subcategoryIds = const [];
    var isCancelled = false;

    void publish() {
      final items = latestItems;
      final series = latestSeries;
      final languages = latestLanguages;
      if (items == null || series == null || languages == null) {
        return;
      }
      if (subcategoryIds.isEmpty) {
        controller.add(groupItemsOnShelf(items, series, type, languages, lastPlayedByItem: lastPlayedByItem));
        return;
      }
      final shelves = [
        for (final shelfCategoryId in [categoryId, ...subcategoryIds])
          groupItemsOnShelf(
            [for (final item in items) if (item.categoryId == shelfCategoryId) item],
            [for (final oneSeries in series) if (oneSeries.categoryId == shelfCategoryId) oneSeries],
            type,
            languages,
            lastPlayedByItem: lastPlayedByItem,
          ),
      ].where((groups) => groups.isNotEmpty).toList();
      controller.add([
        for (final (index, groups) in shelves.indexed)
          for (final (position, group) in groups.indexed)
            index > 0 && position == 0
                ? ShelfGroup(id: group.id, label: group.label, isSeries: group.isSeries, ownedCount: group.ownedCount, entries: [const ShelfGap(), ...group.entries])
                : group,
      ]);
    }

    controller = StreamController<List<ShelfGroup>>(
      onListen: () async {
        type = (await _categories.findById(categoryId))?.type ?? CategoryType.free;
        if (isCancelled) {
          return;
        }
        subcategoryIds = [
          for (final node in await _categories.watchTree().first)
            if (node.category.id == categoryId) ...node.children.map((child) => child.id),
        ];
        if (isCancelled) {
          return;
        }
        subscriptions
          ..add(_collection.watchItemsInCategoryTree(categoryId).listen((items) {
            latestItems = items;
            publish();
          }, onError: controller.addError))
          ..add(_collection.watchSeriesInCategoryTree(categoryId).listen((series) {
            latestSeries = series;
            publish();
          }, onError: controller.addError))
          ..add(_settings.watchPreferredLanguages().listen((languages) {
            latestLanguages = languages;
            publish();
          }, onError: controller.addError));
        if (_watchLastPlayed case final watchLastPlayed? when type == CategoryType.videoGames) {
          subscriptions.add(watchLastPlayed().listen((lastPlayed) {
            lastPlayedByItem = lastPlayed;
            publish();
          }, onError: controller.addError));
        }
      },
      onCancel: () async {
        isCancelled = true;
        for (final subscription in subscriptions) {
          await subscription.cancel();
        }
      },
    );
    return controller.stream;
  }
}
