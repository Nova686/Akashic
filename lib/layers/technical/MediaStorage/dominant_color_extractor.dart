import 'dart:isolate';
import 'dart:typed_data';

import 'package:image/image.dart' as img;
import 'package:material_color_utilities/material_color_utilities.dart';

const int _noChromaticColor = 0;

Future<int> extractDominantColor(Uint8List imageBytes) => Isolate.run(() => _dominantColorOf(imageBytes));

Future<int> _dominantColorOf(Uint8List imageBytes) async {
  final decoded = img.decodeImage(imageBytes);
  if (decoded == null) {
    throw const FormatException('Unreadable image');
  }
  final sample = decoded.width > 128 || decoded.height > 128 ? img.copyResize(decoded, width: 128, height: 128) : decoded;
  final pixels = [
    for (final pixel in sample) 0xFF000000 | (pixel.r.toInt() << 16) | (pixel.g.toInt() << 8) | pixel.b.toInt(),
  ];
  final quantized = await QuantizerCelebi().quantize(pixels, 16);
  final best = Score.score(quantized.colorToCount, desired: 1, fallbackColorARGB: _noChromaticColor).first;
  if (best != _noChromaticColor) {
    return best;
  }
  return quantized.colorToCount.entries.reduce((first, second) => first.value >= second.value ? first : second).key;
}
