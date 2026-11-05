import 'package:akashic/layers/functional/Catalog/domain/entities/category_type.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/localized_titles.dart';
import 'package:akashic/layers/functional/Collection/presentation/cubit/item_editor_cubit.dart';
import 'package:akashic/layers/functional/Collection/presentation/cubit/item_editor_state.dart';
import 'package:akashic/layers/functional/Collection/presentation/views/item_editor_view.dart';
import 'package:akashic/layers/functional/Lookup/domain/entities/source_match.dart';
import 'package:akashic/layers/technical/Localization/app_localizations.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockItemEditorCubit extends MockCubit<ItemEditorState> implements ItemEditorCubit {}

const blueTrain = SourceMatch(
  sourceKey: 'musicbrainz',
  externalWorkId: 'blue-train',
  titles: LocalizedTitles(byLanguage: {'en': 'Blue Train'}),
  suggestedType: CategoryType.music,
);

void main() {
  setUpAll(() => registerFallbackValue(blueTrain));

  testWidgets('a search result can go to the wishes instead of the collection', (tester) async {
    final cubit = MockItemEditorCubit();
    when(() => cubit.state).thenReturn(const ItemEditorState(
      categoryId: 'jazz',
      categoryType: CategoryType.music,
      titleLanguages: ['fr', 'en'],
      canSearchOnline: true,
      searchResults: [blueTrain],
    ));
    final wished = <SourceMatch>[];
    await tester.pumpWidget(MaterialApp(
      locale: const Locale('fr'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: BlocProvider<ItemEditorCubit>.value(
        value: cubit,
        child: ItemEditorView(categoryName: 'Jazz', onWishMatch: (match) async => wished.add(match)),
      ),
    ));
    await tester.tap(find.byTooltip('Ajouter à mes envies'));
    await tester.pump();
    expect(wished, [blueTrain]);
    expect(find.text('Ajouté à tes envies.'), findsOneWidget);
    verifyNever(() => cubit.applyMatch(any()));
  });
}
