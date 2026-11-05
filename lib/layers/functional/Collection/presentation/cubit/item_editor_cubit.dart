import 'dart:async';
import 'dart:typed_data';

import 'package:akashic/layers/technical/Feedback/error_toasts.dart';
import 'package:akashic/layers/functional/Lookup/presentation/source_failure_toast.dart';
import 'package:akashic/layers/functional/Catalog/domain/entities/category_type.dart';
import 'package:akashic/layers/functional/Catalog/domain/entities/item_field.dart';
import 'package:akashic/layers/functional/Check/domain/use_cases/normalize_barcode.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/card_kind.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/collection_item.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/item_copy.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/localized_titles.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/series.dart';
import 'package:akashic/layers/functional/Collection/domain/use_cases/precon_deck_library.dart';
import 'package:akashic/layers/functional/Collection/domain/use_cases/add_item.dart';
import 'package:akashic/layers/functional/Collection/domain/use_cases/add_series_volumes.dart';
import 'package:akashic/layers/functional/Collection/domain/use_cases/create_series.dart';
import 'package:akashic/layers/functional/Collection/domain/use_cases/search_text_normalizer.dart';
import 'package:akashic/layers/functional/Collection/domain/use_cases/update_item.dart';
import 'package:akashic/layers/functional/Collection/presentation/cubit/item_editor_state.dart';
import 'package:akashic/layers/functional/Lookup/domain/entities/source_match.dart';
import 'package:akashic/layers/functional/Lookup/domain/entities/source_unavailable.dart';
import 'package:akashic/layers/functional/Lookup/domain/gateways/catalog_source.dart';
import 'package:akashic/layers/functional/Lookup/domain/gateways/image_search.dart';
import 'package:akashic/layers/functional/Settings/domain/entities/preferred_languages.dart';
import 'package:akashic/layers/technical/HttpAccess/debounced_search.dart';
import 'package:akashic/layers/technical/MediaStorage/local_image_store.dart';
import 'package:akashic/layers/technical/MediaStorage/phone_image_picker.dart';
import 'package:akashic/layers/technical/MediaStorage/remote_image_downloader.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';

class ItemEditorCubit extends Cubit<ItemEditorState> {
  ItemEditorCubit({
    required String categoryId,
    CategoryType categoryType = CategoryType.free,
    required PreferredLanguages preferredLanguages,
    required this._addItem,
    required this._addSeriesVolumes,
    required this._createSeries,
    required this._imagePicker,
    required this._imageStore,
    required this._extractColor,
    List<Series> existingSeries = const [],
    String Function()? newId,
    this._onlineSources = const [],
    this._imageSearch,
    this._imageDownloader,
    this._searchDelay = DebouncedSearch.defaultDelay,
    this._updateItem,
    CollectionItem? editing,
    this._barcodeLookup,
    this._preconDecks,
    this._sealedProducts,
  })  : _newId = newId ?? const Uuid().v4,
        super(editing == null
            ? ItemEditorState(
                categoryId: categoryId,
                categoryType: categoryType,
                titleLanguages: preferredLanguages.codes,
                existingSeries: existingSeries,
                canSearchOnline: _onlineSources.isNotEmpty,
                canSearchPreconDecks: _preconDecks != null,
                canSearchSealedProducts: _sealedProducts != null,
                canSearchImages: _imageSearch != null,
                cardKind: categoryType == CategoryType.cards ? CardKind.extension : null,
              )
            : _stateForEditing(editing, categoryType, preferredLanguages, canSearchOnline: _onlineSources.isNotEmpty, canSearchImages: _imageSearch != null));

