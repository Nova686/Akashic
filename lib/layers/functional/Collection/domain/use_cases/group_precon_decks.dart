import 'package:akashic/layers/functional/Collection/domain/entities/card_kind.dart';
import 'package:akashic/layers/functional/Collection/domain/gateways/collection_gateway.dart';
import 'package:akashic/layers/functional/Collection/domain/use_cases/precon_deck_library.dart';
import 'package:akashic/layers/functional/Lookup/domain/entities/precon_deck.dart';
import 'package:akashic/layers/functional/Lookup/domain/gateways/precon_deck_catalogue.dart';
import 'package:akashic/layers/functional/Settings/domain/gateways/settings_gateway.dart';

class GroupPreconDecks {
  GroupPreconDecks(this._collection, this._catalogue, this._groupOf, {this._settings, DateTime Function()? now}) : _now = now ?? DateTime.now;

  static const Duration retryAfter = Duration(days: 7);

  final CollectionGateway _collection;
  final PreconDeckCatalogue _catalogue;
  final String Function(PreconDeck deck) _groupOf;
  final SettingsGateway? _settings;
  final DateTime Function() _now;

  Future<int> call() async {
    final ungrouped = [
      for (final item in await _collection.allItems())
        if (item.cardKind == CardKind.deck && PreconDeckLibrary.isPrecon(item.sourceKey) && item.groupKey == null && item.externalWorkId != null) item,
    ];
    if (ungrouped.isEmpty) {
      return 0;
    }
    final settings = _settings;
    final now = _now();
    if (await settings?.lastPreconGroupingAt() case final lastAttempt? when now.difference(lastAttempt) < retryAfter) {
      return 0;
    }
    await settings?.savePreconGroupingAt(now);
    final decksById = {for (final deck in await _catalogue.decks()) deck.id: deck};
    var grouped = 0;
    for (final item in ungrouped) {
      if (decksById[item.externalWorkId] case final deck?) {
        await _collection.setGroupKey(item.id, _groupOf(deck));
        grouped++;
      }
    }
    return grouped;
  }
}
