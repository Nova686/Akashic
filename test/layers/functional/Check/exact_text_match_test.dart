import 'package:akashic/layers/functional/Check/domain/use_cases/find_locally.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/collection_item.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/localized_titles.dart';
import 'package:flutter_test/flutter_test.dart';

import '../Collection/collection_harness.dart';

void main() {
  test('only an exact title counts as already owned when typing or reading a cover', () async {
    final harness = CollectionHarness();
    final books = await harness.vinyls();
    await harness.collection.saveItem(CollectionItem(id: 'messiah', categoryId: books.id, titles: const LocalizedTitles(byLanguage: {'en': 'Dune Messiah'}), creator: 'Frank Herbert'));
    final findLocally = FindLocally(harness.collection);
    expect(await findLocally.bestTextMatch('Dune'), isNull);
    expect(await findLocally.bestTextMatch('Frank Herbert'), isNull);
    expect((await findLocally.bestTextMatch('dune messiah'))?.item.id, 'messiah');
    expect((await findLocally.bestTextMatch('  DUNE   MESSIAH ')), isNotNull);
    await harness.database.close();
  });
}
