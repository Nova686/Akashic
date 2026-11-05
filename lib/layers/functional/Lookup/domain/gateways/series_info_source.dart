import 'package:akashic/layers/functional/Lookup/domain/entities/series_info.dart';

abstract interface class SeriesInfoSource {
  String get key;
  Future<SeriesInfo?> seriesInfo(String externalWorkId);
}
