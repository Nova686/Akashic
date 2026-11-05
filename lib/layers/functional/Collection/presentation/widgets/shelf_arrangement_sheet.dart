import 'package:akashic/layers/technical/Theme/safe_bottom_sheet.dart';
import 'package:akashic/layers/functional/Catalog/domain/entities/category_type.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/item_progress.dart';
import 'package:akashic/layers/functional/Collection/domain/use_cases/arrange_shelf.dart';
import 'package:akashic/layers/functional/Collection/presentation/widgets/progress_section.dart';
import 'package:akashic/layers/technical/Localization/app_localizations.dart';
import 'package:akashic/layers/technical/Theme/akashic_colors.dart';
import 'package:akashic/layers/technical/Theme/akashic_typography.dart';
import 'package:flutter/material.dart';

typedef ShelfArrangement = ({ShelfSort sort, ShelfFilter filter, String? smartShelfName});

String shelfSortLabel(ShelfSort sort, AppLocalizations l10n) => switch (sort) {
  ShelfSort.bySeries => l10n.sortBySeries,
  ShelfSort.title => l10n.sortByTitle,
  ShelfSort.creator => l10n.sortByCreator,
  ShelfSort.newest => l10n.sortNewest,
  ShelfSort.oldest => l10n.sortOldest,
  ShelfSort.bestRated => l10n.sortBestRated,
  ShelfSort.recentlyAdded => l10n.sortRecentlyAdded,
  ShelfSort.pricePaid => l10n.sortByPricePaid,
  ShelfSort.location => l10n.sortByLocation,
};

List<String> shelfFilterLabels(ShelfFilter filter, AppLocalizations l10n, CategoryType? categoryType) => [
      if (filter.progressStatus case final status?) progressStatusLabel(status, categoryType, l10n),
      if (filter.minimumRating case final stars?) l10n.filterAtLeastStars(stars),
      if (filter.sealing case final sealing?) sealing == SealingFilter.sealed ? l10n.sealedState : l10n.openedState,
      if (filter.onlyLent) l10n.filterLent,
      ?filter.location,
      if (filter.tag case final tag?) '#$tag',
    ];

Future<ShelfArrangement?> pickShelfArrangement(BuildContext context, {required ShelfSort sort, required ShelfFilter filter, required CategoryType? categoryType, List<String> locations = const [], List<String> tags = const [], bool canSaveAsShelf = false}) {
  return showSafeBottomSheet<ShelfArrangement>(
    context: context,
    isScrollControlled: true,
    builder: (sheetContext) => _ShelfArrangementSheet(sort: sort, filter: filter, categoryType: categoryType, locations: locations, tags: tags, canSaveAsShelf: canSaveAsShelf),
  );
}

class _ShelfArrangementSheet extends StatefulWidget {
  const _ShelfArrangementSheet({required this.sort, required this.filter, required this.categoryType, required this.locations, required this.tags, required this.canSaveAsShelf});

  final ShelfSort sort;
  final ShelfFilter filter;
  final CategoryType? categoryType;
  final List<String> locations;
  final List<String> tags;
  final bool canSaveAsShelf;

  @override
  State<_ShelfArrangementSheet> createState() => _ShelfArrangementSheetState();
}

class _ShelfArrangementSheetState extends State<_ShelfArrangementSheet> {
  late ShelfSort _sort = widget.sort;
  late ProgressStatus? _status = widget.filter.progressStatus;
  late int? _minimumRating = widget.filter.minimumRating;
  late SealingFilter? _sealing = widget.filter.sealing;
  late bool _onlyLent = widget.filter.onlyLent;
  late String? _location = widget.filter.location;
  late String? _tag = widget.filter.tag;
  bool _saveAsShelf = false;
  final TextEditingController _shelfName = TextEditingController();

  ShelfFilter get _filter => ShelfFilter(progressStatus: _status, minimumRating: _minimumRating, sealing: _sealing, onlyLent: _onlyLent, location: _location, tag: _tag);

  @override
  void dispose() {
    _shelfName.dispose();
    super.dispose();
  }

  Widget _chip(String label, {required bool selected, required VoidCallback onTap}) => ChoiceChip(
    label: Text(label),
    selected: selected,
    showCheckmark: false,
    selectedColor: AkashicColors.lavender,
    labelStyle: AkashicTypography.body(size: 13, weight: FontWeight.w600).copyWith(color: selected ? AkashicColors.night : AkashicColors.text),
    onSelected: (_) => onTap(),
  );

