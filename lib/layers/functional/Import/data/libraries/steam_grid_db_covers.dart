import 'package:akashic/layers/functional/Catalog/domain/entities/category_type.dart';
import 'package:akashic/layers/functional/Collection/domain/use_cases/work_identity.dart';
import 'package:akashic/layers/functional/Import/data/libraries/steam_library.dart';
import 'package:akashic/layers/functional/Lookup/data/sources/json_fields.dart';
import 'package:akashic/layers/functional/Lookup/data/sources/source_http.dart';
import 'package:akashic/layers/functional/Lookup/domain/entities/source_match.dart';
import 'package:http/http.dart' as http;

class SteamGridDbCovers {
  SteamGridDbCovers(this._client, {required this._apiKey});

  static const String sourceKey = 'steamgriddb';
  static const String portraitDimensions = '600x900';

  final http.Client _client;
  final String _apiKey;

  bool get isConfigured => _apiKey.isNotEmpty;

  Future<Map<String, Object?>> _get(String path, [Map<String, String>? parameters]) async =>
      mapOf(await sourceGetJson(_client, Uri.https('www.steamgriddb.com', '/api/v2$path', parameters), sourceKey: sourceKey, headers: {'Authorization': 'Bearer $_apiKey'}));

  Future<String?> _portraitGridOf(String gamePath) async {
    final grids = listOf((await _get('/grids/$gamePath', {'dimensions': portraitDimensions, 'types': 'static'}))['data']).map(mapOf);
    return httpsUrl(grids.firstOrNull?['url']);
  }

  Future<String?> coverOf(SourceMatch match) async {
    final name = match.titles.byLanguage.values.firstOrNull;
    if (!isConfigured || match.suggestedType != CategoryType.videoGames || name == null) {
      return null;
    }
    if (match.sourceKey == SteamLibrary.sourceKey) {
      if (await _portraitGridOf('steam/${match.externalWorkId}') case final cover?) {
        return cover;
      }
    }
    final identity = titleIdentityOf(name);
    final found = listOf((await _get('/search/autocomplete/${Uri.encodeComponent(name)}'))['data']).map(mapOf);
    final gameId = found.where((game) => titleIdentityOf(textOf(game['name']) ?? '') == identity).firstOrNull?['id'];
    if (gameId is! int) {
      return null;
    }
    return _portraitGridOf('game/$gameId');
  }
}
