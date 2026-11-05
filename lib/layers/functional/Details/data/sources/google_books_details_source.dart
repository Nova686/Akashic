import 'package:akashic/layers/functional/Collection/domain/entities/collection_item.dart';
import 'package:akashic/layers/functional/Details/data/sources/duration_format.dart';
import 'package:akashic/layers/functional/Details/domain/entities/item_details.dart';
import 'package:akashic/layers/functional/Details/domain/gateways/details_source.dart';
import 'package:akashic/layers/functional/Lookup/data/sources/json_fields.dart';
import 'package:akashic/layers/functional/Lookup/data/sources/source_http.dart';
import 'package:http/http.dart' as http;

class GoogleBooksDetailsSource implements DetailsSource {
  GoogleBooksDetailsSource(this._client, {required this._apiKey});

  static const String _label = 'Google Books';

  final http.Client _client;
  final String _apiKey;

  @override
  bool supports(CollectionItem item) => _apiKey.isNotEmpty && item.sourceKey == 'googlebooks' && (item.externalWorkId?.isNotEmpty ?? false);

  @override
  Future<List<DetailSection>> fetch(CollectionItem item, {required String languageCode, String? editionId}) async {
    final volume = mapOf(await sourceGetJson(
      _client,
      Uri.https('www.googleapis.com', '/books/v1/volumes/${item.externalWorkId}', {if (_apiKey.isNotEmpty) 'key': _apiKey}),
      sourceKey: 'googlebooks',
    ));
    final info = mapOf(volume['volumeInfo']);
    final description = textOf(info['description']);
    final pageUrl = httpsUrl(info['infoLink']);
    return [
      TextSection(kind: TextKind.summary, text: description == null ? '' : stripHtml(description), sourceLabel: _label),
      FactsSection(facts: [
        if (textOf(info['publisher']) case final publisher?) DetailFact(kind: FactKind.publisher, value: publisher),
        if (info['pageCount'] is int && (info['pageCount']! as int) > 0) DetailFact(kind: FactKind.pages, value: '${info['pageCount']}'),
      ], sourceLabel: _label),
      TagSection(tags: [
        for (final category in {for (final entry in listOf(info['categories'])) ...?textOf(entry)?.split(' / ')}) category.trim(),
      ]),
      LinkSection(links: [if (pageUrl != null) DetailLink(label: _label, url: pageUrl)]),
    ];
  }
}
