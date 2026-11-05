import 'package:akashic/layers/functional/Catalog/domain/entities/category.dart';
import 'package:akashic/layers/functional/Catalog/domain/entities/category_type.dart';
import 'package:akashic/layers/functional/Catalog/domain/use_cases/manage_categories.dart';
import 'package:akashic/layers/functional/Catalog/presentation/cubit/category_editor_state.dart';
import 'package:akashic/layers/functional/Catalog/presentation/widgets/category_form_parts.dart';
import 'package:akashic/layers/functional/Catalog/presentation/widgets/category_type_labels.dart';
import 'package:akashic/layers/functional/Catalog/presentation/widgets/labeled_text_entry.dart';
import 'package:akashic/layers/technical/Localization/app_localizations.dart';
import 'package:akashic/layers/technical/Theme/akashic_colors.dart';
import 'package:akashic/layers/technical/Theme/akashic_typography.dart';
import 'package:akashic/layers/technical/Theme/safe_bottom_sheet.dart';
import 'package:akashic/layers/technical/Theme/safe_scroll_padding.dart';
import 'package:flutter/material.dart';

enum CategoryEditResult { saved, deleted }

class CategoryEditPage extends StatefulWidget {
  const CategoryEditPage({required this.category, required this.manageCategories, required this.confirmDeletion, super.key});

  final Category category;
  final ManageCategories manageCategories;
  final Future<bool> Function(BuildContext context) confirmDeletion;

  @override
  State<CategoryEditPage> createState() => _CategoryEditPageState();
}

