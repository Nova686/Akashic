import 'package:akashic/layers/functional/Catalog/domain/entities/category_type.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/localized_titles.dart';
import 'package:akashic/layers/functional/Import/domain/use_cases/import_account_library.dart';
import 'package:akashic/layers/functional/Lookup/data/sources/json_fields.dart';
import 'package:akashic/layers/functional/Lookup/data/sources/rebrickable_source.dart';
import 'package:akashic/layers/functional/Lookup/data/sources/source_http.dart';
import 'package:akashic/layers/functional/Lookup/domain/entities/source_match.dart';
import 'package:akashic/layers/functional/Lookup/domain/entities/source_unavailable.dart';
import 'package:http/http.dart' as http;

class RebrickableCollectionLibrary implements AccountLibrary {
  RebrickableCollectionLibrary(this._client, {required this._apiKey});

  static const int maximumPages = 50;
  static const Set<String> _refusals = {'HTTP 400', 'HTTP 401', 'HTTP 403'};

  final http.Client _client;
  final String _apiKey;

  @override
  LibraryService get service => LibraryService.rebrickable;

  @override
  CategoryType get categoryType => CategoryType.lego;

  @override
  bool get isConfigured => _apiKey.isNotEmpty;

  @override
  AccountField get accountField => AccountField.accountAndPassword;

  Map<String, String> get _headers => {'Authorization': 'key $_apiKey', 'Accept': 'application/json'};

  Future<String> _userTokenOf(String accountName, String password) async {
    final Object? json;
    try {
      json = await sourcePostForm(
        _client,
        Uri.https('rebrickable.com', '/api/v3/users/_token/'),
        sourceKey: RebrickableSource.sourceKey,
        body: Uri(queryParameters: {'username': accountName, 'password': password}).query,
        headers: {..._headers, 'Content-Type': 'application/x-www-form-urlencoded'},
      );
    } on SourceUnavailable catch (failure) {
      if (_refusals.contains(failure.reason)) {
        throw const LibraryNotFound(LibraryService.rebrickable);
      }
      rethrow;
    }
    return textOf(mapOf(json)['user_token']) ?? (throw const LibraryNotFound(LibraryService.rebrickable));
  }

  @override
  Future<List<LibraryEntry>> entriesOf(String accountName, {String password = ''}) async {
    final userToken = await _userTokenOf(accountName, password);
    final entries = <LibraryEntry>[];
    final seenSets = <String>{};
    Uri? next = Uri.https('rebrickable.com', '/api/v3/users/${Uri.encodeComponent(userToken)}/sets/', {'page_size': '1000'});
    for (var page = 0; next != null && page < maximumPages; page++) {
      final body = mapOf(await sourceGetJson(_client, next, sourceKey: RebrickableSource.sourceKey, headers: _headers));
      for (final owned in listOf(body['results']).map(mapOf)) {
        final set = mapOf(owned['set']);
        if ((textOf(set['set_num']), textOf(set['name'])) case (final setNumber?, final name?) when seenSets.add(setNumber)) {
          final pieces = set['num_parts'];
          entries.add(LibraryEntry(SourceMatch(
            sourceKey: RebrickableSource.sourceKey,
            externalWorkId: setNumber,
            titles: LocalizedTitles(byLanguage: {'en': '$name (${setNumber.replaceFirst(RegExp(r'-1$'), '')})'}),
            year: yearOf(set['year']),
            format: pieces is int && pieces > 0 ? '$pieces pcs' : null,
            imageUrl: textOf(set['set_img_url']),
            suggestedType: CategoryType.lego,
          )));
        }
      }
      next = switch (textOf(body['next'])) {
        final nextPage? => Uri.tryParse(nextPage),
        null => null,
      };
    }
    return entries;
  }
}
