import 'dart:io';
import 'dart:isolate';
import 'dart:ui' as ui;

import 'package:akashic/layers/functional/Catalog/presentation/widgets/category_type_labels.dart';
import 'package:akashic/layers/functional/Wishes/domain/entities/wish.dart';
import 'package:akashic/layers/functional/Wishes/presentation/widgets/wish_labels.dart';
import 'package:akashic/layers/functional/Wishes/presentation/widgets/wish_priority_labels.dart';
import 'package:akashic/layers/functional/Wishes/presentation/widgets/wishlist_text.dart';
import 'package:akashic/layers/technical/Documents/font_bytes.dart';
import 'package:akashic/layers/technical/Documents/pdf_table_document.dart';
import 'package:akashic/layers/technical/Localization/app_localizations.dart';
import 'package:akashic/layers/technical/Theme/akashic_colors.dart';
import 'package:akashic/layers/technical/Theme/akashic_typography.dart';
import 'package:akashic/layers/technical/Theme/safe_scroll_padding.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';

class WishlistShareView extends StatefulWidget {
  const WishlistShareView({required this.wishes, super.key});

  final List<Wish> wishes;

  @override
  State<WishlistShareView> createState() => _WishlistShareViewState();
}

class _WishlistShareViewState extends State<WishlistShareView> {
  final GlobalKey _card = GlobalKey();
  bool _isWorking = false;

  Future<void> _shareFile(Future<(List<int>, String, String)> Function() build) async {
    setState(() => _isWorking = true);
    try {
      final (bytes, name, mimeType) = await build();
      final file = File('${Directory.systemTemp.path}/$name');
      await file.writeAsBytes(bytes, flush: true);
      await SharePlus.instance.share(ShareParams(files: [XFile(file.path, mimeType: mimeType)]));
    } finally {
      if (mounted) {
        setState(() => _isWorking = false);
      }
    }
  }

  Future<(List<int>, String, String)> _image() async {
    final boundary = _card.currentContext!.findRenderObject()! as RenderRepaintBoundary;
    final image = await boundary.toImage(pixelRatio: 3);
    final bytes = await image.toByteData(format: ui.ImageByteFormat.png);
    return (bytes!.buffer.asUint8List(), 'akashic-envies.png', 'image/png');
  }

  Future<(List<int>, String, String)> _pdf(AppLocalizations l10n) async {
    final (regular, bold) = await documentFonts();
    final document = PdfTableDocument(
      title: l10n.wishlistShareHeading,
      subtitle: DateFormat.yMMMMd(l10n.localeName).format(DateTime.now()),
      columns: [PdfColumn(l10n.wishlistColumnWish, flex: 4), PdfColumn(l10n.wishlistColumnType, flex: 2)],
      sections: [
        for (final priority in WishPriority.values)
          if ([for (final wish in widget.wishes) if (wish.priority == priority) wish] case final wishes when wishes.isNotEmpty)
            PdfSection(
              heading: wishPriorityLabel(priority, l10n),
              rows: [for (final wish in wishes) PdfRow(title: wish.displayTitle(l10n), subtitle: wish.creator, cells: [wish.categoryType.label(l10n)])],
            ),
      ],
      footerNote: 'Akashic',
      regularFont: regular,
      boldFont: bold,
    );
    final bytes = await Isolate.run(() => buildTablePdf(document));
    return (bytes, 'akashic-envies.pdf', 'application/pdf');
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.shareWishlist, style: AkashicTypography.body(size: 18, weight: FontWeight.w700))),
      body: ListView(
        padding: safeListPadding(context, bottom: 120),
        children: [
          RepaintBoundary(key: _card, child: WishlistCard(wishes: widget.wishes)),
        ],
      ),
      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.fromLTRB(16, 0, 16, 12),
        child: Row(
          children: [
            Expanded(child: FilledButton.icon(onPressed: _isWorking ? null : () => _shareFile(_image), icon: const Icon(Icons.image_outlined), label: Text(l10n.shareAsImage))),
            const SizedBox(width: 8),
            Expanded(child: OutlinedButton.icon(onPressed: _isWorking ? null : () => _shareFile(() => _pdf(l10n)), icon: const Icon(Icons.picture_as_pdf_outlined), label: Text(l10n.shareAsPdf))),
            const SizedBox(width: 8),
            IconButton.outlined(
              tooltip: l10n.shareAsText,
              onPressed: () => SharePlus.instance.share(ShareParams(text: wishlistText(widget.wishes, l10n), subject: l10n.wishlistShareSubject)),
              icon: const Icon(Icons.notes),
            ),
          ],
        ),
      ),
    );
  }
}

class WishlistCard extends StatelessWidget {
  const WishlistCard({required this.wishes, super.key});

  final List<Wish> wishes;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(colors: [Color(0xFF241C52), AkashicColors.night], begin: Alignment.topLeft, end: Alignment.bottomRight),
        border: Border.all(color: AkashicColors.line, width: 2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(l10n.wishlistShareHeading, style: AkashicTypography.displayTitle(size: 26)),
          for (final priority in WishPriority.values)
            if ([for (final wish in wishes) if (wish.priority == priority) wish] case final group when group.isNotEmpty) ...[
              const SizedBox(height: 14),
              Row(
                children: [
                  Icon(wishPriorityIcon(priority), size: 16, color: wishPriorityColor(priority)),
                  const SizedBox(width: 6),
                  Text(wishPriorityLabel(priority, l10n).toUpperCase(), style: AkashicTypography.body(size: 11, weight: FontWeight.w800).copyWith(color: wishPriorityColor(priority), letterSpacing: 1.1)),
                ],
              ),
              for (final wish in group)
                Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: Text.rich(
                    TextSpan(children: [
                      TextSpan(text: wish.displayTitle(l10n), style: AkashicTypography.body(size: 14, weight: FontWeight.w700)),
                      if (wish.creator case final creator?) TextSpan(text: ' · $creator', style: AkashicTypography.body(size: 13).copyWith(color: AkashicColors.textSoft)),
                      TextSpan(text: ' · ${wish.categoryType.label(l10n)}', style: AkashicTypography.body(size: 12).copyWith(color: AkashicColors.teal)),
                    ]),
                  ),
                ),
            ],
        ],
      ),
    );
  }
}
