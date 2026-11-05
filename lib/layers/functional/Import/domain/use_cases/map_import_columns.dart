import 'package:akashic/layers/functional/Collection/domain/entities/item_condition.dart';
import 'package:akashic/layers/functional/Collection/domain/use_cases/search_text_normalizer.dart';
import 'package:akashic/layers/functional/Import/domain/entities/import_table.dart';

const Map<ImportField, Set<String>> _headerSynonyms = {
  ImportField.title: {'titre', 'title', 'album', 'nom', 'name', 'oeuvre', 'livre', 'jeu', 'film'},
  ImportField.creator: {'artiste', 'artist', 'auteur', 'author', 'createur', 'creator', 'realisateur', 'director', 'studio', 'groupe', 'band'},
  ImportField.barcode: {'code-barres', 'code barres', 'code barre', 'codebarre', 'barcode', 'ean', 'isbn', 'upc', 'gtin'},
  ImportField.edition: {'edition', 'version', 'pressage', 'pressing', 'binding', 'reliure', 'format'},
  ImportField.price: {'prix', 'price', 'prix paye', 'price paid', 'cout', 'cost', 'montant', 'amount'},
  ImportField.location: {'emplacement', 'location', 'rangement', 'place', 'lieu', 'etagere', 'shelf'},
  ImportField.condition: {'etat', 'condition', 'state'},
  ImportField.year: {'annee', 'year', 'sortie', 'release', 'annee de sortie', 'release year', 'year published', 'publication year', 'date de publication', 'date de parution', 'parution', 'publication'},
  ImportField.series: {'serie', 'series', 'collection', 'saga'},
  ImportField.volume: {'tome', 'volume', 'vol', 'numero', 'number', 'no', 'n°'},
};

const Set<String> _exactOnlySynonyms = {'collection'};

const Map<ItemCondition, Set<String>> _conditionSynonyms = {
  ItemCondition.mint: {'neuf', 'new', 'mint', 'sous blister', 'sealed', 'nm', 'm'},
  ItemCondition.veryGood: {'tres bon', 'tres bon etat', 'very good', 'vg+', 'vg', 'excellent', 'ex'},
  ItemCondition.good: {'bon', 'bon etat', 'good', 'g', 'g+'},
  ItemCondition.fair: {'correct', 'moyen', 'fair', 'acceptable', 'f'},
  ItemCondition.damaged: {'abime', 'mauvais', 'damaged', 'poor', 'p'},
  ItemCondition.missing: {'manquant', 'missing', 'absent'},
};

const Set<String> _ignoredHeaders = {'bookshelves', 'bookshelves with positions', 'exclusive shelf', 'letterboxd uri', 'my review', 'private notes', 'author l-f', 'additional authors', 'number of pages', 'original publication year'};

final RegExp _spreadsheetFormula = RegExp(r'^="(.*)"$');

String _cleanHeader(String header) => normalizeForSearch(header).replaceAll(RegExp(r'[_.:()]'), ' ').replaceAll(RegExp(r'\s+'), ' ').trim();

Map<int, ImportField> guessColumnMapping(List<String> headers) {
  final mapping = <int, ImportField>{};
  final used = <ImportField>{};
  for (final (index, header) in headers.indexed) {
    final cleaned = _cleanHeader(header);
    if (_ignoredHeaders.contains(cleaned)) {
      mapping[index] = ImportField.ignored;
      continue;
    }
    ImportField? guessed;
    for (final MapEntry(key: field, value: synonyms) in _headerSynonyms.entries) {
      if (!used.contains(field) && synonyms.contains(cleaned)) {
        guessed = field;
        break;
      }
    }
    if (guessed == null) {
      for (final MapEntry(key: field, value: synonyms) in _headerSynonyms.entries) {
        if (!used.contains(field) && synonyms.any((synonym) => synonym.length > 3 && !_exactOnlySynonyms.contains(synonym) && cleaned.contains(synonym))) {
          guessed = field;
          break;
        }
      }
    }
    mapping[index] = guessed ?? ImportField.ignored;
    if (guessed != null) {
      used.add(guessed);
    }
  }
  final isbn13Column = [for (final (index, header) in headers.indexed) if (_cleanHeader(header) == 'isbn13') index].firstOrNull;
  final barcodeColumn = [for (final MapEntry(key: column, value: field) in mapping.entries) if (field == ImportField.barcode) column].firstOrNull;
  if (isbn13Column != null && barcodeColumn != null && barcodeColumn != isbn13Column && _cleanHeader(headers[barcodeColumn]) == 'isbn') {
    mapping[barcodeColumn] = ImportField.ignored;
    mapping[isbn13Column] = ImportField.barcode;
  }
  return mapping;
}

