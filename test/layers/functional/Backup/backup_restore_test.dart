import 'dart:io';

import 'package:akashic/layers/functional/Backup/data/archive/pending_restore.dart';
import 'package:akashic/layers/functional/Backup/data/archive/zip_collection_archiver.dart';
import 'package:akashic/layers/functional/Backup/data/gateways/drift_backup_status_gateway.dart';
import 'package:akashic/layers/functional/Backup/domain/entities/backup.dart';
import 'package:akashic/layers/functional/Backup/domain/gateways/backup_ports.dart';
import 'package:akashic/layers/functional/Backup/domain/use_cases/backup_use_cases.dart';
import 'package:akashic/layers/functional/Catalog/data/gateways/drift_category_gateway.dart';
import 'package:akashic/layers/functional/Catalog/domain/entities/category_type.dart';
import 'package:akashic/layers/functional/Catalog/domain/use_cases/create_category.dart';
import 'package:akashic/layers/functional/Collection/data/gateways/drift_collection_gateway.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/collection_item.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/localized_titles.dart';
import 'package:akashic/layers/technical/LocalDatabase/akashic_database.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

class FolderBackupStorage implements BackupStorage {
  FolderBackupStorage(this.folder);

  final Directory folder;
  bool isAuthorized = true;
  bool failsDownloads = false;
  bool failsUploads = false;
  int authorizationRequests = 0;

  @override
  Future<bool> hasAuthorization() async => isAuthorized;

  @override
  Future<void> authorize() async {
    authorizationRequests++;
    isAuthorized = true;
  }

  @override
  Future<void> upload(BackupFile backup) async {
    if (failsUploads) {
      throw const BackupStorageUnavailable('offline');
    }
    await File(backup.path).copy('${folder.path}/${File(backup.path).uri.pathSegments.last}');
  }

  @override
  Future<List<RemoteBackup>> list() async => [
        for (final file in folder.listSync().whereType<File>())
          RemoteBackup(id: file.path, name: file.uri.pathSegments.last, createdAt: file.lastModifiedSync()),
      ];

  @override
  Future<void> download(RemoteBackup backup, String targetPath) async {
    if (failsDownloads) {
      await File(targetPath).writeAsBytes([1, 2, 3]);
      throw const BackupStorageUnavailable('connection lost');
    }
    await File(backup.id).copy(targetPath);
  }
}

