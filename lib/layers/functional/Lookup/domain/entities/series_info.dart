import 'package:equatable/equatable.dart';

class SeriesInfo extends Equatable {
  const SeriesInfo({this.volumeCount, this.status});

  final int? volumeCount;
  final String? status;

  @override
  List<Object?> get props => [volumeCount, status];
}
