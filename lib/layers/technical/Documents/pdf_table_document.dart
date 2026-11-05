import 'dart:typed_data';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class PdfColumn {
  const PdfColumn(this.label, {this.flex = 1, this.alignsRight = false});

  final String label;
  final int flex;
  final bool alignsRight;
}

class PdfRow {
  const PdfRow({required this.title, this.subtitle, this.cells = const [], this.thumbnail});

  final String title;
  final String? subtitle;
  final List<String> cells;
  final Uint8List? thumbnail;
}

class PdfSection {
  const PdfSection({required this.heading, required this.rows, this.footer = const []});

  final String heading;
  final List<PdfRow> rows;
  final List<String> footer;
}

class PdfTableDocument {
  const PdfTableDocument({
    required this.title,
    required this.subtitle,
    required this.columns,
    required this.sections,
    required this.regularFont,
    required this.boldFont,
    this.summary = const [],
    this.footerNote = '',
    this.showsThumbnails = false,
  });

  final String title;
  final String subtitle;
  final List<PdfColumn> columns;
  final List<PdfSection> sections;
  final List<(String, String)> summary;
  final String footerNote;
  final bool showsThumbnails;
  final Uint8List regularFont;
  final Uint8List boldFont;
}

const PdfColor _ink = PdfColor.fromInt(0xFF1B1830);
const PdfColor _softInk = PdfColor.fromInt(0xFF4A4566);
const PdfColor _accent = PdfColor.fromInt(0xFF4B3FB0);
const PdfColor _rule = PdfColor.fromInt(0xFFD9D5EC);
const double _thumbnailWidth = 34;

Future<Uint8List> buildTablePdf(PdfTableDocument document) {
  final theme = pw.ThemeData.withFont(base: pw.Font.ttf(document.regularFont.buffer.asByteData()), bold: pw.Font.ttf(document.boldFont.buffer.asByteData()));
  final pdf = pw.Document(theme: theme);
  pw.Widget cell(String text, {bool bold = false, bool alignsRight = false, PdfColor color = _ink, double size = 9}) => pw.Text(
        text,
        textAlign: alignsRight ? pw.TextAlign.right : pw.TextAlign.left,
        style: pw.TextStyle(fontSize: size, color: color, fontWeight: bold ? pw.FontWeight.bold : pw.FontWeight.normal),
      );
  pw.Widget line(List<pw.Widget> leading, List<String> values, {bool bold = false, PdfColor color = _ink}) => pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          ...leading,
          for (final (index, column) in document.columns.indexed)
            pw.Expanded(
              flex: column.flex,
              child: pw.Padding(
                padding: const pw.EdgeInsets.symmetric(horizontal: 3),
                child: index < values.length ? cell(values[index], bold: bold, alignsRight: column.alignsRight, color: color) : pw.SizedBox(),
              ),
            ),
        ],
      );
  pdf.addPage(
    pw.MultiPage(
      pageFormat: PdfPageFormat.a4,
      margin: const pw.EdgeInsets.fromLTRB(36, 36, 36, 40),
      header: (context) => pw.Container(
        padding: const pw.EdgeInsets.only(bottom: 8),
        margin: const pw.EdgeInsets.only(bottom: 10),
        decoration: const pw.BoxDecoration(border: pw.Border(bottom: pw.BorderSide(color: _ink, width: 1.2))),
        child: pw.Row(
          crossAxisAlignment: pw.CrossAxisAlignment.end,
          children: [
            pw.Expanded(
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(document.title, style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold, color: _ink)),
                  pw.Text(document.subtitle, style: const pw.TextStyle(fontSize: 8.5, color: _softInk)),
                ],
              ),
            ),
            pw.Text('${context.pageNumber} / ${context.pagesCount}', style: const pw.TextStyle(fontSize: 8.5, color: _softInk)),
          ],
        ),
      ),
      footer: (context) => pw.Text(document.footerNote, style: const pw.TextStyle(fontSize: 7.5, color: _softInk)),
      build: (context) => [
        if (document.summary.isNotEmpty)
          pw.Container(
            padding: const pw.EdgeInsets.all(8),
            margin: const pw.EdgeInsets.only(bottom: 12),
            decoration: pw.BoxDecoration(border: pw.Border.all(color: _rule), borderRadius: pw.BorderRadius.circular(4)),
            child: pw.Wrap(
              spacing: 18,
              runSpacing: 4,
              children: [
                for (final (label, value) in document.summary)
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [cell(label, color: _softInk, size: 8), cell(value, bold: true, size: 11)],
                  ),
              ],
            ),
          ),
        for (final section in document.sections) ...[
          pw.Padding(
            padding: const pw.EdgeInsets.only(top: 10, bottom: 4),
            child: pw.Text(section.heading.toUpperCase(), style: pw.TextStyle(fontSize: 8.5, fontWeight: pw.FontWeight.bold, color: _accent, letterSpacing: 0.6)),
          ),
          if (document.columns.length > 1)
            pw.Container(
              padding: const pw.EdgeInsets.only(bottom: 3),
              decoration: const pw.BoxDecoration(border: pw.Border(bottom: pw.BorderSide(color: _rule))),
              child: line(
                [if (document.showsThumbnails) pw.SizedBox(width: _thumbnailWidth + 6)],
                [for (final column in document.columns) column.label.toUpperCase()],
                bold: true,
                color: _softInk,
              ),
            ),
          for (final row in section.rows)
            pw.Container(
              padding: const pw.EdgeInsets.symmetric(vertical: 4),
              decoration: const pw.BoxDecoration(border: pw.Border(bottom: pw.BorderSide(color: _rule, width: 0.5))),
              child: line(
                [
                  if (document.showsThumbnails)
                    pw.Container(
                      width: _thumbnailWidth,
                      height: _thumbnailWidth * 1.4,
                      margin: const pw.EdgeInsets.only(right: 6),
                      color: const PdfColor.fromInt(0xFFEDEBF7),
                      child: row.thumbnail == null ? null : pw.Image(pw.MemoryImage(row.thumbnail!), fit: pw.BoxFit.cover),
                    ),
                ],
                [
                  row.subtitle == null ? row.title : '${row.title}\n${row.subtitle}',
                  ...row.cells,
                ],
              ),
            ),
          if (section.footer.isNotEmpty)
            pw.Container(
              padding: const pw.EdgeInsets.symmetric(vertical: 4),
              decoration: const pw.BoxDecoration(border: pw.Border(top: pw.BorderSide(color: _ink, width: 0.8))),
              child: line([if (document.showsThumbnails) pw.SizedBox(width: _thumbnailWidth + 6)], section.footer, bold: true),
            ),
        ],
      ],
    ),
  );
  return pdf.save();
}
