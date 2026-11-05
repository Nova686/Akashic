import 'package:akashic/layers/functional/Catalog/domain/entities/category_type.dart';
import 'package:akashic/layers/functional/Catalog/presentation/cubit/category_editor_cubit.dart';
import 'package:akashic/layers/functional/Catalog/presentation/cubit/category_editor_state.dart';
import 'package:akashic/layers/functional/Catalog/presentation/widgets/card_game_suggestions.dart';
import 'package:akashic/layers/functional/Catalog/presentation/widgets/category_form_parts.dart';
import 'package:akashic/layers/functional/Catalog/presentation/widgets/category_type_labels.dart';
import 'package:akashic/layers/functional/Catalog/presentation/widgets/labeled_text_entry.dart';
import 'package:akashic/layers/technical/Localization/app_localizations.dart';
import 'package:akashic/layers/technical/Theme/akashic_colors.dart';
import 'package:akashic/layers/technical/Theme/akashic_typography.dart';
import 'package:akashic/layers/technical/Theme/safe_scroll_padding.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CategoryEditorView extends StatefulWidget {
  const CategoryEditorView({super.key});

  @override
  State<CategoryEditorView> createState() => _CategoryEditorViewState();
}

class _CategoryEditorViewState extends State<CategoryEditorView> {
  bool _isChoosingType = true;

