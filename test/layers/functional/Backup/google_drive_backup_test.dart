import 'dart:convert';
import 'dart:io';

import 'package:akashic/layers/functional/Backup/data/gateways/google_drive_backup_storage.dart';
import 'package:akashic/layers/functional/Backup/domain/entities/backup.dart';
import 'package:akashic/layers/functional/Backup/domain/gateways/backup_ports.dart';
import 'package:akashic/layers/functional/Backup/domain/use_cases/backup_use_cases.dart';
import 'package:akashic/layers/functional/Backup/presentation/cubit/backup_cubit.dart';
import 'package:akashic/layers/functional/Backup/presentation/views/backup_view.dart';
import 'package:akashic/layers/technical/Localization/app_localizations.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:mocktail/mocktail.dart';

class FakeDriveAuthorization implements DriveAuthorization {
  List<String?> silentTokens = ['token'];
  final List<String> forgotten = [];

  @override
  Future<String?> silentAccessToken() async => silentTokens.length > 1 ? silentTokens.removeAt(0) : silentTokens.single;

  @override
  Future<String> interactiveAccessToken() async => 'fresh-token';

  @override
  Future<void> forget(String accessToken) async => forgotten.add(accessToken);
}

class MockBackUpCollection extends Mock implements BackUpCollection {}

class MockListRemoteBackups extends Mock implements ListRemoteBackups {}

class MockRestoreCollection extends Mock implements RestoreCollection {}

class MockBackupStorage extends Mock implements BackupStorage {}

class MockBackupStatus extends Mock implements BackupStatusGateway {}

class MockBackupCubit extends MockCubit<BackupState> implements BackupCubit {}

class MockArchiver extends Mock implements CollectionArchiver {}

String driveFiles(int count) => jsonEncode({
      'files': [
        for (var index = 0; index < count; index++) {'id': 'file-$index', 'name': 'akashic-$index.zip', 'createdTime': '2026-10-${(index + 1).toString().padLeft(2, '0')}T20:00:00Z', 'size': '1024'},
      ],
    });

