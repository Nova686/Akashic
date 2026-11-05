import 'dart:io';

import 'package:akashic/layers/technical/Theme/safe_bottom_sheet.dart';
import 'package:akashic/layers/functional/Catalog/domain/entities/category_type.dart';
import 'package:akashic/layers/functional/Catalog/domain/entities/item_field.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/card_kind.dart';
import 'package:akashic/layers/functional/Collection/presentation/cubit/item_editor_cubit.dart';
import 'package:akashic/layers/functional/Collection/presentation/cubit/item_editor_state.dart';
import 'package:akashic/layers/functional/Collection/presentation/widgets/item_field_labels.dart';
import 'package:akashic/layers/functional/Collection/presentation/widgets/star_rating.dart';
import 'package:akashic/layers/functional/Collection/domain/use_cases/resolve_display_title.dart';
import 'package:akashic/layers/functional/Settings/domain/entities/preferred_languages.dart';
import 'package:akashic/layers/functional/Settings/presentation/widgets/language_names.dart';
import 'package:akashic/layers/functional/Lookup/domain/entities/source_match.dart';
import 'package:akashic/layers/technical/Localization/app_localizations.dart';
import 'package:akashic/layers/technical/Theme/akashic_colors.dart';
import 'package:akashic/layers/technical/Theme/akashic_typography.dart';
import 'package:akashic/layers/technical/Theme/safe_scroll_padding.dart';
import 'package:akashic/layers/functional/Collection/presentation/widgets/spine_text_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

const List<int> spineColorChoices = [
  0xFF20304A,
  0xFF1F4F7A,
  0xFF3D7C99,
  0xFF204A3F,
  0xFF6F7A55,
  0xFFB5502A,
  0xFFC2412D,
  0xFF8A2F3A,
  0xFF6A3D7A,
  0xFF2D2A55,
  0xFFE8E2D4,
  0xFF141414,
];

class ItemEditorView extends StatefulWidget {
  const ItemEditorView({required this.categoryName, this.barcodeScannerBuilder, this.onWishMatch, this.initialQuery = '', super.key});

  final String categoryName;
  final Widget Function(ValueChanged<String> onBarcode)? barcodeScannerBuilder;
  final Future<void> Function(SourceMatch match)? onWishMatch;
  final String initialQuery;

  @override
  State<ItemEditorView> createState() => _ItemEditorViewState();
}

class _ItemEditorViewState extends State<ItemEditorView> {
  late bool _isSearching = _startsWithSearch(context.read<ItemEditorCubit>().state);

  bool _startsWithSearch(ItemEditorState state) => state.canSearchOnline && !state.isEditing;

  Future<void> _wishMatch(SourceMatch match) async {
    final wishMatch = widget.onWishMatch;
    if (wishMatch == null) {
      return;
    }
    final messenger = ScaffoldMessenger.of(context);
    final addedMessage = AppLocalizations.of(context).addedToWishes;
    await wishMatch(match);
    messenger.showSnackBar(SnackBar(content: Text(addedMessage)));
  }

  Future<void> _scanBarcode() async {
    final editor = context.read<ItemEditorCubit>();
    final builder = widget.barcodeScannerBuilder;
    if (builder == null) {
      return;
    }
    final scanned = await showSafeBottomSheet<String>(
      context: context,
      builder: (sheetContext) => SafeArea(child: SizedBox(height: 320, child: builder((code) => Navigator.of(sheetContext).maybePop(code)))),
    );
    if (scanned != null) {
      await editor.useBarcode(scanned);
    }
  }

