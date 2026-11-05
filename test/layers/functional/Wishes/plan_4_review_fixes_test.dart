import 'package:akashic/layers/functional/Catalog/domain/entities/category_type.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/collection_item.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/localized_titles.dart';
import 'package:akashic/layers/functional/Discoveries/data/gateways/drift_discovery_cache.dart';
import 'package:akashic/layers/functional/Discoveries/data/gateways/drift_dismissed_suggestion_gateway.dart';
import 'package:akashic/layers/functional/Discoveries/domain/entities/suggestion.dart';
import 'package:akashic/layers/functional/Discoveries/domain/use_cases/build_discoveries.dart';
import 'package:akashic/layers/functional/Discoveries/domain/use_cases/dismiss_suggestion.dart';
import 'package:akashic/layers/functional/Discoveries/presentation/cubit/discoveries_cubit.dart';
import 'package:akashic/layers/functional/Settings/domain/entities/preferred_languages.dart';
import 'package:akashic/layers/functional/Wishes/data/gateways/drift_wish_gateway.dart';
import 'package:akashic/layers/functional/Wishes/domain/entities/wish.dart';
import 'package:akashic/layers/functional/Wishes/domain/entities/wish_key.dart';
import 'package:akashic/layers/functional/Wishes/domain/use_cases/add_wish.dart';
import 'package:akashic/layers/functional/Wishes/domain/use_cases/remove_fulfilled_wishes.dart';
import 'package:akashic/layers/functional/Wishes/domain/use_cases/watch_fulfilled_wishes.dart';
import 'package:flutter_test/flutter_test.dart';

import '../Collection/collection_harness.dart';
import '../Discoveries/build_discoveries_test.dart' show ScriptedSource, blueTrain, giantSteps;

void main() {
  late CollectionHarness harness;
  late DriftWishGateway wishes;

  setUp(() {
    harness = CollectionHarness();
    wishes = DriftWishGateway(harness.database);
  });

  tearDown(() => harness.database.close());

  test('a wish from a discovery is removed when the album arrives through another source', () async {
    final vinyls = await harness.vinyls();
    await AddWish(wishes)(const WishDraft(
      categoryType: CategoryType.music,
      title: 'Blue Train',
      creator: 'John Coltrane',
      origin: WishOrigin.discovery,
      key: WishKey(sourceKey: 'lastfm', externalWorkId: 'john coltrane|blue train'),
    ));
    await harness.collection.saveItem(CollectionItem(
      id: 'blue-train',
      categoryId: vinyls.id,
      titles: const LocalizedTitles(byLanguage: {'en': 'Blue Train'}),
      creator: 'John Coltrane',
      sourceKey: 'musicbrainz',
      externalWorkId: 'rg-1',
    ));
    final removed = await RemoveFulfilledWishes(wishes)(await harness.collection.watchOwnedWorks().first);
    expect(removed.single.title, 'Blue Train');
  });

  test('a wish for something already owned is removed as soon as it is added', () async {
    final vinyls = await harness.vinyls();
    await harness.collection.saveItem(CollectionItem(id: 'kob', categoryId: vinyls.id, titles: const LocalizedTitles(byLanguage: {'en': 'Kind of Blue'}), sourceKey: 'musicbrainz', externalWorkId: 'rg-kob'));
    final reported = <List<Wish>>[];
    final subscription = WatchFulfilledWishes(harness.collection, wishes, RemoveFulfilledWishes(wishes))().listen(reported.add);
    await pumpEventQueue();
    await AddWish(wishes)(const WishDraft(categoryType: CategoryType.music, title: 'Kind of Blue', origin: WishOrigin.search, key: WishKey(sourceKey: 'musicbrainz', externalWorkId: 'rg-kob')));
    await pumpEventQueue();
    expect(reported.single.single.title, 'Kind of Blue');
    expect(await wishes.all(), isEmpty);
    await subscription.cancel();
  });

  test('kept discoveries hide what has been bought since', () async {
    final vinyls = await harness.vinyls();
    await harness.collection.saveItem(CollectionItem(id: 'kob', categoryId: vinyls.id, titles: const LocalizedTitles(byLanguage: {'en': 'Kind of Blue'}), creator: 'Miles Davis'));
    final cache = DriftDiscoveryCache(harness.database);
    final dismissed = DriftDismissedSuggestionGateway(harness.database);
    final cubit = DiscoveriesCubit(
      buildDiscoveries: BuildDiscoveries([ScriptedSource('lastfm', [blueTrain, giantSteps])], harness.collection, harness.categories, dismissed, cache),
      dismissSuggestion: DismissSuggestion(dismissed, cache),
      wishes: wishes,
      addWish: AddWish(wishes),
      languageCode: () => 'fr',
      preferredLanguages: () async => PreferredLanguages.defaults,
    );
    await cubit.start();
    expect(cubit.state.visibleGroups.single.suggestions, [blueTrain, giantSteps]);
    await harness.collection.saveItem(CollectionItem(id: 'bought', categoryId: vinyls.id, titles: const LocalizedTitles(byLanguage: {'en': 'Blue Train'}), creator: 'John Coltrane'));
    await pumpEventQueue();
    expect(cubit.state.visibleGroups.single.suggestions, [giantSteps]);
    await cubit.close();
  });

  test('a dismissed suggestion without creator never comes back with one', () async {
    final vinyls = await harness.vinyls();
    await harness.collection.saveItem(CollectionItem(id: 'kob', categoryId: vinyls.id, titles: const LocalizedTitles(byLanguage: {'en': 'Kind of Blue'}), creator: 'Miles Davis'));
    final cache = DriftDiscoveryCache(harness.database);
    final dismissed = DriftDismissedSuggestionGateway(harness.database);
    await DismissSuggestion(dismissed, cache)(const Suggestion(sourceKey: 'anilist', externalWorkId: '1', title: 'Blue Train'));
    final discoveries = await BuildDiscoveries([ScriptedSource('lastfm', [blueTrain, giantSteps])], harness.collection, harness.categories, dismissed, cache)(
      languageCode: 'fr',
      preferredLanguages: PreferredLanguages.defaults,
    );
    expect(discoveries.groups.single.suggestions, [giantSteps]);
  });
}
