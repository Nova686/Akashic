import 'package:akashic/layers/functional/Backup/domain/entities/backup.dart';

abstract interface class CollectionArchiver {
  Future<BackupFile> create();
  Future<BackupManifest> inspect(String archivePath);
  Future<void> stageForRestore(String archivePath);
  Future<String> downloadTarget();
  Future<void> discard(String archivePath);
  Future<bool> takeFailedRestore();
}

abstract interface class ArchiveFileExchange {
  Future<bool> save(String archivePath, String fileName);
  Future<bool> pickInto(String targetPath);
}

abstract interface class BackupStorage {
  Future<bool> hasAuthorization();
  Future<void> authorize();
  Future<void> upload(BackupFile backup);
  Future<List<RemoteBackup>> list();
  Future<void> download(RemoteBackup backup, String targetPath);
}

abstract interface class BackupStatusGateway {
  Stream<DateTime?> watchLastBackupAt();
  Future<void> saveLastBackupAt(DateTime at);
}
