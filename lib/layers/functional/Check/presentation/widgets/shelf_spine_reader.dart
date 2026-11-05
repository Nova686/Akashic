import 'dart:io';
import 'dart:isolate';
import 'dart:typed_data';

import 'package:akashic/layers/functional/Check/domain/use_cases/shelf_spines.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image/image.dart' as img;

abstract interface class ShelfSpineReader {
  Future<ShelfReading> readShelf(Uint8List photo);
}

final RegExp _japaneseCharacters = RegExp(r'[\p{Script=Hiragana}\p{Script=Katakana}\p{Script=Han}]', unicode: true);

SpineBounds uprightBoundsOf(SpineBounds turned, {required int quarterTurns, required int width, required int height}) => switch (quarterTurns % 4) {
      1 => SpineBounds(left: turned.top, top: height - turned.right, right: turned.bottom, bottom: height - turned.left),
      3 => SpineBounds(left: width - turned.bottom, top: turned.left, right: width - turned.top, bottom: turned.right),
      _ => turned,
    };

typedef PreparedShelf = ({Uint8List upright, Uint8List quarter, Uint8List threeQuarters, int width, int height});

PreparedShelf? prepareShelfPhoto(Uint8List photo, int workingWidth) {
  final decoded = img.decodeImage(photo);
  if (decoded == null) {
    return null;
  }
  final upright = img.bakeOrientation(decoded);
  final resized = upright.width > workingWidth ? img.copyResize(upright, width: workingWidth) : upright;
  return (
    upright: img.encodeJpg(resized, quality: 85),
    quarter: img.encodeJpg(img.copyRotate(resized, angle: 90), quality: 90),
    threeQuarters: img.encodeJpg(img.copyRotate(resized, angle: 270), quality: 90),
    width: resized.width,
    height: resized.height,
  );
}

class MlKitShelfSpineReader implements ShelfSpineReader {
  static const int workingWidth = 2000;

  @override
  Future<ShelfReading> readShelf(Uint8List photo) async {
    final prepared = await Isolate.run(() => prepareShelfPhoto(photo, workingWidth));
    if (prepared == null) {
      return const ShelfReading(spines: []);
    }
    final uprightJpeg = prepared.upright;
    final directory = await Directory.systemTemp.createTemp('akashic-shelf');
    final recognizer = TextRecognizer();
    final japaneseRecognizer = TextRecognizer(script: TextRecognitionScript.japanese);
    try {
      final spines = <SpineText>[];
      final uprightFile = File('${directory.path}/shelf-upright.jpg');
      await uprightFile.writeAsBytes(uprightJpeg, flush: true);
      final turnedPhotos = {1: prepared.quarter, 3: prepared.threeQuarters};
      for (final quarterTurns in const [0, 1, 3]) {
        final file = quarterTurns == 0 ? uprightFile : File('${directory.path}/shelf-$quarterTurns.jpg');
        if (quarterTurns != 0) {
          await file.writeAsBytes(turnedPhotos[quarterTurns]!, flush: true);
        }
        final recognized = await recognizer.processImage(InputImage.fromFilePath(file.path));
        spines.addAll(spinesFromLines([
          for (final block in recognized.blocks)
            for (final line in block.lines)
              SpineLine(
                line.text,
                left: line.boundingBox.left,
                top: line.boundingBox.top,
                right: line.boundingBox.right,
                bottom: line.boundingBox.bottom,
                confidence: line.confidence,
                photoBounds: uprightBoundsOf(
                  SpineBounds(left: line.boundingBox.left, top: line.boundingBox.top, right: line.boundingBox.right, bottom: line.boundingBox.bottom),
                  quarterTurns: quarterTurns,
                  width: prepared.width,
                  height: prepared.height,
                ),
              ),
        ]));
      }
      final japanese = await japaneseRecognizer.processImage(InputImage.fromFilePath(uprightFile.path));
      spines.addAll(spinesFromLines([
        for (final block in japanese.blocks)
          for (final line in block.lines)
            if (_japaneseCharacters.hasMatch(line.text))
              SpineLine(
                line.text,
                left: line.boundingBox.top,
                top: line.boundingBox.left,
                right: line.boundingBox.bottom,
                bottom: line.boundingBox.right,
                confidence: line.confidence,
                photoBounds: SpineBounds(left: line.boundingBox.left, top: line.boundingBox.top, right: line.boundingBox.right, bottom: line.boundingBox.bottom),
              ),
      ]));
      return ShelfReading(
        spines: [
          for (final spine in spines) SpineText(spine.text, confidence: spine.confidence, bounds: spine.bounds?.scaled(prepared.width.toDouble(), prepared.height.toDouble())),
        ],
        photo: uprightJpeg,
        width: prepared.width,
        height: prepared.height,
      );
    } finally {
      await recognizer.close();
      await japaneseRecognizer.close();
      await directory.delete(recursive: true);
    }
  }
}
