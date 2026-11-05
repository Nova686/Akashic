import 'package:akashic/layers/technical/Theme/akashic_empty_state.dart';
import 'package:akashic/layers/technical/Theme/safe_bottom_sheet.dart';
import 'package:akashic/layers/functional/Lookup/domain/entities/precon_deck.dart';
import 'package:akashic/layers/functional/Collection/domain/use_cases/search_text_normalizer.dart';
import 'package:akashic/layers/functional/Collection/presentation/cubit/deck_editor_cubit.dart';
import 'package:akashic/layers/technical/Localization/app_localizations.dart';
import 'package:akashic/layers/technical/Theme/akashic_colors.dart';
import 'package:akashic/layers/technical/Theme/akashic_typography.dart';
import 'package:akashic/layers/technical/Theme/safe_scroll_padding.dart';
import 'package:akashic/layers/functional/Lookup/domain/entities/imported_deck_list.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DeckEditorView extends StatelessWidget {
  const DeckEditorView({required this.deckName, super.key});

  final String deckName;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final deck = context.read<DeckEditorCubit>();
    return BlocBuilder<DeckEditorCubit, DeckEditorState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: Text(deckName, style: AkashicTypography.body(size: 18, weight: FontWeight.w700)),
            actions: [
              if (state.canImportDeckList)
                IconButton(
                  tooltip: l10n.importDeckList,
                  onPressed: state.isImportingDeckList ? null : () => _importDeckList(context),
                  icon: state.isImportingDeckList
                      ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2))
                      : const Icon(Icons.link, color: AkashicColors.teal),
                ),
              if (state.canAddPrecon)
                IconButton(
                  tooltip: l10n.addPreconDeck,
                  onPressed: state.isAddingPrecon ? null : () => _addPrecon(context),
                  icon: state.isAddingPrecon
                      ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2))
                      : const Icon(Icons.library_add_outlined, color: AkashicColors.teal),
                ),
            ],
          ),
          body: ListView(
            padding: safeListPadding(context),
            children: [
              TextField(
                onChanged: deck.search,
                onSubmitted: state.canSearchCards ? null : (_) => deck.addTypedCard(),
                decoration: InputDecoration(
                  hintText: state.canSearchCards ? l10n.searchCard : l10n.typeCardName,
                  helperText: state.canSearchCards ? null : l10n.noApiForThisGame,
                  prefixIcon: Icon(state.canSearchCards ? Icons.search : Icons.edit_outlined),
                  suffixIcon: state.isSearching ? const Padding(padding: EdgeInsets.all(12), child: SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2))) : null,
                ),
              ),
              for (final result in state.searchResults.take(8))
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: result.imageUrl == null
                      ? null
                      : Image.network(result.imageUrl!, width: 36, height: 50, fit: BoxFit.cover, cacheWidth: 120, errorBuilder: (context, error, stack) => const SizedBox(width: 36)),
                  title: Text(result.name),
                  subtitle: result.setName == null ? null : Text(result.setName!),
                  trailing: const Icon(Icons.add, color: AkashicColors.teal),
                  onTap: () => deck.add(result),
                ),
              if (state.typedName.isNotEmpty && !state.isSearching)
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.edit_note, color: AkashicColors.lavender),
                  title: Text(l10n.addCardAsTyped(state.typedName)),
                  trailing: const Icon(Icons.add, color: AkashicColors.teal),
                  onTap: deck.addTypedCard,
                ),
              const SizedBox(height: 16),
              Text(l10n.deckCardsCount(state.totalCards), style: AkashicTypography.body(size: 15, weight: FontWeight.w800)),
              if (state.canPriceCards && state.cards.isNotEmpty) ...[
                const SizedBox(height: 6),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        state.valueByCurrency.isEmpty
                            ? l10n.deckValueUnknown
                            : l10n.deckEstimatedValue(state.valueByCurrency.entries.map((entry) => formatMoney(entry.value, entry.key, l10n.localeName)).join(' · ')),
                        style: AkashicTypography.body(size: 13, weight: FontWeight.w600).copyWith(color: AkashicColors.teal),
                      ),
                    ),
                    TextButton.icon(
                      onPressed: state.isPricing ? null : deck.updatePrices,
                      icon: state.isPricing ? const SizedBox(width: 14, height: 14, child: CircularProgressIndicator(strokeWidth: 2)) : const Icon(Icons.euro, size: 16),
                      label: Text(l10n.updateCardPrices),
                    ),
                  ],
                ),
              ],
              for (final card in state.cards)
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(card.name),
                  subtitle: switch (card.price) {
                    final price? => Text(formatMoney(price.cents, price.currency, l10n.localeName), style: AkashicTypography.body(size: 12).copyWith(color: AkashicColors.textSoft)),
                    null => null,
                  },
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(tooltip: l10n.removeOneCard, icon: const Icon(Icons.remove), onPressed: () => deck.setQuantity(card.id, card.quantity - 1)),
                      Text('${card.quantity}', style: AkashicTypography.numeral(size: 15)),
                      IconButton(tooltip: l10n.addOneCard, icon: const Icon(Icons.add), onPressed: () => deck.setQuantity(card.id, card.quantity + 1)),
                      IconButton(tooltip: l10n.deleteCard, icon: const Icon(Icons.delete_outline), onPressed: () => deck.remove(card.id)),
                    ],
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _importDeckList(BuildContext context) async {
    final deck = context.read<DeckEditorCubit>();
    final messenger = ScaffoldMessenger.of(context);
    final l10n = AppLocalizations.of(context);
    final link = await showDialog<String>(context: context, builder: (dialogContext) => const _DeckLinkDialog());
    if (link == null || link.trim().isEmpty) {
      return;
    }
    try {
      if (await deck.importDeckList(link) case (final name, final added)) {
        messenger.showSnackBar(SnackBar(content: Text(l10n.preconDeckAdded(added, name))));
      }
    } on DeckListNotFound {
      messenger.showSnackBar(SnackBar(content: Text(l10n.deckListNotFound)));
    }
  }

  Future<void> _addPrecon(BuildContext context) async {
    final deck = context.read<DeckEditorCubit>();
    final messenger = ScaffoldMessenger.of(context);
    final l10n = AppLocalizations.of(context);
    final chosen = await showSafeBottomSheet<PreconDeck>(
      context: context,
      isScrollControlled: true,
      builder: (sheetContext) => FractionallySizedBox(heightFactor: 0.85, child: _PreconPicker(decks: deck.precons())),
    );
    if (chosen == null) {
      return;
    }
    final added = await deck.addPrecon(chosen);
    if (added != null) {
      messenger.showSnackBar(SnackBar(content: Text(l10n.preconDeckAdded(added, chosen.name))));
    }
  }
}