void main() {
  late Directory phone;
  late Directory cloud;

  setUp(() async {
    phone = await Directory.systemTemp.createTemp('akashic-phone');
    cloud = await Directory.systemTemp.createTemp('akashic-cloud');
  });

  tearDown(() async {
    await phone.delete(recursive: true);
    await cloud.delete(recursive: true);
  });

  AkashicDatabase openPhoneDatabase() => AkashicDatabase(NativeDatabase(File('${phone.path}/${AkashicDatabase.fileName}')));

  Future<void> addAlbum(AkashicDatabase database, String id, String title, {String? imagePath}) async {
    final categories = DriftCategoryGateway(database);
    final existing = await categories.watchTree().first;
    final categoryId = existing.isEmpty
        ? (await CreateCategory(categories, newId: () => 'vinyls')(name: 'Vinyles', colorValue: 0, type: CategoryType.music, conditionParts: const ['Disque'])).id
        : existing.first.category.id;
    await DriftCollectionGateway(database).saveItem(CollectionItem(id: id, categoryId: categoryId, titles: LocalizedTitles(byLanguage: {'en': title}), imagePath: imagePath));
  }

  ZipCollectionArchiver archiverFor(AkashicDatabase database) =>
      ZipCollectionArchiver(database: database, documents: phone, workDirectory: Directory('${phone.path}/backup-work'), now: () => DateTime(2026, 10, 27, 20));

  test('a backup archive restores the same collection, images included', () async {
    final database = openPhoneDatabase();
    final image = File('${phone.path}/images/cover.jpg');
    await image.create(recursive: true);
    await image.writeAsBytes([9, 9, 9]);
    await addAlbum(database, 'kob', 'Kind of Blue', imagePath: '/old/phone/app_flutter/images/cover.jpg');
    final storage = FolderBackupStorage(cloud);
    final status = DriftBackupStatusGateway(database);
    final manifest = await BackUpCollection(archiverFor(database), storage, status)(canAskToSignIn: false);
    expect(manifest.imageCount, 1);
    expect(await status.watchLastBackupAt().first, DateTime(2026, 10, 27, 20));
    await addAlbum(database, 'later', 'Bought after the backup');
    final backup = (await ListRemoteBackups(storage)()).single;
    await RestoreCollection(archiverFor(database), storage)(backup);
    await database.close();
    await image.delete();
    expect(await applyPendingRestore(documents: phone, databaseFileName: AkashicDatabase.fileName, maximumSchema: AkashicDatabase.currentSchemaVersion), RestoreOutcome.restored);
    final restored = openPhoneDatabase();
    final items = await DriftCollectionGateway(restored).allItems();
    expect(items.map((item) => item.id), ['kob']);
    expect(items.single.imagePath, '${phone.path}/images/cover.jpg');
    expect(await File('${phone.path}/images/cover.jpg').readAsBytes(), [9, 9, 9]);
    expect(File('${phone.path}/$pendingRestoreFileName').existsSync(), isFalse);
    await restored.close();
  });

  test('an interrupted restore leaves the current database untouched', () async {
    final database = openPhoneDatabase();
    await addAlbum(database, 'kob', 'Kind of Blue');
    final storage = FolderBackupStorage(cloud);
    await BackUpCollection(archiverFor(database), storage, DriftBackupStatusGateway(database))(canAskToSignIn: false);
    storage.failsDownloads = true;
    await expectLater(RestoreCollection(archiverFor(database), storage)((await storage.list()).single), throwsA(isA<BackupStorageUnavailable>()));
    expect(File('${phone.path}/$pendingRestoreFileName').existsSync(), isFalse);
    await addAlbum(database, 'still-here', 'Still here');
    await database.close();
    expect(await applyPendingRestore(documents: phone, databaseFileName: AkashicDatabase.fileName, maximumSchema: AkashicDatabase.currentSchemaVersion), RestoreOutcome.nothingPending);
    final reopened = openPhoneDatabase();
    expect((await DriftCollectionGateway(reopened).allItems()).map((item) => item.id), unorderedEquals(['kob', 'still-here']));
    await reopened.close();
  });

  test('a corrupt archive is refused before anything is staged', () async {
    final database = openPhoneDatabase();
    final corrupt = File('${cloud.path}/broken.zip')..writeAsBytesSync([80, 75, 3, 4, 0, 0]);
    final storage = FolderBackupStorage(cloud);
    await expectLater(
      RestoreCollection(archiverFor(database), storage)(RemoteBackup(id: corrupt.path, name: 'broken.zip', createdAt: DateTime(2026))),
      throwsA(isA<CorruptBackup>()),
    );
    expect(File('${phone.path}/$pendingRestoreFileName').existsSync(), isFalse);
    await database.close();
  });

  test('a manual backup asks to sign in, an automatic one never does', () async {
    final database = openPhoneDatabase();
    final storage = FolderBackupStorage(cloud)..isAuthorized = false;
    final status = DriftBackupStatusGateway(database);
    final backUp = BackUpCollection(archiverFor(database), storage, status);
    expect(await AutomaticBackup(backUp, status)(), isFalse);
    expect(storage.authorizationRequests, 0);
    expect(cloud.listSync(), isEmpty);
    await backUp(canAskToSignIn: true);
    expect(storage.authorizationRequests, 1);
    expect(await AutomaticBackup(backUp, status, now: () => DateTime(2026, 10, 30))(), isFalse);
    expect(await AutomaticBackup(backUp, status, now: () => DateTime(2026, 11, 5))(), isTrue);
    await database.close();
  });

  test('a restore that cannot finish keeps the collection and never blocks the next launch', () async {
    final database = openPhoneDatabase();
    await addAlbum(database, 'kob', 'Kind of Blue');
    final storage = FolderBackupStorage(cloud);
    await BackUpCollection(archiverFor(database), storage, DriftBackupStatusGateway(database))(canAskToSignIn: false);
    await RestoreCollection(archiverFor(database), storage)((await storage.list()).single);
    await database.close();
    final pending = File('${phone.path}/$pendingRestoreFileName');
    final bytes = await pending.readAsBytes();
    await pending.writeAsBytes(bytes.sublist(0, bytes.length - 40));
    expect(await applyPendingRestore(documents: phone, databaseFileName: AkashicDatabase.fileName, maximumSchema: AkashicDatabase.currentSchemaVersion), RestoreOutcome.failed);
    expect(pending.existsSync(), isFalse);
    expect(await applyPendingRestore(documents: phone, databaseFileName: AkashicDatabase.fileName, maximumSchema: AkashicDatabase.currentSchemaVersion), RestoreOutcome.nothingPending);
    final reopened = openPhoneDatabase();
    expect((await DriftCollectionGateway(reopened).allItems()).single.id, 'kob');
    expect(await archiverFor(reopened).takeFailedRestore(), isTrue);
    expect(await archiverFor(reopened).takeFailedRestore(), isFalse);
    await reopened.close();
  });

  test('a backup that cannot be sent leaves no archive behind', () async {
    final database = openPhoneDatabase();
    await addAlbum(database, 'kob', 'Kind of Blue');
    final storage = FolderBackupStorage(cloud)..failsUploads = true;
    final status = DriftBackupStatusGateway(database);
    await expectLater(BackUpCollection(archiverFor(database), storage, status)(canAskToSignIn: false), throwsA(isA<BackupStorageUnavailable>()));
    final work = Directory('${phone.path}/backup-work');
    expect(work.existsSync() ? work.listSync() : const [], isEmpty);
    expect(await status.watchLastBackupAt().first, isNull);
    await database.close();
  });

  test('two backups asked at once share the same run', () async {
    final database = openPhoneDatabase();
    await addAlbum(database, 'kob', 'Kind of Blue');
    final storage = FolderBackupStorage(cloud);
    final backUp = BackUpCollection(archiverFor(database), storage, DriftBackupStatusGateway(database));
    final results = await Future.wait([backUp(canAskToSignIn: false), backUp(canAskToSignIn: false)]);
    expect(results.first, results.last);
    expect(cloud.listSync(), hasLength(1));
    await database.close();
  });
}
