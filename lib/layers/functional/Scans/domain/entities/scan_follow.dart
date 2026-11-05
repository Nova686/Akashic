import 'package:equatable/equatable.dart';

class ScanFollow extends Equatable {
  const ScanFollow({
    required this.seriesId,
    this.siteUrl,
    this.teamName,
    this.mangaUpdatesSeriesId,
    this.alertsEnabled = false,
    this.onlyFollowedTeam = false,
    this.lastCheckedAt,
  });

  final String seriesId;
  final String? siteUrl;
  final String? teamName;
  final String? mangaUpdatesSeriesId;
  final bool alertsEnabled;
  final bool onlyFollowedTeam;
  final DateTime? lastCheckedAt;

  bool get isLinked => mangaUpdatesSeriesId != null;

  ScanFollow copyWith({
    String? Function()? siteUrl,
    String? Function()? teamName,
    String? Function()? mangaUpdatesSeriesId,
    bool? alertsEnabled,
    bool? onlyFollowedTeam,
    DateTime? Function()? lastCheckedAt,
  }) {
    return ScanFollow(
      seriesId: seriesId,
      siteUrl: siteUrl == null ? this.siteUrl : siteUrl(),
      teamName: teamName == null ? this.teamName : teamName(),
      mangaUpdatesSeriesId: mangaUpdatesSeriesId == null ? this.mangaUpdatesSeriesId : mangaUpdatesSeriesId(),
      alertsEnabled: alertsEnabled ?? this.alertsEnabled,
      onlyFollowedTeam: onlyFollowedTeam ?? this.onlyFollowedTeam,
      lastCheckedAt: lastCheckedAt == null ? this.lastCheckedAt : lastCheckedAt(),
    );
  }

  @override
  List<Object?> get props => [seriesId, siteUrl, teamName, mangaUpdatesSeriesId, alertsEnabled, onlyFollowedTeam, lastCheckedAt];
}
