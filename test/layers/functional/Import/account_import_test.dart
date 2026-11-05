import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:akashic/layers/functional/Catalog/domain/entities/category.dart';
import 'package:akashic/layers/functional/Catalog/domain/entities/category_type.dart';
import 'package:akashic/layers/functional/Check/domain/use_cases/add_from_match.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/collection_item.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/item_progress.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/localized_titles.dart';
import 'package:akashic/layers/functional/Import/data/gateways/drift_linked_account_gateway.dart';
import 'package:akashic/layers/functional/Import/domain/entities/linked_account.dart';
import 'package:akashic/layers/functional/Import/domain/entities/linked_account_sync_progress.dart';
import 'package:akashic/layers/functional/Import/presentation/widgets/sync_progress_banner.dart';
import 'package:akashic/layers/functional/Import/data/libraries/anilist_library.dart';
import 'package:akashic/layers/functional/Import/data/libraries/steam_grid_db_covers.dart';
import 'package:akashic/layers/functional/Check/domain/gateways/cover_image_gateway.dart';
import 'package:akashic/layers/functional/Import/domain/use_cases/sync_linked_accounts.dart';
import 'package:akashic/layers/functional/Import/data/libraries/itch_io_library.dart';
import 'package:akashic/layers/functional/Import/data/libraries/my_anime_list_library.dart';
import 'package:akashic/layers/functional/Import/data/libraries/rebrickable_collection_library.dart';
import 'package:akashic/layers/functional/Import/data/libraries/board_game_geek_collection_library.dart';
import 'package:akashic/layers/functional/Import/data/libraries/open_library_library.dart';
import 'package:akashic/layers/functional/Import/data/libraries/playnite_export_library.dart';
import 'package:akashic/layers/functional/Import/domain/entities/import_table.dart';
import 'package:akashic/layers/functional/Import/domain/use_cases/find_game_match.dart';
import 'package:akashic/layers/functional/Lookup/domain/entities/source_unavailable.dart';
import 'package:akashic/layers/functional/Lookup/domain/gateways/catalog_source.dart';
import 'package:akashic/layers/technical/MediaStorage/spreadsheet_files.dart';
import 'package:akashic/layers/functional/Import/data/libraries/steam_library.dart';
import 'package:akashic/layers/functional/Import/data/libraries/trakt_library.dart';
import 'package:akashic/layers/functional/Import/domain/use_cases/import_account_library.dart';
import 'package:akashic/layers/functional/Import/presentation/cubit/account_import_cubit.dart';
import 'package:akashic/layers/functional/Import/presentation/views/account_import_view.dart';
import 'package:akashic/layers/functional/Lookup/domain/entities/source_match.dart';
import 'package:akashic/layers/technical/Localization/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:mocktail/mocktail.dart';

import '../Collection/collection_harness.dart';

http.Response jsonResponse(Object body, {int status = 200}) => http.Response.bytes(utf8.encode(jsonEncode(body)), status, headers: {'content-type': 'application/json; charset=utf-8'});

class MockAddFromMatch extends Mock implements AddFromMatch {}

class FixedLibrary implements AccountLibrary {
  FixedLibrary(this.entries, {this.isConfigured = true, this.service = LibraryService.anilist, this.categoryType = CategoryType.manga});

  final List<LibraryEntry> entries;
  @override
  final bool isConfigured;
  @override
  final LibraryService service;
  @override
  final CategoryType categoryType;

  @override
  AccountField get accountField => service == LibraryService.rebrickable ? AccountField.accountAndPassword : AccountField.accountName;

  @override
  Future<List<LibraryEntry>> entriesOf(String accountName, {String password = ''}) async => accountName == 'nobody' ? throw LibraryNotFound(service) : entries;
}

class PickedFiles implements SpreadsheetFiles {
  PickedFiles(this.picked);

  final PickedSpreadsheet? picked;

  @override
  Future<PickedSpreadsheet?> pick() async => picked;

  @override
  Future<bool> save(String fileName, Uint8List bytes) async => true;
}

class FixedGames implements CatalogSource {
  FixedGames(this.results, {this.isDown = false});

  final List<SourceMatch> results;
  final bool isDown;

  @override
  String get key => 'igdb';

  @override
  Set<CategoryType> get types => const {CategoryType.videoGames};

  @override
  bool get isConfigured => true;

  @override
  bool get supportsBarcode => false;

  @override
  Future<List<SourceMatch>> search(String query) async => isDown ? throw const SourceUnavailable('igdb') : results;

  @override
  Future<List<SourceMatch>> lookupBarcode(String barcode) async => const [];
}

Uint8List csvBytes(String text) => Uint8List.fromList(utf8.encode(text));

SourceMatch manga(String id) => SourceMatch(sourceKey: 'anilist', externalWorkId: id, titles: LocalizedTitles(byLanguage: {'en': 'Manga $id'}), suggestedType: CategoryType.manga);

