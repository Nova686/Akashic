import 'package:equatable/equatable.dart';

class BackupManifest extends Equatable {
  const BackupManifest({required this.formatVersion, required this.schemaVersion, required this.createdAt, required this.imageCount});

  static const int currentFormat = 1;

  final int formatVersion;
  final int schemaVersion;
  final DateTime createdAt;
  final int imageCount;

  Map<String, Object?> toJson() => {'format': formatVersion, 'schema': schemaVersion, 'createdAt': createdAt.toUtc().toIso8601String(), 'images': imageCount};

  static BackupManifest? fromJson(Object? json) {
    if (json is! Map<String, Object?>) {
      return null;
    }
    final (format, schema, createdAt, images) = (json['format'], json['schema'], DateTime.tryParse('${json['createdAt']}'), json['images']);
    if (format is! int || schema is! int || createdAt == null || images is! int) {
      return null;
    }
    return BackupManifest(formatVersion: format, schemaVersion: schema, createdAt: createdAt.toLocal(), imageCount: images);
  }

  @override
  List<Object?> get props => [formatVersion, schemaVersion, createdAt, imageCount];
}

class BackupFile extends Equatable {
  const BackupFile({required this.path, required this.manifest});

  final String path;
  final BackupManifest manifest;

  @override
  List<Object?> get props => [path, manifest];
}

class RemoteBackup extends Equatable {
  const RemoteBackup({required this.id, required this.name, required this.createdAt, this.sizeBytes});

  final String id;
  final String name;
  final DateTime createdAt;
  final int? sizeBytes;

  @override
  List<Object?> get props => [id, name, createdAt, sizeBytes];
}

class CorruptBackup implements Exception {
  const CorruptBackup();
}

class BackupAuthorizationRequired implements Exception {
  const BackupAuthorizationRequired();
}

class BackupStorageUnavailable implements Exception {
  const BackupStorageUnavailable([this.reason]);

  final String? reason;
}
