import 'package:akashic/layers/functional/Lookup/domain/entities/source_unavailable.dart';
import 'package:akashic/layers/functional/Releases/data/calendars/keeping_what_succeeded.dart';
import 'package:akashic/layers/functional/Releases/domain/entities/upcoming_release.dart';
import 'package:flutter_test/flutter_test.dart';

UpcomingRelease volume(String title) => UpcomingRelease(sourceKey: 'googlebooks', externalId: title, kind: ReleaseKind.nextVolume, subject: title, title: title, releaseDate: DateTime(2027));

void main() {
  test('a failing lookup no longer erases what the others found', () async {
    final releases = await keepingWhatSucceeded([
      () async => [volume('Frieren 15')],
      () async => throw const SourceUnavailable('googlebooks', 'timeout'),
      () async => [volume('Dandadan 24')],
    ]);
    expect(releases.map((release) => release.title), ['Frieren 15', 'Dandadan 24']);
  });

  test('a calendar whose every lookup fails is still reported as down, an empty one is not', () async {
    expect(
      keepingWhatSucceeded([() async => throw const SourceUnavailable('googlebooks', 'timeout'), () async => throw const SourceUnavailable('googlebooks', 'HTTP 500')]),
      throwsA(isA<SourceUnavailable>()),
    );
    expect(await keepingWhatSucceeded(const []), isEmpty);
  });
}