void main() {
  test('steam resolves a profile name, then lists the owned games with their library art', () async {
    final asked = <String>[];
    final library = SteamLibrary(MockClient((request) async {
      asked.add(request.url.path);
      expect(request.url.queryParameters['key'], 'key');
      if (request.url.path == '/ISteamUser/ResolveVanityURL/v1/') {
        expect(request.url.queryParameters['vanityurl'], 'gaben');
        return jsonResponse({
          'response': {'success': 1, 'steamid': '76561197960287930'},
        });
      }
      expect(request.url.queryParameters['steamid'], '76561197960287930');
      return jsonResponse({
        'response': {
          'game_count': 2,
          'games': [
            {'appid': 620, 'name': 'Portal 2', 'playtime_forever': 120},
            {'appid': 70, 'name': 'Half-Life'},
          ],
        },
      });
    }), apiKey: 'key');
    final entries = await library.entriesOf('https://steamcommunity.com/id/gaben/');
    expect(asked, ['/ISteamUser/ResolveVanityURL/v1/', '/IPlayerService/GetOwnedGames/v1/']);
    expect(entries.map((entry) => (entry.match.sourceKey, entry.match.externalWorkId, entry.match.titles.byLanguage['en'])), [('steam', '620', 'Portal 2'), ('steam', '70', 'Half-Life')]);
    expect(entries.first.match.imageUrl, 'https://cdn.cloudflare.steamstatic.com/steam/apps/620/library_600x900.jpg');
    expect(entries.first.match.platform, 'PC');
  });

  test('steam takes a SteamID or profile link as is and reports a private library', () async {
    final library = SteamLibrary(MockClient((request) async {
      expect(request.url.path, '/IPlayerService/GetOwnedGames/v1/');
      return jsonResponse({'response': <String, Object?>{}});
    }), apiKey: 'key');
    expect(library.entriesOf('76561197960287930'), throwsA(isA<LibraryNotFound>()));
    expect(library.entriesOf('steamcommunity.com/profiles/76561197960287930'), throwsA(isA<LibraryNotFound>()));
    expect(SteamLibrary(MockClient((request) async => jsonResponse({})), apiKey: '').isConfigured, isFalse);
  });

  test('trakt imports collected films by their tmdb id and shows by their trakt id, a private profile is not found', () async {
    final library = TraktLibrary(MockClient((request) async {
      expect(request.headers['trakt-api-key'], 'client');
      expect(request.headers['trakt-api-version'], '2');
      if (request.url.path.endsWith('/movies')) {
        return jsonResponse([
          {
            'movie': {'title': 'Dune', 'year': 2021, 'ids': {'trakt': 1, 'tmdb': 438631}},
          },
        ]);
      }
      return jsonResponse([
        {
          'show': {'title': 'Arcane', 'year': 2021, 'ids': {'trakt': 2, 'tmdb': 94605}},
        },
      ]);
    }), clientId: 'client');
    final entries = await library.entriesOf('sean');
    expect(entries.map((entry) => (entry.match.sourceKey, entry.match.externalWorkId, entry.match.year)), [('tmdb', '438631', 2021), ('trakt', 'show:2', 2021)]);
    final private = TraktLibrary(MockClient((request) async => http.Response('', 401)), clientId: 'client');
    expect(private.entriesOf('hidden'), throwsA(isA<LibraryNotFound>()));
    final missing = TraktLibrary(MockClient((request) async => http.Response('', 404)), clientId: 'client');
    expect(missing.entriesOf('nobody'), throwsA(isA<LibraryNotFound>()));
  });

  test('anilist imports each manga once with its reading status as progress', () async {
    final library = AnilistLibrary(MockClient((request) async {
      expect((jsonDecode(request.body) as Map)['variables'], {'user': 'reader'});
      Map<String, Object?> entry(String status, int id, String title) => {
            'status': status,
            'media': {
              'id': id,
              'title': {'english': title, 'native': null, 'romaji': null},
              'volumes': 14,
              'coverImage': {'large': 'http://img/$id.jpg'},
              'startDate': {'year': 2020},
              'staff': {
                'nodes': [
                  {'name': {'full': 'Kanehito Yamada'}},
                ],
              },
            },
          };
      return jsonResponse({
        'data': {
          'MediaListCollection': {
            'lists': [
              {
                'entries': [entry('CURRENT', 1, 'Frieren'), entry('COMPLETED', 2, 'Dandadan'), entry('PLANNING', 3, 'Blue Lock')],
              },
              {
                'entries': [entry('CURRENT', 1, 'Frieren')],
              },
            ],
          },
        },
      });
    }));
    final entries = await library.entriesOf('reader');
    expect(entries.map((entry) => (entry.match.titles.byLanguage['en'], entry.progress)), [
      ('Frieren', ProgressStatus.inProgress),
      ('Dandadan', ProgressStatus.finished),
      ('Blue Lock', ProgressStatus.notStarted),
    ]);
    expect(entries.first.match.imageUrl, 'https://img/1.jpg');
    expect(entries.first.match.creator, 'Kanehito Yamada');
    expect(entries.first.match.volumeCount, 14);
    final missing = AnilistLibrary(MockClient((request) async => jsonResponse({'data': {'MediaListCollection': null}})));
    expect(missing.entriesOf('nobody'), throwsA(isA<LibraryNotFound>()));
  });

  test('open library walks every shelf page by page, keeping the most advanced shelf of a book', () async {
    final library = OpenLibraryLibrary(MockClient((request) async {
      final shelf = request.url.pathSegments.last.replaceFirst('.json', '');
      final page = int.parse(request.url.queryParameters['page']!);
      Map<String, Object?> work(String key, String title) => {
            'work': {'key': '/works/$key', 'title': title, 'author_names': ['Ursula K. Le Guin'], 'first_publish_year': 1968, 'cover_id': 42},
          };
      final entries = switch ((shelf, page)) {
        ('already-read', 1) => [work('OL1W', 'A Wizard of Earthsea')],
        ('already-read', 2) => [work('OL2W', 'The Tombs of Atuan')],
        ('currently-reading', 1) => [work('OL3W', 'The Farthest Shore')],
        ('want-to-read', 1) => [work('OL1W', 'A Wizard of Earthsea'), work('OL4W', 'Tehanu')],
        _ => <Map<String, Object?>>[],
      };
      return jsonResponse({'page': page, 'reading_log_entries': entries});
    }));
    final entries = await library.entriesOf('reader');
    expect(entries.map((entry) => (entry.match.externalWorkId, entry.progress)), [
      ('OL1W', ProgressStatus.finished),
      ('OL2W', ProgressStatus.finished),
      ('OL3W', ProgressStatus.inProgress),
      ('OL4W', ProgressStatus.notStarted),
    ]);
    expect(entries.first.match.imageUrl, 'https://covers.openlibrary.org/b/id/42-L.jpg');
    final missing = OpenLibraryLibrary(MockClient((request) async => http.Response('', 404)));
    expect(missing.entriesOf('nobody'), throwsA(isA<LibraryNotFound>()));
  });

  test('importing an account skips what is owned and keeps the reading progress', () async {
    final harness = CollectionHarness();
    final mangas = await harness.mangas();
    await harness.collection.saveItem(CollectionItem(id: 'owned', categoryId: mangas.id, titles: const LocalizedTitles(byLanguage: {'en': 'Owned'}), sourceKey: 'anilist', externalWorkId: '1'));
    final addFromMatch = MockAddFromMatch();
    registerFallbackValue(manga('fallback'));
    when(() => addFromMatch(any(), categoryId: any(named: 'categoryId'))).thenAnswer((invocation) async {
      final match = invocation.positionalArguments.first as SourceMatch;
      final item = CollectionItem(id: 'item-${match.externalWorkId}', categoryId: mangas.id, titles: match.titles, sourceKey: match.sourceKey, externalWorkId: match.externalWorkId);
      await harness.collection.saveItem(item);
      return item;
    });
    final library = FixedLibrary([
      LibraryEntry(manga('1'), progress: ProgressStatus.finished),
      LibraryEntry(manga('2'), progress: ProgressStatus.finished),
      LibraryEntry(manga('3'), progress: ProgressStatus.notStarted),
    ]);
    final outcome = await ImportAccountLibrary(harness.collection, addFromMatch)(library, ' reader ', categoryId: mangas.id);
    expect(outcome, const LibraryImportOutcome(added: 2, alreadyOwned: 1, failed: 0));
    expect((await harness.collection.watchItem('item-2').first)?.progress?.status, ProgressStatus.finished);
    expect((await harness.collection.watchItem('item-3').first)?.progress, isNull);
    await harness.database.close();
  });

  testWidgets('the account import screen offers each service and explains a missing key or an unknown account', (tester) async {
    const mangas = Category(id: 'mangas', name: 'Mangas', colorValue: 0, type: CategoryType.manga, conditionParts: [], position: 0);
    final cubit = AccountImportCubit(
      ImportAccountLibrary(CollectionHarness().collection, MockAddFromMatch()),
      libraries: [
        FixedLibrary(const []),
        FixedLibrary(const [], isConfigured: false, service: LibraryService.steam, categoryType: CategoryType.videoGames),
      ],
      categories: const [mangas],
    );
    await tester.pumpWidget(MaterialApp(
      locale: const Locale('fr'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: BlocProvider.value(value: cubit, child: AccountImportView(files: PickedFiles(null))),
    ));
    expect(find.text('AniList'), findsOneWidget);
    expect(find.text('Steam'), findsOneWidget);
    await tester.enterText(find.byType(TextField), 'nobody');
    await tester.pump();
    await tester.tap(find.text('Importer'));
    await tester.pumpAndSettle();
    expect(find.text('Compte AniList introuvable ou privé.'), findsOneWidget);
    await tester.tap(find.text('Steam'));
    await tester.pump(const Duration(milliseconds: 300));
    expect(find.text('Steam n’est pas configuré : il manque sa clé d’API dans le build.'), findsOneWidget);
    await cubit.close();
  });

  test('a french Playnite export gives one game per row, steam games by their app id and the launcher as edition', () async {
    final export = csvBytes([
      'Nom,Développeurs,Éditeurs,Plateformes,Source,ID du jeu,Masqué,Date de sortie',
      'Hades,Supergiant Games,Supergiant Games,PC (Windows),Steam,1145360,False,17/09/2020',
      'Alan Wake 2,Remedy,Epic Games,"PC (Windows), PlayStation 5",Epic,a1b2c3,False,27/10/2023',
      'Old Demo,,,PC (Windows),GOG,old,True,',
      'Hades,Supergiant Games,Supergiant Games,PC (Windows),Steam,1145360,False,17/09/2020',
    ].join('\n'));
    final entries = await PlayniteExportLibrary().entriesOf('playnite.csv', export);
    expect(entries.map((entry) => (entry.match.sourceKey, entry.match.externalWorkId, entry.match.format, entry.match.platform, entry.match.year, entry.needsLookup)), [
      ('steam', '1145360', 'Steam', 'PC (Windows)', 2020, false),
      ('playnite', 'alan wake 2|epic', 'Epic', 'PC (Windows)', 2023, true),
    ]);
    expect(entries.first.match.imageUrl, 'https://cdn.cloudflare.steamstatic.com/steam/apps/1145360/library_600x900.jpg');
    expect(entries.last.match.creator, 'Remedy');
  });

  test('an english or Dawnflare export is read by its column names', () async {
    final english = await PlayniteExportLibrary().entriesOf('library.csv', csvBytes('Name,Platforms,Source,Id\nCeleste,PC (Windows),itch.io,0f9e\n'));
    expect(english.single.match.externalWorkId, '0f9e');
    expect(english.single.match.format, 'itch.io');
    final dawnflare = await PlayniteExportLibrary().entriesOf(
      'playnite-library.csv',
      csvBytes('playniteId,name,sortingName,providerGameId,pluginId,sourceId,sourceName,steamAppId\nid-1,Portal 2,Portal 2,620,p,s,Steam,620\nid-2,Control,Control,ctl,p,s,Epic,\n'),
    );
    expect(dawnflare.map((entry) => (entry.match.sourceKey, entry.match.externalWorkId, entry.match.format)), [('steam', '620', 'Steam'), ('playnite', 'id-2', 'Epic')]);
    expect(PlayniteExportLibrary().entriesOf('empty.csv', csvBytes('')), throwsA(isA<UnreadableSpreadsheet>()));
  });

  test('a playnite game takes the igdb game of the exact same name, keeping its launcher and platform', () async {
    const alanWake = SourceMatch(sourceKey: 'igdb', externalWorkId: '7', titles: LocalizedTitles(byLanguage: {'en': 'Alan Wake 2'}), imageUrl: 'https://igdb/7.jpg', platform: 'PC', suggestedType: CategoryType.videoGames);
    const alanWakeRemastered = SourceMatch(sourceKey: 'igdb', externalWorkId: '8', titles: LocalizedTitles(byLanguage: {'en': 'Alan Wake Remastered'}), suggestedType: CategoryType.videoGames);
    expect(await FindGameMatch(FixedGames(const [alanWakeRemastered, alanWake]))(manga('x')), isNull);
    final harness = CollectionHarness();
    final games = await harness.createCategory(name: 'Jeux', colorValue: 0, type: CategoryType.videoGames, conditionParts: const ['Jeu']);
    final addFromMatch = MockAddFromMatch();
    registerFallbackValue(manga('fallback'));
    final added = <SourceMatch>[];
    when(() => addFromMatch(any(), categoryId: any(named: 'categoryId'))).thenAnswer((invocation) async {
      final match = invocation.positionalArguments.first as SourceMatch;
      added.add(match);
      return CollectionItem(id: match.externalWorkId, categoryId: games.id, titles: match.titles);
    });
    final export = csvBytes('Name,Platforms,Source\nAlan Wake 2,PC (Windows),Epic\nUnknown Indie,PC (Windows),GOG\n');
    final outcome = await ImportAccountLibrary(harness.collection, addFromMatch, lookUp: FindGameMatch(FixedGames(const [alanWakeRemastered, alanWake])).call).fromFile(PlayniteExportLibrary(), 'export.csv', export, categoryId: games.id);
    expect(outcome, const LibraryImportOutcome(added: 2, alreadyOwned: 0, failed: 0));
    expect(added.map((match) => (match.sourceKey, match.externalWorkId, match.format, match.platform, match.imageUrl)), [
      ('igdb', '7', 'Epic', 'PC (Windows)', 'https://igdb/7.jpg'),
      ('playnite', 'unknown indie|gog', 'GOG', 'PC (Windows)', null),
    ]);
    added.clear();
    await ImportAccountLibrary(harness.collection, addFromMatch, lookUp: FindGameMatch(FixedGames(const [], isDown: true)).call).fromFile(PlayniteExportLibrary(), 'export.csv', csvBytes('Name\nHades\n'), categoryId: games.id);
    expect(added.single.sourceKey, 'playnite');
    await harness.database.close();
  });

  testWidgets('playnite asks for the exported file instead of an account name', (tester) async {
    const games = Category(id: 'games', name: 'Jeux', colorValue: 0, type: CategoryType.videoGames, conditionParts: [], position: 0);
    final cubit = AccountImportCubit(
      ImportAccountLibrary(CollectionHarness().collection, MockAddFromMatch()),
      libraries: [PlayniteExportLibrary()],
      categories: const [games],
    );
    await tester.pumpWidget(MaterialApp(
      locale: const Locale('fr'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: BlocProvider.value(value: cubit, child: AccountImportView(files: PickedFiles(PickedSpreadsheet(name: 'playnite.csv', bytes: csvBytes('Name\nHades\n'))))),
    ));
    expect(find.byType(TextField), findsNothing);
    expect(cubit.state.canStart, isFalse);
    await tester.tap(find.text('Choisir l’export CSV'));
    await tester.pump();
    expect(find.text('playnite.csv'), findsOneWidget);
    expect(cubit.state.canStart, isTrue);
    await cubit.close();
  });

  test('boardgamegeek waits while the collection is prepared, then imports each owned game once', () async {
    final waits = <Duration>[];
    var calls = 0;
    final library = BoardGameGeekCollectionLibrary(
      MockClient((request) async {
        calls++;
        expect(request.url.path, '/xmlapi2/collection');
        expect(request.url.queryParameters, {'username': 'player', 'own': '1'});
        expect(request.headers['Authorization'], 'Bearer token');
        if (calls < 3) {
          return http.Response('<message>Your request for this collection has been accepted and will be processed.</message>', 202);
        }
        return http.Response.bytes(
          utf8.encode('''<items totalitems="3">
  <item objecttype="thing" objectid="13" subtype="boardgame"><name sortindex="1">Catan</name><yearpublished>1995</yearpublished><image>https://cf.geekdo-images.com/catan.jpg</image></item>
  <item objecttype="thing" objectid="926" subtype="boardgameexpansion"><name sortindex="1">Catan: Seafarers</name><yearpublished>1997</yearpublished><image>//cf.geekdo-images.com/seafarers.jpg</image></item>
  <item objecttype="thing" objectid="13" subtype="boardgame"><name sortindex="1">Catan</name></item>
</items>'''),
          200,
        );
      }),
      token: 'token',
      wait: (delay) async => waits.add(delay),
    );
    final entries = await library.entriesOf('player');
    expect(waits, hasLength(2));
    expect(entries.map((entry) => (entry.match.sourceKey, entry.match.externalWorkId, entry.match.titles.byLanguage['en'], entry.match.year, entry.match.imageUrl)), [
      ('boardgamegeek', '13', 'Catan', 1995, 'https://cf.geekdo-images.com/catan.jpg'),
      ('boardgamegeek', '926', 'Catan: Seafarers', 1997, 'https://cf.geekdo-images.com/seafarers.jpg'),
    ]);
  });

  test('boardgamegeek reports an unknown user and gives up on a collection that stays queued', () async {
    final unknown = BoardGameGeekCollectionLibrary(
      MockClient((request) async => http.Response('<errors><error><message>Invalid username specified</message></error></errors>', 200)),
      token: 'token',
      wait: (delay) async {},
    );
    expect(unknown.entriesOf('nobody'), throwsA(isA<LibraryNotFound>()));
    final queued = BoardGameGeekCollectionLibrary(MockClient((request) async => http.Response('<message>Please try again later</message>', 202)), token: 'token', wait: (delay) async {});
    expect(queued.entriesOf('player'), throwsA(isA<SourceUnavailable>()));
    expect(BoardGameGeekCollectionLibrary(MockClient((request) async => http.Response('', 200)), token: '').isConfigured, isFalse);
  });

  test('itch.io pages through the owned keys of a personal key, games only, a refused key is not found', () async {
    final library = ItchIoLibrary(MockClient((request) async {
      expect(request.headers['Authorization'], 'Bearer secret');
      final page = int.parse(request.url.queryParameters['page']!);
      Map<String, Object?> owned(int id, String title, String classification) => {
            'game': {'id': id, 'title': title, 'classification': classification, 'cover_url': 'http://img.itch.zone/$id.png', 'published_at': '2019-01-25 12:00:00', 'user': {'username': 'maddy', 'display_name': 'Maddy Makes Games'}},
          };
      return jsonResponse(switch (page) {
        1 => {'page': 1, 'per_page': 2, 'owned_keys': [owned(1, 'Celeste', 'game'), owned(2, 'Pixel Pack', 'assets')]},
        2 => {'page': 2, 'per_page': 2, 'owned_keys': [owned(3, 'Baba Is You', 'game')]},
        _ => {'owned_keys': <Object>[]},
      });
    }));
    expect(library.accountField, AccountField.apiKey);
    final entries = await library.entriesOf('secret');
    expect(entries.map((entry) => (entry.match.sourceKey, entry.match.externalWorkId, entry.match.titles.byLanguage['en'], entry.match.format, entry.match.year)), [
      ('itchio', '1', 'Celeste', 'itch.io', 2019),
      ('itchio', '3', 'Baba Is You', 'itch.io', 2019),
    ]);
    expect(entries.first.match.creator, 'Maddy Makes Games');
    expect(entries.first.match.imageUrl, 'https://img.itch.zone/1.png');
    expect(ItchIoLibrary(MockClient((request) async => http.Response('', 401))).entriesOf('wrong'), throwsA(isA<LibraryNotFound>()));
    expect(ItchIoLibrary(MockClient((request) async => jsonResponse({'errors': ['invalid key']}))).entriesOf('wrong'), throwsA(isA<LibraryNotFound>()));
  });

  test('myanimelist follows its pages and links each manga to its MAL id with the reading status', () async {
    final library = MyAnimeListLibrary(MockClient((request) async {
      expect(request.headers['X-MAL-CLIENT-ID'], 'client');
      if (request.url.queryParameters['offset'] == '1') {
        return jsonResponse({
          'data': [
            {
              'node': {'id': 2, 'title': 'Berserk', 'num_volumes': 0},
              'list_status': {'status': 'plan_to_read'},
            },
          ],
          'paging': <String, Object?>{},
        });
      }
      expect(request.url.path, '/v2/users/reader/mangalist');
      return jsonResponse({
        'data': [
          {
            'node': {
              'id': 1,
              'title': 'Sousou no Frieren',
              'alternative_titles': {'en': 'Frieren: Beyond Journey\'s End', 'ja': '葬送のフリーレン'},
              'num_volumes': 14,
              'start_date': '2020-04-28',
              'main_picture': {'large': 'https://cdn.myanimelist.net/1l.jpg'},
              'authors': [
                {'node': {'first_name': 'Kanehito', 'last_name': 'Yamada'}},
              ],
            },
            'list_status': {'status': 'reading'},
          },
        ],
        'paging': {'next': 'https://api.myanimelist.net/v2/users/reader/mangalist?offset=1'},
      });
    }), clientId: 'client');
    final entries = await library.entriesOf('reader');
    expect(entries.map((entry) => (entry.match.sourceKey, entry.match.externalWorkId, entry.match.volumeCount, entry.progress)), [
      ('jikan', '1', 14, ProgressStatus.inProgress),
      ('jikan', '2', null, ProgressStatus.notStarted),
    ]);
    expect(entries.first.match.titles.byLanguage, {'ja-Latn': 'Sousou no Frieren', 'en': 'Frieren: Beyond Journey\'s End', 'ja': '葬送のフリーレン'});
    expect(entries.first.match.creator, 'Kanehito Yamada');
    expect(entries.first.match.year, 2020);
    expect(MyAnimeListLibrary(MockClient((request) async => http.Response('', 404)), clientId: 'client').entriesOf('nobody'), throwsA(isA<LibraryNotFound>()));
    expect(MyAnimeListLibrary(MockClient((request) async => jsonResponse({})), clientId: '').isConfigured, isFalse);
  });

  test('rebrickable trades the login for a user token once, then lists every owned set', () async {
    final asked = <String>[];
    final library = RebrickableCollectionLibrary(MockClient((request) async {
      asked.add('${request.method} ${request.url.path}');
      expect(request.headers['Authorization'], 'key key');
      if (request.url.path == '/api/v3/users/_token/') {
        expect(Uri.splitQueryString(request.body), {'username': 'builder', 'password': 'p@ss&word'});
        return jsonResponse({'user_token': 'tok'});
      }
      if (request.url.queryParameters['page'] == '2') {
        return jsonResponse({
          'next': null,
          'results': [
            {'quantity': 1, 'set': {'set_num': '10497-1', 'name': 'Galaxy Explorer', 'year': 2022, 'num_parts': 1254, 'set_img_url': 'https://cdn.rebrickable.com/10497.jpg'}},
          ],
        });
      }
      return jsonResponse({
        'next': 'https://rebrickable.com/api/v3/users/tok/sets/?page=2&page_size=1000',
        'results': [
          {'quantity': 2, 'set': {'set_num': '75192-1', 'name': 'Millennium Falcon', 'year': 2017, 'num_parts': 7541, 'set_img_url': 'https://cdn.rebrickable.com/75192.jpg'}},
        ],
      });
    }), apiKey: 'key');
    expect(library.accountField, AccountField.accountAndPassword);
    final entries = await library.entriesOf('builder', password: 'p@ss&word');
    expect(asked, ['POST /api/v3/users/_token/', 'GET /api/v3/users/tok/sets/', 'GET /api/v3/users/tok/sets/']);
    expect(entries.map((entry) => (entry.match.externalWorkId, entry.match.titles.byLanguage['en'], entry.match.format)), [
      ('75192-1', 'Millennium Falcon (75192)', '7541 pcs'),
      ('10497-1', 'Galaxy Explorer (10497)', '1254 pcs'),
    ]);
    expect(RebrickableCollectionLibrary(MockClient((request) async => http.Response('{"detail":"bad"}', 400)), apiKey: 'key').entriesOf('builder', password: 'wrong'), throwsA(isA<LibraryNotFound>()));
  });

  testWidgets('a service asking for a password shows a second, hidden field and needs both to start', (tester) async {
    const lego = Category(id: 'lego', name: 'LEGO', colorValue: 0, type: CategoryType.lego, conditionParts: [], position: 0);
    final cubit = AccountImportCubit(
      ImportAccountLibrary(CollectionHarness().collection, MockAddFromMatch()),
      libraries: [FixedLibrary(const [], service: LibraryService.rebrickable, categoryType: CategoryType.lego)],
      categories: const [lego],
    );
    await tester.pumpWidget(MaterialApp(
      locale: const Locale('fr'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: BlocProvider.value(value: cubit, child: AccountImportView(files: PickedFiles(null))),
    ));
    expect(find.byType(TextField), findsNWidgets(2));
    expect(find.text('Utilisé une fois, jamais enregistré'), findsOneWidget);
    await tester.enterText(find.byType(TextField).first, 'builder');
    await tester.pump();
    expect(cubit.state.canStart, isFalse);
    await tester.enterText(find.byType(TextField).last, 'secret');
    await tester.pump();
    expect(cubit.state.canStart, isTrue);
    await cubit.close();
  });

  test('a game imported without an image takes a cover from the cover lookup, the others keep theirs', () async {
    final harness = CollectionHarness();
    final games = await harness.createCategory(name: 'Jeux', colorValue: 0, type: CategoryType.videoGames, conditionParts: const ['Jeu']);
    final addFromMatch = MockAddFromMatch();
    registerFallbackValue(manga('fallback'));
    final added = <SourceMatch>[];
    when(() => addFromMatch(any(), categoryId: any(named: 'categoryId'))).thenAnswer((invocation) async {
      final match = invocation.positionalArguments.first as SourceMatch;
      added.add(match);
      return CollectionItem(id: match.externalWorkId, categoryId: games.id, titles: match.titles);
    });
    final asked = <String>[];
    final import = ImportAccountLibrary(harness.collection, addFromMatch, findCover: (match) async {
      asked.add(match.externalWorkId);
      return 'https://cdn2.steamgriddb.com/${match.externalWorkId}.png';
    });
    await import.fromFile(PlayniteExportLibrary(), 'export.csv', csvBytes('Name,Source,Game ID\nHades,Steam,1145360\nUnknown Indie,GOG,x\n'), categoryId: games.id);
    expect(asked, ['unknown indie|gog']);
    expect(added.map((match) => match.imageUrl), ['https://cdn.cloudflare.steamstatic.com/steam/apps/1145360/library_600x900.jpg', 'https://cdn2.steamgriddb.com/unknown indie|gog.png']);
    await harness.database.close();
  });

  test('a steam profile found with a hidden game list is told apart from an unknown profile', () async {
    final hidden = SteamLibrary(MockClient((request) async => jsonResponse({'response': <String, Object?>{}})), apiKey: 'key');
    await expectLater(hidden.entriesOf('76561197960287930'), throwsA(isA<LibraryNotFound>().having((notFound) => notFound.problem, 'problem', LibraryProblem.privateLibrary)));
    final unknown = SteamLibrary(MockClient((request) async => jsonResponse({'response': {'success': 42, 'message': 'No match'}})), apiKey: 'key');
    await expectLater(unknown.entriesOf('supernono681'), throwsA(isA<LibraryNotFound>().having((notFound) => notFound.problem, 'problem', LibraryProblem.unknownAccount)));
  });

  test('two syncs of one account import once, a failed entry is tried again, an unlinked account stays unlinked', () async {
    final harness = CollectionHarness();
    addTearDown(harness.database.close);
    final games = await harness.createCategory(name: 'Jeux', colorValue: 0, type: CategoryType.videoGames, conditionParts: const ['Jeu']);
    final addFromMatch = MockAddFromMatch();
    registerFallbackValue(manga('fallback'));
    var failsFor = '70';
    when(() => addFromMatch(any(), categoryId: any(named: 'categoryId'))).thenAnswer((invocation) async {
      final match = invocation.positionalArguments.first as SourceMatch;
      if (match.externalWorkId == failsFor) {
        throw const FormatException('cover');
      }
      final item = CollectionItem(id: 'item-${match.externalWorkId}', categoryId: games.id, titles: match.titles, sourceKey: match.sourceKey, externalWorkId: match.externalWorkId);
      await harness.collection.saveItem(item);
      return item;
    });
    SourceMatch game(String id) => SourceMatch(sourceKey: 'steam', externalWorkId: id, titles: LocalizedTitles(byLanguage: {'en': 'Game $id'}), suggestedType: CategoryType.videoGames);
    final library = FixedLibrary([LibraryEntry(game('620')), LibraryEntry(game('70'))], service: LibraryService.steam, categoryType: CategoryType.videoGames);
    final linked = DriftLinkedAccountGateway(harness.database);
    final importer = ImportAccountLibrary(harness.collection, addFromMatch);
    final sync = SyncLinkedAccounts(linked, [library], importer);
    final account = LinkedAccount(service: LibraryService.steam, accountName: 'supernono', categoryId: games.id);
    await linked.save(account);
    final (first, second) = (sync.syncOne(account), sync.syncOne(account));
    expect((await first, await second), (1, 1));
    verify(() => addFromMatch(any(), categoryId: any(named: 'categoryId'))).called(2);
    expect((await linked.watchAll().first).single.seenKeys, {'steam|620'});
    failsFor = '';
    expect(await sync.syncOne((await linked.watchAll().first).single), 1);
    expect(await harness.collection.watchItem('item-70').first, isNotNull);
    final unlinking = sync.syncOne((await linked.watchAll().first).single);
    await linked.remove(LibraryService.steam);
    await unlinking;
    expect(await linked.watchAll().first, isEmpty);
  });

  test('a linked account only brings what appeared since, never what was deleted, and waits six hours', () async {
    final harness = CollectionHarness();
    final games = await harness.createCategory(name: 'Jeux', colorValue: 0, type: CategoryType.videoGames, conditionParts: const ['Jeu']);
    final addFromMatch = MockAddFromMatch();
    registerFallbackValue(manga('fallback'));
    when(() => addFromMatch(any(), categoryId: any(named: 'categoryId'))).thenAnswer((invocation) async {
      final match = invocation.positionalArguments.first as SourceMatch;
      final item = CollectionItem(id: 'item-${match.externalWorkId}', categoryId: games.id, titles: match.titles, sourceKey: match.sourceKey, externalWorkId: match.externalWorkId);
      await harness.collection.saveItem(item);
      return item;
    });
    SourceMatch game(String id) => SourceMatch(sourceKey: 'steam', externalWorkId: id, titles: LocalizedTitles(byLanguage: {'en': 'Game $id'}), suggestedType: CategoryType.videoGames);
    final owned = [LibraryEntry(game('620')), LibraryEntry(game('70'))];
    final library = FixedLibrary(owned, service: LibraryService.steam, categoryType: CategoryType.videoGames);
    final linked = DriftLinkedAccountGateway(harness.database);
    final importer = ImportAccountLibrary(harness.collection, addFromMatch);
    var clock = DateTime(2026, 10, 30, 9);
    final cubit = AccountImportCubit(importer, libraries: [library], categories: [games], linkedAccounts: linked, syncLinkedAccounts: SyncLinkedAccounts(linked, [library], importer, now: () => clock), now: () => clock);
    expect(cubit.canKeepCurrentSynced, isTrue);
    cubit.setAccountName('supernono');
    await cubit.start();
    final saved = (await linked.watchAll().first).single;
    expect((saved.service, saved.accountName, saved.categoryId, saved.lastAdded), (LibraryService.steam, 'supernono', games.id, 2));
    expect(saved.seenKeys, {'steam|620', 'steam|70'});
    await harness.collection.deleteItem('item-70');
    owned.add(LibraryEntry(game('400')));
    final followedUp = <String>[];
    final sync = SyncLinkedAccounts(linked, [library], importer, followUps: {LibraryService.steam: (account) async => followedUp.add(account.accountName)}, now: () => clock);
    final steps = <LinkedAccountSyncProgress?>[];
    final listening = sync.progress.listen(steps.add);
    expect(await sync(), 0);
    expect(followedUp, isEmpty);
    clock = clock.add(const Duration(hours: 7));
    expect(await sync(), 1);
    expect(await harness.collection.watchItem('item-70').first, isNull);
    expect(await harness.collection.watchItem('item-400').first, isNotNull);
    expect(followedUp, ['supernono']);
    await Future<void>.delayed(Duration.zero);
    expect(steps.first, const LinkedAccountSyncProgress(service: LibraryService.steam));
    expect(steps, contains(const LinkedAccountSyncProgress(service: LibraryService.steam, done: 1, total: 1)));
    expect(steps, contains(const LinkedAccountSyncProgress(service: LibraryService.steam, isRefreshingDetails: true)));
    expect(steps.last, isNull);
    expect(sync.currentProgress, isNull);
    await listening.cancel();
    expect((await linked.watchAll().first).single.seenKeys, {'steam|620', 'steam|70', 'steam|400'});
    await cubit.unlink(LibraryService.steam);
    expect(await linked.watchAll().first, isEmpty);
    await cubit.close();
    await harness.database.close();
  });

  testWidgets('the import screen says where to put things and offers to keep a named account synced, not a keyed one', (tester) async {
    const games = Category(id: 'games', name: 'Jeux vidéos', colorValue: 0, type: CategoryType.videoGames, conditionParts: [], position: 0);
    final harness = CollectionHarness();
    final cubit = AccountImportCubit(
      ImportAccountLibrary(harness.collection, MockAddFromMatch()),
      libraries: [
        FixedLibrary(const [], service: LibraryService.steam, categoryType: CategoryType.videoGames),
        ItchIoLibrary(MockClient((request) async => jsonResponse({}))),
      ],
      categories: const [games],
      linkedAccounts: DriftLinkedAccountGateway(harness.database),
    );
    await tester.pumpWidget(MaterialApp(
      locale: const Locale('fr'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: BlocProvider.value(value: cubit, child: AccountImportView(files: PickedFiles(null))),
    ));
    await tester.pump();
    expect(find.text('Ranger dans'), findsOneWidget);
    expect(find.text('Catégorie musique'), findsNothing);
    expect(find.text('Lien de ton profil Steam ou SteamID'), findsOneWidget);
    expect(find.text('Synchroniser automatiquement'), findsOneWidget);
    await tester.tap(find.text('itch.io'));
    await tester.pump();
    expect(find.text('Synchroniser automatiquement'), findsNothing);
    await tester.runAsync(cubit.close);
    await tester.runAsync(harness.database.close);
  });

  test('a steam game whose cover fails gets a replacement, and a synced game without cover is repaired', () async {
    final harness = CollectionHarness();
    final games = await harness.createCategory(name: 'Jeux', colorValue: 0, type: CategoryType.videoGames, conditionParts: const ['Jeu']);
    final addFromMatch = MockAddFromMatch();
    registerFallbackValue(manga('fallback'));
    when(() => addFromMatch(any(), categoryId: any(named: 'categoryId'))).thenAnswer((invocation) async {
      final match = invocation.positionalArguments.first as SourceMatch;
      final item = CollectionItem(id: 'item-${match.externalWorkId}', categoryId: games.id, titles: match.titles, sourceKey: match.sourceKey, externalWorkId: match.externalWorkId);
      await harness.collection.saveItem(item);
      return item;
    });
    final covers = StoringCovers();
    final askedCovers = <String>[];
    final importer = ImportAccountLibrary(harness.collection, addFromMatch, covers: covers, findCover: (match) async {
      askedCovers.add(match.externalWorkId);
      return 'https://cdn.cloudflare.steamstatic.com/steam/apps/${match.externalWorkId}/header.jpg';
    });
    SourceMatch game(String id) => SourceMatch(sourceKey: 'steam', externalWorkId: id, titles: LocalizedTitles(byLanguage: {'en': 'Game $id'}), imageUrl: SteamLibrary.portraitImageOf(id), suggestedType: CategoryType.videoGames);
    final library = FixedLibrary([LibraryEntry(game('70'))], service: LibraryService.steam, categoryType: CategoryType.videoGames);
    await importer(library, 'player', categoryId: games.id);
    expect(askedCovers, ['70']);
    expect((await harness.collection.watchItem('item-70').first)?.imagePath, '/covers/header-70.jpg');
    await harness.collection.saveItem(CollectionItem(id: 'old', categoryId: games.id, titles: const LocalizedTitles(byLanguage: {'en': 'Old game'}), sourceKey: 'steam', externalWorkId: '10'));
    askedCovers.clear();
    await importer(FixedLibrary([LibraryEntry(game('10')), LibraryEntry(game('70'))], service: LibraryService.steam, categoryType: CategoryType.videoGames), 'player', categoryId: games.id, skippedKeys: {'steam|10', 'steam|70'});
    expect(askedCovers, ['10']);
    expect((await harness.collection.watchItem('old').first)?.imagePath, '/covers/header-10.jpg');
    await harness.database.close();
  });

  test('steamgriddb looks a steam game up by its app id before its name', () async {
    final asked = <String>[];
    final covers = SteamGridDbCovers(MockClient((request) async {
      asked.add(request.url.path);
      return jsonResponse({
        'success': true,
        'data': [
          {'url': 'https://cdn2.steamgriddb.com/grid/70.png'},
        ],
      });
    }), apiKey: 'key');
    final cover = await covers.coverOf(SourceMatch(sourceKey: 'steam', externalWorkId: '70', titles: const LocalizedTitles(byLanguage: {'en': 'Half-Life'}), suggestedType: CategoryType.videoGames));
    expect(cover, 'https://cdn2.steamgriddb.com/grid/70.png');
    expect(asked, ['/api/v2/grids/steam/70']);
  });

  testWidgets('the sync banner tells which account syncs and how far it went', (tester) async {
    final progress = StreamController<LinkedAccountSyncProgress?>();
    await tester.pumpWidget(MaterialApp(
      locale: const Locale('fr'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(body: SyncProgressBanner(progress: progress.stream)),
    ));
    expect(find.byType(LinearProgressIndicator), findsNothing);
    progress.add(const LinkedAccountSyncProgress(service: LibraryService.steam, done: 23, total: 120));
    await tester.pump();
    expect(find.text('Synchronisation Steam · 23 / 120'), findsOneWidget);
    expect(tester.widget<LinearProgressIndicator>(find.byType(LinearProgressIndicator)).value, closeTo(23 / 120, 0.001));
    progress.add(const LinkedAccountSyncProgress(service: LibraryService.steam, isRefreshingDetails: true));
    await tester.pump();
    expect(find.text('Steam · mise à jour des statistiques…'), findsOneWidget);
    progress.add(null);
    await tester.pumpAndSettle();
    expect(find.byType(LinearProgressIndicator), findsNothing);
    await progress.close();
  });
}

class StoringCovers implements CoverImageGateway {
  @override
  Future<StoredCover?> storeCover(String url) async => StoredCover(path: '/covers/header-${Uri.parse(url).pathSegments[2]}.jpg', spineColorValue: 0xFF123456);
}
