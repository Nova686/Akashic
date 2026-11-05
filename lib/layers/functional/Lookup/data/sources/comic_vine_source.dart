import 'package:akashic/layers/functional/Catalog/domain/entities/category_type.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/localized_titles.dart';
import 'package:akashic/layers/functional/Lookup/data/sources/json_fields.dart';
import 'package:akashic/layers/functional/Lookup/data/sources/source_http.dart';
import 'package:akashic/layers/functional/Lookup/domain/entities/source_match.dart';
import 'package:akashic/layers/functional/Lookup/domain/entities/source_unavailable.dart';
import 'package:akashic/layers/functional/Lookup/domain/gateways/catalog_source.dart';
import 'package:http/http.dart' as http;

class ComicVineSource implements CatalogSource {
  ComicVineSource(this._client, {required this._apiKey});

  static const String sourceKey = 'comicvine';
  static const int _successStatus = 1;
  static const int _rateLimitedStatus = 107;

  final http.Client _client;
  final String _apiKey;

  @override
  String get key => sourceKey;

  @override
  Set<CategoryType> get types => const {CategoryType.comics};

  @override
  bool get isConfigured => _apiKey.isNotEmpty;

  @override
  bool get supportsBarcode => false;

  Future<Map<String, Object?>> _search(String query) async {
    final Object? answer;
    try {
      answer = await sourceGetJson(
        _client,
        Uri.https('comicvine.gamespot.com', '/api/search/', {
          'api_key': _apiKey,
          'format': 'json',
          'resources': 'volume,issue',
          'query': query.trim(),
          'limit': '20',
          'field_list': 'id,name,start_year,publisher,image,count_of_issues,issue_number,volume,cover_date,resource_type',
        }),
        sourceKey: key,
      );
    } on SourceUnavailable catch (failure) {
      if (failure.reason == 'HTTP 420') {
        throw SourceUnavailable(key, failure.reason, true);
      }
      rethrow;
    }
    final json = mapOf(answer);
    final status = json['status_code'];
    if (status is int && status != _successStatus) {
      throw SourceUnavailable(key, textOf(json['error']) ?? 'status $status', status == _rateLimitedStatus);
    }
    return json;
  }

  @override
  Future<List<SourceMatch>> search(String query) async {
    final json = await _search(query);
    return [
      for (final result in listOf(json['results']).map(mapOf)) ?_matchOf(result),
    ];
  }

  SourceMatch? _matchOf(Map<String, Object?> result) {
    final resultId = result['id'];
    if (resultId is! int) {
      return null;
    }
    final image = mapOf(result['image']);
    final imageUrl = textOf(image['super_url']) ?? textOf(image['original_url']) ?? textOf(image['medium_url']);
    if (textOf(result['resource_type']) == 'issue') {
      final volumeName = textOf(mapOf(result['volume'])['name']);
      final issueNumber = textOf(result['issue_number']);
      final issueName = textOf(result['name']);
      final title = [
        if (volumeName != null) issueNumber == null ? volumeName : '$volumeName #$issueNumber',
        ?issueName,
      ].join(' – ');
      if (title.isEmpty) {
        return null;
      }
      return SourceMatch(
        sourceKey: key,
        externalWorkId: 'issue-$resultId',
        titles: LocalizedTitles(byLanguage: {'en': title}),
        year: yearOf(result['cover_date']),
        seriesTitle: volumeName,
        volumeNumber: int.tryParse(issueNumber ?? ''),
        imageUrl: imageUrl,
        suggestedType: CategoryType.comics,
      );
    }
    final name = textOf(result['name']);
    if (name == null) {
      return null;
    }
    return SourceMatch(
      sourceKey: key,
      externalWorkId: 'volume-$resultId',
      titles: LocalizedTitles(byLanguage: {'en': name}),
      year: yearOf(result['start_year']),
      publisher: textOf(mapOf(result['publisher'])['name']),
      volumeCount: result['count_of_issues'] is int ? result['count_of_issues'] as int : null,
      imageUrl: imageUrl,
      suggestedType: CategoryType.comics,
    );
  }

  @override
  Future<List<SourceMatch>> lookupBarcode(String barcode) async => const [];
}
