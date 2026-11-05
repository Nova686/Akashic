import 'package:akashic/layers/functional/Lookup/domain/entities/source_match.dart';

abstract interface class ImageSearch {
  Future<List<String>> imagesFor(SourceMatch? match, String query);
}
