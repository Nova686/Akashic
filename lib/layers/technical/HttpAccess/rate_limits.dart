import 'dart:io';

const String blockedLocallyHeader = 'x-akashic-blocked';

abstract interface class RateLimitRecorder {
  DateTime? blockedUntil(String apiFamily);
  Future<void> recordBlock(String apiFamily, {required DateTime blockedAt, required DateTime retryAt});
}

String apiFamilyOf(String sourceKey) => sourceKey.split('-').first;

const Duration _shortestPause = Duration(seconds: 5);
const Map<String, Duration> _defaultPauses = {
  'discogs': Duration(minutes: 1),
  'anilist': Duration(minutes: 1),
  'googlebooks': Duration(minutes: 1),
  'tmdb': Duration(seconds: 10),
  'igdb': Duration(seconds: 5),
  'scryfall': Duration(minutes: 1),
  'tcgdex': Duration(minutes: 1),
  'ygoprodeck': Duration(hours: 1),
  'lorcast': Duration(minutes: 1),
  'riftcodex': Duration(minutes: 1),
  'musicbrainz': Duration(minutes: 1),
  'openlibrary': Duration(minutes: 1),
  'jikan': Duration(minutes: 1),
  'tvmaze': Duration(seconds: 10),
  'upcitemdb': Duration(hours: 1),
  'boardgamegeek': Duration(minutes: 1),
  'comicvine': Duration(minutes: 15),
  'deezer': Duration(seconds: 10),
  'optcg': Duration(minutes: 1),
  'mtgjson': Duration(minutes: 5),
  'mangadex': Duration(minutes: 1),
  'wikidata': Duration(minutes: 1),
  'rebrickable': Duration(minutes: 5),
  'amiiboapi': Duration(minutes: 1),
  'mangaupdates': Duration(minutes: 1),
  'bnf': Duration(minutes: 1),
};

final RegExp _dailyQuota = RegExp(r'per day|daily|quotidien', caseSensitive: false);

DateTime retryAtFor({required String apiFamily, required Map<String, String> headers, required String body, required DateTime now}) {
  final retryAfter = headers['retry-after']?.trim();
  if (retryAfter != null && retryAfter.isNotEmpty) {
    final seconds = int.tryParse(retryAfter);
    if (seconds != null) {
      return now.add(Duration(seconds: seconds < _shortestPause.inSeconds ? _shortestPause.inSeconds : seconds));
    }
    try {
      final date = HttpDate.parse(retryAfter);
      if (date.isAfter(now)) {
        return date.toLocal();
      }
    } on HttpException {
      return now.add(_defaultPauses[apiFamily] ?? const Duration(minutes: 1));
    }
  }
  if (_dailyQuota.hasMatch(body)) {
    return nextPacificMidnight(now);
  }
  return now.add(_defaultPauses[apiFamily] ?? const Duration(minutes: 1));
}

DateTime nextPacificMidnight(DateTime now) {
  final utc = now.toUtc();
  var reset = DateTime.utc(utc.year, utc.month, utc.day, 8);
  if (!reset.isAfter(utc)) {
    reset = reset.add(const Duration(days: 1));
  }
  return reset.toLocal();
}
