import 'package:akashic/layers/functional/Catalog/domain/entities/category.dart';
import 'package:akashic/layers/functional/Catalog/domain/entities/category_type.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/localized_titles.dart';
import 'package:akashic/layers/functional/Collection/domain/use_cases/search_text_normalizer.dart';
import 'package:akashic/layers/functional/Lookup/domain/entities/card_game.dart';
import 'package:akashic/layers/functional/Lookup/domain/entities/sealed_product.dart';
import 'package:akashic/layers/functional/Lookup/domain/entities/source_match.dart';
import 'package:akashic/layers/functional/Lookup/domain/gateways/sealed_product_catalogue.dart';

const String sealedSourceKey = 'cardmarket';

const List<(String, String)> _sealedTypeLabels = [
  ('elite trainer', 'ETB'),
  ('booster box', 'Display'),
  ('display', 'Display'),
  ('booster', 'Booster'),
  ('box set', 'Coffret'),
  ('sets', 'Coffret'),
  ('set', 'Coffret'),
  ('tin', 'Tin'),
  ('blister', 'Blister'),
  ('starter deck', 'Deck'),
  ('structure deck', 'Deck'),
  ('theme deck', 'Deck'),
  ('preconstructed deck', 'Deck'),
  ('intropack', 'Deck'),
  ('deck', 'Deck'),
  ('coin', 'Pièce'),
  ('trainer kit', 'Kit'),
  ('special edition', 'Édition spéciale'),
  ('promo', 'Promo'),
  ('lot', 'Lot'),
];

String sealedTypeLabelOf(String categoryName) {
  final normalized = normalizeForSearch(categoryName);
  for (final (marker, label) in _sealedTypeLabels) {
    if (normalized.contains(marker)) {
      return label;
    }
  }
  return categoryName;
}

CardGame? sealedGameOf(Category? category, SealedProductCatalogue catalogue) {
  if (category == null || category.type != CategoryType.cards) {
    return null;
  }
  final game = cardGameNamed(category.name);
  return game != null && catalogue.covers(game) ? game : null;
}

class SealedProductLibrary {
  SealedProductLibrary(this._catalogue);

  static const int maximumResults = 40;

  final SealedProductCatalogue _catalogue;

  bool covers(CardGame game) => _catalogue.covers(game);

  Future<List<SourceMatch>> search(String query, CardGame game) async {
    final words = normalizeForSearch(query).split(' ').where((word) => word.isNotEmpty).toList();
    if (words.isEmpty) {
      return const [];
    }
    final found = [
      for (final product in await _catalogue.productsOf(game))
        if (words.every(normalizeForSearch('${product.name} ${sealedTypeLabelOf(product.categoryName)}').contains)) product,
    ]..sort((first, second) => (second.addedAt ?? DateTime(0)).compareTo(first.addedAt ?? DateTime(0)));
    return [for (final product in found.take(maximumResults)) _matchOf(product)];
  }

  SourceMatch _matchOf(SealedProduct product) => SourceMatch(
        sourceKey: sealedSourceKey,
        externalWorkId: product.id,
        titles: LocalizedTitles(byLanguage: {'en': product.name}),
        year: product.addedAt?.year,
        format: sealedTypeLabelOf(product.categoryName),
        suggestedType: CategoryType.cards,
      );
}
