import 'dart:convert';

import 'package:akashic/layers/functional/Releases/domain/entities/upcoming_release.dart';
import 'package:akashic/layers/functional/Releases/domain/gateways/release_store.dart';
import 'package:akashic/layers/technical/LocalDatabase/akashic_database.dart';

class DriftReleaseStore implements ReleaseStore {
  DriftReleaseStore(this._database);

  static const String _outlookKey = 'releaseOutlook';
  static const String _announcedKey = 'announcedReleases';

  final AkashicDatabase _database;

  Future<Object?> _read(String key) async {
    final row = await (_database.select(_database.preferences)..where((table) => table.key.equals(key))).getSingleOrNull();
    return row == null ? null : jsonDecode(row.value);
  }

  Future<void> _write(String key, Object value) =>
      _database.into(_database.preferences).insertOnConflictUpdate(PreferencesCompanion.insert(key: key, value: jsonEncode(value)));

  @override
  Future<ReleaseOutlook?> cachedOutlook() async {
    final json = await _read(_outlookKey);
    if (json is! Map<String, Object?>) {
      return null;
    }
    return ReleaseOutlook(
      computedAt: DateTime.parse(json['computedAt']! as String),
      followedSubjects: json['followedSubjects']! as int,
      releases: [
        for (final release in (json['releases']! as List).cast<Map<String, Object?>>())
          UpcomingRelease(
            sourceKey: release['sourceKey']! as String,
            externalId: release['externalId']! as String,
            kind: ReleaseKind.values.byName(release['kind']! as String),
            subject: release['subject']! as String,
            title: release['title']! as String,
            releaseDate: DateTime.parse(release['releaseDate']! as String),
            datePrecision: ReleaseDatePrecision.values.byName(release['datePrecision'] as String? ?? ReleaseDatePrecision.day.name),
            imageUrl: release['imageUrl'] as String?,
            isEstimated: release['isEstimated'] as bool? ?? false,
            isWished: release['isWished'] as bool? ?? false,
          ),
      ],
    );
  }

  @override
  Future<void> saveOutlook(ReleaseOutlook outlook) => _write(_outlookKey, {
        'computedAt': outlook.computedAt.toIso8601String(),
        'followedSubjects': outlook.followedSubjects,
        'releases': [
          for (final release in outlook.releases)
            {
              'sourceKey': release.sourceKey,
              'externalId': release.externalId,
              'kind': release.kind.name,
              'subject': release.subject,
              'title': release.title,
              'releaseDate': release.releaseDate.toIso8601String(),
              'datePrecision': release.datePrecision.name,
              'imageUrl': release.imageUrl,
              'isEstimated': release.isEstimated,
              'isWished': release.isWished,
            },
        ],
      });

  @override
  Future<Set<String>?> announcedReleases() async {
    final json = await _read(_announcedKey);
    return json is List ? Set<String>.from(json) : null;
  }

  @override
  Future<void> saveAnnouncedReleases(Set<String> releaseKeys) => _write(_announcedKey, releaseKeys.toList());
}
