import 'package:akashic/layers/functional/Collection/domain/use_cases/collection_search_matcher.dart';
import 'package:flutter_test/flutter_test.dart';

import 'collection_fixtures.dart';

void main() {
  test('search ignores accents, case and matches any language variant', () {
    final item = buildItem(titles: {'fr': 'Pokémon Écarlate', 'en': 'Pokemon Scarlet'}, creator: 'Game Freak');
    const matcher = CollectionSearchMatcher();
    expect(matcher.matches(item, 'ecarlate'), isTrue);
    expect(matcher.matches(item, 'POKEMON scarlet'), isTrue);
    expect(matcher.matches(item, 'game   freak'), isTrue);
    expect(matcher.matches(item, ''), isFalse);
    expect(matcher.matches(item, 'zelda'), isFalse);
  });
}
