import 'package:akashic/layers/functional/Collection/domain/entities/series.dart';
import 'package:equatable/equatable.dart';

const Set<String> _ongoingStatuses = {'RELEASING', 'HIATUS', 'NOT_YET_RELEASED'};

class SeriesCompletion extends Equatable {
  const SeriesCompletion({required this.owned, required this.missing, required this.published, required this.nextUnreleased});

  final List<int> owned;
  final List<int> missing;
  final int? published;
  final int? nextUnreleased;

  bool get isComplete => missing.isEmpty && (published ?? 0) > 0;

  @override
  List<Object?> get props => [owned, missing, published, nextUnreleased];
}

SeriesCompletion computeSeriesCompletion(Series series, Set<int> ownedVolumes) {
  final highestOwned = ownedVolumes.isEmpty ? 0 : ownedVolumes.reduce((first, second) => first > second ? first : second);
  final published = [series.publishedVolumes ?? 0, highestOwned].reduce((first, second) => first > second ? first : second);
  final isOngoing = _ongoingStatuses.contains(series.status);
  return SeriesCompletion(
    owned: (ownedVolumes.toList()..sort()),
    missing: [for (var number = 1; number <= published; number++) if (!ownedVolumes.contains(number)) number],
    published: published == 0 ? null : published,
    nextUnreleased: isOngoing ? published + 1 : null,
  );
}
