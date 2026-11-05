import 'dart:io';

import 'package:akashic/layers/technical/LocalDatabase/akashic_database.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqlite3/sqlite3.dart';

Future<Set<String>> indexNamesOf(AkashicDatabase database) async =>
    {for (final row in await database.customSelect("SELECT name FROM sqlite_master WHERE type = 'index'").get()) row.read<String>('name')};

void main() {
  test('a new database is created with its lookup indexes', () async {
    final database = AkashicDatabase.forTesting();
    expect(await indexNamesOf(database), containsAll(AkashicDatabase.lookupIndexes.keys));
    await database.close();
  });

  test('a version 9 database upgrades to version 11 with the lookup indexes and keeps its items', () async {
    final directory = await Directory.systemTemp.createTemp('akashic-migration');
    final file = File('${directory.path}/akashic.sqlite');
    final legacy = sqlite3.open(file.path);
    for (final statement in File('test/fixtures/schema/v9.sql').readAsStringSync().split(';\n')) {
      if (statement.trim().isNotEmpty) {
        legacy.execute(statement);
      }
    }
    legacy
      ..execute("INSERT INTO categories (id, name, color_value, type, condition_parts, position) VALUES ('mangas', 'Mangas', 0, 'manga', '[]', 0)")
      ..execute("INSERT INTO items (id, category_id) VALUES ('frieren-1', 'mangas')")
      ..execute('PRAGMA user_version = 9')
      ..close();
    final database = AkashicDatabase(NativeDatabase(file));
    expect((await database.select(database.items).get()).single.id, 'frieren-1');
    expect(await indexNamesOf(database), containsAll(AkashicDatabase.lookupIndexes.keys));
    final plan = await database.customSelect("EXPLAIN QUERY PLAN SELECT * FROM items WHERE category_id = 'mangas'").get();
    expect(plan.map((row) => row.read<String>('detail')).join(), contains('items_by_category'));
    await database.close();
    await directory.delete(recursive: true);
  });
}
