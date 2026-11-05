import 'package:akashic/layers/functional/Collection/domain/entities/collection_item.dart';
import 'package:akashic/layers/functional/Details/domain/entities/item_details.dart';
import 'package:akashic/layers/functional/Details/domain/gateways/details_source.dart';
import 'package:akashic/layers/functional/Details/domain/gateways/details_store.dart';
import 'package:akashic/layers/functional/Lookup/domain/entities/source_unavailable.dart';

class DetailsUnavailable implements Exception {
  const DetailsUnavailable();
}

class FetchItemDetails {
  FetchItemDetails(this._sources, this._store, {DateTime Function()? now}) : _now = now ?? DateTime.now;

  final List<DetailsSource> _sources;
  final DetailsStore _store;
  final DateTime Function() _now;

  Future<ItemDetails?> cached(String itemId) => _store.read(itemId);

  bool canDescribe(CollectionItem item) => _sources.any((source) => source.supports(item));

  Future<(List<DetailSection>, int)> _collect(CollectionItem item, {required String languageCode, String? editionId}) async {
    final supporting = _sources.where((source) => source.supports(item)).toList();
    final sections = <DetailSection>[];
    var failures = 0;
    for (final source in supporting) {
      try {
        sections.addAll((await source.fetch(item, languageCode: languageCode, editionId: editionId)).where((section) => !section.isEmpty));
      } on SourceUnavailable {
        failures++;
      }
    }
    if (supporting.isEmpty || failures == supporting.length) {
      throw const DetailsUnavailable();
    }
    return (sections, failures);
  }

  Future<ItemDetails> preview(CollectionItem item, {required String languageCode}) async {
    final (sections, _) = await _collect(item, languageCode: languageCode);
    return ItemDetails(sections: sections, fetchedAt: _now());
  }

  Future<ItemDetails> refresh(CollectionItem item, {required String languageCode, String? editionId}) async {
    final (sections, failures) = await _collect(item, languageCode: languageCode, editionId: editionId);
    if (failures > 0 && await _store.read(item.id) != null) {
      throw const DetailsUnavailable();
    }
    final details = ItemDetails(sections: sections, fetchedAt: _now());
    await _store.write(item.id, details);
    return details;
  }
}
