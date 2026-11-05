import 'package:akashic/layers/functional/Collection/domain/entities/collection_item.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/shelf_group.dart';
import 'package:akashic/layers/functional/Collection/presentation/widgets/cover_shelf.dart';
import 'package:akashic/layers/functional/Collection/presentation/widgets/shelf_arrangement_sheet.dart';
import 'package:akashic/layers/functional/Organisation/presentation/cubit/smart_shelves_cubit.dart';
import 'package:akashic/layers/functional/Settings/domain/entities/preferred_languages.dart';
import 'package:akashic/layers/technical/Localization/app_localizations.dart';
import 'package:akashic/layers/technical/Theme/akashic_colors.dart';
import 'package:akashic/layers/technical/Theme/akashic_typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SmartShelvesSection extends StatelessWidget {
  const SmartShelvesSection({required this.onOpenShelf, required this.onOpenItem, super.key});

  final ValueChanged<String> onOpenShelf;
  final ValueChanged<CollectionItem> onOpenItem;

  static const int coversShown = 12;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return BlocBuilder<SmartShelvesCubit, List<FilledSmartShelf>>(
      builder: (context, shelves) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (final filled in shelves) ...[
            const SizedBox(height: 16),
            Semantics(
              button: true,
              label: l10n.smartShelfLabel(filled.shelf.name, filled.items.length),
              excludeSemantics: true,
              onTap: () => onOpenShelf(filled.shelf.id),
              child: InkWell(
                onTap: () => onOpenShelf(filled.shelf.id),
                borderRadius: BorderRadius.circular(10),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(minHeight: 48),
                  child: Row(
                    children: [
                      Container(
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(color: AkashicColors.teal, borderRadius: BorderRadius.circular(6)),
                        child: const Icon(Icons.auto_awesome, size: 15, color: AkashicColors.night),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(filled.shelf.name, maxLines: 1, overflow: TextOverflow.ellipsis, style: AkashicTypography.displayTitle(size: 20)),
                            Text(
                              shelfFilterLabels(filled.shelf.filter, l10n, null).join(' · '),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AkashicTypography.body(size: 12, weight: FontWeight.w600).copyWith(color: AkashicColors.teal),
                            ),
                          ],
                        ),
                      ),
                      Text('${filled.items.length}', style: AkashicTypography.numeral(size: 18)),
                      Icon(Icons.chevron_right, color: AkashicColors.textSoft),
                    ],
                  ),
                ),
              ),
            ),
            if (filled.items.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Text(l10n.smartShelfEmpty, style: AkashicTypography.body(size: 13).copyWith(color: AkashicColors.textSoft)),
              )
            else
              CoverShelf(
                groups: [
                  ShelfGroup(id: filled.shelf.id, label: '', isSeries: false, ownedCount: filled.items.length, entries: [for (final item in filled.items.take(coversShown)) ShelfItem(item)]),
                ],
                preferredLanguages: PreferredLanguages.defaults,
                categoryColorValue: filled.categoryColorValue,
                collapsedSeriesIds: const {},
                onOpenItem: onOpenItem,
                onToggleSeries: (_) {},
                hidesGroupHeaders: true,
              ),
          ],
        ],
      ),
    );
  }
}

class SmartShelfView extends StatelessWidget {
  const SmartShelfView({required this.shelfId, required this.onOpenItem, super.key});

  final String shelfId;
  final ValueChanged<CollectionItem> onOpenItem;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return BlocBuilder<SmartShelvesCubit, List<FilledSmartShelf>>(
      builder: (context, shelves) {
        final filled = shelves.where((candidate) => candidate.shelf.id == shelfId).firstOrNull;
        return Scaffold(
          appBar: AppBar(
            title: Text(filled?.shelf.name ?? '', style: AkashicTypography.body(size: 18, weight: FontWeight.w700)),
            actions: [
              if (filled != null)
                IconButton(
                  tooltip: l10n.deleteSmartShelf,
                  icon: const Icon(Icons.delete_outline),
                  onPressed: () async {
                    final navigator = Navigator.of(context);
                    await context.read<SmartShelvesCubit>().delete(shelfId);
                    navigator.maybePop();
                  },
                ),
            ],
          ),
          body: filled == null || filled.items.isEmpty
              ? Center(child: Text(l10n.smartShelfEmpty, style: AkashicTypography.body().copyWith(color: AkashicColors.textSoft)))
              : CoverShelf(
                  groups: [ShelfGroup(id: filled.shelf.id, label: filled.shelf.name, isSeries: false, ownedCount: filled.items.length, entries: [for (final item in filled.items) ShelfItem(item)])],
                  preferredLanguages: PreferredLanguages.defaults,
                  categoryColorValue: filled.categoryColorValue,
                  collapsedSeriesIds: const {},
                  onOpenItem: onOpenItem,
                  onToggleSeries: (_) {},
                  showsWholeGroups: true,
                  scrollPadding: EdgeInsets.fromLTRB(16, 8, 16, 24 + MediaQuery.paddingOf(context).bottom),
                ),
        );
      },
    );
  }
}
