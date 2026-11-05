import 'package:akashic/layers/functional/Catalog/presentation/widgets/category_type_labels.dart';
import 'package:akashic/layers/functional/Discoveries/domain/entities/suggestion.dart';
import 'package:akashic/layers/functional/Discoveries/presentation/cubit/discoveries_cubit.dart';
import 'package:akashic/layers/functional/Discoveries/presentation/cubit/discoveries_state.dart';
import 'package:akashic/layers/functional/Discoveries/domain/use_cases/describe_suggestion.dart';
import 'package:akashic/layers/functional/Discoveries/presentation/views/discovery_group_view.dart';
import 'package:akashic/layers/functional/Discoveries/presentation/views/suggestion_detail_view.dart';
import 'package:akashic/layers/functional/Discoveries/presentation/widgets/suggestion_card.dart';
import 'package:akashic/layers/technical/Localization/app_localizations.dart';
import 'package:akashic/layers/technical/Theme/akashic_empty_state.dart';
import 'package:akashic/layers/technical/Theme/akashic_colors.dart';
import 'package:akashic/layers/technical/Theme/akashic_typography.dart';
import 'package:akashic/layers/technical/Theme/filter_search_field.dart';
import 'package:akashic/layers/technical/Theme/safe_scroll_padding.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class DiscoveriesView extends StatelessWidget {
  const DiscoveriesView({this.describeSuggestion, super.key});

  final DescribeSuggestion? describeSuggestion;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final discoveriesCubit = context.read<DiscoveriesCubit>();
    return BlocBuilder<DiscoveriesCubit, DiscoveriesState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: Text(l10n.navDiscoveries, style: AkashicTypography.displayTitle(size: 28)),
            actions: [
              IconButton(
                tooltip: l10n.refreshDiscoveries,
                onPressed: state.isRefreshing ? null : discoveriesCubit.refresh,
                icon: state.isRefreshing
                    ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2))
                    : const Icon(Icons.refresh, color: AkashicColors.teal),
              ),
            ],
          ),
          body: state.isLoading ? const AkashicLoader(size: 96) : _content(context, state),
        );
      },
    );
  }

  Widget _content(BuildContext context, DiscoveriesState state) {
    final l10n = AppLocalizations.of(context);
    final discoveriesCubit = context.read<DiscoveriesCubit>();
    final discoveries = state.discoveries;
    if (discoveries == null) {
      return _Invitation(text: state.isOffline ? l10n.discoveriesOfflineEmpty : l10n.discoveriesNothingNew);
    }
    if (discoveries.groups.isEmpty) {
      return _Invitation(text: discoveries.seedCount == 0 ? l10n.discoveriesNeedSeeds : l10n.discoveriesNothingNew);
    }
    return ListView(
      padding: safeListPadding(context, horizontal: 0),
      children: [
        if (state.isOffline)
          Container(
            margin: const EdgeInsets.fromLTRB(18, 0, 18, 10),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: AkashicColors.surface, borderRadius: BorderRadius.circular(12)),
            child: Text(l10n.discoveriesOffline, style: AkashicTypography.body(size: 13).copyWith(color: AkashicColors.textSoft)),
          ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18),
          child: Text(
            l10n.discoveriesComputedOn(DateFormat.yMMMd(l10n.localeName).format(discoveries.computedAt)),
            style: AkashicTypography.body(size: 12).copyWith(color: AkashicColors.textFaint),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(18, 10, 18, 0),
          child: FilterSearchField(value: state.query, onChanged: discoveriesCubit.search, hint: l10n.discoveriesSearchHint),
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.fromLTRB(18, 10, 18, 0),
          child: Row(
            children: [
              if (state.availableTypes.length > 1) ...[
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(label: Text(l10n.allTypes), selected: state.typeFilter == null, onSelected: (_) => discoveriesCubit.filterBy(null)),
                ),
                for (final type in state.availableTypes)
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(label: Text(type.label(l10n)), selected: state.typeFilter == type, onSelected: (_) => discoveriesCubit.filterBy(type)),
                  ),
              ],
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: FilterChip(label: Text(l10n.filterNotWished), selected: state.hidesWished, onSelected: (_) => discoveriesCubit.toggleHidesWished()),
              ),
              FilterChip(label: Text(l10n.filterRecent), selected: state.recentOnly, onSelected: (_) => discoveriesCubit.toggleRecentOnly()),
            ],
          ),
        ),
        if (state.visibleGroups.isEmpty && state.isFiltered)
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 32, 18, 0),
            child: Column(
              children: [
                Text(l10n.noFilteredDiscoveries, textAlign: TextAlign.center, style: AkashicTypography.body().copyWith(color: AkashicColors.textSoft)),
                TextButton(onPressed: discoveriesCubit.resetFilters, child: Text(l10n.resetFilters)),
              ],
            ),
          ),
        for (final group in state.visibleGroups) _GroupSection(group: group, state: state, describeSuggestion: describeSuggestion),
      ],
    );
  }
}

class _GroupSection extends StatelessWidget {
  const _GroupSection({required this.group, required this.state, this.describeSuggestion});

  final SuggestionGroup group;
  final DiscoveriesState state;
  final DescribeSuggestion? describeSuggestion;

  void _openGroup(BuildContext context) {
    final discoveriesCubit = context.read<DiscoveriesCubit>();
    Navigator.of(context, rootNavigator: true).push(MaterialPageRoute<void>(
      builder: (_) => BlocProvider.value(value: discoveriesCubit, child: DiscoveryGroupView(seedItemId: group.seedItemId, seedTitle: group.seedTitle, describeSuggestion: describeSuggestion)),
    ));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final discoveriesCubit = context.read<DiscoveriesCubit>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: () => _openGroup(context),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(18, 18, 6, 8),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    l10n.becauseYouHave(group.seedTitle),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AkashicTypography.displayTitle(size: 22),
                  ),
                ),
                IconButton(tooltip: l10n.seeAll, icon: const Icon(Icons.arrow_forward, color: AkashicColors.teal), onPressed: () => _openGroup(context)),
              ],
            ),
          ),
        ),
        SizedBox(
          height: 268,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 18),
            itemCount: group.suggestions.length,
            separatorBuilder: (context, index) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final suggestion = group.suggestions[index];
              return SuggestionCard(
                suggestion: suggestion,
                isWished: state.isWished(suggestion),
                onWish: () => discoveriesCubit.wish(group, suggestion),
                onOpen: () => openSuggestionDetails(context, group: group, suggestion: suggestion, describeSuggestion: describeSuggestion),
                onDismiss: () {
                  discoveriesCubit.dismiss(suggestion);
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.suggestionDismissed)));
                },
              );
            },
          ),
        ),
      ],
    );
  }
}

class _Invitation extends StatelessWidget {
  const _Invitation({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Center(child: AkashicEmptyState(message: text, animationSize: 140));
  }
}
