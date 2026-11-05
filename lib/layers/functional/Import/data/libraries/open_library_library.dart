import 'package:akashic/layers/functional/Catalog/domain/entities/category_type.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/item_progress.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/localized_titles.dart';
import 'package:akashic/layers/functional/Import/domain/use_cases/import_account_library.dart';
import 'package:akashic/layers/functional/Lookup/data/sources/json_fields.dart';
import 'package:akashic/layers/functional/Lookup/data/sources/open_library_source.dart';
import 'package:akashic/layers/functional/Lookup/data/sources/source_http.dart';
import 'package:akashic/layers/functional/Lookup/domain/entities/source_match.dart';
import 'package:http/http.dart' as http;

class OpenLibraryLibrary implements AccountLibrary {
  OpenLibraryLibrary(this._client);

  static const List<(String, ProgressStatus)> shelves = [
    ('already-read', ProgressStatus.finished),
    ('currently-reading', ProgressStatus.inProgress),
    ('want-to-read', ProgressStatus.notStarted),
  ];
  static const int maximumPages = 50;

  final http.Client _client;

  @override
  LibraryService get service => LibraryService.openLibrary;

  @override
  CategoryType get categoryType => CategoryType.books;

  @override
  bool get isConfigured => true;

  @override
  AccountField get accountField => AccountField.accountName;

  @override
  Future<List<LibraryEntry>> entriesOf(String accountName, {String password = ''}) async {
    final entries = <LibraryEntry>[];
    final seenWorks = <String>{};
    var foundAccount = false;
    for (final (shelf, progress) in shelves) {
      for (var page = 1; page <= maximumPages; page++) {
        final json = await sourceGetJson(
          _client,
          Uri.https('openlibrary.org', '/people/${Uri.encodeComponent(accountName)}/books/$shelf.json', {'page': '$page'}),
          sourceKey: OpenLibrarySource.sourceKey,
        );
        if (json == null) {
          break;
        }
        foundAccount = true;
        final logged = listOf(mapOf(json)['reading_log_entries']).map(mapOf).toList();
        for (final logEntry in logged) {
          final work = mapOf(logEntry['work']);
          if ((textOf(work['key']), textOf(work['title'])) case (final workKey?, final title?) when seenWorks.add(workKey)) {
            entries.add(LibraryEntry(
              SourceMatch(
                sourceKey: OpenLibrarySource.sourceKey,
                externalWorkId: workKey.replaceFirst('/works/', ''),
                titles: LocalizedTitles(byLanguage: {'en': title}),
                creator: switch (listOf(work['author_names']).whereType<String>().toList()) {
                  final authors when authors.isNotEmpty => authors.join(', '),
                  _ => null,
                },
                year: yearOf(work['first_publish_year']),
                imageUrl: switch (work['cover_id']) {
                  final int coverId => 'https://covers.openlibrary.org/b/id/$coverId-L.jpg',
                  _ => null,
                },
                suggestedType: CategoryType.books,
              ),
              progress: progress,
            ));
          }
        }
        if (logged.isEmpty) {
          break;
        }
      }
    }
    if (!foundAccount) {
      throw const LibraryNotFound(LibraryService.openLibrary);
    }
    return entries;
  }
}
