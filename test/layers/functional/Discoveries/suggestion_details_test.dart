import 'package:akashic/layers/functional/Catalog/domain/entities/category_type.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/collection_item.dart';
import 'package:akashic/layers/functional/Details/domain/entities/item_details.dart';
import 'package:akashic/layers/functional/Details/domain/gateways/details_source.dart';
import 'package:akashic/layers/functional/Details/domain/gateways/details_store.dart';
import 'package:akashic/layers/functional/Details/domain/use_cases/fetch_item_details.dart';
import 'package:akashic/layers/functional/Discoveries/domain/entities/suggestion.dart';
import 'package:akashic/layers/functional/Discoveries/domain/use_cases/describe_suggestion.dart';
import 'package:akashic/layers/functional/Discoveries/presentation/cubit/discoveries_cubit.dart';
import 'package:akashic/layers/functional/Discoveries/presentation/cubit/discoveries_state.dart';
import 'package:akashic/layers/functional/Discoveries/presentation/views/discoveries_view.dart';
import 'package:akashic/layers/technical/Localization/app_localizations.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockDiscoveriesCubit extends MockCubit<DiscoveriesState> implements DiscoveriesCubit {}

class MockDetailsStore extends Mock implements DetailsStore {}

class SynopsisSource implements DetailsSource {
  final List<CollectionItem> asked = [];

  @override
  bool supports(CollectionItem item) => item.sourceKey == 'tmdb';

  @override
  Future<List<DetailSection>> fetch(CollectionItem item, {required String languageCode, String? editionId}) async {
    asked.add(item);
    return const [TextSection(kind: TextKind.summary, text: 'Un hacker découvre la Matrice.', sourceLabel: 'TMDB')];
  }
}

const matrix = Suggestion(sourceKey: 'tmdb', externalWorkId: '603', title: 'Matrix', creator: 'Wachowski', year: 1999);

final moviesGroup = Discoveries(
  computedAt: DateTime(2026, 10, 28),
  seedCount: 1,
  groups: const [SuggestionGroup(seedItemId: 'blade-runner', seedTitle: 'Blade Runner', categoryType: CategoryType.films, suggestions: [matrix])],
);

void main() {
  test('a suggestion is described by the source it came from, without storing anything', () async {
    final store = MockDetailsStore();
    final source = SynopsisSource();
    final describe = DescribeSuggestion(FetchItemDetails([source], store));
    expect(describe.canDescribe(matrix), isTrue);
    final details = await describe(matrix, languageCode: 'fr');
    expect(details.sections.single, isA<TextSection>());
    expect(source.asked.single.externalWorkId, '603');
    expect(source.asked.single.creator, 'Wachowski');
    verifyZeroInteractions(store);
  });

  testWidgets('touching a suggestion opens its details and lets it be wished from there', (tester) async {
    final cubit = MockDiscoveriesCubit();
    when(() => cubit.state).thenReturn(DiscoveriesState(discoveries: moviesGroup, isLoading: false));
    registerFallbackValue(moviesGroup.groups.single);
    registerFallbackValue(matrix);
    when(() => cubit.wish(any(), any())).thenAnswer((_) async {});
    await tester.pumpWidget(MaterialApp(
      locale: const Locale('fr'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: BlocProvider<DiscoveriesCubit>.value(
        value: cubit,
        child: DiscoveriesView(describeSuggestion: DescribeSuggestion(FetchItemDetails([SynopsisSource()], MockDetailsStore()))),
      ),
    ));
    await tester.tap(find.text('Matrix'));
    await tester.pumpAndSettle();
    expect(find.text('Wachowski'), findsOneWidget);
    expect(find.text('1999'), findsOneWidget);
    expect(find.text('Un hacker découvre la Matrice.'), findsOneWidget);
    await tester.tap(find.text('Ajouter à mes envies'));
    verify(() => cubit.wish(moviesGroup.groups.single, matrix)).called(1);
  });
}
