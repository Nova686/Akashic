import 'package:akashic/layers/technical/Theme/akashic_empty_state.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/collection_item.dart';
import 'package:akashic/layers/functional/Collection/domain/use_cases/resolve_display_title.dart';
import 'package:akashic/layers/functional/Stats/presentation/cubit/collection_value_cubit.dart';
import 'package:akashic/layers/functional/Stats/presentation/cubit/collection_value_state.dart';
import 'package:akashic/layers/technical/Localization/app_localizations.dart';
import 'package:akashic/layers/technical/Theme/akashic_colors.dart';
import 'package:akashic/layers/technical/Theme/akashic_typography.dart';
import 'package:akashic/layers/technical/Theme/safe_scroll_padding.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DuplicatesView extends StatelessWidget {
  const DuplicatesView({required this.onOpenItem, this.onMerge, super.key});

  final ValueChanged<String> onOpenItem;
  final void Function(CollectionItem first, CollectionItem second)? onMerge;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return BlocBuilder<CollectionValueCubit, CollectionValueState>(
      builder: (context, state) {
        final duplicates = state.duplicates;
        String titleOf(CollectionItem item) {
          final title = resolveDisplayTitle(item.titles, state.preferredLanguages) ?? l10n.untitled;
          return item.volumeNumber == null ? title : '$title ${item.volumeNumber}';
        }

        String? subtitleOf(CollectionItem item) => [?item.creator, ?item.year?.toString()].join(' · ').ifNotEmpty;

        return Scaffold(
          appBar: AppBar(title: Text(l10n.duplicatesTitle, style: AkashicTypography.displayTitle(size: 26))),
          body: switch (duplicates) {
            null => const Center(child: LabelledSpinner()),
            final found when found.count == 0 => Center(
              child: Text(l10n.noDuplicates, style: AkashicTypography.body().copyWith(color: AkashicColors.textSoft)),
            ),
            final found => ListView(
              padding: safeListPadding(context),
              children: [
                if (found.sameWork.isNotEmpty) ...[
                  Text(l10n.sameWorkSection, style: AkashicTypography.displayTitle(size: 22)),
                  for (final group in found.sameWork)
                    Card(
                      margin: const EdgeInsets.symmetric(vertical: 6),
                      child: Column(
                        children: [
                          for (final item in group)
                            ListTile(
                              title: Text(titleOf(item), style: AkashicTypography.body(size: 15, weight: FontWeight.w600)),
                              subtitle: switch (subtitleOf(item)) {
                                final subtitle? => Text(subtitle),
                                null => null,
                              },
                              trailing: const Icon(Icons.chevron_right),
                              onTap: () => onOpenItem(item.id),
                            ),
                          if ((onMerge, group) case (final merge?, [final first, final second]))
                            Padding(
                              padding: const EdgeInsets.fromLTRB(12, 0, 12, 10),
                              child: Align(alignment: Alignment.centerRight, child: OutlinedButton.icon(onPressed: () => merge(first, second), icon: const Icon(Icons.merge), label: Text(l10n.mergeAction))),
                            ),
                        ],
                      ),
                    ),
                ],
              ],
            ),
          },
        );
      },
    );
  }
}

extension on String {
  String? get ifNotEmpty => isEmpty ? null : this;
}
