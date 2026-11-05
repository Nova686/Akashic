// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get navCollection => 'Collection';

  @override
  String get navCheck => 'Got it?';

  @override
  String get navWishes => 'Wishes';

  @override
  String get navDiscoveries => 'Discoveries';

  @override
  String get untitled => 'Untitled';

  @override
  String get conditionMint => 'Mint';

  @override
  String get conditionVeryGood => 'Very good';

  @override
  String get conditionGood => 'Good';

  @override
  String get conditionFair => 'Fair';

  @override
  String get conditionDamaged => 'Damaged';

  @override
  String get conditionMissing => 'Missing';

  @override
  String get partDisc => 'Disc';

  @override
  String get partSleeve => 'Sleeve';

  @override
  String get partGame => 'Game';

  @override
  String get partBox => 'Box';

  @override
  String get partManual => 'Manual';

  @override
  String get partItem => 'Item';

  @override
  String get myCollection => 'My collection';

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
      other: '$objectsString items',
      one: '1 item',
    );
    String _temp1 = intl.Intl.pluralLogic(
      categories,
      locale: localeName,
      other: '$categoriesString categories',
      one: '1 category',
    );
    return '$_temp0 in $_temp1';
  }

  @override
  String get newCategory => 'New category';

  @override
  String get categoryName => 'Name';

  @override
  String get fillInfoFrom => 'Fill in info from';

  @override
  String get categoryTypeMusic => 'Music';

  @override
  String get categoryTypeBooks => 'Books';

  @override
  String get categoryTypeManga => 'Manga';

  @override
  String get categoryTypeComics => 'Comics';

  @override
  String get categoryTypeFilms => 'Films';

  @override
  String get categoryTypeVideoGames => 'Video games';

  @override
  String get categoryTypeCards => 'Cards';

  @override
  String get categoryTypeFree => 'Custom';

  @override
  String get subcategories => 'Subcategories';

  @override
  String get addSubcategory => 'Add a subcategory';

  @override
  String get subcategoryName => 'Subcategory name';

  @override
  String get conditionRatedOn => 'Condition rated on';

  @override
  String get addPart => 'Add a part';

  @override
  String get partName => 'Part name';

  @override
  String get createCategory => 'Create category';

  @override
  String get categoryNameRequired => 'Give the category a name.';

  @override
  String get close => 'Close';

  @override
  String get settings => 'Settings';

  @override
  String get appLanguage => 'App language';

  @override
  String get followDevice => 'Same as the phone';

  @override
  String get preferredTitleLanguages => 'Preferred title languages';

  @override
  String get preferredTitleLanguagesHint =>
      'Titles are shown in the first available language of this list.';

  @override
  String get addLanguage => 'Add a language';

  @override
  String get lastLanguageRefused => 'Keep at least one language.';

  @override
  String get languageFr => 'French';

  @override
  String get languageEn => 'English';

  @override
  String get languageJa => 'Japanese';

  @override
  String get languageEs => 'Spanish';

  @override
  String get languageDe => 'German';

  @override
  String get languageIt => 'Italian';

  @override
  String get languageKo => 'Korean';

  @override
  String get languageZh => 'Chinese';

  @override
  String get languagePt => 'Portuguese';

  @override
  String get addItem => 'Add an item';

  @override
  String get titles => 'Titles';

  @override
  String get originalLanguage => 'Original';

  @override
  String get creator => 'Artist or author';

  @override
  String get year => 'Year';

  @override
  String get publisher => 'Publisher or label';

  @override
  String get image => 'Image';

  @override
  String get imageFromInternet => 'On the internet';

  @override
  String get comingSoon => 'Coming soon';

  @override
  String get imageFromPhone => 'From my phone';

  @override
  String get takePhoto => 'Take a photo';

  @override
  String get chooseFromGallery => 'Choose from the gallery';

  @override
  String get spineColor => 'Spine color';

  @override
  String get partOfSeries => 'Part of a series';

  @override
  String get newSeries => 'New series';

  @override
  String get volumeFrom => 'From volume';

  @override
  String get volumeTo => 'To volume';

  @override
  String get volumeRangeInvalid => 'Check the volume numbers.';

  @override
  String get titleRequired => 'Give at least one title.';

  @override
  String get myRating => 'My rating';

  @override
  String get addToCollection => 'Add to my collection';

  @override
  String get edition => 'Edition';

  @override
  String get pricePaid => 'Price paid';

  @override
  String get storedAt => 'Stored at';

  @override
  String get condition => 'Condition';

  @override
  String get priceInvalid => 'Enter a price like 28.50.';

  @override
  String get save => 'Save';

  @override
  String get editCopy => 'Edit the details';

  @override
  String get searchCollection => 'Search my collection';

  @override
  String get allSubcategories => 'All';

  @override
  String get foldAll => 'Fold all';

  @override
  String get unfoldAll => 'Unfold all';

  @override
  String get addFirstItem => 'Add your first item';

  @override
  String get emptyShelf => 'Nothing on this shelf yet.';

  @override
  String get noSearchResults => 'Nothing found in your collection.';

  @override
  String get emptyCollection =>
      'Create your first category to start your shelves.';

  @override
  String seriesToComplete(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count series to complete',
      one: '1 series to complete',
    );
    return '$_temp0';
  }

  @override
  String get myInfo => 'My info';

  @override
  String get learnMore => 'Learn more';

  @override
  String get titleVariants => 'Title variants';

  @override
  String get myCopies => 'Purchase, condition and storage';

  @override
  String get copyWithoutDetails => 'No details yet';

  @override
  String partCondition(String part, String condition) {
    return '$part: $condition';
  }

  @override
  String get saveFailed => 'Saving failed. Check the category and try again.';

  @override
  String get photographCover => 'Photograph the cover';

  @override
  String get seeItem => 'See the item';

  @override
  String get checking => 'Checking…';

  @override
  String get searchOnline => 'Search online';

  @override
  String get webImages => 'Images found online';

  @override
  String get creatorArtist => 'Artist';

  @override
  String get creatorAuthor => 'Author';

  @override
  String get creatorDirector => 'Director';

  @override
  String get creatorStudio => 'Studio';

  @override
  String get publisherLabel => 'Label';

  @override
  String get publisherName => 'Publisher';

  @override
  String get platformConsole => 'Platform (console)';

  @override
  String get editItem => 'Edit item';

  @override
  String get editAction => 'Edit';

  @override
  String get chainResolving => 'Searching…';

  @override
  String get chainFound => 'Not yours yet';

  @override
  String get chainAlreadyOwned => 'Already yours';

  @override
  String get chainNotFound => 'Not found';

  @override
  String addScannedItems(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Add $count items',
      one: 'Add 1 item',
      zero: 'Nothing to add',
    );
    return '$_temp0';
  }

  @override
  String scannedItemsAdded(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count items added',
      one: '1 item added',
    );
    return '$_temp0';
  }

  @override
  String get scanBarcode => 'Scan a barcode';

  @override
  String barcodeValue(String code) {
    return 'Barcode: $code';
  }

  @override
  String get toComplete => 'To complete';

  @override
  String get publishedVolumes => 'Published volumes';

  @override
  String get updateFromAniList => 'Update from AniList';

  @override
  String get updateFailed =>
      'The update failed. Check the network and try again.';

  @override
  String get ownedVolumes => 'My volumes';

  @override
  String get seeSeries => 'See the series';

  @override
  String missingVolumesList(String volumes) {
    return 'Missing: $volumes';
  }

  @override
  String nextNotReleased(int number) {
    return 'Volume $number is not out yet.';
  }

  @override
  String ownedOfPublished(int owned, int published) {
    return '$owned / $published published';
  }

  @override
  String get cardKindExtension => 'Extension';

  @override
  String get cardKindDeck => 'Deck';

  @override
  String get editDeck => 'Edit the deck';

  @override
  String get searchCard => 'Search a card';

  @override
  String deckCardsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count cards in the deck',
      one: '1 card in the deck',
    );
    return '$_temp0';
  }

  @override
  String get fetchDetails => 'Get the details';

  @override
  String get updateDetails => 'Update';

  @override
  String fetchedOn(String date) {
    return 'Fetched on $date';
  }

  @override
  String get detailsUnavailable =>
      'Couldn’t fetch the details. Check the network and try again.';

  @override
  String get noDetailsYet => 'Nothing fetched yet.';

  @override
  String get sectionSummary => 'Summary';

  @override
  String get sectionTracks => 'Tracks';

  @override
  String get sectionGenres => 'Genres';

  @override
  String get sectionLinks => 'Links';

  @override
  String get factLabel => 'Label';

  @override
  String get factStatus => 'Status';

  @override
  String get factVolumes => 'Volumes';

  @override
  String get factChapters => 'Chapters';

  @override
  String get factRuntime => 'Runtime';

  @override
  String get factDirector => 'Director';

  @override
  String get factStudio => 'Studio';

  @override
  String get factPlatforms => 'Platforms';

  @override
  String get sectionFacts => 'Facts';

  @override
  String factLine(String label, String value) {
    return '$label: $value';
  }

  @override
  String get publicationStatusFinished => 'Finished';

  @override
  String get publicationStatusReleasing => 'Ongoing';

  @override
  String get publicationStatusNotYetReleased => 'Not yet released';

  @override
  String get publicationStatusCancelled => 'Cancelled';

  @override
  String get publicationStatusHiatus => 'On hiatus';

  @override
  String get wishesEmpty =>
      'No wishes yet. Add some from a check, a search, a discovery or a series.';

  @override
  String get wishOriginDiscovery => 'From a discovery';

  @override
  String get wishOriginSearch => 'From a search';

  @override
  String get wishOriginMissingVolume => 'Missing volume';

  @override
  String get wishOriginManual => 'Added by hand';

  @override
  String wishFulfilled(String title) {
    return '$title is in your collection, removed from your wishes.';
  }

  @override
  String get addToWishes => 'Add to my wishes';

  @override
  String get addedToWishes => 'Added to your wishes.';

  @override
  String get wishRemoved => 'Wish removed.';

  @override
  String get removeWish => 'Remove from my wishes';

  @override
  String wishVolumeTitle(String title, int number) {
    return '$title, vol. $number';
  }

  @override
  String get addMissingToWishes => 'Add the missing volumes to my wishes';

  @override
  String missingAddedToWishes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count volumes added to your wishes',
      one: '1 volume added to your wishes',
      zero: 'These volumes were already in your wishes',
    );
    return '$_temp0';
  }

  @override
  String get wished => 'Wished';

  @override
  String get allTypes => 'All';

  @override
  String becauseYouHave(String title) {
    return 'Because you have $title';
  }

  @override
  String discoveriesComputedOn(String date) {
    return 'Computed on $date';
  }

  @override
  String get discoveriesOffline =>
      'No network: here are the last discoveries kept.';

  @override
  String get discoveriesOfflineEmpty =>
      'No network. Discoveries will come back with the connection.';

  @override
  String get discoveriesNeedSeeds =>
      'Add items found online (with their source) to get discoveries.';

  @override
  String get discoveriesNothingNew => 'Nothing new for now.';

  @override
  String get notForMe => 'Not for me';

  @override
  String get addWishShort => '+ Wish';

  @override
  String get refreshDiscoveries => 'Refresh the discoveries';

  @override
  String get suggestionDismissed => 'It won’t be suggested again.';

  @override
  String wishesFulfilled(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count wishes are in your collection, removed from your wishes.',
      one: '1 wish is in your collection, removed from your wishes.',
    );
    return '$_temp0';
  }

  @override
  String wishOriginOn(String origin, String date) {
    return '$origin · $date';
  }

  @override
  String newChapterNotificationTitle(String title) {
    return '$title: new chapter';
  }

  @override
  String newChaptersNotificationBody(int count, String chapters) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Chapters $chapters are out',
      one: 'Chapter $chapters is out',
    );
    return '$_temp0';
  }

  @override
  String get scanAlertsChannelName => 'New chapters';

  @override
  String get scanAlertsChannelDescription =>
      'Alerts when a followed series gets a new chapter.';

  @override
  String get physicalTab => 'Physical';

  @override
  String get scansTab => 'Scans';

  @override
  String get notFollowedInScans => 'You don’t follow this series in scans yet.';

  @override
  String get followInScans => 'Follow in scans';

  @override
  String get stopFollowingInScans => 'Stop following in scans';

  @override
  String get lastChapterRead => 'Last chapter read';

  @override
  String newChaptersCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count new chapters',
      one: '1 new chapter',
      zero: 'Up to date',
    );
    return '$_temp0';
  }

  @override
  String get readUpToChapter => 'Read up to chapter…';

  @override
  String get markRead => 'Mark';

  @override
  String get chaptersRead => 'Chapters';

  @override
  String get showAllChapters => 'Show all chapters';

  @override
  String get readingSite => 'Reading site (link)';

  @override
  String get openReadingSite => 'Open the reading site';

  @override
  String get translationTeam => 'Translation team';

  @override
  String get linkedToMangaUpdates => 'Linked to MangaUpdates';

  @override
  String get unlinkMangaUpdates => 'Unlink';

  @override
  String get searchMangaUpdates => 'Find this series on MangaUpdates';

  @override
  String get manualTrackingHint =>
      'Without MangaUpdates, tracking stays manual and there are no alerts.';

  @override
  String get checkReleases => 'Check new chapters';

  @override
  String get chapterAlerts => 'Alert me when a chapter comes out';

  @override
  String get onlyMyTeam => 'Only my team’s releases';

  @override
  String get releasesCheckFailed =>
      'MangaUpdates can’t be reached. Try again later.';

  @override
  String get notificationsRefused =>
      'Notifications are turned off for Akashic in the phone settings.';

  @override
  String get noReleaseSeriesFound => 'No series found.';

  @override
  String get noScanFollows => 'No series followed in scans yet.';

  @override
  String get followSeriesInScans => 'Follow a series in scans';

  @override
  String get newSeriesTitle => 'New series title';

  @override
  String get createAndFollow => 'Create and follow';

  @override
  String lastReadChapterShort(String chapter) {
    return 'Last read: chapter $chapter';
  }

  @override
  String get nothingReadYet => 'Nothing read yet';

  @override
  String get stopFollowingQuestion =>
      'Stop following this series in scans? Your read chapters are kept.';

  @override
  String get cancel => 'Cancel';

  @override
  String get loans => 'Current loans';

  @override
  String get noLoans => 'Nothing is lent at the moment.';

  @override
  String get lendCopy => 'Lend';

  @override
  String get returnCopy => 'Returned';

  @override
  String get borrowerName => 'Lent to';

  @override
  String lentToSince(String borrower, String date) {
    return 'Lent to $borrower since $date';
  }

  @override
  String get statistics => 'Statistics';

  @override
  String get totalPaid => 'Total paid';

  @override
  String get byCategory => 'By category';

  @override
  String get purchasesByMonth => 'Purchases by month';

  @override
  String get noStatsYet => 'Add items to see your statistics.';

  @override
  String monthSummary(String month, int count, String amount) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count items',
      one: '1 item',
      zero: 'no purchase',
    );
    return '$month: $_temp0, $amount';
  }

  @override
  String get importCollection => 'Import a spreadsheet';

  @override
  String get importDestination => 'Destination category';

  @override
  String get chooseSpreadsheet => 'Choose a file (.xlsx, .csv)';

  @override
  String get downloadTemplate => 'Download the template';

  @override
  String get templateSaved => 'Template saved.';

  @override
  String get unreadableSpreadsheet =>
      'This file can’t be read. Use a .xlsx or .csv file.';

  @override
  String get matchColumns => 'Match the columns';

  @override
  String continueWithRows(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Continue with $count rows',
      one: 'Continue with 1 row',
      zero: 'No row to import',
    );
    return '$_temp0';
  }

  @override
  String get importFieldIgnored => 'Ignore';

  @override
  String get importFieldTitle => 'Title';

  @override
  String get importFieldCreator => 'Artist or author';

  @override
  String get importFieldBarcode => 'Barcode';

  @override
  String get importFieldEdition => 'Edition';

  @override
  String get importFieldPrice => 'Price paid';

  @override
  String get importFieldLocation => 'Location';

  @override
  String get importFieldCondition => 'Condition';

  @override
  String get importFieldYear => 'Year';

  @override
  String get importFieldSeries => 'Series';

  @override
  String get importFieldVolume => 'Volume';

  @override
  String resolvingRows(int done, int total) {
    return 'Looking up $done of $total…';
  }

  @override
  String get importFound => 'Found';

  @override
  String get importNotFound => 'Not found: added as is if ticked';

  @override
  String get importAlreadyOwned => 'Already in your collection';

  @override
  String addImportedRows(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Add $count items',
      one: 'Add 1 item',
      zero: 'Nothing to add',
    );
    return '$_temp0';
  }

  @override
  String importedCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count items added',
      one: '1 item added',
      zero: 'Nothing was added',
    );
    return '$_temp0';
  }

  @override
  String importRowStatus(int number, String status) {
    return 'Row $number · $status';
  }

  @override
  String get collectionData => 'Collection data';

  @override
  String get backup => 'Google Drive backup';

  @override
  String lastBackupOn(String date) {
    return 'Last backup: $date';
  }

  @override
  String get noBackupYet => 'No backup yet.';

  @override
  String get backupExplanation =>
      'Your collection and its images are saved in a private Akashic folder of your Google Drive. A backup also runs on its own once a week while the Google connection is valid.';

  @override
  String get backupReconnectReminder =>
      'The Google connection has expired: reconnect to resume the weekly backups.';

  @override
  String get backUpNow => 'Back up now';

  @override
  String get restoreBackup => 'Restore a backup';

  @override
  String get reconnectGoogle => 'Reconnect to Google';

  @override
  String get backupDone => 'Backup saved to Google Drive.';

  @override
  String get backupUnavailable =>
      'Google Drive can’t be reached. Try again later.';

  @override
  String get backupAuthorizationRefused =>
      'Google didn’t give access to Drive.';

  @override
  String get backupCorrupt => 'This backup is damaged and can’t be restored.';

  @override
  String get noRemoteBackup => 'No backup found on Google Drive.';

  @override
  String restoreQuestion(String date) {
    return 'Replace your current collection with the backup of $date?';
  }

  @override
  String get restoreConfirm => 'Replace';

  @override
  String get restoreReady =>
      'The backup is ready. Akashic closes now; open it again to finish the restore.';

  @override
  String get closeAkashic => 'Close Akashic';

  @override
  String get restoreFailed =>
      'The last restore couldn’t be finished. Your collection was kept as it was.';

  @override
  String get importDuplicateInFile => 'Already earlier in this file';

  @override
  String get importAdded => 'Added';

  @override
  String get importFailed => 'Couldn’t be added';

  @override
  String get factPages => 'Pages';

  @override
  String get factPublisher => 'Publisher';

  @override
  String get factFormat => 'Format';

  @override
  String get dataSources => 'Data sources';

  @override
  String get dataSourcesList =>
      'Music: Discogs and MusicBrainz (Cover Art Archive covers) · Books and comics: Google Books and Open Library, US comics: Comic Vine · Manga: AniList and Jikan (MyAnimeList), with Google Books for ISBN scans · ISBN backup: BnF catalogue (Licence Ouverte) · Films: TMDB · TV series: TVmaze (CC BY-SA) · Video games and consoles: IGDB · LEGO: Rebrickable · amiibo: AmiiboAPI · Product barcodes: UPCitemdb · Board games: BoardGameGeek · Pokémon: TCGdex · Magic: Scryfall, MTGJSON · Yu-Gi-Oh!: YGOPRODeck · Lorcana: Lorcast · Riftbound: Riftcodex · One Piece: OPTCG API · Scans: MangaUpdates · Backups when a quota is reached: Deezer (music), MangaDex (manga), Wikidata (films, video games, board games)';

  @override
  String get tmdbNotice =>
      'This product uses the TMDB API but is not endorsed or certified by TMDB.';

  @override
  String get apiLimits => 'API limits';

  @override
  String get noApiPaused => 'No API is paused.';

  @override
  String apiPausedCountdown(String source, String remaining) {
    return '$source: available again in $remaining';
  }

  @override
  String apiPausedSeveral(int count, String remaining) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count APIs paused',
      one: '1 API paused',
    );
    return '$_temp0 · next one back in $remaining';
  }

  @override
  String apiBlockedAtRetryAt(String blockedAt, String retryAt) {
    return 'Limit reached at $blockedAt · next connection at $retryAt';
  }

  @override
  String get apiLimitsExplanation =>
      'When a source refuses requests because its free limit is reached, Akashic waits until it accepts them again.';

  @override
  String get searchingImages => 'Looking for images…';

  @override
  String get tapToSearchImages => 'Tap to search';

  @override
  String groupItemCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count items',
      one: '1 item',
    );
    return '$_temp0';
  }

  @override
  String missingVolumeShort(int number) {
    return 'Vol. $number';
  }

  @override
  String missingVolumesMore(int count) {
    return '$count missing';
  }

  @override
  String get otherItems => 'Others';

  @override
  String get cameraUnavailable =>
      'The camera cannot be opened. Check the camera permission in the phone settings.';

  @override
  String get removeLanguage => 'Remove this language';

  @override
  String get typeCardName => 'Card name';

  @override
  String get noApiForThisGame =>
      'No online catalogue for this game: cards are entered by hand.';

  @override
  String addCardAsTyped(String name) {
    return 'Add “$name” as typed';
  }

  @override
  String get noApiForThisCategory =>
      'No online catalogue for this category: fill in the sheet by hand, the image search still works.';

  @override
  String get add => 'Add';

  @override
  String get cardGamesWithCatalogue => 'Games with an online catalogue';

  @override
  String get otherCardGamesByHand =>
      'Any other game works too: its cards are entered by hand.';

  @override
  String get categoryTypeBoardGames => 'Board games';

  @override
  String get partComponents => 'Components';

  @override
  String get aimBarcodeOrShootCover => 'Aim at a barcode, or shoot the cover';

  @override
  String get delete => 'Delete';

  @override
  String get deleteCopy => 'Remove from the collection';

  @override
  String get deleteLastCopyTitle => 'Remove this item from the collection?';

  @override
  String get deleteLastCopyExplanation =>
      'The item will be deleted, with its titles, cover, details and deck.';

  @override
  String get noOnlineDetailsForItem =>
      'No online catalogue describes this item: it was entered by hand or comes from a source without details.';

  @override
  String get customCategoryExplanation =>
      'A category you name, with no online catalogue: every item is entered by hand, with the image search for its cover. Add below the parts whose condition you want to rate.';

  @override
  String get chainScanHint =>
      'Scan barcodes or shoot covers: you see straight away whether you own them, then add the ones you keep.';

  @override
  String get scannedCodes => 'Scanned codes';

  @override
  String get chainRateLimited => 'Quota exceeded';

  @override
  String get chainUnreachable => 'Catalogue unreachable';

  @override
  String get chainUnreadable => 'Unreadable cover';

  @override
  String get coverBeingRead => 'Reading the cover…';

  @override
  String coverEntryLabel(String title) {
    return 'Cover: $title';
  }

  @override
  String chainFailureNotFound(String label) {
    return 'Nothing found for $label.';
  }

  @override
  String get chainFailureUnreadable =>
      'The cover couldn\'t be read: take the photo again, closer and without reflections.';

  @override
  String chainFailureRateLimited(String label) {
    return 'Call quota exceeded: $label couldn\'t be checked.';
  }

  @override
  String chainFailureUnreachable(String label) {
    return 'Catalogues unreachable: $label couldn\'t be checked.';
  }

  @override
  String scannedItemsPartlyAdded(int added, int failed) {
    return '$added added, $failed couldn\'t be added.';
  }

  @override
  String get unexpectedError => 'Something went wrong. Try again.';

  @override
  String unexpectedErrorWithDetail(String detail) {
    return 'Something went wrong: $detail';
  }

  @override
  String sourceRateLimitedToast(String source) {
    return '$source: call quota exceeded, try again later.';
  }

  @override
  String sourceUnreachableToast(String source) {
    return '$source can\'t be reached: check the network.';
  }

  @override
  String get itemSaveFailedToast => 'The item couldn\'t be saved.';

  @override
  String get discoveriesFailedToast =>
      'Discoveries couldn\'t be refreshed: the catalogues can\'t be reached.';

  @override
  String get automaticBackupFailedToast => 'The automatic backup failed.';

  @override
  String importLineFailedToast(int row) {
    return 'Line $row couldn\'t be checked.';
  }

  @override
  String appVersionLabel(String version) {
    return 'Akashic $version';
  }

  @override
  String get editCategory => 'Edit the category';

  @override
  String get reorderCategories => 'Change the order';

  @override
  String get deleteCategory => 'Delete the category';

  @override
  String get categoryActions => 'Category actions';

  @override
  String deleteCategoryTitle(String name) {
    return 'Delete “$name”?';
  }

  @override
  String get deleteEmptyCategoryExplanation => 'This category is empty.';

  @override
  String deleteCategoryExplanation(int items, int series, int subcategories) {
    String _temp0 = intl.Intl.pluralLogic(
      items,
      locale: localeName,
      other: '$items items',
      one: '1 item',
      zero: 'no item',
    );
    String _temp1 = intl.Intl.pluralLogic(
      series,
      locale: localeName,
      other: '$series series',
      one: '1 series',
      zero: 'no series',
    );
    String _temp2 = intl.Intl.pluralLogic(
      subcategories,
      locale: localeName,
      other: '$subcategories subcategories',
      one: '1 subcategory',
      zero: 'no subcategory',
    );
    return 'Everything it holds will be deleted too: $_temp0, $_temp1 and $_temp2, with their covers. This can\'t be undone.';
  }

  @override
  String get moveItem => 'Move to another category';

  @override
  String get moveSeriesQuestion => 'Move the whole series?';

  @override
  String get moveSeriesExplanation =>
      'This item belongs to a series. Move the series with all its volumes, or only this one, which then leaves the series.';

  @override
  String get moveThisVolumeOnly => 'This one only';

  @override
  String get moveWholeSeries => 'The whole series';

  @override
  String movedInto(String category) {
    return 'Moved into $category.';
  }

  @override
  String get backupFileSection => 'Backup file';

  @override
  String get backupFileExplanation =>
      'The same full archive as the Drive backup (collection and covers), saved where you choose: phone, SD card, another cloud app.';

  @override
  String get exportToFile => 'Export to a file';

  @override
  String get restoreFromFile => 'Restore from a file';

  @override
  String get exportDone => 'Collection exported.';

  @override
  String get progressTitle => 'Progress';

  @override
  String get progressNotStarted => 'Not started';

  @override
  String get progressToRead => 'To read';

  @override
  String get progressToPlay => 'To play';

  @override
  String get progressToWatch => 'To watch';

  @override
  String get progressToListen => 'To listen';

  @override
  String get progressInProgress => 'In progress';

  @override
  String get progressFinished => 'Finished';

  @override
  String get progressRead => 'Read';

  @override
  String get progressPlayed => 'Completed';

  @override
  String get progressWatched => 'Watched';

  @override
  String get progressListened => 'Listened';

  @override
  String get progressAbandoned => 'Dropped';

  @override
  String get progressChapter => 'Chapter';

  @override
  String get progressPage => 'Page';

  @override
  String progressBookmark(String chapter, String page) {
    return 'Chapter $chapter · page $page';
  }

  @override
  String get arrangeShelf => 'Sort and filter';

  @override
  String get sortTitle => 'Sort';

  @override
  String get sortBySeries => 'By series';

  @override
  String get sortByTitle => 'Title';

  @override
  String get sortByCreator => 'Author or artist';

  @override
  String get sortNewest => 'Most recent';

  @override
  String get sortOldest => 'Oldest';

  @override
  String get sortBestRated => 'Best rated';

  @override
  String get sortRecentlyAdded => 'Recently added';

  @override
  String get filterAll => 'All';

  @override
  String get filterMinimumRating => 'Rating';

  @override
  String filterAtLeastStars(int stars) {
    return '$stars★ and more';
  }

  @override
  String get resetArrangement => 'Reset';

  @override
  String get applyArrangement => 'Apply';

  @override
  String get noItemMatchesArrangement => 'No item matches these filters.';

  @override
  String get photosTitle => 'Photos';

  @override
  String get addPhoto => 'Add a photo';

  @override
  String get pickFromGallery => 'Choose from the gallery';

  @override
  String get deletePhotoQuestion => 'Delete this photo?';

  @override
  String get photosHint => 'Tap to enlarge, long press to delete.';

  @override
  String get loanRemindersChannelName => 'Loan reminders';

  @override
  String get loanRemindersChannelDescription =>
      'Reminds you of items lent for a month.';

  @override
  String loanReminderTitle(String title) {
    return '$title is still lent';
  }

  @override
  String loanReminderBody(String borrower, int days) {
    return '$borrower has had it for $days days.';
  }

  @override
  String selectedItemsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count selected',
      one: '1 selected',
    );
    return '$_temp0';
  }

  @override
  String get clearSelection => 'Cancel the selection';

  @override
  String get setStorageLocation => 'Set the storage location';

  @override
  String get locationApplied => 'Storage location updated.';

  @override
  String deleteSelectedItemsTitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Delete $count items?',
      one: 'Delete 1 item?',
    );
    return '$_temp0';
  }

  @override
  String get deleteSelectedItemsExplanation =>
      'Their photos, covers, details and loans go with them. This can\'t be undone.';

  @override
  String get shareWishlist => 'Share my wishes';

  @override
  String get wishlistShareHeading => 'My wishes, from Akashic';

  @override
  String get wishlistShareSubject => 'My wish list';

  @override
  String get discogsImportTitle => 'Import my Discogs collection';

  @override
  String get discogsImportExplanation =>
      'Every record of your Discogs collection is added with its cover. Records already in Akashic are skipped, so you can import again later to bring in the new ones.';

  @override
  String get discogsImportTarget => 'Music category';

  @override
  String get discogsImportStart => 'Import';

  @override
  String get discogsImportReading => 'Reading your Discogs collection…';

  @override
  String discogsImportProgress(int done, int total) {
    return '$done of $total records';
  }

  @override
  String discogsImportOutcome(int added, int owned, int failed) {
    return '$added added, $owned already there, $failed failed.';
  }

  @override
  String get discogsImportNeedsToken => 'No Discogs token is configured.';

  @override
  String get discogsImportNeedsMusicCategory =>
      'Create a music category first.';

  @override
  String widgetItemCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count items',
      one: '1 item',
      zero: 'No item yet',
    );
    return '$_temp0';
  }

  @override
  String widgetLatestAdditions(String titles) {
    return 'Latest: $titles';
  }

  @override
  String widgetLoans(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count loans in progress',
      one: '1 loan in progress',
    );
    return '$_temp0';
  }

  @override
  String get widgetNoLoan => 'No loan in progress';

  @override
  String get updateCardPrices => 'Update prices';

  @override
  String deckEstimatedValue(String value) {
    return 'Estimated value: $value';
  }

  @override
  String get deckValueUnknown => 'No price yet';

  @override
  String get categoryTypeLego => 'LEGO';

  @override
  String get categoryTypeAmiibo => 'amiibo';

  @override
  String get categoryTypeConsoles => 'Consoles & hardware';

  @override
  String get creatorTheme => 'Theme';

  @override
  String get creatorAmiiboSeries => 'amiibo series';

  @override
  String get creatorManufacturer => 'Manufacturer';

  @override
  String get upcomingReleases => 'Upcoming releases';

  @override
  String get refreshReleases => 'Refresh releases';

  @override
  String get releasesFailedToast =>
      'Upcoming releases can’t be fetched right now.';

  @override
  String get releasesOfflineEmpty =>
      'Upcoming releases couldn’t be loaded. Try again once you’re online.';

  @override
  String get releasesNeedInterests =>
      'File numbered volumes in a series, create a card game category (Pokémon, Magic, Yu-Gi-Oh!, Lorcana, Riftbound) or add records with their artist to follow their releases.';

  @override
  String get releasesNothingAnnounced =>
      'No release announced for what you collect.';

  @override
  String get releaseAlertsChannelName => 'Upcoming releases';

  @override
  String get releaseAlertsChannelDescription =>
      'Lets you know when an expansion, an album or the next volume of a series is announced.';

  @override
  String releaseAlertTitle(String title) {
    return 'Release announced: $title';
  }

  @override
  String releaseAlertBody(String subject, String date) {
    return '$subject · on $date';
  }

  @override
  String releaseAlertSummaryTitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count new releases announced',
      one: '1 new release announced',
    );
    return '$_temp0';
  }

  @override
  String get chooseCategory => 'Choose a category';

  @override
  String get navReleases => 'Releases';

  @override
  String get seeAll => 'See all';

  @override
  String get tutorialNext => 'Next';

  @override
  String get replayTutorial => 'Replay the tutorial';

  @override
  String get helpSection => 'Help';

  @override
  String get addItemShort => 'Add';

  @override
  String get tourPrevious => 'Previous';

  @override
  String get tourDone => 'Done';

  @override
  String tourProgress(int current, int total) {
    return '$current / $total';
  }

  @override
  String get tourWelcomeTitle => 'Welcome to Akashic';

  @override
  String get tourWelcomeText =>
      'Your physical collection laid out like your shelves: books, manga, music, films, games, cards, LEGO… A quick tour of the controls.';

  @override
  String get tourNewCategoryTitle => 'Create your categories';

  @override
  String get tourNewCategoryText =>
      'Pick a type (manga, records, card game…): it decides which catalogues are searched. Each category becomes a shelf; tap it to open it.';

  @override
  String get tourSearchTitle => 'Find an item';

  @override
  String get tourSearchText =>
      'Search your whole collection by title, author or barcode.';

  @override
  String get tourScanTitle => 'Scan';

  @override
  String get tourScanText =>
      'Aim at barcodes one after another or shoot a cover: you instantly see whether you own it, then add what you keep in one go.';

  @override
  String get tourMenuTitle => 'Everything else is here';

  @override
  String get tourMenuText =>
      'Loans, statistics and settings: Drive backup, import, languages… and “Replay the tutorial” to take this tour again.';

  @override
  String get tourWishesTitle => 'Your wishes';

  @override
  String get tourWishesText =>
      'What you are still looking for, shareable in one tap.';

  @override
  String get tourDiscoveriesTitle => 'Discoveries';

  @override
  String get tourDiscoveriesText =>
      'Suggestions drawn from your collection; tap a card to see its details.';

  @override
  String get tourReleasesTitle => 'Releases';

  @override
  String get tourReleasesText =>
      'The next volumes of your series, the expansions of your card games and the new albums of your artists.';

  @override
  String get releasesAlreadyOut => 'Already out';

  @override
  String get addPreconDeck => 'Add a preconstructed deck';

  @override
  String get searchPreconDeck => 'Deck name, set or type';

  @override
  String get noPreconDeckFound => 'No preconstructed deck matches.';

  @override
  String preconDeckAdded(int count, String deck) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count cards added from $deck',
      one: '1 card added from $deck',
    );
    return '$_temp0';
  }

  @override
  String get commanderDeckGroup => 'Commander deck';

  @override
  String get preconDeckGroup => 'Preconstructed deck';

  @override
  String get addToWhichSubcategory => 'Add to which subcategory?';

  @override
  String get deckHasNoCards => 'This deck holds no card yet.';

  @override
  String get progressPlayedOnce => 'Played';

  @override
  String get progressToBuild => 'To build';

  @override
  String get progressBuilding => 'Building';

  @override
  String get progressBuilt => 'Built';

  @override
  String get savePhoto => 'Save to the gallery';

  @override
  String get photoSaved => 'Photo saved to the Akashic album.';

  @override
  String get photoNotSaved => 'The photo could not be saved.';

  @override
  String missingVolumeLabel(int number) {
    return 'Volume $number missing';
  }

  @override
  String get ratingLabel => 'Rating';

  @override
  String get notRated => 'Not rated';

  @override
  String ratingValue(int stars) {
    return '$stars out of 5';
  }

  @override
  String get removeOneCard => 'Remove one copy of the card';

  @override
  String get addOneCard => 'Add one copy of the card';

  @override
  String get deleteCard => 'Remove the card from the deck';

  @override
  String photoNumber(int number) {
    return 'Photo $number';
  }

  @override
  String get incompleteSeries => 'Incomplete series';

  @override
  String get estimatedValue => 'Estimated value';

  @override
  String get estimatedValueExplanation =>
      'Low estimate: lowest Discogs price for records, card prices for decks, otherwise the price paid.';

  @override
  String valuedItemsSummary(int market, int purchase, int unvalued) {
    return '$market priced · $purchase at price paid · $unvalued without value';
  }

  @override
  String get updateMarketValues => 'Update prices';

  @override
  String updatingMarketValues(int done, int total) {
    return 'Updating prices… $done/$total';
  }

  @override
  String marketValuedOn(String date) {
    return 'Prices from $date';
  }

  @override
  String get marketValuesIncomplete =>
      'Update stopped by the request limit, try again later.';

  @override
  String get valueByCategory => 'Value by category';

  @override
  String get duplicatesTitle => 'Duplicates';

  @override
  String duplicatesCount(int count) {
    return 'Duplicates ($count)';
  }

  @override
  String get sameWorkSection => 'Same work added several times';

  @override
  String get noDuplicates => 'No duplicates';

  @override
  String get searchLoans => 'Search a title or a borrower';

  @override
  String get noLoanMatches => 'No loan matches.';

  @override
  String get additionsByYear => 'Additions by year';

  @override
  String get seriesCompletionTitle => 'Complete series';

  @override
  String seriesCompletionSummary(int complete, int total) {
    return '$complete of $total series complete';
  }

  @override
  String categoryShare(String category, int percent) {
    return '$category $percent%';
  }

  @override
  String yearAdditions(String year, int count) {
    return '$year: $count additions';
  }

  @override
  String estimatedReleaseAround(String date) {
    return 'estimate: around $date';
  }

  @override
  String get estimateBadge => 'Estimate';

  @override
  String get wishedRelease => 'On your wish list';

  @override
  String wishedReleaseOutTitle(String title) {
    return '$title is out';
  }

  @override
  String wishedReleaseOutBody(String subject) {
    return 'The $subject volume you were waiting for is available.';
  }

  @override
  String volumeOwnedLabel(int number) {
    return 'Volume $number, owned';
  }

  @override
  String volumeMissingLabel(int number) {
    return 'Volume $number, missing';
  }

  @override
  String volumeUnreleasedLabel(int number) {
    return 'Volume $number, not out yet';
  }

  @override
  String paletteColorName(String index) {
    String _temp0 = intl.Intl.selectLogic(index, {
      '0': 'Blue',
      '1': 'Pink',
      '2': 'Green',
      '3': 'Turquoise',
      '4': 'Purple',
      '5': 'Orange',
      '6': 'Yellow',
      'other': 'Lavender',
    });
    return '$_temp0';
  }

  @override
  String cardsWithoutTraits(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count cards without type or colour',
      one: '1 card without type or colour',
    );
    return '$_temp0';
  }

  @override
  String get fetchCardTraits => 'Fetch';

  @override
  String get cardFamilyCreature => 'Creatures';

  @override
  String get cardFamilyPlaneswalker => 'Planeswalkers';

  @override
  String get cardFamilyBattle => 'Battles';

  @override
  String get cardFamilyInstant => 'Instants';

  @override
  String get cardFamilySorcery => 'Sorceries';

  @override
  String get cardFamilyArtifact => 'Artifacts';

  @override
  String get cardFamilyEnchantment => 'Enchantments';

  @override
  String get cardFamilyLand => 'Lands';

  @override
  String get cardFamilyOther => 'Other';

  @override
  String get manaWhite => 'white';

  @override
  String get manaBlue => 'blue';

  @override
  String get manaBlack => 'black';

  @override
  String get manaRed => 'red';

  @override
  String get manaGreen => 'green';

  @override
  String get colorIdentityTitle => 'Colour identity';

  @override
  String colorIdentityLabel(String colors) {
    return 'Colour identity: $colors';
  }

  @override
  String get manaCurveTitle => 'Mana curve';

  @override
  String manaCurveSummary(String average) {
    return 'Mana curve · average $average';
  }

  @override
  String manaCurveEntry(String cost, int count) {
    return 'cost $cost: $count';
  }

  @override
  String get commanderRulesTitle => 'Commander rules';

  @override
  String get noCommanderChosen => 'No commander chosen';

  @override
  String get chooseCommander => 'Choose the commander';

  @override
  String commanderRuleSize(int count) {
    return 'Exactly 100 cards (currently $count)';
  }

  @override
  String get commanderRuleCommander => 'A commander chosen';

  @override
  String get commanderRuleSingleton =>
      'One copy of each card, basic lands aside';

  @override
  String commanderRuleDuplicates(String names) {
    return 'Several copies: $names';
  }

  @override
  String get commanderRuleIdentity =>
      'Every card within the commander\'s colour identity';

  @override
  String commanderRuleOutsideIdentity(String names) {
    return 'Outside the colour identity: $names';
  }

  @override
  String get commanderRuleIdentityUnknown =>
      'Colour identity to check: choose a commander and fetch the card colours';

  @override
  String get ruleMet => 'Met';

  @override
  String get ruleNotMet => 'Not met';

  @override
  String get ruleUnknown => 'To check';

  @override
  String get photographShelf => 'Photograph a shelf (several items at once)';

  @override
  String get shelfBeingRead => 'Reading the spines…';

  @override
  String get deckCardsTab => 'Cards';

  @override
  String get deckAnalysisTab => 'Analysis';

  @override
  String get primaryCommander => 'Main';

  @override
  String get secondaryCommander => 'Secondary';

  @override
  String primaryCommanderIs(String name) {
    return 'Main commander: $name';
  }

  @override
  String secondaryCommanderIs(String name) {
    return 'Secondary commander: $name';
  }

  @override
  String get swapCommanders => 'Swap main and secondary';

  @override
  String get commanderCandidatesNeedTraits =>
      'Only legendary creatures are offered. Fetch the card types first to see them all.';

  @override
  String get noLegendaryCreature => 'No legendary creature in this deck.';

  @override
  String get accountImportTitle => 'Import from an account';

  @override
  String get accountImportSubtitle =>
      'Steam, itch.io, Trakt, AniList, MyAnimeList, Open Library, BoardGameGeek, Rebrickable, Playnite';

  @override
  String get steamImportExplanation =>
      'Adds every game of your Steam library. Your profile game details must be public (Steam › Profile › Edit › Privacy).';

  @override
  String get traktImportExplanation =>
      'Adds the films and shows of your Trakt collection (what you own). Your Trakt profile must be public.';

  @override
  String get anilistImportExplanation =>
      'Adds the manga of your AniList list with your progress (reading, read, dropped). It is your reading list: remove what you do not own afterwards.';

  @override
  String get openLibraryImportExplanation =>
      'Adds the books of your Open Library shelves (read, reading, want to read) with your progress. Your reading log must be public.';

  @override
  String get accountNameLabel => 'Account name';

  @override
  String get accountNameHint => 'Your name on the site';

  @override
  String get steamAccountHint => 'steamcommunity.com/id/… or SteamID';

  @override
  String accountImportNeedsKey(String service) {
    return '$service is not set up: its API key is missing from the build.';
  }

  @override
  String get accountImportNeedsCategory =>
      'Create a category of this type first to hold the import.';

  @override
  String get accountImportReading => 'Reading the library…';

  @override
  String accountNotFound(String service) {
    return '$service account not found or private.';
  }

  @override
  String get playniteImportExplanation =>
      'Playnite (PC) gathers Steam, Epic, GOG, Ubisoft Connect, EA, Battle.net, Amazon, Xbox… Install the “Library Exporter Advanced” extension, tick Developers, Platforms, Source and Release date, then export the whole library as CSV. Copy the file to your phone and pick it here. Each game is looked up on IGDB for its cover; the launcher becomes its edition.';

  @override
  String get chooseExportFile => 'Choose the CSV export';

  @override
  String get exportFileUnreadable =>
      'This file cannot be read as a Playnite export.';

  @override
  String get boardGameGeekImportExplanation =>
      'Adds the games marked “owned” in your BoardGameGeek collection, expansions included. BGG sometimes prepares the collection first: the import waits a few seconds.';

  @override
  String get itchIoImportExplanation =>
      'Adds the games bought or claimed on your itch.io account. Create a key in itch.io › Settings › API keys and paste it here: it is only used for this import and is not kept.';

  @override
  String get myAnimeListImportExplanation =>
      'Adds the manga of your MyAnimeList list with your progress (reading, read, dropped). It is your reading list: remove what you do not own afterwards.';

  @override
  String get rebrickableImportExplanation =>
      'Adds the LEGO sets of your Rebrickable collection. Your password is used once to access your collection: it is neither kept nor sent anywhere but Rebrickable.';

  @override
  String get personalApiKeyLabel => 'Your personal API key';

  @override
  String get personalApiKeyHint => 'Pasted from the site settings';

  @override
  String get accountPasswordLabel => 'Password';

  @override
  String get accountPasswordNotKept => 'Used once, never saved';

  @override
  String get importDeckList => 'Import a deck from Archidekt';

  @override
  String get deckListLink => 'Deck link';

  @override
  String get deckListNotFound =>
      'Deck not found: check the link and that the deck is public.';

  @override
  String get accountImportTarget => 'Add to';

  @override
  String get steamAccountLabel => 'Your Steam profile link or SteamID';

  @override
  String get steamAccountHelper =>
      'Steam › your profile › right-click the page › Copy page URL. Your display name does not work: only the name in the address (steamcommunity.com/id/…) or the number (…/profiles/7656…) is recognised.';

  @override
  String steamProfileNotFound(String name) {
    return 'No Steam profile has the address “$name”. Paste your profile link (Steam › your profile › Copy page URL): your display name is not the address.';
  }

  @override
  String get steamLibraryPrivate =>
      'Profile found, but your game list is private. Steam › Profile › Edit Profile › Privacy Settings › “Game details”: Public.';

  @override
  String libraryPrivate(String service) {
    return '$service account found, but its library is private.';
  }

  @override
  String get keepAccountSynced => 'Sync automatically';

  @override
  String get keepAccountSyncedExplanation =>
      'New additions on this account arrive in Akashic on their own (at launch, every 6 h at most). What you delete here does not come back.';

  @override
  String get linkedAccountsTitle => 'Synced accounts';

  @override
  String lastSyncedAt(String date) {
    return 'synced $date';
  }

  @override
  String get syncNow => 'Sync now';

  @override
  String get stopSyncing => 'Stop syncing';

  @override
  String get rarityCommon => 'Common';

  @override
  String get rarityRare => 'Rare';

  @override
  String get rarityEpic => 'Epic';

  @override
  String get rarityLegendary => 'Legendary';

  @override
  String get achievementsTab => 'Achievements';

  @override
  String get achievementsAll => 'All';

  @override
  String get achievementsUnlocked => 'Unlocked';

  @override
  String get achievementsLocked => 'To unlock';

  @override
  String get achievementsRare => 'Rare';

  @override
  String achievementsSummary(int unlocked, int total, int percent) {
    return '$unlocked of $total achievements unlocked, $percent%';
  }

  @override
  String achievementsRemaining(int remaining, int legendary) {
    String _temp0 = intl.Intl.pluralLogic(
      remaining,
      locale: localeName,
      other: '$remaining left',
      one: '1 left',
      zero: 'Every achievement unlocked',
    );
    String _temp1 = intl.Intl.pluralLogic(
      legendary,
      locale: localeName,
      other: ', $legendary legendary',
      one: ', 1 legendary',
      zero: '',
    );
    return '$_temp0$_temp1';
  }

  @override
  String achievementPlayersPercent(String percent) {
    return 'unlocked by $percent% of players';
  }

  @override
  String achievementUnlockedOn(String date) {
    return 'Unlocked on $date';
  }

  @override
  String get achievementLocked => 'To unlock';

  @override
  String get hiddenAchievement => 'Hidden achievement';

  @override
  String get steamAchievementsNeedAccount =>
      'Link your Steam account (Settings › Import from an account) to see your achievements.';

  @override
  String get steamAchievementsUnavailable =>
      'Steam is not answering right now.';

  @override
  String get steamNoAchievements => 'This game has no Steam achievements.';

  @override
  String achievementsListCaption(
    int count,
    String lockedFirst,
    String sortLabel,
  ) {
    String _temp0 = intl.Intl.selectLogic(lockedFirst, {
      'yes': ' · to unlock first',
      'other': '',
    });
    return '$count achievements$_temp0 · sorted by $sortLabel';
  }

  @override
  String get achievementSortRarity => 'rarity';

  @override
  String get achievementSortDate => 'date';

  @override
  String get achievementSortName => 'name';

  @override
  String get retry => 'Try again';

  @override
  String get steamStorePageMissing =>
      'Steam has no store page for this game in your region.';

  @override
  String get steamNewsTitle => 'News';

  @override
  String get steamDlcTitle => 'Downloadable content';

  @override
  String get steamDlcOwnershipNote =>
      'Steam does not say which DLC you own: only those in your Akashic collection are marked.';

  @override
  String get steamAboutTitle => 'About';

  @override
  String get steamDeveloper => 'Developer';

  @override
  String get steamPublisher => 'Publisher';

  @override
  String get steamReleaseDate => 'Release';

  @override
  String get steamMediaTitle => 'Screenshots and trailer';

  @override
  String get steamTrailer => 'Trailer, opens on Steam';

  @override
  String steamScreenshot(int number) {
    return 'Screenshot $number';
  }

  @override
  String get steamFeaturesTitle => 'Modes and features';

  @override
  String get steamLanguagesTitle => 'Languages';

  @override
  String get steamRequirementsTitle => 'System requirements';

  @override
  String get steamOpenStore => 'View on Steam';

  @override
  String get steamFree => 'Free';

  @override
  String get steamNoPrice => 'No price given';

  @override
  String steamPriceBefore(String price) {
    return 'instead of $price';
  }

  @override
  String get steamPriceToday => 'Steam price today';

  @override
  String get steamDlcInCollection => 'In your collection';

  @override
  String steamComingOn(String date) {
    return 'Release: $date';
  }

  @override
  String get steamDlcWished => 'Added to your wishes';

  @override
  String get steamWishAction => 'Wish';

  @override
  String get steamPlaytime => 'Playtime';

  @override
  String steamPlaytimeSummary(String total, String recent) {
    return 'Playtime: $total in total, $recent in the last 14 days';
  }

  @override
  String steamRecentPlaytime(String duration) {
    return '$duration in the last 14 days';
  }

  @override
  String get steamNotPlayedRecently => 'Not played in the last 14 days';

  @override
  String steamLastPlayed(String date) {
    return 'Last played on $date';
  }

  @override
  String get steamNeverPlayed => 'Never launched';

  @override
  String get steamStatus => 'Status';

  @override
  String get steamNoStatus => 'None';

  @override
  String steamStatusChange(String status) {
    return 'Status: $status. Tap for the next one.';
  }

  @override
  String get steamStatusAutomatic => 'auto · Steam';

  @override
  String get steamStatusManual => 'set by hand';

  @override
  String get steamDeck => 'Steam Deck';

  @override
  String get steamDeckVerified => 'Verified';

  @override
  String get steamDeckPlayable => 'Playable';

  @override
  String get steamDeckUnsupported => 'Unsupported';

  @override
  String get steamDeckUnknown => 'Unknown';

  @override
  String get steamDeckVerifiedDetail => 'Controls, display and text checked';

  @override
  String get steamDeckPlayableDetail => 'Some manual tweaking';

  @override
  String get steamDeckUnsupportedDetail => 'Does not run on Steam Deck';

  @override
  String get steamDeckUnknownDetail => 'Not yet reviewed by Valve';

  @override
  String get steamMyCopy => 'My game';

  @override
  String get steamCopyPlatform => 'Platform';

  @override
  String get steamCopyPrice => 'Price paid';

  @override
  String get steamCopyAdded => 'Added on';

  @override
  String steamUpdatedAt(String date) {
    return 'Updated from Steam on $date';
  }

  @override
  String get steamRarestAchievement => 'Rarest';

  @override
  String get steamNoRareAchievement => 'No achievement unlocked yet';

  @override
  String get steamStatsTitle => 'Video games';

  @override
  String get steamTotalPlaytime => 'Playtime';

  @override
  String steamGameCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Steam games',
      one: '1 Steam game',
    );
    return '$_temp0';
  }

  @override
  String get steamAverageCompletion => 'Achievements done';

  @override
  String get steamAverageCompletionCaption =>
      'on average across launched games';

  @override
  String get steamShelfOfShame => 'Pile of shame';

  @override
  String steamNeverLaunchedCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count games never launched',
      one: '1 game never launched',
    );
    return '$_temp0';
  }

  @override
  String get steamTopPlayed => 'Most played';

  @override
  String get steamLibraryValue => 'Steam library value';

  @override
  String get steamLibraryValueNote =>
      'at today\'s Steam store price, not a resale value';

  @override
  String steamPricesOf(String date) {
    return 'prices of $date';
  }

  @override
  String syncReading(String service) {
    return 'Syncing $service…';
  }

  @override
  String syncProgress(String service, int done, int total) {
    return 'Syncing $service · $done / $total';
  }

  @override
  String syncRefreshingDetails(String service) {
    return '$service · updating statistics…';
  }

  @override
  String get cardKindSealed => 'Sealed';

  @override
  String get tradeHistory => 'Purchases and sales';

  @override
  String get tradeSpent => 'Spent';

  @override
  String get tradeEarned => 'Sales';

  @override
  String get tradeMargin => 'Margin';

  @override
  String get tradeMarginCaption => 'on sales with a known purchase price';

  @override
  String get noTrades =>
      'No purchases or sales yet. Fill in what you paid for an item, or sell one from its page.';

  @override
  String get tradePurchase => 'Purchase';

  @override
  String get tradeSale => 'Sale';

  @override
  String get channelStore => 'In store';

  @override
  String get channelOnline => 'Online';

  @override
  String get sealedState => 'Sealed';

  @override
  String get openedState => 'Opened';

  @override
  String get productOpened => 'Opened product';

  @override
  String marginOf(String amount) {
    return '$amount margin';
  }

  @override
  String get purchaseDate => 'Purchase date';

  @override
  String get purchaseChannel => 'Bought';

  @override
  String boughtOn(String when) {
    return 'Bought on $when';
  }

  @override
  String get noDateSet => 'Not set';

  @override
  String get sellCopy => 'Sell';

  @override
  String get salePrice => 'Sale price';

  @override
  String get saleDate => 'Sale date';

  @override
  String get saleChannel => 'Sold';

  @override
  String get sell => 'Sell';

  @override
  String get sellLastCopyExplanation =>
      'The item leaves your collection, the sale stays in the history.';

  @override
  String get clearPurchaseDate => 'Clear the purchase date';

  @override
  String get sealedMarketPrice => 'Cardmarket price';

  @override
  String get sealedMarketPriceSealedOnly => 'Sealed product';

  @override
  String get sealedPriceTrend => 'Trend';

  @override
  String get sealedPriceLow => 'Lowest';

  @override
  String get sealedPriceAverage => 'Average sale';

  @override
  String get sealedPriceAverage1 => '1-day average';

  @override
  String get sealedPriceAverage7 => '7-day average';

  @override
  String get sealedPriceAverage30 => '30-day average';

  @override
  String sealedPricedOn(String when) {
    return 'Prices of $when';
  }

  @override
  String get sealedPriceMissing =>
      'No price for this product yet: update the prices.';

  @override
  String get sealedOpenedHasNoPrice =>
      'Cardmarket only prices sealed products: an opened product has no separate price.';

  @override
  String get refreshSealedPrices => 'Update prices';

  @override
  String get meteredDownloadTitle => 'Mobile data';

  @override
  String meteredDownloadBody(String size) {
    return 'You are on mobile data. The update downloads about $size from Cardmarket. Continue?';
  }

  @override
  String get meteredDownloadUnknownSize =>
      'You are on mobile data. The update downloads the Cardmarket price file, about 16 MB per game. Continue?';

  @override
  String get continueAnyway => 'Continue';

  @override
  String sealedPricesUpdated(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count prices updated',
      one: '1 price updated',
      zero: 'No price found',
    );
    return '$_temp0';
  }

  @override
  String get sealedPricesUnavailable =>
      'Cardmarket cannot be reached right now, try again later.';

  @override
  String get scanModeBarcode => 'Barcode';

  @override
  String get scanModeCover => 'Cover';

  @override
  String get scanModeShelf => 'Shelf';

  @override
  String get scanHintBarcodeTitle => 'Aim at the barcode';

  @override
  String get scanHintBarcodeDetail => 'Read automatically, no tap needed';

  @override
  String get scanHintCoverTitle => 'Frame the cover, then tap';

  @override
  String get scanHintCoverDetail => 'One item per photo';

  @override
  String get scanHintShelfTitle => 'Line the spines up in the frame';

  @override
  String get scanHintShelfDetail => 'Up to 24 items at once';

  @override
  String get continuousReading => 'Reading continuously';

  @override
  String get scansPileHere => 'Your scans will pile up here';

  @override
  String get toAdd => 'to add';

  @override
  String chainScannedCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count scanned',
      one: '1 scanned',
    );
    return '$_temp0';
  }

  @override
  String chainOwnedCount(int count) {
    return '$count already yours';
  }

  @override
  String chainMissingCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count not found',
      one: '1 not found',
    );
    return '$_temp0';
  }

  @override
  String shelfSpinesRead(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count spines read',
      one: '1 spine read',
    );
    return '$_temp0';
  }

  @override
  String shelfSpinesSearching(int count) {
    return '$count being searched';
  }

  @override
  String get chainGroupToAdd => 'To add';

  @override
  String get chainGroupOwned => 'Already in your collection';

  @override
  String get chainGroupMissing => 'Not found';

  @override
  String get chainSourceBarcode => 'Barcode';

  @override
  String get chainSourceCover => 'Cover';

  @override
  String get chainSourceShelf => 'Shelf';

  @override
  String get shelfUnreadableTitle => 'No readable spine';

  @override
  String get shelfUnreadableHint =>
      'Move closer and line the spines up in the frame.';

  @override
  String get coverUnreadableHint =>
      'Take the photo again, closer and without glare.';

  @override
  String get showScannedList => 'Show the scan list';

  @override
  String get hideScannedList => 'Fold the scan list';

  @override
  String get addAnotherItem => 'I own another one';

  @override
  String get anotherItemAdded => 'Added once more';

  @override
  String get fillObjectDetails => 'Fill in purchase, condition, storage';

  @override
  String itemCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count items',
      one: '1 item',
    );
    return '$_temp0';
  }

  @override
  String get wishOriginSteamWishlist => 'Steam wishlist';

  @override
  String get steamWishlistUnavailable =>
      'The Steam wishlist could not be read: check that your profile and wishlist are public.';

  @override
  String get discoveriesSearchHint => 'Title, author, starting item';

  @override
  String get filterNotWished => 'Not wished';

  @override
  String get filterRecent => 'Recent';

  @override
  String get noFilteredDiscoveries => 'No discovery matches the filters.';

  @override
  String get resetFilters => 'Clear the filters';

  @override
  String get releasesSearchHint => 'Title, series, artist';

  @override
  String get filterConfirmedDates => 'Confirmed dates';

  @override
  String get filterWished => 'Wished';

  @override
  String get releaseKindCardSet => 'Card sets';

  @override
  String get releaseKindNextVolume => 'Volumes';

  @override
  String get releaseKindAlbum => 'Albums';

  @override
  String get noFilteredReleases => 'No release matches the filters.';

  @override
  String get stepSearch => 'Search';

  @override
  String get stepCheck => 'Check';

  @override
  String get enterByHand => 'Enter by hand';

  @override
  String addToNamedCategory(String category) {
    return 'Add to $category';
  }

  @override
  String get moreDetails => 'More details';

  @override
  String get detailsSection => 'Details';

  @override
  String get coverSection => 'Cover';

  @override
  String volumeShort(int number) {
    return 'Vol. $number';
  }

  @override
  String get searchResultsEmpty =>
      'Type a title, scan a barcode, or enter the item by hand.';

  @override
  String get categoryTypeStepTitle => 'What will you shelve?';

  @override
  String get categoryDetailsStepTitle => 'Category details';

  @override
  String get continueAction => 'Continue';

  @override
  String get changeAction => 'Change';

  @override
  String get categoryPreviewEmpty => 'New category';

  @override
  String get categoryTypeLabel => 'Type';

  @override
  String get categoryDangerZone => 'Delete the category';

  @override
  String get categoryDangerZoneExplanation =>
      'Its items, series and subcategories go with it. This can’t be undone.';

  @override
  String get exportSpreadsheet => 'Export as a spreadsheet (CSV)';

  @override
  String exportSpreadsheetDone(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count items',
      one: '1 item',
    );
    return 'Collection exported: $_temp0.';
  }

  @override
  String get exportSpreadsheetFailed => 'The export could not be saved.';

  @override
  String get exportHeaders =>
      'Category|Subcategory|Title|Creator|Year|Publisher|Series|Volume|Platform|Edition|Barcode|Price paid|Purchase date|Bought|Location|Condition|Rating|Lent to|Estimated value|Currency|Added on';

  @override
  String get steamAlertsChannelName => 'Steam';

  @override
  String get steamAlertsChannelDescription =>
      'Sales and releases of your Steam wishes, new DLC for your games';

  @override
  String steamWishOnSaleTitle(String title) {
    return '$title is on sale';
  }

  @override
  String steamWishOnSaleBody(int percent, String price) {
    return '-$percent%: $price on Steam';
  }

  @override
  String steamWishReleasedTitle(String title) {
    return '$title is out';
  }

  @override
  String get steamWishReleasedBody =>
      'A game from your wishes is available on Steam.';

  @override
  String steamNewDlcTitle(String title) {
    return 'New DLC for $title';
  }

  @override
  String get steamNewDlcBodyUnnamed => 'New content is available on Steam.';

  @override
  String get steamWishComingSoon => 'Coming soon on Steam';

  @override
  String get priceAlertsChannelName => 'Price alerts';

  @override
  String get priceAlertsChannelDescription =>
      'When a sealed product\'s price crosses your threshold';

  @override
  String priceAlertAboveTitle(String title) {
    return '$title went above your threshold';
  }

  @override
  String priceAlertBelowTitle(String title) {
    return '$title went below your threshold';
  }

  @override
  String priceAlertBody(String price, String threshold) {
    return 'Cardmarket price: $price (threshold $threshold)';
  }

  @override
  String get priceAlert => 'Price alert';

  @override
  String get priceAlertAbove => 'Above';

  @override
  String get priceAlertBelow => 'Below';

  @override
  String get priceAlertThreshold => 'Threshold';

  @override
  String priceAlertSummary(String direction, String threshold) {
    return 'Alert $direction $threshold';
  }

  @override
  String get removePriceAlert => 'Remove the alert';

  @override
  String get displaySection => 'Display';

  @override
  String get highContrast => 'High contrast';

  @override
  String get highContrastExplanation =>
      'Brighter text and more visible borders, handy outdoors or in a shop.';

  @override
  String get recentSearches => 'Recent searches';

  @override
  String get forgetSearch => 'Remove this search';

  @override
  String get searchOnlineAction => 'Search online';

  @override
  String get sortByPricePaid => 'Price paid';

  @override
  String get sortByLocation => 'Location';

  @override
  String get filterLent => 'Lent';

  @override
  String get filtersTitle => 'Filters';

  @override
  String get clearArrangement => 'Clear sort and filters';

  @override
  String get valueOverTime => 'Value over time';

  @override
  String get lastSixMonths => '6 months';

  @override
  String get lastYear => '1 year';

  @override
  String get wholeHistory => 'All';

  @override
  String get valueHistoryFilling =>
      'The curve fills in month after month: the collection value is recorded at the start of each month.';

  @override
  String get valueHistoryNote =>
      'Cardmarket, Steam and card prices, recorded at the start of each month.';

  @override
  String get biggestRises => 'Biggest rises';

  @override
  String get biggestFalls => 'Biggest falls';

  @override
  String get missingVolumesTitle => 'Missing volumes';

  @override
  String get noMissingVolumes =>
      'All your series are complete up to the latest volume out.';

  @override
  String get youAreMissing => 'You are missing';

  @override
  String volumesInSeries(int volumes, int series) {
    String _temp0 = intl.Intl.pluralLogic(
      volumes,
      locale: localeName,
      other: 'volumes',
      one: 'volume',
    );
    String _temp1 = intl.Intl.pluralLogic(
      series,
      locale: localeName,
      other: '$series series',
      one: '1 series',
    );
    return '$_temp0 in $_temp1';
  }

  @override
  String wishAllMissing(int count) {
    return 'Add all to my wishes ($count)';
  }

  @override
  String missingVolumesWished(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count volumes added to your wishes',
      one: '1 volume added to your wishes',
      zero: 'Nothing new in your wishes',
    );
    return '$_temp0';
  }

  @override
  String ownedVolumesRun(int from, int to) {
    return 'Volumes $from to $to: owned';
  }

  @override
  String wishedVolumesRun(int from, int to) {
    return 'Volumes $from to $to: in your wishes';
  }

  @override
  String missingVolumesRun(int from, int to) {
    return 'Volumes $from to $to: missing, tap to wish them';
  }

  @override
  String ownedVolume(int number) {
    return 'Volume $number: owned';
  }

  @override
  String wishedVolume(int number) {
    return 'Volume $number: in your wishes';
  }

  @override
  String missingVolume(int number) {
    return 'Volume $number: missing, tap to wish it';
  }

  @override
  String get shelfRead => 'Shelf read';

  @override
  String get shelfPhotoGone => 'This shelf photo is no longer available.';

  @override
  String get tapFrameToFindLine => 'Tap a frame to find its line.';

  @override
  String get seeShelf => 'See the shelf';

  @override
  String get scanHistory => 'Scan history';

  @override
  String get noScanSessions => 'Your scan sessions will show up here.';

  @override
  String scanAddedCount(int count) {
    return '$count added';
  }

  @override
  String get scanGroupAdded => 'Added';

  @override
  String get scanGroupOwned => 'Already yours';

  @override
  String get scanGroupMissed => 'Not found';

  @override
  String get saveFailedRetry => 'Saving failed. Try again.';

  @override
  String get selectItem => 'Select';

  @override
  String get unselectItem => 'Unselect';

  @override
  String scanResultAnnouncement(String title, String status) {
    return '$title: $status';
  }

  @override
  String webImageNumber(int number) {
    return 'Web image $number';
  }

  @override
  String valueChartSummary(
    String first,
    String last,
    String lowest,
    String highest,
  ) {
    return 'Value curve: from $first to $last, lowest $lowest, highest $highest. Swipe up or down to change month.';
  }

  @override
  String get loadingInProgress => 'Loading';

  @override
  String get goalAllCategories => 'the whole collection';

  @override
  String goalFinishLabel(int target, String scope) {
    return 'Finish $target · $scope';
  }

  @override
  String goalAddLabel(int target, String scope) {
    return 'Add $target · $scope';
  }

  @override
  String get goalReached => 'Goal reached';

  @override
  String goalAhead(int count) {
    return '$count ahead';
  }

  @override
  String goalBehind(int count) {
    return '$count behind';
  }

  @override
  String get goalOnPace => 'Right on pace';

  @override
  String goalsOfYear(int year) {
    return '$year goals';
  }

  @override
  String get noGoalsYet =>
      'Set yourself a goal for the year: finish books, games, fill your shelves.';

  @override
  String get newGoal => 'New goal';

  @override
  String get deleteGoal => 'Delete the goal';

  @override
  String goalBarLabel(int done, int target, int expected) {
    return '$done of $target, $expected expected today';
  }

  @override
  String goalProjection(int count) {
    return 'At this pace: $count by the end of December';
  }

  @override
  String get goalMeasureFinished => 'Finish';

  @override
  String get goalMeasureAdded => 'Add';

  @override
  String get goalCategory => 'Category';

  @override
  String get goalTarget => 'How many this year';

  @override
  String get decrease => 'Less';

  @override
  String get increase => 'More';

  @override
  String get createGoal => 'Create the goal';

  @override
  String get tonightTitle => 'Tonight, I…';

  @override
  String get tonightAny => 'Anything';

  @override
  String get tonightRead => 'Read';

  @override
  String get tonightPlay => 'Play';

  @override
  String get tonightWatch => 'Watch';

  @override
  String get tonightListen => 'Listen';

  @override
  String get tonightAnyLength => 'Any length';

  @override
  String get tonightShort => 'Short';

  @override
  String get tonightMedium => 'Medium';

  @override
  String get tonightLong => 'Long';

  @override
  String get tonightAnother => 'Another';

  @override
  String get tonightStart => 'Start it';

  @override
  String tonightStarted(String title) {
    return '“$title” is in progress.';
  }

  @override
  String get tonightNothingWaiting =>
      'Nothing waiting: everything is started or finished.';

  @override
  String get tonightNothingMatches =>
      'Nothing matches these filters. Widen the length or activity.';

  @override
  String tonightWaitingSince(int months) {
    String _temp0 = intl.Intl.pluralLogic(
      months,
      locale: localeName,
      other: 'waiting for $months months',
      one: 'waiting for 1 month',
    );
    return '$_temp0';
  }

  @override
  String get monthlyRecap => 'Monthly recap';

  @override
  String get previousMonth => 'Previous month';

  @override
  String get nextMonth => 'Next month';

  @override
  String get recapEmptyMonth => 'Nothing added or finished that month.';

  @override
  String yearRecapOf(int year) {
    return '$year in review';
  }

  @override
  String get recapAdded => 'Added';

  @override
  String get recapSpent => 'Spent';

  @override
  String get recapFinished => 'Finished';

  @override
  String get recapSeriesCompleted => 'Series completed';

  @override
  String get recapMostValued => 'Most valued';

  @override
  String get recapValueChange => 'Value';

  @override
  String get recapBusiestMonth => 'Busiest month';

  @override
  String get recapTopValued => 'Most valued of the year';

  @override
  String get shareImage => 'Share the image';

  @override
  String get tonightMenu => 'Tonight, I…';

  @override
  String get goalsMenu => 'Goals';

  @override
  String get tagsTitle => 'Tags';

  @override
  String get saveFilterAsShelf => 'Save this filter as a shelf';

  @override
  String get saveFilterAsShelfHint =>
      'It will show at the top of home and fill itself.';

  @override
  String get smartShelfName => 'Shelf name';

  @override
  String smartShelfSaved(String name) {
    return 'Shelf “$name” added to home.';
  }

  @override
  String smartShelfLabel(String name, int count) {
    return 'Smart shelf $name, $count items';
  }

  @override
  String get smartShelfEmpty => 'Nothing matches this filter yet.';

  @override
  String get deleteSmartShelf => 'Delete the shelf';

  @override
  String get tagSigned => 'signed';

  @override
  String get tagToSell => 'to sell';

  @override
  String get tagGift => 'gift';

  @override
  String get tagToReread => 'to reread';

  @override
  String get tagLimitedEdition => 'limited edition';

  @override
  String get newTag => 'New tag';

  @override
  String get tagName => 'Tag name';

  @override
  String removeTag(String tag) {
    return 'Remove the tag $tag';
  }

  @override
  String addTag(String tag) {
    return 'Add the tag $tag';
  }

  @override
  String get storagePlan => 'Storage plan';

  @override
  String get storagePlanHint =>
      'Rooms, furniture and shelves: then pick where an item lives in two taps.';

  @override
  String get storagePlanEmpty =>
      'Start with a room, for example “Living room”.';

  @override
  String get newRoom => 'New room';

  @override
  String get newFurniture => 'New furniture';

  @override
  String get newShelf => 'New shelf';

  @override
  String get renamePlace => 'Rename';

  @override
  String get deletePlace => 'Delete';

  @override
  String get placeName => 'Name';

  @override
  String get placeNameHint => 'Living room, Bookcase, Shelf 3…';

  @override
  String placeItemCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count items',
      one: '1 item',
      zero: 'Empty',
    );
    return '$_temp0';
  }

  @override
  String placeActions(String name) {
    return 'Actions for $name';
  }

  @override
  String placeChildren(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count places',
      one: '1 place',
    );
    return '$_temp0';
  }

  @override
  String get chooseStoragePlace => 'Pick from the plan';

  @override
  String get goUp => 'Go up';

  @override
  String get storeHere => 'Store here';

  @override
  String get whereIs => 'Where is…?';

  @override
  String get whereIsHint => 'Title or author';

  @override
  String get whereIsNothing => 'Nothing in your collection has that name.';

  @override
  String lentToBorrower(String name) {
    return 'At $name\'s';
  }

  @override
  String get notStoredYet => 'Not stored yet: open the item to pick a place';

  @override
  String get journal => 'Journal';

  @override
  String get journalAdded => 'Added';

  @override
  String get journalSales => 'Sales';

  @override
  String get journalLoans => 'Loans';

  @override
  String get journalValues => 'Values';

  @override
  String get journalFinished => 'Finished';

  @override
  String get journalEmpty => 'Nothing to tell yet.';

  @override
  String get today => 'Today';

  @override
  String get yesterday => 'Yesterday';

  @override
  String get journalEntryAdded => 'Added to the collection';

  @override
  String get journalEntryReceived => 'Preorder received';

  @override
  String get journalEntryStarted => 'Started';

  @override
  String get journalEntryFinished => 'Finished';

  @override
  String journalEntrySold(String amount) {
    return 'Sold for $amount';
  }

  @override
  String journalEntryLent(String name) {
    return 'Lent to $name';
  }

  @override
  String journalEntryReturned(String name) {
    return 'Returned by $name';
  }

  @override
  String journalEntryValueRose(String amount) {
    return 'Value up $amount';
  }

  @override
  String journalEntryValueFell(String amount) {
    return 'Value down $amount';
  }

  @override
  String get journalEntryMerged => 'Duplicates merged';

  @override
  String wishUnderMaximumTitle(String title) {
    return '$title is under your maximum';
  }

  @override
  String wishUnderMaximumBody(String price, String maximum) {
    return '$price today, your maximum was $maximum.';
  }

  @override
  String get wishPriorityMustHave => 'Must have';

  @override
  String get wishPriorityWant => 'Want';

  @override
  String get wishPrioritySomeday => 'Someday';

  @override
  String get wishPriority => 'Priority';

  @override
  String get wishMaximumLabel => 'Maximum price';

  @override
  String get wishMaximumHelp =>
      'An alert when the value or a Steam sale goes below it.';

  @override
  String wishMaximumPrice(String price) {
    return 'Max $price';
  }

  @override
  String wishUnderYourMaximum(String price) {
    return 'Under your max of $price';
  }

  @override
  String get shareAsImage => 'Image';

  @override
  String get shareAsPdf => 'PDF';

  @override
  String get shareAsText => 'Share as text';

  @override
  String get wishlistColumnWish => 'Wish';

  @override
  String get wishlistColumnType => 'Type';

  @override
  String get budget => 'Budget';

  @override
  String get budgetAlertTitle => 'Monthly budget almost reached';

  @override
  String budgetAlertBody(String remaining, String ceiling) {
    return 'Only $remaining left of $ceiling this month.';
  }

  @override
  String budgetOverBody(String ceiling) {
    return 'The $ceiling ceiling is exceeded this month.';
  }

  @override
  String get budgetChannelName => 'Budget';

  @override
  String get budgetChannelDescription =>
      'Warns when monthly spending nears the ceiling.';

  @override
  String budgetLeft(String amount) {
    return '$amount left';
  }

  @override
  String budgetOverBy(String amount) {
    return 'Over by $amount';
  }

  @override
  String budgetOnlyLeft(String amount, int days) {
    return 'Only $amount left for the remaining $days days';
  }

  @override
  String budgetDaysLeft(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days days left',
      one: '1 day left',
      zero: 'last day',
    );
    return '$_temp0';
  }

  @override
  String budgetOutOf(String ceiling) {
    return 'of $ceiling';
  }

  @override
  String budgetGaugeLabel(int percent, int alert) {
    return '$percent% of the ceiling spent, alert at $alert%';
  }

  @override
  String get budgetNoCeiling =>
      'Set a ceiling to follow the month and be warned as you near it.';

  @override
  String get budgetSpendingOfMonth => 'This month\'s spending';

  @override
  String get budgetNothingSpent => 'No priced purchase this month.';

  @override
  String get budgetCeiling => 'Monthly ceiling';

  @override
  String get budgetCeilingHelp => 'Reset on the 1st of each month';

  @override
  String get budgetNone => 'None';

  @override
  String get budgetAlertAt => 'Warn me at';

  @override
  String get budgetAlertAtHelp => 'One notification, once a month';

  @override
  String get budgetCountSteam => 'Count Steam games';

  @override
  String get budgetCountSteamHelp =>
      'Purchase prices imported with the library';

  @override
  String get insuranceInventory => 'Insurance inventory';

  @override
  String get insuranceNothing => 'Add items to be able to list them.';

  @override
  String get insuranceIntro =>
      'A PDF to keep or send to your insurer: each item with its photo, purchase, estimated value and place.';

  @override
  String get insuranceCategories => 'Categories to include';

  @override
  String insuranceCategoryLine(int count, String value) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count items',
      one: '1 item',
    );
    return '$_temp0 · $value';
  }

  @override
  String get insuranceWithPhotos => 'With photos';

  @override
  String get insuranceWithPhotosHelp =>
      'A thumbnail per item, the file is heavier';

  @override
  String get insurancePreview => 'Preview';

  @override
  String insurancePages(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'about $count pages',
      one: 'about 1 page',
    );
    return '$_temp0';
  }

  @override
  String insuranceMoreLines(int count) {
    return 'and $count more…';
  }

  @override
  String insuranceItemCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count items',
      one: '1 item',
    );
    return '$_temp0';
  }

  @override
  String insuranceEstimatedTotal(String amount) {
    return '$amount estimated';
  }

  @override
  String get insuranceGenerate => 'Generate the PDF';

  @override
  String get insuranceGenerating => 'Generating…';

  @override
  String get insuranceDocumentTitle => 'Collection inventory';

  @override
  String insuranceDocumentSubtitle(String date, int count) {
    return 'Made on $date · $count items · estimated value: market value, else purchase price';
  }

  @override
  String get insuranceColumnItem => 'Item';

  @override
  String get insuranceColumnBought => 'Bought';

  @override
  String get insuranceColumnPaid => 'Paid';

  @override
  String get insuranceColumnEstimated => 'Estimated';

  @override
  String get insuranceItems => 'Items';

  @override
  String insuranceSubtotal(int count) {
    return 'Subtotal ($count)';
  }

  @override
  String get insuranceFooter =>
      'Values in euros, market values on export day. Made with Akashic.';

  @override
  String get notStoredYetShort => 'No place';

  @override
  String get loanInOneWeek => '1 week';

  @override
  String get loanInTwoWeeks => '2 weeks';

  @override
  String get loanInOneMonth => '1 month';

  @override
  String get loanNoDate => 'No date';

  @override
  String get loanPickDate => 'Other date';

  @override
  String get loanReturnBy => 'Return by';

  @override
  String loanDueOn(String date) {
    return 'Due back on $date';
  }

  @override
  String get loanRemindAtDue => 'Remind me when due';

  @override
  String get loanFollowUp => 'Then follow up';

  @override
  String get loanFollowUpHelp => 'A week later, if it still hasn\'t come back';

  @override
  String get loansLate => 'Late';

  @override
  String get loansOngoing => 'Ongoing';

  @override
  String loanLateBy(String name, int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days days late',
      one: '1 day late',
    );
    return 'At $name\'s · $_temp0';
  }

  @override
  String loanDueBy(String name, String date) {
    return 'At $name\'s · due $date';
  }

  @override
  String get calendarSync => 'Releases in the calendar';

  @override
  String get calendarSyncSwitch => 'Send releases to the calendar';

  @override
  String get calendarSyncSwitchHelp =>
      'An all-day event, editable from the calendar';

  @override
  String get calendarTarget => 'Calendar';

  @override
  String get calendarDefaultName => 'Collection';

  @override
  String get calendarKinds => 'Release types';

  @override
  String get calendarKindVolumes => 'Volumes';

  @override
  String get calendarKindAlbums => 'Albums';

  @override
  String get calendarKindCardSets => 'Card sets';

  @override
  String get calendarSubjects => 'By series or artist';

  @override
  String get calendarEventSettings => 'Event settings';

  @override
  String get calendarReminder => 'Reminder the evening before at 6 pm';

  @override
  String get calendarRemovedWhenAdded =>
      'The event is removed when the item joins your collection or the release goes away.';

  @override
  String get calendarPreview => 'Preview in the calendar';

  @override
  String get calendarNextSent => 'Next releases sent';

  @override
  String calendarEventTitle(String title) {
    return 'Release · $title';
  }

  @override
  String get calendarEventEstimated => 'Estimated date';

  @override
  String get calendarEventFooter => 'Added by Akashic';

  @override
  String calendarAllDay(String date) {
    return '$date · all day';
  }

  @override
  String get calendarAccessDenied =>
      'Without calendar access, releases cannot be added.';

  @override
  String get calendarSyncFailed => 'The calendar could not be updated.';

  @override
  String get tabletPickAnItem => 'Pick an item on the left to see it here.';

  @override
  String get voiceSearch => 'Search by voice';

  @override
  String get voiceListening => 'Listening…';

  @override
  String get voiceUnavailable =>
      'Speech recognition isn\'t available on this phone.';

  @override
  String get voiceTapToRetry => 'Tap the mic to speak';

  @override
  String get voiceStop => 'Stop listening';

  @override
  String get voiceHint => 'Say a title, an author, an artist…';

  @override
  String get voiceUseWords => 'Search this';

  @override
  String get offline => 'Offline';

  @override
  String get offlineExplained =>
      'Offline: the collection stays available, prices shown are from the last check.';

  @override
  String priceOn(String date) {
    return 'price on $date';
  }

  @override
  String preorderArrivesTodayTitle(String title) {
    return 'Arriving today: $title';
  }

  @override
  String preordersArriveTodayTitle(int count) {
    return '$count preorders arrive today';
  }

  @override
  String get preorderArrivesTodayBody =>
      'Tap “Received” on the item once you have it.';

  @override
  String get preorderChannelName => 'Preorders';

  @override
  String get preorderChannelDescription =>
      'Warns on the day a preorder is due.';

  @override
  String get preorderToday => 'Today';

  @override
  String preorderInDays(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'in $days days',
      one: 'in 1 day',
    );
    return '$_temp0';
  }

  @override
  String get preorderTitle => 'Preorder';

  @override
  String get preorderPickDate => 'Pick the delivery date';

  @override
  String preorderDeliveryOn(String date) {
    return 'Due on $date';
  }

  @override
  String get preorderDeposit => 'Deposit paid (optional)';

  @override
  String preorderDepositPaid(String amount) {
    return 'Deposit: $amount';
  }

  @override
  String get markPreordered => 'Mark as preordered';

  @override
  String get preordered => 'Preordered';

  @override
  String get preorderReceived => 'Received';

  @override
  String get preorderChangeDate => 'Change the date';

  @override
  String get preorderCancel => 'No longer a preorder';

  @override
  String get toReceive => 'To receive';

  @override
  String preorderDepositsTotal(String amount) {
    return '$amount in deposits paid';
  }

  @override
  String get mergeTitle => 'Merge duplicates';

  @override
  String get mergeAction => 'Merge';

  @override
  String get mergeKeepWhat =>
      'Pick what the merged item keeps, field by field.';

  @override
  String get mergeFieldTitle => 'Title';

  @override
  String get mergeFieldCover => 'Cover';

  @override
  String get mergeFieldPurchase => 'Purchase, condition and place';

  @override
  String get mergeFieldRating => 'Rating';

  @override
  String get mergeFieldProgress => 'Progress';

  @override
  String get mergeHasCover => 'Has a cover';

  @override
  String get mergeHasProgress => 'Progress tracked';

  @override
  String get mergeEmpty => 'empty';

  @override
  String get mergeJoinPhotos => 'Keep the photos of both items';

  @override
  String mergeResult(String title) {
    return 'Result: $title';
  }

  @override
  String get mergeConfirmTitle => 'Merge these two items?';

  @override
  String get mergeConfirmBody =>
      'Item B goes away: what you picked joins item A.';

  @override
  String get mergeDone => 'Duplicates merged.';

  @override
  String get deckValue => 'Deck value';

  @override
  String deckPricedCards(int priced, int total) {
    return '$priced of $total cards priced';
  }

  @override
  String deckPricedOn(String date) {
    return 'prices from $date';
  }

  @override
  String get deckPriciestCards => 'The priciest cards';

  @override
  String deckTopShare(int percent) {
    return 'They make $percent% of the deck\'s value.';
  }

  @override
  String trackSide(String side) {
    return 'Side $side';
  }

  @override
  String albumLength(String length) {
    return 'Total length: $length';
  }

  @override
  String get compareTitle => 'Compare with a friend';

  @override
  String get compareIntro =>
      'Ask for their export (Settings › Export the collection) and open the file here.';

  @override
  String get compareNothingSent =>
      'Nothing is sent: the comparison happens on your phone.';

  @override
  String get compareChooseFile => 'Choose their file';

  @override
  String get compareOtherFile => 'Another file';

  @override
  String get compareUnreadable =>
      'This file couldn\'t be read. A CSV or XLSX export is needed.';

  @override
  String compareCounts(int mine, int theirs) {
    return 'You: $mine · Your friend: $theirs';
  }

  @override
  String compareInCommon(int count) {
    return 'In common · $count';
  }

  @override
  String compareOnlyFriend(int count) {
    return 'They have · $count';
  }

  @override
  String compareOnlyMine(int count) {
    return 'You have · $count';
  }

  @override
  String compareExchangeIdeas(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count swap ideas',
      one: '1 swap idea',
    );
    return '$_temp0';
  }

  @override
  String get compareCopyList => 'Copy';

  @override
  String get compareCopied => 'List copied.';

  @override
  String get compareNothingHere => 'Nothing in this tab.';

  @override
  String get compareFillsMissing => 'you\'re missing it';

  @override
  String get compareInWishes => 'in your wishes';

  @override
  String get missingCovers => 'Missing covers';

  @override
  String get coverProposals => 'Proposals';

  @override
  String get noMissingCovers => 'All your items have a cover.';

  @override
  String itemsWithoutCover(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count items without a cover',
      one: '1 item without a cover',
    );
    return '$_temp0';
  }

  @override
  String searchCovers(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Find $count covers',
      one: 'Find 1 cover',
    );
    return '$_temp0';
  }

  @override
  String acceptAllCovers(int count) {
    return 'Accept all · $count';
  }

  @override
  String coverSearchProgress(int done, int total, int accepted) {
    return 'Searching: $done / $total · $accepted accepted';
  }

  @override
  String get coverSearching => 'Searching…';

  @override
  String get coverNothingFound => 'Nothing found';

  @override
  String get coverAccepted => 'Cover added';

  @override
  String get coverRefused => 'Skipped';

  @override
  String get coverAccept => 'Accept';

  @override
  String get coverRefuse => 'Refuse';

  @override
  String get coverAnother => 'Another image';
}
