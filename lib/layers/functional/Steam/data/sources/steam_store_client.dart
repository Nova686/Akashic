import 'package:akashic/layers/functional/Lookup/data/sources/json_fields.dart';
import 'package:akashic/layers/functional/Lookup/data/sources/source_http.dart';
import 'package:akashic/layers/functional/Steam/domain/entities/steam_store_page.dart';
import 'package:akashic/layers/functional/Steam/domain/gateways/steam_store_api.dart';
import 'package:http/http.dart' as http;

String? plainTextOf(Object? html) {
  final text = textOf(html);
  if (text == null) {
    return null;
  }
  final plain = text
      .replaceAll(RegExp(r'<br\s*/?>|</li>|</p>', caseSensitive: false), '\n')
      .replaceAll(RegExp(r'<[^>]+>'), '')
      .replaceAll('&nbsp;', ' ')
      .replaceAll(' ', ' ')
      .replaceAll('&amp;', '&')
      .replaceAll('&quot;', '"')
      .replaceAll('&#39;', "'")
      .split('\n')
      .map((line) => line.trim())
      .where((line) => line.isNotEmpty)
      .join('\n');
  return plain.isEmpty ? null : plain;
}

SteamPrice? steamPriceOf(Object? json) {
  final price = mapOf(json);
  if ((price['initial'], price['final'], textOf(price['currency'])) case (final int initial, final int finalCents, final currency?)) {
    return SteamPrice(initialCents: initial, finalCents: finalCents, discountPercent: price['discount_percent'] is int ? price['discount_percent']! as int : 0, currency: currency);
  }
  return null;
}

class SteamStoreClient implements SteamStoreApi {
  SteamStoreClient(this._storeClient, this._apiClient, {this.countryCode = 'fr', this.language = 'french'});

  static const String storeSourceKey = 'steamstore';
  static const String newsSourceKey = 'steam';
  static const int newsCount = 15;

  final http.Client _storeClient;
  final http.Client _apiClient;
  final String countryCode;
  final String language;

  Future<Map<String, Object?>?> _appDetails(String appId) async {
    final json = mapOf(await sourceGetJson(_storeClient, Uri.https('store.steampowered.com', '/api/appdetails', {'appids': appId, 'cc': countryCode, 'l': language}), sourceKey: storeSourceKey));
    final entry = mapOf(json[appId]);
    return entry['success'] == true ? mapOf(entry['data']) : null;
  }

  List<String> _descriptions(Object? list) => [for (final entry in listOf(list).map(mapOf)) ?textOf(entry['description'])];

  @override
  Future<SteamStorePage?> storePage(String appId) async {
    final data = await _appDetails(appId);
    final name = textOf(data?['name']);
    if (data == null || name == null) {
      return null;
    }
    final release = mapOf(data['release_date']);
    final trailer = listOf(data['movies']).map(mapOf).firstOrNull;
    final requirements = mapOf(data['pc_requirements']);
    return SteamStorePage(
      appId: appId,
      name: name,
      shortDescription: plainTextOf(data['short_description']),
      genres: _descriptions(data['genres']),
      features: _descriptions(data['categories']),
      developers: [for (final developer in listOf(data['developers'])) ?textOf(developer)],
      publishers: [for (final publisher in listOf(data['publishers'])) ?textOf(publisher)],
      releaseDate: textOf(release['date']),
      isComingSoon: release['coming_soon'] == true,
      screenshots: [
        for (final screenshot in listOf(data['screenshots']).map(mapOf))
          if ((httpsUrl(screenshot['path_thumbnail']), httpsUrl(screenshot['path_full'])) case (final thumbnail?, final full?)) SteamScreenshot(thumbnailUrl: thumbnail, fullUrl: full),
      ],
      trailerThumbnailUrl: httpsUrl(trailer?['thumbnail']),
      trailerName: textOf(trailer?['name']),
      price: steamPriceOf(data['price_overview']),
      isFree: data['is_free'] == true,
      minimumRequirements: plainTextOf(requirements['minimum']),
      recommendedRequirements: plainTextOf(requirements['recommended']),
      languages: plainTextOf(data['supported_languages']),
      dlcIds: [for (final dlcId in listOf(data['dlc'])) if (dlcId is int) '$dlcId'],
    );
  }

  @override
  Future<List<SteamNews>> news(String appId) async {
    final json = mapOf(await sourceGetJson(_apiClient, Uri.https('api.steampowered.com', '/ISteamNews/GetNewsForApp/v2/', {'appid': appId, 'count': '$newsCount', 'maxlength': '240'}), sourceKey: newsSourceKey));
    return [
      for (final item in listOf(mapOf(json['appnews'])['newsitems']).map(mapOf))
        if ((textOf(item['title']), httpsUrl(item['url']), item['date']) case (final title?, final url?, final int seconds))
          SteamNews(
            title: title,
            url: url,
            publishedAt: DateTime.fromMillisecondsSinceEpoch(seconds * 1000, isUtc: true),
            feedLabel: textOf(item['feedlabel']),
            snippet: plainTextOf(item['contents']),
          ),
    ];
  }

  @override
  Future<SteamDlc?> dlc(String appId) async {
    final data = await _appDetails(appId);
    final name = textOf(data?['name']);
    if (data == null || name == null) {
      return null;
    }
    final release = mapOf(data['release_date']);
    return SteamDlc(
      appId: appId,
      name: name,
      imageUrl: httpsUrl(data['header_image']),
      price: steamPriceOf(data['price_overview']),
      isFree: data['is_free'] == true,
      releaseDate: textOf(release['date']),
      isComingSoon: release['coming_soon'] == true,
    );
  }
}
