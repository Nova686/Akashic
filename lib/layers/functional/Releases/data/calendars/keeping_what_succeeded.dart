import 'package:akashic/layers/functional/Lookup/domain/entities/source_unavailable.dart';
import 'package:akashic/layers/functional/Releases/domain/entities/upcoming_release.dart';

Future<List<UpcomingRelease>> keepingWhatSucceeded(List<Future<List<UpcomingRelease>> Function()> lookups) async {
  if (lookups.isEmpty) {
    return const [];
  }
  final outcomes = await Future.wait([
    for (final lookup in lookups)
      lookup().then<(List<UpcomingRelease>, SourceUnavailable?)>((releases) => (releases, null)).catchError((Object failure) => (const <UpcomingRelease>[], failure as SourceUnavailable), test: (failure) => failure is SourceUnavailable),
  ]);
  if (outcomes.every((outcome) => outcome.$2 != null)) {
    throw outcomes.first.$2!;
  }
  return [for (final (releases, _) in outcomes) ...releases];
}
