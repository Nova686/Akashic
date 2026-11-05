import 'package:akashic/layers/functional/Catalog/domain/entities/category_type.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/localized_titles.dart';
import 'package:akashic/layers/functional/Lookup/data/sources/json_fields.dart';
import 'package:akashic/layers/functional/Lookup/domain/entities/source_match.dart';
import 'package:akashic/layers/functional/Lookup/domain/gateways/catalog_source.dart';
import 'package:akashic/layers/functional/Lookup/data/sources/source_http.dart';
import 'package:akashic/layers/functional/Lookup/domain/entities/source_unavailable.dart';
import 'package:http/http.dart' as http;

class IgdbSource implements CatalogSource {
  IgdbSource(this._client, {required this._clientId, required this._clientSecret, DateTime Function()? now}) : _now = now ?? DateTime.now;

  static const String sourceKey = 'igdb';

  final http.Client _client;
  final String _clientId;
  final String _clientSecret;
  final DateTime Function() _now;
  String? _accessToken;
  DateTime? _tokenExpiry;

  @override
  String get key => sourceKey;

  @override
  Set<CategoryType> get types => const {CategoryType.videoGames};

  @override
  bool get isConfigured => _clientId.isNotEmpty && _clientSecret.isNotEmpty;

  @override
  bool get supportsBarcode => false;

  Future<String>? _pendingToken;

  Future<String> _token() {
    final expiry = _tokenExpiry;
    final cached = _accessToken;
    if (cached != null && expiry != null && _now().isBefore(expiry)) {
      return Future.value(cached);
    }
    return _pendingToken ??= _requestToken().whenComplete(() => _pendingToken = null);
  }

  Future<String> _requestToken() async {
    final uri = Uri.https('id.twitch.tv', '/oauth2/token', {'client_id': _clientId, 'client_secret': _clientSecret, 'grant_type': 'client_credentials'});
    final json = mapOf(await sourcePostForm(_client, uri, sourceKey: key, body: ''));
    final token = textOf(json['access_token']);
    if (token == null) {
      throw const SourceUnavailable(sourceKey, 'no token');
    }
    final lifetime = json['expires_in'] is int ? json['expires_in']! as int : 3600;
    _accessToken = token;
    _tokenExpiry = _now().add(Duration(seconds: lifetime - 60));
    return token;
  }

  @override
  Future<List<SourceMatch>> search(String query) async {
    if (!isConfigured) {
      return const [];
    }
    final token = await _token();
    final escaped = query.replaceAll('"', '');
    final response = await sourcePostForm(
      _client,
      Uri.https('api.igdb.com', '/v4/games'),
      sourceKey: key,
      headers: {'Client-ID': _clientId, 'Authorization': 'Bearer $token', 'Accept': 'application/json'},
      body: 'search "$escaped"; fields name,first_release_date,involved_companies.company.name,platforms.name,cover.image_id; limit 10;',
    );
    return [
      for (final game in listOf(response).map(mapOf))
        if (textOf(game['name']) != null && game['id'] != null) _toMatch(game),
    ];
  }

  SourceMatch _toMatch(Map<String, Object?> game) {
    final releaseSeconds = game['first_release_date'];
    final imageId = textOf(mapOf(game['cover'])['image_id']);
    return SourceMatch(
      sourceKey: key,
      externalWorkId: '${game['id']}',
      titles: LocalizedTitles(byLanguage: {'en': textOf(game['name'])!}),
      creator: textOf(mapOf(mapOf(listOf(game['involved_companies']).firstOrNull)['company'])['name']),
      year: releaseSeconds is int ? DateTime.fromMillisecondsSinceEpoch(releaseSeconds * 1000, isUtc: true).year : null,
      platform: textOf(mapOf(listOf(game['platforms']).firstOrNull)['name']),
      imageUrl: imageId == null ? null : 'https://images.igdb.com/igdb/image/upload/t_cover_big/$imageId.jpg',
      suggestedType: CategoryType.videoGames,
    );
  }

  Future<List<Map<String, Object?>>> platforms(String query) async {
    if (!isConfigured) {
      return const [];
    }
    final token = await _token();
    final escaped = query.replaceAll('"', '');
    final response = await sourcePostForm(
      _client,
      Uri.https('api.igdb.com', '/v4/platforms'),
      sourceKey: key,
      headers: {'Client-ID': _clientId, 'Authorization': 'Bearer $token', 'Accept': 'application/json'},
      body: 'search "$escaped"; fields name,abbreviation,platform_logo.image_id,versions.platform_logo.image_id,versions.platform_version_release_dates.date,'
          'versions.companies.company.name,versions.companies.manufacturer; limit 15;',
    );
    return listOf(response).map(mapOf).toList();
  }

  Future<Map<String, Object?>> gameDetails(int id) async {
    final token = await _token();
    final response = await sourcePostForm(
      _client,
      Uri.https('api.igdb.com', '/v4/games'),
      sourceKey: key,
      headers: {'Client-ID': _clientId, 'Authorization': 'Bearer $token', 'Accept': 'application/json'},
      body: 'fields summary,platforms.name,involved_companies.company.name; where id = $id;',
    );
    return mapOf(listOf(response).firstOrNull);
  }

  Future<Map<String, Object?>> similarGames(int id) async {
    final token = await _token();
    final response = await sourcePostForm(
      _client,
      Uri.https('api.igdb.com', '/v4/games'),
      sourceKey: key,
      headers: {'Client-ID': _clientId, 'Authorization': 'Bearer $token', 'Accept': 'application/json'},
      body: 'fields similar_games.name,similar_games.cover.image_id,similar_games.first_release_date,similar_games.involved_companies.company.name; where id = $id;',
    );
    return mapOf(listOf(response).firstOrNull);
  }

  @override
  Future<List<SourceMatch>> lookupBarcode(String barcode) async => const [];
}
