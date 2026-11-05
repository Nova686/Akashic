import 'package:equatable/equatable.dart';

enum ProgressStatus { notStarted, inProgress, finished, abandoned }

class ItemProgress extends Equatable {
  const ItemProgress({required this.status, this.chapter, this.page});

  final ProgressStatus status;
  final String? chapter;
  final int? page;

  bool get hasBookmark => status == ProgressStatus.inProgress || status == ProgressStatus.abandoned;

  @override
  List<Object?> get props => [status, chapter, page];
}