  Future<void> _pickMatch(SourceMatch match) async {
    await context.read<ItemEditorCubit>().applyMatch(match);
    if (mounted) {
      setState(() => _isSearching = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final editor = context.read<ItemEditorCubit>();
    return BlocConsumer<ItemEditorCubit, ItemEditorState>(
      listenWhen: (previous, current) => current.status == ItemEditorStatus.saved,
      listener: (context, state) => Navigator.of(context).maybePop(),
      buildWhen: (previous, current) => previous.copyWith(titles: current.titles) != current || previous.hasAnyTitle != current.hasAnyTitle,
      builder: (context, state) {
        final hasSearchStep = _startsWithSearch(state);
        final isSearching = _isSearching && hasSearchStep;
        return Scaffold(
          appBar: AppBar(
            leading: hasSearchStep && !isSearching
                ? IconButton(icon: const Icon(Icons.arrow_back), tooltip: l10n.stepSearch, onPressed: () => setState(() => _isSearching = true))
                : IconButton(icon: const Icon(Icons.close), tooltip: l10n.close, onPressed: () => Navigator.of(context).maybePop()),
            title: Text(state.isEditing ? l10n.editItem : '${l10n.addItem} · ${widget.categoryName}', style: AkashicTypography.body(size: 17, weight: FontWeight.w700)),
            bottom: hasSearchStep ? PreferredSize(preferredSize: const Size.fromHeight(28), child: _EditorSteps(isSearching: isSearching)) : null,
          ),
          body: isSearching ? _searchStep(context, state) : _checkStep(context, state, showsCardKind: !hasSearchStep),
          bottomNavigationBar: SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(18, 8, 18, 12),
              child: isSearching
                  ? OutlinedButton.icon(onPressed: () => setState(() => _isSearching = false), icon: const Icon(Icons.edit_outlined), label: Text(l10n.enterByHand))
                  : Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        if (state.status == ItemEditorStatus.failure)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Semantics(liveRegion: true, child: Text(l10n.saveFailed, style: AkashicTypography.body(size: 13).copyWith(color: Theme.of(context).colorScheme.error))),
                          ),
                        FilledButton(
                          onPressed: state.status == ItemEditorStatus.saving ? null : editor.submit,
                          child: Text(state.isEditing ? l10n.save : l10n.addToNamedCategory(widget.categoryName)),
                        ),
                      ],
                    ),
            ),
          ),
        );
      },
    );
  }

  Widget _cardKindSwitch(ItemEditorState state) {
    final l10n = AppLocalizations.of(context);
    final editor = context.read<ItemEditorCubit>();
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: SegmentedButton<CardKind>(
                  expandedInsets: EdgeInsets.zero,
                  showSelectedIcon: false,
                  style: SegmentedButton.styleFrom(
                    backgroundColor: AkashicColors.surface,
                    foregroundColor: AkashicColors.textSoft,
                    selectedBackgroundColor: AkashicColors.lavender,
                    selectedForegroundColor: AkashicColors.night,
                    side: BorderSide(color: AkashicColors.line),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    textStyle: AkashicTypography.body(size: 15, weight: FontWeight.w800),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  segments: [
                    ButtonSegment(value: CardKind.extension, icon: const Icon(Icons.layers_outlined), label: Text(l10n.cardKindExtension)),
                    ButtonSegment(value: CardKind.deck, icon: const Icon(Icons.style_outlined), label: Text(l10n.cardKindDeck)),
                    if (state.canSearchSealedProducts) ButtonSegment(value: CardKind.sealed, icon: const Icon(Icons.inventory_2_outlined), label: Text(l10n.cardKindSealed)),
                  ],
                  selected: {state.cardKind ?? CardKind.extension},
                  onSelectionChanged: (selection) => editor.setCardKind(selection.first),
                ),
    );
  }

  Widget _searchStep(BuildContext context, ItemEditorState state) {
    final l10n = AppLocalizations.of(context);
    final editor = context.read<ItemEditorCubit>();
    return ListView(
      key: const ValueKey('item-search-step'),
      padding: safeListPadding(context, top: 8),
      children: [
        if (state.categoryType == CategoryType.cards) _cardKindSwitch(state),
        TextFormField(
          initialValue: widget.initialQuery,
          autofocus: widget.initialQuery.isEmpty,
          onChanged: editor.searchOnline,
          textInputAction: TextInputAction.search,
          decoration: InputDecoration(
            hintText: state.searchesPreconDecks ? l10n.searchPreconDeck : l10n.searchOnline,
            prefixIcon: const Icon(Icons.search),
            suffixIcon: state.isSearching
                ? const Padding(padding: EdgeInsets.all(12), child: SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2)))
                : widget.barcodeScannerBuilder == null
                    ? null
                    : IconButton(tooltip: l10n.scanBarcode, icon: const Icon(Icons.qr_code_scanner), onPressed: _scanBarcode),
          ),
        ),
        if (state.barcode != null)
          Padding(
            padding: const EdgeInsets.only(top: 6),
            child: Text(l10n.barcodeValue(state.barcode!), style: AkashicTypography.body(size: 12).copyWith(color: AkashicColors.teal)),
          ),
        const SizedBox(height: 10),
        if (state.searchResults.isEmpty && !state.isSearching)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 24),
            child: Text(l10n.searchResultsEmpty, textAlign: TextAlign.center, style: AkashicTypography.body(size: 13).copyWith(color: AkashicColors.textSoft)),
          ),
        for (final match in state.searchResults.take(12))
          _ResultCard(match: match, onTap: () => _pickMatch(match), onWish: widget.onWishMatch == null ? null : () => _wishMatch(match)),
      ],
    );
  }

  Widget _checkStep(BuildContext context, ItemEditorState state, {required bool showsCardKind}) {
    final l10n = AppLocalizations.of(context);
    final editor = context.read<ItemEditorCubit>();
    final fields = state.categoryType.itemFields;
    final addableLanguages = selectableTitleLanguageCodes.where((code) => !state.titleLanguages.contains(code)).toList();
    return ListView(
      key: const ValueKey('item-check-step'),
      padding: safeListPadding(context, top: 8),
      children: [
        if (showsCardKind && state.categoryType == CategoryType.cards) _cardKindSwitch(state),
        if (!state.canSearchOnline && !state.isEditing)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Text(l10n.noApiForThisCategory, style: AkashicTypography.body(size: 12).copyWith(color: AkashicColors.textSoft)),
          ),
        Center(child: _CoverPreview(state: state)),
        const SizedBox(height: 8),
        Wrap(
          alignment: WrapAlignment.center,
          spacing: 4,
          children: [
            TextButton.icon(
              onPressed: state.canSearchImages && !state.isSearchingImages ? editor.searchWebImages : null,
              icon: const Icon(Icons.public, size: 18),
              label: Text(state.isSearchingImages ? l10n.searchingImages : l10n.imageFromInternet),
            ),
            TextButton.icon(onPressed: editor.takePhoto, icon: const Icon(Icons.photo_camera_outlined, size: 18), label: Text(l10n.takePhoto)),
            TextButton.icon(onPressed: editor.pickFromGallery, icon: const Icon(Icons.photo_library_outlined, size: 18), label: Text(l10n.chooseFromGallery)),
          ],
        ),
        if (state.webImages.isNotEmpty) ...[
          const SizedBox(height: 10),
          Text(l10n.webImages, style: AkashicTypography.body(size: 12).copyWith(color: AkashicColors.teal)),
          const SizedBox(height: 6),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final (index, url) in state.webImages.indexed)
                Semantics(
                  button: true,
                  selected: url == state.selectedWebImage,
                  label: l10n.webImageNumber(index + 1),
                  onTap: () => editor.chooseWebImage(url),
                  excludeSemantics: true,
                  child: GestureDetector(
                  onTap: () => editor.chooseWebImage(url),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: url == state.selectedWebImage ? AkashicColors.lavender : Colors.transparent, width: 2),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(5),
                      child: Image.network(
                        url,
                        width: 72,
                        height: 72,
                        cacheWidth: 220,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stack) => const SizedBox(width: 72, height: 72),
                      ),
                    ),
                  ),
                ),
                ),
            ],
          ),
        ],
        _Heading(l10n.titles),
        RadioGroup<String>(
          groupValue: state.originalLanguage,
          onChanged: editor.setOriginalLanguage,
          child: Column(
            children: [
              for (final language in state.titleLanguages)
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        key: ValueKey('title-$language-${state.externalWorkId}'),
                        initialValue: state.titles[language],
                        onChanged: (title) => editor.setTitle(language, title),
                        decoration: InputDecoration(labelText: languageName(l10n, language)),
                      ),
                    ),
                    Tooltip(
                      message: l10n.originalLanguage,
                      child: Radio<String>(value: language),
                    ),
                  ],
                ),
            ],
          ),
        ),
        if (state.status == ItemEditorStatus.invalid && !state.hasAnyTitle)
          Semantics(liveRegion: true, child: Text(l10n.titleRequired, style: AkashicTypography.body(size: 12).copyWith(color: Theme.of(context).colorScheme.error))),
        if (addableLanguages.isNotEmpty)
          PopupMenuButton<String>(
            onSelected: editor.addTitleLanguage,
            itemBuilder: (context) => [for (final code in addableLanguages) PopupMenuItem(value: code, child: Text(languageName(l10n, code)))],
            child: ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.add, color: AkashicColors.teal),
              title: Text(
                l10n.addLanguage,
                style: AkashicTypography.body(weight: FontWeight.w600).copyWith(color: AkashicColors.teal),
              ),
            ),
          ),
        _Heading(l10n.detailsSection),
        if (fields.contains(ItemField.creator))
          TextFormField(
            key: ValueKey('creator-${state.externalWorkId}'),
            initialValue: state.creator,
            onChanged: editor.setCreator,
            decoration: InputDecoration(labelText: creatorLabelFor(state.categoryType, l10n)),
          ),
        Row(
          children: [
            if (fields.contains(ItemField.year))
              SizedBox(
                width: 110,
                child: TextFormField(
                  key: ValueKey('year-${state.externalWorkId}'),
                  initialValue: state.yearText,
                  onChanged: editor.setYearText,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(labelText: l10n.year),
                ),
              ),
            if (fields.contains(ItemField.year) && fields.contains(ItemField.publisher)) const SizedBox(width: 12),
            if (fields.contains(ItemField.publisher))
              Expanded(
                child: TextFormField(
                  key: ValueKey('publisher-${state.externalWorkId}'),
                  initialValue: state.publisher,
                  onChanged: editor.setPublisher,
                  decoration: InputDecoration(labelText: publisherLabelFor(state.categoryType, l10n)),
                ),
              ),
          ],
        ),
        if (fields.contains(ItemField.platform))
          TextFormField(
            key: ValueKey('platform-${state.externalWorkId}'),
            initialValue: state.groupKey,
            onChanged: editor.setPlatform,
            decoration: InputDecoration(labelText: l10n.platformConsole),
          ),
        if (fields.contains(ItemField.series) && !state.isEditing) ...[
          _Heading(l10n.partOfSeries),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: [
              ChoiceChip(label: Text(l10n.newSeries), selected: state.seriesChoice == SeriesChoice.created, onSelected: (_) => editor.startNewSeries()),
              for (final series in state.existingSeries)
                ChoiceChip(
                  label: Text(resolveDisplayTitle(series.titles, PreferredLanguages(state.titleLanguages)) ?? l10n.untitled),
                  selected: state.selectedSeries?.id == series.id,
                  onSelected: (_) => editor.chooseExistingSeries(series),
                ),
              if (state.seriesChoice != SeriesChoice.none) ActionChip(label: const Icon(Icons.close, size: 16), onPressed: editor.clearSeries),
            ],
          ),
          if (state.seriesChoice != SeriesChoice.none)
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    keyboardType: TextInputType.number,
                    style: AkashicTypography.numeral(size: 16),
                    key: ValueKey('volume-from-${state.externalWorkId}-${state.selectedSeries?.id}'),
                    initialValue: state.volumeFromText,
                    onChanged: (from) => editor.setVolumeRange(from: from, to: state.volumeToText),
                    decoration: InputDecoration(labelText: l10n.volumeFrom),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextFormField(
                    keyboardType: TextInputType.number,
                    style: AkashicTypography.numeral(size: 16),
                    key: ValueKey('volume-to-${state.externalWorkId}-${state.selectedSeries?.id}'),
                    initialValue: state.volumeToText,
                    onChanged: (to) => editor.setVolumeRange(from: state.volumeFromText, to: to),
                    decoration: InputDecoration(labelText: l10n.volumeTo, errorText: state.volumeRangeError ? l10n.volumeRangeInvalid : null),
                  ),
                ),
              ],
            ),
        ],
        const SizedBox(height: 8),
        Theme(
          data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
          child: ExpansionTile(
            tilePadding: EdgeInsets.zero,
            childrenPadding: const EdgeInsets.only(bottom: 12),
            expandedCrossAxisAlignment: CrossAxisAlignment.start,
            title: Text(l10n.moreDetails, style: AkashicTypography.body(size: 14, weight: FontWeight.w700)),
            children: [
              _Heading(l10n.spineColor),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final (index, colorValue) in {?state.spineColorValue, ...spineColorChoices}.indexed)
                    Semantics(
                      button: true,
                      selected: colorValue == state.spineColorValue,
                      label: l10n.paletteColorName((index + 1).toString()),
                      onTap: () => editor.overrideSpineColor(colorValue),
                      excludeSemantics: true,
                      child: InkResponse(
                        onTap: () => editor.overrideSpineColor(colorValue),
                        radius: 24,
                        child: SizedBox(
                          width: 48,
                          height: 52,
                          child: Center(
                            child: Container(
                              width: 22,
                              height: 44,
                              decoration: BoxDecoration(
                                color: Color(colorValue),
                                borderRadius: BorderRadius.circular(2),
                                border: Border.all(color: colorValue == state.spineColorValue ? AkashicColors.lavender : AkashicColors.line, width: 2),
                              ),
                              child: colorValue == state.spineColorValue ? Icon(Icons.check, size: 16, color: textColorOnSpine(Color(colorValue))) : null,
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              _Heading(l10n.myRating),
              StarRating(rating: state.rating, onChanged: editor.setRating),
            ],
          ),
        ),
      ],
    );
  }
}

