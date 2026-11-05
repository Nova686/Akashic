import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:akashic/layers/functional/Catalog/domain/entities/category.dart';
import 'package:akashic/layers/functional/Catalog/domain/entities/category_type.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/card_kind.dart';
import 'package:akashic/layers/functional/Collection/domain/use_cases/add_item.dart';
import 'package:akashic/layers/functional/Collection/domain/use_cases/add_series_volumes.dart';
import 'package:akashic/layers/functional/Collection/domain/use_cases/create_series.dart';
import 'package:akashic/layers/functional/Collection/domain/use_cases/sealed_product_library.dart';
import 'package:akashic/layers/functional/Collection/presentation/cubit/item_editor_cubit.dart';
import 'package:akashic/layers/functional/Lookup/data/sources/cardmarket_catalogue.dart';
import 'package:akashic/layers/functional/Lookup/domain/entities/card_game.dart';
import 'package:akashic/layers/functional/Settings/domain/entities/preferred_languages.dart';
import 'package:akashic/layers/technical/MediaStorage/local_image_store.dart';
import 'package:akashic/layers/technical/MediaStorage/phone_image_picker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

import '../collection_harness.dart';

class NoPicker implements PhoneImagePicker {
  @override
  Future<Uint8List?> pickFromGallery() async => null;

  @override
  Future<Uint8List?> takePhoto() async => null;
}

CardmarketCatalogue fakeCardmarket({List<Uri>? requested}) => CardmarketCatalogue(MockClient((request) async {
      requested?.add(request.url);
      if (request.url.path != '/productCatalog/productList/products_nonsingles_6.json') {
        return http.Response('', 404);
      }
      return http.Response.bytes(
          utf8.encode(jsonEncode({
            'version': 1,
            'products': [
              {'idProduct': 101, 'name': 'Scarlet & Violet: Prismatic Evolutions Elite Trainer Box', 'idCategory': 1, 'categoryName': 'Elite Trainer Boxes', 'dateAdded': '2024-11-02 10:00:00'},
              {'idProduct': 102, 'name': 'Scarlet & Violet: Prismatic Evolutions Booster', 'idCategory': 2, 'categoryName': 'Pokémon Booster', 'dateAdded': '2024-11-02 10:00:00'},
              {'idProduct': 103, 'name': 'Sword & Shield: Evolving Skies Booster Box', 'idCategory': 3, 'categoryName': 'Pokémon Display', 'dateAdded': '2021-06-01 10:00:00'},
              {'idProduct': 104, 'name': 'Évoli Tin', 'idCategory': 4, 'categoryName': 'Tins', 'dateAdded': '2019-03-01 10:00:00'},
            ],
          })),
          200,
          headers: {'content-type': 'application/json; charset=utf-8'});
    }));

void main() {
  test('the sealed search matches names and translated product types, newest first', () async {
    final library = SealedProductLibrary(fakeCardmarket());
    final etb = (await library.search('prismatic etb', CardGame.pokemon)).single;
    expect(etb.titles.byLanguage['en'], 'Scarlet & Violet: Prismatic Evolutions Elite Trainer Box');
    expect(etb.format, 'ETB');
    expect(etb.year, 2024);
    expect(etb.sourceKey, 'cardmarket');
    expect(etb.externalWorkId, '101');
    expect((await library.search('display', CardGame.pokemon)).single.externalWorkId, '103');
    expect((await library.search('evoli', CardGame.pokemon)).single.format, 'Tin');
    expect((await library.search('booster', CardGame.pokemon)).map((match) => match.externalWorkId), ['102', '103']);
    expect(await library.search('  ', CardGame.pokemon), isEmpty);
  });

  test('the catalogue of a game is downloaded once per session', () async {
    final requested = <Uri>[];
    final library = SealedProductLibrary(fakeCardmarket(requested: requested));
    await library.search('booster', CardGame.pokemon);
    await library.search('tin', CardGame.pokemon);
    expect(requested, hasLength(1));
  });

  test('sealed products are offered in card categories of a game Cardmarket sells', () {
    Category cards(String name, {CategoryType type = CategoryType.cards}) => Category(id: name, name: name, colorValue: 0, type: type, conditionParts: const ['Objet'], position: 0);
    final catalogue = fakeCardmarket();
    expect(sealedGameOf(cards('Pokémon'), catalogue), CardGame.pokemon);
    expect(sealedGameOf(cards('One Piece'), catalogue), CardGame.onePiece);
    expect(sealedGameOf(cards('TCG'), catalogue), isNull);
    expect(sealedGameOf(cards('Pokémon', type: CategoryType.books), catalogue), isNull);
    expect(sealedGameOf(null, catalogue), isNull);
  });

  test('choosing sealed in the add form searches the catalogue and saves a sealed item', () async {
    final harness = CollectionHarness();
    addTearDown(harness.database.close);
    final pokemon = await harness.createCategory(name: 'Pokémon', colorValue: 0, type: CategoryType.cards, conditionParts: const ['Objet']);
    final library = SealedProductLibrary(fakeCardmarket());
    final editor = ItemEditorCubit(
      categoryId: pokemon.id,
      categoryType: CategoryType.cards,
      preferredLanguages: PreferredLanguages.defaults,
      addItem: AddItem(harness.collection, harness.categories),
      addSeriesVolumes: AddSeriesVolumes(harness.collection),
      createSeries: CreateSeries(harness.collection),
      imagePicker: NoPicker(),
      imageStore: LocalImageStore(Directory.systemTemp),
      extractColor: (_) async => 0,
      searchDelay: Duration.zero,
      sealedProducts: (query) => library.search(query, CardGame.pokemon),
    );
    expect(editor.state.canSearchSealedProducts, isTrue);
    editor.searchOnline('evolving skies');
    editor.setCardKind(CardKind.sealed);
    expect(editor.state.searchesSealedProducts, isTrue);
    await Future<void>.delayed(const Duration(milliseconds: 30));
    final display = editor.state.searchResults.single;
    expect(display.format, 'Display');
    await editor.applyMatch(display);
    await editor.submit();
    final item = (await harness.collection.allItems()).single;
    expect(item.cardKind, CardKind.sealed);
    expect(item.titles.byLanguage['en'], 'Sword & Shield: Evolving Skies Booster Box');
    expect(item.externalWorkId, '103');
    await editor.close();
  });
}
