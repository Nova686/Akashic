import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:akashic/layers/functional/Backup/domain/entities/backup.dart';
import 'package:akashic/layers/functional/Backup/domain/gateways/backup_ports.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;

const String driveAppDataScope = 'https://www.googleapis.com/auth/drive.appdata';
const String driveFullScope = 'https://www.googleapis.com/auth/drive';

class DriveBackupLocation {
  const DriveBackupLocation.appData() : folderId = null;

  const DriveBackupLocation.folder(String this.folderId);

  factory DriveBackupLocation.fromSetting(String setting) {
    final trimmed = setting.trim();
    final folderId = RegExp(r'folders/([A-Za-z0-9_-]+)').firstMatch(trimmed)?.group(1) ?? (RegExp(r'^[A-Za-z0-9_-]{10,}$').hasMatch(trimmed) ? trimmed : null);
    return folderId == null ? const DriveBackupLocation.appData() : DriveBackupLocation.folder(folderId);
  }

  final String? folderId;

  String get scope => folderId == null ? driveAppDataScope : driveFullScope;

  String get parent => folderId ?? 'appDataFolder';

  Map<String, String> get listingParameters => switch (folderId) {
        null => const {'spaces': 'appDataFolder'},
        final folderId => {
            'q': "'$folderId' in parents and trashed = false and name contains 'akashic-' and mimeType = 'application/zip'",
            'spaces': 'drive',
            'supportsAllDrives': 'true',
            'includeItemsFromAllDrives': 'true',
          },
      };
}

abstract interface class DriveAuthorization {
  Future<String?> silentAccessToken();
  Future<String> interactiveAccessToken();
  Future<void> forget(String accessToken);
}

class GoogleSignInDriveAuthorization implements DriveAuthorization {
  GoogleSignInDriveAuthorization({this._serverClientId, this._scopes = const [driveAppDataScope]});

  final String? _serverClientId;
  final List<String> _scopes;
  Future<void>? _initialization;

  Future<void> _initialized() => _initialization ??= GoogleSignIn.instance.initialize(serverClientId: _serverClientId);

  @override
  Future<String?> silentAccessToken() async {
    try {
      await _initialized();
      return (await GoogleSignIn.instance.authorizationClient.authorizationForScopes(_scopes))?.accessToken;
    } on GoogleSignInException {
      return null;
    }
  }

  @override
  Future<String> interactiveAccessToken() async {
    try {
      await _initialized();
      return (await GoogleSignIn.instance.authorizationClient.authorizeScopes(_scopes)).accessToken;
    } on GoogleSignInException catch (failure) {
      throw BackupStorageUnavailable(failure.code.name);
    }
  }

  @override
  Future<void> forget(String accessToken) async {
    await _initialized();
    await GoogleSignIn.instance.authorizationClient.clearAuthorizationToken(accessToken: accessToken);
  }
}

class GoogleDriveBackupStorage implements BackupStorage {
  GoogleDriveBackupStorage(this._client, this._authorization, {this._keptBackups = 5, this._location = const DriveBackupLocation.appData()});

  static const Duration _deadline = Duration(minutes: 10);

  final http.Client _client;
  final DriveAuthorization _authorization;
  final int _keptBackups;
  final DriveBackupLocation _location;
  String? _accessToken;

  @override
  Future<bool> hasAuthorization() async {
    _accessToken ??= await _authorization.silentAccessToken();
    return _accessToken != null;
  }

  @override
  Future<void> authorize() async => _accessToken = await _authorization.interactiveAccessToken();

