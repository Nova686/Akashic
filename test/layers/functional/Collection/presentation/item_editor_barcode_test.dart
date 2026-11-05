import 'dart:io';
import 'dart:typed_data';

import 'package:akashic/layers/functional/Collection/domain/gateways/collection_gateway.dart';

import 'package:akashic/layers/functional/Catalog/domain/entities/category_type.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/collection_item.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/item_copy.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/localized_titles.dart';
import 'package:akashic/layers/functional/Collection/domain/use_cases/add_item.dart';
import 'package:akashic/layers/functional/Collection/domain/use_cases/add_series_volumes.dart';
import 'package:akashic/layers/functional/Collection/domain/use_cases/create_series.dart';
import 'package:akashic/layers/functional/Collection/presentation/cubit/item_editor_cubit.dart';
import 'package:akashic/layers/functional/Lookup/domain/entities/source_match.dart';
import 'package:akashic/layers/functional/Settings/domain/entities/preferred_languages.dart';
import 'package:akashic/layers/technical/MediaStorage/local_image_store.dart';
import 'package:akashic/layers/technical/MediaStorage/phone_image_picker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAddItem extends Mock implements AddItem {}

class NoPicker implements PhoneImagePicker {
  @override
  Future<Uint8List?> pickFromGallery() async => null;

  @override
  Future<Uint8List?> takePhoto() async => null;
}

const kindOfBlue = SourceMatch(
  sourceKey: 'musicbrainz',
  externalWorkId: 'kob',
  externalEditionId: 'release-2007',
  titles: LocalizedTitles(byLanguage: {'en': 'Kind of Blue'}),
  barcode: '4547366033267',
  suggestedType: CategoryType.music,
);

void main() {
  late MockAddItem addItem;
  late List<String> lookedUp;

  setUpAll(() {
    registerFallbackValue(const CollectionItem(id: 'f', categoryId: 'f', titles: LocalizedTitles(byLanguage: {})));
    registerFallbackValue(const ItemCopy(id: 'f', itemId: 'f'));
  });

  setUp(() {
    addItem = MockAddItem();
    lookedUp = [];
    when(() => addItem(any(), firstCopy: any(named: 'firstCopy'))).thenAnswer((invocation) async => invocation.positionalArguments.first as CollectionItem);
  });

  ItemEditorCubit editor() => ItemEditorCubit(
        categoryId: 'vinyls',
        categoryType: CategoryType.music,
        preferredLanguages: PreferredLanguages.defaults,
        addItem: addItem,
        addSeriesVolumes: AddSeriesVolumes(_NoCollection()),
        createSeries: CreateSeries(_NoCollection()),
        imagePicker: NoPicker(),
        imageStore: LocalImageStore(Directory.systemTemp),
        extractColor: (_) async => 0,
        barcodeLookup: (barcode) async {
          lookedUp.add(barcode);
          return const [kindOfBlue];
        },
        searchDelay: Duration.zero,
      );

  test('a scanned barcode is normalized, looked up and saved on the first copy', () async {
    final cubit = editor();
    await cubit.useBarcode('074646093822');
    expect(cubit.state.barcode, '0074646093822');
    expect(lookedUp, ['0074646093822']);
    expect(cubit.state.searchResults, [kindOfBlue]);
    cubit.setTitle('en', 'Kind of Blue');
    await cubit.submit();
    final copy = verify(() => addItem(any(), firstCopy: captureAny(named: 'firstCopy'))).captured.single as ItemCopy;
    expect(copy.barcode, '0074646093822');
    await cubit.close();
  });

  test('digits typed in the search field are treated as a barcode', () async {
    final cubit = editor();
    cubit.searchOnline('4547366033267');
    await Future<void>.delayed(const Duration(milliseconds: 10));
    expect(lookedUp, ['4547366033267']);
    expect(cubit.state.barcode, '4547366033267');
    await cubit.close();
  });
}

class _NoCollection extends Mock implements CollectionGateway {}
