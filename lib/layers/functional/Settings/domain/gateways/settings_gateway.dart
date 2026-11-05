import 'package:akashic/layers/functional/Settings/domain/entities/preferred_languages.dart';

abstract interface class SettingsGateway {
  Stream<PreferredLanguages> watchPreferredLanguages();
  Future<void> savePreferredLanguages(PreferredLanguages languages);
  Stream<String?> watchAppLanguageCode();
  Future<void> saveAppLanguageCode(String? languageCode);
  Stream<bool> watchHighContrast();
  Stream<List<String>> watchRecentSearches();
  Future<void> saveRecentSearches(List<String> queries);
  Future<void> saveHighContrast(bool isHighContrast);
  Stream<Set<String>> watchCollapsedSeries();
  Future<void> saveCollapsedSeries(Set<String> seriesIds);
  Future<bool> hasSeenTutorial();
  Future<void> markTutorialSeen();
  Future<DateTime?> lastPreconGroupingAt();
  Future<void> savePreconGroupingAt(DateTime attemptedAt);
}
