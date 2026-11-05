import 'package:akashic/layers/functional/Wishes/domain/entities/wish.dart';

abstract interface class WishGateway {
  Stream<List<Wish>> watchAll();
  Future<List<Wish>> all();
  Future<void> save(Wish wish);
  Future<void> remove(String wishId);
  Future<void> savePlan(String wishId, {required WishPriority priority, int? maxPriceCents});
}
