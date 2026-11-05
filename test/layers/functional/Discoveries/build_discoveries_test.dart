import 'package:akashic/layers/functional/Catalog/domain/entities/category.dart';
import 'package:akashic/layers/functional/Catalog/domain/entities/category_type.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/collection_item.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/localized_titles.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/owned_work.dart';
import 'package:akashic/layers/functional/Discoveries/data/gateways/drift_discovery_cache.dart';
import 'package:akashic/layers/functional/Discoveries/data/gateways/drift_dismissed_suggestion_gateway.dart';
import 'package:akashic/layers/functional/Discoveries/domain/entities/suggestion.dart';
import 'package:akashic/layers/functional/Discoveries/domain/gateways/recommendation_source.dart';
import 'package:akashic/layers/functional/Discoveries/domain/use_cases/build_discoveries.dart';
import 'package:akashic/layers/functional/Discoveries/domain/use_cases/dismiss_suggestion.dart';
import 'package:akashic/layers/functional/Lookup/domain/entities/source_unavailable.dart';
import 'package:akashic/layers/functional/Settings/domain/entities/preferred_languages.dart';
import 'package:flutter_test/flutter_test.dart';

import '../Collection/collection_harness.dart';

class ScriptedSource implements RecommendationSource {
  ScriptedSource(this.key, this.suggestions, {this.isConfigured = true, this.handles = const {CategoryType.music}, this.maximumSeeds = 8});

  @override
  final String key;
  @override
  final bool isConfigured;
  @override
  final int maximumSeeds;
  final Set<CategoryType> handles;
  final List<Suggestion> suggestions;
  bool isDown = false;
  final List<String> askedFor = [];

  @override
  bool supports(OwnedWork work, CategoryType type) => handles.contains(type);

  @override
  String queryKeyFor(OwnedWork work) => work.itemId;

  @override
  Future<List<Suggestion>> recommendationsFor(OwnedWork work, {required String languageCode}) async {
    askedFor.add(work.itemId);
    if (isDown) {
      throw SourceUnavailable(key);
    }
    return suggestions;
  }
}

const blueTrain = Suggestion(sourceKey: 'lastfm', externalWorkId: 'coltrane|blue train', title: 'Blue Train', creator: 'John Coltrane');
const kindOfBlueSuggested = Suggestion(sourceKey: 'lastfm', externalWorkId: 'miles|kind of blue', title: 'Kind of Blue', creator: 'Miles Davis');
const giantSteps = Suggestion(sourceKey: 'lastfm', externalWorkId: 'coltrane|giant steps', title: 'Giant Steps', creator: 'John Coltrane');

