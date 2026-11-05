import 'package:equatable/equatable.dart';

enum ReleaseKind { cardSet, nextVolume, album }

const Duration recentReleaseWindow = Duration(days: 90);

enum ReleaseDatePrecision { day, month, year }

class UpcomingRelease extends Equatable {
  const UpcomingRelease({
    required this.sourceKey,
    required this.externalId,
    required this.kind,
    required this.subject,
    required this.title,
    required this.releaseDate,
    this.datePrecision = ReleaseDatePrecision.day,
    this.imageUrl,
    this.isEstimated = false,
    this.isWished = false,
  });

  final String sourceKey;
  final String externalId;
  final ReleaseKind kind;
  final String subject;
  final String title;
  final DateTime releaseDate;
  final ReleaseDatePrecision datePrecision;
  final String? imageUrl;
  final bool isEstimated;
  final bool isWished;

  String get key => '$sourceKey|$externalId';

  DateTime get latestDate => switch (datePrecision) {
        ReleaseDatePrecision.day => releaseDate,
        ReleaseDatePrecision.month => DateTime(releaseDate.year, releaseDate.month + 1, 0),
        ReleaseDatePrecision.year => DateTime(releaseDate.year, 12, 31),
      };

  bool isOutBy(DateTime today) => latestDate.isBefore(today);

  bool isReleasedBy(DateTime today) => !isEstimated && datePrecision == ReleaseDatePrecision.day && !releaseDate.isAfter(today);

  @override
  List<Object?> get props => [sourceKey, externalId, kind, subject, title, releaseDate, datePrecision, imageUrl, isEstimated, isWished];
}

class ReleaseOutlook extends Equatable {
  const ReleaseOutlook({required this.releases, required this.computedAt, required this.followedSubjects});

  final List<UpcomingRelease> releases;
  final DateTime computedAt;
  final int followedSubjects;

  @override
  List<Object?> get props => [releases, computedAt, followedSubjects];
}
