import 'dart:convert';

import 'package:akashic/layers/functional/Collection/domain/entities/collection_item.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/localized_titles.dart';
import 'package:akashic/layers/functional/Details/data/sources/anilist_details_source.dart';
import 'package:akashic/layers/functional/Details/data/sources/discogs_details_source.dart';
import 'package:akashic/layers/functional/Details/data/sources/google_books_details_source.dart';
import 'package:akashic/layers/functional/Details/domain/entities/item_details.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

import '../Lookup/data/fixture_client.dart';

const kindOfBlue = CollectionItem(
  id: 'kob',
  categoryId: 'jazz',
  titles: LocalizedTitles(byLanguage: {'en': 'Kind of Blue'}),
  sourceKey: 'discogs',
  externalWorkId: 'master:5460',
);

MockClient discogsClient(List<http.Request> requests) => MockClient((request) async {
      requests.add(request);
      final body = request.url.path.startsWith('/masters/') ? fixture('discogs_master.json') : fixture('discogs_release.json');
      return http.Response.bytes(utf8.encode(body), 200, headers: {'content-type': 'application/json; charset=utf-8'});
    });

void main() {
  test('discogs details give the tracks of the album and the label of the pressing', () async {
    final requests = <http.Request>[];
    final sections = await DiscogsDetailsSource(discogsClient(requests), token: 'secret').fetch(kindOfBlue, languageCode: 'fr', editionId: '6276183');
    final tracks = sections.whereType<TrackListSection>().single.tracks;
    expect(tracks.first, const DetailTrack(position: 'A1', title: 'So What', duration: '9:22'));
    final facts = sections.whereType<FactsSection>().single.facts;
    expect(facts.firstWhere((fact) => fact.kind == FactKind.label).value, 'Columbia · CL 1355');
    expect(facts.firstWhere((fact) => fact.kind == FactKind.format).value, startsWith('Vinyl, LP'));
    expect(sections.whereType<TagSection>().single.tags, containsAll(['Jazz', 'Modal']));
    expect(sections.whereType<TextSection>().single.text, startsWith('Recorded on March 2'));
    expect(requests.map((request) => request.url.path), ['/masters/5460', '/releases/6276183']);
    expect(requests.first.headers['Authorization'], 'Discogs token=secret');
  });

  test('a discogs release without master is read once', () async {
    final requests = <http.Request>[];
    const pressing = CollectionItem(id: 'p', categoryId: 'jazz', titles: LocalizedTitles(byLanguage: {'en': 'Kind of Blue'}), sourceKey: 'discogs', externalWorkId: 'release:6276183');
    final source = DiscogsDetailsSource(discogsClient(requests), token: '');
    expect(source.supports(pressing), isTrue);
    expect(source.supports(const CollectionItem(id: 'x', categoryId: 'jazz', titles: LocalizedTitles(byLanguage: {}), sourceKey: 'musicbrainz', externalWorkId: 'abc')), isFalse);
    final sections = await source.fetch(pressing, languageCode: 'fr');
    expect(requests, hasLength(1));
    expect(requests.single.headers.containsKey('Authorization'), isFalse);
    expect(sections.whereType<FactsSection>().single.facts.first.value, 'Columbia · CL 1355');
  });

  test('anilist description loses its html tags', () async {
    const frieren = CollectionItem(id: 'f', categoryId: 'mangas', titles: LocalizedTitles(byLanguage: {'en': 'Frieren'}), sourceKey: 'anilist', externalWorkId: '118586');
    final client = clientReturning('{"data":{"Media":{"id":1,"description":"An elf<br><br>mage <i>learns</i> what living is.","status":"RELEASING","volumes":null,"genres":["Fantasy"],"siteUrl":"https://anilist.co/manga/118586"}}}');
    final sections = await AniListDetailsSource(client).fetch(frieren, languageCode: 'fr');
    expect(sections.whereType<TextSection>().single.text, 'An elf\n\nmage learns what living is.');
    expect(sections.whereType<TagSection>().single.tags, ['Fantasy']);
    expect(sections.whereType<LinkSection>().single.links.single.url, 'https://anilist.co/manga/118586');
  });

  test('google books details give the summary, publisher, pages and categories', () async {
    const hobbit = CollectionItem(id: 'h', categoryId: 'books', titles: LocalizedTitles(byLanguage: {'en': 'The Hobbit'}), sourceKey: 'googlebooks', externalWorkId: 'zyTCAlFPjgYC');
    final requests = <http.Request>[];
    final sections = await GoogleBooksDetailsSource(clientReturning(fixture('googlebooks_volume.json'), requests: requests), apiKey: 'key').fetch(hobbit, languageCode: 'fr');
    expect(sections.whereType<TextSection>().single.text, contains('Bilbo Baggins'));
    expect(sections.whereType<TextSection>().single.text, isNot(contains('<p>')));
    final facts = sections.whereType<FactsSection>().single.facts;
    expect(facts, containsAll([const DetailFact(kind: FactKind.publisher, value: 'Houghton Mifflin Harcourt'), const DetailFact(kind: FactKind.pages, value: '300')]));
    expect(sections.whereType<TagSection>().single.tags, ['Fiction', 'Fantasy', 'Epic', 'Juvenile Fiction', 'Classics']);
    expect(sections.whereType<LinkSection>().single.links.single.url, startsWith('https://books.google.com'));
    expect(requests.single.url.queryParameters['key'], 'key');
  });

  test('discogs index tracks are flattened and headings skipped', () async {
    const pressing = CollectionItem(id: 'p', categoryId: 'jazz', titles: LocalizedTitles(byLanguage: {'en': 'Suite'}), sourceKey: 'discogs', externalWorkId: 'release:1');
    final body = jsonEncode({
      'id': 1,
      'tracklist': [
        {'type_': 'heading', 'title': 'Side A', 'position': ''},
        {'type_': 'index', 'title': 'Suite', 'position': '', 'sub_tracks': [
          {'type_': 'track', 'title': 'Part I', 'position': 'A1a', 'duration': '3:00'},
          {'type_': 'track', 'title': 'Part II', 'position': 'A1b', 'duration': '4:00'},
        ]},
        {'type_': 'track', 'title': 'Coda', 'position': 'A2', 'duration': '2:00'},
      ],
    });
    final sections = await DiscogsDetailsSource(clientReturning(body), token: '').fetch(pressing, languageCode: 'fr');
    expect(sections.whereType<TrackListSection>().single.tracks.map((track) => track.title), ['Part I', 'Part II', 'Coda']);
  });
}
