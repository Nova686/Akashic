import 'dart:convert';

import 'package:akashic/layers/functional/Settings/domain/entities/preferred_languages.dart';
import 'package:akashic/layers/functional/Settings/domain/gateways/settings_gateway.dart';
import 'package:akashic/layers/technical/LocalDatabase/akashic_database.dart';

class DriftSettingsGateway implements SettingsGateway {
  DriftSettingsGateway(this._database);

  static const String _preferredLanguagesKey = 'preferredLanguages';
  static const String _appLanguageKey = 'appLanguage';
  static const String _highContrastKey = 'highContrast';
  static const String _recentSearchesKey = 'recentSearches';
  static const String _collapsedSeriesKey = 'collapsedSeries';
  static const String _tutorialSeenKey = 'tutorialSeen';
  static const String _preconGroupingKey = 'preconGroupingAt';

  final AkashicDatabase _database;

  Stream<String?> _watchValue(String key) {
    final query = _database.select(_database.preferences)..where((table) => table.key.equals(key));
    return query.watchSingleOrNull().map((row) => row?.value);
  }

  Future<void> _saveValue(String key, String? value) async {
    if (value == null) {
      await (_database.delete(_database.preferences)..where((table) => table.key.equals(key))).go();
      return;
    }
    await _database.into(_database.preferences).insertOnConflictUpdate(PreferencesCompanion.insert(key: key, value: value));
  }

  @override
  Stream<PreferredLanguages> watchPreferredLanguages() => _watchValue(_preferredLanguagesKey).map(
        (value) => value == null ? PreferredLanguages.defaults : PreferredLanguages(List<String>.from(jsonDecode(value) as List)),
      );

  @override
  Future<void> savePreferredLanguages(PreferredLanguages languages) => _saveValue(_preferredLanguagesKey, jsonEncode(languages.codes));

  @override
  Stream<String?> watchAppLanguageCode() => _watchValue(_appLanguageKey);

  @override
  Future<void> saveAppLanguageCode(String? languageCode) => _saveValue(_appLanguageKey, languageCode);

  @override
  Stream<bool> watchHighContrast() => _watchValue(_highContrastKey).map((value) => value != 'false');

  @override
  Future<void> saveHighContrast(bool isHighContrast) => _saveValue(_highContrastKey, isHighContrast ? null : 'false');

  @override
  Stream<List<String>> watchRecentSearches() => _watchValue(_recentSearchesKey).map((value) => value == null ? const <String>[] : List<String>.from(jsonDecode(value) as List));

  @override
  Future<void> saveRecentSearches(List<String> queries) => _saveValue(_recentSearchesKey, jsonEncode(queries));

  @override
  Stream<Set<String>> watchCollapsedSeries() => _watchValue(_collapsedSeriesKey).map(
        (value) => value == null ? <String>{} : Set<String>.from(jsonDecode(value) as List),
      );

  @override
  Future<void> saveCollapsedSeries(Set<String> seriesIds) => _saveValue(_collapsedSeriesKey, jsonEncode(seriesIds.toList()..sort()));

  @override
  Future<bool> hasSeenTutorial() async => await _watchValue(_tutorialSeenKey).first != null;

  @override
  Future<void> markTutorialSeen() => _saveValue(_tutorialSeenKey, 'true');

  @override
  Future<DateTime?> lastPreconGroupingAt() async => DateTime.tryParse(await _watchValue(_preconGroupingKey).first ?? '');

  @override
  Future<void> savePreconGroupingAt(DateTime attemptedAt) => _saveValue(_preconGroupingKey, attemptedAt.toIso8601String());
}
