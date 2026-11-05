import 'package:akashic/layers/functional/Catalog/domain/entities/category_type.dart';
import 'package:akashic/layers/functional/Wishes/data/gateways/drift_wish_gateway.dart';
import 'package:akashic/layers/functional/Wishes/domain/entities/wish.dart';
import 'package:akashic/layers/functional/Wishes/domain/entities/wish_key.dart';
import 'package:akashic/layers/functional/Wishes/domain/use_cases/remove_wish.dart';
import 'package:akashic/layers/functional/Wishes/presentation/cubit/wishes_cubit.dart';
import 'package:akashic/layers/functional/Wishes/presentation/cubit/wishes_state.dart';
import 'package:akashic/layers/functional/Wishes/presentation/views/wishes_view.dart';
import 'package:akashic/layers/technical/Localization/app_localizations.dart';
import 'package:akashic/layers/technical/LocalDatabase/akashic_database.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockWishesCubit extends MockCubit<WishesState> implements WishesCubit {}

final blueTrain = Wish(
  id: 'w1',
  createdAt: DateTime(2026, 9, 12),
  draft: const WishDraft(categoryType: CategoryType.music, title: 'Blue Train', creator: 'John Coltrane', origin: WishOrigin.discovery),
);

final frierenFour = Wish(
  id: 'w2',
  createdAt: DateTime(2026, 10, 1),
  draft: const WishDraft(categoryType: CategoryType.manga, title: 'Frieren', origin: WishOrigin.missingVolume, key: WishKey(seriesId: 'frieren', volumeNumber: 4)),
);

Widget wishesApp(WishesCubit cubit) => MaterialApp(
      locale: const Locale('fr'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: BlocProvider<WishesCubit>.value(value: cubit, child: const WishesView()),
    );

void main() {
  testWidgets('the wishes tab lists wishes with their origin', (tester) async {
    final cubit = MockWishesCubit();
    when(() => cubit.state).thenReturn(WishesState(wishes: [frierenFour, blueTrain], isLoading: false));
    await tester.pumpWidget(wishesApp(cubit));
    expect(find.text('Frieren, tome 4'), findsOneWidget);
    expect(find.textContaining('Tome manquant'), findsOneWidget);
    expect(find.text('Blue Train'), findsOneWidget);
    expect(find.textContaining('Depuis une découverte'), findsOneWidget);
    await tester.tap(find.text('Mangas'));
    verify(() => cubit.filterBy(CategoryType.manga)).called(1);
  });

  testWidgets('an empty wish list invites to add some', (tester) async {
    final cubit = MockWishesCubit();
    when(() => cubit.state).thenReturn(const WishesState(isLoading: false));
    await tester.pumpWidget(wishesApp(cubit));
    expect(find.textContaining('Aucune envie'), findsOneWidget);
  });

  test('the filter follows the wishes that remain', () async {
    final database = AkashicDatabase.forTesting();
    final wishes = DriftWishGateway(database);
    await wishes.save(blueTrain);
    await wishes.save(Wish(id: 'w2', createdAt: DateTime(2026, 10, 1), draft: const WishDraft(categoryType: CategoryType.manga, title: 'Dandadan', origin: WishOrigin.search)));
    final cubit = WishesCubit(wishes, RemoveWish(wishes))..start();
    await expectLater(cubit.stream, emitsThrough(predicate<WishesState>((state) => state.wishes.length == 2)));
    cubit.filterBy(CategoryType.manga);
    expect(cubit.state.visibleWishes.single.id, 'w2');
    await cubit.remove('w2');
    await expectLater(cubit.stream, emitsThrough(predicate<WishesState>((state) => state.wishes.length == 1)));
    expect(cubit.state.typeFilter, isNull);
    expect(cubit.state.visibleWishes.single.id, 'w1');
    await cubit.close();
    await database.close();
  });

  testWidgets('touching a wish opens its page, from which it can be removed', (tester) async {
    final cubit = MockWishesCubit();
    when(() => cubit.state).thenReturn(WishesState(wishes: [blueTrain], isLoading: false));
    when(() => cubit.remove(any())).thenAnswer((_) async {});
    await tester.pumpWidget(wishesApp(cubit));
    await tester.tap(find.text('Blue Train'));
    await tester.pumpAndSettle();
    expect(find.text('John Coltrane'), findsWidgets);
    expect(find.text('Musique'), findsOneWidget);
    await tester.tap(find.text('Retirer de mes envies'));
    await tester.pumpAndSettle();
    verify(() => cubit.remove('w1')).called(1);
    expect(find.text('Retirer de mes envies'), findsNothing);
  });
}
