import 'package:akashic/layers/functional/Collection/domain/entities/localized_titles.dart';
import 'package:equatable/equatable.dart';

class OwnedWork extends Equatable {
  const OwnedWork({
    required this.itemId,
    required this.categoryId,
    required this.titles,
    this.creator,
    this.sourceKey,
    this.externalWorkId,
    this.seriesId,
    this.volumeNumber,
    this.barcodes = const {},
    this.rating,
    this.addedAt,
  });

  final String itemId;
  final String categoryId;
  final LocalizedTitles titles;
  final String? creator;
  final String? sourceKey;
  final String? externalWorkId;
  final String? seriesId;
  final int? volumeNumber;
  final Set<String> barcodes;
  final int? rating;
  final DateTime? addedAt;

  @override
  List<Object?> get props => [itemId, categoryId, titles, creator, sourceKey, externalWorkId, seriesId, volumeNumber, barcodes, rating, addedAt];
}
