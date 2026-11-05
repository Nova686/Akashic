import 'package:akashic/layers/functional/Catalog/domain/entities/category_type.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/localized_titles.dart';
import 'package:akashic/layers/functional/Lookup/data/sources/source_http.dart';
import 'package:akashic/layers/functional/Lookup/domain/entities/source_match.dart';
import 'package:akashic/layers/functional/Lookup/domain/entities/source_unavailable.dart';
import 'package:akashic/layers/functional/Lookup/domain/gateways/catalog_source.dart';
import 'package:http/http.dart' as http;
import 'package:xml/xml.dart';

class BoardGameGeekSource implements CatalogSource {
  BoardGameGeekSource(this._client, {required this._token});

  static const String sourceKey = 'boardgamegeek';
  static const int _detailedResults = 15;

  final http.Client _client;
  final String _token;

  @override
  String get key => sourceKey;

  @override
  Set<CategoryType> get types => const {CategoryType.boardGames};

  @override
  bool get isConfigured => _token.isNotEmpty;

  @override
  bool get supportsBarcode => false;

  Map<String, String> get _headers => {'Authorization': 'Bearer $_token'};

  Future<XmlDocument> _get(String path, Map<String, String> parameters) async {
    final body = await sourceGetText(_client, Uri.https('boardgamegeek.com', '/xmlapi2/$path', parameters), sourceKey: key, headers: _headers);
    try {
      return XmlDocument.parse(body ?? '<items/>');
    } on XmlException catch (failure) {
      throw SourceUnavailable(key, 'unreadable answer: ${failure.message}');
    }
  }

  @override
  Future<List<SourceMatch>> search(String query) async {
    final found = await _get('search', {'query': query.trim(), 'type': 'boardgame,boardgameexpansion'});
    final gameIds = [
      for (final item in found.findAllElements('item')) ?item.getAttribute('id'),
    ].take(_detailedResults).toList();
    if (gameIds.isEmpty) {
      return const [];
    }
    final details = await _get('thing', {'id': gameIds.join(',')});
    final detailsById = {
      for (final item in details.findAllElements('item')) ?item.getAttribute('id'): item,
    };
    return [
      for (final gameId in gameIds)
        if (detailsById[gameId] case final item?) ?_matchOf(gameId, item),
    ];
  }

  SourceMatch? _matchOf(String gameId, XmlElement item) {
    final names = item.findElements('name');
    final primaryName = names.where((name) => name.getAttribute('type') == 'primary').firstOrNull ?? names.firstOrNull;
    final title = primaryName?.getAttribute('value');
    if (title == null || title.isEmpty) {
      return null;
    }
    List<String> linked(String kind) => [
          for (final link in item.findElements('link'))
            if (link.getAttribute('type') == kind) ?link.getAttribute('value'),
        ];
    final designers = linked('boardgamedesigner');
    final image = item.findElements('image').firstOrNull?.innerText.trim();
    return SourceMatch(
      sourceKey: key,
      externalWorkId: gameId,
      titles: LocalizedTitles(byLanguage: {'en': title}),
      creator: designers.isEmpty ? null : designers.take(3).join(', '),
      year: int.tryParse(item.findElements('yearpublished').firstOrNull?.getAttribute('value') ?? ''),
      publisher: linked('boardgamepublisher').firstOrNull,
      imageUrl: image == null || image.isEmpty ? null : image,
      suggestedType: CategoryType.boardGames,
    );
  }

  @override
  Future<List<SourceMatch>> lookupBarcode(String barcode) async => const [];
}
