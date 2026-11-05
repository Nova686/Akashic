import 'package:akashic/layers/functional/Catalog/domain/entities/category_type.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/localized_titles.dart';
import 'package:akashic/layers/functional/Lookup/data/sources/json_fields.dart';
import 'package:akashic/layers/functional/Lookup/data/sources/source_http.dart';
import 'package:akashic/layers/functional/Lookup/domain/entities/source_match.dart';
import 'package:akashic/layers/functional/Lookup/domain/entities/source_unavailable.dart';
import 'package:akashic/layers/functional/Lookup/domain/gateways/catalog_source.dart';
import 'package:http/http.dart' as http;

class UpcItemDbSource implements CatalogSource {
  UpcItemDbSource(this._client, {required this._titleSources});

  static const String sourceKey = 'upcitemdb';
  static final RegExp _mediaNoise = RegExp(
    r'[\(\[]?\b(dvd|blu-?ray|4k|uhd|ultra hd|steelbook|widescreen|full ?screen|digital|import|region \w+|pal|ntsc|edition|ps[2-5]|playstation \d|xbox( one| series x)?|nintendo switch|switch|wii u?|game ?cube|3ds|ds|pc)\b[\)\]]?',
    caseSensitive: false,
  );

  final http.Client _client;
  final Map<CategoryType, CatalogSource> _titleSources;

  @override
  String get key => sourceKey;

  @override
  Set<CategoryType> get types => _titleSources.keys.toSet();

  @override
  bool get isConfigured => true;

  @override
  bool get supportsBarcode => true;

  @override
  Future<List<SourceMatch>> search(String query) async => const [];

  @override
  Future<List<SourceMatch>> lookupBarcode(String barcode) async {
    final json = mapOf(await sourceGetJson(_client, Uri.https('api.upcitemdb.com', '/prod/trial/lookup', {'upc': barcode}), sourceKey: key));
    final product = listOf(json['items']).map(mapOf).firstOrNull;
    final productTitle = textOf(product?['title']);
    if (product == null || productTitle == null) {
      return const [];
    }
    final type = categoryTypeOfProduct(textOf(product['category']) ?? '', productTitle: productTitle, brand: textOf(product['brand']) ?? '');
    final titleSource = type == null ? null : _titleSources[type];
    if (titleSource != null && titleSource.isConfigured) {
      try {
        final named = await titleSource.search(cleanedProductTitle(productTitle));
        if (named.firstOrNull case final match?) {
          return [match.withBarcode(barcode)];
        }
      } on SourceUnavailable {
        return [_productMatch(product, productTitle, barcode, type)];
      }
    }
    return [_productMatch(product, productTitle, barcode, type)];
  }

  SourceMatch _productMatch(Map<String, Object?> product, String productTitle, String barcode, CategoryType? type) => SourceMatch(
        sourceKey: key,
        externalWorkId: barcode,
        titles: LocalizedTitles(byLanguage: {'en': productTitle}),
        publisher: textOf(product['brand']),
        barcode: barcode,
        imageUrl: textOf(listOf(product['images']).firstOrNull)?.replaceFirst('http://', 'https://'),
        suggestedType: type ?? CategoryType.free,
      );

  static CategoryType? categoryTypeOfProduct(String productCategory, {String productTitle = '', String brand = ''}) {
    final category = productCategory.toLowerCase();
    if ('$brand $productTitle'.toLowerCase().contains('lego')) {
      return CategoryType.lego;
    }
    if ('$brand $productTitle'.toLowerCase().contains('amiibo')) {
      return CategoryType.amiibo;
    }
    if (category.contains('video game')) {
      return CategoryType.videoGames;
    }
    if (category.contains('movie') || category.contains('dvd') || category.contains('blu-ray') || category.contains('video')) {
      return CategoryType.films;
    }
    return null;
  }

  static String cleanedProductTitle(String productTitle) =>
      productTitle.replaceAll(_mediaNoise, ' ').replaceAll(RegExp(r'[\(\)\[\]]'), ' ').replaceAll(RegExp(r'\s*[-–:,]\s*$'), '').replaceAll(RegExp(r'\s+'), ' ').trim();
}