class _EditorSteps extends StatelessWidget {
  const _EditorSteps({required this.isSearching});

  final bool isSearching;

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
          step(1, l10n.stepSearch, isSearching),
          const Expanded(child: Divider(indent: 10, endIndent: 10)),
          step(2, l10n.stepCheck, !isSearching),
        ],
      ),
    );
  }
}

class _ResultCard extends StatelessWidget {
  const _ResultCard({required this.match, required this.onTap, this.onWish});

  final SourceMatch match;
  final VoidCallback onTap;
  final VoidCallback? onWish;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final title = match.titles.byLanguage.values.firstOrNull ?? '';
    final details = [?match.year?.toString(), ?match.format, if (match.volumeNumber case final volume?) l10n.volumeShort(volume), ?match.platform, ?match.creator].join(' · ');
    final placeholder = ColoredBox(
      color: AkashicColors.line,
      child: Center(child: Text(title.isEmpty ? '?' : title.characters.first.toUpperCase(), style: AkashicTypography.numeral(size: 20).copyWith(color: AkashicColors.textSoft))),
    );
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Material(
        color: AkashicColors.surface,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: SizedBox(
                    width: 48,
                    height: 66,
                    child: match.imageUrl == null
                        ? placeholder
                        : Image.network(match.imageUrl!, fit: BoxFit.cover, cacheWidth: 150, errorBuilder: (context, error, stack) => placeholder),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title, maxLines: 2, overflow: TextOverflow.ellipsis, style: AkashicTypography.body(size: 15, weight: FontWeight.w700)),
                      if (details.isNotEmpty)
                        Text(details, maxLines: 2, overflow: TextOverflow.ellipsis, style: AkashicTypography.body(size: 12).copyWith(color: AkashicColors.textSoft)),
                    ],
                  ),
                ),
                if (onWish != null)
                  IconButton(tooltip: l10n.addToWishes, icon: const Icon(Icons.favorite_border, color: AkashicColors.lavender), onPressed: onWish),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _CoverPreview extends StatelessWidget {
  const _CoverPreview({required this.state});

  final ItemEditorState state;

  @override
  Widget build(BuildContext context) {
    final placeholder = ColoredBox(
      color: Color(state.spineColorValue ?? AkashicColors.surface.toARGB32()),
      child: Center(child: Icon(Icons.image_outlined, color: AkashicColors.textSoft, size: 36)),
    );
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: SizedBox(
        width: 130,
        height: 180,
        child: switch ((state.imagePath, state.selectedWebImage)) {
          (final path?, _) => Image.file(File(path), fit: BoxFit.cover, cacheWidth: 400, errorBuilder: (context, error, stack) => placeholder),
          (null, final url?) => Image.network(url, fit: BoxFit.cover, cacheWidth: 400, errorBuilder: (context, error, stack) => placeholder),
          _ => placeholder,
        },
      ),
    );
  }
}

class _Heading extends StatelessWidget {
  const _Heading(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 18, bottom: 6),
      child: Text(text, style: AkashicTypography.body(size: 14, weight: FontWeight.w700)),
    );
  }
}
