import 'package:akashic/layers/functional/Discoveries/domain/entities/suggestion.dart';
import 'package:akashic/layers/functional/Discoveries/domain/use_cases/describe_suggestion.dart';
import 'package:akashic/layers/functional/Discoveries/presentation/cubit/discoveries_cubit.dart';
import 'package:akashic/layers/functional/Discoveries/presentation/views/suggestion_detail_view.dart';
import 'package:akashic/layers/functional/Discoveries/presentation/cubit/discoveries_state.dart';
import 'package:akashic/layers/functional/Discoveries/presentation/widgets/suggestion_card.dart';
import 'package:akashic/layers/technical/Localization/app_localizations.dart';
import 'package:akashic/layers/technical/Theme/akashic_empty_state.dart';
import 'package:akashic/layers/technical/Theme/akashic_typography.dart';
import 'package:akashic/layers/technical/Theme/safe_scroll_padding.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DiscoveryGroupView extends StatelessWidget {
  const DiscoveryGroupView({required this.seedItemId, required this.seedTitle, this.describeSuggestion, super.key});

  final String seedItemId;
  final String seedTitle;
  final DescribeSuggestion? describeSuggestion;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final discoveriesCubit = context.read<DiscoveriesCubit>();
    return BlocBuilder<DiscoveriesCubit, DiscoveriesState>(
      builder: (context, state) {
        final group = state.visibleGroups.where((candidate) => candidate.seedItemId == seedItemId).firstOrNull;
        return Scaffold(
          appBar: AppBar(title: Text(l10n.becauseYouHave(seedTitle), maxLines: 2, style: AkashicTypography.body(size: 17, weight: FontWeight.w700))),
          body: group == null
              ? Center(child: AkashicEmptyState(message: l10n.discoveriesNothingNew))
              : GridView.builder(
                  padding: safeListPadding(context, top: 8),
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: SuggestionCard.width + 24,
                    mainAxisExtent: 268,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 12,
                  ),
                  itemCount: group.suggestions.length,
                  itemBuilder: (context, index) {
                    final suggestion = group.suggestions[index];
                    return Center(
                      child: SuggestionCard(
                        suggestion: suggestion,
                        isWished: state.isWished(suggestion),
                        onWish: () => discoveriesCubit.wish(group, suggestion),
                        onOpen: () => openSuggestionDetails(context, group: group, suggestion: suggestion, describeSuggestion: describeSuggestion),
                        onDismiss: () => _dismiss(context, discoveriesCubit, suggestion),
                      ),
                    );
                  },
                ),
        );
      },
    );
  }

  void _dismiss(BuildContext context, DiscoveriesCubit discoveriesCubit, Suggestion suggestion) {
    discoveriesCubit.dismiss(suggestion);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AppLocalizations.of(context).suggestionDismissed)));
  }
}
