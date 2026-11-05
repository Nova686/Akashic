String? normalizeBarcode(String raw) {
  final compact = raw.toUpperCase().replaceAll(RegExp('[^0-9X]'), '');
  if (compact.length == 10 && RegExp(r'^\d{9}[\dX]$').hasMatch(compact) && _isValidIsbn10(compact)) {
    return _isbn10To13(compact);
  }
  if (compact.contains('X')) {
    return null;
  }
  return switch (compact.length) {
    12 => '0$compact',
    13 => compact,
    8 => compact,
    _ => null,
  };
}

bool _isValidIsbn10(String isbn10) {
  var sum = 0;
  for (var index = 0; index < 10; index++) {
    final character = isbn10[index];
    final value = character == 'X' ? 10 : int.parse(character);
    sum += value * (10 - index);
  }
  return sum % 11 == 0;
}

String _isbn10To13(String isbn10) {
  final body = '978${isbn10.substring(0, 9)}';
  var sum = 0;
  for (var index = 0; index < 12; index++) {
    sum += int.parse(body[index]) * (index.isEven ? 1 : 3);
  }
  return '$body${(10 - sum % 10) % 10}';
}

List<String> barcodeStorageForms(String normalized) => [normalized, if (normalized.length == 13 && normalized.startsWith('0')) normalized.substring(1)];
