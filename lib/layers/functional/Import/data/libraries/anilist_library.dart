import 'package:akashic/layers/functional/Catalog/domain/entities/category_type.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/item_progress.dart';
import 'package:akashic/layers/functional/Import/domain/use_cases/import_account_library.dart';
import 'package:akashic/layers/functional/Lookup/data/sources/anilist_source.dart';
import 'package:akashic/layers/functional/Lookup/data/sources/json_fields.dart';
import 'package:akashic/layers/functional/Lookup/data/sources/source_http.dart';
import 'package:akashic/layers/functional/Lookup/domain/entities/source_match.dart';
import 'package:http/http.dart' as http;

class AnilistLibrary implements AccountLibrary {
  AnilistLibrary(this._client);

  static const String _query = r'''
query ($user: String) {
  MediaListCollection(userName: $user, type: MANGA) {
    lists {
      entries {
        status
        media {
          id
          title { romaji english native }
          staff(perPage: 3) { nodes { name { full } } }
          volumes
          status
          coverImage { large }
          startDate { year }
        }
      }
    }
  }
}''';

  static const Map<String, ProgressStatus> _progressByStatus = {
    'CURRENT': ProgressStatus.inProgress,
    'REPEATING': ProgressStatus.inProgress,
    'PAUSED': ProgressStatus.inProgress,
    'COMPLETED': ProgressStatus.finished,
    'DROPPED': ProgressStatus.abandoned,
    'PLANNING': ProgressStatus.notStarted,
  };

  final http.Client _client;

  @override
  LibraryService get service => LibraryService.anilist;

  @override
  CategoryType get categoryType => CategoryType.manga;

  @override
  bool get isConfigured => true;

  @override
  AccountField get accountField => AccountField.accountName;

  @override
  Future<List<LibraryEntry>> entriesOf(String accountName, {String password = ''}) async {
    final json = await sourcePostJson(_client, Uri.https('graphql.anilist.co', '/'), sourceKey: AniListSource.sourceKey, body: {
      'query': _query,
      'variables': {'user': accountName},
    });
    final collection = mapOf(mapOf(mapOf(json)['data'])['MediaListCollection']);
    if (collection.isEmpty) {
      throw const LibraryNotFound(LibraryService.anilist);
    }
    final seenIds = <int>{};
    return [
      for (final list in listOf(collection['lists']).map(mapOf))
        for (final entry in listOf(list['entries']).map(mapOf))
          if (mapOf(entry['media']) case final media when media['id'] is int && seenIds.add(media['id']! as int) && anilistTitlesOf(media).byLanguage.isNotEmpty)
            LibraryEntry(
              SourceMatch(
                sourceKey: AniListSource.sourceKey,
                externalWorkId: '${media['id']}',
                titles: anilistTitlesOf(media),
                creator: anilistStaffOf(media),
                year: yearOf(mapOf(media['startDate'])['year']),
                imageUrl: httpsUrl(mapOf(media['coverImage'])['large']),
                volumeCount: media['volumes'] is int ? media['volumes']! as int : null,
                status: textOf(media['status']),
                suggestedType: CategoryType.manga,
              ),
              progress: _progressByStatus[textOf(entry['status'])],
            ),
    ];
  }
}