  factory ItemEditorCubit.edit({
    required CollectionItem item,
    required CategoryType categoryType,
    required PreferredLanguages preferredLanguages,
    required UpdateItem updateItem,
    required AddItem addItem,
    required AddSeriesVolumes addSeriesVolumes,
    required CreateSeries createSeries,
    required PhoneImagePicker imagePicker,
    required LocalImageStore imageStore,
    required Future<int> Function(Uint8List bytes) extractColor,
    List<CatalogSource> onlineSources = const [],
    ImageSearch? imageSearch,
    RemoteImageDownloader? imageDownloader,
  }) {
    return ItemEditorCubit(
      categoryId: item.categoryId,
      categoryType: categoryType,
      preferredLanguages: preferredLanguages,
      addItem: addItem,
      addSeriesVolumes: addSeriesVolumes,
      createSeries: createSeries,
      imagePicker: imagePicker,
      imageStore: imageStore,
      extractColor: extractColor,
      onlineSources: onlineSources,
      imageSearch: imageSearch,
      imageDownloader: imageDownloader,
      updateItem: updateItem,
      editing: item,
    );
  }

  static ItemEditorState _stateForEditing(CollectionItem item, CategoryType categoryType, PreferredLanguages preferredLanguages, {required bool canSearchOnline, required bool canSearchImages}) {
    return ItemEditorState(
      categoryId: item.categoryId,
      categoryType: categoryType,
      titleLanguages: [...preferredLanguages.codes, ...item.titles.byLanguage.keys.where((language) => !preferredLanguages.codes.contains(language))],
      titles: item.titles.byLanguage,
      originalLanguage: item.titles.originalLanguage,
      creator: item.creator ?? '',
      yearText: item.year?.toString() ?? '',
      publisher: item.publisher ?? '',
      imagePath: item.imagePath,
      spineColorValue: item.spineColorValue,
      rating: item.rating,
      sourceKey: item.sourceKey,
      externalWorkId: item.externalWorkId,
      groupKey: item.groupKey,
      canSearchOnline: canSearchOnline,
      canSearchImages: canSearchImages,
      editingItem: item,
      cardKind: item.cardKind,
    );
  }

  final AddItem _addItem;
  final AddSeriesVolumes _addSeriesVolumes;
  final CreateSeries _createSeries;
  final PhoneImagePicker _imagePicker;
  final LocalImageStore _imageStore;
  final Set<String> _unsavedImages = {};
  bool _isSaved = false;
  final Future<int> Function(Uint8List bytes) _extractColor;
  final String Function() _newId;
  final List<CatalogSource> _onlineSources;
  final ImageSearch? _imageSearch;
  SourceMatch? _appliedMatch;
  String? _lastImageQuery;
  final RemoteImageDownloader? _imageDownloader;
  final Duration _searchDelay;
  final UpdateItem? _updateItem;
  final Future<List<SourceMatch>> Function(String normalizedBarcode)? _barcodeLookup;
  final PreconDeckLibrary? _preconDecks;
  final Future<List<SourceMatch>> Function(String query)? _sealedProducts;
  String _lastQuery = '';
  Timer? _searchTimer;
  StreamSubscription<List<Series>>? _existingSeriesSubscription;

  void watchExistingSeries(Stream<List<Series>> series) {
    _existingSeriesSubscription?.cancel();
    _existingSeriesSubscription = series.listen(updateExistingSeries);
  }

  @override
  Future<void> close() async {
    _searchTimer?.cancel();
    _onlineSearch.close();
    _preconSearch.close();
    _sealedSearch.close();
    await _existingSeriesSubscription?.cancel();
    if (!_isSaved) {
      for (final path in _unsavedImages) {
        await _imageStore.delete(path);
      }
    }
    return super.close();
  }

  void setTitle(String languageCode, String title) {
    emit(state.copyWith(titles: {...state.titles, languageCode: title}));
  }

  void addTitleLanguage(String languageCode) {
    if (state.titleLanguages.contains(languageCode)) {
      return;
    }
    emit(state.copyWith(titleLanguages: [...state.titleLanguages, languageCode]));
  }

