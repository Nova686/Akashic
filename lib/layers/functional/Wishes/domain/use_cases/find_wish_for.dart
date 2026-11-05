import 'package:akashic/layers/functional/Wishes/domain/entities/wish.dart';
import 'package:akashic/layers/functional/Wishes/domain/entities/wish_key.dart';
import 'package:akashic/layers/functional/Wishes/domain/gateways/wish_gateway.dart';

class FindWishFor {
  FindWishFor(this._wishes);

  final WishGateway _wishes;

  Future<Wish?> call(WishKey key) async {
    if (!key.isIdentifiable) {
      return null;
    }
    for (final wish in await _wishes.all()) {
      if (wish.key.matches(key)) {
        return wish;
      }
    }
    return null;
  }
}
