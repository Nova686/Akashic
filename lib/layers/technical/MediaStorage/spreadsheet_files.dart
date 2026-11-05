import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';

class PickedSpreadsheet {
  const PickedSpreadsheet({required this.name, required this.bytes});

  final String name;
  final Uint8List bytes;
}

abstract interface class SpreadsheetFiles {
  Future<PickedSpreadsheet?> pick();
  Future<bool> save(String fileName, Uint8List bytes);
}

class DeviceSpreadsheetFiles implements SpreadsheetFiles {
  @override
  Future<PickedSpreadsheet?> pick() async {
    final file = await FilePicker.pickFile(type: FileType.custom, allowedExtensions: const ['xlsx', 'csv']);
    if (file == null) {
      return null;
    }
    return PickedSpreadsheet(name: file.name, bytes: await file.readAsBytes());
  }

  @override
  Future<bool> save(String fileName, Uint8List bytes) async => await FilePicker.saveFile(fileName: fileName, bytes: bytes) != null;
}
