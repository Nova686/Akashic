import 'package:akashic/layers/functional/Collection/domain/entities/collection_item.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/item_progress.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/localized_titles.dart';
import 'package:akashic/layers/functional/Steam/domain/use_cases/compute_steam_collection_stats.dart';
import 'package:akashic/layers/functional/Steam/presentation/widgets/steam_stats_section.dart';
import 'package:akashic/layers/functional/Steam/domain/entities/steam_achievement.dart';
import 'package:akashic/layers/functional/Steam/domain/entities/steam_game_stats.dart';
import 'package:akashic/layers/functional/Steam/presentation/widgets/steam_dashboard.dart';
import 'package:akashic/layers/technical/Localization/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() {
  setUpAll(() => initializeDateFormatting('fr'));

  test('playtime reads in hours once past an hour, with minutes under ten hours', () {
    expect(playtimeLabel(45), '45 min');
    expect(playtimeLabel(380), '6 h 20');
    expect(playtimeLabel(120), '2 h');
    expect(playtimeLabel(7620), '127 h');
  });

  testWidgets('the steam dashboard shows playtime, achievements, the rarest one, status, deck and copy', (tester) async {
    await tester.binding.setSurfaceSize(const Size(420, 1400));
    final statuses = <ProgressStatus>[];
    var openedAchievements = 0;
    await tester.pumpWidget(MaterialApp(
      locale: const Locale('fr'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(
        body: SingleChildScrollView(
          child: SteamDashboard(
            stats: SteamGameStats(
              itemId: 'hades',
              appId: '1145360',
              playtimeMinutes: 7620,
              recentMinutes: 380,
              lastPlayedAt: DateTime.utc(2026, 10, 29, 22, 14),
              achievements: const AchievementProgress(unlocked: 34, total: 49),
              deckStatus: SteamDeckStatus.verified,
              autoProgressStatus: 'inProgress',
              syncedAt: DateTime.utc(2026, 10, 30, 9),
            ),
            loadAchievements: () async => [
              SteamAchievement(apiName: 'styx', name: 'La Marche du Styx', globalPercent: 0.9, unlockedAt: DateTime.utc(2026, 10, 25)),
              SteamAchievement(apiName: 'tartarus', name: 'Échappé du Tartare', globalPercent: 81.8, unlockedAt: DateTime.utc(2021, 12, 20)),
              const SteamAchievement(apiName: 'secret', name: 'Ultime', globalPercent: 0.4),
            ],
            status: ProgressStatus.inProgress,
            onStatusChanged: statuses.add,
            onOpenAchievements: () => openedAchievements++,
            copy: SteamCopySummary(platform: 'Steam · PC', pricePaidCents: 2499, addedAt: DateTime(2021, 12, 12)),
          ),
        ),
      ),
    ));
    await tester.pumpAndSettle();
    expect(find.text('127 h', findRichText: true), findsOneWidget);
    expect(find.textContaining('6 h 20 ces 14 derniers jours'), findsOneWidget);
    expect(find.text('34 / 49', findRichText: true), findsOneWidget);
    expect(find.text('15 restants, dont 1 légendaire'), findsOneWidget);
    expect(find.text('La Marche du Styx'), findsOneWidget);
    expect(find.text('★ Légendaire'), findsOneWidget);
    expect(find.text('auto · Steam'), findsOneWidget);
    expect(find.text('Vérifié'), findsOneWidget);
    expect(find.text('Steam · PC'), findsOneWidget);
    expect(find.textContaining('24,99'), findsOneWidget);
    await tester.tap(find.text('En cours'));
    expect(statuses, [ProgressStatus.finished]);
    await tester.tap(find.text('34 / 49', findRichText: true));
    expect(openedAchievements, 1);
    await tester.binding.setSurfaceSize(null);
  });

  testWidgets('the game stats section shows playtime, completion, the pile of shame, the top played and the library value', (tester) async {
    await tester.binding.setSurfaceSize(const Size(420, 1600));
    const hades = CollectionItem(id: 'hades', categoryId: 'games', titles: LocalizedTitles(byLanguage: {'en': 'Hades'}));
    const halfLife = CollectionItem(id: 'hl', categoryId: 'games', titles: LocalizedTitles(byLanguage: {'en': 'Half-Life'}));
    final opened = <String>[];
    await tester.pumpWidget(MaterialApp(
      locale: const Locale('fr'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(
        body: SingleChildScrollView(
          child: SteamStatsSection(
            stats: SteamCollectionStats(
              gameCount: 2,
              totalMinutes: 7620,
              neverPlayed: const [halfLife],
              topPlayed: const [PlayedGame(hades, 7620)],
              averageCompletion: 0.69,
              libraryValue: const {'EUR': 1962},
              pricedAt: DateTime.utc(2026, 10, 30),
            ),
            onOpenItem: opened.add,
          ),
        ),
      ),
    ));
    expect(find.text('Jeux vidéo'), findsOneWidget);
    expect(find.text('127 h'), findsWidgets);
    expect(find.text('69 %'), findsOneWidget);
    expect(find.text('1 jeu jamais lancé'), findsOneWidget);
    expect(find.text('Hades'), findsOneWidget);
    expect(find.textContaining('19,62'), findsOneWidget);
    expect(find.textContaining('pas une valeur de revente'), findsOneWidget);
    await tester.tap(find.text('Hades'));
    expect(opened, ['hades']);
    await tester.binding.setSurfaceSize(null);
  });

  testWidgets('a long pile of shame shows the covers that fit and counts the rest, without overflowing', (tester) async {
    await tester.binding.setSurfaceSize(const Size(360, 900));
    await tester.pumpWidget(MaterialApp(
      locale: const Locale('fr'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 18),
          child: SteamStatsSection(
            stats: SteamCollectionStats(
              gameCount: 48,
              totalMinutes: 0,
              neverPlayed: [for (var index = 0; index < 48; index++) CollectionItem(id: 'game-$index', categoryId: 'games', titles: LocalizedTitles(byLanguage: {'en': 'Game $index'}))],
              topPlayed: const [],
              libraryValue: const {},
            ),
          ),
        ),
      ),
    ));
    expect(tester.takeException(), isNull);
    expect(find.textContaining(RegExp(r'^\+\d+$')), findsOneWidget);
    await tester.binding.setSurfaceSize(null);
  });
}

