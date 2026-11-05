import 'package:akashic/layers/functional/Wishes/domain/entities/wish.dart';
import 'package:akashic/layers/functional/Wishes/domain/gateways/wish_gateway.dart';
import 'package:uuid/uuid.dart';

class AddWish {
  AddWish(this._wishes, {String Function()? newId, DateTime Function()? now})
      : _newId = newId ?? const Uuid().v4,
        _now = now ?? DateTime.now;

  final WishGateway _wishes;
  final String Function() _newId;
  final DateTime Function() _now;

  Future<Wish> call(WishDraft draft) async {
    if (draft.key.isIdentifiable) {
      for (final existing in await _wishes.all()) {
        if (existing.key.matches(draft.key)) {
          return existing;
        }
      }
    }
    final wish = Wish(id: _newId(), draft: draft, createdAt: _now());
    await _wishes.save(wish);
    return wish;
  }
}
