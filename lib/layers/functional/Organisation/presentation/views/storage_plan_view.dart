import 'package:akashic/layers/functional/Organisation/domain/entities/storage_place.dart';
import 'package:akashic/layers/functional/Organisation/presentation/cubit/storage_plan_cubit.dart';
import 'package:akashic/layers/technical/Localization/app_localizations.dart';
import 'package:akashic/layers/technical/Theme/akashic_colors.dart';
import 'package:akashic/layers/technical/Theme/akashic_empty_state.dart';
import 'package:akashic/layers/technical/Theme/akashic_typography.dart';
import 'package:akashic/layers/technical/Theme/safe_scroll_padding.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Future<String?> askPlaceName(BuildContext context, {required String title, String initial = ''}) async {
  final l10n = AppLocalizations.of(context);
  final controller = TextEditingController(text: initial);
  final name = await showDialog<String>(
    context: context,
    builder: (dialogContext) => AlertDialog(
      title: Text(title),
      content: TextField(controller: controller, autofocus: true, onSubmitted: (value) => Navigator.of(dialogContext).pop(value), decoration: InputDecoration(labelText: l10n.placeName, hintText: l10n.placeNameHint)),
      actions: [
        TextButton(onPressed: () => Navigator.of(dialogContext).pop(), child: Text(l10n.cancel)),
        FilledButton(onPressed: () => Navigator.of(dialogContext).pop(controller.text), child: Text(l10n.save)),
      ],
    ),
  );
  controller.dispose();
  return name == null || name.trim().isEmpty ? null : name.trim();
}

class StoragePlanView extends StatelessWidget {
  const StoragePlanView({required this.onWhereIs, super.key});

  final VoidCallback onWhereIs;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final cubit = context.read<StoragePlanCubit>();
    return BlocBuilder<StoragePlanCubit, StoragePlanState>(
      builder: (context, state) {
        final plan = state.plan;
        return Scaffold(
          appBar: AppBar(
            title: Text(l10n.storagePlan, style: AkashicTypography.displayTitle(size: 26)),
            actions: [IconButton(tooltip: l10n.whereIs, icon: const Icon(Icons.travel_explore), onPressed: onWhereIs)],
          ),
          body: state.isLoading
              ? const AkashicLoader()
              : ListView(
                  padding: safeListPadding(context, bottom: 96),
                  children: [
                    Text(l10n.storagePlanHint, style: AkashicTypography.body(size: 13).copyWith(color: AkashicColors.textSoft)),
                    if (plan.isEmpty) Padding(padding: const EdgeInsets.only(top: 30), child: AkashicEmptyState(message: l10n.storagePlanEmpty)),
                    for (final room in plan.childrenOf(null)) _PlaceBranch(place: room, depth: 0, state: state, cubit: cubit),
                  ],
                ),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () async {
              final name = await askPlaceName(context, title: l10n.newRoom);
              if (name != null) {
                await cubit.addPlace(name);
              }
            },
            icon: const Icon(Icons.add_home_outlined),
            label: Text(l10n.newRoom),
          ),
        );
      },
    );
  }
}

class _PlaceBranch extends StatelessWidget {
  const _PlaceBranch({required this.place, required this.depth, required this.state, required this.cubit});

  final StoragePlace place;
  final int depth;
  final StoragePlanState state;
  final StoragePlanCubit cubit;

  static const int maximumDepth = 2;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final plan = state.plan;
    final count = state.countUnder(plan.pathOf(place.id));
    final children = plan.childrenOf(place.id);
    final tile = Container(
      margin: EdgeInsets.only(top: 6, left: depth * 18.0),
      decoration: BoxDecoration(color: depth == 0 ? AkashicColors.surface : Colors.transparent, borderRadius: BorderRadius.circular(14), border: Border.all(color: AkashicColors.line)),
      child: ListTile(
        leading: Icon(switch (depth) { 0 => Icons.meeting_room_outlined, 1 => Icons.shelves, _ => Icons.view_stream_outlined }, color: AkashicColors.lavender),
        title: Text(place.name, style: AkashicTypography.body(size: 15, weight: depth == 0 ? FontWeight.w800 : FontWeight.w700)),
        subtitle: Text(l10n.placeItemCount(count), style: AkashicTypography.body(size: 12).copyWith(color: AkashicColors.textSoft)),
        trailing: PopupMenuButton<String>(
          tooltip: l10n.placeActions(place.name),
          onSelected: (action) async {
            switch (action) {
              case 'add':
                final name = await askPlaceName(context, title: depth == 0 ? l10n.newFurniture : l10n.newShelf);
                if (name != null) {
                  await cubit.addPlace(name, parentId: place.id);
                }
              case 'rename':
                final name = await askPlaceName(context, title: l10n.renamePlace, initial: place.name);
                if (name != null) {
                  await cubit.rename(place, name);
                }
              case 'delete':
                await cubit.remove(place);
            }
          },
          itemBuilder: (menuContext) => [
            if (depth < maximumDepth) PopupMenuItem(value: 'add', child: Text(depth == 0 ? l10n.newFurniture : l10n.newShelf)),
            PopupMenuItem(value: 'rename', child: Text(l10n.renamePlace)),
            PopupMenuItem(value: 'delete', child: Text(l10n.deletePlace)),
          ],
        ),
      ),
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        tile,
        for (final child in children) _PlaceBranch(place: child, depth: depth + 1, state: state, cubit: cubit),
      ],
    );
  }
}

