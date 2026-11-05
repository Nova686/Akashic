import 'package:akashic/layers/functional/Catalog/domain/gateways/category_gateway.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/item_condition.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/trade_channel.dart';
import 'package:akashic/layers/functional/Collection/domain/gateways/collection_gateway.dart';
import 'package:akashic/layers/functional/Collection/domain/use_cases/resolve_display_title.dart';
import 'package:akashic/layers/functional/Settings/domain/entities/preferred_languages.dart';

class SpreadsheetWording {
  const SpreadsheetWording({required this.headers, required this.conditionLabel, required this.channelLabel});

  final List<String> headers;
  final String Function(ItemCondition condition) conditionLabel;
  final String Function(TradeChannel channel) channelLabel;
}

class ExportCollectionRows {
  ExportCollectionRows(this._collection, this._categories);

  final CollectionGateway _collection;
  final CategoryGateway _categories;

  static const int columnCount = 21;

  String _date(DateTime? date) => date == null ? '' : '${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';

  String _amount(int? cents) => cents == null ? '' : (cents / 100).toStringAsFixed(2).replaceAll('.', ',');

  Future<List<List<String>>> call(SpreadsheetWording wording, PreferredLanguages languages) async {
    assert(wording.headers.length == columnCount, 'one header per column');
    final namesById = <String, String>{};
    final parentById = <String, String?>{};
    for (final node in await _categories.watchTree().first) {
      namesById[node.category.id] = node.category.name;
      for (final child in node.children) {
        namesById[child.id] = child.name;
        parentById[child.id] = node.category.id;
      }
    }
    final seriesById = {for (final series in await _collection.watchAllSeries().first) series.id: resolveDisplayTitle(series.titles, languages) ?? ''};
    final items = [...await _collection.allItems()]
      ..sort((first, second) => (resolveDisplayTitle(first.titles, languages) ?? '').toLowerCase().compareTo((resolveDisplayTitle(second.titles, languages) ?? '').toLowerCase()));
    final rows = <List<String>>[wording.headers];
    for (final item in items) {
      final copy = (await _collection.watchCopies(item.id).first).firstOrNull;
      final parentId = parentById[item.categoryId];
      rows.add([
        parentId == null ? namesById[item.categoryId] ?? '' : namesById[parentId] ?? '',
        parentId == null ? '' : namesById[item.categoryId] ?? '',
        resolveDisplayTitle(item.titles, languages) ?? '',
        item.creator ?? '',
        item.year?.toString() ?? '',
        item.publisher ?? '',
        seriesById[item.seriesId] ?? '',
        item.volumeNumber?.toString() ?? '',
        item.groupKey ?? '',
        copy?.edition ?? '',
        copy?.barcode ?? '',
        _amount(copy?.pricePaidCents),
        _date(copy?.purchasedOn),
        copy?.purchaseChannel == null ? '' : wording.channelLabel(copy!.purchaseChannel!),
        copy?.location ?? '',
        [for (final MapEntry(key: part, value: condition) in copy?.conditions.entries ?? const <MapEntry<String, ItemCondition>>[]) '$part : ${wording.conditionLabel(condition)}'].join(' · '),
        item.rating?.toString() ?? '',
        copy?.loanedTo ?? '',
        _amount(item.marketValue?.cents),
        item.marketValue?.currency ?? '',
        _date(item.addedAt),
      ]);
    }
    return rows;
  }
}
