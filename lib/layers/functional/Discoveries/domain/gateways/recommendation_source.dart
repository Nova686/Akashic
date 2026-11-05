import 'package:akashic/layers/functional/Catalog/domain/entities/category_type.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/owned_work.dart';
import 'package:akashic/layers/functional/Discoveries/domain/entities/suggestion.dart';

abstract interface class RecommendationSource {
  String get key;
  bool get isConfigured;
  int get maximumSeeds;
  bool supports(OwnedWork work, CategoryType type);
  String queryKeyFor(OwnedWork work);
  Future<List<Suggestion>> recommendationsFor(OwnedWork work, {required String languageCode});
}
