import 'package:akashic/layers/functional/Collection/domain/entities/market_value.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/card_kind.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/item_progress.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/localized_titles.dart';
import 'package:equatable/equatable.dart';

class CollectionItem extends Equatable {
  const CollectionItem({
    required this.id,
    required this.categoryId,
    required this.titles,
    this.seriesId,
    this.volumeNumber,
    this.creator,
    this.year,
    this.publisher,
    this.imagePath,
    this.spineColorValue,
    this.rating,
    this.groupKey,
    this.sourceKey,
    this.externalWorkId,
    this.cardKind,
    this.progress,
    this.addedAt,
    this.marketValue,
    this.preorder,
  });

  final String id;
  final String categoryId;
  final String? seriesId;
  final int? volumeNumber;
  final LocalizedTitles titles;
  final String? creator;
  final int? year;
  final String? publisher;
  final String? imagePath;
  final int? spineColorValue;
  final int? rating;
  final String? groupKey;
  final String? sourceKey;
  final String? externalWorkId;
  final CardKind? cardKind;
  final ItemProgress? progress;
  final DateTime? addedAt;
  final MarketValue? marketValue;
  final Preorder? preorder;

  bool get isPreordered => preorder != null;

  CollectionItem copyWith({int? Function()? rating}) {
    return CollectionItem(
      id: id,
      categoryId: categoryId,
      titles: titles,
      seriesId: seriesId,
      volumeNumber: volumeNumber,
      creator: creator,
      year: year,
      publisher: publisher,
      imagePath: imagePath,
      spineColorValue: spineColorValue,
      rating: rating == null ? this.rating : rating(),
      groupKey: groupKey,
      sourceKey: sourceKey,
      externalWorkId: externalWorkId,
      cardKind: cardKind,
      progress: progress,
      addedAt: addedAt,
      marketValue: marketValue,
      preorder: preorder,
    );
  }

  @override
  List<Object?> get props => [id, categoryId, seriesId, volumeNumber, titles, creator, year, publisher, imagePath, spineColorValue, rating, groupKey, sourceKey, externalWorkId, cardKind, progress, addedAt, marketValue, preorder];
}

class Preorder extends Equatable {
  const Preorder({required this.dueOn, this.depositCents});

  final DateTime dueOn;
  final int? depositCents;

  int daysLeftFrom(DateTime today) => DateTime(dueOn.year, dueOn.month, dueOn.day).difference(DateTime(today.year, today.month, today.day)).inDays;

  @override
  List<Object?> get props => [dueOn, depositCents];
}
