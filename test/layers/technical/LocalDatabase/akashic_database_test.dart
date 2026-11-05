import 'package:akashic/layers/technical/LocalDatabase/akashic_database.dart';
import 'package:drift/drift.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late AkashicDatabase database;

  setUp(() => database = AkashicDatabase.forTesting());
  tearDown(() => database.close());

  Future<void> seedItemWithCopy() async {
    await database.into(database.categories).insert(CategoriesCompanion.insert(
          id: 'vinyls',
          name: 'Vinyles',
          colorValue: 0xFF7FA8FF,
          type: 'music',
          conditionParts: '["Disque","Pochette"]',
          position: 0,
        ));
    await database.into(database.items).insert(ItemsCompanion.insert(id: 'kind-of-blue', categoryId: 'vinyls'));
    await database.into(database.itemTitles).insert(ItemTitlesCompanion.insert(itemId: 'kind-of-blue', languageCode: 'fr', title: 'Kind of Blue'));
    await database.into(database.itemTitles).insert(ItemTitlesCompanion.insert(itemId: 'kind-of-blue', languageCode: 'en', title: 'Kind of Blue'));
    await database.into(database.copies).insert(CopiesCompanion.insert(id: 'copy-1', itemId: 'kind-of-blue', edition: const Value('Réédition 2015, 180 g')));
    await database.into(database.copyConditions).insert(CopyConditionsCompanion.insert(copyId: 'copy-1', part: 'Disque', condition: 'veryGood'));
    await database.into(database.copyConditions).insert(CopyConditionsCompanion.insert(copyId: 'copy-1', part: 'Pochette', condition: 'good'));
  }

  test('stores an item with its titles, copy and conditions', () async {
    await seedItemWithCopy();
    expect(await database.select(database.itemTitles).get(), hasLength(2));
    expect(await database.select(database.copyConditions).get(), hasLength(2));
  });

  test('deleting an item removes its titles, copies and conditions', () async {
    await seedItemWithCopy();
    await (database.delete(database.items)..where((item) => item.id.equals('kind-of-blue'))).go();
    expect(await database.select(database.itemTitles).get(), isEmpty);
    expect(await database.select(database.copies).get(), isEmpty);
    expect(await database.select(database.copyConditions).get(), isEmpty);
  });

  test('an item cannot reference a missing category', () async {
    expect(
      () => database.into(database.items).insert(ItemsCompanion.insert(id: 'orphan', categoryId: 'nowhere')),
      throwsA(isA<Exception>()),
    );
  });
}
