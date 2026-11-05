import 'dart:typed_data';

import 'package:akashic/layers/technical/MediaStorage/dominant_color_extractor.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image/image.dart' as img;

Uint8List pngWithShare({required img.Color main, required img.Color rest, required double mainShare}) {
  final image = img.Image(width: 64, height: 64);
  final mainRows = (64 * mainShare).round();
  for (var y = 0; y < 64; y++) {
    for (var x = 0; x < 64; x++) {
      image.setPixel(x, y, y < mainRows ? main : rest);
    }
  }
  return img.encodePng(image);
}

void main() {
  test('a mostly red image gives a red spine', () async {
    final bytes = pngWithShare(main: img.ColorRgb8(0xC2, 0x41, 0x2D), rest: img.ColorRgb8(255, 255, 255), mainShare: 0.8);
    final color = Color(await extractDominantColor(bytes));
    expect(color.r, greaterThan(color.b));
    expect(color.r, greaterThan(0.5));
  });

  test('a black and white sleeve gives a dark neutral, not the fallback blue', () async {
    final bytes = pngWithShare(main: img.ColorRgb8(5, 5, 5), rest: img.ColorRgb8(250, 250, 250), mainShare: 0.9);
    final color = Color(await extractDominantColor(bytes));
    expect(color.computeLuminance(), lessThan(0.1));
    expect((color.b - color.r).abs(), lessThan(0.05));
  });
}
