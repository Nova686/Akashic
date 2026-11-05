import 'package:akashic/layers/functional/Catalog/domain/entities/category_type.dart';
import 'package:akashic/layers/functional/Collection/domain/use_cases/group_items_on_shelf.dart';
import 'package:akashic/layers/functional/Settings/domain/entities/preferred_languages.dart';
import 'package:flutter_test/flutter_test.dart';

import 'collection_fixtures.dart';

void main() {
  const preferred = PreferredLanguages(['fr', 'en']);

  test('series volumes are ordered with gaps as missing volumes', () {
    final groups = groupItemsOnShelf([vol(3), vol(1), vol(5)], [frieren], CategoryType.manga, preferred);
    expect(groups.single.entries.map(describe), ['divider:Frieren', 'item:1', 'missing:2', 'item:3', 'missing:4', 'item:5']);
    expect(groups.single.ownedCount, 3);
    expect(groups.single.isSeries, isTrue);
    expect(groups.single.isIncomplete, isTrue);
  });

  test('vinyls are grouped by artist alphabetically', () {
    final groups = groupItemsOnShelf([
      buildItem(id: 'dsotm', titles: {'en': 'The Dark Side of the Moon'}, creator: 'Pink Floyd'),
      buildItem(id: 'kob', titles: {'en': 'Kind of Blue'}, creator: 'Miles Davis'),
      buildItem(id: 'wall', titles: {'en': 'The Wall'}, creator: 'Pink Floyd'),
    ], const [], CategoryType.music, preferred);
    expect(groups.map((group) => group.label), ['Miles Davis', 'Pink Floyd']);
    expect(groups.last.entries.map(describe), ['divider:Pink Floyd', 'item:dsotm', 'item:wall']);
  });

  test('group key wins over creator and ungrouped items come last without divider', () {
    final groups = groupItemsOnShelf([
      buildItem(id: 'loose', titles: {'en': 'Loose'}),
      buildItem(id: 'zelda', titles: {'en': 'Zelda'}, creator: 'Nintendo', groupKey: 'Switch'),
    ], const [], CategoryType.videoGames, preferred);
    expect(groups.map((group) => group.label), ['Switch', '']);
    expect(groups.last.entries.map(describe), ['item:loose']);
  });

  test('a complete series is not incomplete', () {
    final groups = groupItemsOnShelf([vol(1), vol(2)], [frieren], CategoryType.manga, preferred);
    expect(groups.single.isIncomplete, isFalse);
  });
}
