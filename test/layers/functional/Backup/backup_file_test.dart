import 'package:akashic/layers/functional/Backup/domain/entities/backup.dart';
import 'package:akashic/layers/functional/Backup/domain/gateways/backup_ports.dart';
import 'package:akashic/layers/functional/Backup/domain/use_cases/backup_use_cases.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockArchiver extends Mock implements CollectionArchiver {}

class RecordingFiles implements ArchiveFileExchange {
  RecordingFiles({this.picks = true});

  final bool picks;
  final List<(String, String)> saved = [];
  final List<String> pickedInto = [];

  @override
  Future<bool> save(String archivePath, String fileName) async {
    saved.add((archivePath, fileName));
    return true;
  }

  @override
  Future<bool> pickInto(String targetPath) async {
    pickedInto.add(targetPath);
    return picks;
  }
}

void main() {
  late MockArchiver archiver;
  final manifest = BackupManifest(formatVersion: 1, schemaVersion: 8, createdAt: DateTime(2026, 10, 28, 9), imageCount: 3);

  setUp(() {
    archiver = MockArchiver();
    when(() => archiver.create()).thenAnswer((_) async => BackupFile(path: '/work/akashic.zip', manifest: manifest));
    when(() => archiver.discard(any())).thenAnswer((_) async {});
    when(() => archiver.downloadTarget()).thenAnswer((_) async => '/work/incoming.zip');
    when(() => archiver.inspect(any())).thenAnswer((_) async => manifest);
    when(() => archiver.stageForRestore(any())).thenAnswer((_) async {});
  });

  test('exporting offers the full archive under a dated name and cleans it up', () async {
    final files = RecordingFiles();
    expect(await ExportCollection(archiver, files)(), isTrue);
    expect(files.saved, [('/work/akashic.zip', 'akashic-2026-10-28.zip')]);
    verify(() => archiver.discard('/work/akashic.zip')).called(1);
  });

  test('restoring from a file checks the archive and stages it', () async {
    final files = RecordingFiles();
    expect(await RestoreCollectionFromFile(archiver, files)(), manifest);
    expect(files.pickedInto, ['/work/incoming.zip']);
    verify(() => archiver.stageForRestore('/work/incoming.zip')).called(1);
    verify(() => archiver.discard('/work/incoming.zip')).called(1);
  });

  test('a cancelled file choice restores nothing', () async {
    expect(await RestoreCollectionFromFile(archiver, RecordingFiles(picks: false))(), isNull);
    verifyNever(() => archiver.stageForRestore(any()));
  });
}
