import 'package:akashic/layers/functional/Catalog/domain/entities/category.dart';
import 'package:akashic/layers/functional/Catalog/domain/entities/category_type.dart';
import 'package:akashic/layers/functional/Lookup/domain/entities/card_game.dart';
import 'package:akashic/layers/functional/Lookup/domain/gateways/catalog_source.dart';

const Set<CategoryType> _printedTypes = {CategoryType.books, CategoryType.comics, CategoryType.manga};

bool isIsbn13(String normalizedBarcode) =>
    normalizedBarcode.length == 13 && (normalizedBarcode.startsWith('978') || normalizedBarcode.startsWith('979'));

class SourceRegistry {
  SourceRegistry(this._sources, {this._barcodeFallbacks = const []});

  final List<CatalogSource> _sources;
  final List<CatalogSource> _barcodeFallbacks;

  List<CatalogSource> barcodeFallbacksFor(String normalizedBarcode) =>
      isIsbn13(normalizedBarcode) ? const [] : _barcodeFallbacks.where((source) => source.isConfigured).toList();

  CatalogSource? byKey(String key) => _sources.where((source) => source.key == key).firstOrNull;

  List<CatalogSource> configuredFor(CategoryType type) =>
      _sources.where((source) => source.isConfigured && source.types.contains(type)).toList();

  List<CatalogSource> forCategory(Category category) {
    final sources = configuredFor(category.type);
    if (category.type != CategoryType.cards) {
      return sources;
    }
    final game = cardGameNamed(category.name);
    if (game != null) {
      return sources.where((source) => source.key == game.sourceKey).toList();
    }
    return category.parentId == null ? sources : const [];
  }

  List<CatalogSource> barcodeSources(String normalizedBarcode) {
    final candidates = _sources.where((source) => source.isConfigured && source.supportsBarcode);
    final printed = isIsbn13(normalizedBarcode);
    return candidates.where((source) => source.types.any(_printedTypes.contains) == printed).toList()
      ..sort((first, second) => _barcodePriority(first.key).compareTo(_barcodePriority(second.key)));
  }

  int _barcodePriority(String key) => switch (key) {
        'discogs' => 0,
        'googlebooks' => 1,
        _ => 2,
      };
}
