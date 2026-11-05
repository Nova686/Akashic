import 'package:akashic/layers/functional/Activity/domain/entities/activity_event.dart';
import 'package:akashic/layers/functional/Activity/domain/gateways/activity_log.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/collection_item.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/item_copy.dart';
import 'package:akashic/layers/functional/Collection/domain/gateways/collection_gateway.dart';
import 'package:akashic/layers/functional/Collection/domain/use_cases/resolve_display_title.dart';
import 'package:akashic/layers/functional/Preorders/domain/gateways/preorder_alerts.dart';
import 'package:akashic/layers/functional/Settings/domain/entities/preferred_languages.dart';
import 'package:uuid/uuid.dart';

String preorderKeyOf(CollectionItem item) => '${item.id}|${item.preorder!.dueOn.millisecondsSinceEpoch}';

class ManagePreorder {
  ManagePreorder(this._collection, {this._activityLog, DateTime Function()? now, String Function()? newId})
      : _now = now ?? DateTime.now,
        _newId = newId ?? const Uuid().v4;

  final CollectionGateway _collection;
  final ActivityLog? _activityLog;
  final DateTime Function() _now;
  final String Function() _newId;

  Future<void> set(String itemId, {required DateTime dueOn, int? depositCents}) => _collection.savePreorder(itemId, Preorder(dueOn: dueOn, depositCents: depositCents));

  Future<void> cancel(String itemId) => _collection.savePreorder(itemId, null);

  Future<void> receive(String itemId) async {
    final item = await _collection.watchItem(itemId).first;
    if (item == null || !item.isPreordered) {
      return;
    }
    final now = _now();
    await _collection.savePreorder(itemId, null);
    final copy = (await _collection.watchCopies(itemId).first).firstOrNull;
    if (copy == null) {
      await _collection.saveCopy(ItemCopy(id: _newId(), itemId: itemId, purchasedOn: now));
    } else if (copy.purchasedOn == null) {
      await _collection.saveCopy(ItemCopy(
        id: copy.id,
        itemId: copy.itemId,
        edition: copy.edition,
        pricePaidCents: copy.pricePaidCents,
        location: copy.location,
        conditions: copy.conditions,
        barcode: copy.barcode,
        externalEditionId: copy.externalEditionId,
        isOpened: copy.isOpened,
        purchasedOn: now,
        purchaseChannel: copy.purchaseChannel,
      ));
    }
    await _activityLog?.record(ActivityEvent(kind: ActivityKind.received, title: resolveDisplayTitle(item.titles, PreferredLanguages.defaults) ?? '', at: now, itemId: itemId, categoryId: item.categoryId));
  }
}

class AnnouncePreorderArrivals {
  AnnouncePreorderArrivals(this._collection, this._alerts, this._memory, {DateTime Function()? now}) : _now = now ?? DateTime.now;

  final CollectionGateway _collection;
  final PreorderAlerts _alerts;
  final PreorderAlertMemory _memory;
  final DateTime Function() _now;

  Future<List<String>> call() async {
    final today = _now();
    final announced = await _memory.announced();
    final arriving = [
      for (final item in await _collection.allItems())
        if (item.preorder case final preorder? when preorder.daysLeftFrom(today) <= 0 && !announced.contains(preorderKeyOf(item))) item,
    ];
    if (arriving.isEmpty) {
      return const [];
    }
    final titles = [for (final item in arriving) resolveDisplayTitle(item.titles, PreferredLanguages.defaults) ?? ''];
    await _alerts.arrivesToday(titles);
    await _memory.saveAnnounced({...announced, for (final item in arriving) preorderKeyOf(item)});
    return titles;
  }
}
