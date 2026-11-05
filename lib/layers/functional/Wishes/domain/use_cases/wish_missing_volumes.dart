import 'package:akashic/layers/functional/Catalog/domain/entities/category_type.dart';
import 'package:akashic/layers/functional/Catalog/domain/gateways/category_gateway.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/series.dart';
import 'package:akashic/layers/functional/Wishes/domain/entities/wish.dart';
import 'package:akashic/layers/functional/Wishes/domain/entities/wish_key.dart';
import 'package:akashic/layers/functional/Wishes/domain/gateways/wish_gateway.dart';
import 'package:akashic/layers/functional/Wishes/domain/use_cases/add_wish.dart';

class WishMissingVolumes {
  WishMissingVolumes(this._wishes, this._addWish, this._categories);

  final WishGateway _wishes;
  final AddWish _addWish;
  final CategoryGateway _categories;

  Future<int> call({required Series series, required String seriesTitle, required List<int> missingVolumes}) async {
    final categoryType = (await _categories.findById(series.categoryId))?.type ?? CategoryType.manga;
    final alreadyWished = {
      for (final wish in await _wishes.all())
        if (wish.key.seriesId == series.id) ?wish.key.volumeNumber,
    };
    var added = 0;
    for (final number in missingVolumes) {
      if (alreadyWished.contains(number)) {
        continue;
      }
      await _addWish(WishDraft(
        categoryType: categoryType,
        categoryId: series.categoryId,
        title: seriesTitle,
        creator: series.creator,
        origin: WishOrigin.missingVolume,
        key: WishKey(seriesId: series.id, volumeNumber: number),
      ));
      added++;
    }
    return added;
  }
}
