import 'dart:async';

import 'package:akashic/layers/functional/Catalog/domain/entities/category.dart';
import 'package:akashic/layers/functional/Catalog/domain/entities/category_type.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/card_kind.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/collection_item.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/deck_card.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/localized_titles.dart';
import 'package:akashic/layers/functional/Collection/presentation/cubit/item_detail_cubit.dart';
import 'package:akashic/layers/functional/Collection/presentation/cubit/item_detail_state.dart';
import 'package:akashic/layers/functional/Collection/presentation/views/item_detail_view.dart';
import 'package:akashic/layers/technical/Localization/app_localizations.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockItemDetailCubit extends MockCubit<ItemDetailState> implements ItemDetailCubit {}

const magic = Category(id: 'magic', name: 'Magic', colorValue: 0xFF7FA8FF, type: CategoryType.cards, conditionParts: ['Objet'], position: 0);

void main() {
  testWidgets('a deck page shows its cards under the rest, keeps editing, and drops progress and the learn more tab', (tester) async {
    final detail = MockItemDetailCubit();
    when(() => detail.canManagePhotos).thenReturn(false);
    when(() => detail.state).thenReturn(const ItemDetailState(
      item: CollectionItem(id: 'growing', categoryId: 'magic', titles: LocalizedTitles(byLanguage: {'en': 'Growing Threat'}), cardKind: CardKind.deck),
      category: magic,
      isLoading: false,
    ));
    final cards = StreamController<List<DeckCard>>();
    addTearDown(cards.close);
    final editedDecks = <String>[];
    await tester.pumpWidget(MaterialApp(
      locale: const Locale('fr'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: BlocProvider<ItemDetailCubit>.value(
        value: detail,
        child: ItemDetailView(onEditCopy: (copy, parts) {}, onEditDeck: editedDecks.add, deckCardsOf: (_) => cards.stream),
      ),
    ));
    cards.add(const [
      DeckCard(id: '1', itemId: 'growing', name: 'Brimaz, Blight of Oreskos', quantity: 1),
      DeckCard(id: '2', itemId: 'growing', name: 'Plains', quantity: 12),
    ]);
    await tester.pump();
    expect(find.byType(TabBar), findsNothing);
    expect(find.text('En savoir plus'), findsNothing);
    expect(find.text('Progression'), findsNothing);
    expect(find.text('Voir les cartes'), findsNothing);
    await tester.scrollUntilVisible(find.text('×12'), 200, scrollable: find.byType(Scrollable).first);
    expect(find.text('Brimaz, Blight of Oreskos'), findsOneWidget);
    await tester.scrollUntilVisible(find.text('Modifier le deck'), -200, scrollable: find.byType(Scrollable).first);
    await tester.tap(find.text('Modifier le deck'));
    expect(editedDecks, ['growing']);
  });
}
