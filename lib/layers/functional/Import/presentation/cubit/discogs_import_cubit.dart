import 'package:akashic/layers/functional/Catalog/domain/entities/category.dart';
import 'package:akashic/layers/functional/Import/domain/use_cases/import_discogs_collection.dart';
import 'package:akashic/layers/functional/Lookup/domain/entities/source_unavailable.dart';
import 'package:akashic/layers/functional/Lookup/presentation/source_failure_toast.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

enum DiscogsImportStatus { choosing, importing, done, failed }

class DiscogsImportState extends Equatable {
  const DiscogsImportState({
    required this.categories,
    this.selectedCategoryId,
    this.status = DiscogsImportStatus.choosing,
    this.done = 0,
    this.total = 0,
    this.outcome,
  });

  final List<Category> categories;
  final String? selectedCategoryId;
  final DiscogsImportStatus status;
  final int done;
  final int total;
  final DiscogsImportOutcome? outcome;

  DiscogsImportState copyWith({String? selectedCategoryId, DiscogsImportStatus? status, int? done, int? total, DiscogsImportOutcome? outcome}) {
    return DiscogsImportState(
      categories: categories,
      selectedCategoryId: selectedCategoryId ?? this.selectedCategoryId,
      status: status ?? this.status,
      done: done ?? this.done,
      total: total ?? this.total,
      outcome: outcome ?? this.outcome,
    );
  }

  @override
  List<Object?> get props => [categories, selectedCategoryId, status, done, total, outcome];
}

class DiscogsImportCubit extends Cubit<DiscogsImportState> {
  DiscogsImportCubit(this._importDiscogsCollection, {required List<Category> musicCategories})
      : super(DiscogsImportState(categories: musicCategories, selectedCategoryId: musicCategories.firstOrNull?.id));

  final ImportDiscogsCollection _importDiscogsCollection;

  bool get isConfigured => _importDiscogsCollection.isConfigured;

  void chooseCategory(String categoryId) => emit(state.copyWith(selectedCategoryId: categoryId));

  Future<void> start() async {
    final categoryId = state.selectedCategoryId;
    if (categoryId == null || state.status == DiscogsImportStatus.importing) {
      return;
    }
    emit(state.copyWith(status: DiscogsImportStatus.importing, done: 0, total: 0));
    try {
      final outcome = await _importDiscogsCollection(
        categoryId: categoryId,
        onProgress: (done, total) {
          if (!isClosed) {
            emit(state.copyWith(done: done, total: total));
          }
        },
      );
      if (!isClosed) {
        emit(state.copyWith(status: DiscogsImportStatus.done, outcome: outcome));
      }
    } on SourceUnavailable catch (failure) {
      showSourceFailure(failure);
      if (!isClosed) {
        emit(state.copyWith(status: DiscogsImportStatus.failed));
      }
    }
  }
}
