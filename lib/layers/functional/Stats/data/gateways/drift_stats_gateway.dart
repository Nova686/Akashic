import 'package:akashic/layers/functional/Stats/domain/entities/collection_stats.dart';
import 'package:akashic/layers/functional/Stats/domain/gateways/stats_gateway.dart';
import 'package:akashic/layers/technical/LocalDatabase/akashic_database.dart';

class DriftStatsGateway implements StatsGateway {
  DriftStatsGateway(this._database);

  final AkashicDatabase _database;

  @override
  Stream<(List<CopyFact>, Map<String, String>)> watchFacts() {
    return _database.customSelect('SELECT 1', readsFrom: {_database.items, _database.copies, _database.categories}).watch().asyncMap((_) async {
      final items = await _database.select(_database.items).get();
      final categoryOfItem = {for (final item in items) item.id: item.categoryId};
      final copies = await _database.select(_database.copies).get();
      return (
        [
          for (final copy in copies)
            if (categoryOfItem[copy.itemId] case final categoryId?)
              CopyFact(itemId: copy.itemId, categoryId: categoryId, addedAt: copy.createdAt, pricePaidCents: copy.pricePaidCents),
        ],
        categoryOfItem,
      );
    });
  }
}
