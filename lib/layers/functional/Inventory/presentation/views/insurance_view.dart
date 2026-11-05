import 'dart:io';
import 'dart:isolate';
import 'dart:typed_data';

import 'package:akashic/layers/functional/Collection/domain/use_cases/resolve_display_title.dart';
import 'package:akashic/layers/functional/Inventory/domain/use_cases/insurance_inventory.dart';
import 'package:akashic/layers/functional/Settings/domain/entities/preferred_languages.dart';
import 'package:akashic/layers/functional/Stats/presentation/views/stats_view.dart';
import 'package:akashic/layers/technical/Documents/font_bytes.dart';
import 'package:akashic/layers/technical/Documents/pdf_table_document.dart';
import 'package:akashic/layers/technical/Localization/app_localizations.dart';
import 'package:akashic/layers/technical/Theme/akashic_colors.dart';
import 'package:akashic/layers/technical/Theme/akashic_empty_state.dart';
import 'package:akashic/layers/technical/Theme/akashic_typography.dart';
import 'package:akashic/layers/technical/Theme/safe_scroll_padding.dart';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';

const int _rowsPerPage = 14;
const int _thumbnailPixels = 140;

Uint8List? _thumbnailOf(String? path) {
  if (path == null) {
    return null;
  }
  final file = File(path);
  if (!file.existsSync()) {
    return null;
  }
  final decoded = img.decodeImage(file.readAsBytesSync());
  return decoded == null ? null : img.encodeJpg(img.copyResize(decoded, width: _thumbnailPixels), quality: 70);
}

class InsuranceView extends StatefulWidget {
  const InsuranceView({required this.loadInventory, super.key});

  final Future<List<InventoryCategory>> Function() loadInventory;

  @override
  State<InsuranceView> createState() => _InsuranceViewState();
}

class _InsuranceViewState extends State<InsuranceView> {
  late final Future<List<InventoryCategory>> _inventory = widget.loadInventory().then((categories) {
    _included = {for (final category in categories) if (category.lines.length >= 5) category.category.id};
    return categories;
  });
  Set<String> _included = {};
  bool _withPhotos = true;
  bool _isGenerating = false;

  List<InventoryLine> _linesOf(List<InventoryCategory> categories) => [
        for (final category in categories)
          if (_included.contains(category.category.id)) ...category.lines,
      ];

