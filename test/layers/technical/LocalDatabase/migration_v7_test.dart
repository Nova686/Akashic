import 'dart:io';

import 'package:akashic/layers/technical/LocalDatabase/akashic_database.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqlite3/sqlite3.dart';

void main() {
  test('a version 6 database upgrades to version 7', () async {
    final directory = await Directory.systemTemp.createTemp('akashic-migration');
    final file = File('${directory.path}/akashic.sqlite');
    final legacy = sqlite3.open(file.path);
    for (final statement in File('test/fixtures/schema/v6.sql').readAsStringSync().split(';\n')) {
      if (statement.trim().isNotEmpty) {
        legacy.execute(statement);
      }
    }
    legacy
      ..execute("INSERT INTO categories (id, name, color_value, type, condition_parts, position) VALUES ('vinyls', 'Vinyles', 0, 'music', '[]', 0)")
      ..execute("INSERT INTO items (id, category_id) VALUES ('kob', 'vinyls')")
      ..execute("INSERT INTO copies (id, item_id, price_paid_cents) VALUES ('copy', 'kob', 2500)")
      ..execute('PRAGMA user_version = 6')
      ..close();
    final database = AkashicDatabase(NativeDatabase(file));
    final copy = (await database.select(database.copies).get()).single;
    expect(copy.pricePaidCents, 2500);
    expect(copy.loanedTo, isNull);
    expect(copy.loanedSince, isNull);
    await database.close();
    await directory.delete(recursive: true);
  });
}
