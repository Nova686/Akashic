import 'dart:convert';
import 'dart:io';

import 'package:akashic/layers/functional/Steam/data/sources/steam_player_client.dart';
import 'package:akashic/layers/functional/Steam/domain/entities/steam_achievement.dart';
import 'package:akashic/layers/functional/Steam/domain/use_cases/load_steam_achievements.dart';
import 'package:akashic/layers/functional/Steam/presentation/widgets/steam_achievements_tab.dart';
import 'package:akashic/layers/technical/Localization/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:intl/date_symbol_data_local.dart';

http.Response fixture(String name) => http.Response.bytes(File('test/fixtures/$name').readAsBytesSync(), 200, headers: {'content-type': 'application/json; charset=utf-8'});

SteamAchievement achievement(String name, {double? percent, DateTime? unlockedAt, bool isHidden = false}) =>
    SteamAchievement(apiName: name, name: name, description: 'Description de $name', globalPercent: percent, unlockedAt: unlockedAt, isHidden: isHidden);

void main() {
  setUpAll(() => initializeDateFormatting('fr'));

  test('rarity tiers follow the share of players who unlocked the achievement', () {
    expect(rarityOf(0.9), AchievementRarity.legendary);
    expect(rarityOf(4.2), AchievementRarity.epic);
    expect(rarityOf(13.3), AchievementRarity.rare);
    expect(rarityOf(20), AchievementRarity.common);
    expect(rarityOf(null), AchievementRarity.common);
  });

  test('all achievements list the ones to unlock first, each group sorted by the chosen criterion', () {
    final list = [
      achievement('Facile obtenu', percent: 80, unlockedAt: DateTime(2026, 10, 1)),
      achievement('Rare à faire', percent: 3),
      achievement('Courant à faire', percent: 60),
      achievement('Légendaire obtenu', percent: 0.5, unlockedAt: DateTime(2026, 10, 20)),
    ];
    expect(arrangeAchievements(list, filter: AchievementFilter.all, sort: AchievementSort.rarity).map((entry) => entry.name), ['Rare à faire', 'Courant à faire', 'Légendaire obtenu', 'Facile obtenu']);
    expect(arrangeAchievements(list, filter: AchievementFilter.unlocked, sort: AchievementSort.date).map((entry) => entry.name), ['Légendaire obtenu', 'Facile obtenu']);
    expect(arrangeAchievements(list, filter: AchievementFilter.rare, sort: AchievementSort.name).map((entry) => entry.name), ['Légendaire obtenu', 'Rare à faire']);
  });

  test('achievements combine the french schema, the player unlocks and the global rarity', () async {
    final client = SteamPlayerClient(
      MockClient((request) async => switch (request.url.path) {
            '/ISteamUserStats/GetSchemaForGame/v2/' => fixture('steam_schema_hades.json'),
            '/ISteamUserStats/GetGlobalAchievementPercentagesForApp/v0002/' => fixture('steam_global_hades.json'),
            _ => http.Response.bytes(
                utf8.encode(jsonEncode({
                  'playerstats': {
                    'success': true,
                    'achievements': [
                      {'apiname': 'AchClearTartarus', 'achieved': 1, 'unlocktime': 1700000000},
                      {'apiname': 'AchClearElysiumEM', 'achieved': 0, 'unlocktime': 0},
                    ],
                  },
                })),
                200,
                headers: {'content-type': 'application/json'},
              ),
          }),
      MockClient((request) async => http.Response('', 404)),
      apiKey: 'key',
    );
    final achievements = await client.achievements('7656', '1145360');
    expect(achievements, hasLength(6));
    final tartarus = achievements.firstWhere((entry) => entry.apiName == 'AchClearTartarus');
    expect((tartarus.name, tartarus.globalPercent, tartarus.isUnlocked), ('Échappé du Tartare', 81.8, true));
    expect(tartarus.iconUrl, startsWith('https://'));
    final champion = achievements.firstWhere((entry) => entry.apiName == 'AchClearElysiumEM');
    expect((champion.isUnlocked, champion.rarity), (false, AchievementRarity.rare));
  });

  test('achievements need a linked steam account', () async {
    final load = LoadSteamAchievements(
      SteamPlayerClient(MockClient((request) async => http.Response('', 404)), MockClient((request) async => http.Response('', 404)), apiKey: 'key'),
      () async => null,
    );
    expect(load('1145360'), throwsA(isA<SteamAccountMissing>()));
  });

  testWidgets('the achievements tab shows the progress, the locked ones first and filters by state', (tester) async {
    await tester.binding.setSurfaceSize(const Size(500, 2000));
    await tester.pumpWidget(MaterialApp(
      locale: const Locale('fr'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(
        body: SingleChildScrollView(
          child: SteamAchievementsTab(
            load: () async => [
              achievement('La Marche du Styx', percent: 0.9, unlockedAt: DateTime(2026, 10, 28)),
              achievement('Ami des ombres', percent: 62),
              achievement('Secret', percent: 30, isHidden: true),
            ],
          ),
        ),
      ),
    ));
    await tester.pumpAndSettle();
    expect(find.text('1 / 3', findRichText: true), findsOneWidget);
    expect(find.text('33 %'), findsOneWidget);
    expect(find.text('2 restants'), findsOneWidget);
    expect(find.text('Succès caché'), findsOneWidget);
    expect(find.text('★ Légendaire'), findsOneWidget);
    expect(tester.getTopLeft(find.text('Ami des ombres')).dy, lessThan(tester.getTopLeft(find.text('La Marche du Styx')).dy));
    await tester.tap(find.text('Débloqués'));
    await tester.pumpAndSettle();
    expect(find.text('Ami des ombres'), findsNothing);
    expect(find.text('La Marche du Styx'), findsOneWidget);
    await tester.binding.setSurfaceSize(null);
  });
}
