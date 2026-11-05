import 'package:akashic/layers/functional/SourceLimits/data/gateways/drift_source_block_gateway.dart';
import 'package:akashic/layers/functional/SourceLimits/domain/entities/source_block.dart';
import 'package:akashic/layers/functional/SourceLimits/presentation/widgets/source_block_labels.dart';
import 'package:akashic/layers/functional/SourceLimits/presentation/widgets/source_blocks_view.dart';
import 'package:akashic/layers/technical/Localization/app_localizations.dart';
import 'package:akashic/layers/technical/LocalDatabase/akashic_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final now = DateTime(2026, 10, 28, 14, 30);

  test('a recorded block survives a restart and expired ones are forgotten', () async {
    final database = AkashicDatabase.forTesting();
    var clock = now;
    final blocks = DriftSourceBlockGateway(database, now: () => clock);
    await blocks.recordBlock('discogs', blockedAt: now, retryAt: now.add(const Duration(minutes: 1)));
    await blocks.recordBlock('googlebooks', blockedAt: now, retryAt: now.add(const Duration(hours: 9)));
    await blocks.recordBlock('discogs', blockedAt: now, retryAt: now.add(const Duration(seconds: 10)));
    expect(blocks.blockedUntil('discogs'), now.add(const Duration(minutes: 1)));
    clock = now.add(const Duration(minutes: 5));
    final restarted = DriftSourceBlockGateway(database, now: () => clock);
    await restarted.load();
    expect(restarted.blockedUntil('discogs'), isNull);
    expect(restarted.blockedUntil('googlebooks'), now.add(const Duration(hours: 9)));
    expect((await restarted.watchBlocks().first).map((block) => block.apiFamily), ['googlebooks']);
    await database.close();
  });

  test('remaining time reads as minutes and seconds, or hours when long', () {
    expect(formatRemaining(const Duration(seconds: 42)), '00:42');
    expect(formatRemaining(const Duration(minutes: 4, seconds: 5)), '04:05');
    expect(formatRemaining(const Duration(hours: 9, minutes: 3, seconds: 7)), '9:03:07');
    expect(SourceBlock(apiFamily: 'tmdb', blockedAt: now, retryAt: now).isActiveAt(now), isFalse);
  });

  testWidgets('the banner counts down to the next connection and the list tells when the limit was reached', (tester) async {
    final database = AkashicDatabase.forTesting();
    final blocks = DriftSourceBlockGateway(database, now: () => now);
    await tester.runAsync(() => blocks.recordBlock('discogs', blockedAt: now.subtract(const Duration(seconds: 18)), retryAt: now.add(const Duration(seconds: 42))));
    await tester.pumpWidget(MaterialApp(
      locale: const Locale('fr'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(
        body: SourceBlocksList(blocks: blocks, now: () => now),
        bottomNavigationBar: SourceBlocksBanner(blocks: blocks, now: () => now),
      ),
    ));
    await tester.pump();
    expect(find.text('Discogs : de nouveau disponible dans 00:42'), findsOneWidget);
    expect(find.text('Limite atteinte à 14:29 · prochaine connexion à 14:30'), findsOneWidget);
    expect(find.text('00:42'), findsOneWidget);
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.runAsync(database.close);
  });
}
