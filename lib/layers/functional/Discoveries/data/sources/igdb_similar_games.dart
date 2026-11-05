import 'package:akashic/layers/functional/Catalog/domain/entities/category_type.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/owned_work.dart';
import 'package:akashic/layers/functional/Discoveries/domain/entities/suggestion.dart';
import 'package:akashic/layers/functional/Discoveries/domain/gateways/recommendation_source.dart';
import 'package:akashic/layers/functional/Lookup/data/sources/igdb_source.dart';
import 'package:akashic/layers/functional/Lookup/data/sources/json_fields.dart';

class IgdbSimilarGames implements RecommendationSource {
  IgdbSimilarGames(this._igdb);

  final IgdbSource _igdb;

  @override
  String get key => 'igdb';

  @override
  bool get isConfigured => _igdb.isConfigured;

  @override
  int get maximumSeeds => 8;

  @override
  bool supports(OwnedWork work, CategoryType type) => work.sourceKey == key && int.tryParse(work.externalWorkId ?? '') != null;

  @override
  String queryKeyFor(OwnedWork work) => work.externalWorkId!;

  @override
  Future<List<Suggestion>> recommendationsFor(OwnedWork work, {required String languageCode}) async {
    final game = await _igdb.similarGames(int.parse(work.externalWorkId!));
    return [
      for (final similar in listOf(game['similar_games']).map(mapOf))
        if ((similar['id'], textOf(similar['name'])) case (final int id, final title?))
          Suggestion(
            sourceKey: key,
            externalWorkId: '$id',
            title: title,
            creator: textOf(mapOf(mapOf(listOf(similar['involved_companies']).firstOrNull)['company'])['name']),
            imageUrl: switch (textOf(mapOf(similar['cover'])['image_id'])) {
              final imageId? => 'https://images.igdb.com/igdb/image/upload/t_cover_big/$imageId.jpg',
              null => null,
            },
            year: similar['first_release_date'] is int ? DateTime.fromMillisecondsSinceEpoch((similar['first_release_date']! as int) * 1000, isUtc: true).year : null,
          ),
    ];
  }
}
