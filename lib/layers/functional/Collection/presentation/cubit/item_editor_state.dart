import 'package:akashic/layers/functional/Catalog/domain/entities/category_type.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/card_kind.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/collection_item.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/series.dart';
import 'package:akashic/layers/functional/Lookup/domain/entities/source_match.dart';
import 'package:equatable/equatable.dart';

enum ItemEditorStatus { editing, saving, saved, invalid, failure }

enum SeriesChoice { none, existing, created }

class ItemEditorState extends Equatable {
  const ItemEditorState({
    required this.categoryId,
    required this.titleLanguages,
    this.categoryType = CategoryType.free,
    this.titles = const {},
    this.originalLanguage,
    this.creator = '',
    this.yearText = '',
    this.publisher = '',
    this.imagePath,
    this.spineColorValue,
    this.spineColorIsManual = false,
    this.rating,
    this.seriesChoice = SeriesChoice.none,
    this.existingSeries = const [],
    this.selectedSeries,
    this.volumeFromText = '',
    this.volumeToText = '',
    this.volumeRangeError = false,
    this.status = ItemEditorStatus.editing,
    this.searchResults = const [],
    this.isSearching = false,
    this.webImages = const [],
    this.isSearchingImages = false,
    this.selectedWebImage,
    this.sourceKey,
    this.externalWorkId,
    this.groupKey,
    this.canSearchOnline = false,
    this.canSearchPreconDecks = false,
    this.canSearchSealedProducts = false,
    this.canSearchImages = false,
    this.editingItem,
    this.barcode,
    this.matchVolumeCount,
    this.matchStatus,
    this.cardKind,
  });

  final String categoryId;
  final CategoryType categoryType;
  final List<String> titleLanguages;
  final Map<String, String> titles;
  final String? originalLanguage;
  final String creator;
  final String yearText;
  final String publisher;
  final String? imagePath;
  final int? spineColorValue;
  final bool spineColorIsManual;
  final int? rating;
  final SeriesChoice seriesChoice;
  final List<Series> existingSeries;
  final Series? selectedSeries;
  final String volumeFromText;
  final String volumeToText;
  final bool volumeRangeError;
  final ItemEditorStatus status;
  final List<SourceMatch> searchResults;
  final bool isSearching;
  final List<String> webImages;
  final bool isSearchingImages;
  final String? selectedWebImage;
  final String? sourceKey;
  final String? externalWorkId;
  final String? groupKey;
  final bool canSearchOnline;
  final bool canSearchPreconDecks;
  final bool canSearchSealedProducts;

  bool get searchesPreconDecks => canSearchPreconDecks && cardKind == CardKind.deck;

  bool get searchesSealedProducts => canSearchSealedProducts && cardKind == CardKind.sealed;
  final bool canSearchImages;
  final CollectionItem? editingItem;
  final String? barcode;
  final int? matchVolumeCount;
  final String? matchStatus;
  final CardKind? cardKind;

  bool get isEditing => editingItem != null;

  bool get hasAnyTitle => titles.values.any((title) => title.trim().isNotEmpty);

  ItemEditorState copyWith({
    List<String>? titleLanguages,
    Map<String, String>? titles,
    String? Function()? originalLanguage,
    String? creator,
    String? yearText,
    String? publisher,
    String? Function()? imagePath,
    int? Function()? spineColorValue,
    bool? spineColorIsManual,
    int? Function()? rating,
    SeriesChoice? seriesChoice,
    List<Series>? existingSeries,
    Series? Function()? selectedSeries,
    String? volumeFromText,
    String? volumeToText,
    bool? volumeRangeError,
    ItemEditorStatus? status,
    List<SourceMatch>? searchResults,
    bool? isSearching,
    List<String>? webImages,
    bool? isSearchingImages,
    String? Function()? selectedWebImage,
    String? Function()? sourceKey,
    String? Function()? externalWorkId,
    String? Function()? groupKey,
    String? Function()? barcode,
    int? Function()? matchVolumeCount,
    String? Function()? matchStatus,
    CardKind? cardKind,
  }) {
    return ItemEditorState(
      categoryId: categoryId,
      categoryType: categoryType,
      titleLanguages: titleLanguages ?? this.titleLanguages,
      titles: titles ?? this.titles,
      originalLanguage: originalLanguage == null ? this.originalLanguage : originalLanguage(),
      creator: creator ?? this.creator,
      yearText: yearText ?? this.yearText,
      publisher: publisher ?? this.publisher,
      imagePath: imagePath == null ? this.imagePath : imagePath(),
      spineColorValue: spineColorValue == null ? this.spineColorValue : spineColorValue(),
      spineColorIsManual: spineColorIsManual ?? this.spineColorIsManual,
      rating: rating == null ? this.rating : rating(),
      seriesChoice: seriesChoice ?? this.seriesChoice,
      existingSeries: existingSeries ?? this.existingSeries,
      selectedSeries: selectedSeries == null ? this.selectedSeries : selectedSeries(),
      volumeFromText: volumeFromText ?? this.volumeFromText,
      volumeToText: volumeToText ?? this.volumeToText,
      volumeRangeError: volumeRangeError ?? false,
      status: status ?? ItemEditorStatus.editing,
      searchResults: searchResults ?? this.searchResults,
      isSearching: isSearching ?? this.isSearching,
      webImages: webImages ?? this.webImages,
      isSearchingImages: isSearchingImages ?? this.isSearchingImages,
      selectedWebImage: selectedWebImage == null ? this.selectedWebImage : selectedWebImage(),
      sourceKey: sourceKey == null ? this.sourceKey : sourceKey(),
      externalWorkId: externalWorkId == null ? this.externalWorkId : externalWorkId(),
      groupKey: groupKey == null ? this.groupKey : groupKey(),
      canSearchOnline: canSearchOnline,
      canSearchPreconDecks: canSearchPreconDecks,
      canSearchSealedProducts: canSearchSealedProducts,
      canSearchImages: canSearchImages,
      editingItem: editingItem,
      barcode: barcode == null ? this.barcode : barcode(),
      matchVolumeCount: matchVolumeCount == null ? this.matchVolumeCount : matchVolumeCount(),
      matchStatus: matchStatus == null ? this.matchStatus : matchStatus(),
      cardKind: cardKind ?? this.cardKind,
    );
  }

  @override
  List<Object?> get props => [
        isSearchingImages,
        categoryId,
        categoryType,
        titleLanguages,
        titles,
        originalLanguage,
        creator,
        yearText,
        publisher,
        imagePath,
        spineColorValue,
        spineColorIsManual,
        rating,
        seriesChoice,
        existingSeries,
        selectedSeries,
        volumeFromText,
        volumeToText,
        volumeRangeError,
        status,
        searchResults,
        isSearching,
        webImages,
        selectedWebImage,
        sourceKey,
        externalWorkId,
        groupKey,
        canSearchOnline,
        canSearchPreconDecks,
        canSearchSealedProducts,
        canSearchImages,
        editingItem,
        barcode,
        matchVolumeCount,
        matchStatus,
        cardKind,
      ];
}
