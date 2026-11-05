import 'package:akashic/layers/functional/Collection/domain/use_cases/search_text_normalizer.dart';

class CoverTextLine {
  const CoverTextLine(this.text, {required this.height});

  final String text;
  final double height;
}

const int _maximumLineLength = 60;
const int _keptLines = 4;
final RegExp _japaneseCharacters = RegExp(r'[\p{Script=Hiragana}\p{Script=Katakana}\p{Script=Han}]', unicode: true);

List<String> prominentCoverLines(List<CoverTextLine> recognizedLines) {
  final candidates = <CoverTextLine>[];
  final seen = <String>{};
  for (final line in recognizedLines) {
    final text = line.text.trim();
    final letters = RegExp(r'\p{L}', unicode: true).allMatches(text).length;
    final digits = RegExp(r'\d').allMatches(text).length;
    final minimumLength = _japaneseCharacters.hasMatch(text) ? 2 : 3;
    if (text.length < minimumLength || text.length > _maximumLineLength || letters == 0 || digits > letters) {
      continue;
    }
    if (seen.add(normalizeForSearch(text))) {
      candidates.add(CoverTextLine(text, height: line.height));
    }
  }
  candidates.sort((first, second) {
    final bySize = second.height.compareTo(first.height);
    return bySize != 0 ? bySize : second.text.length.compareTo(first.text.length);
  });
  return [for (final line in candidates.take(_keptLines)) line.text];
}

Set<String> searchWordsOf(String text) => {
      for (final word in normalizeForSearch(text).split(RegExp(r'[^\p{L}\p{N}]+', unicode: true)))
        if (word.length >= 2) word,
    };
