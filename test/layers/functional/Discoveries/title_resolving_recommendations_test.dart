import 'package:akashic/layers/functional/Catalog/domain/entities/category_type.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/localized_titles.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/owned_work.dart';
import 'package:akashic/layers/functional/Discoveries/data/sources/title_resolving_recommendations.dart';
import 'package:akashic/layers/functional/Discoveries/domain/entities/suggestion.dart';
import 'package:akashic/layers/functional/Discoveries/domain/gateways/recommendation_source.dart';
import 'package:akashic/layers/functional/Lookup/domain/entities/source_match.dart';
import 'package:akashic/layers/functional/Lookup/domain/entities/source_unavailable.dart';
import 'package:akashic/layers/functional/Lookup/domain/gateways/catalog_source.dart';
import 'package:flutter_test/flutter_test.dart';

class IdOnlyRecommendations implements RecommendationSource {
  final List<String> askedIds = [];

  @override
  String get key => 'igdb';

  @override
  bool get isConfigured => true;

  @override
  int get maximumSeeds => 8;

  @override
  bool supports(OwnedWork work, CategoryType type) => work.sourceKey == key && int.tryParse(work.externalWorkId ?? '') != null;

  @override
  String queryKeyFor(OwnedWork work) => work.externalWorkId!;

  @override
  Future<List<Suggestion>> recommendationsFor(OwnedWork work, {required String languageCode}) async {
    askedIds.add(work.externalWorkId!);
    return [Suggestion(sourceKey: key, externalWorkId: 'similar-${work.externalWorkId}', title: 'Similar to ${work.externalWorkId}')];
  }
}

class SearchableGames implements CatalogSource {
  final List<String> queries = [];

  @override
  String get key => 'igdb';

  @override
  Set<CategoryType> get types => {CategoryType.videoGames};

  @override
  bool get isConfigured => true;

  @override
  bool get supportsBarcode => false;

  @override
  Future<List<SourceMatch>> lookupBarcode(String barcode) async => const [];

  @override
  Future<List<SourceMatch>> search(String query) async {
    queries.add(query);
    SourceMatch game(String id, String title, String sourceKey) => SourceMatch(sourceKey: sourceKey, externalWorkId: id, titles: LocalizedTitles(byLanguage: {'en': title}), suggestedType: CategoryType.videoGames);
    return switch (query) {
      'Hades' => [game('w1', 'Hades', 'wikidata'), game('113112', 'Hades II', 'igdb'), game('26', 'Hades', 'igdb')],
      _ => [game('999', 'Something else entirely', 'igdb')],
    };
  }
}

OwnedWork steamGame(String id, String title) => OwnedWork(itemId: id, categoryId: 'games', titles: LocalizedTitles(byLanguage: {'en': title}), sourceKey: 'steam', externalWorkId: '1145360');

void main() {
  test('a game imported from Steam is looked up on IGDB by its title before asking for similar games', () async {
    final inner = IdOnlyRecommendations();
    final catalog = SearchableGames();
    final source = TitleResolvingRecommendations(inner, catalog, resolvableTypes: const {CategoryType.videoGames});
    final hades = steamGame('hades', 'Hades');
    expect(source.supports(hades, CategoryType.videoGames), isTrue);
    expect(source.supports(hades, CategoryType.music), isFalse);
    expect(source.queryKeyFor(hades), 'title:hades');
    final suggestions = await source.recommendationsFor(hades, languageCode: 'fr');
    expect(suggestions.single.title, 'Similar to 26');
    await source.recommendationsFor(hades, languageCode: 'fr');
    expect(catalog.queries, ['Hades']);
    expect(inner.askedIds, ['26', '26']);
  });

  test('an item whose title is not found gets no suggestion, and native items skip the lookup', () async {
    final inner = IdOnlyRecommendations();
    final catalog = SearchableGames();
    final source = TitleResolvingRecommendations(inner, catalog, resolvableTypes: const {CategoryType.videoGames});
    expect(await source.recommendationsFor(steamGame('obscure', 'Obscure Indie Gem'), languageCode: 'fr'), isEmpty);
    const native = OwnedWork(itemId: 'celeste', categoryId: 'games', titles: LocalizedTitles(byLanguage: {'en': 'Celeste'}), sourceKey: 'igdb', externalWorkId: '26758');
    expect((await source.recommendationsFor(native, languageCode: 'fr')).single.title, 'Similar to 26758');
    expect(catalog.queries, ['Obscure Indie Gem']);
  });

  test('a lookup that failed is tried again on the next refresh', () async {
    final inner = IdOnlyRecommendations();
    final catalog = FlakyGames();
    final source = TitleResolvingRecommendations(inner, catalog, resolvableTypes: const {CategoryType.videoGames});
    final hades = steamGame('hades', 'Hades');
    await expectLater(source.recommendationsFor(hades, languageCode: 'fr'), throwsA(isA<SourceUnavailable>()));
    catalog.isDown = false;
    expect((await source.recommendationsFor(hades, languageCode: 'fr')).single.title, 'Similar to 26');
  });
}

class FlakyGames extends SearchableGames {
  bool isDown = true;

  @override
  Future<List<SourceMatch>> search(String query) async => isDown ? throw const SourceUnavailable('igdb') : super.search(query);
}