  Future<void> _generate(List<InventoryCategory> categories, AppLocalizations l10n) async {
    setState(() => _isGenerating = true);
    try {
      final lines = _linesOf(categories)..sort((first, second) => (first.location ?? '\u{FFFF}').compareTo(second.location ?? '\u{FFFF}'));
      final money = NumberFormat.currency(locale: l10n.localeName, symbol: '€');
      final dates = DateFormat.yMd(l10n.localeName);
      final byPlace = <String, List<InventoryLine>>{};
      for (final line in lines) {
        byPlace.putIfAbsent(line.location ?? l10n.notStoredYetShort, () => []).add(line);
      }
      final photos = _withPhotos ? [for (final line in lines) line.item.imagePath] : const <String?>[];
      final thumbnails = _withPhotos ? await Isolate.run(() => [for (final path in photos) _thumbnailOf(path)]) : const <Uint8List?>[];
      final thumbnailByItem = {for (final (index, line) in lines.indexed) if (index < thumbnails.length) line.item.id: thumbnails[index]};
      final (regular, bold) = await documentFonts();
      final paidTotal = lines.fold<int>(0, (total, line) => total + (line.paidCents ?? 0));
      final estimatedTotal = lines.fold<int>(0, (total, line) => total + (line.estimatedCents ?? 0));
      final document = PdfTableDocument(
        title: l10n.insuranceDocumentTitle,
        subtitle: l10n.insuranceDocumentSubtitle(DateFormat.yMMMMd(l10n.localeName).format(DateTime.now()), lines.length),
        columns: [
          PdfColumn(l10n.insuranceColumnItem, flex: 5),
          PdfColumn(l10n.insuranceColumnBought, flex: 2),
          PdfColumn(l10n.insuranceColumnPaid, flex: 2, alignsRight: true),
          PdfColumn(l10n.insuranceColumnEstimated, flex: 2, alignsRight: true),
        ],
        summary: [
          (l10n.insuranceItems, '${lines.length}'),
          (l10n.insuranceColumnPaid, money.format(paidTotal / 100)),
          (l10n.insuranceColumnEstimated, money.format(estimatedTotal / 100)),
        ],
        sections: [
          for (final MapEntry(key: place, value: placeLines) in byPlace.entries)
            PdfSection(
              heading: place,
              rows: [
                for (final line in placeLines)
                  PdfRow(
                    title: resolveDisplayTitle(line.item.titles, PreferredLanguages.defaults) ?? l10n.untitled,
                    subtitle: [line.category.name, ?line.item.creator, if (line.item.year case final year?) '$year', ?line.copy?.edition].join(' · '),
                    cells: [
                      switch (line.copy?.purchasedOn) { final date? => dates.format(date), null => '—' },
                      switch (line.paidCents) { final cents? => money.format(cents / 100), null => '—' },
                      switch (line.estimatedCents) { final cents? => money.format(cents / 100), null => '—' },
                    ],
                    thumbnail: thumbnailByItem[line.item.id],
                  ),
              ],
              footer: [
                l10n.insuranceSubtotal(placeLines.length),
                '',
                money.format(placeLines.fold<int>(0, (total, line) => total + (line.paidCents ?? 0)) / 100),
                money.format(placeLines.fold<int>(0, (total, line) => total + (line.estimatedCents ?? 0)) / 100),
              ],
            ),
        ],
        footerNote: l10n.insuranceFooter,
        showsThumbnails: _withPhotos,
        regularFont: regular,
        boldFont: bold,
      );
      final bytes = await Isolate.run(() => buildTablePdf(document));
      final file = File('${Directory.systemTemp.path}/akashic-inventaire.pdf');
      await file.writeAsBytes(bytes, flush: true);
      await SharePlus.instance.share(ShareParams(files: [XFile(file.path, mimeType: 'application/pdf')]));
    } finally {
      if (mounted) {
        setState(() => _isGenerating = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.insuranceInventory, style: AkashicTypography.displayTitle(size: 24))),
      body: FutureBuilder<List<InventoryCategory>>(
        future: _inventory,
        builder: (context, snapshot) {
          final categories = snapshot.data;
          if (categories == null) {
            return const AkashicLoader();
          }
          if (categories.isEmpty) {
            return Center(child: AkashicEmptyState(message: l10n.insuranceNothing));
          }
          final lines = _linesOf(categories);
          final estimated = lines.fold<int>(0, (total, line) => total + (line.estimatedCents ?? 0));
          final pages = (lines.length / _rowsPerPage).ceil().clamp(1, 9999);
          return ListView(
            padding: safeListPadding(context, bottom: 120),
            children: [
              Text(l10n.insuranceIntro, style: AkashicTypography.body(size: 13).copyWith(color: AkashicColors.textSoft)),
              const SizedBox(height: 12),
              Text(l10n.insuranceCategories.toUpperCase(), style: AkashicTypography.body(size: 11, weight: FontWeight.w800).copyWith(color: AkashicColors.textSoft, letterSpacing: 1.1)),
              for (final category in categories)
                CheckboxListTile(
                  contentPadding: EdgeInsets.zero,
                  value: _included.contains(category.category.id),
                  onChanged: (checked) => setState(() => checked == true ? _included.add(category.category.id) : _included.remove(category.category.id)),
                  title: Text(category.category.name, style: AkashicTypography.body(weight: FontWeight.w700)),
                  subtitle: Text(l10n.insuranceCategoryLine(category.lines.length, formatEuros(l10n, category.estimatedCents))),
                ),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                value: _withPhotos,
                onChanged: (value) => setState(() => _withPhotos = value),
                title: Text(l10n.insuranceWithPhotos, style: AkashicTypography.body(weight: FontWeight.w700)),
                subtitle: Text(l10n.insuranceWithPhotosHelp),
              ),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(color: AkashicColors.surface, borderRadius: BorderRadius.circular(16), border: Border.all(color: AkashicColors.line)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.picture_as_pdf_outlined, color: AkashicColors.lavender),
                        const SizedBox(width: 8),
                        Expanded(child: Text(l10n.insurancePreview, style: AkashicTypography.body(size: 15, weight: FontWeight.w800))),
                        Text(l10n.insurancePages(pages), style: AkashicTypography.body(size: 12).copyWith(color: AkashicColors.textSoft)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    for (final line in lines.take(3))
                      Padding(
                        padding: const EdgeInsets.only(top: 6),
                        child: Row(
                          children: [
                            Expanded(child: Text(resolveDisplayTitle(line.item.titles, PreferredLanguages.defaults) ?? l10n.untitled, maxLines: 1, overflow: TextOverflow.ellipsis, style: AkashicTypography.body(size: 13, weight: FontWeight.w700))),
                            const SizedBox(width: 8),
                            Text(line.estimatedCents == null ? '—' : formatEuros(l10n, line.estimatedCents!), style: AkashicTypography.body(size: 13).copyWith(color: AkashicColors.textSoft)),
                          ],
                        ),
                      ),
                    if (lines.length > 3) Padding(padding: const EdgeInsets.only(top: 6), child: Text(l10n.insuranceMoreLines(lines.length - 3), style: AkashicTypography.body(size: 12).copyWith(color: AkashicColors.textSoft))),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  Expanded(child: Text(l10n.insuranceItemCount(lines.length), style: AkashicTypography.body(size: 14, weight: FontWeight.w700))),
                  Text(l10n.insuranceEstimatedTotal(formatEuros(l10n, estimated)), style: AkashicTypography.body(size: 16, weight: FontWeight.w800).copyWith(color: AkashicColors.lavender)),
                ],
              ),
              const SizedBox(height: 14),
              FilledButton.icon(
                onPressed: lines.isEmpty || _isGenerating ? null : () => _generate(categories, l10n),
                icon: _isGenerating ? const SizedBox.square(dimension: 18, child: CircularProgressIndicator(strokeWidth: 2)) : const Icon(Icons.picture_as_pdf_outlined),
                label: Text(_isGenerating ? l10n.insuranceGenerating : l10n.insuranceGenerate),
              ),
            ],
          );
        },
      ),
    );
  }
}
