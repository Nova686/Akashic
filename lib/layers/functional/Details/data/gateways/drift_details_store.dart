import 'dart:convert';

import 'package:akashic/layers/functional/Details/domain/entities/item_details.dart';
import 'package:akashic/layers/functional/Details/domain/gateways/details_store.dart';
import 'package:akashic/layers/technical/LocalDatabase/akashic_database.dart' hide ItemDetails;
import 'package:drift/drift.dart';

class DriftDetailsStore implements DetailsStore {
  DriftDetailsStore(this._database);

  final AkashicDatabase _database;

  @override
  Future<ItemDetails?> read(String itemId) async {
    final row = await (_database.select(_database.itemDetails)..where((table) => table.itemId.equals(itemId))).getSingleOrNull();
    if (row == null) {
      return null;
    }
    final sections = (jsonDecode(row.payload) as List).cast<Map<String, Object?>>().map(_sectionFromJson).nonNulls.toList();
    return ItemDetails(sections: sections, fetchedAt: row.fetchedAt);
  }

  @override
  Future<void> write(String itemId, ItemDetails details) {
    return _database.into(_database.itemDetails).insertOnConflictUpdate(ItemDetailsCompanion.insert(
          itemId: itemId,
          payload: jsonEncode(details.sections.map(_sectionToJson).toList()),
          fetchedAt: Value(details.fetchedAt),
        ));
  }

  Map<String, Object?> _sectionToJson(DetailSection section) => switch (section) {
        TextSection(:final kind, :final text, :final sourceLabel) => {'type': 'text', 'kind': kind.name, 'text': text, 'source': sourceLabel},
        TrackListSection(:final tracks, :final sourceLabel) => {
            'type': 'tracks',
            'source': sourceLabel,
            'tracks': [for (final track in tracks) {'position': track.position, 'title': track.title, 'duration': track.duration}],
          },
        TagSection(:final tags) => {'type': 'tags', 'tags': tags},
        LinkSection(:final links) => {
            'type': 'links',
            'links': [for (final link in links) {'label': link.label, 'url': link.url}],
          },
        FactsSection(:final facts, :final sourceLabel) => {
            'type': 'facts',
            'source': sourceLabel,
            'facts': [for (final fact in facts) {'kind': fact.kind.name, 'value': fact.value}],
          },
      };

  DetailSection? _sectionFromJson(Map<String, Object?> json) {
    List<Map<String, Object?>> entries(String key) => (json[key] as List? ?? const []).cast<Map<String, Object?>>();
    return switch (json['type']) {
      'text' => TextSection(kind: TextKind.values.byName(json['kind']! as String), text: json['text']! as String, sourceLabel: json['source']! as String),
      'tracks' => TrackListSection(
          sourceLabel: json['source']! as String,
          tracks: [for (final track in entries('tracks')) DetailTrack(position: track['position']! as String, title: track['title']! as String, duration: track['duration'] as String?)],
        ),
      'tags' => TagSection(tags: (json['tags'] as List? ?? const []).cast<String>()),
      'links' => LinkSection(links: [for (final link in entries('links')) DetailLink(label: link['label']! as String, url: link['url']! as String)]),
      'facts' => FactsSection(
          sourceLabel: json['source']! as String,
          facts: [for (final fact in entries('facts')) DetailFact(kind: FactKind.values.byName(fact['kind']! as String), value: fact['value']! as String)],
        ),
      _ => null,
    };
  }
}
