import 'package:akashic/layers/functional/Catalog/domain/entities/category_type.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/collection_item.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/localized_titles.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/shelf_group.dart';
import 'package:akashic/layers/functional/Collection/domain/use_cases/group_items_on_shelf.dart';
import 'package:akashic/layers/functional/Settings/domain/entities/preferred_languages.dart';
import 'package:flutter_test/flutter_test.dart';

CollectionItem game(String id, String title, {String? platform}) => CollectionItem(id: id, categoryId: 'games', titles: LocalizedTitles(byLanguage: {'en': title}), groupKey: platform);

List<String> titlesOf(List<ShelfGroup> groups) => [
      for (final group in groups)
        for (final entry in group.entries)
          if (entry case ShelfItem(:final item)) item.titles.byLanguage['en']!,
    ];

void main() {
  final lastPlayed = {'hades': DateTime(2026, 10, 29), 'celeste': DateTime(2026, 9, 1), 'zelda': DateTime(2026, 10, 30)};

  test('game shelves list the most recently played first, then the others by title', () {
    final items = [game('apex', 'Apex'), game('celeste', 'Celeste'), game('hades', 'Hades'), game('braid', 'Braid')];
    expect(titlesOf(groupItemsOnShelf(items, const [], CategoryType.videoGames, PreferredLanguages.defaults, lastPlayedByItem: lastPlayed)), ['Hades', 'Celeste', 'Apex', 'Braid']);
  });

  test('platform groups follow their most recently played game', () {
    final items = [game('hades', 'Hades', platform: 'PC'), game('zelda', 'Zelda', platform: 'Switch'), game('braid', 'Braid', platform: 'Xbox')];
    final groups = groupItemsOnShelf(items, const [], CategoryType.videoGames, PreferredLanguages.defaults, lastPlayedByItem: lastPlayed);
    expect(groups.map((group) => group.label), ['Switch', 'PC', 'Xbox']);
  });

  test('other categories keep their alphabetical order', () {
    final items = [game('celeste', 'Celeste'), game('hades', 'Hades'), game('apex', 'Apex')];
    expect(titlesOf(groupItemsOnShelf(items, const [], CategoryType.books, PreferredLanguages.defaults, lastPlayedByItem: lastPlayed)), ['Apex', 'Celeste', 'Hades']);
  });
}
