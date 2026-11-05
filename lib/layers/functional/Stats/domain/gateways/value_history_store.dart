import 'package:akashic/layers/functional/Stats/domain/entities/value_history.dart';

abstract interface class ValueHistoryStore {
  Future<List<ValueSnapshot>> snapshots();
  Future<bool> hasSnapshot(DateTime month);
  Future<void> save(ValueSnapshot snapshot, Map<String, (int, String)> valuesByItem);
  Future<Map<String, (int, String)>> itemValuesAt(DateTime month);
}
