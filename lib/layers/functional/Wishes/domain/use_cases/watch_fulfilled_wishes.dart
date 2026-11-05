import 'dart:async';

import 'package:akashic/layers/functional/Collection/domain/entities/owned_work.dart';
import 'package:akashic/layers/functional/Collection/domain/gateways/collection_gateway.dart';
import 'package:akashic/layers/functional/Wishes/domain/entities/wish.dart';
import 'package:akashic/layers/functional/Wishes/domain/gateways/wish_gateway.dart';
import 'package:akashic/layers/functional/Wishes/domain/use_cases/remove_fulfilled_wishes.dart';

class WatchFulfilledWishes {
  WatchFulfilledWishes(this._collection, this._wishes, this._removeFulfilledWishes);

  final CollectionGateway _collection;
  final WishGateway _wishes;
  final RemoveFulfilledWishes _removeFulfilledWishes;

  Stream<List<Wish>> call() {
    late final StreamController<List<Wish>> fulfilled;
    StreamSubscription<List<OwnedWork>>? ownedSubscription;
    StreamSubscription<List<Wish>>? wishesSubscription;
    List<OwnedWork>? latestOwned;
    var pendingWishes = false;
    var isChecking = false;
    var needsAnotherCheck = false;

    Future<void> check() async {
      if (isChecking) {
        needsAnotherCheck = true;
        return;
      }
      isChecking = true;
      try {
        do {
          needsAnotherCheck = false;
          final owned = latestOwned;
          if (owned == null || !pendingWishes) {
            break;
          }
          final removed = await _removeFulfilledWishes(owned);
          if (removed.isNotEmpty && !fulfilled.isClosed) {
            fulfilled.add(removed);
          }
        } while (needsAnotherCheck);
      } on Exception {
        needsAnotherCheck = false;
      } finally {
        isChecking = false;
      }
    }

    fulfilled = StreamController<List<Wish>>(
      onListen: () {
        wishesSubscription = _wishes.watchAll().listen((wishes) {
          pendingWishes = wishes.isNotEmpty;
          if (pendingWishes) {
            ownedSubscription ??= _collection.watchOwnedWorks().listen((owned) {
              latestOwned = owned;
              check();
            });
            check();
          } else {
            ownedSubscription?.cancel();
            ownedSubscription = null;
            latestOwned = null;
          }
        });
      },
      onCancel: () async {
        await ownedSubscription?.cancel();
        await wishesSubscription?.cancel();
      },
    );
    return fulfilled.stream;
  }
}
