import 'package:akashic/layers/functional/Catalog/domain/entities/category_type.dart';
import 'package:akashic/layers/functional/Collection/domain/use_cases/work_identity.dart';
import 'package:akashic/layers/functional/Wishes/domain/entities/wish_key.dart';
import 'package:equatable/equatable.dart';

enum WishOrigin { discovery, search, missingVolume, manual, steamWishlist }

class WishDraft extends Equatable {
  const WishDraft({
    required this.categoryType,
    required this.title,
    required this.origin,
    this.key = const WishKey(),
    this.categoryId,
    this.creator,
    this.imageUrl,
  });

  final CategoryType categoryType;
  final String? categoryId;
  final String title;
  final String? creator;
  final String? imageUrl;
  final WishKey key;
  final WishOrigin origin;

  @override
  List<Object?> get props => [categoryType, categoryId, title, creator, imageUrl, key, origin];
}

enum WishPriority { mustHave, want, someday }

class Wish extends Equatable {
  const Wish({required this.id, required this.draft, required this.createdAt, this.priority = WishPriority.want, this.maxPriceCents});

  final String id;
  final WishDraft draft;
  final DateTime createdAt;
  final WishPriority priority;
  final int? maxPriceCents;

  CategoryType get categoryType => draft.categoryType;
  String? get categoryId => draft.categoryId;
  String get title => draft.title;
  String? get creator => draft.creator;
  String? get imageUrl => draft.imageUrl;
  WishKey get key => draft.key;
  WishOrigin get origin => draft.origin;

  WishKey get fulfillmentKey => WishKey(
        sourceKey: key.sourceKey,
        externalWorkId: key.externalWorkId,
        barcode: key.barcode,
        seriesId: key.seriesId,
        volumeNumber: key.volumeNumber,
        workIdentity: key.hasVolumeIdentity ? null : workIdentityOf(title, creator),
      );

  @override
  List<Object?> get props => [id, draft, createdAt, priority, maxPriceCents];
}
