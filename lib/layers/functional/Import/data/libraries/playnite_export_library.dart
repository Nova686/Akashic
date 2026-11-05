import 'dart:typed_data';

import 'package:akashic/layers/functional/Catalog/domain/entities/category_type.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/localized_titles.dart';
import 'package:akashic/layers/functional/Collection/domain/use_cases/search_text_normalizer.dart';
import 'package:akashic/layers/functional/Import/data/libraries/steam_library.dart';
import 'package:akashic/layers/functional/Import/data/readers/spreadsheet_reader.dart';
import 'package:akashic/layers/functional/Import/domain/use_cases/import_account_library.dart';
import 'package:akashic/layers/functional/Lookup/domain/entities/source_match.dart';

class PlayniteExportLibrary implements ExportFileLibrary {
  static const String sourceKey = 'playnite';
  static const String listSeparator = ', ';
  static final RegExp _year = RegExp(r'\b(19|20)\d{2}\b');
  static final RegExp _steamAppId = RegExp(r'^\d+$');

  @override
  LibraryService get service => LibraryService.playnite;

  @override
  CategoryType get categoryType => CategoryType.videoGames;

  @override
  bool get isConfigured => true;

  @override
  Future<List<LibraryEntry>> entriesOf(String fileName, Uint8List bytes) async {
    final table = readSpreadsheet(fileName, bytes);
    final headers = [for (final header in table.headers) normalizeForSearch(header).replaceAll(' ', '')];
    int? columnWhere(bool Function(String header) test) => switch (headers.indexWhere(test)) {
          -1 => null,
          final index => index,
        };
    final nameColumn = columnWhere((header) => header == 'name' || header == 'nom') ?? 0;
    final developersColumn = columnWhere((header) => header.contains('develop'));
    final platformsColumn = columnWhere((header) => header.contains('platform') || header.contains('plateforme'));
    final launcherColumn = columnWhere((header) => header == 'source' || header == 'sourcename');
    final releaseColumn = columnWhere((header) => header.contains('release') || header.contains('sortie'));
    final idColumn = columnWhere((header) => header == 'id' || header == 'playniteid');
    final gameIdColumn = columnWhere((header) => header == 'gameid' || header == 'iddujeu' || header == 'providergameid' || header == 'steamappid');
    final hiddenColumn = columnWhere((header) => header.contains('hidden') || header.contains('masque'));
    String? cellOf(List<String> row, int? column) => switch (column) {
          final index? when index < row.length && row[index].trim().isNotEmpty => row[index].trim(),
          _ => null,
        };
    final seen = <String>{};
    final entries = <LibraryEntry>[];
    for (final row in table.rows) {
      final name = cellOf(row, nameColumn);
      if (name == null || ['true', 'vrai'].contains(cellOf(row, hiddenColumn)?.toLowerCase())) {
        continue;
      }
      final launcher = cellOf(row, launcherColumn);
      final platform = cellOf(row, platformsColumn)?.split(listSeparator).first.trim();
      final gameId = cellOf(row, gameIdColumn);
      final isSteamGame = gameId != null && _steamAppId.hasMatch(gameId) && (launcher == null || launcher.toLowerCase() == 'steam');
      final externalWorkId = isSteamGame ? gameId : cellOf(row, idColumn) ?? '${normalizeForSearch(name)}|${normalizeForSearch(launcher ?? '')}';
      if (!seen.add('${isSteamGame ? SteamLibrary.sourceKey : sourceKey}|$externalWorkId')) {
        continue;
      }
      entries.add(LibraryEntry(
        SourceMatch(
          sourceKey: isSteamGame ? SteamLibrary.sourceKey : sourceKey,
          externalWorkId: externalWorkId,
          titles: LocalizedTitles(byLanguage: {'en': name}),
          creator: cellOf(row, developersColumn)?.split(listSeparator).first.trim(),
          year: switch (_year.firstMatch(cellOf(row, releaseColumn) ?? '')?.group(0)) {
            final year? => int.parse(year),
            null => null,
          },
          imageUrl: isSteamGame ? 'https://cdn.cloudflare.steamstatic.com/steam/apps/$gameId/library_600x900.jpg' : null,
          platform: platform ?? (isSteamGame ? SteamLibrary.platform : null),
          format: launcher,
          suggestedType: CategoryType.videoGames,
        ),
        needsLookup: !isSteamGame,
      ));
    }
    return entries;
  }
}
