import 'package:akashic/layers/functional/Lookup/domain/entities/card_game.dart';
import 'package:akashic/layers/technical/Localization/app_localizations.dart';
import 'package:akashic/layers/technical/Theme/akashic_colors.dart';
import 'package:akashic/layers/technical/Theme/akashic_typography.dart';
import 'package:flutter/material.dart';

class CardGameSuggestions extends StatelessWidget {
  const CardGameSuggestions({required this.existingNames, required this.onPicked, super.key});

  final Iterable<String> existingNames;
  final ValueChanged<String> onPicked;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final presentGames = existingNames.map(cardGameNamed).nonNulls.toSet();
    final suggestedGames = CardGame.values.where((game) => !presentGames.contains(game)).toList();
    if (suggestedGames.isEmpty) {
      return const SizedBox.shrink();
    }
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l10n.cardGamesWithCatalogue, style: AkashicTypography.body(size: 12).copyWith(color: AkashicColors.textSoft)),
          const SizedBox(height: 6),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final game in suggestedGames)
                ActionChip(
                  avatar: const Icon(Icons.add, size: 18, color: AkashicColors.teal),
                  label: Text(game.displayName),
                  onPressed: () => onPicked(game.displayName),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

Future<String?> askSubcategoryName(BuildContext context, {required bool suggestsCardGames, required Iterable<String> existingNames}) {
  return showDialog<String>(
    context: context,
    builder: (dialogContext) => _SubcategoryNameDialog(suggestsCardGames: suggestsCardGames, existingNames: existingNames),
  );
}

class _SubcategoryNameDialog extends StatefulWidget {
  const _SubcategoryNameDialog({required this.suggestsCardGames, required this.existingNames});

  final bool suggestsCardGames;
  final Iterable<String> existingNames;

  @override
  State<_SubcategoryNameDialog> createState() => _SubcategoryNameDialogState();
}

class _SubcategoryNameDialogState extends State<_SubcategoryNameDialog> {
  final TextEditingController _nameController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _submit(String name) {
    if (name.trim().isNotEmpty) {
      Navigator.of(context).pop(name.trim());
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return AlertDialog(
      title: Text(l10n.addSubcategory),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _nameController,
              textInputAction: TextInputAction.done,
              onSubmitted: _submit,
              decoration: InputDecoration(hintText: l10n.subcategoryName),
            ),
            if (widget.suggestsCardGames) ...[
              const SizedBox(height: 8),
              CardGameSuggestions(existingNames: widget.existingNames, onPicked: _submit),
              Text(l10n.otherCardGamesByHand, style: AkashicTypography.body(size: 12).copyWith(color: AkashicColors.textFaint)),
            ],
          ],
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.of(context).pop(), child: Text(l10n.cancel)),
        FilledButton(onPressed: () => _submit(_nameController.text), child: Text(l10n.add)),
      ],
    );
  }
}
