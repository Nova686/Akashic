import 'package:akashic/layers/functional/Catalog/domain/entities/category_type.dart';
import 'package:akashic/layers/functional/Lookup/domain/entities/source_match.dart';
import 'package:akashic/layers/functional/Lookup/domain/entities/source_unavailable.dart';
import 'package:akashic/layers/functional/Lookup/domain/gateways/catalog_source.dart';

class SourceWithBackup implements CatalogSource {
  SourceWithBackup(this._primary, this._backup);

  final CatalogSource _primary;
  final CatalogSource _backup;

  @override
  String get key => _primary.key;

  @override
  Set<CategoryType> get types => _primary.types;

  @override
  bool get isConfigured => _primary.isConfigured || _backup.isConfigured;

  @override
  bool get supportsBarcode => _primary.supportsBarcode || _backup.supportsBarcode;

  @override
  Future<List<SourceMatch>> search(String query) => _withBackup((source) => source.search(query));

  @override
  Future<List<SourceMatch>> lookupBarcode(String barcode) =>
      _withBackup((source) => source.supportsBarcode ? source.lookupBarcode(barcode) : Future.value(const <SourceMatch>[]));

  Future<List<SourceMatch>> _withBackup(Future<List<SourceMatch>> Function(CatalogSource source) ask) async {
    if (!_primary.isConfigured) {
      return _backup.isConfigured ? ask(_backup) : const [];
    }
    try {
      return await ask(_primary);
    } on SourceUnavailable {
      if (!_backup.isConfigured) {
        rethrow;
      }
      return ask(_backup);
    }
  }
}