void main() {
  late CollectionHarness harness;
  late Category vinyls;
  late DriftDiscoveryCache cache;
  late DriftDismissedSuggestionGateway dismissed;

  setUp(() async {
    harness = CollectionHarness();
    vinyls = await harness.vinyls();
    cache = DriftDiscoveryCache(harness.database);
    dismissed = DriftDismissedSuggestionGateway(harness.database);
    await harness.collection.saveItem(CollectionItem(
      id: 'kob',
      categoryId: vinyls.id,
      titles: const LocalizedTitles(byLanguage: {'en': 'Kind of Blue'}),
      creator: 'Miles Davis',
      rating: 5,
    ));
  });

  tearDown(() => harness.database.close());

  BuildDiscoveries buildWith(List<RecommendationSource> sources) =>
      BuildDiscoveries(sources, harness.collection, harness.categories, dismissed, cache, now: () => DateTime(2026, 10, 27));

  Future<Discoveries> build(BuildDiscoveries buildDiscoveries) => buildDiscoveries(languageCode: 'fr', preferredLanguages: PreferredLanguages.defaults);

  test('owned works never appear', () async {
    final discoveries = await build(buildWith([ScriptedSource('lastfm', [kindOfBlueSuggested, blueTrain])]));
    final group = discoveries.groups.single;
    expect(group.seedTitle, 'Kind of Blue');
    expect(group.categoryType, CategoryType.music);
    expect(group.suggestions, [blueTrain]);
  });

  test('a dismissed work never comes back from another source', () async {
    await DismissSuggestion(dismissed, cache)(blueTrain);
    final fromAnotherSource = Suggestion(sourceKey: 'musicbrainz', externalWorkId: 'rg-blue-train', title: 'Blue Train', creator: 'John Coltrane');
    final discoveries = await build(buildWith([ScriptedSource('musicbrainz', [fromAnotherSource, giantSteps])]));
    expect(discoveries.groups.single.suggestions, [giantSteps]);
  });

  test('a suggestion shared by two seeds is shown once', () async {
    await harness.collection.saveItem(CollectionItem(id: 'mingus', categoryId: vinyls.id, titles: const LocalizedTitles(byLanguage: {'en': 'Mingus Ah Um'}), creator: 'Charles Mingus'));
    final discoveries = await build(buildWith([ScriptedSource('lastfm', [blueTrain])]));
    expect(discoveries.groups, hasLength(1));
    expect(discoveries.seedCount, 2);
  });

  test('a source without key is skipped', () async {
    final unconfigured = ScriptedSource('lastfm', [blueTrain], isConfigured: false);
    final discoveries = await build(buildWith([unconfigured]));
    expect(unconfigured.askedFor, isEmpty);
    expect(discoveries.seedCount, 0);
    expect(discoveries.groups, isEmpty);
  });

  test('offline, the previous discoveries stay and the failure is explicit', () async {
    final source = ScriptedSource('lastfm', [blueTrain, giantSteps]);
    final buildDiscoveries = buildWith([source]);
    await build(buildDiscoveries);
    source.isDown = true;
    await expectLater(build(buildDiscoveries), throwsA(isA<DiscoveriesUnavailable>()));
    final cached = await buildDiscoveries.cached();
    expect(cached?.groups.single.suggestions, [blueTrain, giantSteps]);
    expect(cached?.computedAt, DateTime(2026, 10, 27));
  });

  test('dismissing a suggestion also removes it from the kept discoveries', () async {
    final buildDiscoveries = buildWith([ScriptedSource('lastfm', [blueTrain, giantSteps])]);
    await build(buildDiscoveries);
    await DismissSuggestion(dismissed, cache)(blueTrain);
    expect((await cache.read())?.groups.single.suggestions, [giantSteps]);
  });

  test('best rated items are asked first', () async {
    for (var index = 0; index < 10; index++) {
      await harness.collection.saveItem(CollectionItem(id: 'recent-$index', categoryId: vinyls.id, titles: LocalizedTitles(byLanguage: {'en': 'Album $index'}), creator: 'Artist $index'));
    }
    final source = ScriptedSource('lastfm', const []);
    await build(buildWith([source]));
    expect(source.askedFor, hasLength(source.maximumSeeds));
    expect(source.askedFor, contains('kob'));
  });

  test('every kind of item gets its turn, even when one kind was added last', () async {
    final games = await harness.createCategory(name: 'Jeux', colorValue: 0, type: CategoryType.videoGames, conditionParts: const ['Jeu']);
    final films = await harness.createCategory(name: 'Films', colorValue: 0, type: CategoryType.films, conditionParts: const ['Boîtier']);
    await harness.collection.saveItem(CollectionItem(id: 'hades', categoryId: games.id, titles: const LocalizedTitles(byLanguage: {'en': 'Hades'})));
    await harness.collection.saveItem(CollectionItem(id: 'alien', categoryId: films.id, titles: const LocalizedTitles(byLanguage: {'en': 'Alien'})));
    for (var index = 0; index < 20; index++) {
      await harness.collection.saveItem(CollectionItem(id: 'recent-$index', categoryId: vinyls.id, titles: LocalizedTitles(byLanguage: {'en': 'Album $index'}), creator: 'Artist $index'));
    }
    final music = ScriptedSource('lastfm', const [], maximumSeeds: 20);
    final gamesSource = ScriptedSource('igdb', const [], handles: const {CategoryType.videoGames});
    final filmsSource = ScriptedSource('tmdb', const [], handles: const {CategoryType.films});
    await build(buildWith([music, gamesSource, filmsSource]));
    expect(gamesSource.askedFor, ['hades']);
    expect(filmsSource.askedFor, ['alien']);
    expect(music.askedFor, hasLength(BuildDiscoveries.maximumSeeds - 2));
  });

  test('a slow source is asked for a few seeds only', () async {
    for (var index = 0; index < 6; index++) {
      await harness.collection.saveItem(CollectionItem(id: 'album-$index', categoryId: vinyls.id, titles: LocalizedTitles(byLanguage: {'en': 'Album $index'}), creator: 'Artist $index'));
    }
    final source = ScriptedSource('discogs', const [], maximumSeeds: 3);
    await build(buildWith([source]));
    expect(source.askedFor, hasLength(3));
  });
}
