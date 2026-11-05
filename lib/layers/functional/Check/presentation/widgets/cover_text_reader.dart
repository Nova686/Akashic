import 'dart:io';
import 'dart:typed_data';

import 'package:akashic/layers/functional/Check/domain/use_cases/cover_text_lines.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

abstract interface class CoverTextReader {
  Future<List<CoverTextLine>> readLines(Uint8List image);
}

class MlKitCoverTextReader implements CoverTextReader {
  @override
  Future<List<CoverTextLine>> readLines(Uint8List image) async {
    final directory = await Directory.systemTemp.createTemp('akashic-cover');
    final file = File('${directory.path}/cover.jpg');
    await file.writeAsBytes(image, flush: true);
    final recognizers = [TextRecognizer(), TextRecognizer(script: TextRecognitionScript.japanese)];
    try {
      final image = InputImage.fromFilePath(file.path);
      final readings = await Future.wait(recognizers.map((recognizer) => recognizer.processImage(image)));
      return [
        for (final recognized in readings)
          for (final block in recognized.blocks)
            for (final line in block.lines) CoverTextLine(line.text, height: line.boundingBox.height),
      ];
    } finally {
      for (final recognizer in recognizers) {
        await recognizer.close();
      }
      await directory.delete(recursive: true);
    }
  }
}
