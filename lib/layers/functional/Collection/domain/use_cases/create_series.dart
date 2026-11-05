import 'package:akashic/layers/functional/Collection/domain/entities/localized_titles.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/series.dart';
import 'package:akashic/layers/functional/Collection/domain/gateways/collection_gateway.dart';
import 'package:uuid/uuid.dart';

class CreateSeries {
  CreateSeries(this._collection, {String Function()? newId}) : _newId = newId ?? const Uuid().v4;

  final CollectionGateway _collection;
  final String Function() _newId;

  Future<Series> call({
    required String categoryId,
    required LocalizedTitles titles,
    String? creator,
    String? sourceKey,
    String? externalWorkId,
    int? publishedVolumes,
    String? status,
  }) async {
    final series = Series(
      id: _newId(),
      categoryId: categoryId,
      titles: titles,
      creator: creator,
      sourceKey: sourceKey,
      externalWorkId: externalWorkId,
      publishedVolumes: publishedVolumes,
      status: status,
    );
    await _collection.saveSeries(series);
    return series;
  }
}
