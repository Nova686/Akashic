import 'package:akashic/layers/functional/Catalog/domain/entities/category_type.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/localized_titles.dart';
import 'package:akashic/layers/functional/Import/domain/use_cases/import_account_library.dart';
import 'package:akashic/layers/functional/Lookup/data/sources/board_game_geek_source.dart';
import 'package:akashic/layers/functional/Lookup/data/sources/source_http.dart';
import 'package:akashic/layers/functional/Lookup/domain/entities/source_match.dart';
import 'package:akashic/layers/functional/Lookup/domain/entities/source_unavailable.dart';
import 'package:http/http.dart' as http;
import 'package:xml/xml.dart';

class BoardGameGeekCollectionLibrary implements AccountLibrary {
  BoardGameGeekCollectionLibrary(this._client, {required this._token, Future<void> Function(Duration delay)? wait}) : _wait = wait ?? Future<void>.delayed;

  static const List<Duration> queuedRetryDelays = [Duration(seconds: 2), Duration(seconds: 3), Duration(seconds: 5), Duration(seconds: 8), Duration(seconds: 13)];

  final http.Client _client;
  final String _token;
  final Future<void> Function(Duration delay) _wait;

  @override
  LibraryService get service => LibraryService.boardGameGeek;

  @override
  CategoryType get categoryType => CategoryType.boardGames;

  @override
  bool get isConfigured => _token.isNotEmpty;

  Future<XmlDocument> _collectionOf(String accountName) async {
    final body = await sourceGetText(
      _client,
      Uri.https('boardgamegeek.com', '/xmlapi2/collection', {'username': accountName, 'own': '1'}),
      sourceKey: BoardGameGeekSource.sourceKey,
      headers: {'Authorization': 'Bearer $_token'},
    );
    if (body == null) {
      throw const LibraryNotFound(LibraryService.boardGameGeek);
    }
    try {
      return XmlDocument.parse(body);
    } on XmlException catch (failure) {
      throw SourceUnavailable(BoardGameGeekSource.sourceKey, 'unreadable answer: ${failure.message}');
    }
  }

  @override
  AccountField get accountField => AccountField.accountName;

  @override
  Future<List<LibraryEntry>> entriesOf(String accountName, {String password = ''}) async {
    var collection = await _collectionOf(accountName);
    for (final delay in queuedRetryDelays) {
      if (collection.rootElement.name.local != 'message') {
        break;
      }
      await _wait(delay);
      collection = await _collectionOf(accountName);
    }
    switch (collection.rootElement.name.local) {
      case 'errors':
        throw const LibraryNotFound(LibraryService.boardGameGeek);
      case 'message':
        throw const SourceUnavailable(BoardGameGeekSource.sourceKey, 'collection still being prepared');
    }
    final seenIds = <String>{};
    return [
      for (final item in collection.findAllElements('item'))
        if ((item.getAttribute('objectid'), item.findElements('name').firstOrNull?.innerText.trim()) case (final gameId?, final name?) when name.isNotEmpty && seenIds.add(gameId))
          LibraryEntry(SourceMatch(
            sourceKey: BoardGameGeekSource.sourceKey,
            externalWorkId: gameId,
            titles: LocalizedTitles(byLanguage: {'en': name}),
            year: int.tryParse(item.findElements('yearpublished').firstOrNull?.innerText.trim() ?? ''),
            imageUrl: switch (item.findElements('image').firstOrNull?.innerText.trim()) {
              final image? when image.startsWith('https://') => image,
              final image? when image.startsWith('//') => 'https:$image',
              _ => null,
            },
            suggestedType: CategoryType.boardGames,
          )),
    ];
  }
}
