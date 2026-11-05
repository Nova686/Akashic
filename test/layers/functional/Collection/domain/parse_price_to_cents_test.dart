import 'package:akashic/layers/functional/Collection/domain/use_cases/parse_price_to_cents.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('french and english prices parse to cents', () {
    expect(parsePriceToCents('28,50'), 2850);
    expect(parsePriceToCents('28.50'), 2850);
    expect(parsePriceToCents('28,5'), 2850);
    expect(parsePriceToCents('28'), 2800);
    expect(parsePriceToCents('1 234,56'), 123456);
    expect(parsePriceToCents('1 234,56'), 123456);
    expect(parsePriceToCents('28 €'), 2800);
    expect(parsePriceToCents(''), isNull);
    expect(parsePriceToCents('   '), isNull);
    expect(() => parsePriceToCents('abc'), throwsA(isA<InvalidPrice>()));
    expect(() => parsePriceToCents('12,345'), throwsA(isA<InvalidPrice>()));
  });
}
