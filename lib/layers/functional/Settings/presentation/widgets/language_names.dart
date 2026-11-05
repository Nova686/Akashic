import 'package:akashic/layers/technical/Localization/app_localizations.dart';

const List<String> selectableTitleLanguageCodes = ['fr', 'en', 'ja', 'es', 'de', 'it', 'ko', 'zh', 'pt'];

String languageName(AppLocalizations l10n, String code) => switch (code) {
      'fr' => l10n.languageFr,
      'en' => l10n.languageEn,
      'ja' => l10n.languageJa,
      'es' => l10n.languageEs,
      'de' => l10n.languageDe,
      'it' => l10n.languageIt,
      'ko' => l10n.languageKo,
      'zh' => l10n.languageZh,
      'pt' => l10n.languagePt,
      _ => code,
    };

String languageFlag(String code) => switch (code) {
      'fr' => '🇫🇷',
      'en' => '🇬🇧',
      'ja' => '🇯🇵',
      'es' => '🇪🇸',
      'de' => '🇩🇪',
      'it' => '🇮🇹',
      'ko' => '🇰🇷',
      'zh' => '🇨🇳',
      'pt' => '🇵🇹',
      _ => '🌐',
    };

String languageEndonym(AppLocalizations l10n, String code) => switch (code) {
      'fr' => 'Français',
      'en' => 'English',
      _ => languageName(l10n, code),
    };
