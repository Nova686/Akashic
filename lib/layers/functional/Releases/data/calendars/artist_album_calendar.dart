import 'package:akashic/layers/functional/Collection/domain/use_cases/search_text_normalizer.dart';
import 'package:akashic/layers/functional/Collection/domain/use_cases/work_identity.dart';
import 'package:akashic/layers/functional/Lookup/data/sources/json_fields.dart';
import 'package:akashic/layers/functional/Lookup/data/sources/source_http.dart';
import 'package:akashic/layers/functional/Releases/data/calendars/release_date.dart';
import 'package:akashic/layers/functional/Releases/domain/entities/release_interests.dart';
import 'package:akashic/layers/functional/Releases/domain/entities/upcoming_release.dart';
import 'package:akashic/layers/functional/Releases/domain/gateways/release_calendar.dart';
import 'package:akashic/layers/functional/Releases/data/calendars/keeping_what_succeeded.dart';
import 'package:http/http.dart' as http;

class ArtistAlbumCalendar implements ReleaseCalendar {
  ArtistAlbumCalendar(this._client);

  static const String sourceKey = 'deezer';
  static const Set<String> keptRecordTypes = {'album', 'ep'};
  static final RegExp _editionSuffix = RegExp(r'\s*[\(\[].*[\)\]]\s*$');

  final http.Client _client;

  @override
  String get key => 'deezer-releases';

  @override
  bool get isConfigured => true;

  @override
  Future<List<UpcomingRelease>> upcoming(ReleaseInterests interests, {required DateTime today}) async {
    final since = today.subtract(recentReleaseWindow);
    return keepingWhatSucceeded([
      for (final artist in interests.artists)
        () async {
          final releases = <UpcomingRelease>[];
          final artistId = await _artistIdOf(artist);
          if (artistId == null) {
            return releases;
          }
          final albums = mapOf(await sourceGetJson(_client, Uri.https('api.deezer.com', '/artist/$artistId/albums', {'limit': '100'}), sourceKey: key));
          for (final album in listOf(albums['data']).map(mapOf)) {
            final albumId = album['id'];
            final title = textOf(album['title']);
            final releaseDate = releaseDateOf(album['release_date']);
            if (albumId is! int || title == null || releaseDate == null || !keptRecordTypes.contains(album['record_type'])) {
              continue;
            }
            final release = UpcomingRelease(
              sourceKey: sourceKey,
              externalId: 'album:$albumId',
              kind: ReleaseKind.album,
              subject: artist,
              title: title,
              releaseDate: releaseDate.date,
              datePrecision: releaseDate.precision,
              imageUrl: textOf(album['cover_xl']) ?? textOf(album['cover_big']),
            );
            final owned = interests.ownedTitles.contains(titleIdentityOf(title)) || interests.ownedTitles.contains(titleIdentityOf(title.replaceAll(_editionSuffix, '')));
            if (!owned && !release.isOutBy(since)) {
              releases.add(release);
            }
          }
          return releases;
        },
    ]);
  }

  Future<int?> _artistIdOf(String artist) async {
    final json = mapOf(await sourceGetJson(_client, Uri.https('api.deezer.com', '/search/artist', {'q': artist, 'limit': '5'}), sourceKey: key));
    final wanted = normalizeForSearch(artist);
    for (final candidate in listOf(json['data']).map(mapOf)) {
      if (candidate['id'] case final int candidateId when normalizeForSearch(textOf(candidate['name']) ?? '') == wanted) {
        return candidateId;
      }
    }
    return null;
  }
}
