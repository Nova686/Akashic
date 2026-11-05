import 'package:akashic/layers/functional/Wishes/domain/gateways/wish_gateway.dart';

class RemoveWish {
  RemoveWish(this._wishes);

  final WishGateway _wishes;

  Future<void> call(String wishId) => _wishes.remove(wishId);
}
