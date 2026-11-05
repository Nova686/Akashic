import 'package:akashic/layers/functional/Collection/domain/entities/localized_titles.dart';
import 'package:akashic/layers/functional/Settings/domain/entities/preferred_languages.dart';

String? resolveDisplayTitle(LocalizedTitles titles, PreferredLanguages preferred) {
  final orderedLanguages = [...preferred.codes, ?titles.originalLanguage, ...titles.byLanguage.keys];
  for (final language in orderedLanguages) {
    final title = titles.byLanguage[language]?.trim();
    if (title != null && title.isNotEmpty) {
      return title;
    }
  }
  return null;
}

List<MapEntry<String, String>> orderedTitleVariants(LocalizedTitles titles, PreferredLanguages preferred) {
  final orderedLanguages = {...preferred.codes, ?titles.originalLanguage};
  return [
    for (final language in orderedLanguages)
      if (titles.byLanguage[language]?.trim().isNotEmpty ?? false) MapEntry(language, titles.byLanguage[language]!.trim()),
  ];
}
