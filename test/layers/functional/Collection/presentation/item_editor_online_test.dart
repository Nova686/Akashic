import 'dart:typed_data';

import 'package:akashic/layers/functional/Catalog/domain/entities/category_type.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/collection_item.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/localized_titles.dart';
import 'package:akashic/layers/functional/Collection/domain/use_cases/add_item.dart';
import 'package:akashic/layers/functional/Collection/domain/use_cases/add_series_volumes.dart';
import 'package:akashic/layers/functional/Collection/domain/use_cases/create_series.dart';
import 'package:akashic/layers/functional/Collection/presentation/cubit/item_editor_cubit.dart';
import 'package:akashic/layers/functional/Lookup/domain/entities/source_match.dart';
import 'package:akashic/layers/functional/Lookup/domain/gateways/catalog_source.dart';
import 'package:akashic/layers/functional/Lookup/domain/gateways/image_search.dart';
import 'package:akashic/layers/functional/Settings/domain/entities/preferred_languages.dart';
import 'package:akashic/layers/technical/MediaStorage/local_image_store.dart';
import 'package:akashic/layers/technical/MediaStorage/phone_image_picker.dart';
import 'package:akashic/layers/technical/MediaStorage/remote_image_downloader.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAddItem extends Mock implements AddItem {}

class MockAddSeriesVolumes extends Mock implements AddSeriesVolumes {}

class MockCreateSeries extends Mock implements CreateSeries {}

class MockLocalImageStore extends Mock implements LocalImageStore {}

class MockDownloader extends Mock implements RemoteImageDownloader {}

class NoPicker implements PhoneImagePicker {
  @override
  Future<Uint8List?> pickFromGallery() async => null;

  @override
  Future<Uint8List?> takePhoto() async => null;
}

class FakeAniList implements CatalogSource {
  final queries = <String>[];

  @override
  String get key => 'anilist';

  @override
  Set<CategoryType> get types => const {CategoryType.manga};

  @override
  bool get isConfigured => true;

  @override
  bool get supportsBarcode => false;

  @override
  Future<List<SourceMatch>> lookupBarcode(String barcode) async => const [];

  @override
  Future<List<SourceMatch>> search(String query) async {
    queries.add(query);
    return const [frieren];
  }
}

class FakeImageSearch implements ImageSearch {
  @override
  Future<List<String>> imagesFor(SourceMatch? match, String query) async => ['https://cover/frieren.jpg', 'https://commons/frieren.jpg'];
}

const frieren = SourceMatch(
  sourceKey: 'anilist',
  externalWorkId: '118586',
  titles: LocalizedTitles(byLanguage: {'en': 'Frieren: Beyond Journey’s End', 'ja': '葬送のフリーレン'}, originalLanguage: 'ja'),
  creator: 'Kanehito Yamada, Tsukasa Abe',
  year: 2020,
  imageUrl: 'https://cover/frieren.jpg',
  suggestedType: CategoryType.manga,
);

void main() {
  late MockAddItem addItem;
  late MockLocalImageStore imageStore;
  late MockDownloader downloader;
  late FakeAniList aniList;

  setUpAll(() {
    registerFallbackValue(Uint8List(0));
    registerFallbackValue(const CollectionItem(id: 'fallback', categoryId: 'fallback', titles: LocalizedTitles(byLanguage: {})));
  });

  setUp(() {
    addItem = MockAddItem();
    imageStore = MockLocalImageStore();
    when(() => imageStore.delete(any())).thenAnswer((_) async {});
    downloader = MockDownloader();
    aniList = FakeAniList();
    when(() => addItem(any())).thenAnswer((invocation) async => invocation.positionalArguments.first as CollectionItem);
    when(() => downloader.download(any())).thenAnswer((_) async => Uint8List.fromList([7]));
    when(() => imageStore.save(any())).thenAnswer((_) async => '/images/frieren.jpg');
  });

  ItemEditorCubit editor() => ItemEditorCubit(
        categoryId: 'mangas',
        preferredLanguages: PreferredLanguages.defaults,
        addItem: addItem,
        addSeriesVolumes: MockAddSeriesVolumes(),
        createSeries: MockCreateSeries(),
        imagePicker: NoPicker(),
        imageStore: imageStore,
        extractColor: (_) async => 0xFFE4AE5D,
        onlineSources: [aniList],
        imageSearch: FakeImageSearch(),
        imageDownloader: downloader,
        searchDelay: Duration.zero,
      );

  test('typing searches the category source after a pause and keeps only the last query', () async {
    final cubit = editor();
    cubit.searchOnline('fri');
    cubit.searchOnline('frieren');
    await Future<void>.delayed(const Duration(milliseconds: 10));
    expect(aniList.queries, ['frieren']);
    expect(cubit.state.searchResults, [frieren]);
    await cubit.close();
  });

  test('applying a match fills titles, creator and ids, and web images come when asked', () async {
    final cubit = editor();
    await cubit.applyMatch(frieren);
    expect(cubit.state.webImages, ['https://cover/frieren.jpg']);
    await cubit.searchWebImages();
    expect(cubit.state.titles['en'], 'Frieren: Beyond Journey’s End');
    expect(cubit.state.titleLanguages, containsAll(['fr', 'en', 'ja']));
    expect(cubit.state.originalLanguage, 'ja');
    expect(cubit.state.creator, 'Kanehito Yamada, Tsukasa Abe');
    expect(cubit.state.yearText, '2020');
    expect(cubit.state.webImages, ['https://cover/frieren.jpg', 'https://commons/frieren.jpg']);
    await cubit.submit();
    final saved = verify(() => addItem(captureAny())).captured.single as CollectionItem;
    expect(saved.sourceKey, 'anilist');
    expect(saved.externalWorkId, '118586');
    await cubit.close();
  });

  test('choosing a web image stores it and colors the spine', () async {
    final cubit = editor();
    await cubit.chooseWebImage('https://cover/frieren.jpg');
    expect(cubit.state.imagePath, '/images/frieren.jpg');
    expect(cubit.state.spineColorValue, 0xFFE4AE5D);
    expect(cubit.state.selectedWebImage, 'https://cover/frieren.jpg');
    await cubit.close();
  });
}
