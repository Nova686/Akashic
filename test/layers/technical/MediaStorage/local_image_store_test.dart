import 'dart:io';
import 'dart:typed_data';

import 'package:akashic/layers/technical/MediaStorage/local_image_store.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late Directory root;

  setUp(() async => root = await Directory.systemTemp.createTemp('akashic-images'));
  tearDown(() => root.delete(recursive: true));

  test('save writes a file under images and returns its path', () async {
    final store = LocalImageStore(root);
    final path = await store.save(Uint8List.fromList([1, 2, 3]));
    expect(path, startsWith('${root.path}/images/'));
    expect(await File(path).readAsBytes(), [1, 2, 3]);
    await store.delete(path);
    expect(File(path).existsSync(), isFalse);
  });
}
