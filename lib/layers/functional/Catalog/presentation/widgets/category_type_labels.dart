import 'package:flutter/material.dart';
import 'package:akashic/layers/functional/Catalog/domain/entities/category_type.dart';
import 'package:akashic/layers/technical/Localization/app_localizations.dart';

extension CategoryTypeLabel on CategoryType {
  String label(AppLocalizations l10n) => switch (this) {
        CategoryType.music => l10n.categoryTypeMusic,
        CategoryType.books => l10n.categoryTypeBooks,
        CategoryType.manga => l10n.categoryTypeManga,
        CategoryType.comics => l10n.categoryTypeComics,
        CategoryType.films => l10n.categoryTypeFilms,
        CategoryType.videoGames => l10n.categoryTypeVideoGames,
        CategoryType.cards => l10n.categoryTypeCards,
        CategoryType.boardGames => l10n.categoryTypeBoardGames,
        CategoryType.lego => l10n.categoryTypeLego,
        CategoryType.amiibo => l10n.categoryTypeAmiibo,
        CategoryType.consoles => l10n.categoryTypeConsoles,
        CategoryType.free => l10n.categoryTypeFree,
      };
}

extension ConditionPartKindLabel on ConditionPartKind {
  String label(AppLocalizations l10n) => switch (this) {
        ConditionPartKind.disc => l10n.partDisc,
        ConditionPartKind.sleeve => l10n.partSleeve,
        ConditionPartKind.game => l10n.partGame,
        ConditionPartKind.box => l10n.partBox,
        ConditionPartKind.manual => l10n.partManual,
        ConditionPartKind.components => l10n.partComponents,
        ConditionPartKind.item => l10n.partItem,
      };
}

const Map<String, String> sourceDisplayNames = {
  'discogs': 'Discogs',
  'googlebooks': 'Google Books',
  'anilist': 'AniList',
  'tmdb': 'TMDB',
  'igdb': 'IGDB',
  'tcgdex': 'TCGdex',
  'mangaupdates': 'MangaUpdates',
  'bnf': 'BnF',
  'scryfall': 'Scryfall',
  'ygoprodeck': 'YGOPRODeck',
  'lorcast': 'Lorcast',
  'riftcodex': 'Riftcodex',
  'musicbrainz': 'MusicBrainz',
  'openlibrary': 'Open Library',
  'jikan': 'Jikan (MyAnimeList)',
  'tvmaze': 'TVmaze',
  'upcitemdb': 'UPCitemdb',
  'boardgamegeek': 'BoardGameGeek',
  'rebrickable': 'Rebrickable',
  'amiiboapi': 'AmiiboAPI',
  'comicvine': 'Comic Vine',
};

extension CategoryTypeIcon on CategoryType {
  IconData get icon => switch (this) {
        CategoryType.music => Icons.album_outlined,
        CategoryType.books => Icons.menu_book_outlined,
        CategoryType.manga => Icons.auto_stories_outlined,
        CategoryType.comics => Icons.chrome_reader_mode_outlined,
        CategoryType.films => Icons.movie_outlined,
        CategoryType.videoGames => Icons.sports_esports_outlined,
        CategoryType.cards => Icons.style_outlined,
        CategoryType.boardGames => Icons.casino_outlined,
        CategoryType.lego => Icons.extension_outlined,
        CategoryType.amiibo => Icons.emoji_people_outlined,
        CategoryType.consoles => Icons.videogame_asset_outlined,
        CategoryType.free => Icons.category_outlined,
      };
}
