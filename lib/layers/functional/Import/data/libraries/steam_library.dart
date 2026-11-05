import 'package:akashic/layers/functional/Catalog/domain/entities/category_type.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/localized_titles.dart';
import 'package:akashic/layers/functional/Import/domain/use_cases/import_account_library.dart';
import 'package:akashic/layers/functional/Lookup/data/sources/json_fields.dart';
import 'package:akashic/layers/functional/Lookup/data/sources/source_http.dart';
import 'package:akashic/layers/functional/Lookup/domain/entities/source_match.dart';
import 'package:http/http.dart' as http;

class SteamLibrary implements AccountLibrary {
  SteamLibrary(this._client, {required this._apiKey});

  static const String sourceKey = 'steam';
  static const String platform = 'PC';
  static final RegExp _steamId = RegExp(r'^\d{17}$');
  static final RegExp _profileUrl = RegExp(r'steamcommunity\.com/profiles/(\d{17})');
  static final RegExp _vanityUrl = RegExp(r'steamcommunity\.com/id/([^/?#]+)');

  final http.Client _client;
  final String _apiKey;

  static String portraitImageOf(String appId) => 'https://cdn.cloudflare.steamstatic.com/steam/apps/$appId/library_600x900.jpg';

  static String headerImageOf(String appId) => 'https://cdn.cloudflare.steamstatic.com/steam/apps/$appId/header.jpg';

  @override
  LibraryService get service => LibraryService.steam;

  @override
  CategoryType get categoryType => CategoryType.videoGames;

  @override
  bool get isConfigured => _apiKey.isNotEmpty;

  Future<Map<String, Object?>> _get(String path, Map<String, String> parameters) async =>
      mapOf(await sourceGetJson(_client, Uri.https('api.steampowered.com', path, {'key': _apiKey, ...parameters}), sourceKey: sourceKey));

  @override
  AccountField get accountField => AccountField.accountName;

  @override
  Future<List<LibraryEntry>> entriesOf(String accountName, {String password = ''}) async {
    final response = mapOf((await _get('/IPlayerService/GetOwnedGames/v1/', {'steamid': await steamIdOf(accountName), 'include_appinfo': 'true'}))['response']);
    if (!response.containsKey('games')) {
      throw const LibraryNotFound(LibraryService.steam, problem: LibraryProblem.privateLibrary);
    }
    return [
      for (final game in listOf(response['games']).map(mapOf))
        if ((game['appid'], textOf(game['name'])) case (final int appId, final name?))
          LibraryEntry(SourceMatch(
            sourceKey: sourceKey,
            externalWorkId: '$appId',
            titles: LocalizedTitles(byLanguage: {'en': name}),
            imageUrl: portraitImageOf('$appId'),
            platform: platform,
            suggestedType: CategoryType.videoGames,
          )),
    ];
  }

  Future<String> steamIdOf(String accountName) async {
    final account = accountName.trim();
    if (_steamId.hasMatch(account)) {
      return account;
    }
    if (_profileUrl.firstMatch(account)?.group(1) case final steamId?) {
      return steamId;
    }
    final vanityName = _vanityUrl.firstMatch(account)?.group(1) ?? account;
    final response = mapOf((await _get('/ISteamUser/ResolveVanityURL/v1/', {'vanityurl': vanityName}))['response']);
    if (response['success'] != 1) {
      throw const LibraryNotFound(LibraryService.steam);
    }
    return textOf(response['steamid']) ?? (throw const LibraryNotFound(LibraryService.steam));
  }
}
