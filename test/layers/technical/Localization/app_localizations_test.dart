import 'package:akashic/layers/technical/Localization/app_localizations.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('french and english resolve different strings', () async {
    final fr = await AppLocalizations.delegate.load(const Locale('fr'));
    final en = await AppLocalizations.delegate.load(const Locale('en'));
    expect(fr.navCheck, "Je l'ai ?");
    expect(en.navCheck, 'Got it?');
    expect(fr.conditionMissing, 'Manquant');
    expect(en.untitled, 'Untitled');
    expect(fr.objectsInCategories(1284, 7), '1 284 objets dans 7 catégories');
  });

  test('supported locales are english and french', () {
    expect(AppLocalizations.supportedLocales, containsAll(const [Locale('en'), Locale('fr')]));
  });
}
