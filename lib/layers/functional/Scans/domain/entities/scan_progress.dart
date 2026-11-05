import 'package:akashic/layers/functional/Scans/domain/entities/scan_follow.dart';
import 'package:akashic/layers/functional/Scans/domain/entities/scan_release.dart';
import 'package:equatable/equatable.dart';

class ScanProgress extends Equatable {
  const ScanProgress({required this.follow, this.readChapters = const [], this.releases = const []});

  final ScanFollow follow;
  final List<double> readChapters;
  final List<ScanRelease> releases;

  double? get lastRead => readChapters.isEmpty ? null : readChapters.reduce((first, second) => first > second ? first : second);

  List<ScanRelease> get countedReleases {
    final team = follow.teamName;
    if (!follow.onlyFollowedTeam || team == null || team.trim().isEmpty) {
      return releases;
    }
    return releases.where((release) => release.isFromTeam(team)).toList();
  }

  double? get latestReleased {
    final chapters = countedReleases.map((release) => release.chapter);
    return chapters.isEmpty ? null : chapters.reduce((first, second) => first > second ? first : second);
  }

  List<double> get newChapters {
    final read = lastRead;
    final unread = {
      for (final release in countedReleases)
        if (read == null || release.chapter > read) release.chapter,
    }.toList()
      ..sort();
    return unread;
  }

  @override
  List<Object?> get props => [follow, readChapters, releases];
}
