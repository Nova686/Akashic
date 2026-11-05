import 'package:akashic/layers/functional/Catalog/domain/entities/category_type.dart';
import 'package:akashic/layers/functional/Lookup/domain/entities/source_match.dart';
import 'package:akashic/layers/functional/Lookup/domain/entities/source_unavailable.dart';
import 'package:akashic/layers/functional/Lookup/domain/gateways/catalog_source.dart';

class IsbnWithFallbackSource implements CatalogSource {
  IsbnWithFallbackSource(this._primary, this._fallback);

  final CatalogSource _primary;
  final CatalogSource _fallback;

  @override
  String get key => _primary.key;

  @override
  Set<CategoryType> get types => _primary.types;

  @override
  bool get isConfigured => _primary.isConfigured || _fallback.isConfigured;

  @override
  bool get supportsBarcode => true;

  @override
  Future<List<SourceMatch>> search(String query) async => _primary.isConfigured ? _primary.search(query) : const [];

  @override
  Future<List<SourceMatch>> lookupBarcode(String barcode) async {
    SourceUnavailable? primaryFailure;
    if (_primary.isConfigured) {
      try {
        final matches = await _primary.lookupBarcode(barcode);
        if (matches.isNotEmpty) {
          return matches;
        }
      } on SourceUnavailable catch (failure) {
        primaryFailure = failure;
      }
    }
    if (!_fallback.isConfigured) {
      if (primaryFailure != null) {
        throw primaryFailure;
      }
      return const [];
    }
    return _fallback.lookupBarcode(barcode);
  }
}
