import 'package:akashic/layers/functional/Catalog/domain/entities/category_type.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/localized_titles.dart';
import 'package:akashic/layers/functional/Import/domain/use_cases/import_account_library.dart';
import 'package:akashic/layers/functional/Lookup/data/sources/json_fields.dart';
import 'package:akashic/layers/functional/Lookup/data/sources/source_http.dart';
import 'package:akashic/layers/functional/Lookup/domain/entities/source_match.dart';
import 'package:akashic/layers/functional/Lookup/domain/entities/source_unavailable.dart';
import 'package:http/http.dart' as http;

class ItchIoLibrary implements AccountLibrary {
  ItchIoLibrary(this._client);

  static const String sourceKey = 'itchio';
  static const String storeName = 'itch.io';
  static const int maximumPages = 100;
  static const Set<String> _refusals = {'HTTP 400', 'HTTP 401', 'HTTP 403'};

  final http.Client _client;

  @override
  LibraryService get service => LibraryService.itchIo;

  @override
  CategoryType get categoryType => CategoryType.videoGames;

  @override
  bool get isConfigured => true;

  @override
  AccountField get accountField => AccountField.apiKey;

  @override
  Future<List<LibraryEntry>> entriesOf(String accountName, {String password = ''}) async {
    final entries = <LibraryEntry>[];
    final seenIds = <int>{};
    for (var page = 1; page <= maximumPages; page++) {
      final Object? json;
      try {
        json = await sourceGetJson(_client, Uri.https('api.itch.io', '/profile/owned-keys', {'page': '$page'}), sourceKey: sourceKey, headers: {'Authorization': 'Bearer $accountName'});
      } on SourceUnavailable catch (failure) {
        if (_refusals.contains(failure.reason)) {
          throw const LibraryNotFound(LibraryService.itchIo);
        }
        rethrow;
      }
      final body = mapOf(json);
      if (body.containsKey('errors')) {
        throw const LibraryNotFound(LibraryService.itchIo);
      }
      final ownedKeys = listOf(body['owned_keys']).map(mapOf).toList();
      for (final ownedKey in ownedKeys) {
        final game = mapOf(ownedKey['game']);
        final classification = textOf(game['classification']);
        if ((game['id'], textOf(game['title'])) case (final int gameId, final title?) when (classification == null || classification == 'game') && seenIds.add(gameId)) {
          final author = mapOf(game['user']);
          entries.add(LibraryEntry(SourceMatch(
            sourceKey: sourceKey,
            externalWorkId: '$gameId',
            titles: LocalizedTitles(byLanguage: {'en': title}),
            creator: textOf(author['display_name']) ?? textOf(author['username']),
            year: yearOf(game['published_at']),
            imageUrl: httpsUrl(game['cover_url']),
            platform: 'PC',
            format: storeName,
            suggestedType: CategoryType.videoGames,
          )));
        }
      }
      final perPage = body['per_page'] is int ? body['per_page']! as int : ownedKeys.length;
      if (ownedKeys.isEmpty || ownedKeys.length < perPage) {
        break;
      }
    }
    return entries;
  }
}
