class InvalidPrice implements Exception {
  const InvalidPrice(this.input);

  final String input;
}

final RegExp _priceShape = RegExp(r'^(\d+)(?:[.,](\d{1,2}))?$');

int? parsePriceToCents(String input) {
  final compact = input.replaceAll(RegExp(r'[\s  €$£]'), '');
  if (compact.isEmpty) {
    return null;
  }
  final match = _priceShape.firstMatch(compact);
  if (match == null) {
    throw InvalidPrice(input);
  }
  final units = int.parse(match.group(1)!);
  final decimals = (match.group(2) ?? '0').padRight(2, '0');
  return units * 100 + int.parse(decimals);
}