  void setOriginalLanguage(String? languageCode) => emit(state.copyWith(originalLanguage: () => languageCode));

  void setCreator(String creator) => emit(state.copyWith(creator: creator));

  void setYearText(String yearText) => emit(state.copyWith(yearText: yearText));

  void setPublisher(String publisher) => emit(state.copyWith(publisher: publisher));

  void setCardKind(CardKind cardKind) {
    if (cardKind == state.cardKind) {
      return;
    }
    _onlineSearch.cancel();
    _preconSearch.cancel();
    _sealedSearch.cancel();
    emit(state.copyWith(cardKind: cardKind, searchResults: const [], isSearching: false));
    if (_lastQuery.trim().isNotEmpty) {
      searchOnline(_lastQuery);
    }
  }

  void setPlatform(String platform) => emit(state.copyWith(groupKey: () => platform.trim().isEmpty ? null : platform.trim()));

  void setRating(int? rating) => emit(state.copyWith(rating: () => rating));

  void updateExistingSeries(List<Series> series) => emit(state.copyWith(existingSeries: series));

  Future<void> takePhoto() async => _storePicked(await _imagePicker.takePhoto());

  Future<void> pickFromGallery() async => _storePicked(await _imagePicker.pickFromGallery());

  Future<void> _storePicked(Uint8List? bytes) async {
    if (bytes == null) {
      return;
    }
    final path = await _imageStore.save(bytes);
    int? extracted;
    try {
      extracted = await _extractColor(bytes);
    } on FormatException {
      extracted = null;
    }
    if (isClosed) {
      await _imageStore.delete(path);
      return;
    }
    await _replaceUnsavedImage(path);
    emit(state.copyWith(
      imagePath: () => path,
      spineColorValue: () => state.spineColorIsManual ? state.spineColorValue : extracted,
    ));
  }

  late final DebouncedSearch<SourceMatch> _onlineSearch = DebouncedSearch<SourceMatch>(
    _searchAllSources,
    delay: _searchDelay,
    onOutcome: (outcome) {
      if (isClosed) {
        return;
      }
      emit(switch (outcome) {
        SearchCleared() => state.copyWith(searchResults: const [], isSearching: false),
        SearchStarted() => state.copyWith(isSearching: true),
        SearchFinished(:final results) => state.copyWith(searchResults: results, isSearching: false),
      });
    },
  );

  late final DebouncedSearch<SourceMatch> _preconSearch = DebouncedSearch<SourceMatch>(
    _searchPreconDecks,
    delay: _searchDelay,
    onOutcome: (outcome) {
      if (isClosed) {
        return;
      }
      emit(switch (outcome) {
        SearchCleared() => state.copyWith(searchResults: const [], isSearching: false),
        SearchStarted() => state.copyWith(isSearching: true),
        SearchFinished(:final results) => state.copyWith(searchResults: results, isSearching: false),
      });
    },
  );

  late final DebouncedSearch<SourceMatch> _sealedSearch = DebouncedSearch<SourceMatch>(
    _searchSealedProducts,
    delay: _searchDelay,
    onOutcome: (outcome) {
      if (isClosed) {
        return;
      }
      emit(switch (outcome) {
        SearchCleared() => state.copyWith(searchResults: const [], isSearching: false),
        SearchStarted() => state.copyWith(isSearching: true),
        SearchFinished(:final results) => state.copyWith(searchResults: results, isSearching: false),
      });
    },
  );

  Future<List<SourceMatch>> _searchSealedProducts(String query) async {
    try {
      return await _sealedProducts!(query);
    } on SourceUnavailable catch (failure) {
      showSourceFailure(failure);
      return const [];
    }
  }

  Future<List<SourceMatch>> _searchPreconDecks(String query) async {
    try {
      return await _preconDecks!.search(query);
    } on SourceUnavailable catch (failure) {
      showSourceFailure(failure);
      return const [];
    }
  }

