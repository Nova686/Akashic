import 'package:akashic/layers/functional/Releases/domain/entities/upcoming_release.dart';
import 'package:akashic/layers/functional/Releases/presentation/cubit/releases_cubit.dart';
import 'package:flutter_test/flutter_test.dart';

UpcomingRelease releaseOf(String title, ReleaseKind kind, String subject, {bool isEstimated = false, bool isWished = false, int month = 12}) =>
    UpcomingRelease(sourceKey: 'test', externalId: title, kind: kind, subject: subject, title: title, releaseDate: DateTime(2026, month, 1), isEstimated: isEstimated, isWished: isWished);

void main() {
  final outlook = ReleaseOutlook(
    computedAt: DateTime(2026, 11, 2),
    followedSubjects: 3,
    releases: [
      releaseOf('Perfect Order', ReleaseKind.cardSet, 'Pokémon'),
      releaseOf('One Piece 112', ReleaseKind.nextVolume, 'One Piece', isEstimated: true),
      releaseOf('Frieren 15', ReleaseKind.nextVolume, 'Frieren', isWished: true),
      releaseOf('New Album', ReleaseKind.album, 'Daft Punk', month: 11),
    ],
  );
  List<String> titlesOf(ReleasesState state) => [for (final section in state.sections) for (final release in section.releases) release.title];

  test('releases are filtered by kind, confirmed date, wish and text, and every filter clears', () {
    final state = ReleasesState(outlook: outlook, isLoading: false);
    expect(state.availableKinds, [ReleaseKind.cardSet, ReleaseKind.nextVolume, ReleaseKind.album]);
    expect(titlesOf(state.copyWith(kinds: {ReleaseKind.nextVolume})), ['One Piece 112', 'Frieren 15']);
    expect(titlesOf(state.copyWith(kinds: {ReleaseKind.nextVolume}, confirmedOnly: true)), ['Frieren 15']);
    expect(titlesOf(state.copyWith(wishedOnly: true)), ['Frieren 15']);
    expect(titlesOf(state.copyWith(query: 'daft')), ['New Album']);
    expect(titlesOf(state.copyWith(query: 'pokemon')), ['Perfect Order']);
    expect(state.copyWith(query: 'zelda').sections, isEmpty);
    expect(state.copyWith(query: 'zelda').isFiltered, isTrue);
    expect(state.isFiltered, isFalse);
  });
}
