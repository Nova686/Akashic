import 'package:akashic/layers/functional/Catalog/domain/entities/category_type.dart';
import 'package:akashic/layers/functional/Discoveries/domain/entities/suggestion.dart';
import 'package:akashic/layers/functional/Discoveries/presentation/cubit/discoveries_state.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const celeste = Suggestion(sourceKey: 'igdb', externalWorkId: '1', title: 'Celeste', creator: 'Maddy Makes Games', year: 2018);
  const balatro = Suggestion(sourceKey: 'igdb', externalWorkId: '2', title: 'Balatro', creator: 'LocalThunk', year: 2024);
  const blueTrain = Suggestion(sourceKey: 'discogs', externalWorkId: '3', title: 'Blue Train', creator: 'John Coltrane', year: 1957);
  final discoveries = Discoveries(
    computedAt: DateTime(2026, 11, 2),
    seedCount: 2,
    groups: const [
      SuggestionGroup(seedItemId: 'hades', seedTitle: 'Hades', categoryType: CategoryType.videoGames, suggestions: [celeste, balatro]),
      SuggestionGroup(seedItemId: 'kob', seedTitle: 'Kind of Blue', categoryType: CategoryType.music, suggestions: [blueTrain]),
    ],
  );
  List<String> titlesOf(DiscoveriesState state) => [for (final group in state.visibleGroups) for (final suggestion in group.suggestions) suggestion.title];

  test('discoveries are filtered by text, wishes and recent years', () {
    final state = DiscoveriesState(discoveries: discoveries, isLoading: false, wishedIdentities: {celeste.sourceIdentity});
    expect(titlesOf(state), ['Celeste', 'Balatro', 'Blue Train']);
    expect(titlesOf(state.copyWith(query: 'coltrane')), ['Blue Train']);
    expect(titlesOf(state.copyWith(query: 'hades')), ['Celeste', 'Balatro']);
    expect(titlesOf(state.copyWith(hidesWished: true)), ['Balatro', 'Blue Train']);
    expect(titlesOf(state.copyWith(recentOnly: true)), ['Balatro']);
    expect(titlesOf(state.copyWith(typeFilter: () => CategoryType.music, query: 'celeste')), isEmpty);
    expect(state.isFiltered, isFalse);
    expect(state.copyWith(recentOnly: true).isFiltered, isTrue);
  });
}