  Widget _section(String title, List<Widget> chips) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const SizedBox(height: 16),
      Text(title, style: AkashicTypography.body(size: 14, weight: FontWeight.w800)),
      const SizedBox(height: 8),
      Wrap(spacing: 8, runSpacing: 8, children: chips),
    ],
  );

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(18, 18, 18, 12 + MediaQuery.viewPaddingOf(context).bottom),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(l10n.arrangeShelf, style: AkashicTypography.displayTitle(size: 24)),
          _section(l10n.sortTitle, [for (final sort in ShelfSort.values) _chip(shelfSortLabel(sort, l10n), selected: _sort == sort, onTap: () => setState(() => _sort = sort))]),
          if (tracksProgress(widget.categoryType))
            _section(l10n.progressTitle, [
              _chip(l10n.filterAll, selected: _status == null, onTap: () => setState(() => _status = null)),
              for (final status in progressStatusesFor(widget.categoryType))
                _chip(progressStatusLabel(status, widget.categoryType, l10n), selected: _status == status, onTap: () => setState(() => _status = status)),
            ]),
          _section(l10n.filterMinimumRating, [
            _chip(l10n.filterAll, selected: _minimumRating == null, onTap: () => setState(() => _minimumRating = null)),
            for (final stars in [3, 4, 5]) _chip(l10n.filterAtLeastStars(stars), selected: _minimumRating == stars, onTap: () => setState(() => _minimumRating = stars)),
          ]),
          _section(l10n.filtersTitle, [
            if (widget.categoryType == CategoryType.cards) ...[
              _chip(l10n.sealedState, selected: _sealing == SealingFilter.sealed, onTap: () => setState(() => _sealing = _sealing == SealingFilter.sealed ? null : SealingFilter.sealed)),
              _chip(l10n.openedState, selected: _sealing == SealingFilter.opened, onTap: () => setState(() => _sealing = _sealing == SealingFilter.opened ? null : SealingFilter.opened)),
            ],
            _chip(l10n.filterLent, selected: _onlyLent, onTap: () => setState(() => _onlyLent = !_onlyLent)),
          ]),
          if (widget.locations.isNotEmpty)
            _section(l10n.storedAt, [
              _chip(l10n.filterAll, selected: _location == null, onTap: () => setState(() => _location = null)),
              for (final location in widget.locations) _chip(location, selected: _location == location, onTap: () => setState(() => _location = location)),
            ]),
          if (widget.tags.isNotEmpty)
            _section(l10n.tagsTitle, [
              _chip(l10n.filterAll, selected: _tag == null, onTap: () => setState(() => _tag = null)),
              for (final tag in widget.tags) _chip(tag, selected: _tag == tag, onTap: () => setState(() => _tag = tag)),
            ]),
          if (widget.canSaveAsShelf && _filter.isActive) ...[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.fromLTRB(12, 4, 12, 12),
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(14), border: Border.all(color: AkashicColors.teal, width: 1.5)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    value: _saveAsShelf,
                    onChanged: (value) => setState(() {
                      _saveAsShelf = value;
                      if (value && _shelfName.text.isEmpty) {
                        _shelfName.text = shelfFilterLabels(_filter, l10n, widget.categoryType).join(' · ');
                      }
                    }),
                    secondary: const Icon(Icons.auto_awesome, color: AkashicColors.teal),
                    title: Text(l10n.saveFilterAsShelf, style: AkashicTypography.body(size: 14, weight: FontWeight.w700)),
                    subtitle: Text(l10n.saveFilterAsShelfHint, style: AkashicTypography.body(size: 12).copyWith(color: AkashicColors.textSoft)),
                  ),
                  if (_saveAsShelf) TextField(controller: _shelfName, decoration: InputDecoration(labelText: l10n.smartShelfName)),
                ],
              ),
            ),
          ],
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(onPressed: () => Navigator.of(context).pop((sort: ShelfSort.bySeries, filter: const ShelfFilter(), smartShelfName: null)), child: Text(l10n.resetArrangement)),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: FilledButton(
                  onPressed: () => Navigator.of(context).pop((
                    sort: _sort,
                    filter: _filter,
                    smartShelfName: _saveAsShelf && _filter.isActive && _shelfName.text.trim().isNotEmpty ? _shelfName.text.trim() : null,
                  )),
                  child: Text(l10n.applyArrangement),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
