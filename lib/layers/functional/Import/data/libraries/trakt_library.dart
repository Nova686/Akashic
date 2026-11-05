import 'package:akashic/layers/functional/Catalog/domain/entities/category_type.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/localized_titles.dart';
import 'package:akashic/layers/functional/Import/domain/use_cases/import_account_library.dart';
import 'package:akashic/layers/functional/Lookup/data/sources/json_fields.dart';
import 'package:akashic/layers/functional/Lookup/data/sources/source_http.dart';
import 'package:akashic/layers/functional/Lookup/domain/entities/source_match.dart';
import 'package:akashic/layers/functional/Lookup/domain/entities/source_unavailable.dart';
import 'package:http/http.dart' as http;

class TraktLibrary implements AccountLibrary {
  TraktLibrary(this._client, {required this._clientId});

  static const String sourceKey = 'trakt';
  static const Set<String> _refusals = {'HTTP 401', 'HTTP 403'};

  final http.Client _client;
  final String _clientId;

  @override
  LibraryService get service => LibraryService.trakt;

  @override
  CategoryType get categoryType => CategoryType.films;

  @override
  bool get isConfigured => _clientId.isNotEmpty;

  Future<List<Map<String, Object?>>> _collection(String accountName, String kind) async {
    final Object? json;
    try {
      json = await sourceGetJson(
        _client,
        Uri.https('api.trakt.tv', '/users/${Uri.encodeComponent(accountName)}/collection/$kind'),
        sourceKey: sourceKey,
        headers: {'trakt-api-version': '2', 'trakt-api-key': _clientId, 'Content-Type': 'application/json'},
      );
    } on SourceUnavailable catch (failure) {
      if (_refusals.contains(failure.reason)) {
        throw const LibraryNotFound(LibraryService.trakt);
      }
      rethrow;
    }
    if (json == null) {
      throw const LibraryNotFound(LibraryService.trakt);
    }
    return listOf(json).map(mapOf).toList();
  }

  @override
  AccountField get accountField => AccountField.accountName;

  @override
  Future<List<LibraryEntry>> entriesOf(String accountName, {String password = ''}) async {
    final movies = await _collection(accountName, 'movies');
    final shows = await _collection(accountName, 'shows');
    return [
      for (final entry in movies) ?_entryOf(mapOf(entry['movie']), isShow: false),
      for (final entry in shows) ?_entryOf(mapOf(entry['show']), isShow: true),
    ];
  }

  LibraryEntry? _entryOf(Map<String, Object?> media, {required bool isShow}) {
    final title = textOf(media['title']);
    final ids = mapOf(media['ids']);
    final traktId = ids['trakt'];
    if (title == null || traktId is! int) {
      return null;
    }
    final tmdbId = ids['tmdb'];
    return LibraryEntry(SourceMatch(
      sourceKey: !isShow && tmdbId is int ? 'tmdb' : sourceKey,
      externalWorkId: !isShow && tmdbId is int ? '$tmdbId' : '${isShow ? 'show' : 'movie'}:$traktId',
      titles: LocalizedTitles(byLanguage: {'en': title}),
      year: yearOf(media['year']),
      suggestedType: CategoryType.films,
    ));
  }
}
