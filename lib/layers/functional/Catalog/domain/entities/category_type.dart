import 'package:akashic/layers/functional/Catalog/domain/entities/item_field.dart';

enum ConditionPartKind { disc, sleeve, game, box, manual, components, item }

enum CategoryType {
  music,
  books,
  manga,
  comics,
  films,
  videoGames,
  cards,
  boardGames,
  lego,
  amiibo,
  consoles,
  free;

  List<ConditionPartKind> get defaultConditionParts => switch (this) {
        CategoryType.music => const [ConditionPartKind.disc, ConditionPartKind.sleeve],
        CategoryType.videoGames => const [ConditionPartKind.game, ConditionPartKind.box, ConditionPartKind.manual],
        CategoryType.boardGames => const [ConditionPartKind.box, ConditionPartKind.components],
        CategoryType.lego => const [ConditionPartKind.box, ConditionPartKind.components, ConditionPartKind.manual],
        CategoryType.amiibo => const [ConditionPartKind.item, ConditionPartKind.box],
        CategoryType.consoles => const [ConditionPartKind.item, ConditionPartKind.box, ConditionPartKind.manual],
        _ => const [ConditionPartKind.item],
      };

  List<ItemField> get itemFields => switch (this) {
        CategoryType.music => const [ItemField.creator, ItemField.year, ItemField.publisher],
        CategoryType.books || CategoryType.manga || CategoryType.comics => const [ItemField.creator, ItemField.year, ItemField.publisher, ItemField.series],
        CategoryType.films => const [ItemField.creator, ItemField.year],
        CategoryType.videoGames => const [ItemField.creator, ItemField.year, ItemField.platform],
        CategoryType.cards => const [ItemField.year, ItemField.publisher],
        CategoryType.boardGames => const [ItemField.creator, ItemField.year, ItemField.publisher],
        CategoryType.lego => const [ItemField.creator, ItemField.year],
        CategoryType.amiibo => const [ItemField.creator, ItemField.year],
        CategoryType.consoles => const [ItemField.creator, ItemField.year],
        CategoryType.free => const [ItemField.creator, ItemField.year],
      };
}