class _CategoryEditPageState extends State<CategoryEditPage> {
  late String _name = widget.category.name;
  late int _colorValue = widget.category.colorValue;
  late CategoryType _type = widget.category.type;
  late final List<String> _conditionParts = [...widget.category.conditionParts];
  final List<String> _newSubcategories = [];
  List<Category> _subcategories = const [];
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _loadSubcategories();
  }

  Future<void> _loadSubcategories() async {
    final subcategories = await widget.manageCategories.subcategoriesOf(widget.category);
    if (mounted) {
      setState(() => _subcategories = subcategories);
    }
  }

  Future<void> _changeType() async {
    final l10n = AppLocalizations.of(context);
    final type = await showSafeBottomSheet<CategoryType>(
      context: context,
      isScrollControlled: true,
      builder: (sheetContext) => Padding(
        padding: const EdgeInsets.fromLTRB(18, 18, 18, 12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(l10n.categoryTypeStepTitle, style: AkashicTypography.displayTitle(size: 22)),
            const SizedBox(height: 12),
            Flexible(
              child: GridView.count(
                crossAxisCount: 3,
                shrinkWrap: true,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                childAspectRatio: 0.95,
                children: [
                  for (final type in CategoryType.values) CategoryTypeTile(type: type, isSelected: type == _type, onTap: () => Navigator.of(sheetContext).pop(type)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
    if (type != null && mounted) {
      setState(() => _type = type);
    }
  }

  Future<void> _save() async {
    setState(() => _isSaving = true);
    await widget.manageCategories.update(widget.category, name: _name, colorValue: _colorValue, type: _type, conditionParts: _conditionParts);
    for (final name in _newSubcategories) {
      await widget.manageCategories.addSubcategory(widget.category, name);
    }
    if (mounted) {
      Navigator.of(context).pop(CategoryEditResult.saved);
    }
  }

  Future<void> _delete() async {
    if (await widget.confirmDeletion(context) && mounted) {
      Navigator.of(context).pop(CategoryEditResult.deleted);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(icon: const Icon(Icons.close), tooltip: l10n.close, onPressed: () => Navigator.of(context).maybePop()),
        title: Text(l10n.editCategory, style: AkashicTypography.body(size: 18, weight: FontWeight.w700)),
      ),
      body: ListView(
        padding: safeListPadding(context, top: 8),
        children: [
          CategoryPreviewCard(
            name: _name,
            colorValue: _colorValue,
            type: _type,
            details: [for (final subcategory in _subcategories) subcategory.name, ..._newSubcategories],
          ),
          const SizedBox(height: 12),
          Material(
            color: AkashicColors.surface,
            borderRadius: BorderRadius.circular(14),
            child: ListTile(
              leading: Icon(_type.icon, color: AkashicColors.lavender),
              title: Text(_type.label(l10n), style: AkashicTypography.body(weight: FontWeight.w700)),
              trailing: TextButton(onPressed: _changeType, child: Text(l10n.changeAction)),
            ),
          ),
          _Label(l10n.categoryName),
          Semantics(label: l10n.categoryName, child: TextFormField(initialValue: _name, onChanged: (name) => setState(() => _name = name))),
          const SizedBox(height: 10),
          Wrap(
            children: [
              for (final (index, colorValue) in CategoryEditorState.categoryPalette.indexed)
                Semantics(
                  button: true,
                  selected: colorValue == _colorValue,
                  label: l10n.paletteColorName(index.toString()),
                  excludeSemantics: true,
                  onTap: () => setState(() => _colorValue = colorValue),
                  child: InkResponse(
                    onTap: () => setState(() => _colorValue = colorValue),
                    radius: 24,
                    child: SizedBox.square(
                      dimension: 48,
                      child: Center(
                        child: CircleAvatar(
                          radius: 14,
                          backgroundColor: Color(colorValue),
                          child: colorValue == _colorValue ? const Icon(Icons.check, size: 16, color: AkashicColors.night) : null,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
          _Label(l10n.conditionRatedOn),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: [
              for (final (index, part) in _conditionParts.indexed) InputChip(label: Text(part), onDeleted: () => setState(() => _conditionParts.removeAt(index))),
            ],
          ),
          LabeledTextEntry(
            hint: l10n.partName,
            actionLabel: l10n.addPart,
            onSubmitted: (part) {
              if (part.trim().isNotEmpty) {
                setState(() => _conditionParts.add(part.trim()));
              }
            },
          ),
          if (!widget.category.isSubcategory) ...[
            _Label(l10n.subcategories),
            for (final subcategory in _subcategories)
              ListTile(contentPadding: EdgeInsets.zero, leading: Icon(Icons.subdirectory_arrow_right, color: AkashicColors.textSoft), title: Text(subcategory.name)),
            for (final (index, name) in _newSubcategories.indexed)
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.subdirectory_arrow_right, color: AkashicColors.teal),
                title: Text(name),
                trailing: IconButton(icon: const Icon(Icons.close), tooltip: l10n.close, onPressed: () => setState(() => _newSubcategories.removeAt(index))),
              ),
            LabeledTextEntry(
              hint: l10n.subcategoryName,
              actionLabel: l10n.addSubcategory,
              onSubmitted: (name) {
                if (name.trim().isNotEmpty) {
                  setState(() => _newSubcategories.add(name.trim()));
                }
              },
            ),
          ],
          const SizedBox(height: 28),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(16), border: Border.all(color: AkashicColors.gold.withValues(alpha: 0.5))),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(l10n.categoryDangerZone, style: AkashicTypography.body(size: 13, weight: FontWeight.w800).copyWith(color: AkashicColors.gold)),
                const SizedBox(height: 4),
                Text(l10n.categoryDangerZoneExplanation, style: AkashicTypography.body(size: 12).copyWith(color: AkashicColors.textSoft)),
                const SizedBox(height: 8),
                Align(
                  alignment: Alignment.centerLeft,
                  child: OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(foregroundColor: AkashicColors.gold, side: const BorderSide(color: AkashicColors.gold)),
                    onPressed: _delete,
                    icon: const Icon(Icons.delete_outline),
                    label: Text(l10n.deleteCategory),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(18, 8, 18, 12),
          child: FilledButton(onPressed: _isSaving ? null : _save, child: Text(l10n.save)),
        ),
      ),
    );
  }
}

class _Label extends StatelessWidget {
  const _Label(this.text);

  final String text;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(top: 18, bottom: 8),
        child: Text(text, style: AkashicTypography.body(size: 12, weight: FontWeight.w700).copyWith(color: AkashicColors.textSoft)),
      );
}
