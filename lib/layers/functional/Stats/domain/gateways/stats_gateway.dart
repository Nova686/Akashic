import 'package:akashic/layers/functional/Stats/domain/entities/collection_stats.dart';

abstract interface class StatsGateway {
  Stream<(List<CopyFact>, Map<String, String>)> watchFacts();
}
