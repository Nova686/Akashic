import 'package:akashic/layers/functional/Catalog/domain/entities/category_type.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/collection_item.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/localized_titles.dart';
import 'package:akashic/layers/functional/Discoveries/data/gateways/drift_discovery_cache.dart';
import 'package:akashic/layers/functional/Discoveries/data/gateways/drift_dismissed_suggestion_gateway.dart';
import 'package:akashic/layers/functional/Discoveries/domain/entities/suggestion.dart';
import 'package:akashic/layers/functional/Discoveries/domain/use_cases/build_discoveries.dart';
import 'package:akashic/layers/functional/Discoveries/domain/use_cases/dismiss_suggestion.dart';
import 'package:akashic/layers/functional/Discoveries/presentation/cubit/discoveries_cubit.dart';
import 'package:akashic/layers/functional/Discoveries/presentation/cubit/discoveries_state.dart';
import 'package:akashic/layers/functional/Discoveries/presentation/views/discoveries_view.dart';
import 'package:akashic/layers/functional/Discoveries/presentation/widgets/suggestion_card.dart';
import 'package:akashic/layers/functional/Settings/domain/entities/preferred_languages.dart';
import 'package:akashic/layers/functional/Wishes/data/gateways/drift_wish_gateway.dart';
import 'package:akashic/layers/functional/Wishes/domain/entities/wish.dart';
import 'package:akashic/layers/functional/Wishes/domain/use_cases/add_wish.dart';
import 'package:akashic/layers/technical/Localization/app_localizations.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../Collection/collection_harness.dart';
import 'build_discoveries_test.dart' show ScriptedSource, blueTrain, giantSteps;

class MockDiscoveriesCubit extends MockCubit<DiscoveriesState> implements DiscoveriesCubit {}

final keptDiscoveries = Discoveries(
  computedAt: DateTime(2026, 10, 20),
  seedCount: 1,
  groups: const [SuggestionGroup(seedItemId: 'kob', seedTitle: 'Kind of Blue', categoryType: CategoryType.music, suggestions: [blueTrain, giantSteps])],
);

