import 'package:akashic/layers/functional/Catalog/domain/entities/category_type.dart';
import 'package:akashic/layers/functional/Wishes/domain/entities/wish.dart';
import 'package:akashic/layers/functional/Wishes/domain/entities/wish_key.dart';
import 'package:akashic/layers/functional/Wishes/domain/gateways/wish_gateway.dart';
import 'package:akashic/layers/technical/LocalDatabase/akashic_database.dart';
import 'package:drift/drift.dart';

class DriftWishGateway implements WishGateway {
  DriftWishGateway(this._database);

  final AkashicDatabase _database;

  SimpleSelectStatement<$WishesTable, WishRow> get _newestFirst => _database.select(_database.wishes)..orderBy([(table) => OrderingTerm.desc(table.createdAt)]);

  @override
  Stream<List<Wish>> watchAll() => _newestFirst.watch().map((rows) => rows.map(_wishFromRow).toList());

  @override
  Future<List<Wish>> all() async => (await _newestFirst.get()).map(_wishFromRow).toList();

  @override
  Future<void> save(Wish wish) {
    return _database.into(_database.wishes).insertOnConflictUpdate(WishesCompanion.insert(
          id: wish.id,
          categoryType: wish.categoryType.name,
          categoryId: Value(wish.categoryId),
          title: wish.title,
          creator: Value(wish.creator),
          imageUrl: Value(wish.imageUrl),
          sourceKey: Value(wish.key.sourceKey),
          externalWorkId: Value(wish.key.externalWorkId),
          barcode: Value(wish.key.barcode),
          seriesId: Value(wish.key.seriesId),
          volumeNumber: Value(wish.key.volumeNumber),
          origin: wish.origin.name,
          createdAt: Value(wish.createdAt),
          priority: Value(wish.priority.name),
          maxPriceCents: Value(wish.maxPriceCents),
        ));
  }

  @override
  Future<void> savePlan(String wishId, {required WishPriority priority, int? maxPriceCents}) => (_database.update(_database.wishes)..where((table) => table.id.equals(wishId)))
      .write(WishesCompanion(priority: Value(priority.name), maxPriceCents: Value(maxPriceCents)));

  @override
  Future<void> remove(String wishId) => (_database.delete(_database.wishes)..where((table) => table.id.equals(wishId))).go();

  Wish _wishFromRow(WishRow row) {
    return Wish(
      id: row.id,
      createdAt: row.createdAt,
      priority: WishPriority.values.asNameMap()[row.priority] ?? WishPriority.want,
      maxPriceCents: row.maxPriceCents,
      draft: WishDraft(
        categoryType: CategoryType.values.byName(row.categoryType),
        categoryId: row.categoryId,
        title: row.title,
        creator: row.creator,
        imageUrl: row.imageUrl,
        origin: WishOrigin.values.byName(row.origin),
        key: WishKey(
          sourceKey: row.sourceKey,
          externalWorkId: row.externalWorkId,
          barcode: row.barcode,
          seriesId: row.seriesId,
          volumeNumber: row.volumeNumber,
        ),
      ),
    );
  }
}
