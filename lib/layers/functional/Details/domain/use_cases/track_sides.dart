import 'package:akashic/layers/functional/Details/domain/entities/item_details.dart';

final RegExp _sidePosition = RegExp(r'^([A-Z])\d*$', caseSensitive: false);
final RegExp _duration = RegExp(r'^(?:(\d+):)?(\d{1,2}):(\d{2})$');

int? secondsOf(String? duration) {
  final match = _duration.firstMatch(duration?.trim() ?? '');
  if (match == null) {
    return null;
  }
  return int.parse(match.group(1) ?? '0') * 3600 + int.parse(match.group(2)!) * 60 + int.parse(match.group(3)!);
}

String formatDuration(int totalSeconds) {
  final hours = totalSeconds ~/ 3600;
  final minutes = (totalSeconds % 3600) ~/ 60;
  final seconds = (totalSeconds % 60).toString().padLeft(2, '0');
  return hours > 0 ? '$hours:${minutes.toString().padLeft(2, '0')}:$seconds' : '$minutes:$seconds';
}

class TrackSide {
  const TrackSide({required this.label, required this.tracks});

  final String? label;
  final List<DetailTrack> tracks;

  int? get totalSeconds {
    final seconds = [for (final track in tracks) secondsOf(track.duration)];
    return seconds.isEmpty || seconds.any((value) => value == null) ? null : seconds.fold<int>(0, (total, value) => total + value!);
  }
}

List<TrackSide> trackSidesOf(List<DetailTrack> tracks) {
  final sides = <TrackSide>[];
  for (final track in tracks) {
    final label = _sidePosition.firstMatch(track.position.trim())?.group(1)?.toUpperCase();
    if (sides.isEmpty || sides.last.label != label) {
      sides.add(TrackSide(label: label, tracks: [track]));
    } else {
      sides.last.tracks.add(track);
    }
  }
  return sides.length > 1 ? sides : [TrackSide(label: null, tracks: tracks)];
}

int? totalDurationOf(List<DetailTrack> tracks) => TrackSide(label: null, tracks: tracks).totalSeconds;
