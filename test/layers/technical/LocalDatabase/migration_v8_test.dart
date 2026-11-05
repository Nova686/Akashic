import 'dart:io';

import 'package:akashic/layers/technical/LocalDatabase/akashic_database.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqlite3/sqlite3.dart';

void main() {
  test('a version 7 database upgrades to version 8', () async {
    final directory = await Directory.systemTemp.createTemp('akashic-migration');
    final file = File('${directory.path}/akashic.sqlite');
    final legacy = sqlite3.open(file.path);
    for (final statement in File('test/fixtures/schema/v7.sql').readAsStringSync().split(';\n')) {
      if (statement.trim().isNotEmpty) {
        legacy.execute(statement);
      }
    }
    legacy
      ..execute("INSERT INTO categories (id, name, color_value, type, condition_parts, position) VALUES ('vinyls', 'Vinyles', 0, 'music', '[]', 0)")
      ..execute('PRAGMA user_version = 7')
      ..close();
    final database = AkashicDatabase(NativeDatabase(file));
    expect((await database.select(database.categories).get()).single.id, 'vinyls');
    expect(await database.select(database.sourceBlocks).get(), isEmpty);
    await database.close();
    await directory.delete(recursive: true);
  });
}
