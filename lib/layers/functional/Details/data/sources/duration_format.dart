String? formatTrackLength(Object? milliseconds) {
  if (milliseconds is! int || milliseconds <= 0) {
    return null;
  }
  final totalSeconds = (milliseconds / 1000).round();
  return '${totalSeconds ~/ 60}:${(totalSeconds % 60).toString().padLeft(2, '0')}';
}

String stripHtml(String text) => text
    .replaceAll(RegExp(r'<br\s*/?>', caseSensitive: false), '\n')
    .replaceAll(RegExp(r'<[^>]+>'), '')
    .replaceAll('&amp;', '&')
    .replaceAll('&quot;', '"')
    .replaceAll('&#039;', "'")
    .trim();
