import 'package:akashic/layers/functional/Catalog/domain/entities/category.dart';
import 'package:akashic/layers/functional/Goals/domain/entities/goal.dart';
import 'package:akashic/layers/functional/Goals/presentation/cubit/goals_cubit.dart';
import 'package:akashic/layers/functional/Goals/presentation/widgets/goal_labels.dart';
import 'package:akashic/layers/functional/Goals/presentation/widgets/goal_rings.dart';
import 'package:akashic/layers/technical/Localization/app_localizations.dart';
import 'package:akashic/layers/technical/Theme/akashic_colors.dart';
import 'package:akashic/layers/technical/Theme/akashic_empty_state.dart';
import 'package:akashic/layers/technical/Theme/akashic_typography.dart';
import 'package:akashic/layers/technical/Theme/safe_scroll_padding.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GoalsView extends StatelessWidget {
  const GoalsView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final cubit = context.read<GoalsCubit>();
    return BlocBuilder<GoalsCubit, GoalsState>(
      builder: (context, state) => Scaffold(
        appBar: AppBar(title: Text(l10n.goalsOfYear(state.year), style: AkashicTypography.displayTitle(size: 26))),
        body: state.isLoading
            ? const AkashicLoader()
            : ListView(
                padding: safeListPadding(context, bottom: 96),
                children: [
                  if (state.progress.isEmpty) Padding(padding: const EdgeInsets.only(top: 40), child: AkashicEmptyState(message: l10n.noGoalsYet)),
                  for (final progress in state.progress) _GoalCard(progress: progress, onRemove: () => cubit.remove(progress.goal.id)),
                ],
              ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () => showModalBottomSheet<void>(
            context: context,
            isScrollControlled: true,
            showDragHandle: true,
            builder: (sheetContext) => _NewGoalSheet(categories: state.categories, onCreate: cubit.add),
          ),
          icon: const Icon(Icons.add),
          label: Text(l10n.newGoal),
        ),
      ),
    );
  }
}

class _GoalCard extends StatelessWidget {
  const _GoalCard({required this.progress, required this.onRemove});

  final GoalProgress progress;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final color = goalPaceColor(progress);
    return Container(
      margin: const EdgeInsets.only(top: 12),
      padding: const EdgeInsets.fromLTRB(16, 12, 8, 16),
      decoration: BoxDecoration(color: AkashicColors.surface, borderRadius: BorderRadius.circular(18), border: Border.all(color: AkashicColors.line)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(child: Text(goalLabel(progress, l10n), style: AkashicTypography.body(size: 15, weight: FontWeight.w700))),
              IconButton(tooltip: l10n.deleteGoal, icon: const Icon(Icons.delete_outline), onPressed: onRemove),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text.rich(
                  TextSpan(children: [
                    TextSpan(text: '${progress.done}', style: AkashicTypography.numeral(size: 30).copyWith(color: color)),
                    TextSpan(text: ' / ${progress.goal.target}', style: AkashicTypography.body(size: 15).copyWith(color: AkashicColors.textSoft)),
                  ]),
                ),
                const SizedBox(height: 8),
                Semantics(
                  label: l10n.goalBarLabel(progress.done, progress.goal.target, progress.expectedToday),
                  excludeSemantics: true,
                  child: LayoutBuilder(
                    builder: (context, constraints) => Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Container(height: 10, decoration: BoxDecoration(color: AkashicColors.line, borderRadius: BorderRadius.circular(5))),
                        Container(height: 10, width: constraints.maxWidth * progress.ratio, decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(5))),
                        Positioned(left: (constraints.maxWidth * progress.yearElapsed).clamp(0, constraints.maxWidth - 2), top: -4, child: Container(width: 2, height: 18, color: AkashicColors.text)),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Text(goalPaceLabel(progress, l10n), style: AkashicTypography.body(size: 13, weight: FontWeight.w700).copyWith(color: color)),
                Text(l10n.goalProjection(progress.projected), style: AkashicTypography.body(size: 12).copyWith(color: AkashicColors.textSoft)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _NewGoalSheet extends StatefulWidget {
  const _NewGoalSheet({required this.categories, required this.onCreate});

  final List<Category> categories;
  final Future<void> Function({required GoalMeasure measure, required int target, String? categoryId}) onCreate;

  @override
  State<_NewGoalSheet> createState() => _NewGoalSheetState();
}

class _NewGoalSheetState extends State<_NewGoalSheet> {
  GoalMeasure _measure = GoalMeasure.finished;
  String? _categoryId;
  int _target = 12;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Padding(
      padding: EdgeInsets.fromLTRB(18, 0, 18, 18 + MediaQuery.viewInsetsOf(context).bottom + MediaQuery.paddingOf(context).bottom),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(l10n.newGoal, style: AkashicTypography.displayTitle(size: 24)),
          const SizedBox(height: 14),
          SegmentedButton<GoalMeasure>(
            segments: [
              ButtonSegment(value: GoalMeasure.finished, label: Text(l10n.goalMeasureFinished), icon: const Icon(Icons.flag_outlined)),
              ButtonSegment(value: GoalMeasure.added, label: Text(l10n.goalMeasureAdded), icon: const Icon(Icons.add_box_outlined)),
            ],
            selected: {_measure},
            onSelectionChanged: (selection) => setState(() => _measure = selection.single),
          ),
          const SizedBox(height: 14),
          DropdownButtonFormField<String?>(
            initialValue: _categoryId,
            decoration: InputDecoration(labelText: l10n.goalCategory),
            items: [
              DropdownMenuItem(value: null, child: Text(l10n.goalAllCategories)),
              for (final category in widget.categories) DropdownMenuItem(value: category.id, child: Text(category.name)),
            ],
            onChanged: (categoryId) => setState(() => _categoryId = categoryId),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(child: Text(l10n.goalTarget, style: AkashicTypography.body(weight: FontWeight.w700))),
              IconButton.outlined(tooltip: l10n.decrease, onPressed: _target > 1 ? () => setState(() => _target--) : null, icon: const Icon(Icons.remove)),
              SizedBox(width: 56, child: Text('$_target', textAlign: TextAlign.center, style: AkashicTypography.numeral(size: 24))),
              IconButton.outlined(tooltip: l10n.increase, onPressed: () => setState(() => _target++), icon: const Icon(Icons.add)),
            ],
          ),
          const SizedBox(height: 18),
          FilledButton(
            onPressed: () async {
              final navigator = Navigator.of(context);
              await widget.onCreate(measure: _measure, target: _target, categoryId: _categoryId);
              navigator.pop();
            },
            child: Text(l10n.createGoal),
          ),
        ],
      ),
    );
  }
}
