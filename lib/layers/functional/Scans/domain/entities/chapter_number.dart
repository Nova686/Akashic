const int maximumExpandedRange = 50;

List<double> chaptersIn(String raw) {
  final range = RegExp(r'(\d+(?:\.\d+)?)\s*[-–~]\s*(\d+(?:\.\d+)?)').firstMatch(raw);
  if (range != null) {
    final first = double.parse(range.group(1)!);
    final last = double.parse(range.group(2)!);
    if (last < first || last - first > maximumExpandedRange) {
      return [last];
    }
    return [
      first,
      for (var whole = first.floorToDouble() + 1; whole <= last; whole++) whole,
      if (last != last.floorToDouble()) last,
    ];
  }
  final single = RegExp(r'\d+(?:\.\d+)?').firstMatch(raw);
  return single == null ? const [] : [double.parse(single.group(0)!)];
}

String formatChapter(double chapter) => chapter == chapter.truncateToDouble() ? chapter.toInt().toString() : chapter.toString();
