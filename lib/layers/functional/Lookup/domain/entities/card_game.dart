import 'package:akashic/layers/functional/Collection/domain/use_cases/search_text_normalizer.dart';

enum CardGame {
  pokemon(displayName: 'Pokémon', sourceKey: 'tcgdex', aliases: ['pokemon', 'ptcg']),
  magic(displayName: 'Magic', sourceKey: 'scryfall', aliases: ['magic', 'mtg']),
  yugioh(displayName: 'Yu-Gi-Oh!', sourceKey: 'ygoprodeck', aliases: ['yu-gi-oh', 'yu gi oh', 'yugioh', 'ygo']),
  lorcana(displayName: 'Lorcana', sourceKey: 'lorcast', aliases: ['lorcana']),
  riftbound(displayName: 'Riftbound', sourceKey: 'riftcodex', aliases: ['riftbound']),
  onePiece(displayName: 'One Piece', sourceKey: 'optcg', aliases: ['one piece', 'onepiece', 'optcg']);

  const CardGame({required this.displayName, required this.sourceKey, required this.aliases});

  final String displayName;
  final String sourceKey;
  final List<String> aliases;
}

CardGame? cardGameNamed(String categoryName) {
  final spacedName = ' ${normalizeForSearch(categoryName).replaceAll(RegExp(r'[^\p{L}\p{N}-]+', unicode: true), ' ').trim()} ';
  for (final game in CardGame.values) {
    if (game.aliases.any((alias) => spacedName.contains(' $alias '))) {
      return game;
    }
  }
  return null;
}
