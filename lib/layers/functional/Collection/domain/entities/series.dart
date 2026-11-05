import 'package:akashic/layers/functional/Collection/domain/entities/localized_titles.dart';
import 'package:equatable/equatable.dart';

class Series extends Equatable {
  const Series({
    required this.id,
    required this.categoryId,
    required this.titles,
    this.creator,
    this.publishedVolumes,
    this.sourceKey,
    this.externalWorkId,
    this.status,
  });

  final String id;
  final String categoryId;
  final LocalizedTitles titles;
  final String? creator;
  final int? publishedVolumes;
  final String? sourceKey;
  final String? externalWorkId;
  final String? status;

  Series copyWith({int? Function()? publishedVolumes, String? Function()? status}) {
    return Series(
      id: id,
      categoryId: categoryId,
      titles: titles,
      creator: creator,
      publishedVolumes: publishedVolumes == null ? this.publishedVolumes : publishedVolumes(),
      sourceKey: sourceKey,
      externalWorkId: externalWorkId,
      status: status == null ? this.status : status(),
    );
  }

  @override
  List<Object?> get props => [id, categoryId, titles, creator, publishedVolumes, sourceKey, externalWorkId, status];
}
