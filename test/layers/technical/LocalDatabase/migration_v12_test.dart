import 'dart:io';

import 'package:akashic/layers/technical/LocalDatabase/akashic_database.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqlite3/sqlite3.dart';

void main() {
  test('a version 11 database moves each photo onto the first copy of its item', () async {
    final directory = await Directory.systemTemp.createTemp('akashic-migration');
    final file = File('${directory.path}/akashic.sqlite');
    final legacy = sqlite3.open(file.path);
    for (final statement in File('test/fixtures/schema/v11.sql').readAsStringSync().split(';\n')) {
      if (statement.trim().isNotEmpty) {
        legacy.execute(statement);
      }
    }
    legacy
      ..execute("INSERT INTO categories (id, name, color_value, type, condition_parts, position) VALUES ('vinyls', 'Vinyles', 0, 'music', '[]', 0)")
      ..execute("INSERT INTO items (id, category_id) VALUES ('kob', 'vinyls')")
      ..execute("INSERT INTO copies (id, item_id, created_at) VALUES ('kob-late', 'kob', 2000), ('kob-first', 'kob', 1000)")
      ..execute("INSERT INTO item_photos (id, item_id, path, position) VALUES ('photo', 'kob', '/images/photo.jpg', 0)")
      ..execute('PRAGMA user_version = 11')
      ..close();
    final database = AkashicDatabase(NativeDatabase(file));
    final photo = (await database.select(database.itemPhotos).get()).single;
    expect(photo.copyId, 'kob-first');
    final indexes = await database.customSelect("SELECT name FROM sqlite_master WHERE type = 'index'").get();
    expect(indexes.map((row) => row.read<String>('name')), contains('item_photos_by_copy'));
    final items = await database.select(database.items).get();
    expect(items.map((item) => item.id).toSet(), {'kob', 'split-kob-late'});
    expect(items.every((item) => item.marketValueCents == null), isTrue);
    expect({for (final copy in await database.select(database.copies).get()) copy.id: copy.itemId}, {'kob-first': 'kob', 'kob-late': 'split-kob-late'});
    expect(await database.select(database.deckCards).get(), isEmpty);
    expect(await database.select(database.steamGameStats).get(), isEmpty);
    expect(await database.select(database.sales).get(), isEmpty);
    expect(await database.select(database.sealedPrices).get(), isEmpty);
    expect(await database.select(database.steamWatches).get(), isEmpty);
    expect(await database.select(database.priceAlerts).get(), isEmpty);
    expect(await database.select(database.valueSnapshots).get(), isEmpty);
    expect(await database.select(database.scanSessions).get(), isEmpty);
    expect(await database.select(database.activityEvents).get(), isEmpty);
    expect(await database.select(database.goals).get(), isEmpty);
    expect(await database.select(database.itemTags).get(), isEmpty);
    expect(await database.select(database.storagePlaces).get(), isEmpty);
    expect((await database.select(database.copies).get()).map((copy) => (copy.isOpened, copy.purchasedOn, copy.purchaseChannel)).toSet(), {(false, null, null)});
    expect(await database.customSelect('PRAGMA user_version').map((row) => row.read<int>('user_version')).getSingle(), AkashicDatabase.currentSchemaVersion);
    await database.close();
    await directory.delete(recursive: true);
  });
}
