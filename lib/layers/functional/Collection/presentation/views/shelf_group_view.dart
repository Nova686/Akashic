import 'package:akashic/layers/functional/Collection/domain/entities/collection_item.dart';
import 'package:akashic/layers/functional/Collection/presentation/cubit/category_shelves_cubit.dart';
import 'package:akashic/layers/functional/Collection/presentation/cubit/category_shelves_state.dart';
import 'package:akashic/layers/functional/Collection/presentation/widgets/cover_shelf.dart';
import 'package:akashic/layers/technical/Localization/app_localizations.dart';
import 'package:akashic/layers/technical/Theme/akashic_empty_state.dart';
import 'package:akashic/layers/technical/Theme/akashic_typography.dart';
import 'package:akashic/layers/technical/Theme/safe_scroll_padding.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ShelfGroupView extends StatelessWidget {
  const ShelfGroupView({required this.groupId, required this.onOpenItem, this.onOpenSeries, super.key});

  final String groupId;
  final ValueChanged<CollectionItem> onOpenItem;
  final ValueChanged<String>? onOpenSeries;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return BlocBuilder<CategoryShelvesCubit, CategoryShelvesState>(
      builder: (context, state) {
        final found = state.findGroup(groupId);
        return Scaffold(
          appBar: AppBar(
            title: Text(
              switch (found) {
                (_, final group) when group.label.isNotEmpty => group.label,
                _ => l10n.otherItems,
              },
              style: AkashicTypography.body(size: 18, weight: FontWeight.w700),
            ),
          ),
          body: switch (found) {
            (final shelf, final group) => CoverShelf(
                groups: [group],
                preferredLanguages: state.preferredLanguages,
                categoryColorValue: shelf.category.colorValue,
                collapsedSeriesIds: const {},
                onOpenItem: onOpenItem,
                onToggleSeries: (_) {},
                onOpenSeries: onOpenSeries,
                showsWholeGroups: true,
                scrollPadding: safeListPadding(context, top: 8),
              ),
            null => Center(child: AkashicEmptyState(message: l10n.noItemMatchesArrangement)),
          },
        );
      },
    );
  }
}
