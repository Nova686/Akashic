import 'dart:io';

import 'package:akashic/layers/functional/Backup/data/archive/zip_collection_archiver.dart';
import 'package:archive/archive_io.dart';
import 'package:sqlite3/sqlite3.dart';

enum RestoreOutcome { nothingPending, restored, failed }

Future<RestoreOutcome> applyPendingRestore({required Directory documents, required String databaseFileName, required int maximumSchema}) async {
  final pending = File('${documents.path}/$pendingRestoreFileName');
  if (!await pending.exists()) {
    return RestoreOutcome.nothingPending;
  }
  final staging = Directory('${documents.path}/restore-staging');
  try {
    if (await staging.exists()) {
      await staging.delete(recursive: true);
    }
    await Directory('${staging.path}/images').create(recursive: true);
    final stagedDatabase = File('${staging.path}/$databaseFileName');
    _extract(pending.path, stagedDatabase.path, '${staging.path}/', maximumSchema);
    _prepareRestoredDatabase(stagedDatabase, '${documents.path}/images/');
    for (final suffix in ['-wal', '-shm']) {
      final current = File('${documents.path}/$databaseFileName$suffix');
      if (await current.exists()) {
        await current.delete();
      }
    }
    await stagedDatabase.rename('${documents.path}/$databaseFileName');
    final images = Directory('${documents.path}/images');
    if (await images.exists()) {
      await images.delete(recursive: true);
    }
    await Directory('${staging.path}/images').rename(images.path);
    await staging.delete(recursive: true);
    await pending.delete();
    return RestoreOutcome.restored;
  } on Object catch (_) {
    if (await staging.exists()) {
      await staging.delete(recursive: true);
    }
    if (await pending.exists()) {
      await pending.rename('${documents.path}/$failedRestoreFileName');
    }
    return RestoreOutcome.failed;
  }
}

void _extract(String archivePath, String databasePath, String stagingPrefix, int maximumSchema) {
  final input = InputFileStream(archivePath);
  try {
    final archive = ZipDecoder().decodeStream(input);
    manifestOfArchive(archive, maximumSchema: maximumSchema);
    for (final file in archive.files.where((file) => file.isFile)) {
      final String target;
      if (file.name == databaseEntry) {
        target = databasePath;
      } else if (file.name.startsWith(imagesEntryPrefix) && !file.name.contains('..') && !file.name.substring(imagesEntryPrefix.length).contains('/')) {
        target = '$stagingPrefix${file.name}';
      } else {
        continue;
      }
      final output = OutputFileStream(target);
      try {
        file.writeContent(output);
      } finally {
        output.closeSync();
      }
    }
  } finally {
    input.closeSync();
  }
}

void _prepareRestoredDatabase(File databaseFile, String imagesDirectory) {
  final database = sqlite3.open(databaseFile.path);
  try {
    final integrity = database.select('PRAGMA integrity_check').firstOrNull?.values.firstOrNull;
    if (integrity != 'ok') {
      throw StateError('restored database is damaged: $integrity');
    }
    database.execute(
      "UPDATE items SET image_path = ? || substr(image_path, instr(image_path, '/images/') + 8) WHERE image_path LIKE '%/images/%'",
      [imagesDirectory],
    );
    if (database.select("SELECT name FROM sqlite_master WHERE type = 'table' AND name = 'item_photos'").isNotEmpty) {
      database.execute(
        "UPDATE item_photos SET path = ? || substr(path, instr(path, '/images/') + 8) WHERE path LIKE '%/images/%'",
        [imagesDirectory],
      );
    }
  } finally {
    database.close();
  }
}
