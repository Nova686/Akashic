import 'package:akashic/layers/functional/Collection/domain/use_cases/search_text_normalizer.dart';

class SpineBounds {
  const SpineBounds({required this.left, required this.top, required this.right, required this.bottom});

  final double left;
  final double top;
  final double right;
  final double bottom;

  SpineBounds union(SpineBounds other) => SpineBounds(
        left: left < other.left ? left : other.left,
        top: top < other.top ? top : other.top,
        right: right > other.right ? right : other.right,
        bottom: bottom > other.bottom ? bottom : other.bottom,
      );

  SpineBounds scaled(double width, double height) => SpineBounds(left: left / width, top: top / height, right: right / width, bottom: bottom / height);
}

class SpineText {
  const SpineText(this.text, {this.confidence, this.bounds});

  final String text;
  final double? confidence;
  final SpineBounds? bounds;
}

class ShelfReading {
  const ShelfReading({required this.spines, this.photo, this.width = 0, this.height = 0});

  final List<SpineText> spines;
  final List<int>? photo;
  final int width;
  final int height;
}

class SpineLine {
  const SpineLine(this.text, {required this.left, required this.top, required this.right, required this.bottom, this.confidence, this.photoBounds});

  final String text;
  final double left;
  final double top;
  final double right;
  final double bottom;
  final double? confidence;
  final SpineBounds? photoBounds;

  SpineBounds get boundsOnPhoto => photoBounds ?? SpineBounds(left: left, top: top, right: right, bottom: bottom);

  double get height => bottom - top;
}

const double _sameSpineOverlap = 0.5;
const double _sameSpineHeightRatio = 2.5;
const double _sameSpineGapInHeights = 12;

bool _readAlong(List<SpineLine> spine, SpineLine line) {
  final top = spine.map((member) => member.top).reduce((first, second) => first < second ? first : second);
  final bottom = spine.map((member) => member.bottom).reduce((first, second) => first > second ? first : second);
  final tallest = spine.map((member) => member.height).reduce((first, second) => first > second ? first : second);
  final overlap = (line.bottom < bottom ? line.bottom : bottom) - (line.top > top ? line.top : top);
  final shorter = line.height < tallest ? line.height : tallest;
  final taller = line.height > tallest ? line.height : tallest;
  return shorter > 0 && overlap >= shorter * _sameSpineOverlap && taller <= shorter * _sameSpineHeightRatio;
}

List<SpineText> spinesFromLines(List<SpineLine> lines) {
  final spines = <List<SpineLine>>[];
  for (final line in [...lines]..sort((first, second) => (first.top + first.bottom).compareTo(second.top + second.bottom))) {
    if (line.height <= 0 || line.text.trim().isEmpty) {
      continue;
    }
    final spine = spines.where((candidate) => _readAlong(candidate, line)).firstOrNull;
    if (spine == null) {
      spines.add([line]);
    } else {
      spine.add(line);
    }
  }
  return [
    for (final spine in spines)
      for (final segment in _segmentsAlong(spine))
        SpineText(
          segment.map((line) => line.text.trim()).join(' '),
          confidence: switch ([for (final line in segment) ?line.confidence]) {
            final confidences when confidences.isEmpty => null,
            final confidences => confidences.reduce((sum, value) => sum + value) / confidences.length,
          },
          bounds: segment.map((line) => line.boundsOnPhoto).reduce((first, second) => first.union(second)),
        ),
  ];
}

List<List<SpineLine>> _segmentsAlong(List<SpineLine> spine) {
  final ordered = [...spine]..sort((first, second) => first.left.compareTo(second.left));
  final segments = <List<SpineLine>>[[ordered.first]];
  for (final line in ordered.skip(1)) {
    final previous = segments.last.last;
    final lineHeight = previous.height > line.height ? previous.height : line.height;
    if (line.left - previous.right > lineHeight * _sameSpineGapInHeights) {
      segments.add([line]);
    } else {
      segments.last.add(line);
    }
  }
  return segments;
}

final RegExp _volumeMarker = RegExp(r'(?:^|\s)(?:t|tome|vol|volume|n|no)\.?\s*0*(\d{1,3})(?=\s|$)');
final RegExp _standaloneNumber = RegExp(r'(?:^|\s)0*(\d{1,3})(?=\s|$)');
final RegExp _ageRating = RegExp(r'(?:pegi|cero|usk|esrb)\s*\d{1,2}');

int? spineVolumeNumberOf(String spineText) {
  final normalized = normalizeForSearch(spineText).replaceAll(RegExp(r'[^\p{L}\p{N}]+', unicode: true), ' ').replaceAll(_ageRating, ' ').trim();
  final marked = _volumeMarker.firstMatch(normalized);
  final number = int.tryParse((marked ?? _standaloneNumber.firstMatch(normalized))?.group(1) ?? '');
  return number == null || number == 0 ? null : number;
}