  void searchOnline(String query) {
    _lastQuery = query;
    _searchTimer?.cancel();
    if (state.searchesPreconDecks) {
      _preconSearch.request(query);
      return;
    }
    if (state.searchesSealedProducts) {
      _sealedSearch.request(query);
      return;
    }
    final typedBarcode = RegExp(r'^[\d\s-]{8,17}$').hasMatch(query.trim()) ? normalizeBarcode(query) : null;
    if (typedBarcode != null && _barcodeLookup != null) {
      _onlineSearch.cancel();
      _searchTimer = Timer(_searchDelay, () => useBarcode(typedBarcode));
      return;
    }
    _onlineSearch.request(query);
  }

  Future<List<SourceMatch>> _searchAllSources(String query) async {
    final answers = await Future.wait(_onlineSources.map((source) => source.search(query).catchError((Object failure) {
          showSourceFailure(failure as SourceUnavailable);
          return const <SourceMatch>[];
        }, test: (error) => error is SourceUnavailable)));
    final results = <SourceMatch>[];
    for (var rank = 0; answers.any((answer) => rank < answer.length); rank++) {
      for (final answer in answers) {
        if (rank < answer.length) {
          results.add(answer[rank]);
        }
      }
    }
    return results;
  }

  Future<void> useBarcode(String raw) async {
    final barcode = normalizeBarcode(raw);
    final lookup = _barcodeLookup;
    if (barcode == null || isClosed) {
      return;
    }
    emit(state.copyWith(barcode: () => barcode, isSearching: lookup != null));
    if (lookup == null) {
      return;
    }
    List<SourceMatch> results;
    try {
      results = await lookup(barcode);
    } on SourceUnavailable catch (failure) {
      showSourceFailure(failure);
      results = const [];
    }
    if (!isClosed) {
      emit(state.copyWith(searchResults: results, isSearching: false));
    }
  }

  Future<void> applyMatch(SourceMatch match) async {
    final languages = [...state.titleLanguages, ...match.titles.byLanguage.keys.where((language) => !state.titleLanguages.contains(language))];
    emit(state.copyWith(
      titleLanguages: languages,
      titles: {...state.titles, ...match.titles.byLanguage},
      originalLanguage: () => match.titles.originalLanguage ?? state.originalLanguage,
      creator: match.creator ?? state.creator,
      yearText: match.year?.toString() ?? state.yearText,
      publisher: match.publisher ?? state.publisher,
      sourceKey: () => match.sourceKey,
      externalWorkId: () => match.externalWorkId,
      matchVolumeCount: () => match.volumeCount,
      matchStatus: () => match.status,
      groupKey: () => match.platform ?? (match.creator != null && match.suggestedType == CategoryType.music ? match.creator : state.groupKey),
      searchResults: const [],
    ));
    if (match.volumeNumber case final volumeNumber? when state.categoryType.itemFields.contains(ItemField.series)) {
      _placeInSeries(match, volumeNumber);
    }
    _appliedMatch = match;
    emit(state.copyWith(webImages: [?match.imageUrl]));
    if (PreconDeckLibrary.isPrecon(match.sourceKey)) {
      await _useDeckCover(match.externalWorkId);
    }
  }

  Future<void> _useDeckCover(String deckId) async {
    final preconDecks = _preconDecks;
    if (preconDecks == null) {
      return;
    }
    String? cover;
    try {
      cover = await preconDecks.coverOf(deckId);
    } on SourceUnavailable catch (failure) {
      showSourceFailure(failure);
    }
    if (cover == null || isClosed) {
      return;
    }
    emit(state.copyWith(webImages: [cover, ...state.webImages.where((url) => url != cover)]));
    await chooseWebImage(cover);
  }

