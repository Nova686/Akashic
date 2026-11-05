import 'package:equatable/equatable.dart';

class ChapterNotice extends Equatable {
  const ChapterNotice({required this.seriesId, required this.seriesTitle, required this.chapters});

  final String seriesId;
  final String seriesTitle;
  final List<double> chapters;

  @override
  List<Object?> get props => [seriesId, seriesTitle, chapters];
}

abstract interface class ChapterNotifier {
  Future<bool> requestPermission();
  Future<void> announce(List<ChapterNotice> notices);
}

abstract interface class ScanAlertsScheduler {
  Future<void> ensureScheduled();
}
