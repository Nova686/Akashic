import 'package:akashic/layers/functional/Collection/domain/entities/collection_item.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/localized_titles.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/series.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/shelf_group.dart';

CollectionItem buildItem({
  String id = 'item',
  String categoryId = 'category',
  Map<String, String> titles = const {},
  String? originalLanguage,
  String? creator,
  String? groupKey,
  String? seriesId,
  int? volumeNumber,
}) {
  return CollectionItem(
    id: id,
    categoryId: categoryId,
    titles: LocalizedTitles(byLanguage: titles, originalLanguage: originalLanguage),
    creator: creator,
    groupKey: groupKey,
    seriesId: seriesId,
    volumeNumber: volumeNumber,
  );
}

const Series frieren = Series(
  id: 'frieren',
  categoryId: 'mangas',
  titles: LocalizedTitles(byLanguage: {'fr': 'Frieren', 'ja': '葬送のフリーレン'}, originalLanguage: 'ja'),
);

CollectionItem vol(int number) => buildItem(id: 'frieren-$number', categoryId: 'mangas', seriesId: 'frieren', volumeNumber: number);

String describe(ShelfEntry entry) => switch (entry) {
      ShelfDivider(:final label) => 'divider:$label',
      ShelfItem(:final item) => 'item:${item.volumeNumber ?? item.id}',
      ShelfMissingVolume(:final volumeNumber) => 'missing:$volumeNumber',
      ShelfGap() => 'gap',
    };
