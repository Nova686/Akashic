import 'package:akashic/layers/functional/Collection/domain/entities/collection_item.dart';
import 'package:akashic/layers/functional/Details/domain/entities/item_details.dart';
import 'package:akashic/layers/functional/Details/domain/gateways/details_source.dart';
import 'package:akashic/layers/functional/Lookup/data/sources/igdb_source.dart';
import 'package:akashic/layers/functional/Lookup/data/sources/json_fields.dart';

class IgdbDetailsSource implements DetailsSource {
  IgdbDetailsSource(this._igdb);

  final IgdbSource _igdb;

  @override
  bool supports(CollectionItem item) => _igdb.isConfigured && item.sourceKey == 'igdb' && int.tryParse(item.externalWorkId ?? '') != null;

  @override
  Future<List<DetailSection>> fetch(CollectionItem item, {required String languageCode, String? editionId}) async {
    final game = await _igdb.gameDetails(int.parse(item.externalWorkId!));
    final platforms = [for (final platform in listOf(game['platforms']).map(mapOf)) ?textOf(platform['name'])];
    final studio = textOf(mapOf(mapOf(listOf(game['involved_companies']).firstOrNull)['company'])['name']);
    return [
      TextSection(kind: TextKind.summary, text: textOf(game['summary']) ?? '', sourceLabel: 'IGDB'),
      FactsSection(facts: [
        if (studio != null) DetailFact(kind: FactKind.studio, value: studio),
        if (platforms.isNotEmpty) DetailFact(kind: FactKind.platforms, value: platforms.join(', ')),
      ], sourceLabel: 'IGDB'),
    ];
  }
}
