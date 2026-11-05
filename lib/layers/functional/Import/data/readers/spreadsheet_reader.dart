import 'dart:convert';
import 'dart:typed_data';

import 'package:akashic/layers/functional/Import/domain/entities/import_table.dart';
import 'package:archive/archive.dart';
import 'package:csv/csv.dart';
import 'package:xml/xml.dart';

ImportTable readSpreadsheet(String fileName, Uint8List bytes) {
  final table = fileName.toLowerCase().endsWith('.xlsx') ? _rowsOfXlsx(bytes) : _rowsOfCsv(_decodeText(bytes));
  final filled = [
    for (final row in table)
      if (row.any((cell) => cell.trim().isNotEmpty)) row,
  ];
  if (filled.isEmpty) {
    throw const UnreadableSpreadsheet();
  }
  return ImportTable(headers: filled.first.map((cell) => cell.trim()).toList(), rows: filled.skip(1).toList());
}

String _decodeText(Uint8List bytes) {
  final withoutBom = bytes.length >= 3 && bytes[0] == 0xEF && bytes[1] == 0xBB && bytes[2] == 0xBF ? bytes.sublist(3) : bytes;
  try {
    return utf8.decode(withoutBom);
  } on FormatException {
    return latin1.decode(withoutBom);
  }
}

List<List<String>> _rowsOfCsv(String text) {
  final firstLine = text.split(RegExp(r'\r?\n')).firstWhere((line) => line.trim().isNotEmpty, orElse: () => '');
  final delimiter = [';', '\t', ','].reduce((best, candidate) => candidate.allMatches(firstLine).length > best.allMatches(firstLine).length ? candidate : best);
  return [
    for (final row in Csv(fieldDelimiter: delimiter).decode(text)) [for (final cell in row) '${cell ?? ''}'],
  ];
}

List<List<String>> _rowsOfXlsx(Uint8List bytes) {
  final Archive archive;
  try {
    archive = ZipDecoder().decodeBytes(bytes);
  } on Exception {
    throw const UnreadableSpreadsheet();
  }
  XmlDocument? documentOf(String path) {
    final file = archive.findFile(path);
    return file == null ? null : XmlDocument.parse(utf8.decode(file.content));
  }

  final sharedStrings = [
    for (final item in documentOf('xl/sharedStrings.xml')?.findAllElements('si') ?? const <XmlElement>[])
      item.findAllElements('t').map((text) => text.innerText).join(),
  ];
  final sheetPath = archive.files.map((file) => file.name).where((name) => RegExp(r'^xl/worksheets/sheet\d+\.xml$').hasMatch(name)).toList()..sort();
  final sheet = sheetPath.isEmpty ? null : documentOf(sheetPath.first);
  if (sheet == null) {
    throw const UnreadableSpreadsheet();
  }
  final rows = <List<String>>[];
  for (final rowElement in sheet.findAllElements('row')) {
    final cells = <int, String>{};
    for (final (position, cell) in rowElement.findElements('c').indexed) {
      final column = _columnIndexOf(cell.getAttribute('r')) ?? position;
      final type = cell.getAttribute('t');
      final rawValue = cell.getElement('v')?.innerText ?? '';
      cells[column] = switch (type) {
        's' => sharedStrings.elementAtOrNull(int.tryParse(rawValue) ?? -1) ?? '',
        'inlineStr' => cell.findAllElements('t').map((text) => text.innerText).join(),
        _ => _plainNumber(rawValue),
      };
    }
    final width = cells.isEmpty ? 0 : cells.keys.reduce((first, second) => first > second ? first : second) + 1;
    rows.add([for (var column = 0; column < width; column++) cells[column] ?? '']);
  }
  return rows;
}

int? _columnIndexOf(String? reference) {
  final letters = RegExp('^[A-Z]+').firstMatch(reference ?? '')?.group(0);
  if (letters == null) {
    return null;
  }
  return letters.codeUnits.fold<int>(0, (index, unit) => index * 26 + unit - 64) - 1;
}

String _plainNumber(String raw) {
  final number = double.tryParse(raw);
  if (number == null || number.abs() >= 1e18) {
    return raw;
  }
  if (number == number.truncateToDouble()) {
    return number.toInt().toString();
  }
  return number.toStringAsFixed(6).replaceFirst(RegExp(r'0+$'), '');
}
