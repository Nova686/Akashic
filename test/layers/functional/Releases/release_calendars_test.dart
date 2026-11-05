import 'dart:convert';

import 'package:akashic/layers/functional/Lookup/domain/entities/card_game.dart';
import 'package:akashic/layers/functional/Collection/domain/use_cases/work_identity.dart';
import 'package:akashic/layers/functional/Releases/data/calendars/artist_album_calendar.dart';
import 'package:akashic/layers/functional/Releases/data/calendars/card_set_calendars.dart';
import 'package:akashic/layers/functional/Releases/data/calendars/next_volume_calendar.dart';
import 'package:akashic/layers/functional/Releases/domain/entities/release_interests.dart';
import 'package:akashic/layers/functional/Releases/domain/entities/upcoming_release.dart';
import 'package:akashic/layers/functional/Releases/domain/use_cases/estimate_next_volume.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

http.Response jsonResponse(Object body) =>
    http.Response.bytes(utf8.encode(jsonEncode(body)), 200, headers: {'content-type': 'application/json; charset=utf-8'});

final DateTime today = DateTime(2026, 10, 28);

void main() {
  test('tcgdex keeps the pokemon sets still to come, with their logo', () async {
    final calendar = TcgdexSetCalendar(MockClient((request) async {
      expect(request.url.path, '/v2/graphql');
      return jsonResponse({
        'data': {
          'sets': [
            {'id': 'me05', 'name': 'Pitch Black', 'releaseDate': '2026-07-17', 'logo': 'https://assets.tcgdex.net/en/me/me05/logo'},
            {'id': 'me06', 'name': 'Next Wave', 'releaseDate': '2026-11-14', 'logo': 'https://assets.tcgdex.net/en/me/me06/logo'},
          ],
        },
      });
    }));
    final releases = await calendar.upcoming(const ReleaseInterests(cardGames: {CardGame.pokemon}), today: today);
    expect(releases, [
      UpcomingRelease(
        sourceKey: 'tcgdex',
        externalId: 'set:me06',
        kind: ReleaseKind.cardSet,
        subject: 'Pokémon',
        title: 'Next Wave',
        releaseDate: DateTime(2026, 11, 14),
        imageUrl: 'https://assets.tcgdex.net/en/me/me06/logo.png',
      ),
    ]);
  });

  test('a game nobody collects is never asked', () async {
    final calendar = RiftcodexSetCalendar(MockClient((request) async => fail('riftcodex should not be called')));
    expect(await calendar.upcoming(const ReleaseInterests(cardGames: {CardGame.magic}), today: today), isEmpty);
  });

  test('scryfall leaves out digital and token sets', () async {
    final calendar = ScryfallSetCalendar(MockClient((request) async {
      expect(request.headers['Accept'], 'application/json');
      return jsonResponse({
          'data': [
            {'code': 'abc', 'name': 'Big Expansion', 'set_type': 'expansion', 'released_at': '2026-11-20', 'digital': false},
            {'code': 'tabc', 'name': 'Big Expansion Tokens', 'set_type': 'token', 'released_at': '2026-11-20', 'digital': false},
            {'code': 'yabc', 'name': 'Alchemy', 'set_type': 'alchemy', 'released_at': '2026-12-01', 'digital': true},
          ],
        });
    }));
    final releases = await calendar.upcoming(const ReleaseInterests(cardGames: {CardGame.magic}), today: today);
    expect(releases.map((release) => release.title), ['Big Expansion']);
  });

  test('ygoprodeck and riftcodex read their own date fields', () async {
    final ygoprodeck = YgoprodeckSetCalendar(MockClient((request) async => jsonResponse([
          {'set_name': 'Future Pack', 'set_code': 'FUPA', 'tcg_date': '2027-01-09', 'set_image': 'http://images.ygoprodeck.com/images/sets/FUPA.jpg'},
          {'set_name': 'Old Pack', 'set_code': 'OLPA', 'tcg_date': '2002-03-08'},
        ])));
    final riftcodex = RiftcodexSetCalendar(MockClient((request) async => jsonResponse({
          'items': [
            {'name': 'Unleashed', 'set_id': 'UNL', 'published_on': '2026-12-05T00:00:00'},
          ],
        })));
    final yugioh = await ygoprodeck.upcoming(const ReleaseInterests(cardGames: {CardGame.yugioh}), today: today);
    final riftbound = await riftcodex.upcoming(const ReleaseInterests(cardGames: {CardGame.riftbound}), today: today);
    expect(yugioh.single.releaseDate, DateTime(2027, 1, 9));
    expect(yugioh.single.imageUrl, 'https://images.ygoprodeck.com/images/sets/FUPA.jpg');
    expect(riftbound.single.releaseDate, DateTime(2026, 12, 5));
  });

  test('the next volume of a series is the one with the right number, still to come', () async {
    final calendar = NextVolumeCalendar(MockClient((request) async {
      expect(request.url.queryParameters['q'], 'intitle:"Frieren" 15');
      return jsonResponse({
        'items': [
          {'id': 'old', 'volumeInfo': {'title': 'Frieren - Tome 14', 'publishedDate': '2026-05-03'}},
          {'id': 'other', 'volumeInfo': {'title': 'Frieren - Tome 16', 'publishedDate': '2027-06-01'}},
          {'id': 'spin', 'volumeInfo': {'title': 'Frieren Artbook - Tome 15', 'publishedDate': '2027-01-01'}},
          {'id': 'next', 'volumeInfo': {'title': 'Frieren - Tome 15', 'publishedDate': '2027-01', 'imageLinks': {'thumbnail': 'http://books.google.com/next.jpg'}}},
        ],
      });
    }), apiKey: 'key');
    final releases = await calendar.upcoming(const ReleaseInterests(series: [FollowedSeries(seriesId: 's', title: 'Frieren', nextVolume: 15)]), today: today);
    expect(releases.single.externalId, 'next');
    expect(releases.single.releaseDate, DateTime(2027, 1, 1));
    expect(releases.single.kind, ReleaseKind.nextVolume);
    expect(releases.single.imageUrl, 'https://books.google.com/next.jpg');
  });

  test('without an announced next volume its month is estimated from the pace of the previous ones', () async {
    final calendar = NextVolumeCalendar(MockClient((request) async => jsonResponse({
          'items': [
            {'id': 't12', 'volumeInfo': {'title': 'Frieren - Tome 12', 'publishedDate': '2025-06-04'}},
            {'id': 't13', 'volumeInfo': {'title': 'Frieren - Tome 13', 'publishedDate': '2025-12-03'}},
            {'id': 't14', 'volumeInfo': {'title': 'Frieren - Tome 14', 'publishedDate': '2026-06-03'}},
            {'id': 'old', 'volumeInfo': {'title': 'Frieren - Tome 2', 'publishedDate': '2017'}},
          ],
        })), apiKey: 'key');
    final release = (await calendar.upcoming(const ReleaseInterests(series: [FollowedSeries(seriesId: 's', title: 'Frieren', nextVolume: 15)]), today: today)).single;
    expect(release.isEstimated, isTrue);
    expect(release.releaseDate, DateTime(2026, 12));
    expect(release.datePrecision, ReleaseDatePrecision.month);
    expect(release.externalId, 'estimate:s:15');
  });

  test('an estimate needs two dated volumes and is dropped once its month is past', () {
    expect(estimateVolumeDate({14: DateTime(2026, 6, 3)}, 15), isNull);
    expect(estimateVolumeDate({1: DateTime(2020), 2: DateTime(2021), 3: DateTime(2022)}, 5), DateTime(2024));
    expect(estimateVolumeDate({1: DateTime(2020), 2: DateTime(2020)}, 3), isNull);
  });

  test('a next volume already out, or known only by its year, is still followed', () async {
    Future<UpcomingRelease> nextOf(String publishedDate) async {
      final calendar = NextVolumeCalendar(MockClient((request) async => jsonResponse({
            'items': [
              {'id': 'frieren-15', 'volumeInfo': {'title': 'Frieren - Tome 15', 'publishedDate': publishedDate}},
            ],
          })), apiKey: 'key');
      return (await calendar.upcoming(const ReleaseInterests(series: [FollowedSeries(seriesId: 's', title: 'Frieren', nextVolume: 15)]), today: today)).single;
    }

    final alreadyOut = await nextOf('2024-03-12');
    expect(alreadyOut.isOutBy(today), isTrue);
    final yearOnly = await nextOf('2027');
    expect(yearOnly.datePrecision, ReleaseDatePrecision.year);
    expect(yearOnly.isOutBy(today), isFalse);
    expect(yearOnly.latestDate, DateTime(2027, 12, 31));
  });

  test('a card set known only by its month stays upcoming until that month is over', () async {
    final calendar = LorcastSetCalendar(MockClient((request) async => jsonResponse({
          'results': [
            {'id': 'set_this_month', 'name': 'This Month', 'released_at': '2026-10'},
            {'id': 'set_next_year', 'name': 'Next Year', 'released_at': '2027'},
          ],
        })));
    final releases = await calendar.upcoming(const ReleaseInterests(cardGames: {CardGame.lorcana}), today: today);
    expect(releases.map((release) => release.title), ['This Month', 'Next Year']);
  });

  test('new albums of a followed artist are listed, recent or announced, except the ones owned and singles', () async {
    final calendar = ArtistAlbumCalendar(MockClient((request) async {
      if (request.url.path == '/search/artist') {
        return jsonResponse({
          'data': [
            {'id': 72709, 'name': 'Dance Gavin Dance'},
          ],
        });
      }
      expect(request.url.path, '/artist/72709/albums');
      return jsonResponse({
        'data': [
          {'id': 1, 'title': 'Afterburner (Deluxe Edition)', 'release_date': '2026-10-01', 'record_type': 'album'},
          {'id': 2, 'title': 'Tree City Sessions 4', 'release_date': '2026-10-10', 'record_type': 'album'},
          {'id': 3, 'title': 'Need Money', 'release_date': '2026-10-12', 'record_type': 'single'},
          {'id': 4, 'title': 'Old Record', 'release_date': '2019-03-01', 'record_type': 'album'},
          {'id': 5, 'title': 'Next One', 'release_date': '2027-02-01', 'record_type': 'album'},
        ],
      });
    }));
    final releases = await calendar.upcoming(
      ReleaseInterests(artists: const ['Dance Gavin Dance'], ownedTitles: {titleIdentityOf('Afterburner')}),
      today: today,
    );
    expect(releases.map((release) => release.title), ['Tree City Sessions 4', 'Next One']);
    expect(releases.first.kind, ReleaseKind.album);
    expect(releases.first.subject, 'Dance Gavin Dance');
  });
}
