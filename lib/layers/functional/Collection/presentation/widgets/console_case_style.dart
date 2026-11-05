import 'package:akashic/layers/functional/Collection/domain/use_cases/search_text_normalizer.dart';
import 'package:flutter/painting.dart';

enum ConsoleCaseStyle {
  nintendoSwitch(width: 8, height: 54, body: Color(0xFFE60012), band: Color(0xFFFFFFFF), bandHeight: 10),
  playStation5(width: 10, height: 58, body: Color(0xFFF2F2F4), band: Color(0xFF00439C), bandHeight: 12),
  playStation4(width: 10, height: 58, body: Color(0xFF0A3D91), band: null, bandHeight: 0),
  playStation2(width: 10, height: 64, body: Color(0xFF111111), band: Color(0xFF2B2B6B), bandHeight: 9),
  playStation1(width: 14, height: 50, body: Color(0xFF1A1A1A), band: null, bandHeight: 0),
  xbox(width: 10, height: 58, body: Color(0xFF1E1E1E), band: Color(0xFF107C10), bandHeight: 12),
  gameCube(width: 11, height: 54, body: Color(0xFF4B3B8F), band: null, bandHeight: 0),
  wii(width: 10, height: 58, body: Color(0xFFF5F5F5), band: Color(0xFF9BD7F5), bandHeight: 6),
  megaDrive(width: 12, height: 56, body: Color(0xFF111111), band: Color(0xFFC0392B), bandHeight: 10),
  handheld(width: 9, height: 44, body: Color(0xFFF5F5F5), band: Color(0xFFD0D0D8), bandHeight: 6),
  cardboardBox(width: 18, height: 46, body: Color(0xFFBDBDC7), band: null, bandHeight: 0),
  cartridge(width: 22, height: 26, body: Color(0xFF7D7D86), band: null, bandHeight: 0),
  generic(width: 10, height: 54, body: Color(0xFF6E6896), band: null, bandHeight: 0);

  const ConsoleCaseStyle({required this.width, required this.height, required this.body, required this.band, required this.bandHeight});

  final double width;
  final double height;
  final Color body;
  final Color? band;
  final double bandHeight;

  bool get isCartridge => this == ConsoleCaseStyle.cartridge;

  bool get isCardboardBox => this == ConsoleCaseStyle.cardboardBox;
}

const List<(String, ConsoleCaseStyle)> _platformPatterns = [
  ('switch', ConsoleCaseStyle.nintendoSwitch),
  ('playstation 5', ConsoleCaseStyle.playStation5),
  ('ps5', ConsoleCaseStyle.playStation5),
  ('playstation 4', ConsoleCaseStyle.playStation4),
  ('ps4', ConsoleCaseStyle.playStation4),
  ('playstation 3', ConsoleCaseStyle.playStation4),
  ('ps3', ConsoleCaseStyle.playStation4),
  ('playstation 2', ConsoleCaseStyle.playStation2),
  ('ps2', ConsoleCaseStyle.playStation2),
  ('playstation vita', ConsoleCaseStyle.handheld),
  ('playstation portable', ConsoleCaseStyle.handheld),
  ('psp', ConsoleCaseStyle.handheld),
  ('playstation', ConsoleCaseStyle.playStation1),
  ('xbox', ConsoleCaseStyle.xbox),
  ('gamecube', ConsoleCaseStyle.gameCube),
  ('wii', ConsoleCaseStyle.wii),
  ('mega drive', ConsoleCaseStyle.megaDrive),
  ('genesis', ConsoleCaseStyle.megaDrive),
  ('game boy', ConsoleCaseStyle.cartridge),
  ('3ds', ConsoleCaseStyle.handheld),
  ('nintendo ds', ConsoleCaseStyle.handheld),
  ('super nintendo', ConsoleCaseStyle.cardboardBox),
  ('snes', ConsoleCaseStyle.cardboardBox),
  ('nintendo 64', ConsoleCaseStyle.cardboardBox),
  ('nintendo entertainment system', ConsoleCaseStyle.cardboardBox),
  ('nes', ConsoleCaseStyle.cardboardBox),
];

ConsoleCaseStyle consoleCaseStyleFor(String? platform) {
  final normalized = normalizeForSearch(platform ?? '');
  if (normalized.isEmpty) {
    return ConsoleCaseStyle.generic;
  }
  for (final (pattern, style) in _platformPatterns) {
    if (pattern == 'nes' ? RegExp(r'\bnes\b').hasMatch(normalized) : normalized.contains(pattern)) {
      return style;
    }
  }
  return ConsoleCaseStyle.generic;
}
