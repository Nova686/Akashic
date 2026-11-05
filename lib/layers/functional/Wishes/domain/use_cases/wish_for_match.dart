import 'package:akashic/layers/functional/Lookup/domain/entities/source_match.dart';
import 'package:akashic/layers/functional/Wishes/domain/entities/wish.dart';
import 'package:akashic/layers/functional/Wishes/domain/entities/wish_key.dart';

WishKey wishKeyForMatch(SourceMatch match, {String? scannedBarcode}) {
  return WishKey(sourceKey: match.sourceKey, externalWorkId: match.externalWorkId, barcode: scannedBarcode ?? match.barcode);
}

WishDraft wishDraftForMatch(SourceMatch match, {required String title, required WishOrigin origin, String? categoryId, String? scannedBarcode}) {
  return WishDraft(
    categoryType: match.suggestedType,
    categoryId: categoryId,
    title: title,
    creator: match.creator,
    imageUrl: match.imageUrl,
    origin: origin,
    key: wishKeyForMatch(match, scannedBarcode: scannedBarcode),
  );
}