  void _chooseType(CategoryType type) {
    final l10n = AppLocalizations.of(context);
    final editor = context.read<CategoryEditorCubit>();
    final previousLabel = editor.state.type.label(l10n);
    editor.selectType(type);
    if (editor.state.name.trim().isEmpty || editor.state.name == previousLabel) {
      editor.setName(type.label(l10n));
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final editor = context.read<CategoryEditorCubit>();
    return BlocConsumer<CategoryEditorCubit, CategoryEditorState>(
      listenWhen: (previous, current) => previous.status != current.status && (current.status == CategoryEditorStatus.saved || current.status == CategoryEditorStatus.failed),
      listener: (context, state) => state.status == CategoryEditorStatus.saved
          ? Navigator.of(context).maybePop()
          : ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.saveFailedRetry))),
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            leading: _isChoosingType
                ? IconButton(icon: const Icon(Icons.close), tooltip: l10n.close, onPressed: () => Navigator.of(context).maybePop())
                : IconButton(icon: const Icon(Icons.arrow_back), tooltip: l10n.changeAction, onPressed: () => setState(() => _isChoosingType = true)),
            title: Text(l10n.newCategory, style: AkashicTypography.body(size: 18, weight: FontWeight.w700)),
            bottom: PreferredSize(preferredSize: const Size.fromHeight(28), child: _StepIndicator(isFirstStep: _isChoosingType)),
          ),
          body: _isChoosingType ? _typeGrid(context, state) : _details(context, state),
          bottomNavigationBar: SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(18, 8, 18, 12),
              child: _isChoosingType
                  ? FilledButton(onPressed: () => setState(() => _isChoosingType = false), child: Text(l10n.continueAction))
                  : FilledButton(onPressed: state.status == CategoryEditorStatus.saving ? null : editor.submit, child: Text(l10n.createCategory)),
            ),
          ),
        );
      },
    );
  }

  Widget _typeGrid(BuildContext context, CategoryEditorState state) {
    final l10n = AppLocalizations.of(context);
    return ListView(
      key: const ValueKey('category-type-step'),
      padding: safeListPadding(context, top: 8),
      children: [
        Text(l10n.categoryTypeStepTitle, style: AkashicTypography.displayTitle(size: 24)),
        const SizedBox(height: 14),
        GridView.count(
          crossAxisCount: 3,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          childAspectRatio: 0.95,
          children: [
            for (final type in CategoryType.values)
              CategoryTypeTile(type: type, isSelected: state.type == type, onTap: () => _chooseType(type)),
          ],
        ),
        if (state.type == CategoryType.free)
          Padding(
            padding: const EdgeInsets.only(top: 12),
            child: Text(l10n.customCategoryExplanation, style: AkashicTypography.body(size: 12).copyWith(color: AkashicColors.textSoft)),
          ),
      ],
    );
  }

  Widget _details(BuildContext context, CategoryEditorState state) {
    final l10n = AppLocalizations.of(context);
    final editor = context.read<CategoryEditorCubit>();
    return ListView(
      key: const ValueKey('category-details-step'),
      padding: safeListPadding(context, top: 8),
      children: [
        CategoryPreviewCard(name: state.name, colorValue: state.colorValue, type: state.type, details: [for (final subcategory in state.subcategories) subcategory.name]),
        const SizedBox(height: 12),
        Material(
          color: AkashicColors.surface,
          borderRadius: BorderRadius.circular(14),
          child: ListTile(
            leading: Icon(state.type.icon, color: AkashicColors.lavender),
            title: Text(state.type.label(l10n), style: AkashicTypography.body(weight: FontWeight.w700)),
            trailing: TextButton(onPressed: () => setState(() => _isChoosingType = true), child: Text(l10n.changeAction)),
          ),
        ),
        _SectionLabel(l10n.categoryName),
        Semantics(
          label: l10n.categoryName,
          child: TextFormField(
            initialValue: state.name,
            onChanged: editor.setName,
            decoration: InputDecoration(errorText: state.status == CategoryEditorStatus.invalid ? l10n.categoryNameRequired : null),
          ),
        ),
        const SizedBox(height: 10),
        Wrap(
          children: [
            for (final (index, colorValue) in CategoryEditorState.categoryPalette.indexed)
              Semantics(
                button: true,
                selected: colorValue == state.colorValue,
                label: l10n.paletteColorName(index.toString()),
                excludeSemantics: true,
                onTap: () => editor.setColor(colorValue),
                child: InkResponse(
                  onTap: () => editor.setColor(colorValue),
                  radius: 24,
                  child: SizedBox.square(
                    dimension: 48,
                    child: Center(
                      child: CircleAvatar(
                        radius: 14,
                        backgroundColor: Color(colorValue),
                        child: colorValue == state.colorValue ? const Icon(Icons.check, size: 16, color: AkashicColors.night) : null,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
        _SectionLabel(l10n.subcategories),
        for (final (index, subcategory) in state.subcategories.indexed)
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(subcategory.name),
            trailing: IconButton(icon: const Icon(Icons.close), tooltip: l10n.close, onPressed: () => editor.removeSubcategory(index)),
          ),
        LabeledTextEntry(hint: l10n.subcategoryName, actionLabel: l10n.addSubcategory, onSubmitted: editor.addSubcategory),
        if (state.type == CategoryType.cards) ...[
          CardGameSuggestions(existingNames: state.subcategories.map((subcategory) => subcategory.name), onPicked: editor.addSubcategory),
          Text(l10n.otherCardGamesByHand, style: AkashicTypography.body(size: 12).copyWith(color: AkashicColors.textFaint)),
        ],
        _SectionLabel(l10n.conditionRatedOn),
        Wrap(
          spacing: 6,
          runSpacing: 6,
          children: [
            for (final (index, part) in state.conditionParts.indexed) InputChip(label: Text(part), onDeleted: () => editor.removeConditionPart(index)),
          ],
        ),
        LabeledTextEntry(hint: l10n.partName, actionLabel: l10n.addPart, onSubmitted: editor.addConditionPart),
      ],
    );
  }
}

class _StepIndicator extends StatelessWidget {
  const _StepIndicator({required this.isFirstStep});

  final bool isFirstStep;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    Widget step(int number, String label, bool isActive) => Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              radius: 10,
              backgroundColor: isActive ? AkashicColors.lavender : AkashicColors.line,
              child: Text('$number', style: AkashicTypography.body(size: 11, weight: FontWeight.w800).copyWith(color: isActive ? AkashicColors.night : AkashicColors.textSoft)),
            ),
            const SizedBox(width: 6),
            Text(label, style: AkashicTypography.body(size: 12, weight: FontWeight.w700).copyWith(color: isActive ? AkashicColors.text : AkashicColors.textSoft)),
          ],
        );
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 0, 18, 8),
      child: Row(
        children: [
          step(1, l10n.categoryTypeLabel, isFirstStep),
          const Expanded(child: Divider(indent: 10, endIndent: 10)),
          step(2, l10n.detailsSection, !isFirstStep),
        ],
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 18, bottom: 8),
      child: Text(text, style: AkashicTypography.body(size: 12, weight: FontWeight.w700).copyWith(color: AkashicColors.textSoft)),
    );
  }
}
