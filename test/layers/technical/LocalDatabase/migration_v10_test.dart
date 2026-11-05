import 'dart:io';

import 'package:akashic/layers/technical/LocalDatabase/akashic_database.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqlite3/sqlite3.dart';

void main() {
  test('a version 9 database upgrades to version 10 with an empty progress', () async {
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
    final item = (await database.select(database.items).get()).single;
    expect(item.id, 'frieren-1');
    expect(item.progressStatus, isNull);
    expect(item.progressPage, isNull);
    await database.close();
    await directory.delete(recursive: true);
  });
}
