import 'package:akashic/layers/functional/Import/domain/use_cases/import_account_library.dart';
import 'package:equatable/equatable.dart';

class LinkedAccountSyncProgress extends Equatable {
  const LinkedAccountSyncProgress({required this.service, this.done = 0, this.total = 0, this.isRefreshingDetails = false});

  final LibraryService service;
  final int done;
  final int total;
  final bool isRefreshingDetails;

  double? get fraction => isRefreshingDetails || total == 0 ? null : done / total;

  @override
  List<Object?> get props => [service, done, total, isRefreshingDetails];
}
