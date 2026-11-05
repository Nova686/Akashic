import 'dart:io';

import 'package:akashic/layers/technical/LocalDatabase/akashic_database.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqlite3/sqlite3.dart';

void main() {
  test('a version 5 database upgrades to version 6', () async {
    final directory = await Directory.systemTemp.createTemp('akashic-migration');
    final file = File('${directory.path}/akashic.sqlite');
    final legacy = sqlite3.open(file.path);
    for (final statement in File('test/fixtures/schema/v5.sql').readAsStringSync().split(';\n')) {
      if (statement.trim().isNotEmpty) {
        legacy.execute(statement);
      }
    }
    legacy
      ..execute("INSERT INTO categories (id, name, color_value, type, condition_parts, position) VALUES ('mangas', 'Mangas', 0, 'manga', '[]', 0)")
      ..execute("INSERT INTO series (id, category_id) VALUES ('frieren', 'mangas')")
      ..execute('PRAGMA user_version = 5')
      ..close();
    final database = AkashicDatabase(NativeDatabase(file));
    expect((await database.select(database.seriesTable).get()).single.id, 'frieren');
    expect(await database.select(database.scanFollows).get(), isEmpty);
    expect(await database.select(database.readChapters).get(), isEmpty);
    expect(await database.select(database.scanReleases).get(), isEmpty);
    await database.close();
    await directory.delete(recursive: true);
  });

  test('scan data disappears with its series', () async {
    final database = AkashicDatabase.forTesting();
    await database.into(database.categories).insert(CategoriesCompanion.insert(id: 'mangas', name: 'Mangas', colorValue: 0, type: 'manga', conditionParts: '[]', position: 0));
    await database.into(database.seriesTable).insert(SeriesTableCompanion.insert(id: 'frieren', categoryId: 'mangas'));
    await database.into(database.scanFollows).insert(ScanFollowsCompanion.insert(seriesId: 'frieren'));
    await database.into(database.readChapters).insert(ReadChaptersCompanion.insert(seriesId: 'frieren', chapter: 12));
    await database.into(database.scanReleases).insert(ScanReleasesCompanion.insert(seriesId: 'frieren', chapter: 13, teamName: 'Team'));
    await (database.delete(database.seriesTable)..where((table) => table.id.equals('frieren'))).go();
    expect(await database.select(database.scanFollows).get(), isEmpty);
    expect(await database.select(database.readChapters).get(), isEmpty);
    expect(await database.select(database.scanReleases).get(), isEmpty);
    await database.close();
  });
}
