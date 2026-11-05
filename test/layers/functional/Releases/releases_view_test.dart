import 'package:akashic/layers/functional/Releases/domain/entities/upcoming_release.dart';
import 'package:akashic/layers/functional/Releases/presentation/cubit/releases_cubit.dart';
import 'package:akashic/layers/functional/Releases/presentation/views/releases_view.dart';
import 'package:akashic/layers/technical/Localization/app_localizations.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';

class MockReleasesCubit extends MockCubit<ReleasesState> implements ReleasesCubit {}

Widget releasesApp(ReleasesCubit cubit) => MaterialApp(
      locale: const Locale('fr'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: BlocProvider<ReleasesCubit>.value(value: cubit, child: const ReleasesView()),
    );

void main() {
  setUpAll(() => initializeDateFormatting('fr'));

  testWidgets('releases are listed under their month with what they belong to', (tester) async {
    final cubit = MockReleasesCubit();
    whenListen(
      cubit,
      const Stream<ReleasesState>.empty(),
      initialState: ReleasesState(
        isLoading: false,
        outlook: ReleaseOutlook(
          computedAt: DateTime(2026, 10, 28),
          followedSubjects: 2,
          releases: [
            UpcomingRelease(sourceKey: 'tcgdex', externalId: 'set:me06', kind: ReleaseKind.cardSet, subject: 'Pokémon', title: 'Next Wave', releaseDate: DateTime(2026, 11, 14)),
            UpcomingRelease(sourceKey: 'googlebooks', externalId: 'next', kind: ReleaseKind.nextVolume, subject: 'Frieren', title: 'Frieren - Tome 15', releaseDate: DateTime(2027, 1, 8), isWished: true),
            UpcomingRelease(sourceKey: 'googlebooks', externalId: 'estimate:d:24', kind: ReleaseKind.nextVolume, subject: 'Dandadan', title: 'Dandadan 24', releaseDate: DateTime(2027, 1), datePrecision: ReleaseDatePrecision.month, isEstimated: true),
          ],
        ),
      ),
    );
    await tester.pumpWidget(releasesApp(cubit));
    expect(find.text('Dandadan · estimation : vers janvier 2027'), findsOneWidget);
    expect(find.text('Estimation'), findsOneWidget);
    expect(find.text('Novembre 2026'), findsOneWidget);
    expect(find.text('Janvier 2027'), findsOneWidget);
    expect(find.text('Next Wave'), findsOneWidget);
    expect(find.text('Dans tes envies · Frieren · 8 janv.'), findsOneWidget);
  });

  testWidgets('without anything to follow the screen explains how to get releases', (tester) async {
    final cubit = MockReleasesCubit();
    whenListen(
      cubit,
      const Stream<ReleasesState>.empty(),
      initialState: ReleasesState(isLoading: false, outlook: ReleaseOutlook(computedAt: DateTime(2026, 10, 28), followedSubjects: 0, releases: const [])),
    );
    await tester.pumpWidget(releasesApp(cubit));
    await tester.pump(const Duration(milliseconds: 100));
    expect(find.textContaining('catégorie de jeu de cartes'), findsOneWidget);
  });

  testWidgets('volumes already out come first, then each month, then releases known only by their year', (tester) async {
    final cubit = MockReleasesCubit();
    whenListen(
      cubit,
      const Stream<ReleasesState>.empty(),
      initialState: ReleasesState(
        isLoading: false,
        outlook: ReleaseOutlook(
          computedAt: DateTime(2026, 10, 28),
          followedSubjects: 2,
          releases: [
            UpcomingRelease(sourceKey: 'googlebooks', externalId: 'old', kind: ReleaseKind.nextVolume, subject: 'Berserk', title: 'Berserk - Tome 42', releaseDate: DateTime(2024, 3, 12)),
            UpcomingRelease(sourceKey: 'tcgdex', externalId: 'set:me06', kind: ReleaseKind.cardSet, subject: 'Pokémon', title: 'Next Wave', releaseDate: DateTime(2026, 11, 14)),
            UpcomingRelease(sourceKey: 'googlebooks', externalId: 'later', kind: ReleaseKind.nextVolume, subject: 'Frieren', title: 'Frieren - Tome 16', releaseDate: DateTime(2027), datePrecision: ReleaseDatePrecision.year),
          ],
        ),
      ),
    );
    await tester.pumpWidget(releasesApp(cubit));
    final headers = ['Déjà sortis', 'Novembre 2026', '2027'];
    final tops = [for (final header in headers) tester.getTopLeft(find.text(header)).dy];
    expect(tops, orderedEquals([...tops]..sort()));
    expect(find.text('Frieren · 2027'), findsOneWidget);
  });
}
