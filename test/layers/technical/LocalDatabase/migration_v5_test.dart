import 'dart:io';

import 'package:akashic/layers/technical/LocalDatabase/akashic_database.dart';
import 'package:drift/drift.dart' hide isNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqlite3/sqlite3.dart';

void main() {
  test('a version 4 database upgrades to version 5', () async {
    final directory = await Directory.systemTemp.createTemp('akashic-migration');
    final file = File('${directory.path}/akashic.sqlite');
    final legacy = sqlite3.open(file.path);
    for (final statement in File('test/fixtures/schema/v4.sql').readAsStringSync().split(';\n')) {
      if (statement.trim().isNotEmpty) {
        legacy.execute(statement);
      }
    }
    legacy
      ..execute("INSERT INTO categories (id, name, color_value, type, condition_parts, position) VALUES ('mangas', 'Mangas', 0, 'manga', '[]', 0)")
      ..execute("INSERT INTO items (id, category_id) VALUES ('frieren-1', 'mangas')")
      ..execute('PRAGMA user_version = 4')
      ..close();
    final database = AkashicDatabase(NativeDatabase(file));
    expect((await database.select(database.items).get()).single.id, 'frieren-1');
    expect(await database.select(database.wishes).get(), isEmpty);
    expect(await database.select(database.dismissedSuggestions).get(), isEmpty);
    expect(await database.select(database.discoveryCache).get(), isEmpty);
    await database.close();
    await directory.delete(recursive: true);
  });

  test('a missing volume wish disappears with its series', () async {
    final database = AkashicDatabase.forTesting();
    await database.into(database.categories).insert(CategoriesCompanion.insert(id: 'mangas', name: 'Mangas', colorValue: 0, type: 'manga', conditionParts: '[]', position: 0));
    await database.into(database.seriesTable).insert(SeriesTableCompanion.insert(id: 'frieren', categoryId: 'mangas'));
    await database.into(database.wishes).insert(WishesCompanion.insert(
      id: 'w1',
      categoryType: 'manga',
      title: 'Frieren 4',
      origin: 'missingVolume',
      seriesId: const Value('frieren'),
      volumeNumber: const Value(4),
    ));
    await (database.delete(database.seriesTable)..where((table) => table.id.equals('frieren'))).go();
    expect(await database.select(database.wishes).get(), isEmpty);
    await database.close();
  });
}
