import 'dart:convert';
import 'dart:typed_data';

import 'package:akashic/layers/functional/Collection/domain/entities/item_condition.dart';
import 'package:akashic/layers/functional/Import/data/readers/spreadsheet_reader.dart';
import 'package:akashic/layers/functional/Import/domain/entities/import_table.dart';
import 'package:akashic/layers/functional/Import/domain/use_cases/map_import_columns.dart';
import 'package:archive/archive.dart';
import 'package:flutter_test/flutter_test.dart';

Uint8List minimalXlsx() {
  final archive = Archive()
    ..addFile(ArchiveFile.string('xl/sharedStrings.xml',
        '<?xml version="1.0"?><sst xmlns="http://schemas.openxmlformats.org/spreadsheetml/2006/main"><si><t>Titre</t></si><si><t>Code-barres</t></si><si><t>Prix</t></si><si><t>Kind of Blue</t></si></sst>'))
    ..addFile(ArchiveFile.string('xl/worksheets/sheet1.xml',
        '<?xml version="1.0"?><worksheet xmlns="http://schemas.openxmlformats.org/spreadsheetml/2006/main"><sheetData>'
        '<row r="1"><c r="A1" t="s"><v>0</v></c><c r="B1" t="s"><v>1</v></c><c r="C1" t="s"><v>2</v></c></row>'
        '<row r="2"><c r="A2" t="s"><v>3</v></c><c r="B2"><v>5099750442227</v></c><c r="C2"><v>12.5</v></c></row>'
        '<row r="3"/>'
        '<row r="4"><c r="A4" t="inlineStr"><is><t>Giant Steps</t></is></c><c r="C4"><v>9</v></c></row>'
        '</sheetData></worksheet>'));
  return Uint8List.fromList(ZipEncoder().encode(archive));
}

void main() {
  test('french and english headers are recognised', () {
    expect(guessColumnMapping(['Titre', 'Artiste', 'Code-barres', 'Prix payé', 'Emplacement', 'État', 'Commentaire']), {
      0: ImportField.title,
      1: ImportField.creator,
      2: ImportField.barcode,
      3: ImportField.price,
      4: ImportField.location,
      5: ImportField.condition,
      6: ImportField.ignored,
    });
    expect(guessColumnMapping(['Album', 'Artist', 'EAN', 'Price', 'Series', 'Volume'])[5], ImportField.volume);
  });

  test('prices with comma and currency are read', () {
    expect(parsePriceCents('12,50 €'), 1250);
    expect(parsePriceCents('€12.5'), 1250);
    expect(parsePriceCents('1 234,56'), 123456);
    expect(parsePriceCents('1,234.56'), 123456);
    expect(parsePriceCents('15'), 1500);
    expect(parsePriceCents('gratuit'), isNull);
  });

  test('conditions are read in french and english', () {
    expect(parseCondition('Très bon'), ItemCondition.veryGood);
    expect(parseCondition('mint'), ItemCondition.mint);
    expect(parseCondition('Abîmé'), ItemCondition.damaged);
    expect(parseCondition('???'), isNull);
  });

  test('semicolon csv is read and empty rows are skipped', () {
    final table = readSpreadsheet('collection.csv', Uint8List.fromList(utf8.encode('﻿Titre;Artiste;Prix\nKind of Blue;Miles Davis;"12,50"\n;;\nBlue Train;John Coltrane;9\n')));
    expect(table.headers, ['Titre', 'Artiste', 'Prix']);
    final lines = importLinesOf(table, guessColumnMapping(table.headers));
    expect(lines.map((line) => line.title), ['Kind of Blue', 'Blue Train']);
    expect(lines.first.priceCents, 1250);
    expect(lines.first.rowNumber, 2);
  });

  test('an xlsx sheet is read with shared and inline strings', () {
    final table = readSpreadsheet('collection.xlsx', minimalXlsx());
    expect(table.headers, ['Titre', 'Code-barres', 'Prix']);
    final lines = importLinesOf(table, guessColumnMapping(table.headers));
    expect(lines, hasLength(2));
    expect(lines.first.barcode, '5099750442227');
    expect(lines.first.priceCents, 1250);
    expect(lines.last.title, 'Giant Steps');
  });

  test('a file that is not a spreadsheet is refused', () {
    expect(() => readSpreadsheet('photo.xlsx', Uint8List.fromList([1, 2, 3])), throwsA(isA<UnreadableSpreadsheet>()));
  });

  test('computed prices and excel dates are read sensibly', () {
    expect(parsePriceCents('19.989999999999998'), 1999);
    expect(parsePriceCents('1.234'), 123400);
    expect(parseYear('45231'), 2023);
    expect(parseYear('2016'), 2016);
    expect(parseYear('4523'), isNull);
    expect(parseYear('Pressage 1959, réédition 2015'), 1959);
    expect(guessColumnMapping(["Date d'achat"])[0], ImportField.ignored);
  });
}
