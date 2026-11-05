import 'package:akashic/layers/functional/Backup/domain/entities/backup.dart';
import 'package:akashic/layers/functional/Backup/domain/gateways/backup_ports.dart';

class BackUpCollection {
  BackUpCollection(this._archiver, this._storage, this._status);

  final CollectionArchiver _archiver;
  final BackupStorage _storage;
  final BackupStatusGateway _status;
  Future<BackupManifest>? _running;

  Future<BackupManifest> call({required bool canAskToSignIn}) {
    final running = _running;
    if (running != null) {
      return running;
    }
    final backup = _backUp(canAskToSignIn: canAskToSignIn);
    _running = backup;
    return backup.whenComplete(() => _running = null);
  }

  Future<BackupManifest> _backUp({required bool canAskToSignIn}) async {
    if (!await _storage.hasAuthorization()) {
      if (!canAskToSignIn) {
        throw const BackupAuthorizationRequired();
      }
      await _storage.authorize();
    }
    final backup = await _archiver.create();
    try {
      await _storage.upload(backup);
    } finally {
      await _archiver.discard(backup.path);
    }
    await _status.saveLastBackupAt(backup.manifest.createdAt);
    return backup.manifest;
  }
}

class ListRemoteBackups {
  ListRemoteBackups(this._storage);

  final BackupStorage _storage;

  Future<List<RemoteBackup>> call() async {
    if (!await _storage.hasAuthorization()) {
      await _storage.authorize();
    }
    return (await _storage.list())..sort((first, second) => second.createdAt.compareTo(first.createdAt));
  }
}

class RestoreCollection {
  RestoreCollection(this._archiver, this._storage);

  final CollectionArchiver _archiver;
  final BackupStorage _storage;

  Future<BackupManifest> call(RemoteBackup backup) async {
    final target = await _archiver.downloadTarget();
    try {
      await _storage.download(backup, target);
      final manifest = await _archiver.inspect(target);
      await _archiver.stageForRestore(target);
      return manifest;
    } finally {
      await _archiver.discard(target);
    }
  }
}

class ExportCollection {
  ExportCollection(this._archiver, this._files);

  final CollectionArchiver _archiver;
  final ArchiveFileExchange _files;

  Future<bool> call() async {
    final backup = await _archiver.create();
    try {
      final createdAt = backup.manifest.createdAt;
      final day = '${createdAt.year}-${'${createdAt.month}'.padLeft(2, '0')}-${'${createdAt.day}'.padLeft(2, '0')}';
      return await _files.save(backup.path, 'akashic-$day.zip');
    } finally {
      await _archiver.discard(backup.path);
    }
  }
}

class RestoreCollectionFromFile {
  RestoreCollectionFromFile(this._archiver, this._files);

  final CollectionArchiver _archiver;
  final ArchiveFileExchange _files;

  Future<BackupManifest?> call() async {
    final target = await _archiver.downloadTarget();
    try {
      if (!await _files.pickInto(target)) {
        return null;
      }
      final manifest = await _archiver.inspect(target);
      await _archiver.stageForRestore(target);
      return manifest;
    } finally {
      await _archiver.discard(target);
    }
  }
}

class AutomaticBackup {
  AutomaticBackup(this._backUp, this._status, {DateTime Function()? now, this._interval = const Duration(days: 7)}) : _now = now ?? DateTime.now;

  final BackUpCollection _backUp;
  final BackupStatusGateway _status;
  final DateTime Function() _now;
  final Duration _interval;

  Future<bool> call() async {
    final last = await _status.watchLastBackupAt().first;
    if (last != null && _now().difference(last) < _interval) {
      return false;
    }
    try {
      await _backUp(canAskToSignIn: false);
      return true;
    } on BackupAuthorizationRequired {
      return false;
    } on BackupStorageUnavailable {
      return false;
    }
  }
}