void main() {
  test('the drive listing reads the app folder', () async {
    final requests = <http.Request>[];
    final storage = GoogleDriveBackupStorage(MockClient((request) async {
      requests.add(request);
      return http.Response(driveFiles(2), 200);
    }), FakeDriveAuthorization());
    final backups = await storage.list();
    expect(backups.map((backup) => backup.id), ['file-0', 'file-1']);
    expect(backups.first.sizeBytes, 1024);
    expect(requests.single.url.queryParameters['spaces'], 'appDataFolder');
    expect(requests.single.headers['Authorization'], 'Bearer token');
  });

  test('a drive folder link or id becomes the backup folder, anything else keeps the app space', () {
    const folderId = '1AbCdEfGhIjKlMnOpQrStUvWxYz012345';
    expect(DriveBackupLocation.fromSetting('https://drive.google.com/drive/folders/$folderId?usp=drive_link').folderId, folderId);
    expect(DriveBackupLocation.fromSetting(folderId).folderId, folderId);
    expect(DriveBackupLocation.fromSetting('').folderId, isNull);
    expect(DriveBackupLocation.fromSetting(folderId).scope, driveFullScope);
    expect(const DriveBackupLocation.appData().scope, driveAppDataScope);
  });

  test('a folder backup is uploaded into the folder and only its akashic archives are listed', () async {
    final directory = await Directory.systemTemp.createTemp('akashic-folder');
    final archive = File('${directory.path}/akashic.zip')..writeAsBytesSync([1]);
    final listings = <Uri>[];
    String? uploadedMetadata;
    final storage = GoogleDriveBackupStorage(
      MockClient((request) async {
        if (request.method == 'POST') {
          uploadedMetadata = request.body;
          return http.Response('', 200, headers: {'location': 'https://upload.example/session'});
        }
        if (request.method == 'PUT') {
          return http.Response('{"id":"new"}', 200);
        }
        listings.add(request.url);
        return http.Response(driveFiles(1), 200);
      }),
      FakeDriveAuthorization(),
      location: const DriveBackupLocation.folder('folder-42'),
    );
    await storage.upload(BackupFile(
      path: archive.path,
      manifest: BackupManifest(formatVersion: 1, schemaVersion: 7, createdAt: DateTime(2026, 10, 27), imageCount: 0),
    ));
    expect(uploadedMetadata, contains('"parents":["folder-42"]'));
    final query = listings.single.queryParameters['q']!;
    expect(query, contains("'folder-42' in parents"));
    expect(query, contains("name contains 'akashic-'"));
    expect(query, contains('trashed = false'));
    expect(listings.single.queryParameters['spaces'], 'drive');
    await directory.delete(recursive: true);
  });

  test('an expired token is renewed silently once', () async {
    final authorization = FakeDriveAuthorization()..silentTokens = ['old', 'renewed'];
    final storage = GoogleDriveBackupStorage(MockClient((request) async {
      return request.headers['Authorization'] == 'Bearer renewed' ? http.Response(driveFiles(1), 200) : http.Response('', 401);
    }), authorization);
    expect(await storage.list(), hasLength(1));
    expect(authorization.forgotten, ['old']);
  });

  test('a token refused twice asks for a new authorization', () async {
    final storage = GoogleDriveBackupStorage(MockClient((request) async => http.Response('', 401)), FakeDriveAuthorization());
    await expectLater(storage.list(), throwsA(isA<BackupAuthorizationRequired>()));
  });

  test('a quota refusal is not mistaken for an expired authorization', () async {
    final authorization = FakeDriveAuthorization();
    final storage = GoogleDriveBackupStorage(MockClient((request) async => http.Response('{"error":"rateLimitExceeded"}', 403)), authorization);
    await expectLater(storage.list(), throwsA(isA<BackupStorageUnavailable>()));
    expect(authorization.forgotten, isEmpty);
  });

  test('an upload keeps only the five latest backups', () async {
    final directory = await Directory.systemTemp.createTemp('akashic-upload');
    final archive = File('${directory.path}/akashic.zip')..writeAsBytesSync([1, 2, 3]);
    final deleted = <String>[];
    final storage = GoogleDriveBackupStorage(MockClient((request) async {
      if (request.method == 'DELETE') {
        deleted.add(request.url.pathSegments.last);
        return http.Response('', 204);
      }
      if (request.method == 'POST') {
        expect(request.url.queryParameters['uploadType'], 'resumable');
        expect(request.body, contains('"parents":["appDataFolder"]'));
        return http.Response('', 200, headers: {'location': 'https://upload.example/session'});
      }
      if (request.method == 'PUT') {
        expect(request.url.toString(), 'https://upload.example/session');
        expect(request.bodyBytes, [1, 2, 3]);
        return http.Response('{"id":"new"}', 200);
      }
      return http.Response(driveFiles(7), 200);
    }), FakeDriveAuthorization());
    await storage.upload(BackupFile(
      path: archive.path,
      manifest: BackupManifest(formatVersion: 1, schemaVersion: 7, createdAt: DateTime(2026, 10, 27), imageCount: 0),
    ));
    expect(deleted, unorderedEquals(['file-0', 'file-1']));
    await directory.delete(recursive: true);
  });

  test('without a valid authorization the screen only shows the reminder', () async {
    final storage = MockBackupStorage();
    final status = MockBackupStatus();
    when(storage.hasAuthorization).thenAnswer((_) async => false);
    when(status.watchLastBackupAt).thenAnswer((_) => Stream.value(DateTime(2026, 10, 1)));
    final backUp = MockBackUpCollection();
    final archiver = MockArchiver();
    when(archiver.takeFailedRestore).thenAnswer((_) async => false);
    final cubit = BackupCubit(backUp: backUp, listBackups: MockListRemoteBackups(), restore: MockRestoreCollection(), storage: storage, status: status, archiver: archiver);
    await cubit.start();
    expect(cubit.state.needsReconnect, isTrue);
    expect(cubit.state.notice, BackupNotice.none);
    verifyNever(() => backUp(canAskToSignIn: any(named: 'canAskToSignIn')));
    verifyNever(storage.authorize);
    await cubit.close();
  });

  testWidgets('the backup screen shows the last backup and the reminder', (tester) async {
    final cubit = MockBackupCubit();
    when(() => cubit.canUseFiles).thenReturn(false);
    when(() => cubit.state).thenReturn(BackupState(lastBackupAt: DateTime(2026, 10, 20, 21, 5), needsReconnect: true));
    await tester.pumpWidget(MaterialApp(
      locale: const Locale('fr'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: BlocProvider<BackupCubit>.value(value: cubit, child: const BackupView()),
    ));
    expect(find.textContaining('20 oct. 2026'), findsOneWidget);
    expect(find.textContaining('La connexion Google a expiré'), findsOneWidget);
    expect(find.text('Se reconnecter à Google'), findsOneWidget);
  });
}
