import 'package:akashic/layers/functional/Catalog/domain/entities/category.dart';
import 'package:akashic/layers/functional/Catalog/domain/entities/category_type.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/collection_item.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/localized_titles.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/shelf_group.dart';
import 'package:akashic/layers/functional/Collection/presentation/cubit/item_detail_cubit.dart';
import 'package:akashic/layers/functional/Collection/presentation/cubit/item_detail_state.dart';
import 'package:akashic/layers/functional/Collection/presentation/views/item_detail_view.dart';
import 'package:akashic/layers/functional/Collection/presentation/widgets/item_spine.dart';
import 'package:akashic/layers/functional/Collection/presentation/widgets/shelf_row.dart';
import 'package:akashic/layers/functional/Collection/presentation/widgets/spine_text_color.dart';
import 'package:akashic/layers/functional/Collection/presentation/widgets/star_rating.dart';
import 'package:akashic/layers/technical/Localization/app_localizations.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockItemDetailCubit extends MockCubit<ItemDetailState> implements ItemDetailCubit {}

Widget localized(Widget child) => MaterialApp(
      locale: const Locale('fr'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(body: child),
    );

void main() {
  test('spine text keeps a readable contrast whatever the spine colour', () {
    for (final value in [0xFF7FA8FF, 0xFFB7A6FF, 0xFF7C66E8, 0xFF5ED1C3, 0xFFFF7A8A, 0xFF808080, 0xFF15122B, 0xFFF2C46B]) {
      final spine = Color(value);
      expect(contrastBetween(spine, textColorOnSpine(spine)), greaterThanOrEqualTo(4.5), reason: value.toRadixString(16));
    }
  });

  testWidgets('a spine on the home shelf is read with its title and volume', (tester) async {
    final semantics = tester.ensureSemantics();
    await tester.pumpWidget(localized(ShelfRow(
      groups: [
        ShelfGroup(id: 'frieren', label: 'Frieren', isSeries: true, ownedCount: 1, entries: [
          ShelfItem(const CollectionItem(id: 'f3', categoryId: 'mangas', volumeNumber: 3, titles: LocalizedTitles(byLanguage: {'fr': 'Frieren'}))),
          const ShelfMissingVolume(seriesId: 'frieren', volumeNumber: 4),
        ]),
      ],
      type: CategoryType.manga,
      size: SpineSize.compact,
      categoryColorValue: 0xFFFF7A8A,
      collapsedSeriesIds: const {},
      onToggleSeries: (_) {},
      onOpenItem: (_) {},
    )));
    expect(find.bySemanticsLabel('Frieren, tome 3'), findsOneWidget);
    expect(find.bySemanticsLabel('Tome 4 manquant'), findsOneWidget);
    semantics.dispose();
  });

  testWidgets('the rating is one adjustable control that says its value', (tester) async {
    final semantics = tester.ensureSemantics();
    int? rating = 3;
    await tester.pumpWidget(localized(StatefulBuilder(builder: (context, setState) => StarRating(rating: rating, onChanged: (value) => setState(() => rating = value)))));
    final node = tester.getSemantics(find.byType(StarRating));
    expect(node.label, 'Note');
    expect(node.value, '3 sur 5');
    expect(tester.getSize(find.byType(InkResponse).first).width, greaterThanOrEqualTo(48));
    semantics.dispose();
  });

  testWidgets('every tappable control of an item page has a name', (tester) async {
    final semantics = tester.ensureSemantics();
    final detail = MockItemDetailCubit();
    when(() => detail.canManagePhotos).thenReturn(false);
    when(() => detail.state).thenReturn(const ItemDetailState(
      item: CollectionItem(id: 'kob', categoryId: 'vinyls', titles: LocalizedTitles(byLanguage: {'en': 'Kind of Blue'}), rating: 4),
      category: Category(id: 'vinyls', name: 'Vinyles', colorValue: 0xFF7FA8FF, type: CategoryType.music, conditionParts: ['Disque'], position: 0),
      isLoading: false,
    ));
    await tester.pumpWidget(MaterialApp(
      locale: const Locale('fr'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: BlocProvider<ItemDetailCubit>.value(value: detail, child: ItemDetailView(onEditCopy: (copy, parts) {}, onEditItem: (_) {})),
    ));
    await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
    semantics.dispose();
  });
}
