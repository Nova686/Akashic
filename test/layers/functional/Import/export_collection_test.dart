import 'dart:convert';

import 'package:akashic/layers/functional/Catalog/domain/entities/category_type.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/collection_item.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/item_condition.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/item_copy.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/localized_titles.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/series.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/trade_channel.dart';
import 'package:akashic/layers/functional/Import/data/readers/spreadsheet_writer.dart';
import 'package:akashic/layers/functional/Import/domain/use_cases/export_collection_rows.dart';
import 'package:akashic/layers/functional/Settings/domain/entities/preferred_languages.dart';
import 'package:flutter_test/flutter_test.dart';

import '../Collection/collection_harness.dart';

void main() {
  test('the collection is exported one row per item, with its category, series, purchase and value', () async {
    final harness = CollectionHarness();
    addTearDown(harness.database.close);
    final mangas = await harness.mangas();
    final shonen = await harness.createCategory(name: 'Shōnen', colorValue: 0, type: CategoryType.manga, parentId: mangas.id, conditionParts: const ['Objet']);
    await harness.collection.saveSeries(Series(id: 'op', categoryId: shonen.id, titles: const LocalizedTitles(byLanguage: {'fr': 'One Piece'})));
    await harness.collection.saveItem(CollectionItem(id: 'op-104', categoryId: shonen.id, seriesId: 'op', volumeNumber: 104, titles: const LocalizedTitles(byLanguage: {'fr': 'One Piece'}), creator: 'Eiichiro Oda', year: 2023, rating: 5));
    await harness.collection.saveCopy(ItemCopy(id: 'op-104-copy', itemId: 'op-104', pricePaidCents: 699, purchasedOn: DateTime(2023, 3, 1), purchaseChannel: TradeChannel.store, location: 'Salon', barcode: '9782344051412', conditions: const {'Objet': ItemCondition.good}));
    final headers = [for (var index = 0; index < ExportCollectionRows.columnCount; index++) 'h$index'];
    final rows = await ExportCollectionRows(harness.collection, harness.categories)(
      SpreadsheetWording(headers: headers, conditionLabel: (condition) => condition.name, channelLabel: (channel) => channel.name),
      PreferredLanguages.defaults,
    );
    expect(rows.first, headers);
    expect(rows[1], ['Mangas', 'Shōnen', 'One Piece', 'Eiichiro Oda', '2023', '', 'One Piece', '104', '', '', '9782344051412', '6,99', '2023-03-01', 'store', 'Salon', 'Objet : good', '5', '', '', '', isA<String>()]);
    final bytes = csvBytesOf([['Titre', 'Prix'], ['One Piece; tome 104', '6,99']]);
    final text = utf8.decode(bytes);
    expect(bytes.take(3), [0xEF, 0xBB, 0xBF]);
    expect(text, contains('Titre;Prix'));
    expect(text, contains('"One Piece; tome 104";6,99'));
  });
}
