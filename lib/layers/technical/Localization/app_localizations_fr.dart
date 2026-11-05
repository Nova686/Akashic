// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get navCollection => 'Collection';

  @override
  String get navCheck => 'Je l\'ai ?';

  @override
  String get navWishes => 'Envies';

  @override
  String get navDiscoveries => 'Découvertes';

  @override
  String get untitled => 'Sans titre';

  @override
  String get conditionMint => 'Neuf';

  @override
  String get conditionVeryGood => 'Très bon';

  @override
  String get conditionGood => 'Bon';

  @override
  String get conditionFair => 'Correct';

  @override
  String get conditionDamaged => 'Abîmé';

  @override
  String get conditionMissing => 'Manquant';

  @override
  String get partDisc => 'Disque';

  @override
  String get partSleeve => 'Pochette';

  @override
  String get partGame => 'Jeu';

  @override
  String get partBox => 'Boîte';

  @override
  String get partManual => 'Notice';

  @override
  String get partItem => 'Objet';

  @override
  String get myCollection => 'Ma collection';

  @override
  String objectsInCategories(int objects, int categories) {
    final intl.NumberFormat objectsNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String objectsString = objectsNumberFormat.format(objects);
    final intl.NumberFormat categoriesNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String categoriesString = categoriesNumberFormat.format(categories);

    String _temp0 = intl.Intl.pluralLogic(
      objects,
      locale: localeName,
      other: '$objectsString objets',
      one: '1 objet',
    );
    String _temp1 = intl.Intl.pluralLogic(
      categories,
      locale: localeName,
      other: '$categoriesString catégories',
      one: '1 catégorie',
    );
    return '$_temp0 dans $_temp1';
  }

  @override
  String get newCategory => 'Nouvelle catégorie';

  @override
  String get categoryName => 'Nom';

  @override
  String get fillInfoFrom => 'Remplir les infos depuis';

  @override
  String get categoryTypeMusic => 'Musique';

  @override
  String get categoryTypeBooks => 'Livres';

  @override
  String get categoryTypeManga => 'Mangas';

  @override
  String get categoryTypeComics => 'BD';

  @override
  String get categoryTypeFilms => 'Films';

  @override
  String get categoryTypeVideoGames => 'Jeux vidéo';

  @override
  String get categoryTypeCards => 'Cartes';

  @override
  String get categoryTypeFree => 'Personnalisée';

  @override
  String get subcategories => 'Sous-catégories';

  @override
  String get addSubcategory => 'Ajouter une sous-catégorie';

  @override
  String get subcategoryName => 'Nom de la sous-catégorie';

  @override
  String get conditionRatedOn => 'État noté sur';

  @override
  String get addPart => 'Ajouter une partie';

  @override
  String get partName => 'Nom de la partie';

  @override
  String get createCategory => 'Créer la catégorie';

  @override
  String get categoryNameRequired => 'Donne un nom à la catégorie.';

  @override
  String get close => 'Fermer';

  @override
  String get settings => 'Réglages';

  @override
  String get appLanguage => 'Langue de l’appli';

  @override
  String get followDevice => 'Comme le téléphone';

  @override
  String get preferredTitleLanguages => 'Langues préférées des titres';

  @override
  String get preferredTitleLanguagesHint =>
      'Les titres s’affichent dans la première langue disponible de cette liste.';

  @override
  String get addLanguage => 'Ajouter une langue';

  @override
  String get lastLanguageRefused => 'Garde au moins une langue.';

  @override
  String get languageFr => 'Français';

  @override
  String get languageEn => 'Anglais';

  @override
  String get languageJa => 'Japonais';

  @override
  String get languageEs => 'Espagnol';

  @override
  String get languageDe => 'Allemand';

  @override
  String get languageIt => 'Italien';

  @override
  String get languageKo => 'Coréen';

  @override
  String get languageZh => 'Chinois';

  @override
  String get languagePt => 'Portugais';

  @override
  String get addItem => 'Ajouter un objet';

  @override
  String get titles => 'Titres';

  @override
  String get originalLanguage => 'Original';

  @override
  String get creator => 'Artiste ou auteur';

  @override
  String get year => 'Année';

  @override
  String get publisher => 'Éditeur ou label';

  @override
  String get image => 'Image';

  @override
  String get imageFromInternet => 'Sur internet';

  @override
  String get comingSoon => 'Bientôt';

  @override
  String get imageFromPhone => 'Depuis mon téléphone';

  @override
  String get takePhoto => 'Prendre une photo';

  @override
  String get chooseFromGallery => 'Choisir dans la galerie';

  @override
  String get spineColor => 'Couleur de la tranche';

  @override
  String get partOfSeries => 'Fait partie d’une série';

  @override
  String get newSeries => 'Nouvelle série';

  @override
  String get volumeFrom => 'Du tome';

  @override
  String get volumeTo => 'Au tome';

  @override
  String get volumeRangeInvalid => 'Vérifie les numéros de tomes.';

  @override
  String get titleRequired => 'Donne au moins un titre.';

  @override
  String get myRating => 'Ma note';

  @override
  String get addToCollection => 'Ajouter à ma collection';

  @override
  String get edition => 'Édition';

  @override
  String get pricePaid => 'Prix payé';

  @override
  String get storedAt => 'Rangé';

  @override
  String get condition => 'État';

  @override
  String get priceInvalid => 'Saisis un prix comme 28,50.';

  @override
  String get save => 'Enregistrer';

  @override
  String get editCopy => 'Modifier les informations';

  @override
  String get searchCollection => 'Chercher dans ma collection';

  @override
  String get allSubcategories => 'Tous';

  @override
  String get foldAll => 'Tout replier';

  @override
  String get unfoldAll => 'Tout déplier';

  @override
  String get addFirstItem => 'Ajoute ton premier objet';

  @override
  String get emptyShelf => 'Rien sur cette étagère pour l’instant.';

  @override
  String get noSearchResults => 'Rien trouvé dans ta collection.';

  @override
  String get emptyCollection =>
      'Crée ta première catégorie pour commencer tes étagères.';

  @override
  String seriesToComplete(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count séries à compléter',
      one: '1 série à compléter',
    );
    return '$_temp0';
  }

  @override
  String get myInfo => 'Mes infos';

  @override
  String get learnMore => 'En savoir plus';

  @override
  String get titleVariants => 'Variantes du titre';

  @override
  String get myCopies => 'Achat, état et rangement';

  @override
  String get copyWithoutDetails => 'Aucun détail pour l’instant';

  @override
  String partCondition(String part, String condition) {
    return '$part : $condition';
  }

  @override
  String get saveFailed =>
      'L’enregistrement a échoué. Vérifie la catégorie et réessaie.';

  @override
  String get photographCover => 'Photographier la pochette';

  @override
  String get seeItem => 'Voir la fiche';

  @override
  String get checking => 'Vérification…';

  @override
  String get searchOnline => 'Chercher sur internet';

  @override
  String get webImages => 'Images trouvées sur internet';

  @override
  String get creatorArtist => 'Artiste';

  @override
  String get creatorAuthor => 'Auteur';

  @override
  String get creatorDirector => 'Réalisateur';

  @override
  String get creatorStudio => 'Studio';

  @override
  String get publisherLabel => 'Label';

  @override
  String get publisherName => 'Éditeur';

  @override
  String get platformConsole => 'Plateforme (console)';

  @override
  String get editItem => 'Modifier l’objet';

  @override
  String get editAction => 'Modifier';

  @override
  String get chainResolving => 'Recherche…';

  @override
  String get chainFound => 'Pas encore à toi';

  @override
  String get chainAlreadyOwned => 'Déjà à toi';

  @override
  String get chainNotFound => 'Introuvable';

  @override
  String addScannedItems(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Ajouter $count objets',
      one: 'Ajouter 1 objet',
      zero: 'Rien à ajouter',
    );
    return '$_temp0';
  }

  @override
  String scannedItemsAdded(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count objets ajoutés',
      one: '1 objet ajouté',
    );
    return '$_temp0';
  }

  @override
  String get scanBarcode => 'Scanner un code-barres';

  @override
  String barcodeValue(String code) {
    return 'Code-barres : $code';
  }

  @override
  String get toComplete => 'À compléter';

  @override
  String get publishedVolumes => 'Tomes parus';

  @override
  String get updateFromAniList => 'Mettre à jour depuis AniList';

  @override
  String get updateFailed =>
      'La mise à jour a échoué. Vérifie le réseau et réessaie.';

  @override
  String get ownedVolumes => 'Mes tomes';

  @override
  String get seeSeries => 'Voir la série';

  @override
  String missingVolumesList(String volumes) {
    return 'Il te manque : $volumes';
  }

  @override
  String nextNotReleased(int number) {
    return 'Le tome $number n’est pas encore sorti.';
  }

  @override
  String ownedOfPublished(int owned, int published) {
    return '$owned / $published parus';
  }

  @override
  String get cardKindExtension => 'Extension';

  @override
  String get cardKindDeck => 'Deck';

  @override
  String get editDeck => 'Modifier le deck';

  @override
  String get searchCard => 'Chercher une carte';

  @override
  String deckCardsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count cartes dans le deck',
      one: '1 carte dans le deck',
    );
    return '$_temp0';
  }

  @override
  String get fetchDetails => 'Récupérer les infos';

  @override
  String get updateDetails => 'Mettre à jour';

  @override
  String fetchedOn(String date) {
    return 'Récupéré le $date';
  }

  @override
  String get detailsUnavailable =>
      'Impossible de récupérer les infos. Vérifie le réseau et réessaie.';

  @override
  String get noDetailsYet => 'Rien de récupéré pour l’instant.';

  @override
  String get sectionSummary => 'Résumé';

  @override
  String get sectionTracks => 'Titres';

  @override
  String get sectionGenres => 'Genres';

  @override
  String get sectionLinks => 'Liens';

  @override
  String get factLabel => 'Label';

  @override
  String get factStatus => 'Statut';

  @override
  String get factVolumes => 'Tomes';

  @override
  String get factChapters => 'Chapitres';

  @override
  String get factRuntime => 'Durée';

  @override
  String get factDirector => 'Réalisation';

  @override
  String get factStudio => 'Studio';

  @override
  String get factPlatforms => 'Plateformes';

  @override
  String get sectionFacts => 'Infos';

  @override
  String factLine(String label, String value) {
    return '$label : $value';
  }

  @override
  String get publicationStatusFinished => 'Terminée';

  @override
  String get publicationStatusReleasing => 'En cours';

  @override
  String get publicationStatusNotYetReleased => 'Pas encore sortie';

  @override
  String get publicationStatusCancelled => 'Annulée';

  @override
  String get publicationStatusHiatus => 'En pause';

  @override
  String get wishesEmpty =>
      'Aucune envie pour l’instant. Ajoutes-en depuis une vérification, une recherche, une découverte ou une série.';

  @override
  String get wishOriginDiscovery => 'Depuis une découverte';

  @override
  String get wishOriginSearch => 'Depuis une recherche';

  @override
  String get wishOriginMissingVolume => 'Tome manquant';

  @override
  String get wishOriginManual => 'Ajoutée à la main';

  @override
  String wishFulfilled(String title) {
    return '$title est dans ta collection, retiré de tes envies.';
  }

  @override
  String get addToWishes => 'Ajouter à mes envies';

  @override
  String get addedToWishes => 'Ajouté à tes envies.';

  @override
  String get wishRemoved => 'Envie retirée.';

  @override
  String get removeWish => 'Retirer de mes envies';

  @override
  String wishVolumeTitle(String title, int number) {
    return '$title, tome $number';
  }

  @override
  String get addMissingToWishes => 'Ajouter les tomes manquants à mes envies';

  @override
  String missingAddedToWishes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count tomes ajoutés à tes envies',
      one: '1 tome ajouté à tes envies',
      zero: 'Ces tomes étaient déjà dans tes envies',
    );
    return '$_temp0';
  }

  @override
  String get wished => 'En envie';

  @override
  String get allTypes => 'Tout';

  @override
  String becauseYouHave(String title) {
    return 'Parce que tu as $title';
  }

  @override
  String discoveriesComputedOn(String date) {
    return 'Calculées le $date';
  }

  @override
  String get discoveriesOffline =>
      'Pas de réseau : voici les dernières découvertes gardées.';

  @override
  String get discoveriesOfflineEmpty =>
      'Pas de réseau. Les découvertes reviendront avec la connexion.';

  @override
  String get discoveriesNeedSeeds =>
      'Ajoute des objets trouvés en ligne (avec leur source) pour recevoir des découvertes.';

  @override
  String get discoveriesNothingNew => 'Rien de nouveau pour l’instant.';

  @override
  String get notForMe => 'Pas pour moi';

  @override
  String get addWishShort => '+ Envie';

  @override
  String get refreshDiscoveries => 'Rafraîchir les découvertes';

  @override
  String get suggestionDismissed => 'Elle ne te sera plus proposée.';

  @override
  String wishesFulfilled(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count envies sont dans ta collection, retirées de tes envies.',
      one: '1 envie est dans ta collection, retirée de tes envies.',
    );
    return '$_temp0';
  }

  @override
  String wishOriginOn(String origin, String date) {
    return '$origin · $date';
  }

  @override
  String newChapterNotificationTitle(String title) {
    return '$title : nouveau chapitre';
  }

  @override
  String newChaptersNotificationBody(int count, String chapters) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Les chapitres $chapters sont sortis',
      one: 'Le chapitre $chapters est sorti',
    );
    return '$_temp0';
  }

  @override
  String get scanAlertsChannelName => 'Nouveaux chapitres';

  @override
  String get scanAlertsChannelDescription =>
      'Alertes quand une série suivie a un nouveau chapitre.';

  @override
  String get physicalTab => 'Physique';

  @override
  String get scansTab => 'Scans';

  @override
  String get notFollowedInScans =>
      'Tu ne suis pas encore cette série en scans.';

  @override
  String get followInScans => 'Suivre en scans';

  @override
  String get stopFollowingInScans => 'Ne plus suivre en scans';

  @override
  String get lastChapterRead => 'Dernier chapitre lu';

  @override
  String newChaptersCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count nouveaux chapitres',
      one: '1 nouveau chapitre',
      zero: 'À jour',
    );
    return '$_temp0';
  }

  @override
  String get readUpToChapter => 'Lu jusqu’au chapitre…';

  @override
  String get markRead => 'Marquer';

  @override
  String get chaptersRead => 'Chapitres';

  @override
  String get showAllChapters => 'Afficher tous les chapitres';

  @override
  String get readingSite => 'Site de lecture (lien)';

  @override
  String get openReadingSite => 'Ouvrir le site de lecture';

  @override
  String get translationTeam => 'Équipe de traduction';

  @override
  String get linkedToMangaUpdates => 'Reliée à MangaUpdates';

  @override
  String get unlinkMangaUpdates => 'Délier';

  @override
  String get searchMangaUpdates => 'Trouver cette série sur MangaUpdates';

  @override
  String get manualTrackingHint =>
      'Sans MangaUpdates, le suivi reste manuel et sans alerte.';

  @override
  String get checkReleases => 'Vérifier les nouveaux chapitres';

  @override
  String get chapterAlerts => 'M’alerter à la sortie d’un chapitre';

  @override
  String get onlyMyTeam => 'Seulement les sorties de mon équipe';

  @override
  String get releasesCheckFailed =>
      'MangaUpdates est injoignable. Réessaie plus tard.';

  @override
  String get notificationsRefused =>
      'Les notifications d’Akashic sont désactivées dans les réglages du téléphone.';

  @override
  String get noReleaseSeriesFound => 'Aucune série trouvée.';

  @override
  String get noScanFollows => 'Aucune série suivie en scans pour l’instant.';

  @override
  String get followSeriesInScans => 'Suivre une série en scans';

  @override
  String get newSeriesTitle => 'Titre d’une nouvelle série';

  @override
  String get createAndFollow => 'Créer et suivre';

  @override
  String lastReadChapterShort(String chapter) {
    return 'Dernier lu : chapitre $chapter';
  }

  @override
  String get nothingReadYet => 'Rien lu pour l’instant';

  @override
  String get stopFollowingQuestion =>
      'Ne plus suivre cette série en scans ? Tes chapitres lus sont gardés.';

  @override
  String get cancel => 'Annuler';

  @override
  String get loans => 'Prêts en cours';

  @override
  String get noLoans => 'Rien n’est prêté en ce moment.';

  @override
  String get lendCopy => 'Prêter';

  @override
  String get returnCopy => 'Rendu';

  @override
  String get borrowerName => 'Prêté à';

  @override
  String lentToSince(String borrower, String date) {
    return 'Prêté à $borrower depuis le $date';
  }

  @override
  String get statistics => 'Statistiques';

  @override
  String get totalPaid => 'Total payé';

  @override
  String get byCategory => 'Par catégorie';

  @override
  String get purchasesByMonth => 'Achats par mois';

  @override
  String get noStatsYet => 'Ajoute des objets pour voir tes statistiques.';

  @override
  String monthSummary(String month, int count, String amount) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count objets',
      one: '1 objet',
      zero: 'aucun achat',
    );
    return '$month : $_temp0, $amount';
  }

  @override
  String get importCollection => 'Importer un tableur';

  @override
  String get importDestination => 'Catégorie de destination';

  @override
  String get chooseSpreadsheet => 'Choisir un fichier (.xlsx, .csv)';

  @override
  String get downloadTemplate => 'Télécharger le modèle';

  @override
  String get templateSaved => 'Modèle enregistré.';

  @override
  String get unreadableSpreadsheet =>
      'Ce fichier est illisible. Utilise un fichier .xlsx ou .csv.';

  @override
  String get matchColumns => 'Associer les colonnes';

  @override
  String continueWithRows(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Continuer avec $count lignes',
      one: 'Continuer avec 1 ligne',
      zero: 'Aucune ligne à importer',
    );
    return '$_temp0';
  }

  @override
  String get importFieldIgnored => 'Ignorer';

  @override
  String get importFieldTitle => 'Titre';

  @override
  String get importFieldCreator => 'Artiste ou auteur';

  @override
  String get importFieldBarcode => 'Code-barres';

  @override
  String get importFieldEdition => 'Édition';

  @override
  String get importFieldPrice => 'Prix payé';

  @override
  String get importFieldLocation => 'Emplacement';

  @override
  String get importFieldCondition => 'État';

  @override
  String get importFieldYear => 'Année';

  @override
  String get importFieldSeries => 'Série';

  @override
  String get importFieldVolume => 'Tome';

  @override
  String resolvingRows(int done, int total) {
    return 'Recherche $done sur $total…';
  }

  @override
  String get importFound => 'Trouvé';

  @override
  String get importNotFound => 'Introuvable : ajouté tel quel si coché';

  @override
  String get importAlreadyOwned => 'Déjà dans ta collection';

  @override
  String addImportedRows(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Ajouter $count objets',
      one: 'Ajouter 1 objet',
      zero: 'Rien à ajouter',
    );
    return '$_temp0';
  }

  @override
  String importedCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count objets ajoutés',
      one: '1 objet ajouté',
      zero: 'Rien n’a été ajouté',
    );
    return '$_temp0';
  }

  @override
  String importRowStatus(int number, String status) {
    return 'Ligne $number · $status';
  }

  @override
  String get collectionData => 'Données de la collection';

  @override
  String get backup => 'Sauvegarde Google Drive';

  @override
  String lastBackupOn(String date) {
    return 'Dernière sauvegarde : $date';
  }

  @override
  String get noBackupYet => 'Aucune sauvegarde pour l’instant.';

  @override
  String get backupExplanation =>
      'Ta collection et ses images sont enregistrées dans un dossier privé d’Akashic sur ton Google Drive. Une sauvegarde se fait aussi toute seule une fois par semaine tant que la connexion Google est valide.';

  @override
  String get backupReconnectReminder =>
      'La connexion Google a expiré : reconnecte-toi pour reprendre les sauvegardes hebdomadaires.';

  @override
  String get backUpNow => 'Sauvegarder maintenant';

  @override
  String get restoreBackup => 'Restaurer une sauvegarde';

  @override
  String get reconnectGoogle => 'Se reconnecter à Google';

  @override
  String get backupDone => 'Sauvegarde enregistrée sur Google Drive.';

  @override
  String get backupUnavailable =>
      'Google Drive est injoignable. Réessaie plus tard.';

  @override
  String get backupAuthorizationRefused =>
      'Google n’a pas donné l’accès à Drive.';

  @override
  String get backupCorrupt =>
      'Cette sauvegarde est abîmée et ne peut pas être restaurée.';

  @override
  String get noRemoteBackup => 'Aucune sauvegarde trouvée sur Google Drive.';

  @override
  String restoreQuestion(String date) {
    return 'Remplacer ta collection actuelle par la sauvegarde du $date ?';
  }

  @override
  String get restoreConfirm => 'Remplacer';

  @override
  String get restoreReady =>
      'La sauvegarde est prête. Akashic va se fermer : rouvre-la pour terminer la restauration.';

  @override
  String get closeAkashic => 'Fermer Akashic';

  @override
  String get restoreFailed =>
      'La dernière restauration n’a pas pu aboutir. Ta collection est restée telle quelle.';

  @override
  String get importDuplicateInFile => 'Déjà plus haut dans ce fichier';

  @override
  String get importAdded => 'Ajouté';

  @override
  String get importFailed => 'N’a pas pu être ajouté';

  @override
  String get factPages => 'Pages';

  @override
  String get factPublisher => 'Éditeur';

  @override
  String get factFormat => 'Format';

  @override
  String get dataSources => 'Sources des données';

  @override
  String get dataSourcesList =>
      'Musique : Discogs et MusicBrainz (pochettes Cover Art Archive) · Livres et BD : Google Books et Open Library, comics américains : Comic Vine · Mangas : AniList et Jikan (MyAnimeList), et Google Books pour les scans d’ISBN · Secours ISBN : catalogue de la BnF (Licence Ouverte) · Films : TMDB · Séries : TVmaze (CC BY-SA) · Jeux vidéo et consoles : IGDB · LEGO : Rebrickable · amiibo : AmiiboAPI · Codes-barres de produits : UPCitemdb · Jeux de société : BoardGameGeek · Pokémon : TCGdex · Magic : Scryfall, MTGJSON · Yu-Gi-Oh! : YGOPRODeck · Lorcana : Lorcast · Riftbound : Riftcodex · One Piece : OPTCG API · Scans : MangaUpdates · Secours en cas de quota : Deezer (musique), MangaDex (mangas), Wikidata (films, jeux vidéo, jeux de société)';

  @override
  String get tmdbNotice =>
      'Ce produit utilise l’API TMDB mais n’est ni approuvé ni certifié par TMDB.';

  @override
  String get apiLimits => 'Limites des API';

  @override
  String get noApiPaused => 'Aucune API n’est en pause.';

  @override
  String apiPausedCountdown(String source, String remaining) {
    return '$source : de nouveau disponible dans $remaining';
  }

  @override
  String apiPausedSeveral(int count, String remaining) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count API en pause',
      one: '1 API en pause',
    );
    return '$_temp0 · reprise de la prochaine dans $remaining';
  }

  @override
  String apiBlockedAtRetryAt(String blockedAt, String retryAt) {
    return 'Limite atteinte à $blockedAt · prochaine connexion à $retryAt';
  }

  @override
  String get apiLimitsExplanation =>
      'Quand une source refuse les requêtes parce que sa limite gratuite est atteinte, Akashic attend qu’elle les accepte de nouveau.';

  @override
  String get searchingImages => 'Recherche d’images…';

  @override
  String get tapToSearchImages => 'Toucher pour chercher';

  @override
  String groupItemCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count objets',
      one: '1 objet',
    );
    return '$_temp0';
  }

  @override
  String missingVolumeShort(int number) {
    return 'T. $number';
  }

  @override
  String missingVolumesMore(int count) {
    return '$count manquants';
  }

  @override
  String get otherItems => 'Autres';

  @override
  String get cameraUnavailable =>
      'Impossible d\'ouvrir la caméra. Vérifie l\'autorisation caméra dans les réglages du téléphone.';

  @override
  String get removeLanguage => 'Retirer cette langue';

  @override
  String get typeCardName => 'Nom de la carte';

  @override
  String get noApiForThisGame =>
      'Pas de catalogue en ligne pour ce jeu : les cartes se saisissent à la main.';

  @override
  String addCardAsTyped(String name) {
    return 'Ajouter « $name » tel quel';
  }

  @override
  String get noApiForThisCategory =>
      'Pas de catalogue en ligne pour cette catégorie : remplis la fiche à la main, la recherche d’images reste disponible.';

  @override
  String get add => 'Ajouter';

  @override
  String get cardGamesWithCatalogue => 'Jeux avec catalogue en ligne';

  @override
  String get otherCardGamesByHand =>
      'Tout autre jeu fonctionne aussi : ses cartes se saisissent à la main.';

  @override
  String get categoryTypeBoardGames => 'Jeux de société';

  @override
  String get partComponents => 'Matériel';

  @override
  String get aimBarcodeOrShootCover =>
      'Vise un code-barres, ou photographie la pochette';

  @override
  String get delete => 'Supprimer';

  @override
  String get deleteCopy => 'Retirer de la collection';

  @override
  String get deleteLastCopyTitle => 'Retirer cet objet de la collection ?';

  @override
  String get deleteLastCopyExplanation =>
      'L’objet sera supprimé, avec ses titres, sa couverture, ses détails et son deck.';

  @override
  String get noOnlineDetailsForItem =>
      'Aucun catalogue en ligne ne décrit cet objet : il a été saisi à la main ou vient d’une source sans fiche détaillée.';

  @override
  String get customCategoryExplanation =>
      'Une catégorie à ton nom, sans catalogue en ligne : chaque objet se saisit à la main, avec la recherche d’images pour la couverture. Ajoute ci-dessous les parties dont tu veux noter l’état.';

  @override
  String get chainScanHint =>
      'Scanne des codes-barres ou photographie des pochettes : tu vois tout de suite si tu les as, puis tu ajoutes ceux que tu gardes.';

  @override
  String get scannedCodes => 'Codes scannés';

  @override
  String get chainRateLimited => 'Quota dépassé';

  @override
  String get chainUnreachable => 'Catalogue injoignable';

  @override
  String get chainUnreadable => 'Pochette illisible';

  @override
  String get coverBeingRead => 'Lecture de la pochette…';

  @override
  String coverEntryLabel(String title) {
    return 'Pochette : $title';
  }

  @override
  String chainFailureNotFound(String label) {
    return 'Aucun résultat pour $label.';
  }

  @override
  String get chainFailureUnreadable =>
      'Pochette illisible : reprends la photo, plus près et sans reflet.';

  @override
  String chainFailureRateLimited(String label) {
    return 'Quota d’appels dépassé : $label n’a pas pu être vérifié.';
  }

  @override
  String chainFailureUnreachable(String label) {
    return 'Catalogues injoignables : $label n’a pas pu être vérifié.';
  }

  @override
  String scannedItemsPartlyAdded(int added, int failed) {
    return '$added ajoutés, $failed n’ont pas pu être ajoutés.';
  }

  @override
  String get unexpectedError => 'Une erreur est survenue. Réessaie.';

  @override
  String unexpectedErrorWithDetail(String detail) {
    return 'Une erreur est survenue : $detail';
  }

  @override
  String sourceRateLimitedToast(String source) {
    return '$source : quota d’appels dépassé, réessaie plus tard.';
  }

  @override
  String sourceUnreachableToast(String source) {
    return '$source est injoignable : vérifie le réseau.';
  }

  @override
  String get itemSaveFailedToast => 'L’objet n’a pas pu être enregistré.';

  @override
  String get discoveriesFailedToast =>
      'Les découvertes n’ont pas pu être actualisées : catalogues injoignables.';

  @override
  String get automaticBackupFailedToast =>
      'La sauvegarde automatique a échoué.';

  @override
  String importLineFailedToast(int row) {
    return 'La ligne $row n’a pas pu être vérifiée.';
  }

  @override
  String appVersionLabel(String version) {
    return 'Akashic $version';
  }

  @override
  String get editCategory => 'Modifier la catégorie';

  @override
  String get reorderCategories => 'Changer l’ordre';

  @override
  String get deleteCategory => 'Supprimer la catégorie';

  @override
  String get categoryActions => 'Actions sur la catégorie';

  @override
  String deleteCategoryTitle(String name) {
    return 'Supprimer « $name » ?';
  }

  @override
  String get deleteEmptyCategoryExplanation => 'Cette catégorie est vide.';

  @override
  String deleteCategoryExplanation(int items, int series, int subcategories) {
    String _temp0 = intl.Intl.pluralLogic(
      items,
      locale: localeName,
      other: '$items objets',
      one: '1 objet',
      zero: 'aucun objet',
    );
    String _temp1 = intl.Intl.pluralLogic(
      series,
      locale: localeName,
      other: '$series séries',
      one: '1 série',
      zero: 'aucune série',
    );
    String _temp2 = intl.Intl.pluralLogic(
      subcategories,
      locale: localeName,
      other: '$subcategories sous-catégories',
      one: '1 sous-catégorie',
      zero: 'aucune sous-catégorie',
    );
    return 'Tout son contenu sera aussi supprimé : $_temp0, $_temp1 et $_temp2, avec leurs couvertures. C’est définitif.';
  }

  @override
  String get moveItem => 'Déplacer vers une autre catégorie';

  @override
  String get moveSeriesQuestion => 'Déplacer toute la série ?';

  @override
  String get moveSeriesExplanation =>
      'Cet objet fait partie d’une série. Déplace la série avec tous ses tomes, ou seulement celui-ci, qui quitte alors la série.';

  @override
  String get moveThisVolumeOnly => 'Celui-ci seul';

  @override
  String get moveWholeSeries => 'Toute la série';

  @override
  String movedInto(String category) {
    return 'Déplacé dans $category.';
  }

  @override
  String get backupFileSection => 'Fichier de sauvegarde';

  @override
  String get backupFileExplanation =>
      'La même archive complète que la sauvegarde Drive (collection et couvertures), enregistrée où tu veux : téléphone, carte SD, autre appli de stockage.';

  @override
  String get exportToFile => 'Exporter dans un fichier';

  @override
  String get restoreFromFile => 'Restaurer depuis un fichier';

  @override
  String get exportDone => 'Collection exportée.';

  @override
  String get progressTitle => 'Progression';

  @override
  String get progressNotStarted => 'Pas commencé';

  @override
  String get progressToRead => 'À lire';

  @override
  String get progressToPlay => 'À jouer';

  @override
  String get progressToWatch => 'À voir';

  @override
  String get progressToListen => 'À écouter';

  @override
  String get progressInProgress => 'En cours';

  @override
  String get progressFinished => 'Fini';

  @override
  String get progressRead => 'Lu';

  @override
  String get progressPlayed => 'Terminé';

  @override
  String get progressWatched => 'Vu';

  @override
  String get progressListened => 'Écouté';

  @override
  String get progressAbandoned => 'Abandonné';

  @override
  String get progressChapter => 'Chapitre';

  @override
  String get progressPage => 'Page';

  @override
  String progressBookmark(String chapter, String page) {
    return 'Chapitre $chapter · page $page';
  }

  @override
  String get arrangeShelf => 'Trier et filtrer';

  @override
  String get sortTitle => 'Trier';

  @override
  String get sortBySeries => 'Par série';

  @override
  String get sortByTitle => 'Titre';

  @override
  String get sortByCreator => 'Auteur ou artiste';

  @override
  String get sortNewest => 'Plus récents';

  @override
  String get sortOldest => 'Plus anciens';

  @override
  String get sortBestRated => 'Mieux notés';

  @override
  String get sortRecentlyAdded => 'Derniers ajouts';

  @override
  String get filterAll => 'Tous';

  @override
  String get filterMinimumRating => 'Note';

  @override
  String filterAtLeastStars(int stars) {
    return '$stars★ et plus';
  }

  @override
  String get resetArrangement => 'Réinitialiser';

  @override
  String get applyArrangement => 'Appliquer';

  @override
  String get noItemMatchesArrangement =>
      'Aucun objet ne correspond à ces filtres.';

  @override
  String get photosTitle => 'Photos';

  @override
  String get addPhoto => 'Ajouter une photo';

  @override
  String get pickFromGallery => 'Choisir dans la galerie';

  @override
  String get deletePhotoQuestion => 'Supprimer cette photo ?';

  @override
  String get photosHint => 'Appuie pour agrandir, appui long pour supprimer.';

  @override
  String get loanRemindersChannelName => 'Rappels de prêts';

  @override
  String get loanRemindersChannelDescription =>
      'Te rappelle les objets prêtés depuis un mois.';

  @override
  String loanReminderTitle(String title) {
    return '$title est toujours prêté';
  }

  @override
  String loanReminderBody(String borrower, int days) {
    return '$borrower l’a depuis $days jours.';
  }

  @override
  String selectedItemsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count sélectionnés',
      one: '1 sélectionné',
    );
    return '$_temp0';
  }

  @override
  String get clearSelection => 'Annuler la sélection';

  @override
  String get setStorageLocation => 'Définir l’emplacement';

  @override
  String get locationApplied => 'Emplacement mis à jour.';

  @override
  String deleteSelectedItemsTitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Supprimer $count objets ?',
      one: 'Supprimer 1 objet ?',
    );
    return '$_temp0';
  }

  @override
  String get deleteSelectedItemsExplanation =>
      'Leurs photos, couvertures, détails et prêts seront aussi supprimés. C’est définitif.';

  @override
  String get shareWishlist => 'Partager mes envies';

  @override
  String get wishlistShareHeading => 'Mes envies, depuis Akashic';

  @override
  String get wishlistShareSubject => 'Ma liste d’envies';

  @override
  String get discogsImportTitle => 'Importer ma collection Discogs';

  @override
  String get discogsImportExplanation =>
      'Chaque disque de ta collection Discogs est ajouté avec sa pochette. Ceux déjà dans Akashic sont ignorés : tu peux relancer l’import plus tard pour ajouter les nouveaux.';

  @override
  String get discogsImportTarget => 'Catégorie musique';

  @override
  String get discogsImportStart => 'Importer';

  @override
  String get discogsImportReading => 'Lecture de ta collection Discogs…';

  @override
  String discogsImportProgress(int done, int total) {
    return '$done disques sur $total';
  }

  @override
  String discogsImportOutcome(int added, int owned, int failed) {
    return '$added ajoutés, $owned déjà présents, $failed en échec.';
  }

  @override
  String get discogsImportNeedsToken => 'Aucun jeton Discogs n’est configuré.';

  @override
  String get discogsImportNeedsMusicCategory =>
      'Crée d’abord une catégorie musique.';

  @override
  String widgetItemCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count objets',
      one: '1 objet',
      zero: 'Aucun objet',
    );
    return '$_temp0';
  }

  @override
  String widgetLatestAdditions(String titles) {
    return 'Derniers ajouts : $titles';
  }

  @override
  String widgetLoans(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count prêts en cours',
      one: '1 prêt en cours',
    );
    return '$_temp0';
  }

  @override
  String get widgetNoLoan => 'Aucun prêt en cours';

  @override
  String get updateCardPrices => 'Mettre à jour les prix';

  @override
  String deckEstimatedValue(String value) {
    return 'Valeur estimée : $value';
  }

  @override
  String get deckValueUnknown => 'Pas encore de prix';

  @override
  String get categoryTypeLego => 'LEGO';

  @override
  String get categoryTypeAmiibo => 'amiibo';

  @override
  String get categoryTypeConsoles => 'Consoles et matériel';

  @override
  String get creatorTheme => 'Thème';

  @override
  String get creatorAmiiboSeries => 'Série amiibo';

  @override
  String get creatorManufacturer => 'Fabricant';

  @override
  String get upcomingReleases => 'Sorties à venir';

  @override
  String get refreshReleases => 'Actualiser les sorties';

  @override
  String get releasesFailedToast =>
      'Impossible de récupérer les sorties à venir pour l’instant.';

  @override
  String get releasesOfflineEmpty =>
      'Les sorties à venir n’ont pas pu être chargées. Réessaie quand tu seras connecté.';

  @override
  String get releasesNeedInterests =>
      'Range des tomes numérotés dans une série, crée une catégorie de jeu de cartes (Pokémon, Magic, Yu-Gi-Oh!, Lorcana, Riftbound) ou ajoute des disques avec leur artiste pour suivre leurs sorties.';

  @override
  String get releasesNothingAnnounced =>
      'Aucune sortie annoncée pour ce que tu collectionnes.';

  @override
  String get releaseAlertsChannelName => 'Sorties à venir';

  @override
  String get releaseAlertsChannelDescription =>
      'Te prévient quand une extension, un album ou le tome suivant d’une série est annoncé.';

  @override
  String releaseAlertTitle(String title) {
    return 'Sortie annoncée : $title';
  }

  @override
  String releaseAlertBody(String subject, String date) {
    return '$subject · le $date';
  }

  @override
  String releaseAlertSummaryTitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count nouvelles sorties annoncées',
      one: '1 nouvelle sortie annoncée',
    );
    return '$_temp0';
  }

  @override
  String get chooseCategory => 'Choisir une catégorie';

  @override
  String get navReleases => 'Sorties';

  @override
  String get seeAll => 'Voir tout';

  @override
  String get tutorialNext => 'Suivant';

  @override
  String get replayTutorial => 'Revoir le tutoriel';

  @override
  String get helpSection => 'Aide';

  @override
  String get addItemShort => 'Ajouter';

  @override
  String get tourPrevious => 'Précédent';

  @override
  String get tourDone => 'Terminer';

  @override
  String tourProgress(int current, int total) {
    return '$current / $total';
  }

  @override
  String get tourWelcomeTitle => 'Bienvenue dans Akashic';

  @override
  String get tourWelcomeText =>
      'Ta collection physique rangée comme sur tes étagères : livres, mangas, musique, films, jeux, cartes, LEGO… Petit tour des commandes.';

  @override
  String get tourNewCategoryTitle => 'Crée tes catégories';

  @override
  String get tourNewCategoryText =>
      'Choisis un type (mangas, vinyles, jeu de cartes…) : il décide des catalogues interrogés. Chaque catégorie devient une étagère ; touche-la pour l’ouvrir.';

  @override
  String get tourSearchTitle => 'Retrouve un objet';

  @override
  String get tourSearchText =>
      'Cherche dans toute ta collection par titre, auteur ou code-barres.';

  @override
  String get tourScanTitle => 'Scanne';

  @override
  String get tourScanText =>
      'Vise des codes-barres à la chaîne ou photographie une couverture : tu vois tout de suite si tu l’as déjà, puis tu ajoutes d’un coup ce que tu gardes.';

  @override
  String get tourMenuTitle => 'Le reste est ici';

  @override
  String get tourMenuText =>
      'Prêts, statistiques et paramètres : sauvegarde Drive, import, langues… et « Revoir le tutoriel » pour refaire ce tour.';

  @override
  String get tourWishesTitle => 'Tes envies';

  @override
  String get tourWishesText =>
      'Ce que tu cherches encore, à partager en un geste.';

  @override
  String get tourDiscoveriesTitle => 'Découvertes';

  @override
  String get tourDiscoveriesText =>
      'Des suggestions tirées de ta collection ; touche une carte pour voir ses détails.';

  @override
  String get tourReleasesTitle => 'Sorties';

  @override
  String get tourReleasesText =>
      'Les prochains tomes de tes séries, les extensions de tes jeux de cartes et les nouveaux albums de tes artistes.';

  @override
  String get releasesAlreadyOut => 'Déjà sortis';

  @override
  String get addPreconDeck => 'Ajouter un deck préconstruit';

  @override
  String get searchPreconDeck => 'Nom, extension ou type de deck';

  @override
  String get noPreconDeckFound => 'Aucun deck préconstruit ne correspond.';

  @override
  String preconDeckAdded(int count, String deck) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count cartes ajoutées depuis $deck',
      one: '1 carte ajoutée depuis $deck',
    );
    return '$_temp0';
  }

  @override
  String get commanderDeckGroup => 'Deck commander';

  @override
  String get preconDeckGroup => 'Deck préconstruit';

  @override
  String get addToWhichSubcategory => 'Ajouter dans quelle sous-catégorie ?';

  @override
  String get deckHasNoCards => 'Ce deck ne contient encore aucune carte.';

  @override
  String get progressPlayedOnce => 'Joué';

  @override
  String get progressToBuild => 'À monter';

  @override
  String get progressBuilding => 'En montage';

  @override
  String get progressBuilt => 'Monté';

  @override
  String get savePhoto => 'Enregistrer dans la galerie';

  @override
  String get photoSaved => 'Photo enregistrée dans l’album Akashic.';

  @override
  String get photoNotSaved => 'La photo n’a pas pu être enregistrée.';

  @override
  String missingVolumeLabel(int number) {
    return 'Tome $number manquant';
  }

  @override
  String get ratingLabel => 'Note';

  @override
  String get notRated => 'Pas de note';

  @override
  String ratingValue(int stars) {
    return '$stars sur 5';
  }

  @override
  String get removeOneCard => 'Retirer un exemplaire de la carte';

  @override
  String get addOneCard => 'Ajouter un exemplaire de la carte';

  @override
  String get deleteCard => 'Supprimer la carte du deck';

  @override
  String photoNumber(int number) {
    return 'Photo $number';
  }

  @override
  String get incompleteSeries => 'Série incomplète';

  @override
  String get estimatedValue => 'Valeur estimée';

  @override
  String get estimatedValueExplanation =>
      'Estimation basse : cote Discogs la plus basse pour les vinyles, prix des cartes pour les decks, sinon prix payé.';

  @override
  String valuedItemsSummary(int market, int purchase, int unvalued) {
    return '$market cotés · $purchase au prix payé · $unvalued sans valeur';
  }

  @override
  String get updateMarketValues => 'Mettre à jour les cotes';

  @override
  String updatingMarketValues(int done, int total) {
    return 'Mise à jour des cotes… $done/$total';
  }

  @override
  String marketValuedOn(String date) {
    return 'Cotes du $date';
  }

  @override
  String get marketValuesIncomplete =>
      'Mise à jour interrompue par la limite de requêtes, réessaie plus tard.';

  @override
  String get valueByCategory => 'Valeur par catégorie';

  @override
  String get duplicatesTitle => 'Doublons';

  @override
  String duplicatesCount(int count) {
    return 'Doublons ($count)';
  }

  @override
  String get sameWorkSection => 'Même œuvre ajoutée plusieurs fois';

  @override
  String get noDuplicates => 'Aucun doublon';

  @override
  String get searchLoans => 'Rechercher un titre ou un emprunteur';

  @override
  String get noLoanMatches => 'Aucun prêt ne correspond.';

  @override
  String get additionsByYear => 'Ajouts par année';

  @override
  String get seriesCompletionTitle => 'Séries complètes';

  @override
  String seriesCompletionSummary(int complete, int total) {
    return '$complete sur $total séries complètes';
  }

  @override
  String categoryShare(String category, int percent) {
    return '$category $percent %';
  }

  @override
  String yearAdditions(String year, int count) {
    return '$year : $count ajouts';
  }

  @override
  String estimatedReleaseAround(String date) {
    return 'estimation : vers $date';
  }

  @override
  String get estimateBadge => 'Estimation';

  @override
  String get wishedRelease => 'Dans tes envies';

  @override
  String wishedReleaseOutTitle(String title) {
    return '$title est sorti';
  }

  @override
  String wishedReleaseOutBody(String subject) {
    return 'Le tome de $subject que tu attendais est disponible.';
  }

  @override
  String volumeOwnedLabel(int number) {
    return 'Tome $number, possédé';
  }

  @override
  String volumeMissingLabel(int number) {
    return 'Tome $number, manquant';
  }

  @override
  String volumeUnreleasedLabel(int number) {
    return 'Tome $number, pas encore sorti';
  }

  @override
  String paletteColorName(String index) {
    String _temp0 = intl.Intl.selectLogic(index, {
      '0': 'Bleu',
      '1': 'Rose',
      '2': 'Vert',
      '3': 'Turquoise',
      '4': 'Violet',
      '5': 'Orange',
      '6': 'Jaune',
      'other': 'Lavande',
    });
    return '$_temp0';
  }

  @override
  String cardsWithoutTraits(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count cartes sans type ni couleur',
      one: '1 carte sans type ni couleur',
    );
    return '$_temp0';
  }

  @override
  String get fetchCardTraits => 'Récupérer';

  @override
  String get cardFamilyCreature => 'Créatures';

  @override
  String get cardFamilyPlaneswalker => 'Planeswalkers';

  @override
  String get cardFamilyBattle => 'Batailles';

  @override
  String get cardFamilyInstant => 'Éphémères';

  @override
  String get cardFamilySorcery => 'Rituels';

  @override
  String get cardFamilyArtifact => 'Artefacts';

  @override
  String get cardFamilyEnchantment => 'Enchantements';

  @override
  String get cardFamilyLand => 'Terrains';

  @override
  String get cardFamilyOther => 'Autres';

  @override
  String get manaWhite => 'blanc';

  @override
  String get manaBlue => 'bleu';

  @override
  String get manaBlack => 'noir';

  @override
  String get manaRed => 'rouge';

  @override
  String get manaGreen => 'vert';

  @override
  String get colorIdentityTitle => 'Identité couleur';

  @override
  String colorIdentityLabel(String colors) {
    return 'Identité couleur : $colors';
  }

  @override
  String get manaCurveTitle => 'Courbe de mana';

  @override
  String manaCurveSummary(String average) {
    return 'Courbe de mana · moyenne $average';
  }

  @override
  String manaCurveEntry(String cost, int count) {
    return 'coût $cost : $count';
  }

  @override
  String get commanderRulesTitle => 'Règles Commander';

  @override
  String get noCommanderChosen => 'Aucun commandant désigné';

  @override
  String get chooseCommander => 'Choisir le commandant';

  @override
  String commanderRuleSize(int count) {
    return '100 cartes exactement (actuellement $count)';
  }

  @override
  String get commanderRuleCommander => 'Un commandant désigné';

  @override
  String get commanderRuleSingleton =>
      'Un seul exemplaire de chaque carte, hors terrains de base';

  @override
  String commanderRuleDuplicates(String names) {
    return 'En plusieurs exemplaires : $names';
  }

  @override
  String get commanderRuleIdentity =>
      'Toutes les cartes dans l’identité couleur du commandant';

  @override
  String commanderRuleOutsideIdentity(String names) {
    return 'Hors de l’identité couleur : $names';
  }

  @override
  String get commanderRuleIdentityUnknown =>
      'Identité couleur à vérifier : désigne un commandant et récupère les couleurs des cartes';

  @override
  String get ruleMet => 'Respectée';

  @override
  String get ruleNotMet => 'Non respectée';

  @override
  String get ruleUnknown => 'À vérifier';

  @override
  String get photographShelf =>
      'Photographier une étagère (plusieurs objets d’un coup)';

  @override
  String get shelfBeingRead => 'Lecture des tranches…';

  @override
  String get deckCardsTab => 'Cartes';

  @override
  String get deckAnalysisTab => 'Analyse';

  @override
  String get primaryCommander => 'Principal';

  @override
  String get secondaryCommander => 'Secondaire';

  @override
  String primaryCommanderIs(String name) {
    return 'Commandant principal : $name';
  }

  @override
  String secondaryCommanderIs(String name) {
    return 'Commandant secondaire : $name';
  }

  @override
  String get swapCommanders => 'Alterner principal et secondaire';

  @override
  String get commanderCandidatesNeedTraits =>
      'Seules les créatures légendaires sont proposées. Récupère d’abord les types des cartes pour toutes les voir.';

  @override
  String get noLegendaryCreature => 'Aucune créature légendaire dans ce deck.';

  @override
  String get accountImportTitle => 'Importer depuis un compte';

  @override
  String get accountImportSubtitle =>
      'Steam, itch.io, Trakt, AniList, MyAnimeList, Open Library, BoardGameGeek, Rebrickable, Playnite';

  @override
  String get steamImportExplanation =>
      'Ajoute tous les jeux de ta bibliothèque Steam. Les détails des jeux de ton profil doivent être publics (Steam › Profil › Modifier › Confidentialité).';

  @override
  String get traktImportExplanation =>
      'Ajoute les films et séries de ta collection Trakt (ce que tu possèdes). Ton profil Trakt doit être public.';

  @override
  String get anilistImportExplanation =>
      'Ajoute les mangas de ta liste AniList, avec ta progression (en cours, lu, abandonné). C’est ta liste de lecture : retire ensuite ce que tu ne possèdes pas.';

  @override
  String get openLibraryImportExplanation =>
      'Ajoute les livres de tes étagères Open Library (lus, en cours, à lire) avec ta progression. Ton journal de lecture doit être public.';

  @override
  String get accountNameLabel => 'Pseudo du compte';

  @override
  String get accountNameHint => 'Ton pseudo sur le site';

  @override
  String get steamAccountHint => 'steamcommunity.com/id/… ou SteamID';

  @override
  String accountImportNeedsKey(String service) {
    return '$service n’est pas configuré : il manque sa clé d’API dans le build.';
  }

  @override
  String get accountImportNeedsCategory =>
      'Crée d’abord une catégorie de ce type pour y ranger l’import.';

  @override
  String get accountImportReading => 'Lecture de la bibliothèque…';

  @override
  String accountNotFound(String service) {
    return 'Compte $service introuvable ou privé.';
  }

  @override
  String get playniteImportExplanation =>
      'Playnite (PC) regroupe Steam, Epic, GOG, Ubisoft Connect, EA, Battle.net, Amazon, Xbox… Installe l’extension « Library Exporter Advanced », coche Développeurs, Plateformes, Source et Date de sortie, puis exporte toute la bibliothèque en CSV. Copie le fichier sur ton téléphone et choisis-le ici. Chaque jeu est cherché sur IGDB pour sa jaquette ; le launcher devient son édition.';

  @override
  String get chooseExportFile => 'Choisir l’export CSV';

  @override
  String get exportFileUnreadable =>
      'Ce fichier ne se lit pas comme un export Playnite.';

  @override
  String get boardGameGeekImportExplanation =>
      'Ajoute les jeux marqués « possédés » de ta collection BoardGameGeek, extensions comprises. BGG prépare parfois la collection avant de la donner : l’import patiente quelques secondes.';

  @override
  String get itchIoImportExplanation =>
      'Ajoute les jeux achetés ou réclamés sur ton compte itch.io. Crée une clé sur itch.io › Paramètres › Clés d’API et colle-la ici : elle n’est utilisée que pour cet import et n’est pas gardée.';

  @override
  String get myAnimeListImportExplanation =>
      'Ajoute les mangas de ta liste MyAnimeList, avec ta progression (en cours, lu, abandonné). C’est ta liste de lecture : retire ensuite ce que tu ne possèdes pas.';

  @override
  String get rebrickableImportExplanation =>
      'Ajoute les sets LEGO de ta collection Rebrickable. Ton mot de passe sert une seule fois à obtenir l’accès à ta collection : il n’est ni gardé ni envoyé ailleurs qu’à Rebrickable.';

  @override
  String get personalApiKeyLabel => 'Ta clé d’API personnelle';

  @override
  String get personalApiKeyHint => 'Collée depuis les paramètres du site';

  @override
  String get accountPasswordLabel => 'Mot de passe';

  @override
  String get accountPasswordNotKept => 'Utilisé une fois, jamais enregistré';

  @override
  String get importDeckList => 'Importer un deck depuis Archidekt';

  @override
  String get deckListLink => 'Lien du deck';

  @override
  String get deckListNotFound =>
      'Deck introuvable : vérifie le lien et que le deck est public.';

  @override
  String get accountImportTarget => 'Ranger dans';

  @override
  String get steamAccountLabel => 'Lien de ton profil Steam ou SteamID';

  @override
  String get steamAccountHelper =>
      'Steam › ton profil › clic droit sur la page › Copier l’adresse. Ton pseudo affiché ne marche pas : seul le nom de l’adresse (steamcommunity.com/id/…) ou le numéro (…/profiles/7656…) est reconnu.';

  @override
  String steamProfileNotFound(String name) {
    return 'Aucun profil Steam n’a l’adresse « $name ». Colle le lien de ton profil (Steam › ton profil › Copier l’adresse) : ton pseudo affiché n’est pas l’adresse.';
  }

  @override
  String get steamLibraryPrivate =>
      'Profil trouvé, mais la liste de tes jeux est privée. Steam › Profil › Modifier le profil › Paramètres de confidentialité › « Détails des jeux » : Public.';

  @override
  String libraryPrivate(String service) {
    return 'Compte $service trouvé, mais sa bibliothèque est privée.';
  }

  @override
  String get keepAccountSynced => 'Synchroniser automatiquement';

  @override
  String get keepAccountSyncedExplanation =>
      'Les nouveaux ajouts sur ce compte arrivent tout seuls dans Akashic (au lancement, toutes les 6 h au plus). Ce que tu supprimes ici ne revient pas.';

  @override
  String get linkedAccountsTitle => 'Comptes synchronisés';

  @override
  String lastSyncedAt(String date) {
    return 'synchronisé le $date';
  }

  @override
  String get syncNow => 'Synchroniser maintenant';

  @override
  String get stopSyncing => 'Arrêter la synchronisation';

  @override
  String get rarityCommon => 'Commun';

  @override
  String get rarityRare => 'Rare';

  @override
  String get rarityEpic => 'Épique';

  @override
  String get rarityLegendary => 'Légendaire';

  @override
  String get achievementsTab => 'Succès';

  @override
  String get achievementsAll => 'Tous';

  @override
  String get achievementsUnlocked => 'Débloqués';

  @override
  String get achievementsLocked => 'À débloquer';

  @override
  String get achievementsRare => 'Rares';

  @override
  String achievementsSummary(int unlocked, int total, int percent) {
    return '$unlocked succès débloqués sur $total, $percent %';
  }

  @override
  String achievementsRemaining(int remaining, int legendary) {
    String _temp0 = intl.Intl.pluralLogic(
      remaining,
      locale: localeName,
      other: '$remaining restants',
      one: '1 restant',
      zero: 'Tous les succès sont débloqués',
    );
    String _temp1 = intl.Intl.pluralLogic(
      legendary,
      locale: localeName,
      other: ', dont $legendary légendaires',
      one: ', dont 1 légendaire',
      zero: '',
    );
    return '$_temp0$_temp1';
  }

  @override
  String achievementPlayersPercent(String percent) {
    return 'débloqué par $percent % des joueurs';
  }

  @override
  String achievementUnlockedOn(String date) {
    return 'Débloqué le $date';
  }

  @override
  String get achievementLocked => 'À débloquer';

  @override
  String get hiddenAchievement => 'Succès caché';

  @override
  String get steamAchievementsNeedAccount =>
      'Connecte ton compte Steam (Réglages › Importer depuis un compte) pour voir tes succès.';

  @override
  String get steamAchievementsUnavailable =>
      'Steam ne répond pas pour l’instant.';

  @override
  String get steamNoAchievements => 'Ce jeu n’a pas de succès Steam.';

  @override
  String achievementsListCaption(
    int count,
    String lockedFirst,
    String sortLabel,
  ) {
    String _temp0 = intl.Intl.selectLogic(lockedFirst, {
      'yes': ' · à débloquer d’abord',
      'other': '',
    });
    return '$count succès$_temp0 · tri par $sortLabel';
  }

  @override
  String get achievementSortRarity => 'rareté';

  @override
  String get achievementSortDate => 'date';

  @override
  String get achievementSortName => 'nom';

  @override
  String get retry => 'Réessayer';

  @override
  String get steamStorePageMissing =>
      'Steam n’a pas de fiche pour ce jeu dans ta région.';

  @override
  String get steamNewsTitle => 'Actualités';

  @override
  String get steamDlcTitle => 'Contenus additionnels';

  @override
  String get steamDlcOwnershipNote =>
      'Steam ne dit pas quels DLC tu possèdes : seuls ceux rangés dans ta collection Akashic sont signalés.';

  @override
  String get steamAboutTitle => 'À propos';

  @override
  String get steamDeveloper => 'Développeur';

  @override
  String get steamPublisher => 'Éditeur';

  @override
  String get steamReleaseDate => 'Sortie';

  @override
  String get steamMediaTitle => 'Captures et bande-annonce';

  @override
  String get steamTrailer => 'Bande-annonce, s’ouvre sur Steam';

  @override
  String steamScreenshot(int number) {
    return 'Capture $number';
  }

  @override
  String get steamFeaturesTitle => 'Modes et fonctions';

  @override
  String get steamLanguagesTitle => 'Langues';

  @override
  String get steamRequirementsTitle => 'Configuration requise';

  @override
  String get steamOpenStore => 'Voir sur Steam';

  @override
  String get steamFree => 'Gratuit';

  @override
  String get steamNoPrice => 'Prix non communiqué';

  @override
  String steamPriceBefore(String price) {
    return 'au lieu de $price';
  }

  @override
  String get steamPriceToday => 'Prix du jour sur Steam';

  @override
  String get steamDlcInCollection => 'Dans ta collection';

  @override
  String steamComingOn(String date) {
    return 'Sortie : $date';
  }

  @override
  String get steamDlcWished => 'Ajouté à tes envies';

  @override
  String get steamWishAction => 'Envie';

  @override
  String get steamPlaytime => 'Temps de jeu';

  @override
  String steamPlaytimeSummary(String total, String recent) {
    return 'Temps de jeu : $total au total, $recent ces 14 derniers jours';
  }

  @override
  String steamRecentPlaytime(String duration) {
    return '$duration ces 14 derniers jours';
  }

  @override
  String get steamNotPlayedRecently => 'Pas joué ces 14 derniers jours';

  @override
  String steamLastPlayed(String date) {
    return 'Dernière partie le $date';
  }

  @override
  String get steamNeverPlayed => 'Jamais lancé';

  @override
  String get steamStatus => 'Statut';

  @override
  String get steamNoStatus => 'Aucun';

  @override
  String steamStatusChange(String status) {
    return 'Statut : $status. Toucher pour passer au suivant.';
  }

  @override
  String get steamStatusAutomatic => 'auto · Steam';

  @override
  String get steamStatusManual => 'choisi à la main';

  @override
  String get steamDeck => 'Steam Deck';

  @override
  String get steamDeckVerified => 'Vérifié';

  @override
  String get steamDeckPlayable => 'Jouable';

  @override
  String get steamDeckUnsupported => 'Non pris en charge';

  @override
  String get steamDeckUnknown => 'Inconnu';

  @override
  String get steamDeckVerifiedDetail => 'Manette, affichage et texte validés';

  @override
  String get steamDeckPlayableDetail => 'Quelques réglages à la main';

  @override
  String get steamDeckUnsupportedDetail => 'Ne fonctionne pas sur Steam Deck';

  @override
  String get steamDeckUnknownDetail => 'Pas encore évalué par Valve';

  @override
  String get steamMyCopy => 'Mon jeu';

  @override
  String get steamCopyPlatform => 'Plateforme';

  @override
  String get steamCopyPrice => 'Prix payé';

  @override
  String get steamCopyAdded => 'Ajouté le';

  @override
  String steamUpdatedAt(String date) {
    return 'Mis à jour depuis Steam le $date';
  }

  @override
  String get steamRarestAchievement => 'Le plus rare';

  @override
  String get steamNoRareAchievement => 'Aucun succès débloqué pour l’instant';

  @override
  String get steamStatsTitle => 'Jeux vidéo';

  @override
  String get steamTotalPlaytime => 'Temps de jeu';

  @override
  String steamGameCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count jeux Steam',
      one: '1 jeu Steam',
    );
    return '$_temp0';
  }

  @override
  String get steamAverageCompletion => 'Succès complétés';

  @override
  String get steamAverageCompletionCaption => 'en moyenne sur les jeux lancés';

  @override
  String get steamShelfOfShame => 'Pile de la honte';

  @override
  String steamNeverLaunchedCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count jeux jamais lancés',
      one: '1 jeu jamais lancé',
    );
    return '$_temp0';
  }

  @override
  String get steamTopPlayed => 'Les plus joués';

  @override
  String get steamLibraryValue => 'Valeur de la bibliothèque Steam';

  @override
  String get steamLibraryValueNote =>
      'au prix boutique Steam d’aujourd’hui, pas une valeur de revente';

  @override
  String steamPricesOf(String date) {
    return 'prix du $date';
  }

  @override
  String syncReading(String service) {
    return 'Synchronisation $service…';
  }

  @override
  String syncProgress(String service, int done, int total) {
    return 'Synchronisation $service · $done / $total';
  }

  @override
  String syncRefreshingDetails(String service) {
    return '$service · mise à jour des statistiques…';
  }

  @override
  String get cardKindSealed => 'Scellé';

  @override
  String get tradeHistory => 'Achats et ventes';

  @override
  String get tradeSpent => 'Dépensé';

  @override
  String get tradeEarned => 'Ventes';

  @override
  String get tradeMargin => 'Marge';

  @override
  String get tradeMarginCaption => 'sur les ventes au prix d\'achat connu';

  @override
  String get noTrades =>
      'Aucun achat ni vente pour l\'instant. Renseigne le prix payé d\'un objet, ou vends-en un depuis sa fiche.';

  @override
  String get tradePurchase => 'Achat';

  @override
  String get tradeSale => 'Vente';

  @override
  String get channelStore => 'En magasin';

  @override
  String get channelOnline => 'En ligne';

  @override
  String get sealedState => 'Scellé';

  @override
  String get openedState => 'Ouvert';

  @override
  String get productOpened => 'Produit ouvert';

  @override
  String marginOf(String amount) {
    return '$amount de marge';
  }

  @override
  String get purchaseDate => 'Date d\'achat';

  @override
  String get purchaseChannel => 'Acheté';

  @override
  String boughtOn(String when) {
    return 'Acheté le $when';
  }

  @override
  String get noDateSet => 'Non renseignée';

  @override
  String get sellCopy => 'Vendre';

  @override
  String get salePrice => 'Prix de vente';

  @override
  String get saleDate => 'Date de vente';

  @override
  String get saleChannel => 'Vendu';

  @override
  String get sell => 'Vendre';

  @override
  String get sellLastCopyExplanation =>
      'L\'objet quitte ta collection, la vente reste dans l\'historique.';

  @override
  String get clearPurchaseDate => 'Effacer la date d\'achat';

  @override
  String get sealedMarketPrice => 'Cote Cardmarket';

  @override
  String get sealedMarketPriceSealedOnly => 'Produit scellé';

  @override
  String get sealedPriceTrend => 'Tendance';

  @override
  String get sealedPriceLow => 'Plus bas';

  @override
  String get sealedPriceAverage => 'Moyenne des ventes';

  @override
  String get sealedPriceAverage1 => 'Moyenne 1 jour';

  @override
  String get sealedPriceAverage7 => 'Moyenne 7 jours';

  @override
  String get sealedPriceAverage30 => 'Moyenne 30 jours';

  @override
  String sealedPricedOn(String when) {
    return 'Prix du $when';
  }

  @override
  String get sealedPriceMissing =>
      'Pas encore de cote pour ce produit : mets les prix à jour.';

  @override
  String get sealedOpenedHasNoPrice =>
      'Cardmarket ne cote que le scellé : un produit ouvert n\'a pas de cote à part.';

  @override
  String get refreshSealedPrices => 'Mettre à jour les prix';

  @override
  String get meteredDownloadTitle => 'Données mobiles';

  @override
  String meteredDownloadBody(String size) {
    return 'Tu es en données mobiles. La mise à jour télécharge environ $size depuis Cardmarket. Continuer ?';
  }

  @override
  String get meteredDownloadUnknownSize =>
      'Tu es en données mobiles. La mise à jour télécharge le fichier des prix Cardmarket, environ 16 Mo par jeu. Continuer ?';

  @override
  String get continueAnyway => 'Continuer';

  @override
  String sealedPricesUpdated(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count prix mis à jour',
      one: '1 prix mis à jour',
      zero: 'Aucun prix trouvé',
    );
    return '$_temp0';
  }

  @override
  String get sealedPricesUnavailable =>
      'Cardmarket est injoignable pour l\'instant, réessaie plus tard.';

  @override
  String get scanModeBarcode => 'Code-barres';

  @override
  String get scanModeCover => 'Couverture';

  @override
  String get scanModeShelf => 'Étagère';

  @override
  String get scanHintBarcodeTitle => 'Vise le code-barres';

  @override
  String get scanHintBarcodeDetail => 'Lecture automatique, sans appuyer';

  @override
  String get scanHintCoverTitle => 'Cadre la pochette, puis appuie';

  @override
  String get scanHintCoverDetail => 'Un objet par photo';

  @override
  String get scanHintShelfTitle => 'Aligne les tranches dans le cadre';

  @override
  String get scanHintShelfDetail => 'Jusqu\'à 24 objets d\'un coup';

  @override
  String get continuousReading => 'Lecture en continu';

  @override
  String get scansPileHere => 'Tes scans s\'empileront ici';

  @override
  String get toAdd => 'à ajouter';

  @override
  String chainScannedCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count scannés',
      one: '1 scanné',
    );
    return '$_temp0';
  }

  @override
  String chainOwnedCount(int count) {
    return '$count déjà à toi';
  }

  @override
  String chainMissingCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count introuvables',
      one: '1 introuvable',
    );
    return '$_temp0';
  }

  @override
  String shelfSpinesRead(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count tranches lues',
      one: '1 tranche lue',
    );
    return '$_temp0';
  }

  @override
  String shelfSpinesSearching(int count) {
    return '$count en recherche';
  }

  @override
  String get chainGroupToAdd => 'À ajouter';

  @override
  String get chainGroupOwned => 'Déjà dans ta collection';

  @override
  String get chainGroupMissing => 'Non trouvés';

  @override
  String get chainSourceBarcode => 'Code-barres';

  @override
  String get chainSourceCover => 'Pochette';

  @override
  String get chainSourceShelf => 'Étagère';

  @override
  String get shelfUnreadableTitle => 'Aucune tranche lisible';

  @override
  String get shelfUnreadableHint =>
      'Rapproche-toi et aligne les tranches dans le cadre.';

  @override
  String get coverUnreadableHint =>
      'Reprends la photo, plus près et sans reflet.';

  @override
  String get showScannedList => 'Afficher la liste des scans';

  @override
  String get hideScannedList => 'Replier la liste des scans';

  @override
  String get addAnotherItem => 'J\'en ai un autre';

  @override
  String get anotherItemAdded => 'Ajouté une fois de plus';

  @override
  String get fillObjectDetails => 'Renseigner l\'achat, l\'état, le rangement';

  @override
  String itemCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count objets',
      one: '1 objet',
    );
    return '$_temp0';
  }

  @override
  String get wishOriginSteamWishlist => 'Liste de souhaits Steam';

  @override
  String get steamWishlistUnavailable =>
      'La liste de souhaits Steam n’a pas pu être lue : vérifie que ton profil et ta liste sont publics.';

  @override
  String get discoveriesSearchHint => 'Titre, auteur, objet de départ';

  @override
  String get filterNotWished => 'Hors envies';

  @override
  String get filterRecent => 'Récents';

  @override
  String get noFilteredDiscoveries =>
      'Aucune découverte ne correspond aux filtres.';

  @override
  String get resetFilters => 'Effacer les filtres';

  @override
  String get releasesSearchHint => 'Titre, série, artiste';

  @override
  String get filterConfirmedDates => 'Dates confirmées';

  @override
  String get filterWished => 'En envie';

  @override
  String get releaseKindCardSet => 'Extensions';

  @override
  String get releaseKindNextVolume => 'Tomes';

  @override
  String get releaseKindAlbum => 'Albums';

  @override
  String get noFilteredReleases => 'Aucune sortie ne correspond aux filtres.';

  @override
  String get stepSearch => 'Chercher';

  @override
  String get stepCheck => 'Vérifier';

  @override
  String get enterByHand => 'Saisir à la main';

  @override
  String addToNamedCategory(String category) {
    return 'Ajouter à $category';
  }

  @override
  String get moreDetails => 'Plus de détails';

  @override
  String get detailsSection => 'Détails';

  @override
  String get coverSection => 'Couverture';

  @override
  String volumeShort(int number) {
    return 'Tome $number';
  }

  @override
  String get searchResultsEmpty =>
      'Tape un titre, scanne un code-barres, ou saisis l\'objet à la main.';

  @override
  String get categoryTypeStepTitle => 'Que veux-tu ranger ?';

  @override
  String get categoryDetailsStepTitle => 'Détails de la catégorie';

  @override
  String get continueAction => 'Continuer';

  @override
  String get changeAction => 'Changer';

  @override
  String get categoryPreviewEmpty => 'Nouvelle catégorie';

  @override
  String get categoryTypeLabel => 'Type';

  @override
  String get categoryDangerZone => 'Supprimer la catégorie';

  @override
  String get categoryDangerZoneExplanation =>
      'Ses objets, séries et sous-catégories partent avec elle. C’est définitif.';

  @override
  String get exportSpreadsheet => 'Exporter en tableur (CSV)';

  @override
  String exportSpreadsheetDone(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count objets',
      one: '1 objet',
    );
    return 'Collection exportée : $_temp0.';
  }

  @override
  String get exportSpreadsheetFailed =>
      'L\'export n\'a pas pu être enregistré.';

  @override
  String get exportHeaders =>
      'Catégorie|Sous-catégorie|Titre|Auteur|Année|Éditeur|Série|Tome|Plateforme|Édition|Code-barres|Prix payé|Date d\'achat|Acheté|Emplacement|État|Note|Prêté à|Valeur estimée|Devise|Ajouté le';

  @override
  String get steamAlertsChannelName => 'Steam';

  @override
  String get steamAlertsChannelDescription =>
      'Promos et sorties de tes envies Steam, nouveaux DLC de tes jeux';

  @override
  String steamWishOnSaleTitle(String title) {
    return '$title est en promo';
  }

  @override
  String steamWishOnSaleBody(int percent, String price) {
    return '-$percent % : $price sur Steam';
  }

  @override
  String steamWishReleasedTitle(String title) {
    return '$title est sorti';
  }

  @override
  String get steamWishReleasedBody =>
      'Un jeu de tes envies est disponible sur Steam.';

  @override
  String steamNewDlcTitle(String title) {
    return 'Nouveau DLC pour $title';
  }

  @override
  String get steamNewDlcBodyUnnamed =>
      'Un nouveau contenu est disponible sur Steam.';

  @override
  String get steamWishComingSoon => 'À venir sur Steam';

  @override
  String get priceAlertsChannelName => 'Alertes de prix';

  @override
  String get priceAlertsChannelDescription =>
      'Quand la cote d\'un produit scellé franchit ton seuil';

  @override
  String priceAlertAboveTitle(String title) {
    return '$title dépasse ton seuil';
  }

  @override
  String priceAlertBelowTitle(String title) {
    return '$title passe sous ton seuil';
  }

  @override
  String priceAlertBody(String price, String threshold) {
    return 'Cote Cardmarket : $price (seuil $threshold)';
  }

  @override
  String get priceAlert => 'Alerte de prix';

  @override
  String get priceAlertAbove => 'Au-dessus de';

  @override
  String get priceAlertBelow => 'En dessous de';

  @override
  String get priceAlertThreshold => 'Seuil';

  @override
  String priceAlertSummary(String direction, String threshold) {
    return 'Alerte $direction $threshold';
  }

  @override
  String get removePriceAlert => 'Retirer l\'alerte';

  @override
  String get displaySection => 'Affichage';

  @override
  String get highContrast => 'Contraste élevé';

  @override
  String get highContrastExplanation =>
      'Textes plus clairs et bordures plus visibles, pratique dehors ou en boutique.';

  @override
  String get recentSearches => 'Recherches récentes';

  @override
  String get forgetSearch => 'Retirer cette recherche';

  @override
  String get searchOnlineAction => 'Chercher en ligne';

  @override
  String get sortByPricePaid => 'Prix payé';

  @override
  String get sortByLocation => 'Emplacement';

  @override
  String get filterLent => 'Prêté';

  @override
  String get filtersTitle => 'Filtres';

  @override
  String get clearArrangement => 'Effacer le tri et les filtres';

  @override
  String get valueOverTime => 'Valeur dans le temps';

  @override
  String get lastSixMonths => '6 mois';

  @override
  String get lastYear => '1 an';

  @override
  String get wholeHistory => 'Tout';

  @override
  String get valueHistoryFilling =>
      'La courbe se remplit mois après mois : la valeur de la collection est relevée au début de chaque mois.';

  @override
  String get valueHistoryNote =>
      'Cotes Cardmarket, Steam et cartes, relevées au début de chaque mois.';

  @override
  String get biggestRises => 'Plus fortes hausses';

  @override
  String get biggestFalls => 'Plus fortes baisses';

  @override
  String get missingVolumesTitle => 'Tomes manquants';

  @override
  String get noMissingVolumes =>
      'Toutes tes séries sont complètes jusqu\'au dernier tome paru.';

  @override
  String get youAreMissing => 'Il te manque';

  @override
  String volumesInSeries(int volumes, int series) {
    String _temp0 = intl.Intl.pluralLogic(
      volumes,
      locale: localeName,
      other: 'tomes',
      one: 'tome',
    );
    String _temp1 = intl.Intl.pluralLogic(
      series,
      locale: localeName,
      other: '$series séries',
      one: '1 série',
    );
    return '$_temp0 dans $_temp1';
  }

  @override
  String wishAllMissing(int count) {
    return 'Tout ajouter à mes envies ($count)';
  }

  @override
  String missingVolumesWished(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count tomes ajoutés à tes envies',
      one: '1 tome ajouté à tes envies',
      zero: 'Rien de nouveau dans tes envies',
    );
    return '$_temp0';
  }

  @override
  String ownedVolumesRun(int from, int to) {
    return 'Tomes $from à $to : possédés';
  }

  @override
  String wishedVolumesRun(int from, int to) {
    return 'Tomes $from à $to : dans tes envies';
  }

  @override
  String missingVolumesRun(int from, int to) {
    return 'Tomes $from à $to : manquants, touche pour les mettre en envie';
  }

  @override
  String ownedVolume(int number) {
    return 'Tome $number : possédé';
  }

  @override
  String wishedVolume(int number) {
    return 'Tome $number : dans tes envies';
  }

  @override
  String missingVolume(int number) {
    return 'Tome $number : manquant, touche pour le mettre en envie';
  }

  @override
  String get shelfRead => 'Étagère lue';

  @override
  String get shelfPhotoGone =>
      'La photo de cette étagère n\'est plus disponible.';

  @override
  String get tapFrameToFindLine => 'Touche un cadre pour retrouver sa ligne.';

  @override
  String get seeShelf => 'Voir l\'étagère';

  @override
  String get scanHistory => 'Historique des scans';

  @override
  String get noScanSessions => 'Tes sessions de scan apparaîtront ici.';

  @override
  String scanAddedCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ajoutés',
      one: '1 ajouté',
    );
    return '$_temp0';
  }

  @override
  String get scanGroupAdded => 'Ajoutés';

  @override
  String get scanGroupOwned => 'Déjà à toi';

  @override
  String get scanGroupMissed => 'Introuvables';

  @override
  String get saveFailedRetry => 'L\'enregistrement a échoué. Réessaie.';

  @override
  String get selectItem => 'Sélectionner';

  @override
  String get unselectItem => 'Désélectionner';

  @override
  String scanResultAnnouncement(String title, String status) {
    return '$title : $status';
  }

  @override
  String webImageNumber(int number) {
    return 'Image web $number';
  }

  @override
  String valueChartSummary(
    String first,
    String last,
    String lowest,
    String highest,
  ) {
    return 'Courbe de valeur : de $first à $last, au plus bas $lowest, au plus haut $highest. Glisse vers le haut ou le bas pour changer de mois.';
  }

  @override
  String get loadingInProgress => 'Chargement en cours';

  @override
  String get goalAllCategories => 'toute la collection';

  @override
  String goalFinishLabel(int target, String scope) {
    return 'Finir $target · $scope';
  }

  @override
  String goalAddLabel(int target, String scope) {
    return 'Ajouter $target · $scope';
  }

  @override
  String get goalReached => 'Objectif atteint';

  @override
  String goalAhead(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count d\'avance',
      one: '1 d\'avance',
    );
    return '$_temp0';
  }

  @override
  String goalBehind(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count de retard',
      one: '1 de retard',
    );
    return '$_temp0';
  }

  @override
  String get goalOnPace => 'Pile dans le rythme';

  @override
  String goalsOfYear(int year) {
    return 'Objectifs $year';
  }

  @override
  String get noGoalsYet =>
      'Fixe-toi un objectif pour l\'année : finir des livres, des jeux, compléter tes étagères.';

  @override
  String get newGoal => 'Nouvel objectif';

  @override
  String get deleteGoal => 'Supprimer l\'objectif';

  @override
  String goalBarLabel(int done, int target, int expected) {
    return '$done sur $target, il en faudrait $expected aujourd\'hui';
  }

  @override
  String goalProjection(int count) {
    return 'Au rythme actuel : $count fin décembre';
  }

  @override
  String get goalMeasureFinished => 'Finir';

  @override
  String get goalMeasureAdded => 'Ajouter';

  @override
  String get goalCategory => 'Catégorie';

  @override
  String get goalTarget => 'Combien sur l\'année';

  @override
  String get decrease => 'Moins';

  @override
  String get increase => 'Plus';

  @override
  String get createGoal => 'Créer l\'objectif';

  @override
  String get tonightTitle => 'Ce soir, je…';

  @override
  String get tonightAny => 'Tout';

  @override
  String get tonightRead => 'Lire';

  @override
  String get tonightPlay => 'Jouer';

  @override
  String get tonightWatch => 'Voir';

  @override
  String get tonightListen => 'Écouter';

  @override
  String get tonightAnyLength => 'Peu importe';

  @override
  String get tonightShort => 'Court';

  @override
  String get tonightMedium => 'Moyen';

  @override
  String get tonightLong => 'Long';

  @override
  String get tonightAnother => 'Un autre';

  @override
  String get tonightStart => 'Je commence';

  @override
  String tonightStarted(String title) {
    return '« $title » est en cours.';
  }

  @override
  String get tonightNothingWaiting =>
      'Rien ne t\'attend : tout est commencé ou fini.';

  @override
  String get tonightNothingMatches =>
      'Rien ne correspond à ces filtres. Élargis la durée ou l\'activité.';

  @override
  String tonightWaitingSince(int months) {
    String _temp0 = intl.Intl.pluralLogic(
      months,
      locale: localeName,
      other: 'attend depuis $months mois',
      one: 'attend depuis 1 mois',
    );
    return '$_temp0';
  }

  @override
  String get monthlyRecap => 'Récap du mois';

  @override
  String get previousMonth => 'Mois précédent';

  @override
  String get nextMonth => 'Mois suivant';

  @override
  String get recapEmptyMonth => 'Rien d\'ajouté ni de fini ce mois-là.';

  @override
  String yearRecapOf(int year) {
    return 'Bilan $year';
  }

  @override
  String get recapAdded => 'Ajoutés';

  @override
  String get recapSpent => 'Dépensés';

  @override
  String get recapFinished => 'Finis';

  @override
  String get recapSeriesCompleted => 'Séries complétées';

  @override
  String get recapMostValued => 'Le plus coté';

  @override
  String get recapValueChange => 'Valeur';

  @override
  String get recapBusiestMonth => 'Mois le plus actif';

  @override
  String get recapTopValued => 'Les plus cotés de l\'année';

  @override
  String get shareImage => 'Partager l\'image';

  @override
  String get tonightMenu => 'Ce soir, je…';

  @override
  String get goalsMenu => 'Objectifs';

  @override
  String get tagsTitle => 'Étiquettes';

  @override
  String get saveFilterAsShelf => 'Enregistrer ce filtre comme étagère';

  @override
  String get saveFilterAsShelfHint =>
      'Elle apparaîtra en tête de l\'accueil et se remplira seule.';

  @override
  String get smartShelfName => 'Nom de l\'étagère';

  @override
  String smartShelfSaved(String name) {
    return 'Étagère « $name » ajoutée à l\'accueil.';
  }

  @override
  String smartShelfLabel(String name, int count) {
    return 'Étagère intelligente $name, $count objets';
  }

  @override
  String get smartShelfEmpty =>
      'Rien ne correspond à ce filtre pour l\'instant.';

  @override
  String get deleteSmartShelf => 'Supprimer l\'étagère';

  @override
  String get tagSigned => 'dédicacé';

  @override
  String get tagToSell => 'à revendre';

  @override
  String get tagGift => 'cadeau';

  @override
  String get tagToReread => 'à relire';

  @override
  String get tagLimitedEdition => 'édition limitée';

  @override
  String get newTag => 'Nouvelle étiquette';

  @override
  String get tagName => 'Nom de l\'étiquette';

  @override
  String removeTag(String tag) {
    return 'Retirer l\'étiquette $tag';
  }

  @override
  String addTag(String tag) {
    return 'Ajouter l\'étiquette $tag';
  }

  @override
  String get storagePlan => 'Plan de rangement';

  @override
  String get storagePlanHint =>
      'Pièces, meubles et étagères : choisis ensuite l\'emplacement d\'un objet en deux touches.';

  @override
  String get storagePlanEmpty =>
      'Commence par une pièce, par exemple « Salon ».';

  @override
  String get newRoom => 'Nouvelle pièce';

  @override
  String get newFurniture => 'Nouveau meuble';

  @override
  String get newShelf => 'Nouvelle étagère';

  @override
  String get renamePlace => 'Renommer';

  @override
  String get deletePlace => 'Supprimer';

  @override
  String get placeName => 'Nom';

  @override
  String get placeNameHint => 'Salon, Bibliothèque, Étagère 3…';

  @override
  String placeItemCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count objets',
      one: '1 objet',
      zero: 'Vide',
    );
    return '$_temp0';
  }

  @override
  String placeActions(String name) {
    return 'Actions pour $name';
  }

  @override
  String placeChildren(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count emplacements',
      one: '1 emplacement',
    );
    return '$_temp0';
  }

  @override
  String get chooseStoragePlace => 'Choisir dans le plan';

  @override
  String get goUp => 'Remonter';

  @override
  String get storeHere => 'Ranger ici';

  @override
  String get whereIs => 'Où est… ?';

  @override
  String get whereIsHint => 'Titre ou auteur';

  @override
  String get whereIsNothing => 'Rien dans ta collection ne porte ce nom.';

  @override
  String lentToBorrower(String name) {
    return 'Chez $name';
  }

  @override
  String get notStoredYet =>
      'Pas encore rangé : ouvre la fiche pour choisir un emplacement';

  @override
  String get journal => 'Journal';

  @override
  String get journalAdded => 'Ajouts';

  @override
  String get journalSales => 'Ventes';

  @override
  String get journalLoans => 'Prêts';

  @override
  String get journalValues => 'Cotes';

  @override
  String get journalFinished => 'Finis';

  @override
  String get journalEmpty => 'Rien à raconter pour l\'instant.';

  @override
  String get today => 'Aujourd\'hui';

  @override
  String get yesterday => 'Hier';

  @override
  String get journalEntryAdded => 'Ajouté à la collection';

  @override
  String get journalEntryReceived => 'Précommande reçue';

  @override
  String get journalEntryStarted => 'Commencé';

  @override
  String get journalEntryFinished => 'Fini';

  @override
  String journalEntrySold(String amount) {
    return 'Vendu $amount';
  }

  @override
  String journalEntryLent(String name) {
    return 'Prêté à $name';
  }

  @override
  String journalEntryReturned(String name) {
    return 'Rendu par $name';
  }

  @override
  String journalEntryValueRose(String amount) {
    return 'Cote en hausse de $amount';
  }

  @override
  String journalEntryValueFell(String amount) {
    return 'Cote en baisse de $amount';
  }

  @override
  String get journalEntryMerged => 'Doublons fusionnés';

  @override
  String wishUnderMaximumTitle(String title) {
    return '$title passe sous ton maximum';
  }

  @override
  String wishUnderMaximumBody(String price, String maximum) {
    return '$price aujourd\'hui, ton maximum était $maximum.';
  }

  @override
  String get wishPriorityMustHave => 'Indispensable';

  @override
  String get wishPriorityWant => 'Envie';

  @override
  String get wishPrioritySomeday => 'Un jour';

  @override
  String get wishPriority => 'Priorité';

  @override
  String get wishMaximumLabel => 'Prix maximum';

  @override
  String get wishMaximumHelp =>
      'Une alerte quand la cote ou une promo Steam passe dessous.';

  @override
  String wishMaximumPrice(String price) {
    return 'Max $price';
  }

  @override
  String wishUnderYourMaximum(String price) {
    return 'Sous ton max de $price';
  }

  @override
  String get shareAsImage => 'Image';

  @override
  String get shareAsPdf => 'PDF';

  @override
  String get shareAsText => 'Partager en texte';

  @override
  String get wishlistColumnWish => 'Envie';

  @override
  String get wishlistColumnType => 'Type';

  @override
  String get budget => 'Budget';

  @override
  String get budgetAlertTitle => 'Budget du mois presque atteint';

  @override
  String budgetAlertBody(String remaining, String ceiling) {
    return 'Plus que $remaining sur $ceiling ce mois-ci.';
  }

  @override
  String budgetOverBody(String ceiling) {
    return 'Le plafond de $ceiling est dépassé ce mois-ci.';
  }

  @override
  String get budgetChannelName => 'Budget';

  @override
  String get budgetChannelDescription =>
      'Prévient quand les dépenses du mois approchent du plafond.';

  @override
  String budgetLeft(String amount) {
    return 'reste $amount';
  }

  @override
  String budgetOverBy(String amount) {
    return 'Dépassé de $amount';
  }

  @override
  String budgetOnlyLeft(String amount, int days) {
    return 'Plus que $amount pour les $days jours qui restent';
  }

  @override
  String budgetDaysLeft(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'reste $days jours',
      one: 'reste 1 jour',
      zero: 'dernier jour',
    );
    return '$_temp0';
  }

  @override
  String budgetOutOf(String ceiling) {
    return 'sur $ceiling';
  }

  @override
  String budgetGaugeLabel(int percent, int alert) {
    return '$percent % du plafond dépensés, alerte à $alert %';
  }

  @override
  String get budgetNoCeiling =>
      'Fixe un plafond pour suivre le mois et être prévenu à l\'approche.';

  @override
  String get budgetSpendingOfMonth => 'Dépenses du mois';

  @override
  String get budgetNothingSpent => 'Aucun achat avec un prix ce mois-ci.';

  @override
  String get budgetCeiling => 'Plafond mensuel';

  @override
  String get budgetCeilingHelp => 'Remis à zéro le 1er de chaque mois';

  @override
  String get budgetNone => 'Aucun';

  @override
  String get budgetAlertAt => 'Me prévenir à';

  @override
  String get budgetAlertAtHelp => 'Une notification, une seule fois par mois';

  @override
  String get budgetCountSteam => 'Compter les jeux Steam';

  @override
  String get budgetCountSteamHelp =>
      'Prix d\'achat importés avec la bibliothèque';

  @override
  String get insuranceInventory => 'Inventaire assurance';

  @override
  String get insuranceNothing =>
      'Ajoute des objets pour pouvoir les inventorier.';

  @override
  String get insuranceIntro =>
      'Un PDF à garder ou à envoyer à ton assureur : chaque objet avec sa photo, son achat, sa valeur estimée et son emplacement.';

  @override
  String get insuranceCategories => 'Catégories à inclure';

  @override
  String insuranceCategoryLine(int count, String value) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count objets',
      one: '1 objet',
    );
    return '$_temp0 · $value';
  }

  @override
  String get insuranceWithPhotos => 'Avec les photos';

  @override
  String get insuranceWithPhotosHelp =>
      'Une vignette par objet, le fichier est plus lourd';

  @override
  String get insurancePreview => 'Aperçu';

  @override
  String insurancePages(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'environ $count pages',
      one: 'environ 1 page',
    );
    return '$_temp0';
  }

  @override
  String insuranceMoreLines(int count) {
    return 'et $count autres…';
  }

  @override
  String insuranceItemCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count objets',
      one: '1 objet',
    );
    return '$_temp0';
  }

  @override
  String insuranceEstimatedTotal(String amount) {
    return '$amount estimés';
  }

  @override
  String get insuranceGenerate => 'Générer le PDF';

  @override
  String get insuranceGenerating => 'Génération…';

  @override
  String get insuranceDocumentTitle => 'Inventaire de collection';

  @override
  String insuranceDocumentSubtitle(String date, int count) {
    return 'Établi le $date · $count objets · valeur estimée : cote, sinon prix d\'achat';
  }

  @override
  String get insuranceColumnItem => 'Objet';

  @override
  String get insuranceColumnBought => 'Achat';

  @override
  String get insuranceColumnPaid => 'Payé';

  @override
  String get insuranceColumnEstimated => 'Estimé';

  @override
  String get insuranceItems => 'Objets';

  @override
  String insuranceSubtotal(int count) {
    return 'Sous-total ($count)';
  }

  @override
  String get insuranceFooter =>
      'Valeurs en euros, cotes au jour de l\'export. Généré par Akashic.';

  @override
  String get notStoredYetShort => 'Sans emplacement';

  @override
  String get loanInOneWeek => '1 semaine';

  @override
  String get loanInTwoWeeks => '2 semaines';

  @override
  String get loanInOneMonth => '1 mois';

  @override
  String get loanNoDate => 'Sans date';

  @override
  String get loanPickDate => 'Autre date';

  @override
  String get loanReturnBy => 'À rendre';

  @override
  String loanDueOn(String date) {
    return 'Retour prévu le $date';
  }

  @override
  String get loanRemindAtDue => 'Me prévenir à l\'échéance';

  @override
  String get loanFollowUp => 'Puis relancer';

  @override
  String get loanFollowUpHelp =>
      'Une semaine après, s\'il n\'est toujours pas rendu';

  @override
  String get loansLate => 'En retard';

  @override
  String get loansOngoing => 'En cours';

  @override
  String loanLateBy(String name, int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days jours de retard',
      one: '1 jour de retard',
    );
    return 'Chez $name · $_temp0';
  }

  @override
  String loanDueBy(String name, String date) {
    return 'Chez $name · à rendre le $date';
  }

  @override
  String get calendarSync => 'Sorties dans l\'agenda';

  @override
  String get calendarSyncSwitch => 'Envoyer les sorties dans l\'agenda';

  @override
  String get calendarSyncSwitchHelp =>
      'Un événement sur la journée, modifiable depuis l\'agenda';

  @override
  String get calendarTarget => 'Calendrier';

  @override
  String get calendarDefaultName => 'Collection';

  @override
  String get calendarKinds => 'Types de sortie';

  @override
  String get calendarKindVolumes => 'Tomes';

  @override
  String get calendarKindAlbums => 'Albums';

  @override
  String get calendarKindCardSets => 'Extensions de cartes';

  @override
  String get calendarSubjects => 'Par série ou artiste';

  @override
  String get calendarEventSettings => 'Réglages de l\'événement';

  @override
  String get calendarReminder => 'Rappel la veille à 18 h';

  @override
  String get calendarRemovedWhenAdded =>
      'L\'événement est retiré quand l\'objet rejoint ta collection ou que la sortie disparaît.';

  @override
  String get calendarPreview => 'Aperçu dans l\'agenda';

  @override
  String get calendarNextSent => 'Prochaines sorties envoyées';

  @override
  String calendarEventTitle(String title) {
    return 'Sortie · $title';
  }

  @override
  String get calendarEventEstimated => 'Date estimée';

  @override
  String get calendarEventFooter => 'Ajouté par Akashic';

  @override
  String calendarAllDay(String date) {
    return '$date · toute la journée';
  }

  @override
  String get calendarAccessDenied =>
      'Sans accès à l\'agenda, les sorties ne peuvent pas y être ajoutées.';

  @override
  String get calendarSyncFailed => 'L\'agenda n\'a pas pu être mis à jour.';

  @override
  String get tabletPickAnItem =>
      'Choisis un objet à gauche pour voir sa fiche ici.';

  @override
  String get voiceSearch => 'Chercher à la voix';

  @override
  String get voiceListening => 'Je t\'écoute…';

  @override
  String get voiceUnavailable =>
      'La reconnaissance vocale n\'est pas disponible sur ce téléphone.';

  @override
  String get voiceTapToRetry => 'Touche le micro pour parler';

  @override
  String get voiceStop => 'Arrêter l\'écoute';

  @override
  String get voiceHint => 'Dis un titre, un auteur, un artiste…';

  @override
  String get voiceUseWords => 'Chercher ça';

  @override
  String get offline => 'Hors ligne';

  @override
  String get offlineExplained =>
      'Hors ligne : la collection reste consultable, les prix affichés sont ceux du dernier relevé.';

  @override
  String priceOn(String date) {
    return 'prix du $date';
  }

  @override
  String preorderArrivesTodayTitle(String title) {
    return 'Arrive aujourd\'hui : $title';
  }

  @override
  String preordersArriveTodayTitle(int count) {
    return '$count précommandes arrivent aujourd\'hui';
  }

  @override
  String get preorderArrivesTodayBody =>
      'Touche « Reçu » sur la fiche quand tu l\'as entre les mains.';

  @override
  String get preorderChannelName => 'Précommandes';

  @override
  String get preorderChannelDescription =>
      'Prévient le jour où une précommande doit arriver.';

  @override
  String get preorderToday => 'Aujourd\'hui';

  @override
  String preorderInDays(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'dans $days jours',
      one: 'dans 1 jour',
    );
    return '$_temp0';
  }

  @override
  String get preorderTitle => 'Précommande';

  @override
  String get preorderPickDate => 'Choisir la date de livraison';

  @override
  String preorderDeliveryOn(String date) {
    return 'Livraison prévue le $date';
  }

  @override
  String get preorderDeposit => 'Acompte versé (facultatif)';

  @override
  String preorderDepositPaid(String amount) {
    return 'Acompte : $amount';
  }

  @override
  String get markPreordered => 'Marquer comme précommandé';

  @override
  String get preordered => 'Précommandé';

  @override
  String get preorderReceived => 'Reçu';

  @override
  String get preorderChangeDate => 'Changer la date';

  @override
  String get preorderCancel => 'Ce n\'est plus une précommande';

  @override
  String get toReceive => 'À recevoir';

  @override
  String preorderDepositsTotal(String amount) {
    return '$amount d\'acomptes versés';
  }

  @override
  String get mergeTitle => 'Fusionner les doublons';

  @override
  String get mergeAction => 'Fusionner';

  @override
  String get mergeKeepWhat =>
      'Choisis ce que la fiche fusionnée garde, champ par champ.';

  @override
  String get mergeFieldTitle => 'Titre';

  @override
  String get mergeFieldCover => 'Couverture';

  @override
  String get mergeFieldPurchase => 'Achat, état et emplacement';

  @override
  String get mergeFieldRating => 'Note';

  @override
  String get mergeFieldProgress => 'Progression';

  @override
  String get mergeHasCover => 'Couverture présente';

  @override
  String get mergeHasProgress => 'Progression suivie';

  @override
  String get mergeEmpty => 'vide';

  @override
  String get mergeJoinPhotos => 'Réunir les photos des deux fiches';

  @override
  String mergeResult(String title) {
    return 'Résultat : $title';
  }

  @override
  String get mergeConfirmTitle => 'Fusionner ces deux fiches ?';

  @override
  String get mergeConfirmBody =>
      'La fiche B disparaît : ce que tu as choisi rejoint la fiche A.';

  @override
  String get mergeDone => 'Doublons fusionnés.';

  @override
  String get deckValue => 'Valeur du deck';

  @override
  String deckPricedCards(int priced, int total) {
    return '$priced cartes cotées sur $total';
  }

  @override
  String deckPricedOn(String date) {
    return 'cotes du $date';
  }

  @override
  String get deckPriciestCards => 'Les cartes les plus chères';

  @override
  String deckTopShare(int percent) {
    return 'Elles font $percent % de la valeur du deck.';
  }

  @override
  String trackSide(String side) {
    return 'Face $side';
  }

  @override
  String albumLength(String length) {
    return 'Durée totale : $length';
  }

  @override
  String get compareTitle => 'Comparer avec un ami';

  @override
  String get compareIntro =>
      'Demande-lui son export (Réglages › Exporter la collection) et ouvre le fichier ici.';

  @override
  String get compareNothingSent =>
      'Rien n\'est envoyé : la comparaison se fait sur ton téléphone.';

  @override
  String get compareChooseFile => 'Choisir son fichier';

  @override
  String get compareOtherFile => 'Un autre fichier';

  @override
  String get compareUnreadable =>
      'Ce fichier n\'a pas pu être lu. Il faut un export CSV ou XLSX.';

  @override
  String compareCounts(int mine, int theirs) {
    return 'Toi : $mine · Ton ami : $theirs';
  }

  @override
  String compareInCommon(int count) {
    return 'En commun · $count';
  }

  @override
  String compareOnlyFriend(int count) {
    return 'Il a · $count';
  }

  @override
  String compareOnlyMine(int count) {
    return 'Tu as · $count';
  }

  @override
  String compareExchangeIdeas(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count pistes d\'échange',
      one: '1 piste d\'échange',
    );
    return '$_temp0';
  }

  @override
  String get compareCopyList => 'Copier';

  @override
  String get compareCopied => 'Liste copiée.';

  @override
  String get compareNothingHere => 'Rien dans cet onglet.';

  @override
  String get compareFillsMissing => 'te manque';

  @override
  String get compareInWishes => 'dans tes envies';

  @override
  String get missingCovers => 'Couvertures manquantes';

  @override
  String get coverProposals => 'Propositions';

  @override
  String get noMissingCovers => 'Tous tes objets ont une couverture.';

  @override
  String itemsWithoutCover(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count objets sans couverture',
      one: '1 objet sans couverture',
    );
    return '$_temp0';
  }

  @override
  String searchCovers(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Chercher $count couvertures',
      one: 'Chercher 1 couverture',
    );
    return '$_temp0';
  }

  @override
  String acceptAllCovers(int count) {
    return 'Tout accepter · $count';
  }

  @override
  String coverSearchProgress(int done, int total, int accepted) {
    return 'Recherche : $done / $total · $accepted acceptées';
  }

  @override
  String get coverSearching => 'Recherche…';

  @override
  String get coverNothingFound => 'Rien trouvé';

  @override
  String get coverAccepted => 'Couverture ajoutée';

  @override
  String get coverRefused => 'Laissée de côté';

  @override
  String get coverAccept => 'Accepter';

  @override
  String get coverRefuse => 'Refuser';

  @override
  String get coverAnother => 'Autre image';
}