  Future<void> searchWebImages() async {
    final imageSearch = _imageSearch;
    final query = [?state.titles.values.where((title) => title.trim().isNotEmpty).firstOrNull, if (state.creator.trim().isNotEmpty) state.creator.trim()].join(' ');
    if (imageSearch == null || query.isEmpty || query == _lastImageQuery || state.isSearchingImages) {
      return;
    }
    _lastImageQuery = query;
    emit(state.copyWith(isSearchingImages: true));
    final images = await imageSearch.imagesFor(_appliedMatch, query);
    if (!isClosed) {
      emit(state.copyWith(webImages: {...state.webImages, ...images}.toList(), isSearchingImages: false));
    }
  }

  Future<void> chooseWebImage(String url) async {
    final downloader = _imageDownloader;
    if (downloader == null) {
      return;
    }
    final bytes = await downloader.download(url);
    if (bytes == null || isClosed) {
      return;
    }
    final path = await _imageStore.save(bytes);
    int? extracted;
    try {
      extracted = await _extractColor(bytes);
    } on FormatException {
      extracted = null;
    }
    if (isClosed) {
      await _imageStore.delete(path);
      return;
    }
    await _replaceUnsavedImage(path);
    emit(state.copyWith(
      imagePath: () => path,
      selectedWebImage: () => url,
      spineColorValue: () => state.spineColorIsManual ? state.spineColorValue : (extracted ?? state.spineColorValue),
    ));
  }

  void overrideSpineColor(int colorValue) {
    emit(state.copyWith(spineColorValue: () => colorValue, spineColorIsManual: true));
  }

  void _placeInSeries(SourceMatch match, int volumeNumber) {
    final titles = {
      ...match.titles.byLanguage.values.map(normalizeForSearch),
      if (match.seriesTitle case final seriesTitle?) normalizeForSearch(seriesTitle),
    };
    final existing = state.existingSeries.where((series) {
      final sameWork = series.sourceKey == match.sourceKey && series.externalWorkId == match.externalWorkId;
      return sameWork || series.titles.byLanguage.values.map(normalizeForSearch).any(titles.contains);
    }).firstOrNull;
    emit(state.copyWith(
      seriesChoice: existing == null ? SeriesChoice.created : SeriesChoice.existing,
      selectedSeries: () => existing,
      volumeFromText: '$volumeNumber',
      volumeToText: '$volumeNumber',
    ));
  }

  void clearSeries() => emit(state.copyWith(seriesChoice: SeriesChoice.none, selectedSeries: () => null));

  void startNewSeries() => emit(state.copyWith(seriesChoice: SeriesChoice.created, selectedSeries: () => null));

  void chooseExistingSeries(Series series) {
    emit(state.copyWith(seriesChoice: SeriesChoice.existing, selectedSeries: () => series));
  }

  void setVolumeRange({required String from, required String to}) {
    emit(state.copyWith(volumeFromText: from, volumeToText: to));
  }

  Future<void> submit() async {
    if (!state.hasAnyTitle && state.seriesChoice != SeriesChoice.existing) {
      emit(state.copyWith(status: ItemEditorStatus.invalid));
      return;
    }
    final range = _volumeRange();
    if (state.seriesChoice != SeriesChoice.none && range == null) {
      emit(state.copyWith(volumeRangeError: true, status: ItemEditorStatus.invalid));
      return;
    }
    emit(state.copyWith(status: ItemEditorStatus.saving));
    try {
      await _save(range);
    } on Exception {
      ErrorToasts.instance.show((l10n) => l10n.itemSaveFailedToast);
      if (!isClosed) {
        emit(state.copyWith(status: ItemEditorStatus.failure));
      }
      return;
    }
    _isSaved = true;
    if (!isClosed) {
      emit(state.copyWith(status: ItemEditorStatus.saved));
    }
  }

  Future<void> _replaceUnsavedImage(String path) async {
    final previous = state.imagePath;
    if (previous != null && _unsavedImages.remove(previous)) {
      await _imageStore.delete(previous);
    }
    _unsavedImages.add(path);
  }

