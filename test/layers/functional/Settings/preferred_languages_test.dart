import 'package:akashic/layers/functional/Settings/domain/entities/preferred_languages.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('add ignores a duplicate', () {
    expect(PreferredLanguages.defaults.add('fr').codes, ['fr', 'en']);
    expect(PreferredLanguages.defaults.add('ja').codes, ['fr', 'en', 'ja']);
  });

  test('move reorders', () {
    expect(const PreferredLanguages(['fr', 'en', 'ja']).move(2, 0).codes, ['ja', 'fr', 'en']);
  });

  test('removing the last language throws LastPreferredLanguage', () {
    expect(PreferredLanguages.defaults.remove('en').codes, ['fr']);
    expect(() => const PreferredLanguages(['fr']).remove('fr'), throwsA(isA<LastPreferredLanguage>()));
  });
}
