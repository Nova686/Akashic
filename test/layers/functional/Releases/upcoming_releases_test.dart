import 'package:akashic/layers/functional/Catalog/domain/entities/category_type.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/collection_item.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/localized_titles.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/series.dart';
import 'package:akashic/layers/functional/Lookup/domain/entities/card_game.dart';
import 'package:akashic/layers/functional/Lookup/domain/entities/source_unavailable.dart';
import 'package:akashic/layers/functional/Releases/data/gateways/drift_release_store.dart';
import 'package:akashic/layers/functional/Releases/domain/entities/release_interests.dart';
import 'package:akashic/layers/functional/Releases/domain/entities/upcoming_release.dart';
import 'package:akashic/layers/functional/Releases/domain/gateways/release_calendar.dart';
import 'package:akashic/layers/functional/Releases/domain/gateways/release_notifier.dart';
import 'package:akashic/layers/functional/Releases/domain/use_cases/announce_new_releases.dart';
import 'package:akashic/layers/functional/Releases/domain/use_cases/find_upcoming_releases.dart';
import 'package:akashic/layers/functional/Settings/domain/entities/preferred_languages.dart';
import 'package:akashic/layers/functional/Collection/domain/use_cases/work_identity.dart';
import 'package:akashic/layers/functional/Wishes/domain/entities/wish.dart';
import 'package:akashic/layers/functional/Wishes/domain/entities/wish_key.dart';
import 'package:flutter_test/flutter_test.dart';

import '../Collection/collection_harness.dart';

class ScriptedCalendar implements ReleaseCalendar {
  ScriptedCalendar(this.releases);

  List<UpcomingRelease> releases;
  bool isDown = false;
  ReleaseInterests? askedWith;

  @override
  String get key => 'scripted';

  @override
  bool get isConfigured => true;

  @override
  Future<List<UpcomingRelease>> upcoming(ReleaseInterests interests, {required DateTime today}) async {
    askedWith = interests;
    if (isDown) {
      throw const SourceUnavailable('scripted');
    }
    return releases;
  }
}

class RecordingNotifier implements ReleaseNotifier {
  final List<List<UpcomingRelease>> announcements = [];

  @override
  Future<bool> requestPermission() async => true;

  @override
  Future<void> announce(List<UpcomingRelease> releases) async => announcements.add(releases);

  final List<List<UpcomingRelease>> wishedOut = [];

  @override
  Future<void> announceWishedOut(List<UpcomingRelease> releases) async => wishedOut.add(releases);
}

Wish wishedVolume(int volumeNumber) => Wish(
      id: 'wish-$volumeNumber',
      draft: WishDraft(categoryType: CategoryType.manga, title: 'Frieren $volumeNumber', origin: WishOrigin.missingVolume, key: WishKey(seriesId: 'frieren', volumeNumber: volumeNumber)),
      createdAt: DateTime(2026, 10, 1),
    );

UpcomingRelease setNamed(String name, DateTime date) =>
    UpcomingRelease(sourceKey: 'tcgdex', externalId: 'set:$name', kind: ReleaseKind.cardSet, subject: 'Pokémon', title: name, releaseDate: date);