Widget discoveriesApp(DiscoveriesCubit cubit) => MaterialApp(
      locale: const Locale('fr'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: BlocProvider<DiscoveriesCubit>.value(value: cubit, child: const DiscoveriesView()),
    );

void main() {
  late CollectionHarness harness;
  late DriftWishGateway wishes;
  late ScriptedSource source;
  late DiscoveriesCubit cubit;

  setUpAll(() => registerFallbackValue(blueTrain));

  setUp(() async {
    harness = CollectionHarness();
    wishes = DriftWishGateway(harness.database);
    final vinyls = await harness.vinyls();
    await harness.collection.saveItem(CollectionItem(id: 'kob', categoryId: vinyls.id, titles: const LocalizedTitles(byLanguage: {'en': 'Kind of Blue'}), creator: 'Miles Davis'));
    source = ScriptedSource('lastfm', [blueTrain, giantSteps]);
    final cache = DriftDiscoveryCache(harness.database);
    final dismissed = DriftDismissedSuggestionGateway(harness.database);
    cubit = DiscoveriesCubit(
      buildDiscoveries: BuildDiscoveries([source], harness.collection, harness.categories, dismissed, cache, now: () => DateTime(2026, 10, 27)),
      dismissSuggestion: DismissSuggestion(dismissed, cache),
      wishes: wishes,
      addWish: AddWish(wishes),
      languageCode: () => 'fr',
      preferredLanguages: () async => PreferredLanguages.defaults,
      now: () => DateTime(2026, 10, 27),
    );
  });

  tearDown(() async {
    await cubit.close();
    await harness.database.close();
  });

  test('the tab shows groups from the cache when offline', () async {
    await DriftDiscoveryCache(harness.database).write(keptDiscoveries);
    source.isDown = true;
    await cubit.start();
    await cubit.refresh();
    expect(cubit.state.isOffline, isTrue);
    expect(cubit.state.discoveries?.groups.single.suggestions, [blueTrain, giantSteps]);
    expect(source.askedFor, isNotEmpty);
  });

  test('recent kept discoveries are shown without asking the sources', () async {
    await DriftDiscoveryCache(harness.database).write(Discoveries(groups: keptDiscoveries.groups, computedAt: DateTime(2026, 10, 25), seedCount: 1));
    await cubit.start();
    expect(source.askedFor, isEmpty);
    expect(cubit.state.discoveries?.groups, hasLength(1));
  });

  test('dismissing removes the card', () async {
    await cubit.start();
    await cubit.dismiss(blueTrain);
    expect(cubit.state.discoveries?.groups.single.suggestions, [giantSteps]);
    await cubit.refresh();
    expect(cubit.state.discoveries?.groups.single.suggestions, [giantSteps]);
  });

  test('adding a wish marks the card', () async {
    await cubit.start();
    final group = cubit.state.discoveries!.groups.single;
    await cubit.wish(group, blueTrain);
    expect(cubit.state.isWished(blueTrain), isTrue);
    final stored = (await wishes.all()).single;
    expect(stored.origin, WishOrigin.discovery);
    expect(stored.categoryType, CategoryType.music);
    expect(stored.key.externalWorkId, blueTrain.externalWorkId);
  });

  testWidgets('the tab shows each group, the offline notice and the card actions', (tester) async {
    final mockCubit = MockDiscoveriesCubit();
    when(() => mockCubit.state).thenReturn(DiscoveriesState(
      discoveries: keptDiscoveries,
      wishedIdentities: {giantSteps.sourceIdentity},
      isLoading: false,
      isOffline: true,
    ));
    when(() => mockCubit.dismiss(any())).thenAnswer((_) async {});
    await tester.pumpWidget(discoveriesApp(mockCubit));
    expect(find.text('Parce que tu as Kind of Blue'), findsOneWidget);
    expect(find.text('Pas de réseau : voici les dernières découvertes gardées.'), findsOneWidget);
    expect(find.text('Calculées le 20 oct. 2026'), findsOneWidget);
    expect(find.text('En envie'), findsOneWidget);
    expect(find.text('+ Envie'), findsOneWidget);
    await tester.tap(find.byTooltip('Pas pour moi').first);
    verify(() => mockCubit.dismiss(blueTrain)).called(1);
  });

  testWidgets('the arrow of a row opens every suggestion of that row', (tester) async {
    final mockCubit = MockDiscoveriesCubit();
    when(() => mockCubit.state).thenReturn(DiscoveriesState(discoveries: keptDiscoveries, isLoading: false));
    await tester.pumpWidget(discoveriesApp(mockCubit));
    await tester.tap(find.byTooltip('Voir tout'));
    await tester.pumpAndSettle();
    expect(find.byType(GridView), findsOneWidget);
    expect(find.descendant(of: find.byType(GridView), matching: find.byType(SuggestionCard)), findsNWidgets(2));
  });

  testWidgets('without anything to start from, the tab explains what to do', (tester) async {
    final mockCubit = MockDiscoveriesCubit();
    when(() => mockCubit.state).thenReturn(DiscoveriesState(discoveries: Discoveries(groups: const [], computedAt: DateTime(2026), seedCount: 0), isLoading: false));
    await tester.pumpWidget(discoveriesApp(mockCubit));
    expect(find.textContaining('Ajoute des objets trouvés en ligne'), findsOneWidget);
  });

  testWidgets('a suggestion card fits its carousel even with large text', (tester) async {
    await tester.pumpWidget(MaterialApp(
      locale: const Locale('fr'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: MediaQuery(
        data: const MediaQueryData(textScaler: TextScaler.linear(1.5)),
        child: Scaffold(
          body: SizedBox(
            height: 268,
            child: SuggestionCard(
              suggestion: const Suggestion(sourceKey: 'lastfm', externalWorkId: 'long', title: 'A very long album title that wraps on two lines', creator: 'Someone'),
              isWished: false,
              onWish: () {},
              onDismiss: () {},
            ),
          ),
        ),
      ),
    ));
    expect(tester.takeException(), isNull);
  });
}
