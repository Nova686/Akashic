import 'package:akashic/layers/technical/Theme/akashic_typography.dart';
import 'package:akashic/layers/functional/Catalog/domain/entities/category.dart';
import 'package:akashic/layers/functional/Catalog/domain/entities/category_type.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/collection_item.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/localized_titles.dart';
import 'package:akashic/layers/functional/Collection/presentation/cubit/item_detail_cubit.dart';
import 'package:akashic/layers/functional/Collection/presentation/cubit/item_detail_state.dart';
import 'package:akashic/layers/functional/Collection/presentation/cubit/item_editor_cubit.dart';
import 'package:akashic/layers/functional/Collection/presentation/cubit/item_editor_state.dart';
import 'package:akashic/layers/functional/Collection/presentation/views/item_detail_view.dart';
import 'package:akashic/layers/functional/Collection/presentation/views/item_editor_view.dart';
import 'package:akashic/layers/technical/Localization/app_localizations.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockItemDetailCubit extends MockCubit<ItemDetailState> implements ItemDetailCubit {}

class MockItemEditorCubit extends MockCubit<ItemEditorState> implements ItemEditorCubit {}

Widget host(Widget child) => MaterialApp(
      locale: const Locale('fr'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: child,
    );

void main() {
  testWidgets('a volume number in the detail title is drawn in the numeral face', (tester) async {
    final cubit = MockItemDetailCubit();
    when(() => cubit.canManagePhotos).thenReturn(false);
    when(() => cubit.state).thenReturn(const ItemDetailState(
      item: CollectionItem(id: 'f4', categoryId: 'mangas', seriesId: 'frieren', volumeNumber: 4, titles: LocalizedTitles(byLanguage: {'fr': 'Frieren'})),
      category: Category(id: 'mangas', name: 'Mangas', colorValue: 0, type: CategoryType.manga, conditionParts: ['Objet'], position: 0),
      isLoading: false,
    ));
    await tester.pumpWidget(host(BlocProvider<ItemDetailCubit>.value(value: cubit, child: ItemDetailView(onEditCopy: (copy, parts) {}))));
    final spans = <TextSpan>[];
    for (final richText in tester.widgetList<RichText>(find.byType(RichText))) {
      richText.text.visitChildren((span) {
        if (span is TextSpan) {
          spans.add(span);
        }
        return true;
      });
    }
    final numberSpan = spans.firstWhere((span) => span.text == '4');
    expect(numberSpan.style?.fontFamily, AkashicTypography.numeral().fontFamily);
  });

  testWidgets('editor fields show the values already in the state', (tester) async {
    final cubit = MockItemEditorCubit();
    when(() => cubit.state).thenReturn(const ItemEditorState(
      categoryId: 'books',
      categoryType: CategoryType.books,
      titleLanguages: ['fr', 'en'],
      creator: 'J. R. R. Tolkien',
      yearText: '1937',
      publisher: 'Allen & Unwin',
    ));
    await tester.pumpWidget(host(BlocProvider<ItemEditorCubit>.value(value: cubit, child: const ItemEditorView(categoryName: 'Livres'))));
    await tester.scrollUntilVisible(find.text('Allen & Unwin'), 200, scrollable: find.byType(Scrollable).first);
    expect(find.text('J. R. R. Tolkien'), findsOneWidget);
    expect(find.text('1937'), findsOneWidget);
    expect(find.text('Allen & Unwin'), findsOneWidget);
  });
}
