# Akashic

Application Android personnelle pour cataloguer une collection physique : vinyles, livres, BD, mangas, films, jeux vidéo, cartes à collectionner (TCG) et jeux de société.

Sa fonction centrale répond à une question simple, en boutique comme chez soi : **« Je l'ai ? »**. On scanne un code-barres ou on photographie une pochette, et l'appli dit si l'objet est déjà dans la collection, dans une autre édition, ou pas du tout — puis le range au bon endroit d'un tap.

La collection vit dans une base locale sur le téléphone : l'appli fonctionne hors ligne, et les catalogues en ligne ne servent qu'à remplir les fiches.

## Fonctionnalités

- **Je l'ai ?** — caméra plein écran à trois modes : **Code-barres** (lecture en continu, sans appuyer), **Couverture** (une photo, lue par reconnaissance de texte sur l'appareil) et **Étagère** (une photo, jusqu'à 24 tranches reconnues d'un coup, numéros de tome compris). Les résultats s'empilent dans un tiroir : dernier résultat et compteur au repos, liste à mi-hauteur, revue groupée « À ajouter / Déjà dans ta collection / Non trouvés » tout en haut. L'appli choisit seule la sous-catégorie où ranger l'objet (série déjà possédée, sous-catégorie nommée dans le résultat, même auteur, sinon la plus fournie). Les photos sont prises sans bruit d'obturateur, directement dans le flux vidéo. Après une photo d'étagère, la **vue étagère** encadre chaque tranche lue à la couleur de son statut, numérotée et reliée à sa ligne. Chaque session laisse une trace dans l'**historique des scans** (ajoutés, déjà à toi, introuvables).
- **Une fiche = un objet** : achat (prix, date, magasin ou en ligne), état, rangement, prêt et photos sur la fiche ; « J'en ai un autre » ajoute le même objet une fois de plus, depuis la fiche ou depuis le scan.
- **Collection** en catégories et sous-catégories, affichée en couvertures, triée et filtrée (prix payé, rangement, scellé, prêté…), avec séries et un écran des **tomes manquants** qui les met en envies d'un geste. Une **recherche globale** depuis l'accueil fouille toute la collection.
- **Recherche en ligne** dans tous les catalogues adaptés à la catégorie, interrogés en parallèle ; saisie manuelle quand aucun catalogue n'existe, recherche d'images toujours disponible.
- **TCG** : Pokémon, Magic, Yu-Gi-Oh!, Lorcana, Riftbound et One Piece ont leur catalogue, tout autre jeu se saisit à la main. Les decks se composent carte par carte, s'importent depuis Archidekt ou depuis les préconstruits Magic. Les **produits scellés** (ETB, displays, boosters, coffrets, tins…) viennent du catalogue Cardmarket, avec leur cote (tendance, plus bas, moyennes 1, 7 et 30 jours) téléchargée chaque jour en Wi-Fi, ou à la demande avec un avertissement sur la taille en données mobiles.
- **Achats et ventes** : vendre un objet le retire de la collection et le garde dans un historique, avec dépenses, ventes et marge.
- **Comptes liés et imports** : Steam, itch.io, Trakt, AniList, MyAnimeList, Open Library, BoardGameGeek, Rebrickable, Discogs et Playnite (qui regroupe Epic, GOG, Ubisoft Connect, EA, Battle.net, Amazon…), plus les tableurs Goodreads, Letterboxd, Babelio et tout CSV. Les comptes liés se resynchronisent seuls toutes les six heures, avec une barre de progression.
- **Steam** : temps de jeu et étagères triées par dernière partie, succès avec leur rareté, compatibilité Steam Deck, fiche boutique (prix, actualités dans les langues des titres, DLC), tableau de bord et valeur de la bibliothèque, liste de souhaits importée dans les envies, couvertures complétées par SteamGridDB.
- **Envies** et **découvertes** (recommandations tirées de ce que l'on possède déjà), **sorties à venir** des artistes et séries suivis.
- **Suivi des scans** de mangas, avec notification des nouveaux chapitres.
- **Prêts**, **statistiques** (valeur estimée et son évolution mois après mois, plus fortes hausses et baisses, doublons, graphiques), **sauvegarde** sur Google Drive.
- **Thème contrasté** par défaut, désactivable dans les réglages.
- **Ce soir, je…** tire au sort ce qui attend d'être commencé ; **objectifs** annuels en anneaux sur l'accueil ; **récap du mois** et **bilan de l'année** en affiche partageable.
- **Étiquettes** et **étagères intelligentes** (un filtre enregistré devient une étagère), **plan de rangement** pièce › meuble › étagère avec « Où est… ? », **journal** d'activité.
- **Budget** mensuel avec alerte et reste affiché pendant le scan, **inventaire PDF** pour l'assurance, **liste d'envies partageable** en image ou PDF, **priorités** et **prix maximum** des envies.
- **Prêts avec date de retour**, rappel et relance ; **sorties dans l'agenda** du téléphone, au choix par type et par série ou artiste.
- **Tablette** en deux volets, **recherche vocale** dans l'accueil et dans « Je l'ai ? », **mode hors ligne** (vignettes en cache, pastille).
- **Précommandes** avec la section « À recevoir », **fusion des doublons**, **comparaison avec un ami** depuis son export, **valeur des decks**, **tracklists** par face avec durées, **couvertures manquantes** cherchées en lot.
- **Limites d'API** : un blocage pour quota est enregistré, avec un compte à rebours jusqu'à la prochaine tentative possible.
- Interface en français et en anglais, langues des titres réordonnables, animations Lottie maison (figées si le téléphone demande moins d'animations).

## Catalogues utilisés

Toutes les sources sont gratuites. Chaque requête porte un `User-Agent` identifiant l'appli (RFC 1945) et passe par un client qui espace les appels, met les réponses en cache, et refuse localement d'appeler une API bloquée.

Quand une source principale atteint son quota d'appels, est injoignable ou n'a pas de clé configurée, sa source de secours prend le relais ; la source de secours n'est jamais appelée quand la principale répond.

| Catégorie | Source | Clé nécessaire |
|---|---|---|
| Musique | [Discogs](https://www.discogs.com/developers) | jeton personnel |
| Musique | [MusicBrainz](https://musicbrainz.org/doc/MusicBrainz_API) + [Cover Art Archive](https://coverartarchive.org) | non |
| Livres, BD | [Google Books](https://developers.google.com/books) | clé d'API |
| Livres, BD | [Open Library](https://openlibrary.org/developers/api) | non |
| Comics américains | [Comic Vine](https://comicvine.gamespot.com/api/) (usage non commercial, 200 requêtes par heure) | clé d'API |
| Secours ISBN | [Catalogue général de la BnF](https://catalogue.bnf.fr/api) (Licence Ouverte) | non |
| Mangas | [AniList](https://docs.anilist.co), et Google Books pour les ISBN | non |
| Mangas | [Jikan](https://jikan.moe) (MyAnimeList) | non |
| Scans de mangas | [MangaUpdates](https://api.mangaupdates.com) | non |
| Films | [TMDB](https://developer.themoviedb.org) | clé d'API |
| Séries TV | [TVmaze](https://www.tvmaze.com/api) (CC BY-SA) | non |
| Codes-barres de produits (recours DVD, Blu-ray, jeux) | [UPCitemdb](https://www.upcitemdb.com/wp/docs/main/development/) — 100 requêtes par jour | non |
| Jeux vidéo, consoles | [IGDB](https://api-docs.igdb.com) (via Twitch) | identifiant + secret |
| LEGO | [Rebrickable](https://rebrickable.com/api/) | clé d'API gratuite |
| amiibo | [AmiiboAPI](https://www.amiiboapi.com) | non |
| Jeux de société | [BoardGameGeek](https://boardgamegeek.com/using_the_xml_api) (usage non commercial) | application enregistrée + jeton |
| Pokémon | [TCGdex](https://tcgdex.dev) | non |
| Magic | [Scryfall](https://scryfall.com/docs/api) | non |
| Decks Magic préconstruits | [MTGJSON](https://mtgjson.com) | non |
| Yu-Gi-Oh! | [YGOPRODeck](https://ygoprodeck.com/api-guide/) | non |
| Lorcana | [Lorcast](https://lorcast.com/docs/api) | non |
| Riftbound | [Riftcodex](https://riftcodex.com) (projet de fans, non affilié à Riot) | non |
| One Piece | [OPTCG API](https://optcgapi.com) (projet de fans, non affilié à Bandai ; prix TCGplayer en dollars) | non |
| Produits scellés TCG et leur cote | [Cardmarket](https://www.cardmarket.com) — fichiers publics du catalogue et du guide des prix | non |
| Decks à importer | [Archidekt](https://archidekt.com) | non |
| Jeux Steam, succès, boutique, liste de souhaits | [Steam Web API](https://steamcommunity.com/dev) et API de la boutique | clé d'API |
| Couvertures de jeux | [SteamGridDB](https://www.steamgriddb.com/api/v2) | clé d'API |
| Import films et séries vus | [Trakt](https://trakt.docs.apiary.io) | Client ID |
| Import mangas et animes | [MyAnimeList](https://myanimelist.net/apiconfig/references/api/v2) | Client ID |
| Import mangas et animes | [AniList](https://docs.anilist.co) | non |
| Import jeux itch.io | [itch.io](https://itch.io/docs/api/serverside) | clé personnelle saisie dans l'appli |
| Images | [Wikimedia Commons](https://commons.wikimedia.org) | non |
| Secours musique (quota Discogs atteint) | [Deezer](https://developers.deezer.com/api) — titre, artiste, label, pochette | non |
| Sorties d'albums des artistes de la collection | [Deezer](https://developers.deezer.com/api) | non |
| Secours mangas (quota AniList atteint) | [MangaDex](https://api.mangadex.org/docs/) — titres, auteurs, couverture | non |
| Secours films, jeux vidéo, jeux de société | [Wikidata](https://www.wikidata.org/wiki/Wikidata:Data_access) (CC0) — titre et année seulement | non |

Une source sans clé configurée est simplement ignorée : l'appli reste utilisable.

*This product uses the TMDB API but is not endorsed or certified by TMDB.*

## Prérequis

- Flutter 3.47 (Dart 3.13) ou plus récent
- JDK 21 et le SDK Android
- Un téléphone Android ; Android 12 ou plus pour afficher les images AVIF de Lorcast

## Configuration des clés

Les clés ne sont jamais versionnées (`dart_defines.json` est ignoré par git). Copier le modèle puis le remplir :

```bash
cp dart_defines.example.json dart_defines.json
```

| Variable | Où l'obtenir |
|---|---|
| `DISCOGS_TOKEN` | Discogs → Settings → Developers → *Generate new token* |
| `TMDB_API_KEY` | themoviedb.org → Paramètres → API |
| `GOOGLE_BOOKS_API_KEY` | Google Cloud Console → activer *Books API* → Identifiants → clé d'API |
| `GOOGLE_SERVER_CLIENT_ID` | Google Cloud Console → Identifiants → ID client OAuth de type **Application Web**, pour la sauvegarde Drive ; un ID client **Android** avec l'empreinte SHA-1 de l'APK doit aussi exister dans le même projet |
| `IGDB_CLIENT_ID`, `IGDB_CLIENT_SECRET` | dev.twitch.tv → Console → *Register your application* |
| `API_CONTACT` | facultatif : un contact ajouté au `User-Agent` |
| `BGG_TOKEN` | boardgamegeek.com → créer un compte → [Applications](https://boardgamegeek.com/applications) → enregistrer l'application (validation manuelle par BGG, parfois plus d'une semaine) → créer un jeton |
| `COMIC_VINE_API_KEY` | comicvine.gamespot.com → créer un compte → [page API](https://comicvine.gamespot.com/api/) → la clé s'affiche une fois connecté |
| `REBRICKABLE_API_KEY` | rebrickable.com → créer un compte → Settings → API → *Generate new API key* |
| `STEAM_API_KEY` | [steamcommunity.com/dev/apikey](https://steamcommunity.com/dev/apikey) → saisir un nom de domaine quelconque → la clé s'affiche. Le profil Steam et sa liste de souhaits doivent être publics. |
| `STEAMGRIDDB_API_KEY` | steamgriddb.com → se connecter → Preferences → API → *Generate API Key* |
| `TRAKT_CLIENT_ID` | trakt.tv → Settings → Your API Apps → *New Application* (redirect URI : `urn:ietf:wg:oauth:2.0:oob`) → Client ID |
| `MAL_CLIENT_ID` | myanimelist.net → Account Settings → API → *Create ID* → Client ID |
| `DRIVE_BACKUP_FOLDER` | facultatif : lien ou identifiant d'un dossier Google Drive où ranger les sauvegardes. L'appli demande alors l'accès complet à Drive (portée restreinte, acceptée pour les utilisateurs de test) et ne liste ni ne supprime que les archives `akashic-*.zip` de ce dossier. Sans lui, les sauvegardes vont dans l'espace caché réservé à l'appli. |

## Lancer et construire

```bash
flutter pub get
flutter run --dart-define-from-file=dart_defines.json
```

APK de mise au point :

```bash
flutter build apk --debug --dart-define-from-file=dart_defines.json
```

APK optimisé (un fichier par architecture, code obscurci, ressources réduites) :

```bash
flutter build apk --release --split-per-abi --target-platform android-arm,android-arm64 --obfuscate \
  --split-debug-info=build/debug-symbols \
  --dart-define-from-file=dart_defines.json
```

Le fichier à installer sur un téléphone récent est `build/app/outputs/flutter-apk/app-arm64-v8a-release.apk` (environ 26 Mo).

### Versions et releases

Le dépôt public `Nova686/Akashic` est recopié dans le dépôt privé `Nova686/akashic-history` (`tool/sync_history.sh`, un commit par recopie, l'ancien historique reste intact) ; la CI ne tourne que sur Akashic : analyse et tests sur chaque PR, puis à chaque fusion sur `main` recopie dans `akashic-history` et, si la version est nouvelle, build signé et release dans `akashic-history` (secrets `KEYSTORE_BASE64`, `KEYSTORE_PASSWORD`, `DART_DEFINES_JSON`, `HISTORY_TOKEN`). Sans GitHub Actions, la même chose se fait depuis le poste de développement avec `tool/sync_history.sh` et `tool/publish_release.sh` ; les releases sont publiées dans `Nova686/akashic-history`, seulement quand la version de `pubspec.yaml` n'a pas encore de tag (`v1.1.0`, titre « Akashic 1.1.0 ») ; le script lance l'analyse et les tests, construit les APK signés, pose le tag et génère les notes à partir des PR : une PR qui ne relève pas la version (documentation, CI, tests) ne publie rien. Pour un changement visible dans l'appli, relever le chiffre du milieu pour une nouvelle fonctionnalité (`1.1.0` → `1.2.0`), le dernier pour une correction (`1.1.0` → `1.1.1`), et le `defaultValue` de `lib/layers/technical/AppShell/app_version.dart`. Le numéro de build Android (`versionCode`), qui doit croître pour qu'une mise à jour s'installe par-dessus l'ancienne, est calculé à part à partir du nombre de commits (plus 1000, pour rester au-dessus des versions publiées avant ce dépôt) et n'apparaît pas dans le nom de la release.

## Tests et qualité

```bash
flutter analyze
flutter test
```

Après une modification des textes, régénérer les traductions avec `flutter gen-l10n` ; après une modification du schéma de la base, `dart run build_runner build`.

## Architecture

Le code est organisé en couches (OSDD) : chaque domaine fonctionnel possède ses couches `domain`, `data` et `presentation`, et les briques transverses vivent dans des couches techniques.

```
lib/layers/
├── functional/   Backup, Catalog, Check, Collection, Details, Discoveries, Import,
│                 Loans, Lookup, Releases, Scans, SealedPrices, Settings, SourceLimits,
│                 Stats, Steam, Trades, Wishes
└── technical/    AppShell, Feedback, HttpAccess, LocalDatabase, Localization, MediaStorage,
                  Theme, Tour
```

- État : `flutter_bloc` (Cubit)
- Base locale : Drift (SQLite)
- Navigation : `go_router`
- Caméra : `camera` pour le scan et les photos (images tirées du flux vidéo, donc sans bruit d'obturateur), ML Kit pour les codes-barres et la lecture de texte, `mobile_scanner` pour le lecteur de code-barres de l'éditeur
- Réseau : `connectivity_plus` pour reconnaître les données mobiles avant un gros téléchargement
- Traductions : fichiers ARB dans `lib/layers/technical/Localization/arb/`
- Animations : fichiers Lottie créés pour l'appli dans `assets/animations/`

## Licence

Projet personnel, sans licence publique pour l'instant. Les données récupérées restent soumises aux conditions de chaque source.
