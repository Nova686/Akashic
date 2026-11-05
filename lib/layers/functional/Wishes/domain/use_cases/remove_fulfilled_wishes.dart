import 'package:akashic/layers/functional/Collection/domain/entities/owned_work.dart';
import 'package:akashic/layers/functional/Collection/domain/use_cases/work_identity.dart';
import 'package:akashic/layers/functional/Wishes/domain/entities/wish.dart';
import 'package:akashic/layers/functional/Wishes/domain/entities/wish_key.dart';
import 'package:akashic/layers/functional/Wishes/domain/gateways/wish_gateway.dart';

class RemoveFulfilledWishes {
  RemoveFulfilledWishes(this._wishes);

  final WishGateway _wishes;

  Future<List<Wish>> call(List<OwnedWork> ownedWorks) async {
    final pending = await _wishes.all();
    if (pending.isEmpty) {
      return const [];
    }
    final ownedKeys = [for (final work in ownedWorks) ..._keysOf(work)];
    final fulfilled = [
      for (final wish in pending)
        if (ownedKeys.any(wish.fulfillmentKey.matches)) wish,
    ];
    for (final wish in fulfilled) {
      await _wishes.remove(wish.id);
    }
    return fulfilled;
  }

  Iterable<WishKey> _keysOf(OwnedWork work) sync* {
    yield WishKey(sourceKey: work.sourceKey, externalWorkId: work.externalWorkId, seriesId: work.seriesId, volumeNumber: work.volumeNumber);
    for (final barcode in work.barcodes) {
      yield WishKey(barcode: barcode);
    }
    if (work.seriesId == null) {
      for (final title in work.titles.byLanguage.values) {
        yield WishKey(workIdentity: workIdentityOf(title, work.creator));
      }
    }
  }
}
