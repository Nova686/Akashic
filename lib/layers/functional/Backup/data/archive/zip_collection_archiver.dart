import 'dart:convert';
import 'dart:io';
import 'dart:isolate';

import 'package:akashic/layers/functional/Backup/domain/entities/backup.dart';
import 'package:akashic/layers/functional/Backup/domain/gateways/backup_ports.dart';
import 'package:akashic/layers/technical/LocalDatabase/akashic_database.dart';
import 'package:archive/archive_io.dart';

const String manifestEntry = 'manifest.json';
const String databaseEntry = 'akashic.sqlite';
const String imagesEntryPrefix = 'images/';
const String pendingRestoreFileName = 'akashic-restore.zip';
const String failedRestoreFileName = 'akashic-restore.failed.zip';

class ZipCollectionArchiver implements CollectionArchiver {
  ZipCollectionArchiver({required this._database, required this._documents, required this._workDirectory, DateTime Function()? now}) : _now = now ?? DateTime.now;

  final AkashicDatabase _database;
  final Directory _documents;
  final Directory _workDirectory;
  final DateTime Function() _now;

  static const Duration _runsKeptFor = Duration(days: 1);

  Future<void> _forgetOldRuns() async {
    final limit = _now().subtract(_runsKeptFor);
    for (final entry in await _workDirectory.list().toList()) {
      if (entry is Directory && entry.path.split('/').last.startsWith('run-') && (await entry.stat()).modified.isBefore(limit)) {
        await entry.delete(recursive: true);
      }
    }
  }

  @override
  Future<BackupFile> create() async {
    await _workDirectory.create(recursive: true);
    await _forgetOldRuns();
    final run = await _workDirectory.createTemp('run-');
    final snapshot = File('${run.path}/snapshot.sqlite');
    await _database.customStatement('VACUUM INTO ?', [snapshot.path]);
    final images = Directory('${_documents.path}/images');
    final imagePaths = await images.exists() ? [for (final entry in await images.list().toList()) if (entry is File) entry.path] : const <String>[];
    final manifest = BackupManifest(formatVersion: BackupManifest.currentFormat, schemaVersion: _database.schemaVersion, createdAt: _now(), imageCount: imagePaths.length);
    final zipPath = '${run.path}/akashic-${manifest.createdAt.toUtc().toIso8601String().replaceAll(RegExp('[:.]'), '-')}.zip';
    final manifestJson = jsonEncode(manifest.toJson());
    await Isolate.run(() => _writeZip(zipPath, manifestJson, snapshot.path, imagePaths));
    await snapshot.delete();
    return BackupFile(path: zipPath, manifest: manifest);
  }

  @override
  Future<BackupManifest> inspect(String archivePath) => Isolate.run(() => manifestOfArchiveFile(archivePath, maximumSchema: AkashicDatabase.currentSchemaVersion));

  @override
  Future<String> downloadTarget() async {
    await _workDirectory.create(recursive: true);
    return '${_workDirectory.path}/download.part';
  }

  @override
  Future<void> stageForRestore(String archivePath) async {
    await File(archivePath).rename('${_documents.path}/$pendingRestoreFileName');
  }

  @override
  Future<bool> takeFailedRestore() async {
    final failed = File('${_documents.path}/$failedRestoreFileName');
    if (!await failed.exists()) {
      return false;
    }
    await failed.delete();
    return true;
  }

  @override
  Future<void> discard(String archivePath) async {
    final archive = File(archivePath);
    if (await archive.exists()) {
      await archive.delete();
    }
    final run = archive.parent;
    if (run.path.split('/').last.startsWith('run-') && await run.exists()) {
      await run.delete(recursive: true);
    }
  }
}

Future<void> _writeZip(String zipPath, String manifestJson, String snapshotPath, List<String> imagePaths) async {
  final encoder = ZipFileEncoder()..create(zipPath);
  try {
    encoder.addArchiveFile(ArchiveFile.string(manifestEntry, manifestJson));
    await encoder.addFile(File(snapshotPath), databaseEntry);
    for (final imagePath in imagePaths) {
      await encoder.addFile(File(imagePath), '$imagesEntryPrefix${File(imagePath).uri.pathSegments.last}', 0);
    }
  } finally {
    await encoder.close();
  }
}

BackupManifest manifestOfArchiveFile(String archivePath, {required int maximumSchema}) {
  final input = InputFileStream(archivePath);
  try {
    return manifestOfArchive(ZipDecoder().decodeStream(input), maximumSchema: maximumSchema);
  } on CorruptBackup {
    rethrow;
  } on Exception {
    throw const CorruptBackup();
  } finally {
    input.closeSync();
  }
}

BackupManifest manifestOfArchive(Archive archive, {required int maximumSchema}) {
  try {
    final manifestFile = archive.findFile(manifestEntry);
    final databaseFile = archive.findFile(databaseEntry);
    final manifest = manifestFile == null ? null : BackupManifest.fromJson(jsonDecode(utf8.decode(manifestFile.content)));
    if (manifest == null || databaseFile == null || manifest.schemaVersion > maximumSchema || manifest.formatVersion > BackupManifest.currentFormat) {
      throw const CorruptBackup();
    }
    return manifest;
  } on CorruptBackup {
    rethrow;
  } on Exception {
    throw const CorruptBackup();
  }
}
