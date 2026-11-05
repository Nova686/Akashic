import 'dart:convert';

import 'package:akashic/layers/functional/Catalog/domain/entities/category_type.dart';
import 'package:akashic/layers/functional/Discoveries/domain/entities/suggestion.dart';
import 'package:akashic/layers/functional/Discoveries/domain/gateways/discovery_cache.dart';
import 'package:akashic/layers/technical/LocalDatabase/akashic_database.dart';
import 'package:drift/drift.dart';

class DriftDiscoveryCache implements DiscoveryCacheGateway {
  DriftDiscoveryCache(this._database);

  static const String _latestId = 'latest';

  final AkashicDatabase _database;

  @override
  Future<Discoveries?> read() async {
    final row = await (_database.select(_database.discoveryCache)..where((table) => table.id.equals(_latestId))).getSingleOrNull();
    if (row == null) {
      return null;
    }
    try {
      final json = jsonDecode(row.payload) as Map<String, Object?>;
      return Discoveries(
        computedAt: row.fetchedAt,
        seedCount: json['seedCount'] as int? ?? 0,
        groups: [for (final group in (json['groups'] as List? ?? const []).cast<Map<String, Object?>>()) _groupFromJson(group)],
      );
    } on FormatException {
      return null;
    } on TypeError {
      return null;
    } on ArgumentError {
      return null;
    }
  }

  @override
  Future<void> write(Discoveries discoveries) {
    return _database.into(_database.discoveryCache).insertOnConflictUpdate(DiscoveryCacheCompanion.insert(
          id: _latestId,
          fetchedAt: Value(discoveries.computedAt),
          payload: jsonEncode({
            'seedCount': discoveries.seedCount,
            'groups': [
              for (final group in discoveries.groups)
                {
                  'seedItemId': group.seedItemId,
                  'seedTitle': group.seedTitle,
                  'type': group.categoryType.name,
                  'suggestions': [
                    for (final suggestion in group.suggestions)
                      {
                        'sourceKey': suggestion.sourceKey,
                        'externalWorkId': suggestion.externalWorkId,
                        'title': suggestion.title,
                        'creator': suggestion.creator,
                        'imageUrl': suggestion.imageUrl,
                        'year': suggestion.year,
                      },
                  ],
                },
            ],
          }),
        ));
  }

  SuggestionGroup _groupFromJson(Map<String, Object?> json) {
    return SuggestionGroup(
      seedItemId: json['seedItemId']! as String,
      seedTitle: json['seedTitle']! as String,
      categoryType: CategoryType.values.byName(json['type']! as String),
      suggestions: [
        for (final suggestion in (json['suggestions'] as List? ?? const []).cast<Map<String, Object?>>())
          Suggestion(
            sourceKey: suggestion['sourceKey']! as String,
            externalWorkId: suggestion['externalWorkId']! as String,
            title: suggestion['title']! as String,
            creator: suggestion['creator'] as String?,
            imageUrl: suggestion['imageUrl'] as String?,
            year: suggestion['year'] as int?,
          ),
      ],
    );
  }
}
