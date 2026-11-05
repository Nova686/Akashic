import 'package:akashic/layers/functional/Collection/domain/entities/market_value.dart';
import 'package:akashic/layers/functional/Lookup/data/sources/json_fields.dart';
import 'package:akashic/layers/functional/Lookup/data/sources/source_http.dart';
import 'package:akashic/layers/functional/Lookup/domain/gateways/record_market.dart';
import 'package:http/http.dart' as http;

class DiscogsMarketplace implements RecordMarket {
  DiscogsMarketplace(this._client, {required this._token, DateTime Function()? now}) : _now = now ?? DateTime.now;

  static const String sourceKey = 'discogs';
  static const String currency = 'EUR';

  final http.Client _client;
  final String _token;
  final DateTime Function() _now;

  Map<String, String> get _headers => {if (_token.isNotEmpty) 'Authorization': 'Discogs token=$_token'};

  @override
  bool get isConfigured => true;

  @override
  Future<MarketValue?> lowestPriceOf(String releaseId) async {
    final stats = mapOf(await sourceGetJson(_client, Uri.https('api.discogs.com', '/marketplace/stats/$releaseId', {'curr_abbr': currency}), sourceKey: sourceKey, headers: _headers));
    final lowest = mapOf(stats['lowest_price']);
    final cents = centsOf(lowest['value']);
    return cents == null ? null : MarketValue(cents: cents, currency: textOf(lowest['currency']) ?? currency, valuedAt: _now());
  }

  @override
  Future<String?> mainReleaseOf(String masterId) async {
    final master = mapOf(await sourceGetJson(_client, Uri.https('api.discogs.com', '/masters/$masterId'), sourceKey: sourceKey, headers: _headers));
    final mainRelease = master['main_release'];
    return mainRelease is int ? '$mainRelease' : null;
  }
}
