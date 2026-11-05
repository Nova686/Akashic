import 'package:equatable/equatable.dart';

class VolumeTitle extends Equatable {
  const VolumeTitle({required this.seriesTitle, required this.volumeNumber});

  final String seriesTitle;
  final int volumeNumber;

  @override
  List<Object?> get props => [seriesTitle, volumeNumber];
}

final RegExp _markedVolume = RegExp(r'^(.+?)[\s,:\-–—.]*(?:tome|t\.?|vol\.?|volume|n°|no\.?|#)\s*0*(\d{1,3})\b.*$', caseSensitive: false);
final RegExp _trailingNumber = RegExp(r'^(.+?)[\s,:\-–—]+0*(\d{1,3})$');
final RegExp _dottedNumber = RegExp(r'^(.+?)\.\s*(?:t\.*\s*|tome\s*|vol\.*\s*)?0*(\d{1,3})$', caseSensitive: false);
final RegExp _editionNoise = RegExp(r'[\s\-–—,:]*(?:édition originale|edition originale|perfect edition|deluxe|nouvelle édition|new edition)\s*$', caseSensitive: false);

VolumeTitle? parseVolumeTitle(String title) {
  final trimmed = title.trim();
  final match = _markedVolume.firstMatch(trimmed) ?? _dottedNumber.firstMatch(trimmed) ?? _trailingNumber.firstMatch(trimmed);
  if (match == null) {
    return null;
  }
  final series = match.group(1)!.replaceAll(_editionNoise, '').replaceAll(RegExp(r'[\s,:\-–—.]+$'), '').trim();
  final number = int.parse(match.group(2)!);
  if (series.isEmpty || number == 0) {
    return null;
  }
  return VolumeTitle(seriesTitle: series, volumeNumber: number);
}
