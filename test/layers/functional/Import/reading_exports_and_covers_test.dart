import 'dart:convert';

import 'package:akashic/layers/functional/Catalog/domain/entities/category_type.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/localized_titles.dart';
import 'package:akashic/layers/functional/Import/data/libraries/steam_grid_db_covers.dart';
import 'package:akashic/layers/functional/Import/domain/entities/import_table.dart';
import 'package:akashic/layers/functional/Import/domain/use_cases/map_import_columns.dart';
import 'package:akashic/layers/functional/Lookup/domain/entities/source_match.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

http.Response jsonResponse(Object body) => http.Response.bytes(utf8.encode(jsonEncode(body)), 200, headers: {'content-type': 'application/json; charset=utf-8'});

Map<String, ImportField> mappedHeaders(List<String> headers) => {
      for (final MapEntry(key: column, value: field) in guessColumnMapping(headers).entries)
        if (field != ImportField.ignored) headers[column]: field,
    };

void main() {
  test('a Goodreads export maps title, author, ISBN13, binding and year, and skips shelves and page counts', () {
    const headers = [
      'Book Id', 'Title', 'Author', 'Author l-f', 'Additional Authors', 'ISBN', 'ISBN13', 'My Rating', 'Average Rating', 'Publisher', 'Binding', 'Number of Pages', 'Year Published',
      'Original Publication Year', 'Date Read', 'Date Added', 'Bookshelves', 'Bookshelves with positions', 'Exclusive Shelf',
    ];
    expect(mappedHeaders(headers), {
      'Title': ImportField.title,
      'Author': ImportField.creator,
      'ISBN13': ImportField.barcode,
      'Binding': ImportField.edition,
      'Year Published': ImportField.year,
    });
    final lines = importLinesOf(
      const ImportTable(headers: headers, rows: [
        ['1', 'The Hunger Games', 'Suzanne Collins', 'Collins, Suzanne', '', '=""', '="9780439023481"', '4', '4.3', 'Scholastic', 'Hardcover', '374', '2008', '2008', '', '2024/01/01', 'owned', 'owned (#1)', 'read'],
      ]),
      guessColumnMapping(headers),
    );
    expect(lines.single.barcode, '9780439023481');
    expect(lines.single.edition, 'Hardcover');
    expect(lines.single.year, 2008);
    expect(lines.single.volumeNumber, isNull);
  });

  test('Letterboxd and Babelio exports map their titles, authors and dates', () {
    expect(mappedHeaders(const ['Date', 'Name', 'Year', 'Letterboxd URI']), {'Name': ImportField.title, 'Year': ImportField.year});
    expect(mappedHeaders(const ['Titre', 'Auteur', 'ISBN', 'Editeur', 'Date de publication', 'Reliure']), {
      'Titre': ImportField.title,
      'Auteur': ImportField.creator,
      'ISBN': ImportField.barcode,
      'Date de publication': ImportField.year,
      'Reliure': ImportField.edition,
    });
  });

  test('steamgriddb gives the portrait grid of the game with exactly the same name, nothing otherwise', () async {
    final covers = SteamGridDbCovers(MockClient((request) async {
      expect(request.headers['Authorization'], 'Bearer key');
      if (request.url.path.startsWith('/api/v2/search/autocomplete/')) {
        return jsonResponse({
          'success': true,
          'data': [
            {'id': 1, 'name': 'Hades II'},
            {'id': 2, 'name': 'Hades'},
          ],
        });
      }
      expect(request.url.path, '/api/v2/grids/game/2');
      expect(request.url.queryParameters['dimensions'], '600x900');
      return jsonResponse({
        'success': true,
        'data': [
          {'url': 'https://cdn2.steamgriddb.com/grid/hades.png'},
        ],
      });
    }), apiKey: 'key');
    SourceMatch game(String name, {CategoryType type = CategoryType.videoGames}) => SourceMatch(sourceKey: 'playnite', externalWorkId: name, titles: LocalizedTitles(byLanguage: {'en': name}), suggestedType: type);
    expect(await covers.coverOf(game('Hades')), 'https://cdn2.steamgriddb.com/grid/hades.png');
    expect(await covers.coverOf(game('Hade')), isNull);
    expect(await covers.coverOf(game('Hades', type: CategoryType.books)), isNull);
    expect(await SteamGridDbCovers(MockClient((request) async => fail('no call without a key')), apiKey: '').coverOf(game('Hades')), isNull);
  });
}
