import 'package:equatable/equatable.dart';

class WishKey extends Equatable {
  const WishKey({this.sourceKey, this.externalWorkId, this.barcode, this.seriesId, this.volumeNumber, this.workIdentity});

  final String? sourceKey;
  final String? externalWorkId;
  final String? barcode;
  final String? seriesId;
  final int? volumeNumber;
  final String? workIdentity;

  bool get hasSourceIdentity => sourceKey != null && externalWorkId != null;

  bool get hasVolumeIdentity => seriesId != null && volumeNumber != null;

  bool get isIdentifiable => hasSourceIdentity || barcode != null || hasVolumeIdentity;

  bool matches(WishKey other) {
    if (hasSourceIdentity && other.hasSourceIdentity && sourceKey == other.sourceKey && externalWorkId == other.externalWorkId) {
      return true;
    }
    if (barcode != null && barcode == other.barcode) {
      return true;
    }
    if (hasVolumeIdentity && seriesId == other.seriesId && volumeNumber == other.volumeNumber) {
      return true;
    }
    return workIdentity != null && workIdentity == other.workIdentity;
  }

  @override
  List<Object?> get props => [sourceKey, externalWorkId, barcode, seriesId, volumeNumber, workIdentity];
}