const Set<String> _spineNoiseWords = {
  'tome', 'vol', 'volume', 'pegi', 'cero', 'usk', 'esrb',
  'nintendo', 'switch', 'playstation', 'ps1', 'ps2', 'ps3', 'ps4', 'ps5', 'psp', 'vita', 'xbox', 'wii', '3ds', 'gamecube', 'sega', 'dreamcast',
  'glenat', 'kana', 'pika', 'kioon', 'kurokawa', 'delcourt', 'tonkam', 'soleil', 'panini', 'kaze', 'akata', 'mangetsu', 'meian', 'ototo', 'kazoku', 'noeve', 'vega', 'dupuis', 'casterman', 'dargaud', 'manga', 'edition', 'editions', 'collector', 'deluxe', 'perfect',
};

String spineSearchQueryOf(String spineText) {
  final words = normalizeForSearch(spineText).replaceAll(_ageRating, ' ').split(RegExp(r'[^\p{L}\p{N}]+', unicode: true));
  return [
    for (final word in words)
      if (word.isNotEmpty && !_spineNoiseWords.contains(word) && !RegExp(r'^\d+$').hasMatch(word) && !RegExp(r'^t\d{1,3}$').hasMatch(word)) word,
  ].join(' ');
}

const int maximumShelfSpines = 24;
const double minimumSpineConfidence = 0.5;
const int _minimumSpineLength = 3;
const int _maximumSpineLength = 120;

List<String> spineTitlesOf(List<SpineText> readings) => [for (final reading in spineReadingsOf(readings)) reading.text];

List<SpineText> spineReadingsOf(List<SpineText> readings) {
  final kept = <SpineText>[];
  final normalizedKept = <String>[];
  final candidates = [
    for (final reading in readings)
      if (reading.confidence == null || reading.confidence! >= minimumSpineConfidence) SpineText(reading.text.replaceAll(RegExp(r'\s+'), ' ').trim(), confidence: reading.confidence, bounds: reading.bounds),
  ]..sort((first, second) => second.text.length.compareTo(first.text.length));
  for (final candidate in candidates) {
    final text = candidate.text;
    final letters = RegExp(r'\p{L}', unicode: true).allMatches(text).length;
    final words = RegExp(r'\p{L}{3,}|[\p{Script=Hiragana}\p{Script=Katakana}\p{Script=Han}]{2,}', unicode: true).allMatches(text).length;
    if (text.length < _minimumSpineLength || text.length > _maximumSpineLength || words == 0 || letters < text.replaceAll(' ', '').length * 0.6) {
      continue;
    }
    final normalized = normalizeForSearch(text);
    if (normalized.isEmpty || normalizedKept.any((existing) => existing.contains(normalized))) {
      continue;
    }
    kept.add(candidate);
    normalizedKept.add(normalized);
    if (kept.length == maximumShelfSpines) {
      break;
    }
  }
  return kept;
}

const Map<String, String> _ocrLookalikes = {'0': 'o', '1': 'l', '5': 's', '8': 'b', '|': 'l'};

String _ocrNormalized(String word) => RegExp(r'\p{L}', unicode: true).hasMatch(word) ? word.split('').map((character) => _ocrLookalikes[character] ?? character).join() : word;

int _editDistance(String first, String second) {
  final distances = List.generate(first.length + 1, (row) => List<int>.generate(second.length + 1, (column) => row == 0 ? column : (column == 0 ? row : 0)));
  for (var row = 1; row <= first.length; row++) {
    for (var column = 1; column <= second.length; column++) {
      final cost = first[row - 1] == second[column - 1] ? 0 : 1;
      var best = [distances[row - 1][column] + 1, distances[row][column - 1] + 1, distances[row - 1][column - 1] + cost].reduce((smallest, value) => value < smallest ? value : smallest);
      if (row > 1 && column > 1 && first[row - 1] == second[column - 2] && first[row - 2] == second[column - 1]) {
        final transposition = distances[row - 2][column - 2] + 1;
        best = transposition < best ? transposition : best;
      }
      distances[row][column] = best;
    }
  }
  return distances[first.length][second.length];
}

bool wordsResemble(String read, String expected) {
  if (read == expected) {
    return true;
  }
  final normalizedRead = _ocrNormalized(read);
  final normalizedExpected = _ocrNormalized(expected);
  if (normalizedRead == normalizedExpected) {
    return true;
  }
  final shortest = normalizedRead.length < normalizedExpected.length ? normalizedRead.length : normalizedExpected.length;
  if (shortest < 5 || (normalizedRead.length - normalizedExpected.length).abs() > 2) {
    return false;
  }
  return _editDistance(normalizedRead, normalizedExpected) <= (shortest >= 8 ? 2 : 1);
}

bool hasWordLike(Set<String> readWords, String expected) => readWords.contains(expected) || readWords.any((read) => wordsResemble(read, expected));
