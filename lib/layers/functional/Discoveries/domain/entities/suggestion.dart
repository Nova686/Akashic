import 'package:akashic/layers/functional/Catalog/domain/entities/category_type.dart';
import 'package:akashic/layers/functional/Collection/domain/use_cases/work_identity.dart';
import 'package:equatable/equatable.dart';

export 'package:akashic/layers/functional/Collection/domain/use_cases/work_identity.dart';

String sourceIdentityOf(String sourceKey, String externalWorkId) => '$sourceKey|$externalWorkId';


class Suggestion extends Equatable {
  const Suggestion({required this.sourceKey, required this.externalWorkId, required this.title, this.creator, this.imageUrl, this.year});

  final String sourceKey;
  final String externalWorkId;
  final String title;
  final String? creator;
  final String? imageUrl;
  final int? year;

  String get sourceIdentity => sourceIdentityOf(sourceKey, externalWorkId);

  String get workIdentity => workIdentityOf(title, creator);

  Set<String> get dismissalIdentities => {sourceIdentity, workIdentity, if (creator == null) titleIdentityOf(title)};

  bool isExcludedBy(Set<String> excluded) =>
      excluded.contains(sourceIdentity) || excluded.contains(workIdentity) || excluded.contains(titleIdentityOf(title));

  @override
  List<Object?> get props => [sourceKey, externalWorkId, title, creator, imageUrl, year];
}

class SuggestionGroup extends Equatable {
  const SuggestionGroup({required this.seedItemId, required this.seedTitle, required this.categoryType, required this.suggestions});

  final String seedItemId;
  final String seedTitle;
  final CategoryType categoryType;
  final List<Suggestion> suggestions;

  SuggestionGroup withoutSuggestion(Suggestion removed) => SuggestionGroup(
        seedItemId: seedItemId,
        seedTitle: seedTitle,
        categoryType: categoryType,
        suggestions: suggestions.where((suggestion) => suggestion.sourceIdentity != removed.sourceIdentity).toList(),
      );

  @override
  List<Object?> get props => [seedItemId, seedTitle, categoryType, suggestions];
}

class Discoveries extends Equatable {
  const Discoveries({required this.groups, required this.computedAt, required this.seedCount});

  final List<SuggestionGroup> groups;
  final DateTime computedAt;
  final int seedCount;

  Discoveries withoutSuggestion(Suggestion removed) => Discoveries(
        groups: [
          for (final group in groups)
            if (group.withoutSuggestion(removed) case final remaining when remaining.suggestions.isNotEmpty) remaining,
        ],
        computedAt: computedAt,
        seedCount: seedCount,
      );

  @override
  List<Object?> get props => [groups, computedAt, seedCount];
}