  Future<void> _fillPreconDeck(String itemId, String deckId) async {
    try {
      await _preconDecks?.fill(itemId, deckId);
    } on SourceUnavailable catch (failure) {
      showSourceFailure(failure);
    }
  }

  Future<void> _save((int, int)? range) async {
    final titles = LocalizedTitles(
      byLanguage: {
        for (final MapEntry(key: language, value: title) in state.titles.entries)
          if (title.trim().isNotEmpty) language: title.trim(),
      },
      originalLanguage: state.originalLanguage,
    );
    final creator = state.creator.trim().isEmpty ? null : state.creator.trim();
    final template = CollectionItem(
      id: _newId(),
      categoryId: state.categoryId,
      titles: titles,
      creator: creator,
      year: int.tryParse(state.yearText.trim()),
      publisher: state.publisher.trim().isEmpty ? null : state.publisher.trim(),
      imagePath: state.imagePath,
      spineColorValue: state.spineColorValue,
      rating: state.rating,
      sourceKey: state.sourceKey,
      externalWorkId: state.externalWorkId,
      groupKey: state.groupKey,
      cardKind: state.cardKind,
    );
    final editingItem = state.editingItem;
    final updateItem = _updateItem;
    if (editingItem != null && updateItem != null) {
      await updateItem(CollectionItem(
        id: editingItem.id,
        categoryId: editingItem.categoryId,
        seriesId: editingItem.seriesId,
        volumeNumber: editingItem.volumeNumber,
        titles: titles,
        creator: template.creator,
        year: template.year,
        publisher: template.publisher,
        imagePath: template.imagePath,
        spineColorValue: template.spineColorValue,
        rating: template.rating,
        groupKey: template.groupKey,
        sourceKey: template.sourceKey,
        externalWorkId: template.externalWorkId,
        cardKind: template.cardKind,
      ));
      return;
    }
    if (state.seriesChoice == SeriesChoice.none) {
      final barcode = state.barcode;
      if (barcode == null) {
        await _addItem(template);
      } else {
        await _addItem(template, firstCopy: ItemCopy(id: _newId(), itemId: template.id, barcode: barcode));
      }
      if (template.cardKind == CardKind.deck && PreconDeckLibrary.isPrecon(template.sourceKey) && template.externalWorkId != null) {
        await _fillPreconDeck(template.id, template.externalWorkId!);
      }
    } else {
      final series = state.selectedSeries ?? await _createSeries(
            categoryId: state.categoryId,
            titles: titles,
            creator: creator,
            sourceKey: state.sourceKey,
            externalWorkId: state.externalWorkId,
            publishedVolumes: state.matchVolumeCount,
            status: state.matchStatus,
          );
      await _addSeriesVolumes(
        series: series,
        from: range!.$1,
        to: range.$2,
        template: CollectionItem(
          id: template.id,
          categoryId: template.categoryId,
          titles: titles.byLanguage.isEmpty ? series.titles : titles,
          creator: creator,
          year: template.year,
          publisher: template.publisher,
          imagePath: template.imagePath,
          spineColorValue: template.spineColorValue,
          seriesId: series.id,
          rating: template.rating,
          groupKey: template.groupKey,
          cardKind: template.cardKind,
          sourceKey: template.sourceKey,
          externalWorkId: template.externalWorkId,
        ),
        copyTemplate: range.$1 == range.$2 && state.barcode != null ? ItemCopy(id: '', itemId: '', barcode: state.barcode) : null,
        addsOwnedVolumesAgain: range.$1 == range.$2,
      );
    }
  }

  (int, int)? _volumeRange() {
    final from = int.tryParse(state.volumeFromText.trim());
    final to = state.volumeToText.trim().isEmpty ? from : int.tryParse(state.volumeToText.trim());
    if (from == null || to == null || from < 1 || from > to) {
      return null;
    }
    return (from, to);
  }
}
