import 'package:akashic/layers/functional/Catalog/domain/entities/category_type.dart';
import 'package:akashic/layers/technical/Localization/app_localizations.dart';

String creatorLabelFor(CategoryType type, AppLocalizations l10n) => switch (type) {
      CategoryType.music => l10n.creatorArtist,
      CategoryType.books || CategoryType.manga || CategoryType.comics || CategoryType.boardGames => l10n.creatorAuthor,
      CategoryType.films => l10n.creatorDirector,
      CategoryType.videoGames => l10n.creatorStudio,
      CategoryType.lego => l10n.creatorTheme,
      CategoryType.amiibo => l10n.creatorAmiiboSeries,
      CategoryType.consoles => l10n.creatorManufacturer,
      CategoryType.cards || CategoryType.free => l10n.creator,
    };

String publisherLabelFor(CategoryType type, AppLocalizations l10n) => type == CategoryType.music ? l10n.publisherLabel : l10n.publisherName;
