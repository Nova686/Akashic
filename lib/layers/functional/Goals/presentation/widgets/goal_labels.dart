import 'package:akashic/layers/functional/Goals/domain/entities/goal.dart';
import 'package:akashic/layers/technical/Localization/app_localizations.dart';

String goalLabel(GoalProgress progress, AppLocalizations l10n) {
  final scope = progress.categoryName ?? l10n.goalAllCategories;
  return switch (progress.goal.measure) {
    GoalMeasure.finished => l10n.goalFinishLabel(progress.goal.target, scope),
    GoalMeasure.added => l10n.goalAddLabel(progress.goal.target, scope),
  };
}

String goalPaceLabel(GoalProgress progress, AppLocalizations l10n) => switch (progress) {
      GoalProgress(isReached: true) => l10n.goalReached,
      GoalProgress(:final gap) when gap > 0 => l10n.goalAhead(gap),
      GoalProgress(:final gap) when gap < 0 => l10n.goalBehind(-gap),
      _ => l10n.goalOnPace,
    };
