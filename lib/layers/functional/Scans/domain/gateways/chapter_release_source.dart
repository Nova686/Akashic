import 'package:equatable/equatable.dart';

class ReleaseSeriesCandidate extends Equatable {
  const ReleaseSeriesCandidate({required this.id, required this.title, this.year, this.imageUrl, this.kind});

  final String id;
  final String title;
  final String? year;
  final String? imageUrl;
  final String? kind;

  @override
  List<Object?> get props => [id, title, year, imageUrl, kind];
}

class PublishedChapters extends Equatable {
  const PublishedChapters({required this.chapters, required this.teamName});

  final List<double> chapters;
  final String teamName;

  @override
  List<Object?> get props => [chapters, teamName];
}

abstract interface class ChapterReleaseSource {
  Future<List<ReleaseSeriesCandidate>> searchSeries(String query);
  Future<List<PublishedChapters>> releasesOf(String releaseSeriesId);
}