  Future<http.StreamedResponse> _send(http.BaseRequest Function() buildRequest) async {
    for (var attempt = 0; attempt < 2; attempt++) {
      final token = _accessToken ?? await _authorization.silentAccessToken();
      if (token == null) {
        throw const BackupAuthorizationRequired();
      }
      _accessToken = token;
      final request = buildRequest()..headers['Authorization'] = 'Bearer $token';
      final http.StreamedResponse response;
      try {
        response = await _client.send(request).timeout(_deadline);
      } on IOException catch (failure) {
        throw BackupStorageUnavailable('$failure');
      } on http.ClientException catch (failure) {
        throw BackupStorageUnavailable(failure.message);
      } on TimeoutException {
        throw const BackupStorageUnavailable('timeout');
      }
      if (response.statusCode == 401) {
        await response.stream.drain<void>();
        _accessToken = null;
        await _authorization.forget(token);
        continue;
      }
      if (response.statusCode < 200 || response.statusCode >= 300) {
        final reason = await response.stream.bytesToString();
        throw BackupStorageUnavailable('HTTP ${response.statusCode} $reason');
      }
      return response;
    }
    throw const BackupAuthorizationRequired();
  }

  Future<String> _sendForText(http.BaseRequest Function() buildRequest) async => (await _send(buildRequest)).stream.bytesToString();

  @override
  Future<void> upload(BackupFile backup) async {
    final archive = File(backup.path);
    final length = await archive.length();
    final session = await _send(() => http.Request('POST', Uri.https('www.googleapis.com', '/upload/drive/v3/files', {'uploadType': 'resumable', 'supportsAllDrives': 'true'}))
      ..headers.addAll({'Content-Type': 'application/json; charset=UTF-8', 'X-Upload-Content-Type': 'application/zip', 'X-Upload-Content-Length': '$length'})
      ..body = jsonEncode({'name': archive.uri.pathSegments.last, 'parents': [_location.parent], 'mimeType': 'application/zip'}));
    await session.stream.drain<void>();
    final location = session.headers['location'];
    if (location == null) {
      throw const BackupStorageUnavailable('no upload session');
    }
    await (await _send(() => _archiveUpload(Uri.parse(location), archive, length))).stream.drain<void>();
    await _pruneOldBackups();
  }

  http.StreamedRequest _archiveUpload(Uri location, File archive, int length) {
    final request = http.StreamedRequest('PUT', location)
      ..headers['Content-Type'] = 'application/zip'
      ..contentLength = length;
    unawaited(request.sink.addStream(archive.openRead()).whenComplete(request.sink.close));
    return request;
  }

  Future<void> _pruneOldBackups() async {
    try {
      final backups = await list()
        ..sort((first, second) => second.createdAt.compareTo(first.createdAt));
      for (final outdated in backups.skip(_keptBackups)) {
        await (await _send(() => http.Request('DELETE', Uri.https('www.googleapis.com', '/drive/v3/files/${outdated.id}', {'supportsAllDrives': 'true'})))).stream.drain<void>();
      }
    } on BackupStorageUnavailable {
      return;
    }
  }

  @override
  Future<List<RemoteBackup>> list() async {
    final body = await _sendForText(() => http.Request(
          'GET',
          Uri.https('www.googleapis.com', '/drive/v3/files', {..._location.listingParameters, 'fields': 'files(id,name,createdTime,size)', 'pageSize': '100'}),
        ));
    final Object? decoded;
    try {
      decoded = jsonDecode(body);
    } on FormatException {
      throw const BackupStorageUnavailable('unreadable listing');
    }
    final files = decoded is Map<String, Object?> ? decoded['files'] as List? ?? const [] : const [];
    return [
      for (final file in files.whereType<Map<String, Object?>>())
        if (DateTime.tryParse('${file['createdTime']}') case final createdAt?)
          RemoteBackup(id: '${file['id']}', name: '${file['name']}', createdAt: createdAt.toLocal(), sizeBytes: int.tryParse('${file['size']}')),
    ];
  }

  @override
  Future<void> download(RemoteBackup backup, String targetPath) async {
    final response = await _send(() => http.Request('GET', Uri.https('www.googleapis.com', '/drive/v3/files/${backup.id}', {'alt': 'media', 'supportsAllDrives': 'true'})));
    final sink = File(targetPath).openWrite();
    try {
      await response.stream.pipe(sink);
    } on IOException catch (failure) {
      throw BackupStorageUnavailable('$failure');
    } on http.ClientException catch (failure) {
      throw BackupStorageUnavailable(failure.message);
    }
  }
}
