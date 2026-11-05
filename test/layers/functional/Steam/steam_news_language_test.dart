import 'package:akashic/layers/functional/Settings/domain/entities/preferred_languages.dart';
import 'package:akashic/layers/functional/Steam/domain/entities/steam_store_page.dart';
import 'package:akashic/layers/functional/Steam/domain/use_cases/guess_text_language.dart';
import 'package:akashic/layers/functional/Steam/domain/use_cases/load_steam_store_sheet.dart';
import 'package:flutter_test/flutter_test.dart';

import '../Collection/collection_harness.dart';
import 'steam_store_test.dart';

SteamNews newsOf(String title, String snippet, int day) => SteamNews(title: title, url: 'https://store.steampowered.com/news/$day', publishedAt: DateTime.utc(2026, 10, day), snippet: snippet);

class MultilingualStore extends FixedStore {
  @override
  Future<List<SteamNews>> news(String appId) async => [
        newsOf('Update 1.011 is live', 'This is not a drill. Keepers, wake up! Update 1.011 is here, and we have some exciting changes to share.', 30),
        newsOf('Graveyard Keeper 2 и другие проекты помогли издательству tinyBuild', 'Издательство tinyBuild за последние три месяца получило свыше 4 млн добавлений игр', 20),
        newsOf('Graveyard Keeper 2 : la mise à jour est disponible', 'Nous avons ajouté de nouvelles quêtes et corrigé les sauvegardes pour tous les joueurs.', 19),
        newsOf('《守墓人2》更新公告', '本次更新修复了多个问题', 18),
        newsOf('Neues Update ist jetzt verfügbar', 'Wir haben die Speicherstände für alle Spieler repariert und das ist neu.', 17),
        newsOf('Patch 1.010', 'Bug fixes and stability improvements for the new update.', 16),
        newsOf('Patch 1.009', 'More fixes for the save system and the new quests.', 15),
      ];
}

void main() {
  test('the language of a text is guessed from its script, then from its common words', () {
    expect(guessTextLanguage('Рекордный бюджет Graveyard Keeper 2 поставил студию'), 'ru');
    expect(guessTextLanguage('《守墓人2》更新公告'), 'zh');
    expect(guessTextLanguage('ゲームのアップデート'), 'ja');
    expect(guessTextLanguage('업데이트 안내'), 'ko');
    expect(guessTextLanguage('This is the new update for all of you'), 'en');
    expect(guessTextLanguage('La mise à jour est disponible pour les joueurs'), 'fr');
    expect(guessTextLanguage('Patch 1.010'), isNull);
    expect(guessTextLanguage("Soldes de printemps : jusqu'à -50 % en ce moment"), 'fr');
    expect(guessTextLanguage('De nieuwe update is nu beschikbaar voor iedereen met deze versie'), 'nl');
  });

  test('only the news written in the preferred title languages are kept, three at most', () async {
    final harness = CollectionHarness();
    addTearDown(harness.database.close);
    final sheet = await LoadSteamStoreSheet(MultilingualStore(), harness.collection, preferredLanguages: () async => const PreferredLanguages(['fr', 'en']))('1145360');
    expect(sheet.news.map((news) => news.publishedAt.day), [30, 19, 16]);
  });
}
