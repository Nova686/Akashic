import 'package:akashic/layers/functional/Organisation/domain/gateways/organisation_gateways.dart';
import 'package:akashic/layers/technical/Localization/app_localizations.dart';
import 'package:akashic/layers/technical/Theme/akashic_colors.dart';
import 'package:akashic/layers/technical/Theme/akashic_typography.dart';
import 'package:flutter/material.dart';

List<String> suggestedTags(AppLocalizations l10n) => [l10n.tagSigned, l10n.tagToSell, l10n.tagGift, l10n.tagToReread, l10n.tagLimitedEdition];

class ItemTagsEditor extends StatelessWidget {
  const ItemTagsEditor({required this.itemId, required this.tags, super.key});

  final String itemId;
  final TagGateway tags;

  static const int suggestionsShown = 5;

  Future<void> _askNewTag(BuildContext context, Set<String> current) async {
    final l10n = AppLocalizations.of(context);
    final controller = TextEditingController();
    final name = await showDialog<String>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.newTag),
        content: TextField(controller: controller, autofocus: true, textInputAction: TextInputAction.done, onSubmitted: (value) => Navigator.of(dialogContext).pop(value), decoration: InputDecoration(labelText: l10n.tagName)),
        actions: [
          TextButton(onPressed: () => Navigator.of(dialogContext).pop(), child: Text(l10n.cancel)),
          FilledButton(onPressed: () => Navigator.of(dialogContext).pop(controller.text), child: Text(l10n.add)),
        ],
      ),
    );
    controller.dispose();
    if (name != null && name.trim().isNotEmpty) {
      await tags.setTags(itemId, {...current, name.trim()});
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return StreamBuilder<Set<String>>(
      stream: tags.watchTagsOf(itemId),
      builder: (context, snapshot) {
        final current = snapshot.data ?? const <String>{};
        return StreamBuilder<Map<String, int>>(
          stream: tags.watchTagCounts(),
          builder: (context, counts) {
            final used = (counts.data?.entries.toList() ?? [])..sort((first, second) => second.value.compareTo(first.value));
            final suggestions = <String>{
              for (final entry in used) entry.key,
              ...suggestedTags(l10n),
            }.where((tag) => !current.contains(tag)).take(suggestionsShown);
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 12),
                Text(l10n.tagsTitle, style: AkashicTypography.body(size: 15, weight: FontWeight.w800)),
                const SizedBox(height: 6),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    for (final tag in current.toList()..sort())
                      InputChip(
                        label: Text(tag),
                        selected: true,
                        showCheckmark: false,
                        selectedColor: AkashicColors.lavender,
                        labelStyle: AkashicTypography.body(size: 13, weight: FontWeight.w700).copyWith(color: AkashicColors.night),
                        deleteIconColor: AkashicColors.night,
                        deleteButtonTooltipMessage: l10n.removeTag(tag),
                        onDeleted: () => tags.setTags(itemId, {...current}..remove(tag)),
                        onSelected: (_) {},
                      ),
                    for (final tag in suggestions)
                      ActionChip(
                        avatar: const Icon(Icons.add, size: 16),
                        label: Text(tag),
                        tooltip: l10n.addTag(tag),
                        onPressed: () => tags.setTags(itemId, {...current, tag}),
                      ),
                    ActionChip(
                      avatar: const Icon(Icons.edit_outlined, size: 16),
                      label: Text(l10n.newTag),
                      onPressed: () => _askNewTag(context, current),
                    ),
                  ],
                ),
              ],
            );
          },
        );
      },
    );
  }
}
