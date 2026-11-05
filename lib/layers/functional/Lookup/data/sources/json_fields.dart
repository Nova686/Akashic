String? textOf(Object? value) {
  if (value is! String) {
    return null;
  }
  final trimmed = value.trim();
  return trimmed.isEmpty ? null : trimmed;
}

int? yearOf(Object? value) {
  if (value is int) {
    return value;
  }
  final text = textOf(value);
  if (text == null || text.length < 4) {
    return null;
  }
  return int.tryParse(text.substring(0, 4));
}

Map<String, Object?> mapOf(Object? value) => value is Map<String, Object?> ? value : const {};

List<Object?> listOf(Object? value) => value is List<Object?> ? value : const [];

String? firstTextOf(Object? value) {
  for (final entry in listOf(value)) {
    final text = textOf(entry);
    if (text != null) {
      return text;
    }
  }
  return null;
}

String? httpsUrl(Object? value) => textOf(value)?.replaceFirst(RegExp('^http://'), 'https://');

int? centsOf(Object? amount) {
  final value = switch (amount) {
    final num number => number.toDouble(),
    final String text => double.tryParse(text.replaceAll(',', '.')),
    _ => null,
  };
  return value == null || value <= 0 ? null : (value * 100).round();
}
