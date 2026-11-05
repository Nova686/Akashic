import 'package:akashic/layers/functional/Collection/domain/use_cases/search_text_normalizer.dart';

const Map<String, Set<String>> _commonWordsByLanguage = {
  'en': {'the', 'and', 'of', 'to', 'is', 'in', 'for', 'with', 'you', 'this', 'are', 'on', 'new', 'now', 'your', 'update', 'we', 'has', 'have', 'from'},
  'fr': {'le', 'la', 'les', 'des', 'de', 'en', 'ce', 'et', 'est', 'un', 'une', 'du', 'pour', 'dans', 'sur', 'avec', 'vous', 'nous', 'pas', 'qui', 'au', 'aux', 'nouveau', 'mise', 'jour', 'jusqu', 'moment', 'soldes'},
  'de': {'der', 'die', 'das', 'und', 'ist', 'mit', 'fur', 'ein', 'eine', 'auf', 'den', 'dem', 'nicht', 'sie', 'wir', 'ihr', 'neue', 'jetzt', 'auch', 'von'},
  'es': {'el', 'los', 'las', 'y', 'es', 'con', 'para', 'una', 'del', 'que', 'por', 'nuevo', 'ahora', 'tu', 'su', 'como', 'mas', 'al'},
  'it': {'il', 'gli', 'della', 'di', 'che', 'con', 'per', 'una', 'nel', 'sono', 'nuovo', 'ora', 'anche', 'questo', 'del', 'alla'},
  'pt': {'os', 'as', 'do', 'da', 'dos', 'das', 'com', 'para', 'uma', 'que', 'em', 'novo', 'agora', 'voce', 'nao', 'mais', 'ao'},
  'nl': {'het', 'een', 'van', 'met', 'voor', 'op', 'zijn', 'nieuwe', 'nu', 'ook', 'niet', 'wij', 'jullie', 'deze', 'naar'},
  'pl': {'i', 'w', 'na', 'z', 'jest', 'nie', 'do', 'sie', 'dla', 'oraz', 'nowa', 'nowy', 'teraz', 'juz'},
};

final Map<String, RegExp> _scripts = {
  'ru': RegExp(r'\p{Script=Cyrillic}', unicode: true),
  'ko': RegExp(r'\p{Script=Hangul}', unicode: true),
  'ja': RegExp(r'[\p{Script=Hiragana}\p{Script=Katakana}]', unicode: true),
  'zh': RegExp(r'\p{Script=Han}', unicode: true),
  'ar': RegExp(r'\p{Script=Arabic}', unicode: true),
  'th': RegExp(r'\p{Script=Thai}', unicode: true),
  'el': RegExp(r'\p{Script=Greek}', unicode: true),
};

final RegExp _letter = RegExp(r'\p{L}', unicode: true);

String? guessTextLanguage(String text) {
  final letters = _letter.allMatches(text).length;
  if (letters == 0) {
    return null;
  }
  final scriptCounts = {for (final MapEntry(key: language, value: script) in _scripts.entries) language: script.allMatches(text).length};
  if (scriptCounts['ja']! > 0) {
    return 'ja';
  }
  final (scriptLanguage, scriptCount) = scriptCounts.entries.fold(('', 0), (best, entry) => entry.value > best.$2 ? (entry.key, entry.value) : best);
  if (scriptCount > letters * 0.3) {
    return scriptLanguage;
  }
  final words = normalizeForSearch(text).split(RegExp(r'[^\p{L}]+', unicode: true));
  final scores = {
    for (final MapEntry(key: language, value: commonWords) in _commonWordsByLanguage.entries) language: words.where(commonWords.contains).length,
  };
  final ranked = scores.entries.toList()..sort((first, second) => second.value.compareTo(first.value));
  final best = ranked.first;
  return best.value >= 2 && best.value > ranked[1].value ? best.key : null;
}
