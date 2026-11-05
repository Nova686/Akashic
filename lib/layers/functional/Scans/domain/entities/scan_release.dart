import 'package:equatable/equatable.dart';

class ScanRelease extends Equatable {
  const ScanRelease({required this.seriesId, required this.chapter, required this.teamName, this.releasedOn, this.notified = false});

  final String seriesId;
  final double chapter;
  final String teamName;
  final DateTime? releasedOn;
  final bool notified;

  static final RegExp _teamSeparator = RegExp(r'\s*(?:&|,|\+|/)\s*');

  bool isFromTeam(String team) {
    final followed = team.trim().toLowerCase();
    final releaseTeams = {teamName.trim().toLowerCase(), ...teamName.toLowerCase().split(_teamSeparator).map((part) => part.trim())};
    return releaseTeams.contains(followed);
  }

  @override
  List<Object?> get props => [seriesId, chapter, teamName, releasedOn, notified];
}