class WhereIsView extends StatelessWidget {
  const WhereIsView({required this.onOpenItem, super.key});

  final ValueChanged<String> onOpenItem;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final cubit = context.read<StoragePlanCubit>();
    return BlocBuilder<StoragePlanCubit, StoragePlanState>(
      builder: (context, state) => Scaffold(
        appBar: AppBar(title: Text(l10n.whereIs, style: AkashicTypography.displayTitle(size: 26))),
        body: ListView(
          padding: safeListPadding(context),
          children: [
            TextField(
              autofocus: true,
              onChanged: cubit.search,
              textInputAction: TextInputAction.search,
              decoration: InputDecoration(prefixIcon: const Icon(Icons.search), labelText: l10n.whereIsHint),
            ),
            const SizedBox(height: 10),
            if (state.query.trim().isNotEmpty && state.answers.isEmpty) Padding(padding: const EdgeInsets.only(top: 20), child: AkashicEmptyState(message: l10n.whereIsNothing)),
            for (final answer in state.answers)
              Card(
                margin: const EdgeInsets.only(top: 8),
                child: ListTile(
                  onTap: () => onOpenItem(answer.item.id),
                  title: Text(answer.title, maxLines: 2, overflow: TextOverflow.ellipsis, style: AkashicTypography.body(size: 15, weight: FontWeight.w700)),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Row(
                      children: [
                        Icon(
                          switch (answer) { WhereIsAnswer(borrower: _?) => Icons.person_outline, WhereIsAnswer(location: _?) => Icons.place_outlined, _ => Icons.help_outline },
                          size: 16,
                          color: switch (answer) { WhereIsAnswer(borrower: _?) => AkashicColors.lavender, WhereIsAnswer(location: _?) => AkashicColors.teal, _ => AkashicColors.gold },
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            switch (answer) {
                              WhereIsAnswer(borrower: final borrower?) => l10n.lentToBorrower(borrower),
                              WhereIsAnswer(location: final location?) => location,
                              _ => l10n.notStoredYet,
                            },
                            style: AkashicTypography.body(size: 14, weight: FontWeight.w700).copyWith(color: AkashicColors.text),
                          ),
                        ),
                      ],
                    ),
                  ),
                  trailing: const Icon(Icons.chevron_right),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

Future<String?> pickStoragePlace(BuildContext context, List<StoragePlace> places) {
  final plan = StoragePlan(places);
  return showModalBottomSheet<String>(
    context: context,
    showDragHandle: true,
    isScrollControlled: true,
    builder: (sheetContext) => _PlacePicker(plan: plan),
  );
}

class _PlacePicker extends StatefulWidget {
  const _PlacePicker({required this.plan});

  final StoragePlan plan;

  @override
  State<_PlacePicker> createState() => _PlacePickerState();
}

class _PlacePickerState extends State<_PlacePicker> {
  String? _current;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final current = _current;
    final children = widget.plan.childrenOf(current);
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(18, 0, 18, 12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(l10n.chooseStoragePlace, style: AkashicTypography.displayTitle(size: 22)),
            const SizedBox(height: 4),
            Text(current == null ? l10n.storagePlan : widget.plan.pathOf(current), style: AkashicTypography.body(size: 13, weight: FontWeight.w700).copyWith(color: AkashicColors.teal)),
            const SizedBox(height: 8),
            if (widget.plan.isEmpty) Text(l10n.storagePlanEmpty, style: AkashicTypography.body(size: 13).copyWith(color: AkashicColors.textSoft)),
            ConstrainedBox(
              constraints: BoxConstraints(maxHeight: MediaQuery.sizeOf(context).height * 0.45),
              child: ListView(
                shrinkWrap: true,
                children: [
                  for (final place in children)
                    ListTile(
                      title: Text(place.name, style: AkashicTypography.body(weight: FontWeight.w700)),
                      subtitle: widget.plan.childrenOf(place.id).isEmpty ? null : Text(l10n.placeChildren(widget.plan.childrenOf(place.id).length)),
                      trailing: widget.plan.childrenOf(place.id).isEmpty ? null : const Icon(Icons.chevron_right),
                      onTap: () => widget.plan.childrenOf(place.id).isEmpty ? Navigator.of(context).pop(widget.plan.pathOf(place.id)) : setState(() => _current = place.id),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                if (current != null)
                  Expanded(child: OutlinedButton.icon(onPressed: () => setState(() => _current = widget.plan.chainOf(current).reversed.skip(1).firstOrNull?.id), icon: const Icon(Icons.arrow_upward), label: Text(l10n.goUp))),
                if (current != null) const SizedBox(width: 10),
                if (current != null) Expanded(child: FilledButton(onPressed: () => Navigator.of(context).pop(widget.plan.pathOf(current)), child: Text(l10n.storeHere))),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
