import 'dart:io';

import 'package:akashic/layers/technical/LocalDatabase/akashic_database.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqlite3/sqlite3.dart';

void main() {
  test('a version 1 database upgrades and keeps its items', () async {
    final directory = await Directory.systemTemp.createTemp('akashic-migration');
    final file = File('${directory.path}/akashic.sqlite');
    final legacy = sqlite3.open(file.path);
    for (final statement in File('test/fixtures/schema/v1.sql').readAsStringSync().split(';\n')) {
      if (statement.trim().isNotEmpty) {
        legacy.execute(statement);
      }
    }
    legacy
      ..execute("INSERT INTO categories (id, name, color_value, type, condition_parts, position) VALUES ('vinyls', 'Vinyles', 0, 'music', '[]', 0)")
      ..execute("INSERT INTO items (id, category_id) VALUES ('kind-of-blue', 'vinyls')")
      ..execute("INSERT INTO copies (id, item_id) VALUES ('copy', 'kind-of-blue')")
      ..execute('PRAGMA user_version = 1')
      ..close();

    final database = AkashicDatabase(NativeDatabase(file));
    final items = await database.select(database.items).get();
    final copies = await database.select(database.copies).get();
    expect(items.single.id, 'kind-of-blue');
    expect(items.single.externalWorkId, isNull);
    expect(copies.single.barcode, isNull);
    await database.close();
    await directory.delete(recursive: true);
  });
}
