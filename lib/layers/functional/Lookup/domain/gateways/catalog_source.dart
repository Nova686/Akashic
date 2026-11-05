import 'package:akashic/layers/functional/Catalog/domain/entities/category_type.dart';
import 'package:akashic/layers/functional/Lookup/domain/entities/source_match.dart';

abstract interface class CatalogSource {
  String get key;
  Set<CategoryType> get types;
  bool get isConfigured;
  bool get supportsBarcode;
  Future<List<SourceMatch>> search(String query);
  Future<List<SourceMatch>> lookupBarcode(String barcode);
}
