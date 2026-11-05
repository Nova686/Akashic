import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_fr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'Localization/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('fr'),
  ];

  /// No description provided for @navCollection.
  ///
  /// In en, this message translates to:
  /// **'Collection'**
  String get navCollection;

  /// No description provided for @navCheck.
  ///
  /// In en, this message translates to:
  /// **'Got it?'**
  String get navCheck;

  /// No description provided for @navWishes.
  ///
  /// In en, this message translates to:
  /// **'Wishes'**
  String get navWishes;

  /// No description provided for @navDiscoveries.
  ///
  /// In en, this message translates to:
  /// **'Discoveries'**
  String get navDiscoveries;

  /// No description provided for @untitled.
  ///
  /// In en, this message translates to:
  /// **'Untitled'**
  String get untitled;

  /// No description provided for @conditionMint.
  ///
  /// In en, this message translates to:
  /// **'Mint'**
  String get conditionMint;

  /// No description provided for @conditionVeryGood.
  ///
  /// In en, this message translates to:
  /// **'Very good'**
  String get conditionVeryGood;

  /// No description provided for @conditionGood.
  ///
  /// In en, this message translates to:
  /// **'Good'**
  String get conditionGood;

  /// No description provided for @conditionFair.
  ///
  /// In en, this message translates to:
  /// **'Fair'**
  String get conditionFair;

  /// No description provided for @conditionDamaged.
  ///
  /// In en, this message translates to:
  /// **'Damaged'**
  String get conditionDamaged;

  /// No description provided for @conditionMissing.
  ///
  /// In en, this message translates to:
  /// **'Missing'**
  String get conditionMissing;

  /// No description provided for @partDisc.
  ///
  /// In en, this message translates to:
  /// **'Disc'**
  String get partDisc;

  /// No description provided for @partSleeve.
  ///
  /// In en, this message translates to:
  /// **'Sleeve'**
  String get partSleeve;

  /// No description provided for @partGame.
  ///
  /// In en, this message translates to:
  /// **'Game'**
  String get partGame;

  /// No description provided for @partBox.
  ///
  /// In en, this message translates to:
  /// **'Box'**
  String get partBox;

  /// No description provided for @partManual.
  ///
  /// In en, this message translates to:
  /// **'Manual'**
  String get partManual;

  /// No description provided for @partItem.
  ///
  /// In en, this message translates to:
  /// **'Item'**
  String get partItem;

  /// No description provided for @myCollection.
  ///
  /// In en, this message translates to:
  /// **'My collection'**
  String get myCollection;

  /// No description provided for @objectsInCategories.
  ///
  /// In en, this message translates to:
  /// **'{objects, plural, =1{1 item} other{{objects} items}} in {categories, plural, =1{1 category} other{{categories} categories}}'**
  String objectsInCategories(int objects, int categories);

  /// No description provided for @newCategory.
  ///
  /// In en, this message translates to:
  /// **'New category'**
  String get newCategory;

  /// No description provided for @categoryName.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get categoryName;

  /// No description provided for @fillInfoFrom.
  ///
  /// In en, this message translates to:
  /// **'Fill in info from'**
  String get fillInfoFrom;

  /// No description provided for @categoryTypeMusic.
  ///
  /// In en, this message translates to:
  /// **'Music'**
  String get categoryTypeMusic;

  /// No description provided for @categoryTypeBooks.
  ///
  /// In en, this message translates to:
  /// **'Books'**
  String get categoryTypeBooks;

  /// No description provided for @categoryTypeManga.
  ///
  /// In en, this message translates to:
  /// **'Manga'**
  String get categoryTypeManga;

  /// No description provided for @categoryTypeComics.
  ///
  /// In en, this message translates to:
  /// **'Comics'**
  String get categoryTypeComics;

  /// No description provided for @categoryTypeFilms.
  ///
  /// In en, this message translates to:
  /// **'Films'**
  String get categoryTypeFilms;

  /// No description provided for @categoryTypeVideoGames.
  ///
  /// In en, this message translates to:
  /// **'Video games'**
  String get categoryTypeVideoGames;

  /// No description provided for @categoryTypeCards.
  ///
  /// In en, this message translates to:
  /// **'Cards'**
  String get categoryTypeCards;

  /// No description provided for @categoryTypeFree.
  ///
  /// In en, this message translates to:
  /// **'Custom'**
  String get categoryTypeFree;

  /// No description provided for @subcategories.
  ///
  /// In en, this message translates to:
  /// **'Subcategories'**
  String get subcategories;

  /// No description provided for @addSubcategory.
  ///
  /// In en, this message translates to:
  /// **'Add a subcategory'**
  String get addSubcategory;

  /// No description provided for @subcategoryName.
  ///
  /// In en, this message translates to:
  /// **'Subcategory name'**
  String get subcategoryName;

  /// No description provided for @conditionRatedOn.
  ///
  /// In en, this message translates to:
  /// **'Condition rated on'**
  String get conditionRatedOn;

  /// No description provided for @addPart.
  ///
  /// In en, this message translates to:
  /// **'Add a part'**
  String get addPart;

  /// No description provided for @partName.
  ///
  /// In en, this message translates to:
  /// **'Part name'**
  String get partName;

  /// No description provided for @createCategory.
  ///
  /// In en, this message translates to:
  /// **'Create category'**
  String get createCategory;

  /// No description provided for @categoryNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Give the category a name.'**
  String get categoryNameRequired;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @appLanguage.
  ///
  /// In en, this message translates to:
  /// **'App language'**
  String get appLanguage;

  /// No description provided for @followDevice.
  ///
  /// In en, this message translates to:
  /// **'Same as the phone'**
  String get followDevice;

  /// No description provided for @preferredTitleLanguages.
  ///
  /// In en, this message translates to:
  /// **'Preferred title languages'**
  String get preferredTitleLanguages;

  /// No description provided for @preferredTitleLanguagesHint.
  ///
  /// In en, this message translates to:
  /// **'Titles are shown in the first available language of this list.'**
  String get preferredTitleLanguagesHint;

  /// No description provided for @addLanguage.
  ///
  /// In en, this message translates to:
  /// **'Add a language'**
  String get addLanguage;

  /// No description provided for @lastLanguageRefused.
  ///
  /// In en, this message translates to:
  /// **'Keep at least one language.'**
  String get lastLanguageRefused;

  /// No description provided for @languageFr.
  ///
  /// In en, this message translates to:
  /// **'French'**
  String get languageFr;

  /// No description provided for @languageEn.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get languageEn;

  /// No description provided for @languageJa.
  ///
  /// In en, this message translates to:
  /// **'Japanese'**
  String get languageJa;

  /// No description provided for @languageEs.
  ///
  /// In en, this message translates to:
  /// **'Spanish'**
  String get languageEs;

  /// No description provided for @languageDe.
  ///
  /// In en, this message translates to:
  /// **'German'**
  String get languageDe;

  /// No description provided for @languageIt.
  ///
  /// In en, this message translates to:
  /// **'Italian'**
  String get languageIt;

  /// No description provided for @languageKo.
  ///
  /// In en, this message translates to:
  /// **'Korean'**
  String get languageKo;

  /// No description provided for @languageZh.
  ///
  /// In en, this message translates to:
  /// **'Chinese'**
  String get languageZh;

  /// No description provided for @languagePt.
  ///
  /// In en, this message translates to:
  /// **'Portuguese'**
  String get languagePt;

  /// No description provided for @addItem.
  ///
  /// In en, this message translates to:
  /// **'Add an item'**
  String get addItem;

  /// No description provided for @titles.
  ///
  /// In en, this message translates to:
  /// **'Titles'**
  String get titles;

  /// No description provided for @originalLanguage.
  ///
  /// In en, this message translates to:
  /// **'Original'**
  String get originalLanguage;

  /// No description provided for @creator.
  ///
  /// In en, this message translates to:
  /// **'Artist or author'**
  String get creator;

  /// No description provided for @year.
  ///
  /// In en, this message translates to:
  /// **'Year'**
  String get year;

  /// No description provided for @publisher.
  ///
  /// In en, this message translates to:
  /// **'Publisher or label'**
  String get publisher;

  /// No description provided for @image.
  ///
  /// In en, this message translates to:
  /// **'Image'**
  String get image;

  /// No description provided for @imageFromInternet.
  ///
  /// In en, this message translates to:
  /// **'On the internet'**
  String get imageFromInternet;

  /// No description provided for @comingSoon.
  ///
  /// In en, this message translates to:
  /// **'Coming soon'**
  String get comingSoon;

  /// No description provided for @imageFromPhone.
  ///
  /// In en, this message translates to:
  /// **'From my phone'**
  String get imageFromPhone;

  /// No description provided for @takePhoto.
  ///
  /// In en, this message translates to:
  /// **'Take a photo'**
  String get takePhoto;

  /// No description provided for @chooseFromGallery.
  ///
  /// In en, this message translates to:
  /// **'Choose from the gallery'**
  String get chooseFromGallery;

  /// No description provided for @spineColor.
  ///
  /// In en, this message translates to:
  /// **'Spine color'**
  String get spineColor;

  /// No description provided for @partOfSeries.
  ///
  /// In en, this message translates to:
  /// **'Part of a series'**
  String get partOfSeries;

  /// No description provided for @newSeries.
  ///
  /// In en, this message translates to:
  /// **'New series'**
  String get newSeries;

  /// No description provided for @volumeFrom.
  ///
  /// In en, this message translates to:
  /// **'From volume'**
  String get volumeFrom;

  /// No description provided for @volumeTo.
  ///
  /// In en, this message translates to:
  /// **'To volume'**
  String get volumeTo;

  /// No description provided for @volumeRangeInvalid.
  ///
  /// In en, this message translates to:
  /// **'Check the volume numbers.'**
  String get volumeRangeInvalid;

  /// No description provided for @titleRequired.
  ///
  /// In en, this message translates to:
  /// **'Give at least one title.'**
  String get titleRequired;

  /// No description provided for @myRating.
  ///
  /// In en, this message translates to:
  /// **'My rating'**
  String get myRating;

  /// No description provided for @addToCollection.
  ///
  /// In en, this message translates to:
  /// **'Add to my collection'**
  String get addToCollection;

  /// No description provided for @edition.
  ///
  /// In en, this message translates to:
  /// **'Edition'**
  String get edition;

  /// No description provided for @pricePaid.
  ///
  /// In en, this message translates to:
  /// **'Price paid'**
  String get pricePaid;

  /// No description provided for @storedAt.
  ///
  /// In en, this message translates to:
  /// **'Stored at'**
  String get storedAt;

  /// No description provided for @condition.
  ///
  /// In en, this message translates to:
  /// **'Condition'**
  String get condition;

  /// No description provided for @priceInvalid.
  ///
  /// In en, this message translates to:
  /// **'Enter a price like 28.50.'**
  String get priceInvalid;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @editCopy.
  ///
  /// In en, this message translates to:
  /// **'Edit the details'**
  String get editCopy;

  /// No description provided for @searchCollection.
  ///
  /// In en, this message translates to:
  /// **'Search my collection'**
  String get searchCollection;

  /// No description provided for @allSubcategories.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get allSubcategories;

  /// No description provided for @foldAll.
  ///
  /// In en, this message translates to:
  /// **'Fold all'**
  String get foldAll;

  /// No description provided for @unfoldAll.
  ///
  /// In en, this message translates to:
  /// **'Unfold all'**
  String get unfoldAll;

  /// No description provided for @addFirstItem.
  ///
  /// In en, this message translates to:
  /// **'Add your first item'**
  String get addFirstItem;

  /// No description provided for @emptyShelf.
  ///
  /// In en, this message translates to:
  /// **'Nothing on this shelf yet.'**
  String get emptyShelf;

  /// No description provided for @noSearchResults.
  ///
  /// In en, this message translates to:
  /// **'Nothing found in your collection.'**
  String get noSearchResults;

  /// No description provided for @emptyCollection.
  ///
  /// In en, this message translates to:
  /// **'Create your first category to start your shelves.'**
  String get emptyCollection;

  /// No description provided for @seriesToComplete.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 series to complete} other{{count} series to complete}}'**
  String seriesToComplete(int count);

  /// No description provided for @myInfo.
  ///
  /// In en, this message translates to:
  /// **'My info'**
  String get myInfo;

  /// No description provided for @learnMore.
  ///
  /// In en, this message translates to:
  /// **'Learn more'**
  String get learnMore;

  /// No description provided for @titleVariants.
  ///
  /// In en, this message translates to:
  /// **'Title variants'**
  String get titleVariants;

  /// No description provided for @myCopies.
  ///
  /// In en, this message translates to:
  /// **'Purchase, condition and storage'**
  String get myCopies;

  /// No description provided for @copyWithoutDetails.
  ///
  /// In en, this message translates to:
  /// **'No details yet'**
  String get copyWithoutDetails;

  /// No description provided for @partCondition.
  ///
  /// In en, this message translates to:
  /// **'{part}: {condition}'**
  String partCondition(String part, String condition);

  /// No description provided for @saveFailed.
  ///
  /// In en, this message translates to:
  /// **'Saving failed. Check the category and try again.'**
  String get saveFailed;

  /// No description provided for @photographCover.
  ///
  /// In en, this message translates to:
  /// **'Photograph the cover'**
  String get photographCover;

  /// No description provided for @seeItem.
  ///
  /// In en, this message translates to:
  /// **'See the item'**
  String get seeItem;

  /// No description provided for @checking.
  ///
  /// In en, this message translates to:
  /// **'Checking…'**
  String get checking;

  /// No description provided for @searchOnline.
  ///
  /// In en, this message translates to:
  /// **'Search online'**
  String get searchOnline;

  /// No description provided for @webImages.
  ///
  /// In en, this message translates to:
  /// **'Images found online'**
  String get webImages;

  /// No description provided for @creatorArtist.
  ///
  /// In en, this message translates to:
  /// **'Artist'**
  String get creatorArtist;

  /// No description provided for @creatorAuthor.
  ///
  /// In en, this message translates to:
  /// **'Author'**
  String get creatorAuthor;

  /// No description provided for @creatorDirector.
  ///
  /// In en, this message translates to:
  /// **'Director'**
  String get creatorDirector;

  /// No description provided for @creatorStudio.
  ///
  /// In en, this message translates to:
  /// **'Studio'**
  String get creatorStudio;

  /// No description provided for @publisherLabel.
  ///
  /// In en, this message translates to:
  /// **'Label'**
  String get publisherLabel;

  /// No description provided for @publisherName.
  ///
  /// In en, this message translates to:
  /// **'Publisher'**
  String get publisherName;

  /// No description provided for @platformConsole.
  ///
  /// In en, this message translates to:
  /// **'Platform (console)'**
  String get platformConsole;

  /// No description provided for @editItem.
  ///
  /// In en, this message translates to:
  /// **'Edit item'**
  String get editItem;

  /// No description provided for @editAction.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get editAction;

  /// No description provided for @chainResolving.
  ///
  /// In en, this message translates to:
  /// **'Searching…'**
  String get chainResolving;

  /// No description provided for @chainFound.
  ///
  /// In en, this message translates to:
  /// **'Not yours yet'**
  String get chainFound;

  /// No description provided for @chainAlreadyOwned.
  ///
  /// In en, this message translates to:
  /// **'Already yours'**
  String get chainAlreadyOwned;

  /// No description provided for @chainNotFound.
  ///
  /// In en, this message translates to:
  /// **'Not found'**
  String get chainNotFound;

  /// No description provided for @addScannedItems.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{Nothing to add} =1{Add 1 item} other{Add {count} items}}'**
  String addScannedItems(int count);

  /// No description provided for @scannedItemsAdded.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 item added} other{{count} items added}}'**
  String scannedItemsAdded(int count);

  /// No description provided for @scanBarcode.
  ///
  /// In en, this message translates to:
  /// **'Scan a barcode'**
  String get scanBarcode;

  /// No description provided for @barcodeValue.
  ///
  /// In en, this message translates to:
  /// **'Barcode: {code}'**
  String barcodeValue(String code);

  /// No description provided for @toComplete.
  ///
  /// In en, this message translates to:
  /// **'To complete'**
  String get toComplete;

  /// No description provided for @publishedVolumes.
  ///
  /// In en, this message translates to:
  /// **'Published volumes'**
  String get publishedVolumes;

  /// No description provided for @updateFromAniList.
  ///
  /// In en, this message translates to:
  /// **'Update from AniList'**
  String get updateFromAniList;

  /// No description provided for @updateFailed.
  ///
  /// In en, this message translates to:
  /// **'The update failed. Check the network and try again.'**
  String get updateFailed;

  /// No description provided for @ownedVolumes.
  ///
  /// In en, this message translates to:
  /// **'My volumes'**
  String get ownedVolumes;

  /// No description provided for @seeSeries.
  ///
  /// In en, this message translates to:
  /// **'See the series'**
  String get seeSeries;

  /// No description provided for @missingVolumesList.
  ///
  /// In en, this message translates to:
  /// **'Missing: {volumes}'**
  String missingVolumesList(String volumes);

  /// No description provided for @nextNotReleased.
  ///
  /// In en, this message translates to:
  /// **'Volume {number} is not out yet.'**
  String nextNotReleased(int number);

  /// No description provided for @ownedOfPublished.
  ///
  /// In en, this message translates to:
  /// **'{owned} / {published} published'**
  String ownedOfPublished(int owned, int published);

  /// No description provided for @cardKindExtension.
  ///
  /// In en, this message translates to:
  /// **'Extension'**
  String get cardKindExtension;

  /// No description provided for @cardKindDeck.
  ///
  /// In en, this message translates to:
  /// **'Deck'**
  String get cardKindDeck;

  /// No description provided for @editDeck.
  ///
  /// In en, this message translates to:
  /// **'Edit the deck'**
  String get editDeck;

  /// No description provided for @searchCard.
  ///
  /// In en, this message translates to:
  /// **'Search a card'**
  String get searchCard;

  /// No description provided for @deckCardsCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 card in the deck} other{{count} cards in the deck}}'**
  String deckCardsCount(int count);

  /// No description provided for @fetchDetails.
  ///
  /// In en, this message translates to:
  /// **'Get the details'**
  String get fetchDetails;

  /// No description provided for @updateDetails.
  ///
  /// In en, this message translates to:
  /// **'Update'**
  String get updateDetails;

  /// No description provided for @fetchedOn.
  ///
  /// In en, this message translates to:
  /// **'Fetched on {date}'**
  String fetchedOn(String date);

  /// No description provided for @detailsUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Couldn’t fetch the details. Check the network and try again.'**
  String get detailsUnavailable;

  /// No description provided for @noDetailsYet.
  ///
  /// In en, this message translates to:
  /// **'Nothing fetched yet.'**
  String get noDetailsYet;

  /// No description provided for @sectionSummary.
  ///
  /// In en, this message translates to:
  /// **'Summary'**
  String get sectionSummary;

  /// No description provided for @sectionTracks.
  ///
  /// In en, this message translates to:
  /// **'Tracks'**
  String get sectionTracks;

  /// No description provided for @sectionGenres.
  ///
  /// In en, this message translates to:
  /// **'Genres'**
  String get sectionGenres;

  /// No description provided for @sectionLinks.
  ///
  /// In en, this message translates to:
  /// **'Links'**
  String get sectionLinks;

  /// No description provided for @factLabel.
  ///
  /// In en, this message translates to:
  /// **'Label'**
  String get factLabel;

  /// No description provided for @factStatus.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get factStatus;

  /// No description provided for @factVolumes.
  ///
  /// In en, this message translates to:
  /// **'Volumes'**
  String get factVolumes;

  /// No description provided for @factChapters.
  ///
  /// In en, this message translates to:
  /// **'Chapters'**
  String get factChapters;

  /// No description provided for @factRuntime.
  ///
  /// In en, this message translates to:
  /// **'Runtime'**
  String get factRuntime;

  /// No description provided for @factDirector.
  ///
  /// In en, this message translates to:
  /// **'Director'**
  String get factDirector;

  /// No description provided for @factStudio.
  ///
  /// In en, this message translates to:
  /// **'Studio'**
  String get factStudio;

  /// No description provided for @factPlatforms.
  ///
  /// In en, this message translates to:
  /// **'Platforms'**
  String get factPlatforms;

  /// No description provided for @sectionFacts.
  ///
  /// In en, this message translates to:
  /// **'Facts'**
  String get sectionFacts;

  /// No description provided for @factLine.
  ///
  /// In en, this message translates to:
  /// **'{label}: {value}'**
  String factLine(String label, String value);

  /// No description provided for @publicationStatusFinished.
  ///
  /// In en, this message translates to:
  /// **'Finished'**
  String get publicationStatusFinished;

  /// No description provided for @publicationStatusReleasing.
  ///
  /// In en, this message translates to:
  /// **'Ongoing'**
  String get publicationStatusReleasing;

  /// No description provided for @publicationStatusNotYetReleased.
  ///
  /// In en, this message translates to:
  /// **'Not yet released'**
  String get publicationStatusNotYetReleased;

  /// No description provided for @publicationStatusCancelled.
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get publicationStatusCancelled;

  /// No description provided for @publicationStatusHiatus.
  ///
  /// In en, this message translates to:
  /// **'On hiatus'**
  String get publicationStatusHiatus;

  /// No description provided for @wishesEmpty.
  ///
  /// In en, this message translates to:
  /// **'No wishes yet. Add some from a check, a search, a discovery or a series.'**
  String get wishesEmpty;

  /// No description provided for @wishOriginDiscovery.
  ///
  /// In en, this message translates to:
  /// **'From a discovery'**
  String get wishOriginDiscovery;

  /// No description provided for @wishOriginSearch.
  ///
  /// In en, this message translates to:
  /// **'From a search'**
  String get wishOriginSearch;

  /// No description provided for @wishOriginMissingVolume.
  ///
  /// In en, this message translates to:
  /// **'Missing volume'**
  String get wishOriginMissingVolume;

  /// No description provided for @wishOriginManual.
  ///
  /// In en, this message translates to:
  /// **'Added by hand'**
  String get wishOriginManual;

  /// No description provided for @wishFulfilled.
  ///
  /// In en, this message translates to:
  /// **'{title} is in your collection, removed from your wishes.'**
  String wishFulfilled(String title);

  /// No description provided for @addToWishes.
  ///
  /// In en, this message translates to:
  /// **'Add to my wishes'**
  String get addToWishes;

  /// No description provided for @addedToWishes.
  ///
  /// In en, this message translates to:
  /// **'Added to your wishes.'**
  String get addedToWishes;

  /// No description provided for @wishRemoved.
  ///
  /// In en, this message translates to:
  /// **'Wish removed.'**
  String get wishRemoved;

  /// No description provided for @removeWish.
  ///
  /// In en, this message translates to:
  /// **'Remove from my wishes'**
  String get removeWish;

  /// No description provided for @wishVolumeTitle.
  ///
  /// In en, this message translates to:
  /// **'{title}, vol. {number}'**
  String wishVolumeTitle(String title, int number);

  /// No description provided for @addMissingToWishes.
  ///
  /// In en, this message translates to:
  /// **'Add the missing volumes to my wishes'**
  String get addMissingToWishes;

  /// No description provided for @missingAddedToWishes.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{These volumes were already in your wishes} =1{1 volume added to your wishes} other{{count} volumes added to your wishes}}'**
  String missingAddedToWishes(int count);

  /// No description provided for @wished.
  ///
  /// In en, this message translates to:
  /// **'Wished'**
  String get wished;

  /// No description provided for @allTypes.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get allTypes;

  /// No description provided for @becauseYouHave.
  ///
  /// In en, this message translates to:
  /// **'Because you have {title}'**
  String becauseYouHave(String title);

  /// No description provided for @discoveriesComputedOn.
  ///
  /// In en, this message translates to:
  /// **'Computed on {date}'**
  String discoveriesComputedOn(String date);

  /// No description provided for @discoveriesOffline.
  ///
  /// In en, this message translates to:
  /// **'No network: here are the last discoveries kept.'**
  String get discoveriesOffline;

  /// No description provided for @discoveriesOfflineEmpty.
  ///
  /// In en, this message translates to:
  /// **'No network. Discoveries will come back with the connection.'**
  String get discoveriesOfflineEmpty;

  /// No description provided for @discoveriesNeedSeeds.
  ///
  /// In en, this message translates to:
  /// **'Add items found online (with their source) to get discoveries.'**
  String get discoveriesNeedSeeds;

  /// No description provided for @discoveriesNothingNew.
  ///
  /// In en, this message translates to:
  /// **'Nothing new for now.'**
  String get discoveriesNothingNew;

  /// No description provided for @notForMe.
  ///
  /// In en, this message translates to:
  /// **'Not for me'**
  String get notForMe;

  /// No description provided for @addWishShort.
  ///
  /// In en, this message translates to:
  /// **'+ Wish'**
  String get addWishShort;

  /// No description provided for @refreshDiscoveries.
  ///
  /// In en, this message translates to:
  /// **'Refresh the discoveries'**
  String get refreshDiscoveries;

  /// No description provided for @suggestionDismissed.
  ///
  /// In en, this message translates to:
  /// **'It won’t be suggested again.'**
  String get suggestionDismissed;

  /// No description provided for @wishesFulfilled.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 wish is in your collection, removed from your wishes.} other{{count} wishes are in your collection, removed from your wishes.}}'**
  String wishesFulfilled(int count);

  /// No description provided for @wishOriginOn.
  ///
  /// In en, this message translates to:
  /// **'{origin} · {date}'**
  String wishOriginOn(String origin, String date);

  /// No description provided for @newChapterNotificationTitle.
  ///
  /// In en, this message translates to:
  /// **'{title}: new chapter'**
  String newChapterNotificationTitle(String title);

  /// No description provided for @newChaptersNotificationBody.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Chapter {chapters} is out} other{Chapters {chapters} are out}}'**
  String newChaptersNotificationBody(int count, String chapters);

  /// No description provided for @scanAlertsChannelName.
  ///
  /// In en, this message translates to:
  /// **'New chapters'**
  String get scanAlertsChannelName;

  /// No description provided for @scanAlertsChannelDescription.
  ///
  /// In en, this message translates to:
  /// **'Alerts when a followed series gets a new chapter.'**
  String get scanAlertsChannelDescription;

  /// No description provided for @physicalTab.
  ///
  /// In en, this message translates to:
  /// **'Physical'**
  String get physicalTab;

  /// No description provided for @scansTab.
  ///
  /// In en, this message translates to:
  /// **'Scans'**
  String get scansTab;

  /// No description provided for @notFollowedInScans.
  ///
  /// In en, this message translates to:
  /// **'You don’t follow this series in scans yet.'**
  String get notFollowedInScans;

  /// No description provided for @followInScans.
  ///
  /// In en, this message translates to:
  /// **'Follow in scans'**
  String get followInScans;

  /// No description provided for @stopFollowingInScans.
  ///
  /// In en, this message translates to:
  /// **'Stop following in scans'**
  String get stopFollowingInScans;

  /// No description provided for @lastChapterRead.
  ///
  /// In en, this message translates to:
  /// **'Last chapter read'**
  String get lastChapterRead;

  /// No description provided for @newChaptersCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{Up to date} =1{1 new chapter} other{{count} new chapters}}'**
  String newChaptersCount(int count);

  /// No description provided for @readUpToChapter.
  ///
  /// In en, this message translates to:
  /// **'Read up to chapter…'**
  String get readUpToChapter;

  /// No description provided for @markRead.
  ///
  /// In en, this message translates to:
  /// **'Mark'**
  String get markRead;

  /// No description provided for @chaptersRead.
  ///
  /// In en, this message translates to:
  /// **'Chapters'**
  String get chaptersRead;

  /// No description provided for @showAllChapters.
  ///
  /// In en, this message translates to:
  /// **'Show all chapters'**
  String get showAllChapters;

  /// No description provided for @readingSite.
  ///
  /// In en, this message translates to:
  /// **'Reading site (link)'**
  String get readingSite;

  /// No description provided for @openReadingSite.
  ///
  /// In en, this message translates to:
  /// **'Open the reading site'**
  String get openReadingSite;

  /// No description provided for @translationTeam.
  ///
  /// In en, this message translates to:
  /// **'Translation team'**
  String get translationTeam;

  /// No description provided for @linkedToMangaUpdates.
  ///
  /// In en, this message translates to:
  /// **'Linked to MangaUpdates'**
  String get linkedToMangaUpdates;

  /// No description provided for @unlinkMangaUpdates.
  ///
  /// In en, this message translates to:
  /// **'Unlink'**
  String get unlinkMangaUpdates;

  /// No description provided for @searchMangaUpdates.
  ///
  /// In en, this message translates to:
  /// **'Find this series on MangaUpdates'**
  String get searchMangaUpdates;

  /// No description provided for @manualTrackingHint.
  ///
  /// In en, this message translates to:
  /// **'Without MangaUpdates, tracking stays manual and there are no alerts.'**
  String get manualTrackingHint;

  /// No description provided for @checkReleases.
  ///
  /// In en, this message translates to:
  /// **'Check new chapters'**
  String get checkReleases;

  /// No description provided for @chapterAlerts.
  ///
  /// In en, this message translates to:
  /// **'Alert me when a chapter comes out'**
  String get chapterAlerts;

  /// No description provided for @onlyMyTeam.
  ///
  /// In en, this message translates to:
  /// **'Only my team’s releases'**
  String get onlyMyTeam;

  /// No description provided for @releasesCheckFailed.
  ///
  /// In en, this message translates to:
  /// **'MangaUpdates can’t be reached. Try again later.'**
  String get releasesCheckFailed;

  /// No description provided for @notificationsRefused.
  ///
  /// In en, this message translates to:
  /// **'Notifications are turned off for Akashic in the phone settings.'**
  String get notificationsRefused;

  /// No description provided for @noReleaseSeriesFound.
  ///
  /// In en, this message translates to:
  /// **'No series found.'**
  String get noReleaseSeriesFound;

  /// No description provided for @noScanFollows.
  ///
  /// In en, this message translates to:
  /// **'No series followed in scans yet.'**
  String get noScanFollows;

  /// No description provided for @followSeriesInScans.
  ///
  /// In en, this message translates to:
  /// **'Follow a series in scans'**
  String get followSeriesInScans;

  /// No description provided for @newSeriesTitle.
  ///
  /// In en, this message translates to:
  /// **'New series title'**
  String get newSeriesTitle;

  /// No description provided for @createAndFollow.
  ///
  /// In en, this message translates to:
  /// **'Create and follow'**
  String get createAndFollow;

  /// No description provided for @lastReadChapterShort.
  ///
  /// In en, this message translates to:
  /// **'Last read: chapter {chapter}'**
  String lastReadChapterShort(String chapter);

  /// No description provided for @nothingReadYet.
  ///
  /// In en, this message translates to:
  /// **'Nothing read yet'**
  String get nothingReadYet;

  /// No description provided for @stopFollowingQuestion.
  ///
  /// In en, this message translates to:
  /// **'Stop following this series in scans? Your read chapters are kept.'**
  String get stopFollowingQuestion;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @loans.
  ///
  /// In en, this message translates to:
  /// **'Current loans'**
  String get loans;

  /// No description provided for @noLoans.
  ///
  /// In en, this message translates to:
  /// **'Nothing is lent at the moment.'**
  String get noLoans;

  /// No description provided for @lendCopy.
  ///
  /// In en, this message translates to:
  /// **'Lend'**
  String get lendCopy;

  /// No description provided for @returnCopy.
  ///
  /// In en, this message translates to:
  /// **'Returned'**
  String get returnCopy;

  /// No description provided for @borrowerName.
  ///
  /// In en, this message translates to:
  /// **'Lent to'**
  String get borrowerName;

  /// No description provided for @lentToSince.
  ///
  /// In en, this message translates to:
  /// **'Lent to {borrower} since {date}'**
  String lentToSince(String borrower, String date);

  /// No description provided for @statistics.
  ///
  /// In en, this message translates to:
  /// **'Statistics'**
  String get statistics;

  /// No description provided for @totalPaid.
  ///
  /// In en, this message translates to:
  /// **'Total paid'**
  String get totalPaid;

  /// No description provided for @byCategory.
  ///
  /// In en, this message translates to:
  /// **'By category'**
  String get byCategory;

  /// No description provided for @purchasesByMonth.
  ///
  /// In en, this message translates to:
  /// **'Purchases by month'**
  String get purchasesByMonth;

  /// No description provided for @noStatsYet.
  ///
  /// In en, this message translates to:
  /// **'Add items to see your statistics.'**
  String get noStatsYet;

  /// No description provided for @monthSummary.
  ///
  /// In en, this message translates to:
  /// **'{month}: {count, plural, =0{no purchase} =1{1 item} other{{count} items}}, {amount}'**
  String monthSummary(String month, int count, String amount);

  /// No description provided for @importCollection.
  ///
  /// In en, this message translates to:
  /// **'Import a spreadsheet'**
  String get importCollection;

  /// No description provided for @importDestination.
  ///
  /// In en, this message translates to:
  /// **'Destination category'**
  String get importDestination;

  /// No description provided for @chooseSpreadsheet.
  ///
  /// In en, this message translates to:
  /// **'Choose a file (.xlsx, .csv)'**
  String get chooseSpreadsheet;

  /// No description provided for @downloadTemplate.
  ///
  /// In en, this message translates to:
  /// **'Download the template'**
  String get downloadTemplate;

  /// No description provided for @templateSaved.
  ///
  /// In en, this message translates to:
  /// **'Template saved.'**
  String get templateSaved;

  /// No description provided for @unreadableSpreadsheet.
  ///
  /// In en, this message translates to:
  /// **'This file can’t be read. Use a .xlsx or .csv file.'**
  String get unreadableSpreadsheet;

  /// No description provided for @matchColumns.
  ///
  /// In en, this message translates to:
  /// **'Match the columns'**
  String get matchColumns;

  /// No description provided for @continueWithRows.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{No row to import} =1{Continue with 1 row} other{Continue with {count} rows}}'**
  String continueWithRows(int count);

  /// No description provided for @importFieldIgnored.
  ///
  /// In en, this message translates to:
  /// **'Ignore'**
  String get importFieldIgnored;

  /// No description provided for @importFieldTitle.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get importFieldTitle;

  /// No description provided for @importFieldCreator.
  ///
  /// In en, this message translates to:
  /// **'Artist or author'**
  String get importFieldCreator;

  /// No description provided for @importFieldBarcode.
  ///
  /// In en, this message translates to:
  /// **'Barcode'**
  String get importFieldBarcode;

  /// No description provided for @importFieldEdition.
  ///
  /// In en, this message translates to:
  /// **'Edition'**
  String get importFieldEdition;

  /// No description provided for @importFieldPrice.
  ///
  /// In en, this message translates to:
  /// **'Price paid'**
  String get importFieldPrice;

  /// No description provided for @importFieldLocation.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get importFieldLocation;

  /// No description provided for @importFieldCondition.
  ///
  /// In en, this message translates to:
  /// **'Condition'**
  String get importFieldCondition;

  /// No description provided for @importFieldYear.
  ///
  /// In en, this message translates to:
  /// **'Year'**
  String get importFieldYear;

  /// No description provided for @importFieldSeries.
  ///
  /// In en, this message translates to:
  /// **'Series'**
  String get importFieldSeries;

  /// No description provided for @importFieldVolume.
  ///
  /// In en, this message translates to:
  /// **'Volume'**
  String get importFieldVolume;

  /// No description provided for @resolvingRows.
  ///
  /// In en, this message translates to:
  /// **'Looking up {done} of {total}…'**
  String resolvingRows(int done, int total);

  /// No description provided for @importFound.
  ///
  /// In en, this message translates to:
  /// **'Found'**
  String get importFound;

  /// No description provided for @importNotFound.
  ///
  /// In en, this message translates to:
  /// **'Not found: added as is if ticked'**
  String get importNotFound;

  /// No description provided for @importAlreadyOwned.
  ///
  /// In en, this message translates to:
  /// **'Already in your collection'**
  String get importAlreadyOwned;

  /// No description provided for @addImportedRows.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{Nothing to add} =1{Add 1 item} other{Add {count} items}}'**
  String addImportedRows(int count);

  /// No description provided for @importedCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{Nothing was added} =1{1 item added} other{{count} items added}}'**
  String importedCount(int count);

  /// No description provided for @importRowStatus.
  ///
  /// In en, this message translates to:
  /// **'Row {number} · {status}'**
  String importRowStatus(int number, String status);

  /// No description provided for @collectionData.
  ///
  /// In en, this message translates to:
  /// **'Collection data'**
  String get collectionData;

  /// No description provided for @backup.
  ///
  /// In en, this message translates to:
  /// **'Google Drive backup'**
  String get backup;

  /// No description provided for @lastBackupOn.
  ///
  /// In en, this message translates to:
  /// **'Last backup: {date}'**
  String lastBackupOn(String date);

  /// No description provided for @noBackupYet.
  ///
  /// In en, this message translates to:
  /// **'No backup yet.'**
  String get noBackupYet;

  /// No description provided for @backupExplanation.
  ///
  /// In en, this message translates to:
  /// **'Your collection and its images are saved in a private Akashic folder of your Google Drive. A backup also runs on its own once a week while the Google connection is valid.'**
  String get backupExplanation;

  /// No description provided for @backupReconnectReminder.
  ///
  /// In en, this message translates to:
  /// **'The Google connection has expired: reconnect to resume the weekly backups.'**
  String get backupReconnectReminder;

  /// No description provided for @backUpNow.
  ///
  /// In en, this message translates to:
  /// **'Back up now'**
  String get backUpNow;

  /// No description provided for @restoreBackup.
  ///
  /// In en, this message translates to:
  /// **'Restore a backup'**
  String get restoreBackup;

  /// No description provided for @reconnectGoogle.
  ///
  /// In en, this message translates to:
  /// **'Reconnect to Google'**
  String get reconnectGoogle;

  /// No description provided for @backupDone.
  ///
  /// In en, this message translates to:
  /// **'Backup saved to Google Drive.'**
  String get backupDone;

  /// No description provided for @backupUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Google Drive can’t be reached. Try again later.'**
  String get backupUnavailable;

  /// No description provided for @backupAuthorizationRefused.
  ///
  /// In en, this message translates to:
  /// **'Google didn’t give access to Drive.'**
  String get backupAuthorizationRefused;

  /// No description provided for @backupCorrupt.
  ///
  /// In en, this message translates to:
  /// **'This backup is damaged and can’t be restored.'**
  String get backupCorrupt;

  /// No description provided for @noRemoteBackup.
  ///
  /// In en, this message translates to:
  /// **'No backup found on Google Drive.'**
  String get noRemoteBackup;

  /// No description provided for @restoreQuestion.
  ///
  /// In en, this message translates to:
  /// **'Replace your current collection with the backup of {date}?'**
  String restoreQuestion(String date);

  /// No description provided for @restoreConfirm.
  ///
  /// In en, this message translates to:
  /// **'Replace'**
  String get restoreConfirm;

  /// No description provided for @restoreReady.
  ///
  /// In en, this message translates to:
  /// **'The backup is ready. Akashic closes now; open it again to finish the restore.'**
  String get restoreReady;

  /// No description provided for @closeAkashic.
  ///
  /// In en, this message translates to:
  /// **'Close Akashic'**
  String get closeAkashic;

  /// No description provided for @restoreFailed.
  ///
  /// In en, this message translates to:
  /// **'The last restore couldn’t be finished. Your collection was kept as it was.'**
  String get restoreFailed;

  /// No description provided for @importDuplicateInFile.
  ///
  /// In en, this message translates to:
  /// **'Already earlier in this file'**
  String get importDuplicateInFile;

  /// No description provided for @importAdded.
  ///
  /// In en, this message translates to:
  /// **'Added'**
  String get importAdded;

  /// No description provided for @importFailed.
  ///
  /// In en, this message translates to:
  /// **'Couldn’t be added'**
  String get importFailed;

  /// No description provided for @factPages.
  ///
  /// In en, this message translates to:
  /// **'Pages'**
  String get factPages;

  /// No description provided for @factPublisher.
  ///
  /// In en, this message translates to:
  /// **'Publisher'**
  String get factPublisher;

  /// No description provided for @factFormat.
  ///
  /// In en, this message translates to:
  /// **'Format'**
  String get factFormat;

  /// No description provided for @dataSources.
  ///
  /// In en, this message translates to:
  /// **'Data sources'**
  String get dataSources;

  /// No description provided for @dataSourcesList.
  ///
  /// In en, this message translates to:
  /// **'Music: Discogs and MusicBrainz (Cover Art Archive covers) · Books and comics: Google Books and Open Library, US comics: Comic Vine · Manga: AniList and Jikan (MyAnimeList), with Google Books for ISBN scans · ISBN backup: BnF catalogue (Licence Ouverte) · Films: TMDB · TV series: TVmaze (CC BY-SA) · Video games and consoles: IGDB · LEGO: Rebrickable · amiibo: AmiiboAPI · Product barcodes: UPCitemdb · Board games: BoardGameGeek · Pokémon: TCGdex · Magic: Scryfall, MTGJSON · Yu-Gi-Oh!: YGOPRODeck · Lorcana: Lorcast · Riftbound: Riftcodex · One Piece: OPTCG API · Scans: MangaUpdates · Backups when a quota is reached: Deezer (music), MangaDex (manga), Wikidata (films, video games, board games)'**
  String get dataSourcesList;

  /// No description provided for @tmdbNotice.
  ///
  /// In en, this message translates to:
  /// **'This product uses the TMDB API but is not endorsed or certified by TMDB.'**
  String get tmdbNotice;

  /// No description provided for @apiLimits.
  ///
  /// In en, this message translates to:
  /// **'API limits'**
  String get apiLimits;

  /// No description provided for @noApiPaused.
  ///
  /// In en, this message translates to:
  /// **'No API is paused.'**
  String get noApiPaused;

  /// No description provided for @apiPausedCountdown.
  ///
  /// In en, this message translates to:
  /// **'{source}: available again in {remaining}'**
  String apiPausedCountdown(String source, String remaining);

  /// No description provided for @apiPausedSeveral.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 API paused} other{{count} APIs paused}} · next one back in {remaining}'**
  String apiPausedSeveral(int count, String remaining);

  /// No description provided for @apiBlockedAtRetryAt.
  ///
  /// In en, this message translates to:
  /// **'Limit reached at {blockedAt} · next connection at {retryAt}'**
  String apiBlockedAtRetryAt(String blockedAt, String retryAt);

  /// No description provided for @apiLimitsExplanation.
  ///
  /// In en, this message translates to:
  /// **'When a source refuses requests because its free limit is reached, Akashic waits until it accepts them again.'**
  String get apiLimitsExplanation;

  /// No description provided for @searchingImages.
  ///
  /// In en, this message translates to:
  /// **'Looking for images…'**
  String get searchingImages;

  /// No description provided for @tapToSearchImages.
  ///
  /// In en, this message translates to:
  /// **'Tap to search'**
  String get tapToSearchImages;

  /// No description provided for @groupItemCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 item} other{{count} items}}'**
  String groupItemCount(int count);

  /// No description provided for @missingVolumeShort.
  ///
  /// In en, this message translates to:
  /// **'Vol. {number}'**
  String missingVolumeShort(int number);

  /// No description provided for @missingVolumesMore.
  ///
  /// In en, this message translates to:
  /// **'{count} missing'**
  String missingVolumesMore(int count);

  /// No description provided for @otherItems.
  ///
  /// In en, this message translates to:
  /// **'Others'**
  String get otherItems;

  /// No description provided for @cameraUnavailable.
  ///
  /// In en, this message translates to:
  /// **'The camera cannot be opened. Check the camera permission in the phone settings.'**
  String get cameraUnavailable;

  /// No description provided for @removeLanguage.
  ///
  /// In en, this message translates to:
  /// **'Remove this language'**
  String get removeLanguage;

  /// No description provided for @typeCardName.
  ///
  /// In en, this message translates to:
  /// **'Card name'**
  String get typeCardName;

  /// No description provided for @noApiForThisGame.
  ///
  /// In en, this message translates to:
  /// **'No online catalogue for this game: cards are entered by hand.'**
  String get noApiForThisGame;

  /// No description provided for @addCardAsTyped.
  ///
  /// In en, this message translates to:
  /// **'Add “{name}” as typed'**
  String addCardAsTyped(String name);

  /// No description provided for @noApiForThisCategory.
  ///
  /// In en, this message translates to:
  /// **'No online catalogue for this category: fill in the sheet by hand, the image search still works.'**
  String get noApiForThisCategory;

  /// No description provided for @add.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get add;

  /// No description provided for @cardGamesWithCatalogue.
  ///
  /// In en, this message translates to:
  /// **'Games with an online catalogue'**
  String get cardGamesWithCatalogue;

  /// No description provided for @otherCardGamesByHand.
  ///
  /// In en, this message translates to:
  /// **'Any other game works too: its cards are entered by hand.'**
  String get otherCardGamesByHand;

  /// No description provided for @categoryTypeBoardGames.
  ///
  /// In en, this message translates to:
  /// **'Board games'**
  String get categoryTypeBoardGames;

  /// No description provided for @partComponents.
  ///
  /// In en, this message translates to:
  /// **'Components'**
  String get partComponents;

  /// No description provided for @aimBarcodeOrShootCover.
  ///
  /// In en, this message translates to:
  /// **'Aim at a barcode, or shoot the cover'**
  String get aimBarcodeOrShootCover;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @deleteCopy.
  ///
  /// In en, this message translates to:
  /// **'Remove from the collection'**
  String get deleteCopy;

  /// No description provided for @deleteLastCopyTitle.
  ///
  /// In en, this message translates to:
  /// **'Remove this item from the collection?'**
  String get deleteLastCopyTitle;

  /// No description provided for @deleteLastCopyExplanation.
  ///
  /// In en, this message translates to:
  /// **'The item will be deleted, with its titles, cover, details and deck.'**
  String get deleteLastCopyExplanation;

  /// No description provided for @noOnlineDetailsForItem.
  ///
  /// In en, this message translates to:
  /// **'No online catalogue describes this item: it was entered by hand or comes from a source without details.'**
  String get noOnlineDetailsForItem;

  /// No description provided for @customCategoryExplanation.
  ///
  /// In en, this message translates to:
  /// **'A category you name, with no online catalogue: every item is entered by hand, with the image search for its cover. Add below the parts whose condition you want to rate.'**
  String get customCategoryExplanation;

  /// No description provided for @chainScanHint.
  ///
  /// In en, this message translates to:
  /// **'Scan barcodes or shoot covers: you see straight away whether you own them, then add the ones you keep.'**
  String get chainScanHint;

  /// No description provided for @scannedCodes.
  ///
  /// In en, this message translates to:
  /// **'Scanned codes'**
  String get scannedCodes;

  /// No description provided for @chainRateLimited.
  ///
  /// In en, this message translates to:
  /// **'Quota exceeded'**
  String get chainRateLimited;

  /// No description provided for @chainUnreachable.
  ///
  /// In en, this message translates to:
  /// **'Catalogue unreachable'**
  String get chainUnreachable;

  /// No description provided for @chainUnreadable.
  ///
  /// In en, this message translates to:
  /// **'Unreadable cover'**
  String get chainUnreadable;

  /// No description provided for @coverBeingRead.
  ///
  /// In en, this message translates to:
  /// **'Reading the cover…'**
  String get coverBeingRead;

  /// No description provided for @coverEntryLabel.
  ///
  /// In en, this message translates to:
  /// **'Cover: {title}'**
  String coverEntryLabel(String title);

  /// No description provided for @chainFailureNotFound.
  ///
  /// In en, this message translates to:
  /// **'Nothing found for {label}.'**
  String chainFailureNotFound(String label);

  /// No description provided for @chainFailureUnreadable.
  ///
  /// In en, this message translates to:
  /// **'The cover couldn\'t be read: take the photo again, closer and without reflections.'**
  String get chainFailureUnreadable;

  /// No description provided for @chainFailureRateLimited.
  ///
  /// In en, this message translates to:
  /// **'Call quota exceeded: {label} couldn\'t be checked.'**
  String chainFailureRateLimited(String label);

  /// No description provided for @chainFailureUnreachable.
  ///
  /// In en, this message translates to:
  /// **'Catalogues unreachable: {label} couldn\'t be checked.'**
  String chainFailureUnreachable(String label);

  /// No description provided for @scannedItemsPartlyAdded.
  ///
  /// In en, this message translates to:
  /// **'{added} added, {failed} couldn\'t be added.'**
  String scannedItemsPartlyAdded(int added, int failed);

  /// No description provided for @unexpectedError.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong. Try again.'**
  String get unexpectedError;

  /// No description provided for @unexpectedErrorWithDetail.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong: {detail}'**
  String unexpectedErrorWithDetail(String detail);

  /// No description provided for @sourceRateLimitedToast.
  ///
  /// In en, this message translates to:
  /// **'{source}: call quota exceeded, try again later.'**
  String sourceRateLimitedToast(String source);

  /// No description provided for @sourceUnreachableToast.
  ///
  /// In en, this message translates to:
  /// **'{source} can\'t be reached: check the network.'**
  String sourceUnreachableToast(String source);

  /// No description provided for @itemSaveFailedToast.
  ///
  /// In en, this message translates to:
  /// **'The item couldn\'t be saved.'**
  String get itemSaveFailedToast;

  /// No description provided for @discoveriesFailedToast.
  ///
  /// In en, this message translates to:
  /// **'Discoveries couldn\'t be refreshed: the catalogues can\'t be reached.'**
  String get discoveriesFailedToast;

  /// No description provided for @automaticBackupFailedToast.
  ///
  /// In en, this message translates to:
  /// **'The automatic backup failed.'**
  String get automaticBackupFailedToast;

  /// No description provided for @importLineFailedToast.
  ///
  /// In en, this message translates to:
  /// **'Line {row} couldn\'t be checked.'**
  String importLineFailedToast(int row);

  /// No description provided for @appVersionLabel.
  ///
  /// In en, this message translates to:
  /// **'Akashic {version}'**
  String appVersionLabel(String version);

  /// No description provided for @editCategory.
  ///
  /// In en, this message translates to:
  /// **'Edit the category'**
  String get editCategory;

  /// No description provided for @reorderCategories.
  ///
  /// In en, this message translates to:
  /// **'Change the order'**
  String get reorderCategories;

  /// No description provided for @deleteCategory.
  ///
  /// In en, this message translates to:
  /// **'Delete the category'**
  String get deleteCategory;

  /// No description provided for @categoryActions.
  ///
  /// In en, this message translates to:
  /// **'Category actions'**
  String get categoryActions;

  /// No description provided for @deleteCategoryTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete “{name}”?'**
  String deleteCategoryTitle(String name);

  /// No description provided for @deleteEmptyCategoryExplanation.
  ///
  /// In en, this message translates to:
  /// **'This category is empty.'**
  String get deleteEmptyCategoryExplanation;

  /// No description provided for @deleteCategoryExplanation.
  ///
  /// In en, this message translates to:
  /// **'Everything it holds will be deleted too: {items, plural, =0{no item} =1{1 item} other{{items} items}}, {series, plural, =0{no series} =1{1 series} other{{series} series}} and {subcategories, plural, =0{no subcategory} =1{1 subcategory} other{{subcategories} subcategories}}, with their covers. This can\'t be undone.'**
  String deleteCategoryExplanation(int items, int series, int subcategories);

  /// No description provided for @moveItem.
  ///
  /// In en, this message translates to:
  /// **'Move to another category'**
  String get moveItem;

  /// No description provided for @moveSeriesQuestion.
  ///
  /// In en, this message translates to:
  /// **'Move the whole series?'**
  String get moveSeriesQuestion;

  /// No description provided for @moveSeriesExplanation.
  ///
  /// In en, this message translates to:
  /// **'This item belongs to a series. Move the series with all its volumes, or only this one, which then leaves the series.'**
  String get moveSeriesExplanation;

  /// No description provided for @moveThisVolumeOnly.
  ///
  /// In en, this message translates to:
  /// **'This one only'**
  String get moveThisVolumeOnly;

  /// No description provided for @moveWholeSeries.
  ///
  /// In en, this message translates to:
  /// **'The whole series'**
  String get moveWholeSeries;

  /// No description provided for @movedInto.
  ///
  /// In en, this message translates to:
  /// **'Moved into {category}.'**
  String movedInto(String category);

  /// No description provided for @backupFileSection.
  ///
  /// In en, this message translates to:
  /// **'Backup file'**
  String get backupFileSection;

  /// No description provided for @backupFileExplanation.
  ///
  /// In en, this message translates to:
  /// **'The same full archive as the Drive backup (collection and covers), saved where you choose: phone, SD card, another cloud app.'**
  String get backupFileExplanation;

  /// No description provided for @exportToFile.
  ///
  /// In en, this message translates to:
  /// **'Export to a file'**
  String get exportToFile;

  /// No description provided for @restoreFromFile.
  ///
  /// In en, this message translates to:
  /// **'Restore from a file'**
  String get restoreFromFile;

  /// No description provided for @exportDone.
  ///
  /// In en, this message translates to:
  /// **'Collection exported.'**
  String get exportDone;

  /// No description provided for @progressTitle.
  ///
  /// In en, this message translates to:
  /// **'Progress'**
  String get progressTitle;

  /// No description provided for @progressNotStarted.
  ///
  /// In en, this message translates to:
  /// **'Not started'**
  String get progressNotStarted;

  /// No description provided for @progressToRead.
  ///
  /// In en, this message translates to:
  /// **'To read'**
  String get progressToRead;

  /// No description provided for @progressToPlay.
  ///
  /// In en, this message translates to:
  /// **'To play'**
  String get progressToPlay;

  /// No description provided for @progressToWatch.
  ///
  /// In en, this message translates to:
  /// **'To watch'**
  String get progressToWatch;

  /// No description provided for @progressToListen.
  ///
  /// In en, this message translates to:
  /// **'To listen'**
  String get progressToListen;

  /// No description provided for @progressInProgress.
  ///
  /// In en, this message translates to:
  /// **'In progress'**
  String get progressInProgress;

  /// No description provided for @progressFinished.
  ///
  /// In en, this message translates to:
  /// **'Finished'**
  String get progressFinished;

  /// No description provided for @progressRead.
  ///
  /// In en, this message translates to:
  /// **'Read'**
  String get progressRead;

  /// No description provided for @progressPlayed.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get progressPlayed;

  /// No description provided for @progressWatched.
  ///
  /// In en, this message translates to:
  /// **'Watched'**
  String get progressWatched;

  /// No description provided for @progressListened.
  ///
  /// In en, this message translates to:
  /// **'Listened'**
  String get progressListened;

  /// No description provided for @progressAbandoned.
  ///
  /// In en, this message translates to:
  /// **'Dropped'**
  String get progressAbandoned;

  /// No description provided for @progressChapter.
  ///
  /// In en, this message translates to:
  /// **'Chapter'**
  String get progressChapter;

  /// No description provided for @progressPage.
  ///
  /// In en, this message translates to:
  /// **'Page'**
  String get progressPage;

  /// No description provided for @progressBookmark.
  ///
  /// In en, this message translates to:
  /// **'Chapter {chapter} · page {page}'**
  String progressBookmark(String chapter, String page);

  /// No description provided for @arrangeShelf.
  ///
  /// In en, this message translates to:
  /// **'Sort and filter'**
  String get arrangeShelf;

  /// No description provided for @sortTitle.
  ///
  /// In en, this message translates to:
  /// **'Sort'**
  String get sortTitle;

  /// No description provided for @sortBySeries.
  ///
  /// In en, this message translates to:
  /// **'By series'**
  String get sortBySeries;

  /// No description provided for @sortByTitle.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get sortByTitle;

  /// No description provided for @sortByCreator.
  ///
  /// In en, this message translates to:
  /// **'Author or artist'**
  String get sortByCreator;

  /// No description provided for @sortNewest.
  ///
  /// In en, this message translates to:
  /// **'Most recent'**
  String get sortNewest;

  /// No description provided for @sortOldest.
  ///
  /// In en, this message translates to:
  /// **'Oldest'**
  String get sortOldest;

  /// No description provided for @sortBestRated.
  ///
  /// In en, this message translates to:
  /// **'Best rated'**
  String get sortBestRated;

  /// No description provided for @sortRecentlyAdded.
  ///
  /// In en, this message translates to:
  /// **'Recently added'**
  String get sortRecentlyAdded;

  /// No description provided for @filterAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get filterAll;

  /// No description provided for @filterMinimumRating.
  ///
  /// In en, this message translates to:
  /// **'Rating'**
  String get filterMinimumRating;

  /// No description provided for @filterAtLeastStars.
  ///
  /// In en, this message translates to:
  /// **'{stars}★ and more'**
  String filterAtLeastStars(int stars);

  /// No description provided for @resetArrangement.
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get resetArrangement;

  /// No description provided for @applyArrangement.
  ///
  /// In en, this message translates to:
  /// **'Apply'**
  String get applyArrangement;

  /// No description provided for @noItemMatchesArrangement.
  ///
  /// In en, this message translates to:
  /// **'No item matches these filters.'**
  String get noItemMatchesArrangement;

  /// No description provided for @photosTitle.
  ///
  /// In en, this message translates to:
  /// **'Photos'**
  String get photosTitle;

  /// No description provided for @addPhoto.
  ///
  /// In en, this message translates to:
  /// **'Add a photo'**
  String get addPhoto;

  /// No description provided for @pickFromGallery.
  ///
  /// In en, this message translates to:
  /// **'Choose from the gallery'**
  String get pickFromGallery;

  /// No description provided for @deletePhotoQuestion.
  ///
  /// In en, this message translates to:
  /// **'Delete this photo?'**
  String get deletePhotoQuestion;

  /// No description provided for @photosHint.
  ///
  /// In en, this message translates to:
  /// **'Tap to enlarge, long press to delete.'**
  String get photosHint;

  /// No description provided for @loanRemindersChannelName.
  ///
  /// In en, this message translates to:
  /// **'Loan reminders'**
  String get loanRemindersChannelName;

  /// No description provided for @loanRemindersChannelDescription.
  ///
  /// In en, this message translates to:
  /// **'Reminds you of items lent for a month.'**
  String get loanRemindersChannelDescription;

  /// No description provided for @loanReminderTitle.
  ///
  /// In en, this message translates to:
  /// **'{title} is still lent'**
  String loanReminderTitle(String title);

  /// No description provided for @loanReminderBody.
  ///
  /// In en, this message translates to:
  /// **'{borrower} has had it for {days} days.'**
  String loanReminderBody(String borrower, int days);

  /// No description provided for @selectedItemsCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 selected} other{{count} selected}}'**
  String selectedItemsCount(int count);

  /// No description provided for @clearSelection.
  ///
  /// In en, this message translates to:
  /// **'Cancel the selection'**
  String get clearSelection;

  /// No description provided for @setStorageLocation.
  ///
  /// In en, this message translates to:
  /// **'Set the storage location'**
  String get setStorageLocation;

  /// No description provided for @locationApplied.
  ///
  /// In en, this message translates to:
  /// **'Storage location updated.'**
  String get locationApplied;

  /// No description provided for @deleteSelectedItemsTitle.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Delete 1 item?} other{Delete {count} items?}}'**
  String deleteSelectedItemsTitle(int count);

  /// No description provided for @deleteSelectedItemsExplanation.
  ///
  /// In en, this message translates to:
  /// **'Their photos, covers, details and loans go with them. This can\'t be undone.'**
  String get deleteSelectedItemsExplanation;

  /// No description provided for @shareWishlist.
  ///
  /// In en, this message translates to:
  /// **'Share my wishes'**
  String get shareWishlist;

  /// No description provided for @wishlistShareHeading.
  ///
  /// In en, this message translates to:
  /// **'My wishes, from Akashic'**
  String get wishlistShareHeading;

  /// No description provided for @wishlistShareSubject.
  ///
  /// In en, this message translates to:
  /// **'My wish list'**
  String get wishlistShareSubject;

  /// No description provided for @discogsImportTitle.
  ///
  /// In en, this message translates to:
  /// **'Import my Discogs collection'**
  String get discogsImportTitle;

  /// No description provided for @discogsImportExplanation.
  ///
  /// In en, this message translates to:
  /// **'Every record of your Discogs collection is added with its cover. Records already in Akashic are skipped, so you can import again later to bring in the new ones.'**
  String get discogsImportExplanation;

  /// No description provided for @discogsImportTarget.
  ///
  /// In en, this message translates to:
  /// **'Music category'**
  String get discogsImportTarget;

  /// No description provided for @discogsImportStart.
  ///
  /// In en, this message translates to:
  /// **'Import'**
  String get discogsImportStart;

  /// No description provided for @discogsImportReading.
  ///
  /// In en, this message translates to:
  /// **'Reading your Discogs collection…'**
  String get discogsImportReading;

  /// No description provided for @discogsImportProgress.
  ///
  /// In en, this message translates to:
  /// **'{done} of {total} records'**
  String discogsImportProgress(int done, int total);

  /// No description provided for @discogsImportOutcome.
  ///
  /// In en, this message translates to:
  /// **'{added} added, {owned} already there, {failed} failed.'**
  String discogsImportOutcome(int added, int owned, int failed);

  /// No description provided for @discogsImportNeedsToken.
  ///
  /// In en, this message translates to:
  /// **'No Discogs token is configured.'**
  String get discogsImportNeedsToken;

  /// No description provided for @discogsImportNeedsMusicCategory.
  ///
  /// In en, this message translates to:
  /// **'Create a music category first.'**
  String get discogsImportNeedsMusicCategory;

  /// No description provided for @widgetItemCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{No item yet} =1{1 item} other{{count} items}}'**
  String widgetItemCount(int count);

  /// No description provided for @widgetLatestAdditions.
  ///
  /// In en, this message translates to:
  /// **'Latest: {titles}'**
  String widgetLatestAdditions(String titles);

  /// No description provided for @widgetLoans.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 loan in progress} other{{count} loans in progress}}'**
  String widgetLoans(int count);

  /// No description provided for @widgetNoLoan.
  ///
  /// In en, this message translates to:
  /// **'No loan in progress'**
  String get widgetNoLoan;

  /// No description provided for @updateCardPrices.
  ///
  /// In en, this message translates to:
  /// **'Update prices'**
  String get updateCardPrices;

  /// No description provided for @deckEstimatedValue.
  ///
  /// In en, this message translates to:
  /// **'Estimated value: {value}'**
  String deckEstimatedValue(String value);

  /// No description provided for @deckValueUnknown.
  ///
  /// In en, this message translates to:
  /// **'No price yet'**
  String get deckValueUnknown;

  /// No description provided for @categoryTypeLego.
  ///
  /// In en, this message translates to:
  /// **'LEGO'**
  String get categoryTypeLego;

  /// No description provided for @categoryTypeAmiibo.
  ///
  /// In en, this message translates to:
  /// **'amiibo'**
  String get categoryTypeAmiibo;

  /// No description provided for @categoryTypeConsoles.
  ///
  /// In en, this message translates to:
  /// **'Consoles & hardware'**
  String get categoryTypeConsoles;

  /// No description provided for @creatorTheme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get creatorTheme;

  /// No description provided for @creatorAmiiboSeries.
  ///
  /// In en, this message translates to:
  /// **'amiibo series'**
  String get creatorAmiiboSeries;

  /// No description provided for @creatorManufacturer.
  ///
  /// In en, this message translates to:
  /// **'Manufacturer'**
  String get creatorManufacturer;

  /// No description provided for @upcomingReleases.
  ///
  /// In en, this message translates to:
  /// **'Upcoming releases'**
  String get upcomingReleases;

  /// No description provided for @refreshReleases.
  ///
  /// In en, this message translates to:
  /// **'Refresh releases'**
  String get refreshReleases;

  /// No description provided for @releasesFailedToast.
  ///
  /// In en, this message translates to:
  /// **'Upcoming releases can’t be fetched right now.'**
  String get releasesFailedToast;

  /// No description provided for @releasesOfflineEmpty.
  ///
  /// In en, this message translates to:
  /// **'Upcoming releases couldn’t be loaded. Try again once you’re online.'**
  String get releasesOfflineEmpty;

  /// No description provided for @releasesNeedInterests.
  ///
  /// In en, this message translates to:
  /// **'File numbered volumes in a series, create a card game category (Pokémon, Magic, Yu-Gi-Oh!, Lorcana, Riftbound) or add records with their artist to follow their releases.'**
  String get releasesNeedInterests;

  /// No description provided for @releasesNothingAnnounced.
  ///
  /// In en, this message translates to:
  /// **'No release announced for what you collect.'**
  String get releasesNothingAnnounced;

  /// No description provided for @releaseAlertsChannelName.
  ///
  /// In en, this message translates to:
  /// **'Upcoming releases'**
  String get releaseAlertsChannelName;

  /// No description provided for @releaseAlertsChannelDescription.
  ///
  /// In en, this message translates to:
  /// **'Lets you know when an expansion, an album or the next volume of a series is announced.'**
  String get releaseAlertsChannelDescription;

  /// No description provided for @releaseAlertTitle.
  ///
  /// In en, this message translates to:
  /// **'Release announced: {title}'**
  String releaseAlertTitle(String title);

  /// No description provided for @releaseAlertBody.
  ///
  /// In en, this message translates to:
  /// **'{subject} · on {date}'**
  String releaseAlertBody(String subject, String date);

  /// No description provided for @releaseAlertSummaryTitle.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 new release announced} other{{count} new releases announced}}'**
  String releaseAlertSummaryTitle(int count);

  /// No description provided for @chooseCategory.
  ///
  /// In en, this message translates to:
  /// **'Choose a category'**
  String get chooseCategory;

  /// No description provided for @navReleases.
  ///
  /// In en, this message translates to:
  /// **'Releases'**
  String get navReleases;

  /// No description provided for @seeAll.
  ///
  /// In en, this message translates to:
  /// **'See all'**
  String get seeAll;

  /// No description provided for @tutorialNext.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get tutorialNext;

  /// No description provided for @replayTutorial.
  ///
  /// In en, this message translates to:
  /// **'Replay the tutorial'**
  String get replayTutorial;

  /// No description provided for @helpSection.
  ///
  /// In en, this message translates to:
  /// **'Help'**
  String get helpSection;

  /// No description provided for @addItemShort.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get addItemShort;

  /// No description provided for @tourPrevious.
  ///
  /// In en, this message translates to:
  /// **'Previous'**
  String get tourPrevious;

  /// No description provided for @tourDone.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get tourDone;

  /// No description provided for @tourProgress.
  ///
  /// In en, this message translates to:
  /// **'{current} / {total}'**
  String tourProgress(int current, int total);

  /// No description provided for @tourWelcomeTitle.
  ///
  /// In en, this message translates to:
  /// **'Welcome to Akashic'**
  String get tourWelcomeTitle;

  /// No description provided for @tourWelcomeText.
  ///
  /// In en, this message translates to:
  /// **'Your physical collection laid out like your shelves: books, manga, music, films, games, cards, LEGO… A quick tour of the controls.'**
  String get tourWelcomeText;

  /// No description provided for @tourNewCategoryTitle.
  ///
  /// In en, this message translates to:
  /// **'Create your categories'**
  String get tourNewCategoryTitle;

  /// No description provided for @tourNewCategoryText.
  ///
  /// In en, this message translates to:
  /// **'Pick a type (manga, records, card game…): it decides which catalogues are searched. Each category becomes a shelf; tap it to open it.'**
  String get tourNewCategoryText;

  /// No description provided for @tourSearchTitle.
  ///
  /// In en, this message translates to:
  /// **'Find an item'**
  String get tourSearchTitle;

  /// No description provided for @tourSearchText.
  ///
  /// In en, this message translates to:
  /// **'Search your whole collection by title, author or barcode.'**
  String get tourSearchText;

  /// No description provided for @tourScanTitle.
  ///
  /// In en, this message translates to:
  /// **'Scan'**
  String get tourScanTitle;

  /// No description provided for @tourScanText.
  ///
  /// In en, this message translates to:
  /// **'Aim at barcodes one after another or shoot a cover: you instantly see whether you own it, then add what you keep in one go.'**
  String get tourScanText;

  /// No description provided for @tourMenuTitle.
  ///
  /// In en, this message translates to:
  /// **'Everything else is here'**
  String get tourMenuTitle;

  /// No description provided for @tourMenuText.
  ///
  /// In en, this message translates to:
  /// **'Loans, statistics and settings: Drive backup, import, languages… and “Replay the tutorial” to take this tour again.'**
  String get tourMenuText;

  /// No description provided for @tourWishesTitle.
  ///
  /// In en, this message translates to:
  /// **'Your wishes'**
  String get tourWishesTitle;

  /// No description provided for @tourWishesText.
  ///
  /// In en, this message translates to:
  /// **'What you are still looking for, shareable in one tap.'**
  String get tourWishesText;

  /// No description provided for @tourDiscoveriesTitle.
  ///
  /// In en, this message translates to:
  /// **'Discoveries'**
  String get tourDiscoveriesTitle;

  /// No description provided for @tourDiscoveriesText.
  ///
  /// In en, this message translates to:
  /// **'Suggestions drawn from your collection; tap a card to see its details.'**
  String get tourDiscoveriesText;

  /// No description provided for @tourReleasesTitle.
  ///
  /// In en, this message translates to:
  /// **'Releases'**
  String get tourReleasesTitle;

  /// No description provided for @tourReleasesText.
  ///
  /// In en, this message translates to:
  /// **'The next volumes of your series, the expansions of your card games and the new albums of your artists.'**
  String get tourReleasesText;

  /// No description provided for @releasesAlreadyOut.
  ///
  /// In en, this message translates to:
  /// **'Already out'**
  String get releasesAlreadyOut;

  /// No description provided for @addPreconDeck.
  ///
  /// In en, this message translates to:
  /// **'Add a preconstructed deck'**
  String get addPreconDeck;

  /// No description provided for @searchPreconDeck.
  ///
  /// In en, this message translates to:
  /// **'Deck name, set or type'**
  String get searchPreconDeck;

  /// No description provided for @noPreconDeckFound.
  ///
  /// In en, this message translates to:
  /// **'No preconstructed deck matches.'**
  String get noPreconDeckFound;

  /// No description provided for @preconDeckAdded.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 card added from {deck}} other{{count} cards added from {deck}}}'**
  String preconDeckAdded(int count, String deck);

  /// No description provided for @commanderDeckGroup.
  ///
  /// In en, this message translates to:
  /// **'Commander deck'**
  String get commanderDeckGroup;

  /// No description provided for @preconDeckGroup.
  ///
  /// In en, this message translates to:
  /// **'Preconstructed deck'**
  String get preconDeckGroup;

  /// No description provided for @addToWhichSubcategory.
  ///
  /// In en, this message translates to:
  /// **'Add to which subcategory?'**
  String get addToWhichSubcategory;

  /// No description provided for @deckHasNoCards.
  ///
  /// In en, this message translates to:
  /// **'This deck holds no card yet.'**
  String get deckHasNoCards;

  /// No description provided for @progressPlayedOnce.
  ///
  /// In en, this message translates to:
  /// **'Played'**
  String get progressPlayedOnce;

  /// No description provided for @progressToBuild.
  ///
  /// In en, this message translates to:
  /// **'To build'**
  String get progressToBuild;

  /// No description provided for @progressBuilding.
  ///
  /// In en, this message translates to:
  /// **'Building'**
  String get progressBuilding;

  /// No description provided for @progressBuilt.
  ///
  /// In en, this message translates to:
  /// **'Built'**
  String get progressBuilt;

  /// No description provided for @savePhoto.
  ///
  /// In en, this message translates to:
  /// **'Save to the gallery'**
  String get savePhoto;

  /// No description provided for @photoSaved.
  ///
  /// In en, this message translates to:
  /// **'Photo saved to the Akashic album.'**
  String get photoSaved;

  /// No description provided for @photoNotSaved.
  ///
  /// In en, this message translates to:
  /// **'The photo could not be saved.'**
  String get photoNotSaved;

  /// No description provided for @missingVolumeLabel.
  ///
  /// In en, this message translates to:
  /// **'Volume {number} missing'**
  String missingVolumeLabel(int number);

  /// No description provided for @ratingLabel.
  ///
  /// In en, this message translates to:
  /// **'Rating'**
  String get ratingLabel;

  /// No description provided for @notRated.
  ///
  /// In en, this message translates to:
  /// **'Not rated'**
  String get notRated;

  /// No description provided for @ratingValue.
  ///
  /// In en, this message translates to:
  /// **'{stars} out of 5'**
  String ratingValue(int stars);

  /// No description provided for @removeOneCard.
  ///
  /// In en, this message translates to:
  /// **'Remove one copy of the card'**
  String get removeOneCard;

  /// No description provided for @addOneCard.
  ///
  /// In en, this message translates to:
  /// **'Add one copy of the card'**
  String get addOneCard;

  /// No description provided for @deleteCard.
  ///
  /// In en, this message translates to:
  /// **'Remove the card from the deck'**
  String get deleteCard;

  /// No description provided for @photoNumber.
  ///
  /// In en, this message translates to:
  /// **'Photo {number}'**
  String photoNumber(int number);

  /// No description provided for @incompleteSeries.
  ///
  /// In en, this message translates to:
  /// **'Incomplete series'**
  String get incompleteSeries;

  /// No description provided for @estimatedValue.
  ///
  /// In en, this message translates to:
  /// **'Estimated value'**
  String get estimatedValue;

  /// No description provided for @estimatedValueExplanation.
  ///
  /// In en, this message translates to:
  /// **'Low estimate: lowest Discogs price for records, card prices for decks, otherwise the price paid.'**
  String get estimatedValueExplanation;

  /// No description provided for @valuedItemsSummary.
  ///
  /// In en, this message translates to:
  /// **'{market} priced · {purchase} at price paid · {unvalued} without value'**
  String valuedItemsSummary(int market, int purchase, int unvalued);

  /// No description provided for @updateMarketValues.
  ///
  /// In en, this message translates to:
  /// **'Update prices'**
  String get updateMarketValues;

  /// No description provided for @updatingMarketValues.
  ///
  /// In en, this message translates to:
  /// **'Updating prices… {done}/{total}'**
  String updatingMarketValues(int done, int total);

  /// No description provided for @marketValuedOn.
  ///
  /// In en, this message translates to:
  /// **'Prices from {date}'**
  String marketValuedOn(String date);

  /// No description provided for @marketValuesIncomplete.
  ///
  /// In en, this message translates to:
  /// **'Update stopped by the request limit, try again later.'**
  String get marketValuesIncomplete;

  /// No description provided for @valueByCategory.
  ///
  /// In en, this message translates to:
  /// **'Value by category'**
  String get valueByCategory;

  /// No description provided for @duplicatesTitle.
  ///
  /// In en, this message translates to:
  /// **'Duplicates'**
  String get duplicatesTitle;

  /// No description provided for @duplicatesCount.
  ///
  /// In en, this message translates to:
  /// **'Duplicates ({count})'**
  String duplicatesCount(int count);

  /// No description provided for @sameWorkSection.
  ///
  /// In en, this message translates to:
  /// **'Same work added several times'**
  String get sameWorkSection;

  /// No description provided for @noDuplicates.
  ///
  /// In en, this message translates to:
  /// **'No duplicates'**
  String get noDuplicates;

  /// No description provided for @searchLoans.
  ///
  /// In en, this message translates to:
  /// **'Search a title or a borrower'**
  String get searchLoans;

  /// No description provided for @noLoanMatches.
  ///
  /// In en, this message translates to:
  /// **'No loan matches.'**
  String get noLoanMatches;

  /// No description provided for @additionsByYear.
  ///
  /// In en, this message translates to:
  /// **'Additions by year'**
  String get additionsByYear;

  /// No description provided for @seriesCompletionTitle.
  ///
  /// In en, this message translates to:
  /// **'Complete series'**
  String get seriesCompletionTitle;

  /// No description provided for @seriesCompletionSummary.
  ///
  /// In en, this message translates to:
  /// **'{complete} of {total} series complete'**
  String seriesCompletionSummary(int complete, int total);

  /// No description provided for @categoryShare.
  ///
  /// In en, this message translates to:
  /// **'{category} {percent}%'**
  String categoryShare(String category, int percent);

  /// No description provided for @yearAdditions.
  ///
  /// In en, this message translates to:
  /// **'{year}: {count} additions'**
  String yearAdditions(String year, int count);

  /// No description provided for @estimatedReleaseAround.
  ///
  /// In en, this message translates to:
  /// **'estimate: around {date}'**
  String estimatedReleaseAround(String date);

  /// No description provided for @estimateBadge.
  ///
  /// In en, this message translates to:
  /// **'Estimate'**
  String get estimateBadge;

  /// No description provided for @wishedRelease.
  ///
  /// In en, this message translates to:
  /// **'On your wish list'**
  String get wishedRelease;

  /// No description provided for @wishedReleaseOutTitle.
  ///
  /// In en, this message translates to:
  /// **'{title} is out'**
  String wishedReleaseOutTitle(String title);

  /// No description provided for @wishedReleaseOutBody.
  ///
  /// In en, this message translates to:
  /// **'The {subject} volume you were waiting for is available.'**
  String wishedReleaseOutBody(String subject);

  /// No description provided for @volumeOwnedLabel.
  ///
  /// In en, this message translates to:
  /// **'Volume {number}, owned'**
  String volumeOwnedLabel(int number);

  /// No description provided for @volumeMissingLabel.
  ///
  /// In en, this message translates to:
  /// **'Volume {number}, missing'**
  String volumeMissingLabel(int number);

  /// No description provided for @volumeUnreleasedLabel.
  ///
  /// In en, this message translates to:
  /// **'Volume {number}, not out yet'**
  String volumeUnreleasedLabel(int number);

  /// No description provided for @paletteColorName.
  ///
  /// In en, this message translates to:
  /// **'{index, select, 0{Blue} 1{Pink} 2{Green} 3{Turquoise} 4{Purple} 5{Orange} 6{Yellow} other{Lavender}}'**
  String paletteColorName(String index);

  /// No description provided for @cardsWithoutTraits.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 card without type or colour} other{{count} cards without type or colour}}'**
  String cardsWithoutTraits(int count);

  /// No description provided for @fetchCardTraits.
  ///
  /// In en, this message translates to:
  /// **'Fetch'**
  String get fetchCardTraits;

  /// No description provided for @cardFamilyCreature.
  ///
  /// In en, this message translates to:
  /// **'Creatures'**
  String get cardFamilyCreature;

  /// No description provided for @cardFamilyPlaneswalker.
  ///
  /// In en, this message translates to:
  /// **'Planeswalkers'**
  String get cardFamilyPlaneswalker;

  /// No description provided for @cardFamilyBattle.
  ///
  /// In en, this message translates to:
  /// **'Battles'**
  String get cardFamilyBattle;

  /// No description provided for @cardFamilyInstant.
  ///
  /// In en, this message translates to:
  /// **'Instants'**
  String get cardFamilyInstant;

  /// No description provided for @cardFamilySorcery.
  ///
  /// In en, this message translates to:
  /// **'Sorceries'**
  String get cardFamilySorcery;

  /// No description provided for @cardFamilyArtifact.
  ///
  /// In en, this message translates to:
  /// **'Artifacts'**
  String get cardFamilyArtifact;

  /// No description provided for @cardFamilyEnchantment.
  ///
  /// In en, this message translates to:
  /// **'Enchantments'**
  String get cardFamilyEnchantment;

  /// No description provided for @cardFamilyLand.
  ///
  /// In en, this message translates to:
  /// **'Lands'**
  String get cardFamilyLand;

  /// No description provided for @cardFamilyOther.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get cardFamilyOther;

  /// No description provided for @manaWhite.
  ///
  /// In en, this message translates to:
  /// **'white'**
  String get manaWhite;

  /// No description provided for @manaBlue.
  ///
  /// In en, this message translates to:
  /// **'blue'**
  String get manaBlue;

  /// No description provided for @manaBlack.
  ///
  /// In en, this message translates to:
  /// **'black'**
  String get manaBlack;

  /// No description provided for @manaRed.
  ///
  /// In en, this message translates to:
  /// **'red'**
  String get manaRed;

  /// No description provided for @manaGreen.
  ///
  /// In en, this message translates to:
  /// **'green'**
  String get manaGreen;

  /// No description provided for @colorIdentityTitle.
  ///
  /// In en, this message translates to:
  /// **'Colour identity'**
  String get colorIdentityTitle;

  /// No description provided for @colorIdentityLabel.
  ///
  /// In en, this message translates to:
  /// **'Colour identity: {colors}'**
  String colorIdentityLabel(String colors);

  /// No description provided for @manaCurveTitle.
  ///
  /// In en, this message translates to:
  /// **'Mana curve'**
  String get manaCurveTitle;

  /// No description provided for @manaCurveSummary.
  ///
  /// In en, this message translates to:
  /// **'Mana curve · average {average}'**
  String manaCurveSummary(String average);

  /// No description provided for @manaCurveEntry.
  ///
  /// In en, this message translates to:
  /// **'cost {cost}: {count}'**
  String manaCurveEntry(String cost, int count);

  /// No description provided for @commanderRulesTitle.
  ///
  /// In en, this message translates to:
  /// **'Commander rules'**
  String get commanderRulesTitle;

  /// No description provided for @noCommanderChosen.
  ///
  /// In en, this message translates to:
  /// **'No commander chosen'**
  String get noCommanderChosen;

  /// No description provided for @chooseCommander.
  ///
  /// In en, this message translates to:
  /// **'Choose the commander'**
  String get chooseCommander;

  /// No description provided for @commanderRuleSize.
  ///
  /// In en, this message translates to:
  /// **'Exactly 100 cards (currently {count})'**
  String commanderRuleSize(int count);

  /// No description provided for @commanderRuleCommander.
  ///
  /// In en, this message translates to:
  /// **'A commander chosen'**
  String get commanderRuleCommander;

  /// No description provided for @commanderRuleSingleton.
  ///
  /// In en, this message translates to:
  /// **'One copy of each card, basic lands aside'**
  String get commanderRuleSingleton;

  /// No description provided for @commanderRuleDuplicates.
  ///
  /// In en, this message translates to:
  /// **'Several copies: {names}'**
  String commanderRuleDuplicates(String names);

  /// No description provided for @commanderRuleIdentity.
  ///
  /// In en, this message translates to:
  /// **'Every card within the commander\'s colour identity'**
  String get commanderRuleIdentity;

  /// No description provided for @commanderRuleOutsideIdentity.
  ///
  /// In en, this message translates to:
  /// **'Outside the colour identity: {names}'**
  String commanderRuleOutsideIdentity(String names);

  /// No description provided for @commanderRuleIdentityUnknown.
  ///
  /// In en, this message translates to:
  /// **'Colour identity to check: choose a commander and fetch the card colours'**
  String get commanderRuleIdentityUnknown;

  /// No description provided for @ruleMet.
  ///
  /// In en, this message translates to:
  /// **'Met'**
  String get ruleMet;

  /// No description provided for @ruleNotMet.
  ///
  /// In en, this message translates to:
  /// **'Not met'**
  String get ruleNotMet;

  /// No description provided for @ruleUnknown.
  ///
  /// In en, this message translates to:
  /// **'To check'**
  String get ruleUnknown;

  /// No description provided for @photographShelf.
  ///
  /// In en, this message translates to:
  /// **'Photograph a shelf (several items at once)'**
  String get photographShelf;

  /// No description provided for @shelfBeingRead.
  ///
  /// In en, this message translates to:
  /// **'Reading the spines…'**
  String get shelfBeingRead;

  /// No description provided for @deckCardsTab.
  ///
  /// In en, this message translates to:
  /// **'Cards'**
  String get deckCardsTab;

  /// No description provided for @deckAnalysisTab.
  ///
  /// In en, this message translates to:
  /// **'Analysis'**
  String get deckAnalysisTab;

  /// No description provided for @primaryCommander.
  ///
  /// In en, this message translates to:
  /// **'Main'**
  String get primaryCommander;

  /// No description provided for @secondaryCommander.
  ///
  /// In en, this message translates to:
  /// **'Secondary'**
  String get secondaryCommander;

  /// No description provided for @primaryCommanderIs.
  ///
  /// In en, this message translates to:
  /// **'Main commander: {name}'**
  String primaryCommanderIs(String name);

  /// No description provided for @secondaryCommanderIs.
  ///
  /// In en, this message translates to:
  /// **'Secondary commander: {name}'**
  String secondaryCommanderIs(String name);

  /// No description provided for @swapCommanders.
  ///
  /// In en, this message translates to:
  /// **'Swap main and secondary'**
  String get swapCommanders;

  /// No description provided for @commanderCandidatesNeedTraits.
  ///
  /// In en, this message translates to:
  /// **'Only legendary creatures are offered. Fetch the card types first to see them all.'**
  String get commanderCandidatesNeedTraits;

  /// No description provided for @noLegendaryCreature.
  ///
  /// In en, this message translates to:
  /// **'No legendary creature in this deck.'**
  String get noLegendaryCreature;

  /// No description provided for @accountImportTitle.
  ///
  /// In en, this message translates to:
  /// **'Import from an account'**
  String get accountImportTitle;

  /// No description provided for @accountImportSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Steam, itch.io, Trakt, AniList, MyAnimeList, Open Library, BoardGameGeek, Rebrickable, Playnite'**
  String get accountImportSubtitle;

  /// No description provided for @steamImportExplanation.
  ///
  /// In en, this message translates to:
  /// **'Adds every game of your Steam library. Your profile game details must be public (Steam › Profile › Edit › Privacy).'**
  String get steamImportExplanation;

  /// No description provided for @traktImportExplanation.
  ///
  /// In en, this message translates to:
  /// **'Adds the films and shows of your Trakt collection (what you own). Your Trakt profile must be public.'**
  String get traktImportExplanation;

  /// No description provided for @anilistImportExplanation.
  ///
  /// In en, this message translates to:
  /// **'Adds the manga of your AniList list with your progress (reading, read, dropped). It is your reading list: remove what you do not own afterwards.'**
  String get anilistImportExplanation;

  /// No description provided for @openLibraryImportExplanation.
  ///
  /// In en, this message translates to:
  /// **'Adds the books of your Open Library shelves (read, reading, want to read) with your progress. Your reading log must be public.'**
  String get openLibraryImportExplanation;

  /// No description provided for @accountNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Account name'**
  String get accountNameLabel;

  /// No description provided for @accountNameHint.
  ///
  /// In en, this message translates to:
  /// **'Your name on the site'**
  String get accountNameHint;

  /// No description provided for @steamAccountHint.
  ///
  /// In en, this message translates to:
  /// **'steamcommunity.com/id/… or SteamID'**
  String get steamAccountHint;

  /// No description provided for @accountImportNeedsKey.
  ///
  /// In en, this message translates to:
  /// **'{service} is not set up: its API key is missing from the build.'**
  String accountImportNeedsKey(String service);

  /// No description provided for @accountImportNeedsCategory.
  ///
  /// In en, this message translates to:
  /// **'Create a category of this type first to hold the import.'**
  String get accountImportNeedsCategory;

  /// No description provided for @accountImportReading.
  ///
  /// In en, this message translates to:
  /// **'Reading the library…'**
  String get accountImportReading;

  /// No description provided for @accountNotFound.
  ///
  /// In en, this message translates to:
  /// **'{service} account not found or private.'**
  String accountNotFound(String service);

  /// No description provided for @playniteImportExplanation.
  ///
  /// In en, this message translates to:
  /// **'Playnite (PC) gathers Steam, Epic, GOG, Ubisoft Connect, EA, Battle.net, Amazon, Xbox… Install the “Library Exporter Advanced” extension, tick Developers, Platforms, Source and Release date, then export the whole library as CSV. Copy the file to your phone and pick it here. Each game is looked up on IGDB for its cover; the launcher becomes its edition.'**
  String get playniteImportExplanation;

  /// No description provided for @chooseExportFile.
  ///
  /// In en, this message translates to:
  /// **'Choose the CSV export'**
  String get chooseExportFile;

  /// No description provided for @exportFileUnreadable.
  ///
  /// In en, this message translates to:
  /// **'This file cannot be read as a Playnite export.'**
  String get exportFileUnreadable;

  /// No description provided for @boardGameGeekImportExplanation.
  ///
  /// In en, this message translates to:
  /// **'Adds the games marked “owned” in your BoardGameGeek collection, expansions included. BGG sometimes prepares the collection first: the import waits a few seconds.'**
  String get boardGameGeekImportExplanation;

  /// No description provided for @itchIoImportExplanation.
  ///
  /// In en, this message translates to:
  /// **'Adds the games bought or claimed on your itch.io account. Create a key in itch.io › Settings › API keys and paste it here: it is only used for this import and is not kept.'**
  String get itchIoImportExplanation;

  /// No description provided for @myAnimeListImportExplanation.
  ///
  /// In en, this message translates to:
  /// **'Adds the manga of your MyAnimeList list with your progress (reading, read, dropped). It is your reading list: remove what you do not own afterwards.'**
  String get myAnimeListImportExplanation;

  /// No description provided for @rebrickableImportExplanation.
  ///
  /// In en, this message translates to:
  /// **'Adds the LEGO sets of your Rebrickable collection. Your password is used once to access your collection: it is neither kept nor sent anywhere but Rebrickable.'**
  String get rebrickableImportExplanation;

  /// No description provided for @personalApiKeyLabel.
  ///
  /// In en, this message translates to:
  /// **'Your personal API key'**
  String get personalApiKeyLabel;

  /// No description provided for @personalApiKeyHint.
  ///
  /// In en, this message translates to:
  /// **'Pasted from the site settings'**
  String get personalApiKeyHint;

  /// No description provided for @accountPasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get accountPasswordLabel;

  /// No description provided for @accountPasswordNotKept.
  ///
  /// In en, this message translates to:
  /// **'Used once, never saved'**
  String get accountPasswordNotKept;

  /// No description provided for @importDeckList.
  ///
  /// In en, this message translates to:
  /// **'Import a deck from Archidekt'**
  String get importDeckList;

  /// No description provided for @deckListLink.
  ///
  /// In en, this message translates to:
  /// **'Deck link'**
  String get deckListLink;

  /// No description provided for @deckListNotFound.
  ///
  /// In en, this message translates to:
  /// **'Deck not found: check the link and that the deck is public.'**
  String get deckListNotFound;

  /// No description provided for @accountImportTarget.
  ///
  /// In en, this message translates to:
  /// **'Add to'**
  String get accountImportTarget;

  /// No description provided for @steamAccountLabel.
  ///
  /// In en, this message translates to:
  /// **'Your Steam profile link or SteamID'**
  String get steamAccountLabel;

  /// No description provided for @steamAccountHelper.
  ///
  /// In en, this message translates to:
  /// **'Steam › your profile › right-click the page › Copy page URL. Your display name does not work: only the name in the address (steamcommunity.com/id/…) or the number (…/profiles/7656…) is recognised.'**
  String get steamAccountHelper;

  /// No description provided for @steamProfileNotFound.
  ///
  /// In en, this message translates to:
  /// **'No Steam profile has the address “{name}”. Paste your profile link (Steam › your profile › Copy page URL): your display name is not the address.'**
  String steamProfileNotFound(String name);

  /// No description provided for @steamLibraryPrivate.
  ///
  /// In en, this message translates to:
  /// **'Profile found, but your game list is private. Steam › Profile › Edit Profile › Privacy Settings › “Game details”: Public.'**
  String get steamLibraryPrivate;

  /// No description provided for @libraryPrivate.
  ///
  /// In en, this message translates to:
  /// **'{service} account found, but its library is private.'**
  String libraryPrivate(String service);

  /// No description provided for @keepAccountSynced.
  ///
  /// In en, this message translates to:
  /// **'Sync automatically'**
  String get keepAccountSynced;

  /// No description provided for @keepAccountSyncedExplanation.
  ///
  /// In en, this message translates to:
  /// **'New additions on this account arrive in Akashic on their own (at launch, every 6 h at most). What you delete here does not come back.'**
  String get keepAccountSyncedExplanation;

  /// No description provided for @linkedAccountsTitle.
  ///
  /// In en, this message translates to:
  /// **'Synced accounts'**
  String get linkedAccountsTitle;

  /// No description provided for @lastSyncedAt.
  ///
  /// In en, this message translates to:
  /// **'synced {date}'**
  String lastSyncedAt(String date);

  /// No description provided for @syncNow.
  ///
  /// In en, this message translates to:
  /// **'Sync now'**
  String get syncNow;

  /// No description provided for @stopSyncing.
  ///
  /// In en, this message translates to:
  /// **'Stop syncing'**
  String get stopSyncing;

  /// No description provided for @rarityCommon.
  ///
  /// In en, this message translates to:
  /// **'Common'**
  String get rarityCommon;

  /// No description provided for @rarityRare.
  ///
  /// In en, this message translates to:
  /// **'Rare'**
  String get rarityRare;

  /// No description provided for @rarityEpic.
  ///
  /// In en, this message translates to:
  /// **'Epic'**
  String get rarityEpic;

  /// No description provided for @rarityLegendary.
  ///
  /// In en, this message translates to:
  /// **'Legendary'**
  String get rarityLegendary;

  /// No description provided for @achievementsTab.
  ///
  /// In en, this message translates to:
  /// **'Achievements'**
  String get achievementsTab;

  /// No description provided for @achievementsAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get achievementsAll;

  /// No description provided for @achievementsUnlocked.
  ///
  /// In en, this message translates to:
  /// **'Unlocked'**
  String get achievementsUnlocked;

  /// No description provided for @achievementsLocked.
  ///
  /// In en, this message translates to:
  /// **'To unlock'**
  String get achievementsLocked;

  /// No description provided for @achievementsRare.
  ///
  /// In en, this message translates to:
  /// **'Rare'**
  String get achievementsRare;

  /// No description provided for @achievementsSummary.
  ///
  /// In en, this message translates to:
  /// **'{unlocked} of {total} achievements unlocked, {percent}%'**
  String achievementsSummary(int unlocked, int total, int percent);

  /// No description provided for @achievementsRemaining.
  ///
  /// In en, this message translates to:
  /// **'{remaining, plural, =0{Every achievement unlocked} =1{1 left} other{{remaining} left}}{legendary, plural, =0{} =1{, 1 legendary} other{, {legendary} legendary}}'**
  String achievementsRemaining(int remaining, int legendary);

  /// No description provided for @achievementPlayersPercent.
  ///
  /// In en, this message translates to:
  /// **'unlocked by {percent}% of players'**
  String achievementPlayersPercent(String percent);

  /// No description provided for @achievementUnlockedOn.
  ///
  /// In en, this message translates to:
  /// **'Unlocked on {date}'**
  String achievementUnlockedOn(String date);

  /// No description provided for @achievementLocked.
  ///
  /// In en, this message translates to:
  /// **'To unlock'**
  String get achievementLocked;

  /// No description provided for @hiddenAchievement.
  ///
  /// In en, this message translates to:
  /// **'Hidden achievement'**
  String get hiddenAchievement;

  /// No description provided for @steamAchievementsNeedAccount.
  ///
  /// In en, this message translates to:
  /// **'Link your Steam account (Settings › Import from an account) to see your achievements.'**
  String get steamAchievementsNeedAccount;

  /// No description provided for @steamAchievementsUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Steam is not answering right now.'**
  String get steamAchievementsUnavailable;

  /// No description provided for @steamNoAchievements.
  ///
  /// In en, this message translates to:
  /// **'This game has no Steam achievements.'**
  String get steamNoAchievements;

  /// No description provided for @achievementsListCaption.
  ///
  /// In en, this message translates to:
  /// **'{count} achievements{lockedFirst, select, yes{ · to unlock first} other{}} · sorted by {sortLabel}'**
  String achievementsListCaption(
    int count,
    String lockedFirst,
    String sortLabel,
  );

  /// No description provided for @achievementSortRarity.
  ///
  /// In en, this message translates to:
  /// **'rarity'**
  String get achievementSortRarity;

  /// No description provided for @achievementSortDate.
  ///
  /// In en, this message translates to:
  /// **'date'**
  String get achievementSortDate;

  /// No description provided for @achievementSortName.
  ///
  /// In en, this message translates to:
  /// **'name'**
  String get achievementSortName;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get retry;

  /// No description provided for @steamStorePageMissing.
  ///
  /// In en, this message translates to:
  /// **'Steam has no store page for this game in your region.'**
  String get steamStorePageMissing;

  /// No description provided for @steamNewsTitle.
  ///
  /// In en, this message translates to:
  /// **'News'**
  String get steamNewsTitle;

  /// No description provided for @steamDlcTitle.
  ///
  /// In en, this message translates to:
  /// **'Downloadable content'**
  String get steamDlcTitle;

  /// No description provided for @steamDlcOwnershipNote.
  ///
  /// In en, this message translates to:
  /// **'Steam does not say which DLC you own: only those in your Akashic collection are marked.'**
  String get steamDlcOwnershipNote;

  /// No description provided for @steamAboutTitle.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get steamAboutTitle;

  /// No description provided for @steamDeveloper.
  ///
  /// In en, this message translates to:
  /// **'Developer'**
  String get steamDeveloper;

  /// No description provided for @steamPublisher.
  ///
  /// In en, this message translates to:
  /// **'Publisher'**
  String get steamPublisher;

  /// No description provided for @steamReleaseDate.
  ///
  /// In en, this message translates to:
  /// **'Release'**
  String get steamReleaseDate;

  /// No description provided for @steamMediaTitle.
  ///
  /// In en, this message translates to:
  /// **'Screenshots and trailer'**
  String get steamMediaTitle;

  /// No description provided for @steamTrailer.
  ///
  /// In en, this message translates to:
  /// **'Trailer, opens on Steam'**
  String get steamTrailer;

  /// No description provided for @steamScreenshot.
  ///
  /// In en, this message translates to:
  /// **'Screenshot {number}'**
  String steamScreenshot(int number);

  /// No description provided for @steamFeaturesTitle.
  ///
  /// In en, this message translates to:
  /// **'Modes and features'**
  String get steamFeaturesTitle;

  /// No description provided for @steamLanguagesTitle.
  ///
  /// In en, this message translates to:
  /// **'Languages'**
  String get steamLanguagesTitle;

  /// No description provided for @steamRequirementsTitle.
  ///
  /// In en, this message translates to:
  /// **'System requirements'**
  String get steamRequirementsTitle;

  /// No description provided for @steamOpenStore.
  ///
  /// In en, this message translates to:
  /// **'View on Steam'**
  String get steamOpenStore;

  /// No description provided for @steamFree.
  ///
  /// In en, this message translates to:
  /// **'Free'**
  String get steamFree;

  /// No description provided for @steamNoPrice.
  ///
  /// In en, this message translates to:
  /// **'No price given'**
  String get steamNoPrice;

  /// No description provided for @steamPriceBefore.
  ///
  /// In en, this message translates to:
  /// **'instead of {price}'**
  String steamPriceBefore(String price);

  /// No description provided for @steamPriceToday.
  ///
  /// In en, this message translates to:
  /// **'Steam price today'**
  String get steamPriceToday;

  /// No description provided for @steamDlcInCollection.
  ///
  /// In en, this message translates to:
  /// **'In your collection'**
  String get steamDlcInCollection;

  /// No description provided for @steamComingOn.
  ///
  /// In en, this message translates to:
  /// **'Release: {date}'**
  String steamComingOn(String date);

  /// No description provided for @steamDlcWished.
  ///
  /// In en, this message translates to:
  /// **'Added to your wishes'**
  String get steamDlcWished;

  /// No description provided for @steamWishAction.
  ///
  /// In en, this message translates to:
  /// **'Wish'**
  String get steamWishAction;

  /// No description provided for @steamPlaytime.
  ///
  /// In en, this message translates to:
  /// **'Playtime'**
  String get steamPlaytime;

  /// No description provided for @steamPlaytimeSummary.
  ///
  /// In en, this message translates to:
  /// **'Playtime: {total} in total, {recent} in the last 14 days'**
  String steamPlaytimeSummary(String total, String recent);

  /// No description provided for @steamRecentPlaytime.
  ///
  /// In en, this message translates to:
  /// **'{duration} in the last 14 days'**
  String steamRecentPlaytime(String duration);

  /// No description provided for @steamNotPlayedRecently.
  ///
  /// In en, this message translates to:
  /// **'Not played in the last 14 days'**
  String get steamNotPlayedRecently;

  /// No description provided for @steamLastPlayed.
  ///
  /// In en, this message translates to:
  /// **'Last played on {date}'**
  String steamLastPlayed(String date);

  /// No description provided for @steamNeverPlayed.
  ///
  /// In en, this message translates to:
  /// **'Never launched'**
  String get steamNeverPlayed;

  /// No description provided for @steamStatus.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get steamStatus;

  /// No description provided for @steamNoStatus.
  ///
  /// In en, this message translates to:
  /// **'None'**
  String get steamNoStatus;

  /// No description provided for @steamStatusChange.
  ///
  /// In en, this message translates to:
  /// **'Status: {status}. Tap for the next one.'**
  String steamStatusChange(String status);

  /// No description provided for @steamStatusAutomatic.
  ///
  /// In en, this message translates to:
  /// **'auto · Steam'**
  String get steamStatusAutomatic;

  /// No description provided for @steamStatusManual.
  ///
  /// In en, this message translates to:
  /// **'set by hand'**
  String get steamStatusManual;

  /// No description provided for @steamDeck.
  ///
  /// In en, this message translates to:
  /// **'Steam Deck'**
  String get steamDeck;

  /// No description provided for @steamDeckVerified.
  ///
  /// In en, this message translates to:
  /// **'Verified'**
  String get steamDeckVerified;

  /// No description provided for @steamDeckPlayable.
  ///
  /// In en, this message translates to:
  /// **'Playable'**
  String get steamDeckPlayable;

  /// No description provided for @steamDeckUnsupported.
  ///
  /// In en, this message translates to:
  /// **'Unsupported'**
  String get steamDeckUnsupported;

  /// No description provided for @steamDeckUnknown.
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get steamDeckUnknown;

  /// No description provided for @steamDeckVerifiedDetail.
  ///
  /// In en, this message translates to:
  /// **'Controls, display and text checked'**
  String get steamDeckVerifiedDetail;

  /// No description provided for @steamDeckPlayableDetail.
  ///
  /// In en, this message translates to:
  /// **'Some manual tweaking'**
  String get steamDeckPlayableDetail;

  /// No description provided for @steamDeckUnsupportedDetail.
  ///
  /// In en, this message translates to:
  /// **'Does not run on Steam Deck'**
  String get steamDeckUnsupportedDetail;

  /// No description provided for @steamDeckUnknownDetail.
  ///
  /// In en, this message translates to:
  /// **'Not yet reviewed by Valve'**
  String get steamDeckUnknownDetail;

  /// No description provided for @steamMyCopy.
  ///
  /// In en, this message translates to:
  /// **'My game'**
  String get steamMyCopy;

  /// No description provided for @steamCopyPlatform.
  ///
  /// In en, this message translates to:
  /// **'Platform'**
  String get steamCopyPlatform;

  /// No description provided for @steamCopyPrice.
  ///
  /// In en, this message translates to:
  /// **'Price paid'**
  String get steamCopyPrice;

  /// No description provided for @steamCopyAdded.
  ///
  /// In en, this message translates to:
  /// **'Added on'**
  String get steamCopyAdded;

  /// No description provided for @steamUpdatedAt.
  ///
  /// In en, this message translates to:
  /// **'Updated from Steam on {date}'**
  String steamUpdatedAt(String date);

  /// No description provided for @steamRarestAchievement.
  ///
  /// In en, this message translates to:
  /// **'Rarest'**
  String get steamRarestAchievement;

  /// No description provided for @steamNoRareAchievement.
  ///
  /// In en, this message translates to:
  /// **'No achievement unlocked yet'**
  String get steamNoRareAchievement;

  /// No description provided for @steamStatsTitle.
  ///
  /// In en, this message translates to:
  /// **'Video games'**
  String get steamStatsTitle;

  /// No description provided for @steamTotalPlaytime.
  ///
  /// In en, this message translates to:
  /// **'Playtime'**
  String get steamTotalPlaytime;

  /// No description provided for @steamGameCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 Steam game} other{{count} Steam games}}'**
  String steamGameCount(int count);

  /// No description provided for @steamAverageCompletion.
  ///
  /// In en, this message translates to:
  /// **'Achievements done'**
  String get steamAverageCompletion;

  /// No description provided for @steamAverageCompletionCaption.
  ///
  /// In en, this message translates to:
  /// **'on average across launched games'**
  String get steamAverageCompletionCaption;

  /// No description provided for @steamShelfOfShame.
  ///
  /// In en, this message translates to:
  /// **'Pile of shame'**
  String get steamShelfOfShame;

  /// No description provided for @steamNeverLaunchedCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 game never launched} other{{count} games never launched}}'**
  String steamNeverLaunchedCount(int count);

  /// No description provided for @steamTopPlayed.
  ///
  /// In en, this message translates to:
  /// **'Most played'**
  String get steamTopPlayed;

  /// No description provided for @steamLibraryValue.
  ///
  /// In en, this message translates to:
  /// **'Steam library value'**
  String get steamLibraryValue;

  /// No description provided for @steamLibraryValueNote.
  ///
  /// In en, this message translates to:
  /// **'at today\'s Steam store price, not a resale value'**
  String get steamLibraryValueNote;

  /// No description provided for @steamPricesOf.
  ///
  /// In en, this message translates to:
  /// **'prices of {date}'**
  String steamPricesOf(String date);

  /// No description provided for @syncReading.
  ///
  /// In en, this message translates to:
  /// **'Syncing {service}…'**
  String syncReading(String service);

  /// No description provided for @syncProgress.
  ///
  /// In en, this message translates to:
  /// **'Syncing {service} · {done} / {total}'**
  String syncProgress(String service, int done, int total);

  /// No description provided for @syncRefreshingDetails.
  ///
  /// In en, this message translates to:
  /// **'{service} · updating statistics…'**
  String syncRefreshingDetails(String service);

  /// No description provided for @cardKindSealed.
  ///
  /// In en, this message translates to:
  /// **'Sealed'**
  String get cardKindSealed;

  /// No description provided for @tradeHistory.
  ///
  /// In en, this message translates to:
  /// **'Purchases and sales'**
  String get tradeHistory;

  /// No description provided for @tradeSpent.
  ///
  /// In en, this message translates to:
  /// **'Spent'**
  String get tradeSpent;

  /// No description provided for @tradeEarned.
  ///
  /// In en, this message translates to:
  /// **'Sales'**
  String get tradeEarned;

  /// No description provided for @tradeMargin.
  ///
  /// In en, this message translates to:
  /// **'Margin'**
  String get tradeMargin;

  /// No description provided for @tradeMarginCaption.
  ///
  /// In en, this message translates to:
  /// **'on sales with a known purchase price'**
  String get tradeMarginCaption;

  /// No description provided for @noTrades.
  ///
  /// In en, this message translates to:
  /// **'No purchases or sales yet. Fill in what you paid for an item, or sell one from its page.'**
  String get noTrades;

  /// No description provided for @tradePurchase.
  ///
  /// In en, this message translates to:
  /// **'Purchase'**
  String get tradePurchase;

  /// No description provided for @tradeSale.
  ///
  /// In en, this message translates to:
  /// **'Sale'**
  String get tradeSale;

  /// No description provided for @channelStore.
  ///
  /// In en, this message translates to:
  /// **'In store'**
  String get channelStore;

  /// No description provided for @channelOnline.
  ///
  /// In en, this message translates to:
  /// **'Online'**
  String get channelOnline;

  /// No description provided for @sealedState.
  ///
  /// In en, this message translates to:
  /// **'Sealed'**
  String get sealedState;

  /// No description provided for @openedState.
  ///
  /// In en, this message translates to:
  /// **'Opened'**
  String get openedState;

  /// No description provided for @productOpened.
  ///
  /// In en, this message translates to:
  /// **'Opened product'**
  String get productOpened;

  /// No description provided for @marginOf.
  ///
  /// In en, this message translates to:
  /// **'{amount} margin'**
  String marginOf(String amount);

  /// No description provided for @purchaseDate.
  ///
  /// In en, this message translates to:
  /// **'Purchase date'**
  String get purchaseDate;

  /// No description provided for @purchaseChannel.
  ///
  /// In en, this message translates to:
  /// **'Bought'**
  String get purchaseChannel;

  /// No description provided for @boughtOn.
  ///
  /// In en, this message translates to:
  /// **'Bought on {when}'**
  String boughtOn(String when);

  /// No description provided for @noDateSet.
  ///
  /// In en, this message translates to:
  /// **'Not set'**
  String get noDateSet;

  /// No description provided for @sellCopy.
  ///
  /// In en, this message translates to:
  /// **'Sell'**
  String get sellCopy;

  /// No description provided for @salePrice.
  ///
  /// In en, this message translates to:
  /// **'Sale price'**
  String get salePrice;

  /// No description provided for @saleDate.
  ///
  /// In en, this message translates to:
  /// **'Sale date'**
  String get saleDate;

  /// No description provided for @saleChannel.
  ///
  /// In en, this message translates to:
  /// **'Sold'**
  String get saleChannel;

  /// No description provided for @sell.
  ///
  /// In en, this message translates to:
  /// **'Sell'**
  String get sell;

  /// No description provided for @sellLastCopyExplanation.
  ///
  /// In en, this message translates to:
  /// **'The item leaves your collection, the sale stays in the history.'**
  String get sellLastCopyExplanation;

  /// No description provided for @clearPurchaseDate.
  ///
  /// In en, this message translates to:
  /// **'Clear the purchase date'**
  String get clearPurchaseDate;

  /// No description provided for @sealedMarketPrice.
  ///
  /// In en, this message translates to:
  /// **'Cardmarket price'**
  String get sealedMarketPrice;

  /// No description provided for @sealedMarketPriceSealedOnly.
  ///
  /// In en, this message translates to:
  /// **'Sealed product'**
  String get sealedMarketPriceSealedOnly;

  /// No description provided for @sealedPriceTrend.
  ///
  /// In en, this message translates to:
  /// **'Trend'**
  String get sealedPriceTrend;

  /// No description provided for @sealedPriceLow.
  ///
  /// In en, this message translates to:
  /// **'Lowest'**
  String get sealedPriceLow;

  /// No description provided for @sealedPriceAverage.
  ///
  /// In en, this message translates to:
  /// **'Average sale'**
  String get sealedPriceAverage;

  /// No description provided for @sealedPriceAverage1.
  ///
  /// In en, this message translates to:
  /// **'1-day average'**
  String get sealedPriceAverage1;

  /// No description provided for @sealedPriceAverage7.
  ///
  /// In en, this message translates to:
  /// **'7-day average'**
  String get sealedPriceAverage7;

  /// No description provided for @sealedPriceAverage30.
  ///
  /// In en, this message translates to:
  /// **'30-day average'**
  String get sealedPriceAverage30;

  /// No description provided for @sealedPricedOn.
  ///
  /// In en, this message translates to:
  /// **'Prices of {when}'**
  String sealedPricedOn(String when);

  /// No description provided for @sealedPriceMissing.
  ///
  /// In en, this message translates to:
  /// **'No price for this product yet: update the prices.'**
  String get sealedPriceMissing;

  /// No description provided for @sealedOpenedHasNoPrice.
  ///
  /// In en, this message translates to:
  /// **'Cardmarket only prices sealed products: an opened product has no separate price.'**
  String get sealedOpenedHasNoPrice;

  /// No description provided for @refreshSealedPrices.
  ///
  /// In en, this message translates to:
  /// **'Update prices'**
  String get refreshSealedPrices;

  /// No description provided for @meteredDownloadTitle.
  ///
  /// In en, this message translates to:
  /// **'Mobile data'**
  String get meteredDownloadTitle;

  /// No description provided for @meteredDownloadBody.
  ///
  /// In en, this message translates to:
  /// **'You are on mobile data. The update downloads about {size} from Cardmarket. Continue?'**
  String meteredDownloadBody(String size);

  /// No description provided for @meteredDownloadUnknownSize.
  ///
  /// In en, this message translates to:
  /// **'You are on mobile data. The update downloads the Cardmarket price file, about 16 MB per game. Continue?'**
  String get meteredDownloadUnknownSize;

  /// No description provided for @continueAnyway.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueAnyway;

  /// No description provided for @sealedPricesUpdated.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{No price found} =1{1 price updated} other{{count} prices updated}}'**
  String sealedPricesUpdated(int count);

  /// No description provided for @sealedPricesUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Cardmarket cannot be reached right now, try again later.'**
  String get sealedPricesUnavailable;

  /// No description provided for @scanModeBarcode.
  ///
  /// In en, this message translates to:
  /// **'Barcode'**
  String get scanModeBarcode;

  /// No description provided for @scanModeCover.
  ///
  /// In en, this message translates to:
  /// **'Cover'**
  String get scanModeCover;

  /// No description provided for @scanModeShelf.
  ///
  /// In en, this message translates to:
  /// **'Shelf'**
  String get scanModeShelf;

  /// No description provided for @scanHintBarcodeTitle.
  ///
  /// In en, this message translates to:
  /// **'Aim at the barcode'**
  String get scanHintBarcodeTitle;

  /// No description provided for @scanHintBarcodeDetail.
  ///
  /// In en, this message translates to:
  /// **'Read automatically, no tap needed'**
  String get scanHintBarcodeDetail;

  /// No description provided for @scanHintCoverTitle.
  ///
  /// In en, this message translates to:
  /// **'Frame the cover, then tap'**
  String get scanHintCoverTitle;

  /// No description provided for @scanHintCoverDetail.
  ///
  /// In en, this message translates to:
  /// **'One item per photo'**
  String get scanHintCoverDetail;

  /// No description provided for @scanHintShelfTitle.
  ///
  /// In en, this message translates to:
  /// **'Line the spines up in the frame'**
  String get scanHintShelfTitle;

  /// No description provided for @scanHintShelfDetail.
  ///
  /// In en, this message translates to:
  /// **'Up to 24 items at once'**
  String get scanHintShelfDetail;

  /// No description provided for @continuousReading.
  ///
  /// In en, this message translates to:
  /// **'Reading continuously'**
  String get continuousReading;

  /// No description provided for @scansPileHere.
  ///
  /// In en, this message translates to:
  /// **'Your scans will pile up here'**
  String get scansPileHere;

  /// No description provided for @toAdd.
  ///
  /// In en, this message translates to:
  /// **'to add'**
  String get toAdd;

  /// No description provided for @chainScannedCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 scanned} other{{count} scanned}}'**
  String chainScannedCount(int count);

  /// No description provided for @chainOwnedCount.
  ///
  /// In en, this message translates to:
  /// **'{count} already yours'**
  String chainOwnedCount(int count);

  /// No description provided for @chainMissingCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 not found} other{{count} not found}}'**
  String chainMissingCount(int count);

  /// No description provided for @shelfSpinesRead.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 spine read} other{{count} spines read}}'**
  String shelfSpinesRead(int count);

  /// No description provided for @shelfSpinesSearching.
  ///
  /// In en, this message translates to:
  /// **'{count} being searched'**
  String shelfSpinesSearching(int count);

  /// No description provided for @chainGroupToAdd.
  ///
  /// In en, this message translates to:
  /// **'To add'**
  String get chainGroupToAdd;

  /// No description provided for @chainGroupOwned.
  ///
  /// In en, this message translates to:
  /// **'Already in your collection'**
  String get chainGroupOwned;

  /// No description provided for @chainGroupMissing.
  ///
  /// In en, this message translates to:
  /// **'Not found'**
  String get chainGroupMissing;

  /// No description provided for @chainSourceBarcode.
  ///
  /// In en, this message translates to:
  /// **'Barcode'**
  String get chainSourceBarcode;

  /// No description provided for @chainSourceCover.
  ///
  /// In en, this message translates to:
  /// **'Cover'**
  String get chainSourceCover;

  /// No description provided for @chainSourceShelf.
  ///
  /// In en, this message translates to:
  /// **'Shelf'**
  String get chainSourceShelf;

  /// No description provided for @shelfUnreadableTitle.
  ///
  /// In en, this message translates to:
  /// **'No readable spine'**
  String get shelfUnreadableTitle;

  /// No description provided for @shelfUnreadableHint.
  ///
  /// In en, this message translates to:
  /// **'Move closer and line the spines up in the frame.'**
  String get shelfUnreadableHint;

  /// No description provided for @coverUnreadableHint.
  ///
  /// In en, this message translates to:
  /// **'Take the photo again, closer and without glare.'**
  String get coverUnreadableHint;

  /// No description provided for @showScannedList.
  ///
  /// In en, this message translates to:
  /// **'Show the scan list'**
  String get showScannedList;

  /// No description provided for @hideScannedList.
  ///
  /// In en, this message translates to:
  /// **'Fold the scan list'**
  String get hideScannedList;

  /// No description provided for @addAnotherItem.
  ///
  /// In en, this message translates to:
  /// **'I own another one'**
  String get addAnotherItem;

  /// No description provided for @anotherItemAdded.
  ///
  /// In en, this message translates to:
  /// **'Added once more'**
  String get anotherItemAdded;

  /// No description provided for @fillObjectDetails.
  ///
  /// In en, this message translates to:
  /// **'Fill in purchase, condition, storage'**
  String get fillObjectDetails;

  /// No description provided for @itemCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 item} other{{count} items}}'**
  String itemCount(int count);

  /// No description provided for @wishOriginSteamWishlist.
  ///
  /// In en, this message translates to:
  /// **'Steam wishlist'**
  String get wishOriginSteamWishlist;

  /// No description provided for @steamWishlistUnavailable.
  ///
  /// In en, this message translates to:
  /// **'The Steam wishlist could not be read: check that your profile and wishlist are public.'**
  String get steamWishlistUnavailable;

  /// No description provided for @discoveriesSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Title, author, starting item'**
  String get discoveriesSearchHint;

  /// No description provided for @filterNotWished.
  ///
  /// In en, this message translates to:
  /// **'Not wished'**
  String get filterNotWished;

  /// No description provided for @filterRecent.
  ///
  /// In en, this message translates to:
  /// **'Recent'**
  String get filterRecent;

  /// No description provided for @noFilteredDiscoveries.
  ///
  /// In en, this message translates to:
  /// **'No discovery matches the filters.'**
  String get noFilteredDiscoveries;

  /// No description provided for @resetFilters.
  ///
  /// In en, this message translates to:
  /// **'Clear the filters'**
  String get resetFilters;

  /// No description provided for @releasesSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Title, series, artist'**
  String get releasesSearchHint;

  /// No description provided for @filterConfirmedDates.
  ///
  /// In en, this message translates to:
  /// **'Confirmed dates'**
  String get filterConfirmedDates;

  /// No description provided for @filterWished.
  ///
  /// In en, this message translates to:
  /// **'Wished'**
  String get filterWished;

  /// No description provided for @releaseKindCardSet.
  ///
  /// In en, this message translates to:
  /// **'Card sets'**
  String get releaseKindCardSet;

  /// No description provided for @releaseKindNextVolume.
  ///
  /// In en, this message translates to:
  /// **'Volumes'**
  String get releaseKindNextVolume;

  /// No description provided for @releaseKindAlbum.
  ///
  /// In en, this message translates to:
  /// **'Albums'**
  String get releaseKindAlbum;

  /// No description provided for @noFilteredReleases.
  ///
  /// In en, this message translates to:
  /// **'No release matches the filters.'**
  String get noFilteredReleases;

  /// No description provided for @stepSearch.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get stepSearch;

  /// No description provided for @stepCheck.
  ///
  /// In en, this message translates to:
  /// **'Check'**
  String get stepCheck;

  /// No description provided for @enterByHand.
  ///
  /// In en, this message translates to:
  /// **'Enter by hand'**
  String get enterByHand;

  /// No description provided for @addToNamedCategory.
  ///
  /// In en, this message translates to:
  /// **'Add to {category}'**
  String addToNamedCategory(String category);

  /// No description provided for @moreDetails.
  ///
  /// In en, this message translates to:
  /// **'More details'**
  String get moreDetails;

  /// No description provided for @detailsSection.
  ///
  /// In en, this message translates to:
  /// **'Details'**
  String get detailsSection;

  /// No description provided for @coverSection.
  ///
  /// In en, this message translates to:
  /// **'Cover'**
  String get coverSection;

  /// No description provided for @volumeShort.
  ///
  /// In en, this message translates to:
  /// **'Vol. {number}'**
  String volumeShort(int number);

  /// No description provided for @searchResultsEmpty.
  ///
  /// In en, this message translates to:
  /// **'Type a title, scan a barcode, or enter the item by hand.'**
  String get searchResultsEmpty;

  /// No description provided for @categoryTypeStepTitle.
  ///
  /// In en, this message translates to:
  /// **'What will you shelve?'**
  String get categoryTypeStepTitle;

  /// No description provided for @categoryDetailsStepTitle.
  ///
  /// In en, this message translates to:
  /// **'Category details'**
  String get categoryDetailsStepTitle;

  /// No description provided for @continueAction.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueAction;

  /// No description provided for @changeAction.
  ///
  /// In en, this message translates to:
  /// **'Change'**
  String get changeAction;

  /// No description provided for @categoryPreviewEmpty.
  ///
  /// In en, this message translates to:
  /// **'New category'**
  String get categoryPreviewEmpty;

  /// No description provided for @categoryTypeLabel.
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get categoryTypeLabel;

  /// No description provided for @categoryDangerZone.
  ///
  /// In en, this message translates to:
  /// **'Delete the category'**
  String get categoryDangerZone;

  /// No description provided for @categoryDangerZoneExplanation.
  ///
  /// In en, this message translates to:
  /// **'Its items, series and subcategories go with it. This can’t be undone.'**
  String get categoryDangerZoneExplanation;

  /// No description provided for @exportSpreadsheet.
  ///
  /// In en, this message translates to:
  /// **'Export as a spreadsheet (CSV)'**
  String get exportSpreadsheet;

  /// No description provided for @exportSpreadsheetDone.
  ///
  /// In en, this message translates to:
  /// **'Collection exported: {count, plural, =1{1 item} other{{count} items}}.'**
  String exportSpreadsheetDone(int count);

  /// No description provided for @exportSpreadsheetFailed.
  ///
  /// In en, this message translates to:
  /// **'The export could not be saved.'**
  String get exportSpreadsheetFailed;

  /// No description provided for @exportHeaders.
  ///
  /// In en, this message translates to:
  /// **'Category|Subcategory|Title|Creator|Year|Publisher|Series|Volume|Platform|Edition|Barcode|Price paid|Purchase date|Bought|Location|Condition|Rating|Lent to|Estimated value|Currency|Added on'**
  String get exportHeaders;

  /// No description provided for @steamAlertsChannelName.
  ///
  /// In en, this message translates to:
  /// **'Steam'**
  String get steamAlertsChannelName;

  /// No description provided for @steamAlertsChannelDescription.
  ///
  /// In en, this message translates to:
  /// **'Sales and releases of your Steam wishes, new DLC for your games'**
  String get steamAlertsChannelDescription;

  /// No description provided for @steamWishOnSaleTitle.
  ///
  /// In en, this message translates to:
  /// **'{title} is on sale'**
  String steamWishOnSaleTitle(String title);

  /// No description provided for @steamWishOnSaleBody.
  ///
  /// In en, this message translates to:
  /// **'-{percent}%: {price} on Steam'**
  String steamWishOnSaleBody(int percent, String price);

  /// No description provided for @steamWishReleasedTitle.
  ///
  /// In en, this message translates to:
  /// **'{title} is out'**
  String steamWishReleasedTitle(String title);

  /// No description provided for @steamWishReleasedBody.
  ///
  /// In en, this message translates to:
  /// **'A game from your wishes is available on Steam.'**
  String get steamWishReleasedBody;

  /// No description provided for @steamNewDlcTitle.
  ///
  /// In en, this message translates to:
  /// **'New DLC for {title}'**
  String steamNewDlcTitle(String title);

  /// No description provided for @steamNewDlcBodyUnnamed.
  ///
  /// In en, this message translates to:
  /// **'New content is available on Steam.'**
  String get steamNewDlcBodyUnnamed;

  /// No description provided for @steamWishComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Coming soon on Steam'**
  String get steamWishComingSoon;

  /// No description provided for @priceAlertsChannelName.
  ///
  /// In en, this message translates to:
  /// **'Price alerts'**
  String get priceAlertsChannelName;

  /// No description provided for @priceAlertsChannelDescription.
  ///
  /// In en, this message translates to:
  /// **'When a sealed product\'s price crosses your threshold'**
  String get priceAlertsChannelDescription;

  /// No description provided for @priceAlertAboveTitle.
  ///
  /// In en, this message translates to:
  /// **'{title} went above your threshold'**
  String priceAlertAboveTitle(String title);

  /// No description provided for @priceAlertBelowTitle.
  ///
  /// In en, this message translates to:
  /// **'{title} went below your threshold'**
  String priceAlertBelowTitle(String title);

  /// No description provided for @priceAlertBody.
  ///
  /// In en, this message translates to:
  /// **'Cardmarket price: {price} (threshold {threshold})'**
  String priceAlertBody(String price, String threshold);

  /// No description provided for @priceAlert.
  ///
  /// In en, this message translates to:
  /// **'Price alert'**
  String get priceAlert;

  /// No description provided for @priceAlertAbove.
  ///
  /// In en, this message translates to:
  /// **'Above'**
  String get priceAlertAbove;

  /// No description provided for @priceAlertBelow.
  ///
  /// In en, this message translates to:
  /// **'Below'**
  String get priceAlertBelow;

  /// No description provided for @priceAlertThreshold.
  ///
  /// In en, this message translates to:
  /// **'Threshold'**
  String get priceAlertThreshold;

  /// No description provided for @priceAlertSummary.
  ///
  /// In en, this message translates to:
  /// **'Alert {direction} {threshold}'**
  String priceAlertSummary(String direction, String threshold);

  /// No description provided for @removePriceAlert.
  ///
  /// In en, this message translates to:
  /// **'Remove the alert'**
  String get removePriceAlert;

  /// No description provided for @displaySection.
  ///
  /// In en, this message translates to:
  /// **'Display'**
  String get displaySection;

  /// No description provided for @highContrast.
  ///
  /// In en, this message translates to:
  /// **'High contrast'**
  String get highContrast;

  /// No description provided for @highContrastExplanation.
  ///
  /// In en, this message translates to:
  /// **'Brighter text and more visible borders, handy outdoors or in a shop.'**
  String get highContrastExplanation;

  /// No description provided for @recentSearches.
  ///
  /// In en, this message translates to:
  /// **'Recent searches'**
  String get recentSearches;

  /// No description provided for @forgetSearch.
  ///
  /// In en, this message translates to:
  /// **'Remove this search'**
  String get forgetSearch;

  /// No description provided for @searchOnlineAction.
  ///
  /// In en, this message translates to:
  /// **'Search online'**
  String get searchOnlineAction;

  /// No description provided for @sortByPricePaid.
  ///
  /// In en, this message translates to:
  /// **'Price paid'**
  String get sortByPricePaid;

  /// No description provided for @sortByLocation.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get sortByLocation;

  /// No description provided for @filterLent.
  ///
  /// In en, this message translates to:
  /// **'Lent'**
  String get filterLent;

  /// No description provided for @filtersTitle.
  ///
  /// In en, this message translates to:
  /// **'Filters'**
  String get filtersTitle;

  /// No description provided for @clearArrangement.
  ///
  /// In en, this message translates to:
  /// **'Clear sort and filters'**
  String get clearArrangement;

  /// No description provided for @valueOverTime.
  ///
  /// In en, this message translates to:
  /// **'Value over time'**
  String get valueOverTime;

  /// No description provided for @lastSixMonths.
  ///
  /// In en, this message translates to:
  /// **'6 months'**
  String get lastSixMonths;

  /// No description provided for @lastYear.
  ///
  /// In en, this message translates to:
  /// **'1 year'**
  String get lastYear;

  /// No description provided for @wholeHistory.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get wholeHistory;

  /// No description provided for @valueHistoryFilling.
  ///
  /// In en, this message translates to:
  /// **'The curve fills in month after month: the collection value is recorded at the start of each month.'**
  String get valueHistoryFilling;

  /// No description provided for @valueHistoryNote.
  ///
  /// In en, this message translates to:
  /// **'Cardmarket, Steam and card prices, recorded at the start of each month.'**
  String get valueHistoryNote;

  /// No description provided for @biggestRises.
  ///
  /// In en, this message translates to:
  /// **'Biggest rises'**
  String get biggestRises;

  /// No description provided for @biggestFalls.
  ///
  /// In en, this message translates to:
  /// **'Biggest falls'**
  String get biggestFalls;

  /// No description provided for @missingVolumesTitle.
  ///
  /// In en, this message translates to:
  /// **'Missing volumes'**
  String get missingVolumesTitle;

  /// No description provided for @noMissingVolumes.
  ///
  /// In en, this message translates to:
  /// **'All your series are complete up to the latest volume out.'**
  String get noMissingVolumes;

  /// No description provided for @youAreMissing.
  ///
  /// In en, this message translates to:
  /// **'You are missing'**
  String get youAreMissing;

  /// No description provided for @volumesInSeries.
  ///
  /// In en, this message translates to:
  /// **'{volumes, plural, =1{volume} other{volumes}} in {series, plural, =1{1 series} other{{series} series}}'**
  String volumesInSeries(int volumes, int series);

  /// No description provided for @wishAllMissing.
  ///
  /// In en, this message translates to:
  /// **'Add all to my wishes ({count})'**
  String wishAllMissing(int count);

  /// No description provided for @missingVolumesWished.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{Nothing new in your wishes} =1{1 volume added to your wishes} other{{count} volumes added to your wishes}}'**
  String missingVolumesWished(int count);

  /// No description provided for @ownedVolumesRun.
  ///
  /// In en, this message translates to:
  /// **'Volumes {from} to {to}: owned'**
  String ownedVolumesRun(int from, int to);

  /// No description provided for @wishedVolumesRun.
  ///
  /// In en, this message translates to:
  /// **'Volumes {from} to {to}: in your wishes'**
  String wishedVolumesRun(int from, int to);

  /// No description provided for @missingVolumesRun.
  ///
  /// In en, this message translates to:
  /// **'Volumes {from} to {to}: missing, tap to wish them'**
  String missingVolumesRun(int from, int to);

  /// No description provided for @ownedVolume.
  ///
  /// In en, this message translates to:
  /// **'Volume {number}: owned'**
  String ownedVolume(int number);

  /// No description provided for @wishedVolume.
  ///
  /// In en, this message translates to:
  /// **'Volume {number}: in your wishes'**
  String wishedVolume(int number);

  /// No description provided for @missingVolume.
  ///
  /// In en, this message translates to:
  /// **'Volume {number}: missing, tap to wish it'**
  String missingVolume(int number);

  /// No description provided for @shelfRead.
  ///
  /// In en, this message translates to:
  /// **'Shelf read'**
  String get shelfRead;

  /// No description provided for @shelfPhotoGone.
  ///
  /// In en, this message translates to:
  /// **'This shelf photo is no longer available.'**
  String get shelfPhotoGone;

  /// No description provided for @tapFrameToFindLine.
  ///
  /// In en, this message translates to:
  /// **'Tap a frame to find its line.'**
  String get tapFrameToFindLine;

  /// No description provided for @seeShelf.
  ///
  /// In en, this message translates to:
  /// **'See the shelf'**
  String get seeShelf;

  /// No description provided for @scanHistory.
  ///
  /// In en, this message translates to:
  /// **'Scan history'**
  String get scanHistory;

  /// No description provided for @noScanSessions.
  ///
  /// In en, this message translates to:
  /// **'Your scan sessions will show up here.'**
  String get noScanSessions;

  /// No description provided for @scanAddedCount.
  ///
  /// In en, this message translates to:
  /// **'{count} added'**
  String scanAddedCount(int count);

  /// No description provided for @scanGroupAdded.
  ///
  /// In en, this message translates to:
  /// **'Added'**
  String get scanGroupAdded;

  /// No description provided for @scanGroupOwned.
  ///
  /// In en, this message translates to:
  /// **'Already yours'**
  String get scanGroupOwned;

  /// No description provided for @scanGroupMissed.
  ///
  /// In en, this message translates to:
  /// **'Not found'**
  String get scanGroupMissed;

  /// No description provided for @saveFailedRetry.
  ///
  /// In en, this message translates to:
  /// **'Saving failed. Try again.'**
  String get saveFailedRetry;

  /// No description provided for @selectItem.
  ///
  /// In en, this message translates to:
  /// **'Select'**
  String get selectItem;

  /// No description provided for @unselectItem.
  ///
  /// In en, this message translates to:
  /// **'Unselect'**
  String get unselectItem;

  /// No description provided for @scanResultAnnouncement.
  ///
  /// In en, this message translates to:
  /// **'{title}: {status}'**
  String scanResultAnnouncement(String title, String status);

  /// No description provided for @webImageNumber.
  ///
  /// In en, this message translates to:
  /// **'Web image {number}'**
  String webImageNumber(int number);

  /// No description provided for @valueChartSummary.
  ///
  /// In en, this message translates to:
  /// **'Value curve: from {first} to {last}, lowest {lowest}, highest {highest}. Swipe up or down to change month.'**
  String valueChartSummary(
    String first,
    String last,
    String lowest,
    String highest,
  );

  /// No description provided for @loadingInProgress.
  ///
  /// In en, this message translates to:
  /// **'Loading'**
  String get loadingInProgress;

  /// No description provided for @goalAllCategories.
  ///
  /// In en, this message translates to:
  /// **'the whole collection'**
  String get goalAllCategories;

  /// No description provided for @goalFinishLabel.
  ///
  /// In en, this message translates to:
  /// **'Finish {target} · {scope}'**
  String goalFinishLabel(int target, String scope);

  /// No description provided for @goalAddLabel.
  ///
  /// In en, this message translates to:
  /// **'Add {target} · {scope}'**
  String goalAddLabel(int target, String scope);

  /// No description provided for @goalReached.
  ///
  /// In en, this message translates to:
  /// **'Goal reached'**
  String get goalReached;

  /// No description provided for @goalAhead.
  ///
  /// In en, this message translates to:
  /// **'{count} ahead'**
  String goalAhead(int count);

  /// No description provided for @goalBehind.
  ///
  /// In en, this message translates to:
  /// **'{count} behind'**
  String goalBehind(int count);

  /// No description provided for @goalOnPace.
  ///
  /// In en, this message translates to:
  /// **'Right on pace'**
  String get goalOnPace;

  /// No description provided for @goalsOfYear.
  ///
  /// In en, this message translates to:
  /// **'{year} goals'**
  String goalsOfYear(int year);

  /// No description provided for @noGoalsYet.
  ///
  /// In en, this message translates to:
  /// **'Set yourself a goal for the year: finish books, games, fill your shelves.'**
  String get noGoalsYet;

  /// No description provided for @newGoal.
  ///
  /// In en, this message translates to:
  /// **'New goal'**
  String get newGoal;

  /// No description provided for @deleteGoal.
  ///
  /// In en, this message translates to:
  /// **'Delete the goal'**
  String get deleteGoal;

  /// No description provided for @goalBarLabel.
  ///
  /// In en, this message translates to:
  /// **'{done} of {target}, {expected} expected today'**
  String goalBarLabel(int done, int target, int expected);

  /// No description provided for @goalProjection.
  ///
  /// In en, this message translates to:
  /// **'At this pace: {count} by the end of December'**
  String goalProjection(int count);

  /// No description provided for @goalMeasureFinished.
  ///
  /// In en, this message translates to:
  /// **'Finish'**
  String get goalMeasureFinished;

  /// No description provided for @goalMeasureAdded.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get goalMeasureAdded;

  /// No description provided for @goalCategory.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get goalCategory;

  /// No description provided for @goalTarget.
  ///
  /// In en, this message translates to:
  /// **'How many this year'**
  String get goalTarget;

  /// No description provided for @decrease.
  ///
  /// In en, this message translates to:
  /// **'Less'**
  String get decrease;

  /// No description provided for @increase.
  ///
  /// In en, this message translates to:
  /// **'More'**
  String get increase;

  /// No description provided for @createGoal.
  ///
  /// In en, this message translates to:
  /// **'Create the goal'**
  String get createGoal;

  /// No description provided for @tonightTitle.
  ///
  /// In en, this message translates to:
  /// **'Tonight, I…'**
  String get tonightTitle;

  /// No description provided for @tonightAny.
  ///
  /// In en, this message translates to:
  /// **'Anything'**
  String get tonightAny;

  /// No description provided for @tonightRead.
  ///
  /// In en, this message translates to:
  /// **'Read'**
  String get tonightRead;

  /// No description provided for @tonightPlay.
  ///
  /// In en, this message translates to:
  /// **'Play'**
  String get tonightPlay;

  /// No description provided for @tonightWatch.
  ///
  /// In en, this message translates to:
  /// **'Watch'**
  String get tonightWatch;

  /// No description provided for @tonightListen.
  ///
  /// In en, this message translates to:
  /// **'Listen'**
  String get tonightListen;

  /// No description provided for @tonightAnyLength.
  ///
  /// In en, this message translates to:
  /// **'Any length'**
  String get tonightAnyLength;

  /// No description provided for @tonightShort.
  ///
  /// In en, this message translates to:
  /// **'Short'**
  String get tonightShort;

  /// No description provided for @tonightMedium.
  ///
  /// In en, this message translates to:
  /// **'Medium'**
  String get tonightMedium;

  /// No description provided for @tonightLong.
  ///
  /// In en, this message translates to:
  /// **'Long'**
  String get tonightLong;

  /// No description provided for @tonightAnother.
  ///
  /// In en, this message translates to:
  /// **'Another'**
  String get tonightAnother;

  /// No description provided for @tonightStart.
  ///
  /// In en, this message translates to:
  /// **'Start it'**
  String get tonightStart;

  /// No description provided for @tonightStarted.
  ///
  /// In en, this message translates to:
  /// **'“{title}” is in progress.'**
  String tonightStarted(String title);

  /// No description provided for @tonightNothingWaiting.
  ///
  /// In en, this message translates to:
  /// **'Nothing waiting: everything is started or finished.'**
  String get tonightNothingWaiting;

  /// No description provided for @tonightNothingMatches.
  ///
  /// In en, this message translates to:
  /// **'Nothing matches these filters. Widen the length or activity.'**
  String get tonightNothingMatches;

  /// No description provided for @tonightWaitingSince.
  ///
  /// In en, this message translates to:
  /// **'{months, plural, =1{waiting for 1 month} other{waiting for {months} months}}'**
  String tonightWaitingSince(int months);

  /// No description provided for @monthlyRecap.
  ///
  /// In en, this message translates to:
  /// **'Monthly recap'**
  String get monthlyRecap;

  /// No description provided for @previousMonth.
  ///
  /// In en, this message translates to:
  /// **'Previous month'**
  String get previousMonth;

  /// No description provided for @nextMonth.
  ///
  /// In en, this message translates to:
  /// **'Next month'**
  String get nextMonth;

  /// No description provided for @recapEmptyMonth.
  ///
  /// In en, this message translates to:
  /// **'Nothing added or finished that month.'**
  String get recapEmptyMonth;

  /// No description provided for @yearRecapOf.
  ///
  /// In en, this message translates to:
  /// **'{year} in review'**
  String yearRecapOf(int year);

  /// No description provided for @recapAdded.
  ///
  /// In en, this message translates to:
  /// **'Added'**
  String get recapAdded;

  /// No description provided for @recapSpent.
  ///
  /// In en, this message translates to:
  /// **'Spent'**
  String get recapSpent;

  /// No description provided for @recapFinished.
  ///
  /// In en, this message translates to:
  /// **'Finished'**
  String get recapFinished;

  /// No description provided for @recapSeriesCompleted.
  ///
  /// In en, this message translates to:
  /// **'Series completed'**
  String get recapSeriesCompleted;

  /// No description provided for @recapMostValued.
  ///
  /// In en, this message translates to:
  /// **'Most valued'**
  String get recapMostValued;

  /// No description provided for @recapValueChange.
  ///
  /// In en, this message translates to:
  /// **'Value'**
  String get recapValueChange;

  /// No description provided for @recapBusiestMonth.
  ///
  /// In en, this message translates to:
  /// **'Busiest month'**
  String get recapBusiestMonth;

  /// No description provided for @recapTopValued.
  ///
  /// In en, this message translates to:
  /// **'Most valued of the year'**
  String get recapTopValued;

  /// No description provided for @shareImage.
  ///
  /// In en, this message translates to:
  /// **'Share the image'**
  String get shareImage;

  /// No description provided for @tonightMenu.
  ///
  /// In en, this message translates to:
  /// **'Tonight, I…'**
  String get tonightMenu;

  /// No description provided for @goalsMenu.
  ///
  /// In en, this message translates to:
  /// **'Goals'**
  String get goalsMenu;

  /// No description provided for @tagsTitle.
  ///
  /// In en, this message translates to:
  /// **'Tags'**
  String get tagsTitle;

  /// No description provided for @saveFilterAsShelf.
  ///
  /// In en, this message translates to:
  /// **'Save this filter as a shelf'**
  String get saveFilterAsShelf;

  /// No description provided for @saveFilterAsShelfHint.
  ///
  /// In en, this message translates to:
  /// **'It will show at the top of home and fill itself.'**
  String get saveFilterAsShelfHint;

  /// No description provided for @smartShelfName.
  ///
  /// In en, this message translates to:
  /// **'Shelf name'**
  String get smartShelfName;

  /// No description provided for @smartShelfSaved.
  ///
  /// In en, this message translates to:
  /// **'Shelf “{name}” added to home.'**
  String smartShelfSaved(String name);

  /// No description provided for @smartShelfLabel.
  ///
  /// In en, this message translates to:
  /// **'Smart shelf {name}, {count} items'**
  String smartShelfLabel(String name, int count);

  /// No description provided for @smartShelfEmpty.
  ///
  /// In en, this message translates to:
  /// **'Nothing matches this filter yet.'**
  String get smartShelfEmpty;

  /// No description provided for @deleteSmartShelf.
  ///
  /// In en, this message translates to:
  /// **'Delete the shelf'**
  String get deleteSmartShelf;

  /// No description provided for @tagSigned.
  ///
  /// In en, this message translates to:
  /// **'signed'**
  String get tagSigned;

  /// No description provided for @tagToSell.
  ///
  /// In en, this message translates to:
  /// **'to sell'**
  String get tagToSell;

  /// No description provided for @tagGift.
  ///
  /// In en, this message translates to:
  /// **'gift'**
  String get tagGift;

  /// No description provided for @tagToReread.
  ///
  /// In en, this message translates to:
  /// **'to reread'**
  String get tagToReread;

  /// No description provided for @tagLimitedEdition.
  ///
  /// In en, this message translates to:
  /// **'limited edition'**
  String get tagLimitedEdition;

  /// No description provided for @newTag.
  ///
  /// In en, this message translates to:
  /// **'New tag'**
  String get newTag;

  /// No description provided for @tagName.
  ///
  /// In en, this message translates to:
  /// **'Tag name'**
  String get tagName;

  /// No description provided for @removeTag.
  ///
  /// In en, this message translates to:
  /// **'Remove the tag {tag}'**
  String removeTag(String tag);

  /// No description provided for @addTag.
  ///
  /// In en, this message translates to:
  /// **'Add the tag {tag}'**
  String addTag(String tag);

  /// No description provided for @storagePlan.
  ///
  /// In en, this message translates to:
  /// **'Storage plan'**
  String get storagePlan;

  /// No description provided for @storagePlanHint.
  ///
  /// In en, this message translates to:
  /// **'Rooms, furniture and shelves: then pick where an item lives in two taps.'**
  String get storagePlanHint;

  /// No description provided for @storagePlanEmpty.
  ///
  /// In en, this message translates to:
  /// **'Start with a room, for example “Living room”.'**
  String get storagePlanEmpty;

  /// No description provided for @newRoom.
  ///
  /// In en, this message translates to:
  /// **'New room'**
  String get newRoom;

  /// No description provided for @newFurniture.
  ///
  /// In en, this message translates to:
  /// **'New furniture'**
  String get newFurniture;

  /// No description provided for @newShelf.
  ///
  /// In en, this message translates to:
  /// **'New shelf'**
  String get newShelf;

  /// No description provided for @renamePlace.
  ///
  /// In en, this message translates to:
  /// **'Rename'**
  String get renamePlace;

  /// No description provided for @deletePlace.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get deletePlace;

  /// No description provided for @placeName.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get placeName;

  /// No description provided for @placeNameHint.
  ///
  /// In en, this message translates to:
  /// **'Living room, Bookcase, Shelf 3…'**
  String get placeNameHint;

  /// No description provided for @placeItemCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{Empty} =1{1 item} other{{count} items}}'**
  String placeItemCount(int count);

  /// No description provided for @placeActions.
  ///
  /// In en, this message translates to:
  /// **'Actions for {name}'**
  String placeActions(String name);

  /// No description provided for @placeChildren.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 place} other{{count} places}}'**
  String placeChildren(int count);

  /// No description provided for @chooseStoragePlace.
  ///
  /// In en, this message translates to:
  /// **'Pick from the plan'**
  String get chooseStoragePlace;

  /// No description provided for @goUp.
  ///
  /// In en, this message translates to:
  /// **'Go up'**
  String get goUp;

  /// No description provided for @storeHere.
  ///
  /// In en, this message translates to:
  /// **'Store here'**
  String get storeHere;

  /// No description provided for @whereIs.
  ///
  /// In en, this message translates to:
  /// **'Where is…?'**
  String get whereIs;

  /// No description provided for @whereIsHint.
  ///
  /// In en, this message translates to:
  /// **'Title or author'**
  String get whereIsHint;

  /// No description provided for @whereIsNothing.
  ///
  /// In en, this message translates to:
  /// **'Nothing in your collection has that name.'**
  String get whereIsNothing;

  /// No description provided for @lentToBorrower.
  ///
  /// In en, this message translates to:
  /// **'At {name}\'s'**
  String lentToBorrower(String name);

  /// No description provided for @notStoredYet.
  ///
  /// In en, this message translates to:
  /// **'Not stored yet: open the item to pick a place'**
  String get notStoredYet;

  /// No description provided for @journal.
  ///
  /// In en, this message translates to:
  /// **'Journal'**
  String get journal;

  /// No description provided for @journalAdded.
  ///
  /// In en, this message translates to:
  /// **'Added'**
  String get journalAdded;

  /// No description provided for @journalSales.
  ///
  /// In en, this message translates to:
  /// **'Sales'**
  String get journalSales;

  /// No description provided for @journalLoans.
  ///
  /// In en, this message translates to:
  /// **'Loans'**
  String get journalLoans;

  /// No description provided for @journalValues.
  ///
  /// In en, this message translates to:
  /// **'Values'**
  String get journalValues;

  /// No description provided for @journalFinished.
  ///
  /// In en, this message translates to:
  /// **'Finished'**
  String get journalFinished;

  /// No description provided for @journalEmpty.
  ///
  /// In en, this message translates to:
  /// **'Nothing to tell yet.'**
  String get journalEmpty;

  /// No description provided for @today.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get today;

  /// No description provided for @yesterday.
  ///
  /// In en, this message translates to:
  /// **'Yesterday'**
  String get yesterday;

  /// No description provided for @journalEntryAdded.
  ///
  /// In en, this message translates to:
  /// **'Added to the collection'**
  String get journalEntryAdded;

  /// No description provided for @journalEntryReceived.
  ///
  /// In en, this message translates to:
  /// **'Preorder received'**
  String get journalEntryReceived;

  /// No description provided for @journalEntryStarted.
  ///
  /// In en, this message translates to:
  /// **'Started'**
  String get journalEntryStarted;

  /// No description provided for @journalEntryFinished.
  ///
  /// In en, this message translates to:
  /// **'Finished'**
  String get journalEntryFinished;

  /// No description provided for @journalEntrySold.
  ///
  /// In en, this message translates to:
  /// **'Sold for {amount}'**
  String journalEntrySold(String amount);

  /// No description provided for @journalEntryLent.
  ///
  /// In en, this message translates to:
  /// **'Lent to {name}'**
  String journalEntryLent(String name);

  /// No description provided for @journalEntryReturned.
  ///
  /// In en, this message translates to:
  /// **'Returned by {name}'**
  String journalEntryReturned(String name);

  /// No description provided for @journalEntryValueRose.
  ///
  /// In en, this message translates to:
  /// **'Value up {amount}'**
  String journalEntryValueRose(String amount);

  /// No description provided for @journalEntryValueFell.
  ///
  /// In en, this message translates to:
  /// **'Value down {amount}'**
  String journalEntryValueFell(String amount);

  /// No description provided for @journalEntryMerged.
  ///
  /// In en, this message translates to:
  /// **'Duplicates merged'**
  String get journalEntryMerged;

  /// No description provided for @wishUnderMaximumTitle.
  ///
  /// In en, this message translates to:
  /// **'{title} is under your maximum'**
  String wishUnderMaximumTitle(String title);

  /// No description provided for @wishUnderMaximumBody.
  ///
  /// In en, this message translates to:
  /// **'{price} today, your maximum was {maximum}.'**
  String wishUnderMaximumBody(String price, String maximum);

  /// No description provided for @wishPriorityMustHave.
  ///
  /// In en, this message translates to:
  /// **'Must have'**
  String get wishPriorityMustHave;

  /// No description provided for @wishPriorityWant.
  ///
  /// In en, this message translates to:
  /// **'Want'**
  String get wishPriorityWant;

  /// No description provided for @wishPrioritySomeday.
  ///
  /// In en, this message translates to:
  /// **'Someday'**
  String get wishPrioritySomeday;

  /// No description provided for @wishPriority.
  ///
  /// In en, this message translates to:
  /// **'Priority'**
  String get wishPriority;

  /// No description provided for @wishMaximumLabel.
  ///
  /// In en, this message translates to:
  /// **'Maximum price'**
  String get wishMaximumLabel;

  /// No description provided for @wishMaximumHelp.
  ///
  /// In en, this message translates to:
  /// **'An alert when the value or a Steam sale goes below it.'**
  String get wishMaximumHelp;

  /// No description provided for @wishMaximumPrice.
  ///
  /// In en, this message translates to:
  /// **'Max {price}'**
  String wishMaximumPrice(String price);

  /// No description provided for @wishUnderYourMaximum.
  ///
  /// In en, this message translates to:
  /// **'Under your max of {price}'**
  String wishUnderYourMaximum(String price);

  /// No description provided for @shareAsImage.
  ///
  /// In en, this message translates to:
  /// **'Image'**
  String get shareAsImage;

  /// No description provided for @shareAsPdf.
  ///
  /// In en, this message translates to:
  /// **'PDF'**
  String get shareAsPdf;

  /// No description provided for @shareAsText.
  ///
  /// In en, this message translates to:
  /// **'Share as text'**
  String get shareAsText;

  /// No description provided for @wishlistColumnWish.
  ///
  /// In en, this message translates to:
  /// **'Wish'**
  String get wishlistColumnWish;

  /// No description provided for @wishlistColumnType.
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get wishlistColumnType;

  /// No description provided for @budget.
  ///
  /// In en, this message translates to:
  /// **'Budget'**
  String get budget;

  /// No description provided for @budgetAlertTitle.
  ///
  /// In en, this message translates to:
  /// **'Monthly budget almost reached'**
  String get budgetAlertTitle;

  /// No description provided for @budgetAlertBody.
  ///
  /// In en, this message translates to:
  /// **'Only {remaining} left of {ceiling} this month.'**
  String budgetAlertBody(String remaining, String ceiling);

  /// No description provided for @budgetOverBody.
  ///
  /// In en, this message translates to:
  /// **'The {ceiling} ceiling is exceeded this month.'**
  String budgetOverBody(String ceiling);

  /// No description provided for @budgetChannelName.
  ///
  /// In en, this message translates to:
  /// **'Budget'**
  String get budgetChannelName;

  /// No description provided for @budgetChannelDescription.
  ///
  /// In en, this message translates to:
  /// **'Warns when monthly spending nears the ceiling.'**
  String get budgetChannelDescription;

  /// No description provided for @budgetLeft.
  ///
  /// In en, this message translates to:
  /// **'{amount} left'**
  String budgetLeft(String amount);

  /// No description provided for @budgetOverBy.
  ///
  /// In en, this message translates to:
  /// **'Over by {amount}'**
  String budgetOverBy(String amount);

  /// No description provided for @budgetOnlyLeft.
  ///
  /// In en, this message translates to:
  /// **'Only {amount} left for the remaining {days} days'**
  String budgetOnlyLeft(String amount, int days);

  /// No description provided for @budgetDaysLeft.
  ///
  /// In en, this message translates to:
  /// **'{days, plural, =0{last day} =1{1 day left} other{{days} days left}}'**
  String budgetDaysLeft(int days);

  /// No description provided for @budgetOutOf.
  ///
  /// In en, this message translates to:
  /// **'of {ceiling}'**
  String budgetOutOf(String ceiling);

  /// No description provided for @budgetGaugeLabel.
  ///
  /// In en, this message translates to:
  /// **'{percent}% of the ceiling spent, alert at {alert}%'**
  String budgetGaugeLabel(int percent, int alert);

  /// No description provided for @budgetNoCeiling.
  ///
  /// In en, this message translates to:
  /// **'Set a ceiling to follow the month and be warned as you near it.'**
  String get budgetNoCeiling;

  /// No description provided for @budgetSpendingOfMonth.
  ///
  /// In en, this message translates to:
  /// **'This month\'s spending'**
  String get budgetSpendingOfMonth;

  /// No description provided for @budgetNothingSpent.
  ///
  /// In en, this message translates to:
  /// **'No priced purchase this month.'**
  String get budgetNothingSpent;

  /// No description provided for @budgetCeiling.
  ///
  /// In en, this message translates to:
  /// **'Monthly ceiling'**
  String get budgetCeiling;

  /// No description provided for @budgetCeilingHelp.
  ///
  /// In en, this message translates to:
  /// **'Reset on the 1st of each month'**
  String get budgetCeilingHelp;

  /// No description provided for @budgetNone.
  ///
  /// In en, this message translates to:
  /// **'None'**
  String get budgetNone;

  /// No description provided for @budgetAlertAt.
  ///
  /// In en, this message translates to:
  /// **'Warn me at'**
  String get budgetAlertAt;

  /// No description provided for @budgetAlertAtHelp.
  ///
  /// In en, this message translates to:
  /// **'One notification, once a month'**
  String get budgetAlertAtHelp;

  /// No description provided for @budgetCountSteam.
  ///
  /// In en, this message translates to:
  /// **'Count Steam games'**
  String get budgetCountSteam;

  /// No description provided for @budgetCountSteamHelp.
  ///
  /// In en, this message translates to:
  /// **'Purchase prices imported with the library'**
  String get budgetCountSteamHelp;

  /// No description provided for @insuranceInventory.
  ///
  /// In en, this message translates to:
  /// **'Insurance inventory'**
  String get insuranceInventory;

  /// No description provided for @insuranceNothing.
  ///
  /// In en, this message translates to:
  /// **'Add items to be able to list them.'**
  String get insuranceNothing;

  /// No description provided for @insuranceIntro.
  ///
  /// In en, this message translates to:
  /// **'A PDF to keep or send to your insurer: each item with its photo, purchase, estimated value and place.'**
  String get insuranceIntro;

  /// No description provided for @insuranceCategories.
  ///
  /// In en, this message translates to:
  /// **'Categories to include'**
  String get insuranceCategories;

  /// No description provided for @insuranceCategoryLine.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 item} other{{count} items}} · {value}'**
  String insuranceCategoryLine(int count, String value);

  /// No description provided for @insuranceWithPhotos.
  ///
  /// In en, this message translates to:
  /// **'With photos'**
  String get insuranceWithPhotos;

  /// No description provided for @insuranceWithPhotosHelp.
  ///
  /// In en, this message translates to:
  /// **'A thumbnail per item, the file is heavier'**
  String get insuranceWithPhotosHelp;

  /// No description provided for @insurancePreview.
  ///
  /// In en, this message translates to:
  /// **'Preview'**
  String get insurancePreview;

  /// No description provided for @insurancePages.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{about 1 page} other{about {count} pages}}'**
  String insurancePages(int count);

  /// No description provided for @insuranceMoreLines.
  ///
  /// In en, this message translates to:
  /// **'and {count} more…'**
  String insuranceMoreLines(int count);

  /// No description provided for @insuranceItemCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 item} other{{count} items}}'**
  String insuranceItemCount(int count);

  /// No description provided for @insuranceEstimatedTotal.
  ///
  /// In en, this message translates to:
  /// **'{amount} estimated'**
  String insuranceEstimatedTotal(String amount);

  /// No description provided for @insuranceGenerate.
  ///
  /// In en, this message translates to:
  /// **'Generate the PDF'**
  String get insuranceGenerate;

  /// No description provided for @insuranceGenerating.
  ///
  /// In en, this message translates to:
  /// **'Generating…'**
  String get insuranceGenerating;

  /// No description provided for @insuranceDocumentTitle.
  ///
  /// In en, this message translates to:
  /// **'Collection inventory'**
  String get insuranceDocumentTitle;

  /// No description provided for @insuranceDocumentSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Made on {date} · {count} items · estimated value: market value, else purchase price'**
  String insuranceDocumentSubtitle(String date, int count);

  /// No description provided for @insuranceColumnItem.
  ///
  /// In en, this message translates to:
  /// **'Item'**
  String get insuranceColumnItem;

  /// No description provided for @insuranceColumnBought.
  ///
  /// In en, this message translates to:
  /// **'Bought'**
  String get insuranceColumnBought;

  /// No description provided for @insuranceColumnPaid.
  ///
  /// In en, this message translates to:
  /// **'Paid'**
  String get insuranceColumnPaid;

  /// No description provided for @insuranceColumnEstimated.
  ///
  /// In en, this message translates to:
  /// **'Estimated'**
  String get insuranceColumnEstimated;

  /// No description provided for @insuranceItems.
  ///
  /// In en, this message translates to:
  /// **'Items'**
  String get insuranceItems;

  /// No description provided for @insuranceSubtotal.
  ///
  /// In en, this message translates to:
  /// **'Subtotal ({count})'**
  String insuranceSubtotal(int count);

  /// No description provided for @insuranceFooter.
  ///
  /// In en, this message translates to:
  /// **'Values in euros, market values on export day. Made with Akashic.'**
  String get insuranceFooter;

  /// No description provided for @notStoredYetShort.
  ///
  /// In en, this message translates to:
  /// **'No place'**
  String get notStoredYetShort;

  /// No description provided for @loanInOneWeek.
  ///
  /// In en, this message translates to:
  /// **'1 week'**
  String get loanInOneWeek;

  /// No description provided for @loanInTwoWeeks.
  ///
  /// In en, this message translates to:
  /// **'2 weeks'**
  String get loanInTwoWeeks;

  /// No description provided for @loanInOneMonth.
  ///
  /// In en, this message translates to:
  /// **'1 month'**
  String get loanInOneMonth;

  /// No description provided for @loanNoDate.
  ///
  /// In en, this message translates to:
  /// **'No date'**
  String get loanNoDate;

  /// No description provided for @loanPickDate.
  ///
  /// In en, this message translates to:
  /// **'Other date'**
  String get loanPickDate;

  /// No description provided for @loanReturnBy.
  ///
  /// In en, this message translates to:
  /// **'Return by'**
  String get loanReturnBy;

  /// No description provided for @loanDueOn.
  ///
  /// In en, this message translates to:
  /// **'Due back on {date}'**
  String loanDueOn(String date);

  /// No description provided for @loanRemindAtDue.
  ///
  /// In en, this message translates to:
  /// **'Remind me when due'**
  String get loanRemindAtDue;

  /// No description provided for @loanFollowUp.
  ///
  /// In en, this message translates to:
  /// **'Then follow up'**
  String get loanFollowUp;

  /// No description provided for @loanFollowUpHelp.
  ///
  /// In en, this message translates to:
  /// **'A week later, if it still hasn\'t come back'**
  String get loanFollowUpHelp;

  /// No description provided for @loansLate.
  ///
  /// In en, this message translates to:
  /// **'Late'**
  String get loansLate;

  /// No description provided for @loansOngoing.
  ///
  /// In en, this message translates to:
  /// **'Ongoing'**
  String get loansOngoing;

  /// No description provided for @loanLateBy.
  ///
  /// In en, this message translates to:
  /// **'At {name}\'s · {days, plural, =1{1 day late} other{{days} days late}}'**
  String loanLateBy(String name, int days);

  /// No description provided for @loanDueBy.
  ///
  /// In en, this message translates to:
  /// **'At {name}\'s · due {date}'**
  String loanDueBy(String name, String date);

  /// No description provided for @calendarSync.
  ///
  /// In en, this message translates to:
  /// **'Releases in the calendar'**
  String get calendarSync;

  /// No description provided for @calendarSyncSwitch.
  ///
  /// In en, this message translates to:
  /// **'Send releases to the calendar'**
  String get calendarSyncSwitch;

  /// No description provided for @calendarSyncSwitchHelp.
  ///
  /// In en, this message translates to:
  /// **'An all-day event, editable from the calendar'**
  String get calendarSyncSwitchHelp;

  /// No description provided for @calendarTarget.
  ///
  /// In en, this message translates to:
  /// **'Calendar'**
  String get calendarTarget;

  /// No description provided for @calendarDefaultName.
  ///
  /// In en, this message translates to:
  /// **'Collection'**
  String get calendarDefaultName;

  /// No description provided for @calendarKinds.
  ///
  /// In en, this message translates to:
  /// **'Release types'**
  String get calendarKinds;

  /// No description provided for @calendarKindVolumes.
  ///
  /// In en, this message translates to:
  /// **'Volumes'**
  String get calendarKindVolumes;

  /// No description provided for @calendarKindAlbums.
  ///
  /// In en, this message translates to:
  /// **'Albums'**
  String get calendarKindAlbums;

  /// No description provided for @calendarKindCardSets.
  ///
  /// In en, this message translates to:
  /// **'Card sets'**
  String get calendarKindCardSets;

  /// No description provided for @calendarSubjects.
  ///
  /// In en, this message translates to:
  /// **'By series or artist'**
  String get calendarSubjects;

  /// No description provided for @calendarEventSettings.
  ///
  /// In en, this message translates to:
  /// **'Event settings'**
  String get calendarEventSettings;

  /// No description provided for @calendarReminder.
  ///
  /// In en, this message translates to:
  /// **'Reminder the evening before at 6 pm'**
  String get calendarReminder;

  /// No description provided for @calendarRemovedWhenAdded.
  ///
  /// In en, this message translates to:
  /// **'The event is removed when the item joins your collection or the release goes away.'**
  String get calendarRemovedWhenAdded;

  /// No description provided for @calendarPreview.
  ///
  /// In en, this message translates to:
  /// **'Preview in the calendar'**
  String get calendarPreview;

  /// No description provided for @calendarNextSent.
  ///
  /// In en, this message translates to:
  /// **'Next releases sent'**
  String get calendarNextSent;

  /// No description provided for @calendarEventTitle.
  ///
  /// In en, this message translates to:
  /// **'Release · {title}'**
  String calendarEventTitle(String title);

  /// No description provided for @calendarEventEstimated.
  ///
  /// In en, this message translates to:
  /// **'Estimated date'**
  String get calendarEventEstimated;

  /// No description provided for @calendarEventFooter.
  ///
  /// In en, this message translates to:
  /// **'Added by Akashic'**
  String get calendarEventFooter;

  /// No description provided for @calendarAllDay.
  ///
  /// In en, this message translates to:
  /// **'{date} · all day'**
  String calendarAllDay(String date);

  /// No description provided for @calendarAccessDenied.
  ///
  /// In en, this message translates to:
  /// **'Without calendar access, releases cannot be added.'**
  String get calendarAccessDenied;

  /// No description provided for @calendarSyncFailed.
  ///
  /// In en, this message translates to:
  /// **'The calendar could not be updated.'**
  String get calendarSyncFailed;

  /// No description provided for @tabletPickAnItem.
  ///
  /// In en, this message translates to:
  /// **'Pick an item on the left to see it here.'**
  String get tabletPickAnItem;

  /// No description provided for @voiceSearch.
  ///
  /// In en, this message translates to:
  /// **'Search by voice'**
  String get voiceSearch;

  /// No description provided for @voiceListening.
  ///
  /// In en, this message translates to:
  /// **'Listening…'**
  String get voiceListening;

  /// No description provided for @voiceUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Speech recognition isn\'t available on this phone.'**
  String get voiceUnavailable;

  /// No description provided for @voiceTapToRetry.
  ///
  /// In en, this message translates to:
  /// **'Tap the mic to speak'**
  String get voiceTapToRetry;

  /// No description provided for @voiceStop.
  ///
  /// In en, this message translates to:
  /// **'Stop listening'**
  String get voiceStop;

  /// No description provided for @voiceHint.
  ///
  /// In en, this message translates to:
  /// **'Say a title, an author, an artist…'**
  String get voiceHint;

  /// No description provided for @voiceUseWords.
  ///
  /// In en, this message translates to:
  /// **'Search this'**
  String get voiceUseWords;

  /// No description provided for @offline.
  ///
  /// In en, this message translates to:
  /// **'Offline'**
  String get offline;

  /// No description provided for @offlineExplained.
  ///
  /// In en, this message translates to:
  /// **'Offline: the collection stays available, prices shown are from the last check.'**
  String get offlineExplained;

  /// No description provided for @priceOn.
  ///
  /// In en, this message translates to:
  /// **'price on {date}'**
  String priceOn(String date);

  /// No description provided for @preorderArrivesTodayTitle.
  ///
  /// In en, this message translates to:
  /// **'Arriving today: {title}'**
  String preorderArrivesTodayTitle(String title);

  /// No description provided for @preordersArriveTodayTitle.
  ///
  /// In en, this message translates to:
  /// **'{count} preorders arrive today'**
  String preordersArriveTodayTitle(int count);

  /// No description provided for @preorderArrivesTodayBody.
  ///
  /// In en, this message translates to:
  /// **'Tap “Received” on the item once you have it.'**
  String get preorderArrivesTodayBody;

  /// No description provided for @preorderChannelName.
  ///
  /// In en, this message translates to:
  /// **'Preorders'**
  String get preorderChannelName;

  /// No description provided for @preorderChannelDescription.
  ///
  /// In en, this message translates to:
  /// **'Warns on the day a preorder is due.'**
  String get preorderChannelDescription;

  /// No description provided for @preorderToday.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get preorderToday;

  /// No description provided for @preorderInDays.
  ///
  /// In en, this message translates to:
  /// **'{days, plural, =1{in 1 day} other{in {days} days}}'**
  String preorderInDays(int days);

  /// No description provided for @preorderTitle.
  ///
  /// In en, this message translates to:
  /// **'Preorder'**
  String get preorderTitle;

  /// No description provided for @preorderPickDate.
  ///
  /// In en, this message translates to:
  /// **'Pick the delivery date'**
  String get preorderPickDate;

  /// No description provided for @preorderDeliveryOn.
  ///
  /// In en, this message translates to:
  /// **'Due on {date}'**
  String preorderDeliveryOn(String date);

  /// No description provided for @preorderDeposit.
  ///
  /// In en, this message translates to:
  /// **'Deposit paid (optional)'**
  String get preorderDeposit;

  /// No description provided for @preorderDepositPaid.
  ///
  /// In en, this message translates to:
  /// **'Deposit: {amount}'**
  String preorderDepositPaid(String amount);

  /// No description provided for @markPreordered.
  ///
  /// In en, this message translates to:
  /// **'Mark as preordered'**
  String get markPreordered;

  /// No description provided for @preordered.
  ///
  /// In en, this message translates to:
  /// **'Preordered'**
  String get preordered;

  /// No description provided for @preorderReceived.
  ///
  /// In en, this message translates to:
  /// **'Received'**
  String get preorderReceived;

  /// No description provided for @preorderChangeDate.
  ///
  /// In en, this message translates to:
  /// **'Change the date'**
  String get preorderChangeDate;

  /// No description provided for @preorderCancel.
  ///
  /// In en, this message translates to:
  /// **'No longer a preorder'**
  String get preorderCancel;

  /// No description provided for @toReceive.
  ///
  /// In en, this message translates to:
  /// **'To receive'**
  String get toReceive;

  /// No description provided for @preorderDepositsTotal.
  ///
  /// In en, this message translates to:
  /// **'{amount} in deposits paid'**
  String preorderDepositsTotal(String amount);

  /// No description provided for @mergeTitle.
  ///
  /// In en, this message translates to:
  /// **'Merge duplicates'**
  String get mergeTitle;

  /// No description provided for @mergeAction.
  ///
  /// In en, this message translates to:
  /// **'Merge'**
  String get mergeAction;

  /// No description provided for @mergeKeepWhat.
  ///
  /// In en, this message translates to:
  /// **'Pick what the merged item keeps, field by field.'**
  String get mergeKeepWhat;

  /// No description provided for @mergeFieldTitle.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get mergeFieldTitle;

  /// No description provided for @mergeFieldCover.
  ///
  /// In en, this message translates to:
  /// **'Cover'**
  String get mergeFieldCover;

  /// No description provided for @mergeFieldPurchase.
  ///
  /// In en, this message translates to:
  /// **'Purchase, condition and place'**
  String get mergeFieldPurchase;

  /// No description provided for @mergeFieldRating.
  ///
  /// In en, this message translates to:
  /// **'Rating'**
  String get mergeFieldRating;

  /// No description provided for @mergeFieldProgress.
  ///
  /// In en, this message translates to:
  /// **'Progress'**
  String get mergeFieldProgress;

  /// No description provided for @mergeHasCover.
  ///
  /// In en, this message translates to:
  /// **'Has a cover'**
  String get mergeHasCover;

  /// No description provided for @mergeHasProgress.
  ///
  /// In en, this message translates to:
  /// **'Progress tracked'**
  String get mergeHasProgress;

  /// No description provided for @mergeEmpty.
  ///
  /// In en, this message translates to:
  /// **'empty'**
  String get mergeEmpty;

  /// No description provided for @mergeJoinPhotos.
  ///
  /// In en, this message translates to:
  /// **'Keep the photos of both items'**
  String get mergeJoinPhotos;

  /// No description provided for @mergeResult.
  ///
  /// In en, this message translates to:
  /// **'Result: {title}'**
  String mergeResult(String title);

  /// No description provided for @mergeConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Merge these two items?'**
  String get mergeConfirmTitle;

  /// No description provided for @mergeConfirmBody.
  ///
  /// In en, this message translates to:
  /// **'Item B goes away: what you picked joins item A.'**
  String get mergeConfirmBody;

  /// No description provided for @mergeDone.
  ///
  /// In en, this message translates to:
  /// **'Duplicates merged.'**
  String get mergeDone;

  /// No description provided for @deckValue.
  ///
  /// In en, this message translates to:
  /// **'Deck value'**
  String get deckValue;

  /// No description provided for @deckPricedCards.
  ///
  /// In en, this message translates to:
  /// **'{priced} of {total} cards priced'**
  String deckPricedCards(int priced, int total);

  /// No description provided for @deckPricedOn.
  ///
  /// In en, this message translates to:
  /// **'prices from {date}'**
  String deckPricedOn(String date);

  /// No description provided for @deckPriciestCards.
  ///
  /// In en, this message translates to:
  /// **'The priciest cards'**
  String get deckPriciestCards;

  /// No description provided for @deckTopShare.
  ///
  /// In en, this message translates to:
  /// **'They make {percent}% of the deck\'s value.'**
  String deckTopShare(int percent);

  /// No description provided for @trackSide.
  ///
  /// In en, this message translates to:
  /// **'Side {side}'**
  String trackSide(String side);

  /// No description provided for @albumLength.
  ///
  /// In en, this message translates to:
  /// **'Total length: {length}'**
  String albumLength(String length);

  /// No description provided for @compareTitle.
  ///
  /// In en, this message translates to:
  /// **'Compare with a friend'**
  String get compareTitle;

  /// No description provided for @compareIntro.
  ///
  /// In en, this message translates to:
  /// **'Ask for their export (Settings › Export the collection) and open the file here.'**
  String get compareIntro;

  /// No description provided for @compareNothingSent.
  ///
  /// In en, this message translates to:
  /// **'Nothing is sent: the comparison happens on your phone.'**
  String get compareNothingSent;

  /// No description provided for @compareChooseFile.
  ///
  /// In en, this message translates to:
  /// **'Choose their file'**
  String get compareChooseFile;

  /// No description provided for @compareOtherFile.
  ///
  /// In en, this message translates to:
  /// **'Another file'**
  String get compareOtherFile;

  /// No description provided for @compareUnreadable.
  ///
  /// In en, this message translates to:
  /// **'This file couldn\'t be read. A CSV or XLSX export is needed.'**
  String get compareUnreadable;

  /// No description provided for @compareCounts.
  ///
  /// In en, this message translates to:
  /// **'You: {mine} · Your friend: {theirs}'**
  String compareCounts(int mine, int theirs);

  /// No description provided for @compareInCommon.
  ///
  /// In en, this message translates to:
  /// **'In common · {count}'**
  String compareInCommon(int count);

  /// No description provided for @compareOnlyFriend.
  ///
  /// In en, this message translates to:
  /// **'They have · {count}'**
  String compareOnlyFriend(int count);

  /// No description provided for @compareOnlyMine.
  ///
  /// In en, this message translates to:
  /// **'You have · {count}'**
  String compareOnlyMine(int count);

  /// No description provided for @compareExchangeIdeas.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 swap idea} other{{count} swap ideas}}'**
  String compareExchangeIdeas(int count);

  /// No description provided for @compareCopyList.
  ///
  /// In en, this message translates to:
  /// **'Copy'**
  String get compareCopyList;

  /// No description provided for @compareCopied.
  ///
  /// In en, this message translates to:
  /// **'List copied.'**
  String get compareCopied;

  /// No description provided for @compareNothingHere.
  ///
  /// In en, this message translates to:
  /// **'Nothing in this tab.'**
  String get compareNothingHere;

  /// No description provided for @compareFillsMissing.
  ///
  /// In en, this message translates to:
  /// **'you\'re missing it'**
  String get compareFillsMissing;

  /// No description provided for @compareInWishes.
  ///
  /// In en, this message translates to:
  /// **'in your wishes'**
  String get compareInWishes;

  /// No description provided for @missingCovers.
  ///
  /// In en, this message translates to:
  /// **'Missing covers'**
  String get missingCovers;

  /// No description provided for @coverProposals.
  ///
  /// In en, this message translates to:
  /// **'Proposals'**
  String get coverProposals;

  /// No description provided for @noMissingCovers.
  ///
  /// In en, this message translates to:
  /// **'All your items have a cover.'**
  String get noMissingCovers;

  /// No description provided for @itemsWithoutCover.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 item without a cover} other{{count} items without a cover}}'**
  String itemsWithoutCover(int count);

  /// No description provided for @searchCovers.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Find 1 cover} other{Find {count} covers}}'**
  String searchCovers(int count);

  /// No description provided for @acceptAllCovers.
  ///
  /// In en, this message translates to:
  /// **'Accept all · {count}'**
  String acceptAllCovers(int count);

  /// No description provided for @coverSearchProgress.
  ///
  /// In en, this message translates to:
  /// **'Searching: {done} / {total} · {accepted} accepted'**
  String coverSearchProgress(int done, int total, int accepted);

  /// No description provided for @coverSearching.
  ///
  /// In en, this message translates to:
  /// **'Searching…'**
  String get coverSearching;

  /// No description provided for @coverNothingFound.
  ///
  /// In en, this message translates to:
  /// **'Nothing found'**
  String get coverNothingFound;

  /// No description provided for @coverAccepted.
  ///
  /// In en, this message translates to:
  /// **'Cover added'**
  String get coverAccepted;

  /// No description provided for @coverRefused.
  ///
  /// In en, this message translates to:
  /// **'Skipped'**
  String get coverRefused;

  /// No description provided for @coverAccept.
  ///
  /// In en, this message translates to:
  /// **'Accept'**
  String get coverAccept;

  /// No description provided for @coverRefuse.
  ///
  /// In en, this message translates to:
  /// **'Refuse'**
  String get coverRefuse;

  /// No description provided for @coverAnother.
  ///
  /// In en, this message translates to:
  /// **'Another image'**
  String get coverAnother;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'fr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'fr':
      return AppLocalizationsFr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
