import 'package:akashic/layers/functional/Collection/domain/entities/collection_item.dart';
import 'package:akashic/layers/functional/Covers/domain/use_cases/bulk_covers.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

enum ProposalStatus { searching, proposed, nothingFound, accepted, refused }

class CoverProposal extends Equatable {
  const CoverProposal({required this.item, this.urls = const [], this.shownIndex = 0, this.status = ProposalStatus.searching});

  final CollectionItem item;
  final List<String> urls;
  final int shownIndex;
  final ProposalStatus status;

  String? get shownUrl => urls.isEmpty ? null : urls[shownIndex % urls.length];

  CoverProposal copyWith({List<String>? urls, int? shownIndex, ProposalStatus? status}) => CoverProposal(item: item, urls: urls ?? this.urls, shownIndex: shownIndex ?? this.shownIndex, status: status ?? this.status);

  @override
  List<Object?> get props => [item.id, urls, shownIndex, status];
}

class BulkCoversState extends Equatable {
  const BulkCoversState({this.groups = const [], this.selectedCategories = const {}, this.proposals = const [], this.isLoading = true, this.hasStarted = false});

  final List<CoverlessGroup> groups;
  final Set<String> selectedCategories;
  final List<CoverProposal> proposals;
  final bool isLoading;
  final bool hasStarted;

  int get coverlessCount => groups.fold(0, (total, group) => total + group.items.length);

  int get selectedCount => groups.where((group) => selectedCategories.contains(group.category.id)).fold(0, (total, group) => total + group.items.length);

  int get searchedCount => proposals.where((proposal) => proposal.status != ProposalStatus.searching).length;

  int get pendingCount => proposals.where((proposal) => proposal.status == ProposalStatus.proposed).length;

  int get acceptedCount => proposals.where((proposal) => proposal.status == ProposalStatus.accepted).length;

  BulkCoversState copyWith({List<CoverlessGroup>? groups, Set<String>? selectedCategories, List<CoverProposal>? proposals, bool? isLoading, bool? hasStarted}) => BulkCoversState(
        groups: groups ?? this.groups,
        selectedCategories: selectedCategories ?? this.selectedCategories,
        proposals: proposals ?? this.proposals,
        isLoading: isLoading ?? this.isLoading,
        hasStarted: hasStarted ?? this.hasStarted,
      );

  @override
  List<Object?> get props => [groups, selectedCategories, proposals, isLoading, hasStarted];
}

class BulkCoversCubit extends Cubit<BulkCoversState> {
  BulkCoversCubit(this._find, this._propose, this._accept) : super(const BulkCoversState());

  final FindCoverlessItems _find;
  final ProposeCovers _propose;
  final AcceptCover _accept;

  Future<void> load() async {
    final groups = await _find();
    if (!isClosed) {
      emit(state.copyWith(groups: groups, selectedCategories: {for (final group in groups) group.category.id}, isLoading: false));
    }
  }

  void toggleCategory(String categoryId) => emit(state.copyWith(
        selectedCategories: state.selectedCategories.contains(categoryId) ? ({...state.selectedCategories}..remove(categoryId)) : {...state.selectedCategories, categoryId},
      ));

  void _update(String itemId, CoverProposal Function(CoverProposal proposal) change) {
    if (!isClosed) {
      emit(state.copyWith(proposals: [for (final proposal in state.proposals) proposal.item.id == itemId ? change(proposal) : proposal]));
    }
  }

  Future<void> search() async {
    final items = [
      for (final group in state.groups)
        if (state.selectedCategories.contains(group.category.id)) ...group.items,
    ];
    emit(state.copyWith(hasStarted: true, proposals: [for (final item in items) CoverProposal(item: item)]));
    for (final item in items) {
      if (isClosed) {
        return;
      }
      List<String> urls;
      try {
        urls = await _propose(item);
      } on Exception {
        urls = const [];
      }
      _update(item.id, (proposal) => proposal.copyWith(urls: urls, status: urls.isEmpty ? ProposalStatus.nothingFound : ProposalStatus.proposed));
    }
  }

  Future<void> accept(String itemId) async {
    final proposal = state.proposals.where((candidate) => candidate.item.id == itemId).firstOrNull;
    final url = proposal?.shownUrl;
    if (proposal == null || url == null || proposal.status != ProposalStatus.proposed) {
      return;
    }
    final isStored = await _accept(itemId, url).catchError((Object _) => false, test: (error) => error is Exception);
    _update(itemId, (current) => current.copyWith(status: isStored ? ProposalStatus.accepted : ProposalStatus.nothingFound));
  }

  void refuse(String itemId) => _update(itemId, (proposal) => proposal.copyWith(status: ProposalStatus.refused));

  void showAnother(String itemId) => _update(itemId, (proposal) => proposal.copyWith(shownIndex: proposal.shownIndex + 1));

  Future<void> acceptAll() async {
    for (final proposal in [...state.proposals]) {
      if (proposal.status == ProposalStatus.proposed) {
        await accept(proposal.item.id);
      }
    }
  }
}
