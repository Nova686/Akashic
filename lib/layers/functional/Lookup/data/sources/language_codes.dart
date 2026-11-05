const Map<String, String> _twoLetterCodes = {
  'eng': 'en',
  'fre': 'fr',
  'fra': 'fr',
  'jpn': 'ja',
  'ger': 'de',
  'deu': 'de',
  'spa': 'es',
  'ita': 'it',
  'por': 'pt',
  'kor': 'ko',
  'chi': 'zh',
  'zho': 'zh',
};

String twoLetterLanguage(String? threeLetterCode, {String fallback = 'en'}) => _twoLetterCodes[threeLetterCode?.toLowerCase()] ?? fallback;
