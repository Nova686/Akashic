import 'package:akashic/layers/functional/Settings/domain/use_cases/manage_app_language.dart';
import 'package:akashic/layers/functional/Settings/presentation/widgets/language_names.dart';
import 'package:akashic/layers/technical/Localization/app_localizations.dart';
import 'package:akashic/layers/technical/Theme/akashic_colors.dart';
import 'package:akashic/layers/technical/Theme/akashic_typography.dart';
import 'package:flutter/material.dart';

class AppLanguagePicker extends StatelessWidget {
  const AppLanguagePicker({required this.selectedCode, required this.onSelected, super.key});

  final String? selectedCode;
  final ValueChanged<String?> onSelected;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Row(
      children: [
        for (final (index, code) in [null, ...ManageAppLanguage.supportedLanguageCodes].indexed) ...[
          if (index > 0) const SizedBox(width: 10),
          Expanded(
            child: _LanguageCard(
              symbol: code == null ? null : languageFlag(code),
              label: code == null ? l10n.followDevice : languageEndonym(l10n, code),
              isSelected: selectedCode == code,
              onTap: () => onSelected(code),
            ),
          ),
        ],
      ],
    );
  }
}

class _LanguageCard extends StatelessWidget {
  const _LanguageCard({required this.symbol, required this.label, required this.isSelected, required this.onTap});

  final String? symbol;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      selected: isSelected,
      button: true,
      child: Material(
        color: isSelected ? AkashicColors.lavender.withValues(alpha: 0.16) : AkashicColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: isSelected ? AkashicColors.lavender : AkashicColors.line, width: isSelected ? 2 : 1),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 18, 8, 12),
                child: Column(
                  children: [
                    SizedBox(
                      height: 36,
                      child: Center(
                        child: switch (symbol) {
                          final flag? => Text(flag, style: const TextStyle(fontSize: 28, height: 1)),
                          null => const Icon(Icons.smartphone, size: 28, color: AkashicColors.teal),
                        },
                      ),
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      height: 32,
                      child: Center(
                        child: Text(
                          label,
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: AkashicTypography.body(size: 13, weight: isSelected ? FontWeight.w700 : FontWeight.w600)
                              .copyWith(color: isSelected ? AkashicColors.text : AkashicColors.textSoft, height: 1.15),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              if (isSelected) const Positioned(top: 6, right: 6, child: Icon(Icons.check_circle, size: 16, color: AkashicColors.lavender)),
            ],
          ),
        ),
      ),
    );
  }
}

class TitleLanguagesEditor extends StatelessWidget {
  const TitleLanguagesEditor({
    required this.orderedCodes,
    required this.addableCodes,
    required this.onMove,
    required this.onRemove,
    required this.onAdd,
    super.key,
  });

  final List<String> orderedCodes;
  final List<String> addableCodes;
  final void Function(int oldIndex, int newIndex) onMove;
  final ValueChanged<String> onRemove;
  final ValueChanged<String> onAdd;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        DecoratedBox(
          decoration: BoxDecoration(color: AkashicColors.surface, borderRadius: BorderRadius.circular(16), border: Border.all(color: AkashicColors.line)),
          child: ReorderableListView(
            shrinkWrap: true,
            buildDefaultDragHandles: false,
            physics: const NeverScrollableScrollPhysics(),
            onReorderItem: onMove,
            children: [
              for (final (index, code) in orderedCodes.indexed)
                _RankedLanguage(
                  key: ValueKey(code),
                  index: index,
                  code: code,
                  label: languageName(l10n, code),
                  isLast: index == orderedCodes.length - 1,
                  removeTooltip: l10n.removeLanguage,
                  onRemove: () => onRemove(code),
                ),
            ],
          ),
        ),
        if (addableCodes.isNotEmpty) ...[
          const SizedBox(height: 14),
          Text(l10n.addLanguage, style: AkashicTypography.body(size: 12, weight: FontWeight.w700).copyWith(color: AkashicColors.textSoft)),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final code in addableCodes)
                ActionChip(
                  avatar: Text(languageFlag(code)),
                  label: Text(languageName(l10n, code)),
                  side: BorderSide(color: AkashicColors.line),
                  backgroundColor: AkashicColors.night,
                  shape: const StadiumBorder(),
                  onPressed: () => onAdd(code),
                ),
            ],
          ),
        ],
      ],
    );
  }
}

class _RankedLanguage extends StatelessWidget {
  const _RankedLanguage({
    required this.index,
    required this.code,
    required this.label,
    required this.isLast,
    required this.removeTooltip,
    required this.onRemove,
    super.key,
  });

  final int index;
  final String code;
  final String label;
  final bool isLast;
  final String removeTooltip;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final isFirst = index == 0;
    return Material(
      type: MaterialType.transparency,
      child: Container(
        decoration: BoxDecoration(border: isLast ? null : Border(bottom: BorderSide(color: AkashicColors.line))),
        padding: const EdgeInsets.fromLTRB(14, 6, 4, 6),
        child: Row(
          children: [
            Container(
              width: 28,
              height: 28,
              alignment: Alignment.center,
              decoration: BoxDecoration(shape: BoxShape.circle, color: isFirst ? AkashicColors.lavender : AkashicColors.line),
              child: Text('${index + 1}', style: AkashicTypography.numeral(size: 13).copyWith(color: isFirst ? AkashicColors.night : AkashicColors.text)),
            ),
            const SizedBox(width: 12),
            Text(languageFlag(code), style: const TextStyle(fontSize: 22)),
            const SizedBox(width: 10),
            Expanded(child: Text(label, style: AkashicTypography.body(size: 15, weight: isFirst ? FontWeight.w700 : FontWeight.w500))),
            IconButton(tooltip: removeTooltip, icon: Icon(Icons.close, size: 20, color: AkashicColors.textSoft), onPressed: onRemove),
            ReorderableDragStartListener(
              index: index,
              child: Padding(padding: EdgeInsets.all(8), child: Icon(Icons.drag_indicator, color: AkashicColors.textFaint)),
            ),
          ],
        ),
      ),
    );
  }
}
