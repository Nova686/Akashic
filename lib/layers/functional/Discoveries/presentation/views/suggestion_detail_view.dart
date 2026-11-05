import 'package:akashic/layers/functional/Collection/presentation/widgets/learn_more_tab.dart';
import 'package:akashic/layers/functional/Details/domain/entities/item_details.dart';
import 'package:akashic/layers/functional/Details/domain/use_cases/fetch_item_details.dart';
import 'package:akashic/layers/functional/Discoveries/domain/entities/suggestion.dart';
import 'package:akashic/layers/functional/Discoveries/domain/use_cases/describe_suggestion.dart';
import 'package:akashic/layers/functional/Discoveries/presentation/cubit/discoveries_cubit.dart';
import 'package:akashic/layers/functional/Discoveries/presentation/cubit/discoveries_state.dart';
import 'package:akashic/layers/technical/Feedback/error_toasts.dart';
import 'package:akashic/layers/technical/Localization/app_localizations.dart';
import 'package:akashic/layers/technical/Theme/akashic_colors.dart';
import 'package:akashic/layers/technical/Theme/akashic_typography.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void openSuggestionDetails(BuildContext context, {required SuggestionGroup group, required Suggestion suggestion, DescribeSuggestion? describeSuggestion}) {
  final discoveriesCubit = context.read<DiscoveriesCubit>();
  Navigator.of(context, rootNavigator: true).push(MaterialPageRoute<void>(
    builder: (_) => BlocProvider.value(
      value: discoveriesCubit,
      child: SuggestionDetailView(group: group, suggestion: suggestion, describeSuggestion: describeSuggestion),
    ),
  ));
}

class SuggestionDetailView extends StatefulWidget {
  const SuggestionDetailView({required this.group, required this.suggestion, this.describeSuggestion, super.key});

  final SuggestionGroup group;
  final Suggestion suggestion;
  final DescribeSuggestion? describeSuggestion;

  @override
  State<SuggestionDetailView> createState() => _SuggestionDetailViewState();
}

class _SuggestionDetailViewState extends State<SuggestionDetailView> {
  ItemDetails? _details;
  bool _isFetching = false;

  bool get _canDescribe => widget.describeSuggestion?.canDescribe(widget.suggestion) ?? false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_canDescribe && _details == null && !_isFetching) {
      _describe();
    }
  }

  Future<void> _describe() async {
    final describeSuggestion = widget.describeSuggestion;
    if (describeSuggestion == null) {
      return;
    }
    setState(() => _isFetching = true);
    try {
      final details = await describeSuggestion(widget.suggestion, languageCode: Localizations.localeOf(context).languageCode);
      if (mounted) {
        setState(() => _details = details);
      }
    } on DetailsUnavailable {
      ErrorToasts.instance.show((l10n) => l10n.detailsUnavailable);
    } finally {
      if (mounted) {
        setState(() => _isFetching = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final discoveriesCubit = context.read<DiscoveriesCubit>();
    final suggestion = widget.suggestion;
    return BlocBuilder<DiscoveriesCubit, DiscoveriesState>(
      builder: (context, state) {
        final isWished = state.isWished(suggestion);
        return Scaffold(
          appBar: AppBar(title: Text(suggestion.title, maxLines: 1, overflow: TextOverflow.ellipsis, style: AkashicTypography.body(size: 18, weight: FontWeight.w700))),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: SizedBox(
                        width: 110,
                        height: 160,
                        child: suggestion.imageUrl == null
                            ? const ColoredBox(color: AkashicColors.surface, child: Icon(Icons.auto_awesome_outlined, color: AkashicColors.lavender))
                            : CachedNetworkImage(imageUrl: suggestion.imageUrl!, fit: BoxFit.cover, memCacheWidth: 330, errorWidget: (context, url, error) => const ColoredBox(color: AkashicColors.surface)),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(suggestion.title, style: AkashicTypography.displayTitle(size: 22)),
                          if (suggestion.creator case final creator?) ...[
                            const SizedBox(height: 4),
                            Text(creator, style: AkashicTypography.body(size: 14).copyWith(color: AkashicColors.textSoft)),
                          ],
                          if (suggestion.year case final year?) Text('$year', style: AkashicTypography.body(size: 13).copyWith(color: AkashicColors.textFaint)),
                          const SizedBox(height: 6),
                          Text(l10n.becauseYouHave(widget.group.seedTitle), style: AkashicTypography.body(size: 12).copyWith(color: AkashicColors.teal)),
                          const SizedBox(height: 10),
                          Wrap(
                            spacing: 8,
                            children: [
                              FilledButton.icon(
                                onPressed: isWished ? null : () => discoveriesCubit.wish(widget.group, suggestion),
                                icon: Icon(isWished ? Icons.favorite : Icons.favorite_border, size: 18),
                                label: Text(isWished ? l10n.wished : l10n.addToWishes),
                              ),
                              OutlinedButton(
                                onPressed: () {
                                  discoveriesCubit.dismiss(suggestion);
                                  Navigator.of(context).pop();
                                },
                                child: Text(l10n.notForMe),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Expanded(child: LearnMoreTab(details: _details, isFetching: _isFetching, canFetch: _canDescribe, onRefresh: _describe)),
              ],
            ),
          ),
        );
      },
    );
  }
}
