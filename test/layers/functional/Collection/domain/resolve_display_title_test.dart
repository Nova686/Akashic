import 'package:akashic/layers/functional/Collection/domain/entities/localized_titles.dart';
import 'package:akashic/layers/functional/Collection/domain/use_cases/resolve_display_title.dart';
import 'package:akashic/layers/functional/Settings/domain/entities/preferred_languages.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const preferred = PreferredLanguages(['fr', 'en']);

  test('falls back to original language then untitled', () {
    expect(resolveDisplayTitle(const LocalizedTitles(byLanguage: {'ja': '葬送のフリーレン'}, originalLanguage: 'ja'), preferred), '葬送のフリーレン');
    expect(resolveDisplayTitle(const LocalizedTitles(byLanguage: {'en': 'Frieren', 'fr': 'Frieren'}, originalLanguage: 'ja'), preferred), 'Frieren');
    expect(resolveDisplayTitle(const LocalizedTitles(byLanguage: {}, originalLanguage: null), preferred), isNull);
    expect(resolveDisplayTitle(const LocalizedTitles(byLanguage: {'fr': '  '}, originalLanguage: 'fr'), preferred), isNull);
  });

  test('prefers the first preferred language present', () {
    const titles = LocalizedTitles(byLanguage: {'en': 'The Hobbit', 'fr': 'Le Hobbit'}, originalLanguage: 'en');
    expect(resolveDisplayTitle(titles, preferred), 'Le Hobbit');
    expect(resolveDisplayTitle(titles, const PreferredLanguages(['en', 'fr'])), 'The Hobbit');
  });

  test('a title only in a non preferred, non original language is still shown', () {
    expect(resolveDisplayTitle(const LocalizedTitles(byLanguage: {'de': 'Der Hobbit'}, originalLanguage: 'en'), preferred), 'Der Hobbit');
  });

  test('title variants follow preferred order then original', () {
    const titles = LocalizedTitles(byLanguage: {'ja': '葬送のフリーレン', 'en': 'Frieren', 'fr': 'Frieren FR', 'de': 'Frieren DE'}, originalLanguage: 'ja');
    expect(orderedTitleVariants(titles, preferred).map((variant) => variant.key), ['fr', 'en', 'ja']);
  });
}