void main() {
  late CollectionHarness harness;
  late DriftReleaseStore store;
  late ScriptedCalendar calendar;
  var clock = DateTime(2026, 10, 28, 9);

  setUp(() {
    harness = CollectionHarness();
    store = DriftReleaseStore(harness.database);
    calendar = ScriptedCalendar([]);
    clock = DateTime(2026, 10, 28, 9);
  });

  tearDown(() => harness.database.close());

  FindUpcomingReleases finder({List<Wish> wishes = const []}) => FindUpcomingReleases([calendar], harness.collection, harness.categories, store,
      preferredLanguages: () async => PreferredLanguages.defaults, wishes: () async => wishes, now: () => clock);

  Future<void> collectPokemonAndFrieren() async {
    await harness.createCategory(name: 'Pokémon', colorValue: 0, type: CategoryType.cards, conditionParts: const ['Objet']);
    final mangas = await harness.mangas();
    await harness.collection.saveSeries(Series(id: 'frieren', categoryId: mangas.id, titles: const LocalizedTitles(byLanguage: {'fr': 'Frieren'})));
    for (final volume in [1, 2, 3]) {
      await harness.collection.saveItem(CollectionItem(
        id: 'frieren-$volume',
        categoryId: mangas.id,
        seriesId: 'frieren',
        volumeNumber: volume,
        titles: LocalizedTitles(byLanguage: {'fr': 'Frieren T$volume'}),
      ));
    }
  }

  test('the followed games and series come from the collection, the next volume after the highest owned', () async {
    await collectPokemonAndFrieren();
    await finder()();
    expect(calendar.askedWith, const ReleaseInterests(cardGames: {CardGame.pokemon}, series: [FollowedSeries(seriesId: 'frieren', title: 'Frieren', nextVolume: 4)]));
  });

  test('wished volumes are followed first, the next one included, without following it twice', () async {
    await collectPokemonAndFrieren();
    await finder(wishes: [wishedVolume(6), wishedVolume(4), wishedVolume(2)])();
    expect(calendar.askedWith?.series, const [
      FollowedSeries(seriesId: 'frieren', title: 'Frieren', nextVolume: 4, isWished: true),
      FollowedSeries(seriesId: 'frieren', title: 'Frieren', nextVolume: 6, isWished: true),
    ]);
  });

  test('a wished volume is announced once more on the day it comes out', () async {
    await collectPokemonAndFrieren();
    final notifier = RecordingNotifier();
    final wished = UpcomingRelease(sourceKey: 'googlebooks', externalId: 'f4', kind: ReleaseKind.nextVolume, subject: 'Frieren', title: 'Frieren - Tome 4', releaseDate: DateTime(2026, 11, 4), isWished: true);
    AnnounceNewReleases announcer() => AnnounceNewReleases(finder(wishes: [wishedVolume(4)]), store, notifier, now: () => clock, refreshAfter: Duration.zero);
    calendar.releases = [wished];
    expect(await announcer()(), isEmpty);
    clock = DateTime(2026, 11, 4, 9);
    expect(await announcer()(), [wished]);
    expect(notifier.wishedOut, [
      [wished],
    ]);
    clock = DateTime(2026, 11, 5, 9);
    expect(await announcer()(), isEmpty);
    expect(notifier.announcements, isEmpty);
  });

  test('releases are sorted by date, past ones dropped, and the outlook is kept', () async {
    await collectPokemonAndFrieren();
    calendar.releases = [setNamed('Later', DateTime(2027, 2, 1)), setNamed('Recent', DateTime(2026, 9, 1)), setNamed('Long gone', DateTime(2026, 5, 1)), setNamed('Sooner', DateTime(2026, 11, 7))];
    final outlook = await finder()();
    expect(outlook.releases.map((release) => release.title), ['Recent', 'Sooner', 'Later']);
    expect(await store.cachedOutlook(), outlook);
  });

  test('nothing collected that has releases means no calendar is asked', () async {
    final outlook = await finder()();
    expect(calendar.askedWith, isNull);
    expect(outlook.followedSubjects, 0);
  });

  test('every calendar down is reported as unavailable', () async {
    await collectPokemonAndFrieren();
    calendar.isDown = true;
    expect(finder()(), throwsA(isA<ReleasesUnavailable>()));
  });

  test('the first check stays silent, later ones announce each new release once', () async {
    await collectPokemonAndFrieren();
    final notifier = RecordingNotifier();
    AnnounceNewReleases announcer() => AnnounceNewReleases(finder(), store, notifier, now: () => clock);
    calendar.releases = [setNamed('Sooner', DateTime(2026, 11, 7))];
    expect(await announcer()(), isEmpty);
    clock = clock.add(const Duration(days: 2));
    calendar.releases = [setNamed('Sooner', DateTime(2026, 11, 7)), setNamed('Fresh', DateTime(2027, 3, 1))];
    expect((await announcer()()).map((release) => release.title), ['Fresh']);
    clock = clock.add(const Duration(days: 2));
    expect(await announcer()(), isEmpty);
    expect(notifier.announcements, hasLength(1));
  });

  test('an estimated volume date is listed but never announced', () async {
    await collectPokemonAndFrieren();
    final notifier = RecordingNotifier();
    AnnounceNewReleases announcer() => AnnounceNewReleases(finder(), store, notifier, now: () => clock);
    calendar.releases = [];
    expect(await announcer()(), isEmpty);
    clock = clock.add(const Duration(days: 2));
    calendar.releases = [UpcomingRelease(sourceKey: 'googlebooks', externalId: 'estimate:s:15', kind: ReleaseKind.nextVolume, subject: 'Frieren', title: 'Frieren 15', releaseDate: DateTime(2026, 12), datePrecision: ReleaseDatePrecision.month, isEstimated: true)];
    expect(await announcer()(), isEmpty);
    expect(notifier.announcements, isEmpty);
  });

  test('the artists most present on the records are followed, with the titles already owned', () async {
    final vinyls = await harness.vinyls();
    for (final (id, title, artist) in [('a', 'Afterburner', 'Dance Gavin Dance'), ('b', 'Jackpot Juicer', 'Dance Gavin Dance'), ('c', 'Nevermind', 'Nirvana')]) {
      await harness.collection.saveItem(CollectionItem(id: id, categoryId: vinyls.id, titles: LocalizedTitles(byLanguage: {'en': title}), creator: artist));
    }
    final interests = await finder().followedInterests();
    expect(interests.artists, ['Dance Gavin Dance', 'Nirvana']);
    expect(interests.ownedTitles, contains(titleIdentityOf('Nevermind')));
  });
}
