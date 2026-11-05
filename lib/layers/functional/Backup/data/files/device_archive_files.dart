import 'dart:io';

import 'package:akashic/layers/functional/Backup/domain/gateways/backup_ports.dart';
import 'package:file_picker/file_picker.dart';

class DeviceArchiveFiles implements ArchiveFileExchange {
  @override
  Future<bool> save(String archivePath, String fileName) async {
    final bytes = await File(archivePath).readAsBytes();
    return await FilePicker.saveFile(fileName: fileName, bytes: bytes) != null;
  }

  @override
  Future<bool> pickInto(String targetPath) async {
    final picked = await FilePicker.pickFile(type: FileType.custom, allowedExtensions: const ['zip']);
    if (picked == null) {
      return false;
    }
    await File(targetPath).writeAsBytes(await picked.readAsBytes(), flush: true);
    return true;
  }
}
