import 'package:akashic/layers/functional/Collection/domain/entities/collection_item.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/series.dart';
import 'package:akashic/layers/functional/Collection/domain/use_cases/series_completion.dart';
import 'package:akashic/layers/functional/Settings/domain/entities/preferred_languages.dart';
import 'package:equatable/equatable.dart';

class SeriesDetailState extends Equatable {
  const SeriesDetailState({
    this.series,
    this.volumes = const [],
    this.completion,
    this.isLoading = true,
    this.isUpdating = false,
    this.updateFailed = false,
    this.preferredLanguages = PreferredLanguages.defaults,
    this.missingVolumesWished,
  });

  final Series? series;
  final List<CollectionItem> volumes;
  final SeriesCompletion? completion;
  final bool isLoading;
  final bool isUpdating;
  final bool updateFailed;
  final PreferredLanguages preferredLanguages;
  final int? missingVolumesWished;

  SeriesDetailState copyWith({
    Series? series,
    List<CollectionItem>? volumes,
    SeriesCompletion? completion,
    bool? isLoading,
    bool? isUpdating,
    bool? updateFailed,
    PreferredLanguages? preferredLanguages,
    int? missingVolumesWished,
  }) {
    return SeriesDetailState(
      series: series ?? this.series,
      volumes: volumes ?? this.volumes,
      completion: completion ?? this.completion,
      isLoading: isLoading ?? this.isLoading,
      isUpdating: isUpdating ?? this.isUpdating,
      updateFailed: updateFailed ?? false,
      preferredLanguages: preferredLanguages ?? this.preferredLanguages,
      missingVolumesWished: missingVolumesWished,
    );
  }

  @override
  List<Object?> get props => [series, volumes, completion, isLoading, isUpdating, updateFailed, preferredLanguages, missingVolumesWished];
}
