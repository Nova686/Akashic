import 'dart:io';

import 'package:akashic/layers/technical/LocalDatabase/akashic_database.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqlite3/sqlite3.dart';

void main() {
  test('a version 8 database upgrades to version 9 without the pending checks table', () async {
    final directory = await Directory.systemTemp.createTemp('akashic-migration');
    final file = File('${directory.path}/akashic.sqlite');
    final legacy = sqlite3.open(file.path);
    for (final statement in File('test/fixtures/schema/v8.sql').readAsStringSync().split(';\n')) {
      if (statement.trim().isNotEmpty) {
        legacy.execute(statement);
      }
    }
    legacy
      ..execute("INSERT INTO categories (id, name, color_value, type, condition_parts, position) VALUES ('vinyls', 'Vinyles', 0, 'music', '[]', 0)")
      ..execute("INSERT INTO pending_checks (id, kind, query) VALUES ('old', 'barcode', '0888751238211')")
      ..execute('PRAGMA user_version = 8')
      ..close();
    final database = AkashicDatabase(NativeDatabase(file));
    expect((await database.select(database.categories).get()).single.id, 'vinyls');
    final tables = await database.customSelect("SELECT name FROM sqlite_master WHERE type = 'table'").get();
    expect(tables.map((row) => row.read<String>('name')), isNot(contains('pending_checks')));
    await database.close();
    await directory.delete(recursive: true);
  });
}
