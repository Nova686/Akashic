import 'dart:convert';

import 'package:akashic/layers/functional/Catalog/domain/entities/category_type.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/localized_titles.dart';
import 'package:akashic/layers/functional/Lookup/data/sources/anilist_source.dart';
import 'package:akashic/layers/functional/Lookup/data/sources/bnf_source.dart';
import 'package:akashic/layers/functional/Lookup/domain/entities/source_match.dart';
import 'package:akashic/layers/functional/Lookup/domain/entities/source_unavailable.dart';
import 'package:akashic/layers/functional/Lookup/domain/gateways/catalog_source.dart';
import 'package:akashic/layers/functional/Lookup/domain/use_cases/isbn_with_fallback_source.dart';
import 'package:akashic/layers/functional/Lookup/domain/use_cases/isbn_with_series_source.dart';
import 'package:akashic/layers/functional/Lookup/domain/use_cases/volume_title.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

import 'data/fixture_client.dart';

MockClient bnfClient({List<http.Request>? requests}) => MockClient((request) async {
      requests?.add(request);
      final isbn = RegExp(r'"(\d+)"').firstMatch(request.url.queryParameters['query']!)!.group(1);
      return http.Response.bytes(utf8.encode(fixture('bnf_isbn_$isbn.xml')), 200, headers: {'content-type': 'text/xml; charset=utf-8'});
    });

class ScriptedIsbnSource implements CatalogSource {
  ScriptedIsbnSource({this.answer = const [], this.isDown = false, this.isConfigured = true});

  final List<SourceMatch> answer;
  final bool isDown;
  int calls = 0;

  @override
  final bool isConfigured;

  @override
  String get key => 'googlebooks';

  @override
  Set<CategoryType> get types => const {CategoryType.books, CategoryType.comics};

  @override
  bool get supportsBarcode => true;

  @override
  Future<List<SourceMatch>> search(String query) async => answer;

  @override
  Future<List<SourceMatch>> lookupBarcode(String barcode) async {
    calls++;
    if (isDown) {
      throw const SourceUnavailable('googlebooks', 'HTTP 503');
    }
    return answer;
  }
}

const SourceMatch googleHobbit = SourceMatch(sourceKey: 'googlebooks', externalWorkId: 'hobbit', titles: LocalizedTitles(byLanguage: {'en': 'The Hobbit'}), suggestedType: CategoryType.books);

void main() {
  test('a BnF record gives a cleaned title, author, publisher, year, volume and cover', () async {
    final match = (await BnfSource(bnfClient()).lookupBarcode('9791032713662')).single;
    expect(match.titles.byLanguage, {'fr': 'Frieren. 10'});
    expect(match.creator, 'Kanehito Yamada');
    expect(match.publisher, 'Ki-oon');
    expect(match.year, 2023);
    expect(match.suggestedType, CategoryType.manga);
    expect(match.seriesTitle, 'Frieren');
    expect(match.volumeNumber, 10);
    expect(match.barcode, '9791032713662');
    expect(match.imageUrl, 'https://catalogue.bnf.fr/couverture?appName=NE&idArk=ark:/12148/cb47373699p&couverture=1');
  });

  test('unusual BnF titles and duplicated records still give one volume', () async {
    final blueLock = (await BnfSource(bnfClient()).lookupBarcode('9791043304552')).single;
    expect(blueLock.seriesTitle, 'Blue Lock');
    expect(blueLock.volumeNumber, 31);
    expect(blueLock.publisher, 'Pika éditions');
    expect(blueLock.creator, 'Yūsuke Nomura');
    final spyFamily = await BnfSource(bnfClient()).lookupBarcode('9791042021030');
    expect(spyFamily, hasLength(1));
    expect(spyFamily.single.volumeNumber, 16);
    expect(spyFamily.single.creator, 'Tatsuya Endō');
  });

  test('an isbn unknown to the BnF gives nothing and a non isbn is never asked', () async {
    final requests = <http.Request>[];
    final source = BnfSource(bnfClient(requests: requests));
    expect(await source.lookupBarcode('9780000000002'), isEmpty);
    expect(await source.lookupBarcode('0074646093822'), isEmpty);
    expect(requests, hasLength(1));
    expect(requests.single.headers.containsKey('Authorization'), isFalse);
  });

  test('BnF names and publishers are cleaned', () {
    expect(BnfSource.bnfPersonName('Yamada, Kanehito. Auteur du texte'), 'Kanehito Yamada');
    expect(BnfSource.bnfPersonName('Endō, Tatsuya (1980-....)'), 'Tatsuya Endō');
    expect(BnfSource.bnfPersonName('Lebrun, Lilian (Traducteur)'), isNull);
    expect(cleanBnfPublisher('Kurokawa (Paris)'), 'Kurokawa');
    expect(cleanBnfTitle('Frieren. 10 / scénario, Kanehito Yamada ; [Traduction : Géraldine Oudin]'), 'Frieren. 10');
    expect(parseVolumeTitle('One Piece. 112'), const VolumeTitle(seriesTitle: 'One Piece', volumeNumber: 112));
    expect(parseVolumeTitle('Blue Lock. T.. 31'), const VolumeTitle(seriesTitle: 'Blue Lock', volumeNumber: 31));
  });

  test('google books answers first and the BnF is not asked', () async {
    final requests = <http.Request>[];
    final source = IsbnWithFallbackSource(ScriptedIsbnSource(answer: const [googleHobbit]), BnfSource(bnfClient(requests: requests)));
    expect((await source.lookupBarcode('9791032713662')).single, googleHobbit);
    expect(requests, isEmpty);
  });

  test('when google books fails or finds nothing, the BnF answers', () async {
    for (final google in [ScriptedIsbnSource(isDown: true), ScriptedIsbnSource(), ScriptedIsbnSource(isConfigured: false)]) {
      final match = (await IsbnWithFallbackSource(google, BnfSource(bnfClient())).lookupBarcode('9791032713662')).single;
      expect(match.sourceKey, 'bnf');
    }
  });

  test('when both fail, the isbn stays to check later', () async {
    final downBnf = BnfSource(MockClient((request) async => throw http.ClientException('connection reset')));
    await expectLater(IsbnWithFallbackSource(ScriptedIsbnSource(isDown: true), downBnf).lookupBarcode('9791032713662'), throwsA(isA<SourceUnavailable>()));
  });

  test('a manga volume found by the BnF is completed by its AniList series', () async {
    final source = IsbnWithSeriesSource(IsbnWithFallbackSource(ScriptedIsbnSource(isDown: true), BnfSource(bnfClient())), AniListSource(clientReturning(fixture('anilist.json'))));
    final match = (await source.lookupBarcode('9791032713662')).single;
    expect(match.sourceKey, 'anilist');
    expect(match.externalWorkId, '118586');
    expect(match.volumeNumber, 10);
    expect(match.barcode, '9791032713662');
    expect(match.imageUrl, startsWith('https://catalogue.bnf.fr/couverture'));
  });
}
