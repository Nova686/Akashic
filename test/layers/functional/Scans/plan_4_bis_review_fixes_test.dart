import 'package:akashic/layers/functional/Collection/domain/entities/localized_titles.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/series.dart';
import 'package:akashic/layers/functional/Scans/data/gateways/drift_scan_gateway.dart';
import 'package:akashic/layers/functional/Scans/domain/entities/scan_follow.dart';
import 'package:akashic/layers/functional/Scans/domain/entities/scan_progress.dart';
import 'package:akashic/layers/functional/Scans/domain/use_cases/scan_reading.dart';
import 'package:akashic/layers/functional/Scans/presentation/cubit/scan_follow_cubit.dart';
import 'package:akashic/layers/functional/Scans/presentation/cubit/scan_follow_state.dart';
import 'package:akashic/layers/functional/Scans/presentation/widgets/scan_follow_panel.dart';
import 'package:akashic/layers/technical/AppShell/resolved_once.dart';
import 'package:akashic/layers/technical/Localization/app_localizations.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../Collection/collection_harness.dart';

class MockScanFollowCubit extends MockCubit<ScanFollowState> implements ScanFollowCubit {}

Widget inApp(Widget child) => MaterialApp(
      locale: const Locale('fr'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(body: child),
    );

void main() {
  test('unfollowing keeps the chapters already read', () async {
    final harness = CollectionHarness();
    final scans = DriftScanGateway(harness.database);
    final mangas = await harness.mangas();
    await harness.collection.saveSeries(Series(id: 'frieren', categoryId: mangas.id, titles: const LocalizedTitles(byLanguage: {'fr': 'Frieren'})));
    await FollowSeriesInScans(scans)('frieren');
    await MarkReadUpTo(scans)('frieren', 5);
    await scans.unfollow('frieren');
    expect(await scans.watchSeries('frieren').first, isNull);
    await FollowSeriesInScans(scans)('frieren');
    expect((await scans.watchSeries('frieren').first)!.lastRead, 5);
    await harness.database.close();
  });

  testWidgets('a value is resolved once even when its page is rebuilt', (tester) async {
    var resolutions = 0;
    Widget page() => inApp(ResolvedOnce<int>(
          resolve: () async => ++resolutions,
          builder: (context, value) => Text('value $value'),
        ));
    await tester.pumpWidget(page());
    await tester.pump();
    await tester.pumpWidget(page());
    await tester.pump();
    expect(find.text('value 1'), findsOneWidget);
    expect(resolutions, 1);
  });

  testWidgets('the team typed is saved when the field loses focus', (tester) async {
    final cubit = MockScanFollowCubit();
    when(() => cubit.state).thenReturn(const ScanFollowState(isLoading: false, progress: ScanProgress(follow: ScanFollow(seriesId: 'frieren'))));
    when(() => cubit.setTeam(any())).thenAnswer((_) async {});
    await tester.pumpWidget(inApp(BlocProvider<ScanFollowCubit>.value(value: cubit, child: const ScanFollowPanel())));
    await tester.enterText(find.widgetWithText(TextField, 'Équipe de traduction'), 'Kirei Cake');
    FocusManager.instance.primaryFocus?.unfocus();
    await tester.pump();
    verify(() => cubit.setTeam('Kirei Cake')).called(1);
  });

  testWidgets('unfollowing asks for confirmation first', (tester) async {
    final cubit = MockScanFollowCubit();
    when(() => cubit.state).thenReturn(const ScanFollowState(isLoading: false, progress: ScanProgress(follow: ScanFollow(seriesId: 'frieren'))));
    when(() => cubit.unfollow()).thenAnswer((_) async {});
    await tester.pumpWidget(inApp(BlocProvider<ScanFollowCubit>.value(value: cubit, child: const ScanFollowPanel())));
    await tester.scrollUntilVisible(find.text('Ne plus suivre en scans'), 300, scrollable: find.byType(Scrollable).first);
    await tester.tap(find.text('Ne plus suivre en scans'));
    await tester.pumpAndSettle();
    verifyNever(() => cubit.unfollow());
    await tester.tap(find.widgetWithText(FilledButton, 'Ne plus suivre en scans'));
    await tester.pumpAndSettle();
    verify(() => cubit.unfollow()).called(1);
  });
}
