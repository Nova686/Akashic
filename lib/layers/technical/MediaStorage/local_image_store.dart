import 'dart:io';
import 'dart:typed_data';

import 'package:uuid/uuid.dart';

class LocalImageStore {
  LocalImageStore(this._root);

  final Directory _root;

  Future<String> save(Uint8List bytes) async {
    final directory = Directory('${_root.path}/images');
    await directory.create(recursive: true);
    final file = File('${directory.path}/${const Uuid().v4()}.jpg');
    await file.writeAsBytes(bytes, flush: true);
    return file.path;
  }

  Future<void> delete(String path) async {
    final file = File(path);
    if (await file.exists()) {
      await file.delete();
    }
  }
}
