import 'package:akashic/layers/functional/Catalog/domain/entities/category_type.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/localized_titles.dart';
import 'package:equatable/equatable.dart';

class SourceMatch extends Equatable {
  const SourceMatch({
    required this.sourceKey,
    required this.externalWorkId,
    required this.titles,
    required this.suggestedType,
    this.externalEditionId,
    this.creator,
    this.year,
    this.publisher,
    this.barcode,
    this.imageUrl,
    this.format,
    this.seriesTitle,
    this.volumeNumber,
    this.platform,
    this.volumeCount,
    this.status,
  });

  final String sourceKey;
  final String externalWorkId;
  final String? externalEditionId;
  final LocalizedTitles titles;
  final String? creator;
  final int? year;
  final String? publisher;
  final String? barcode;
  final String? imageUrl;
  final String? format;
  final String? seriesTitle;
  final int? volumeNumber;
  final String? platform;
  final int? volumeCount;
  final String? status;
  final CategoryType suggestedType;

  SourceMatch withImageUrl(String coverUrl) => SourceMatch(
        sourceKey: sourceKey,
        externalWorkId: externalWorkId,
        externalEditionId: externalEditionId,
        titles: titles,
        creator: creator,
        year: year,
        publisher: publisher,
        barcode: barcode,
        imageUrl: coverUrl,
        format: format,
        seriesTitle: seriesTitle,
        volumeNumber: volumeNumber,
        platform: platform,
        volumeCount: volumeCount,
        status: status,
        suggestedType: suggestedType,
      );

  SourceMatch withBarcode(String scannedBarcode) => SourceMatch(
        sourceKey: sourceKey,
        externalWorkId: externalWorkId,
        externalEditionId: externalEditionId,
        titles: titles,
        creator: creator,
        year: year,
        publisher: publisher,
        barcode: scannedBarcode,
        imageUrl: imageUrl,
        format: format,
        seriesTitle: seriesTitle,
        volumeNumber: volumeNumber,
        platform: platform,
        volumeCount: volumeCount,
        status: status,
        suggestedType: suggestedType,
      );

  @override
  List<Object?> get props => [
        sourceKey,
        externalWorkId,
        externalEditionId,
        titles,
        creator,
        year,
        publisher,
        barcode,
        imageUrl,
        format,
        seriesTitle,
        volumeNumber,
        platform,
        volumeCount,
        status,
        suggestedType,
      ];
}