class _PreconPicker extends StatefulWidget {
  const _PreconPicker({required this.decks});

  final Future<List<PreconDeck>> decks;

  @override
  State<_PreconPicker> createState() => _PreconPickerState();
}

class _PreconPickerState extends State<_PreconPicker> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(l10n.addPreconDeck, style: AkashicTypography.displayTitle(size: 24)),
          const SizedBox(height: 8),
          TextField(
            autofocus: true,
            onChanged: (query) => setState(() => _query = normalizeForSearch(query)),
            decoration: InputDecoration(hintText: l10n.searchPreconDeck, prefixIcon: const Icon(Icons.search)),
          ),
          Expanded(
            child: FutureBuilder<List<PreconDeck>>(
              future: widget.decks,
              builder: (context, snapshot) {
                final decks = snapshot.data;
                if (decks == null) {
                  return const Center(child: LabelledSpinner());
                }
                final shown = [
                  for (final deck in decks)
                    if (_query.isEmpty || normalizeForSearch('${deck.name} ${deck.setCode ?? ''} ${deck.type}').contains(_query)) deck,
                ];
                if (shown.isEmpty) {
                  return Center(child: Text(l10n.noPreconDeckFound, style: AkashicTypography.body(size: 14).copyWith(color: AkashicColors.textSoft)));
                }
                return ListView.builder(
                  itemCount: shown.length,
                  itemBuilder: (context, index) {
                    final deck = shown[index];
                    return ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(deck.name, maxLines: 1, overflow: TextOverflow.ellipsis),
                      subtitle: Text(
                        [deck.type, ?deck.setCode, if (deck.releaseDate case final released?) '${released.year}'].join(' · '),
                        style: AkashicTypography.body(size: 12).copyWith(color: AkashicColors.textSoft),
                      ),
                      onTap: () => Navigator.of(context).pop(deck),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

String formatMoney(int cents, String currency, String localeName) => NumberFormat.simpleCurrency(locale: localeName, name: currency).format(cents / 100);

class _DeckLinkDialog extends StatefulWidget {
  const _DeckLinkDialog();

  @override
  State<_DeckLinkDialog> createState() => _DeckLinkDialogState();
}

class _DeckLinkDialogState extends State<_DeckLinkDialog> {
  final TextEditingController _link = TextEditingController();

  @override
  void dispose() {
    _link.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return AlertDialog(
      title: Text(l10n.importDeckList),
      content: TextField(
        controller: _link,
        autofocus: true,
        keyboardType: TextInputType.url,
        decoration: InputDecoration(labelText: l10n.deckListLink, hintText: 'https://archidekt.com/decks/…'),
        onSubmitted: (link) => Navigator.of(context).pop(link),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.of(context).pop(), child: Text(l10n.cancel)),
        FilledButton(onPressed: () => Navigator.of(context).pop(_link.text), child: Text(l10n.discogsImportStart)),
      ],
    );
  }
}
