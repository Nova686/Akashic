import 'dart:io';

import 'package:akashic/layers/technical/LocalDatabase/akashic_database.dart';
import 'package:drift/drift.dart' hide isNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqlite3/sqlite3.dart';

void main() {
  test('a version 3 database upgrades to version 4', () async {
    final directory = await Directory.systemTemp.createTemp('akashic-migration');
    final file = File('${directory.path}/akashic.sqlite');
    final legacy = sqlite3.open(file.path);
    for (final statement in File('test/fixtures/schema/v3.sql').readAsStringSync().split(';\n')) {
      if (statement.trim().isNotEmpty) {
        legacy.execute(statement);
      }
    }
    legacy
      ..execute("INSERT INTO categories (id, name, color_value, type, condition_parts, position) VALUES ('tcg', 'TCG', 0, 'cards', '[]', 0)")
      ..execute("INSERT INTO series (id, category_id) VALUES ('frieren', 'tcg')")
      ..execute("INSERT INTO items (id, category_id) VALUES ('deck', 'tcg')")
      ..execute('PRAGMA user_version = 3')
      ..close();
    final database = AkashicDatabase(NativeDatabase(file));
    expect((await database.select(database.items).get()).single.cardKind, isNull);
    expect((await database.select(database.seriesTable).get()).single.status, isNull);
    expect(await database.select(database.deckCards).get(), isEmpty);
    expect(await database.select(database.itemDetails).get(), isEmpty);
    await database.close();
    await directory.delete(recursive: true);
  });

  test('deck cards and details are deleted with their item', () async {
    final database = AkashicDatabase.forTesting();
    await database.into(database.categories).insert(CategoriesCompanion.insert(id: 'tcg', name: 'TCG', colorValue: 0, type: 'cards', conditionParts: '[]', position: 0));
    await database.into(database.items).insert(ItemsCompanion.insert(id: 'deck', categoryId: 'tcg', cardKind: const Value('deck')));
    await database.into(database.deckCards).insert(DeckCardsCompanion.insert(id: 'c1', itemId: 'deck', name: 'Pikachu', quantity: 2));
    await database.into(database.itemDetails).insert(ItemDetailsCompanion.insert(itemId: 'deck', payload: '{}'));
    await (database.delete(database.items)..where((table) => table.id.equals('deck'))).go();
    expect(await database.select(database.deckCards).get(), isEmpty);
    expect(await database.select(database.itemDetails).get(), isEmpty);
    await database.close();
  });
}
