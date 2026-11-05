import 'package:akashic/layers/functional/Catalog/domain/entities/category_type.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/item_progress.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/localized_titles.dart';
import 'package:akashic/layers/functional/Import/domain/use_cases/import_account_library.dart';
import 'package:akashic/layers/functional/Lookup/data/sources/jikan_source.dart';
import 'package:akashic/layers/functional/Lookup/data/sources/json_fields.dart';
import 'package:akashic/layers/functional/Lookup/data/sources/source_http.dart';
import 'package:akashic/layers/functional/Lookup/domain/entities/source_match.dart';
import 'package:akashic/layers/functional/Lookup/domain/entities/source_unavailable.dart';
import 'package:http/http.dart' as http;

class MyAnimeListLibrary implements AccountLibrary {
  MyAnimeListLibrary(this._client, {required this._clientId});

  static const String serviceKey = 'myanimelist';
  static const int maximumPages = 50;
  static const String _fields = 'list_status,num_volumes,authors{first_name,last_name},start_date,alternative_titles,main_picture';
  static const Set<String> _refusals = {'HTTP 401', 'HTTP 403'};
  static const Map<String, ProgressStatus> _progressByStatus = {
    'reading': ProgressStatus.inProgress,
    'on_hold': ProgressStatus.inProgress,
    'completed': ProgressStatus.finished,
    'dropped': ProgressStatus.abandoned,
    'plan_to_read': ProgressStatus.notStarted,
  };

  final http.Client _client;
  final String _clientId;

  @override
  LibraryService get service => LibraryService.myAnimeList;

  @override
  CategoryType get categoryType => CategoryType.manga;

  @override
  bool get isConfigured => _clientId.isNotEmpty;

  @override
  AccountField get accountField => AccountField.accountName;

  @override
  Future<List<LibraryEntry>> entriesOf(String accountName, {String password = ''}) async {
    final entries = <LibraryEntry>[];
    final seenIds = <int>{};
    Uri? next = Uri.https('api.myanimelist.net', '/v2/users/${Uri.encodeComponent(accountName)}/mangalist', {'fields': _fields, 'limit': '1000', 'nsfw': 'true'});
    for (var page = 0; next != null && page < maximumPages; page++) {
      final Object? json;
      try {
        json = await sourceGetJson(_client, next, sourceKey: serviceKey, headers: {'X-MAL-CLIENT-ID': _clientId});
      } on SourceUnavailable catch (failure) {
        if (_refusals.contains(failure.reason)) {
          throw const LibraryNotFound(LibraryService.myAnimeList);
        }
        rethrow;
      }
      if (json == null) {
        throw const LibraryNotFound(LibraryService.myAnimeList);
      }
      final body = mapOf(json);
      for (final listed in listOf(body['data']).map(mapOf)) {
        final manga = mapOf(listed['node']);
        if ((manga['id'], textOf(manga['title'])) case (final int malId, final title?) when seenIds.add(malId)) {
          final alternatives = mapOf(manga['alternative_titles']);
          final authors = [
            for (final author in listOf(manga['authors']).map(mapOf))
              if ([?textOf(mapOf(author['node'])['first_name']), ?textOf(mapOf(author['node'])['last_name'])].join(' ').trim() case final name when name.isNotEmpty) name,
          ];
          entries.add(LibraryEntry(
            SourceMatch(
              sourceKey: JikanSource.sourceKey,
              externalWorkId: '$malId',
              titles: LocalizedTitles(
                byLanguage: {
                  'ja-Latn': title,
                  if (textOf(alternatives['en']) case final english? when english.isNotEmpty) 'en': english,
                  if (textOf(alternatives['ja']) case final japanese? when japanese.isNotEmpty) 'ja': japanese,
                },
                originalLanguage: 'ja',
              ),
              creator: authors.isEmpty ? null : authors.join(', '),
              year: yearOf(manga['start_date']),
              imageUrl: httpsUrl(mapOf(manga['main_picture'])['large'] ?? mapOf(manga['main_picture'])['medium']),
              volumeCount: manga['num_volumes'] is int && manga['num_volumes'] != 0 ? manga['num_volumes']! as int : null,
              suggestedType: CategoryType.manga,
            ),
            progress: _progressByStatus[textOf(mapOf(listed['list_status'])['status'])],
          ));
        }
      }
      next = switch (textOf(mapOf(body['paging'])['next'])) {
        final nextPage? => Uri.tryParse(nextPage),
        null => null,
      };
    }
    return entries;
  }
}