int? parsePriceCents(String raw) {
  final kept = raw.replaceAll(RegExp(r'[^0-9,.\-]'), '');
  if (kept.isEmpty || !RegExp(r'\d').hasMatch(kept)) {
    return null;
  }
  final lastComma = kept.lastIndexOf(',');
  final lastDot = kept.lastIndexOf('.');
  final decimalSeparatorIndex = lastComma > lastDot ? lastComma : lastDot;
  final separatorCount = RegExp('[,.]').allMatches(kept).length;
  final digitsAfter = decimalSeparatorIndex < 0 ? 0 : kept.length - decimalSeparatorIndex - 1;
  if (separatorCount == 1 && digitsAfter > 3) {
    final exact = double.tryParse(kept.replaceAll(',', '.'));
    return exact == null ? null : (exact * 100).round();
  }
  String wholePart;
  String decimals;
  if (decimalSeparatorIndex >= 0 && digitsAfter <= 2) {
    wholePart = kept.substring(0, decimalSeparatorIndex);
    decimals = kept.substring(decimalSeparatorIndex + 1);
  } else {
    wholePart = kept;
    decimals = '';
  }
  final whole = int.tryParse(wholePart.replaceAll(RegExp('[,.]'), '').ifEmpty('0'));
  if (whole == null) {
    return null;
  }
  final cents = int.tryParse(decimals.padRight(2, '0')) ?? 0;
  return whole < 0 ? whole * 100 - cents : whole * 100 + cents;
}

int? parseYear(String raw, {DateTime? today}) {
  final latest = (today ?? DateTime.now()).year + 1;
  final trimmed = raw.trim();
  final serial = double.tryParse(trimmed);
  if (serial != null && serial >= 20000 && serial <= 80000) {
    return DateTime(1899, 12, 30).add(Duration(days: serial.floor())).year;
  }
  for (final match in RegExp(r'\d{4}').allMatches(trimmed)) {
    final year = int.parse(match.group(0)!);
    if (year >= 1800 && year <= latest) {
      return year;
    }
  }
  return null;
}

ItemCondition? parseCondition(String raw) {
  final cleaned = normalizeForSearch(raw);
  for (final MapEntry(key: condition, value: synonyms) in _conditionSynonyms.entries) {
    if (synonyms.contains(cleaned)) {
      return condition;
    }
  }
  return null;
}

List<ImportLine> importLinesOf(ImportTable table, Map<int, ImportField> mapping) {
  String? valueOf(List<String> row, ImportField field) {
    for (final MapEntry(key: column, value: mapped) in mapping.entries) {
      if (mapped == field && column < row.length) {
        final cell = row[column].trim();
        final value = (_spreadsheetFormula.firstMatch(cell)?.group(1) ?? cell).trim();
        if (value.isNotEmpty) {
          return value;
        }
      }
    }
    return null;
  }

  return [
    for (final (index, row) in table.rows.indexed)
      if (valueOf(row, ImportField.title) != null || valueOf(row, ImportField.barcode) != null)
        ImportLine(
          rowNumber: index + 2,
          title: valueOf(row, ImportField.title),
          creator: valueOf(row, ImportField.creator),
          barcode: valueOf(row, ImportField.barcode)?.replaceAll(RegExp(r'\s'), ''),
          edition: valueOf(row, ImportField.edition),
          priceCents: switch (valueOf(row, ImportField.price)) {
            final price? => parsePriceCents(price),
            null => null,
          },
          location: valueOf(row, ImportField.location),
          condition: switch (valueOf(row, ImportField.condition)) {
            final condition? => parseCondition(condition),
            null => null,
          },
          year: switch (valueOf(row, ImportField.year)) {
            final year? => parseYear(year),
            null => null,
          },
          seriesTitle: valueOf(row, ImportField.series),
          volumeNumber: int.tryParse(RegExp(r'\d+').firstMatch(valueOf(row, ImportField.volume) ?? '')?.group(0) ?? ''),
        ),
  ];
}

extension on String {
  String ifEmpty(String fallback) => isEmpty ? fallback : this;
}
